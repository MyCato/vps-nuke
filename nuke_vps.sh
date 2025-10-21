#!/usr/bin/env bash
# nuke_vps.sh
# WARNING: Irreversible. Use only on machines you own and intend to destroy.
# Modes:
#   --files-only        : remove files, logs, histories, SSH keys, users, wipe free space
#   --disk-wipe DEVICE  : overwrite a block device (e.g. /dev/vda) with random data then zero
#   --full              : runs files-only then attempts disk-wipe on common device names
# Optional:
#   --force             : don't prompt for confirmation
# Example:
#   sudo ./nuke_vps.sh --files-only
#   sudo ./nuke_vps.sh --disk-wipe /dev/vda --force
set -euo pipefail
MODE=""
DEVICE=""
FORCE=0
# Better argument parsing to avoid shift issues
while [[ $# -gt 0 ]]; do
  case "$1" in
    --files-only) MODE="files-only"; shift ;;
    --disk-wipe) 
      MODE="disk-wipe"
      shift
      if [[ $# -gt 0 && ! "$1" =~ ^-- ]]; then
        DEVICE="$1"
        shift
      else
        echo "Error: --disk-wipe requires a device argument"
        exit 2
      fi
      ;;
    --full) MODE="full"; shift ;;
    --force) FORCE=1; shift ;;
    *) 
      # allow position-style for disk device
      if [[ "$MODE" == "disk-wipe" && -z "$DEVICE" ]]; then
        DEVICE="$1"
        shift
      else
        echo "Unknown arg: $1"
        exit 2
      fi
    ;;
  esac
done
if [[ -z "$MODE" ]]; then
  echo "Usage: $0 --files-only | --disk-wipe <DEVICE> | --full [--force]"
  exit 2
fi
if [[ $EUID -ne 0 ]]; then
  echo "This must be run as root (sudo). Aborting."
  exit 1
fi
confirm() {
  if [[ $FORCE -eq 1 ]]; then
    return 0
  fi
  echo
  echo "***** FINAL WARNING *****"
  echo "You are about to perform '$MODE' on this machine."
  echo "THIS WILL DESTROY DATA IRREVERSIBLY on the target(s)."
  read -p "Type 'destroy' to proceed, anything else to abort: " ans
  if [[ "$ans" != "destroy" ]]; then
    echo "Aborted by user."
    exit 1
  fi
}
log() { echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] $*"; }
# ---- Functions: safe destructive steps for files-only mode ----
files_only() {
  log "Starting FILES-ONLY destruction."
  log "1) Stop services to reduce logging and locks (may fail silently)."
  # best-effort stop known loggers
  systemctl stop rsyslog.service 2>/dev/null || true
  systemctl stop syslog.service 2>/dev/null || true
  systemctl stop systemd-journald.service 2>/dev/null || true
  systemctl stop auditd.service 2>/dev/null || true
  log "2) Clear shell history for all users."
  # Bash history
  for home in /root /home/*; do
    if [[ -d "$home" ]]; then
      rm -f "$home/.bash_history" "$home/.zsh_history" "$home/.mysql_history" "$home/.mongo_history" "$home/.psql_history" 2>/dev/null || true
      # unset HISTFILE for any running shells (best-effort)
      # truncate any existing history files
      find "$home" -maxdepth 1 -type f -name ".*history" -exec sh -c 'truncate -s 0 "$1" || true' _ {} \; 2>/dev/null || true
    fi
  done
  log "3) Remove SSH keys and authorized_keys."
  rm -f /root/.ssh/authorized_keys /root/.ssh/id_* 2>/dev/null || true
  rm -rf /etc/ssh/*key* /etc/ssh/ssh_host_* 2>/dev/null || true
  find /home -type f -name "authorized_keys" -exec shred -u {} \; 2>/dev/null || true
  log "4) Clear package caches and temp directories."
  # apt/dnf/pacman caches
  apt-get clean 2>/dev/null || true
  dnf clean all 2>/dev/null || true
  yum clean all 2>/dev/null || true
  pacman -Scc --noconfirm 2>/dev/null || true
  rm -rf /var/cache/* /var/tmp/* /tmp/* /run/shm/* 2>/dev/null || true
  log "5) Stop and clear journal logs (systemd)."
  if command -v journalctl >/dev/null 2>&1; then
    journalctl --rotate 2>/dev/null || true
    # vacuum to essentially nothing
    journalctl --vacuum-size=1K 2>/dev/null || true
    journalctl --vacuum-time=1s 2>/dev/null || true
  fi
  rm -rf /var/log/journal/* 2>/dev/null || true
  log "6) Truncate or remove remaining logs."
  # Try to truncate common logs
  for f in /var/log/*.log /var/log/*/*.log /var/log/*; do
    if [[ -f "$f" ]]; then
      : > "$f" 2>/dev/null || rm -f "$f" 2>/dev/null || true
    fi
  done
  rm -rf /var/log/* 2>/dev/null || true
  log "7) Remove user data and home directories."
  rm -rf /home/* /root/* /srv/* /opt/* 2>/dev/null || true
  log "8) Remove system user accounts and shadow file entries (destructive)."
  # overwrite passwd/shadow/gshadow/group files to make logins impossible
  for f in /etc/passwd /etc/shadow /etc/group /etc/gshadow; do
    if [[ -f "$f" ]]; then
      shred -u "$f" 2>/dev/null || echo -n > "$f" || true
    fi
  done
  log "9) Remove cloud and metadata files / keys typically present."
  rm -rf /etc/cloud /var/lib/cloud /root/.ssh /etc/ssh 2>/dev/null || true
  log "9a) Remove additional system configurations and certificates."
  rm -rf /etc/ssl/ /etc/pki/ /etc/letsencrypt/ /etc/systemd/ 2>/dev/null || true
  rm -rf /etc/sudoers* /etc/network/ /etc/netplan/ /etc/NetworkManager/ 2>/dev/null || true
  log "9b) Remove cron jobs and scheduled tasks."
  rm -rf /var/spool/cron/ /etc/cron.d/ /etc/crontab /etc/cron.*/ 2>/dev/null || true
  log "9c) Remove application and database data."
  rm -rf /var/lib/mysql/ /var/lib/postgresql/ /var/lib/redis/ 2>/dev/null || true
  rm -rf /var/www/ /etc/nginx/ /etc/apache2/ /etc/httpd/ 2>/dev/null || true
  rm -rf /var/lib/docker/ /var/lib/containerd/ /var/lib/kubernetes/ 2>/dev/null || true
  log "9d) Remove mail data and kernel modules."
  rm -rf /var/mail/ /var/spool/mail/ /lib/modules/ 2>/dev/null || true
  log "9e) Clear additional user data and browser histories."
  find /home /root -type f -name ".recently-used*" -exec shred -u {} \; 2>/dev/null || true
  find /home /root -type d -name ".mozilla" -exec rm -rf {} \; 2>/dev/null || true
  find /home /root -type d -name ".chrome*" -exec rm -rf {} \; 2>/dev/null || true
  find /home /root -type d -name ".config/google-chrome*" -exec rm -rf {} \; 2>/dev/null || true
  find /home /root -type f -name ".bash_completion*" -exec shred -u {} \; 2>/dev/null || true
  log "9f) Remove Git repositories and version control data."
  find /home /root /opt /srv -type d -name ".git" -exec rm -rf {} \; 2>/dev/null || true
  find /home /root /opt /srv -type d -name ".svn" -exec rm -rf {} \; 2>/dev/null || true
  log "10) Clear package lists, databases, and keys."
  rm -rf /var/lib/dpkg /var/lib/apt/lists/* /var/cache/apt/* 2>/dev/null || true
  rm -rf /var/lib/rpm /var/lib/yum /var/lib/dnf 2>/dev/null || true
  log "10a) Clear memory-related files and kernel data."
  rm -rf /proc/kcore /sys/kernel/ 2>/dev/null || true
  echo 3 > /proc/sys/vm/drop_caches 2>/dev/null || true
  log "10b) Remove hibernation and additional swap files."
  rm -f /hiberfil.sys /swapfile 2>/dev/null || true
  log "11) Overwrite free space to reduce recoverability (may take time)."
  # create a large file of zeros then delete, to wipe free space
  if mount | grep -q ' / '; then
    log " - Overwriting free space in / (this may take minutes)."
    dd if=/dev/urandom of=/zerofill.tmp bs=1M status=progress conv=fdatasync 2>/dev/null || true
    sync || true
    shred -u /zerofill.tmp 2>/dev/null || rm -f /zerofill.tmp 2>/dev/null || true
  fi
  log "12) Swap wipe (best-effort)."
  # turn off swap and shred swap partitions/files
  swapoff -a 2>/dev/null || true
  for s in $(cat /proc/swaps 2>/dev/null | tail -n +2 | awk '{print $1}'); do
    log " - Shredding swap device/file: $s"
    if [[ -b "$s" ]] || [[ -f "$s" ]]; then
      dd if=/dev/urandom of="$s" bs=1M status=progress conv=fdatasync 2>/dev/null || true
      shred -u "$s" 2>/dev/null || rm -f "$s" 2>/dev/null || true
    fi
  done
  log "13) Unmount non-essential mounts and remove mounts from fstab (best-effort)."
  # remove entries from /etc/fstab
  if [[ -f /etc/fstab ]]; then
    : > /etc/fstab 2>/dev/null || true
  fi
  log "14) Attempt to remove package manager binaries (to hinder recovery)."
  rm -f /usr/bin/apt /usr/bin/apt-get /usr/bin/dnf /usr/bin/yum /usr/bin/pacman 2>/dev/null || true
  log "FILES-ONLY destruction completed (best-effort)."
  log "This machine may still be recoverable depending on provider snapshots and how the disks are implemented."
  echo "Consider terminating the instance in your provider control panel or requesting deletion of snapshots."
}
# ---- Function: overwrite a block device (very destructive) ----
disk_wipe() {
  dev="$1"
  if [[ -z "$dev" ]]; then
    echo "No device specified for disk_wipe."
    exit 2
  fi
  if [[ ! -b "$dev" ]]; then
    echo "Device $dev does not appear to be a block device. Aborting device wipe."
    exit 1
  fi
  log "STARTING DISK WIPE ON $dev"
  log "This will write random data across $dev, then zero it. This may take a long time and is IRREVERSIBLE."
  # attempt to unmount any partitions on the device
  for m in $(lsblk -ln -o MOUNTPOINT "$dev" 2>/dev/null | grep -v '^$' || true); do
    log "Unmounting: $m"
    umount "$m" 2>/dev/null || true
  done
  # Step 1: overwrite with random data (if /dev/urandom is available)
  if [[ -w "$dev" ]]; then
    log "Overwriting $dev with /dev/urandom (this may take many minutes)."
    # use pv if available for progress, else dd
    if command -v pv >/dev/null 2>&1; then
      pv /dev/urandom > "$dev" 2>/dev/null || true
    else
      dd if=/dev/urandom of="$dev" bs=1M status=progress conv=fdatasync 2>/dev/null || true
    fi
    sync || true
  else
    log "No write permission to $dev (or device not writable). Aborting device overwrite."
    return 1
  fi
  # Step 2: write zeros across device
  log "Now writing zeros across $dev."
  dd if=/dev/zero of="$dev" bs=1M status=progress conv=fdatasync 2>/dev/null || true
  sync || true
  # Step 3: wipe filesystem signatures
  log "Dropping filesystem signatures (wipefs)."
  if command -v wipefs >/dev/null 2>&1; then
    wipefs -a "$dev" 2>/dev/null || true
  fi
  log "Disk wipe on $dev completed (best-effort)."
}
# ---- Main flow ----
confirm
case "$MODE" in
  files-only)
    files_only
    ;;
  disk-wipe)
    if [[ -z "$DEVICE" ]]; then
      echo "You requested disk-wipe but did not supply a device."
      exit 2
    fi
    files_only || true
    disk_wipe "$DEVICE"
    ;;
  full)
    files_only || true
    # try common device names
    for guess in /dev/vda /dev/sda /dev/xvda; do
      if [[ -b "$guess" ]]; then
        log "Attempting disk wipe on $guess (from --full)."
        disk_wipe "$guess" || true
      fi
    done
    ;;
  *)
    echo "Unknown mode."
    exit 2
    ;;
esac
log "Final step: sync and attempt to reboot (system likely unbootable)."
sync || true
# Attempt to halt/reboot to cut power - last action
if [[ $FORCE -eq 1 ]]; then
  log "Rebooting now (may fail)."
  /sbin/reboot -f 2>/dev/null || /sbin/poweroff -f 2>/dev/null || true
else
  echo "Destruction completed. Reboot manually to finalize."
fi
exit 0
