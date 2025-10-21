# 🔥 VPS Nuke Script

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-blue.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey.svg)](https://www.linux.org/)

> **⚠️ EXTREME WARNING ⚠️**  
> This script will **IRREVERSIBLY DESTROY** all data on your VPS.  
> Only use on machines **you own** and **intend to completely obliterate**.

## 📖 Description

A comprehensive VPS destruction script for securely wiping Virtual Private Servers when you need to ensure complete data removal. This tool goes far beyond simple file deletion - it systematically destroys:

- 🗂️ All user data and system files
- 🔐 SSH keys and authentication data  
- 🗄️ Databases (MySQL, PostgreSQL, Redis)
- 🐳 Container data (Docker, Kubernetes)
- 🌐 Web server configurations
- 📜 System logs and histories
- 💾 Free space overwriting
- 🔧 System configurations and certificates

## 🎯 Use Cases

- **Security**: Ensure sensitive data cannot be recovered from decommissioned VPS
- **Compliance**: Meet data destruction requirements for regulations
- **Testing**: Reset test/development environments completely
- **Privacy**: Remove all traces before terminating cloud instances

## ⚡ Quick Start

```bash
# Clone the repository
git clone https://github.com/MyCato/vps-nuke.git
cd vps-nuke

# Make executable
chmod +x nuke_vps.sh
```
```bash
# Run (requires sudo)
sudo ./nuke_vps.sh --files-only
```

## 🚀 Usage

### Basic Modes

```bash
# Files-only mode (safe for most VPS)
sudo ./nuke_vps.sh --files-only

# Disk wipe mode (specify device)
sudo ./nuke_vps.sh --disk-wipe /dev/vda

# Full nuclear mode (files + auto disk detection)
sudo ./nuke_vps.sh --full

# Skip confirmation prompt
sudo ./nuke_vps.sh --files-only --force
```

### Mode Details

| Mode | Description | Risk Level |
|------|-------------|------------|
| `--files-only` | Destroys files, configs, logs, users | 🟡 Medium |
| `--disk-wipe` | Files + overwrites specified disk | 🔴 High |
| `--full` | Files + attempts to wipe common disks | 🔴 Maximum |

## 🛡️ Safety Features

- **Root requirement**: Must run as sudo/root
- **Confirmation prompt**: Requires typing "destroy" to proceed
- **Device validation**: Checks block devices exist before wiping
- **Best-effort operations**: Uses `|| true` to continue on errors
- **Comprehensive logging**: Timestamps all operations

## 📋 What Gets Destroyed

### 🗂️ User Data
- Home directories (`/home/*`, `/root/*`)
- Application data (`/srv/*`, `/opt/*`)
- Shell histories (bash, zsh, mysql, postgres, mongo)
- Browser data (Chrome, Firefox, Safari)
- Recent file lists and completion caches

### 🔐 Authentication & Security
- SSH keys and authorized_keys
- SSL/TLS certificates (`/etc/ssl/`, `/etc/letsencrypt/`)
- System user accounts (passwd/shadow files)
- Sudoers configuration

### 🗄️ Application Data
- **Databases**: MySQL, PostgreSQL, Redis data directories
- **Containers**: Docker images, volumes, Kubernetes data
- **Web Servers**: Nginx, Apache configurations and content
- **Mail**: Mail spool and configuration
- **Version Control**: Git repositories, SVN data

### 🔧 System Configuration
- Network configurations (`/etc/network/`, `/etc/netplan/`)
- Systemd configurations
- Cron jobs and scheduled tasks
- Package manager caches and databases
- Kernel modules

### 📜 Logs & Monitoring
- System logs (`/var/log/*`)
- Journal logs (systemd)
- Audit logs
- Application logs

### 💾 Storage & Memory
- Free space overwriting with random data
- Swap partition/file destruction
- Memory cache clearing
- Hibernation files

## ⚙️ Technical Details

### Requirements
- **OS**: Linux (tested on Ubuntu, Debian, CentOS, RHEL)
- **Shell**: Bash 4.0+
- **Privileges**: Root/sudo access
- **Optional**: `pv` command for progress display during disk wipe

### Key Features
- **Robust argument parsing**: Handles all input scenarios safely
- **Multi-distribution support**: Works with apt, dnf/yum, pacman
- **Modern application support**: Docker, Kubernetes, modern databases
- **Comprehensive coverage**: Destroys data from 50+ different sources

### Disk Wiping Process
1. **Random overwrite**: Fills disk with `/dev/urandom` data
2. **Zero overwrite**: Writes zeros across entire device
3. **Signature removal**: Uses `wipefs` to remove filesystem signatures

## ⚠️ Important Warnings

### 🚨 This Script Will
- **Completely destroy** your VPS and all data on it
- **Make the system unbootable** 
- **Render data unrecoverable** from local storage
- **Remove all user accounts** and authentication

### 🛡️ This Script Cannot
- Delete **cloud provider snapshots**
- Remove **external backups** 
- Affect **network-attached storage** not mounted locally
- Delete **provider metadata** (billing, tags, etc.)

### 📝 Before Running
- [ ] **Backup any data** you want to keep elsewhere
- [ ] **Verify you own** the machine completely
- [ ] **Understand this is irreversible**
- [ ] **Consider terminating** the instance via cloud provider after running

## 🔧 Advanced Usage

### Custom Device Wiping
```bash
# Wipe specific device
sudo ./nuke_vps.sh --disk-wipe /dev/nvme0n1

# Multiple devices (run separately)
sudo ./nuke_vps.sh --disk-wipe /dev/sda
sudo ./nuke_vps.sh --disk-wipe /dev/sdb
```

### Automation (Use with extreme caution)
```bash
# Automated destruction (no prompts)
sudo ./nuke_vps.sh --full --force
```

## 🤝 Contributing

Contributions are welcome! Please:

1. **Test thoroughly** on disposable VMs/containers first
2. **Document changes** clearly in PR descriptions  
3. **Follow existing code style** and safety patterns
4. **Add appropriate warnings** for destructive changes

### Areas for Improvement
- Support for additional databases/applications
- Enhanced progress reporting
- Platform-specific optimizations
- Recovery prevention techniques

## 📜 License

MIT License - see [LICENSE](LICENSE) file for details.

## ⚖️ Legal Disclaimer

This software is provided "as is" without warranty of any kind. Users are solely responsible for:
- Ensuring they have **legal authority** to destroy the target system
- **Verifying data backup** needs before use
- Understanding **local laws** regarding data destruction
- **Testing in safe environments** first

**Use at your own risk. The authors assume no liability for data loss or system damage.**

## 🙏 Acknowledgments

- Inspired by various secure deletion tools and best practices
- Thanks to the security community for data destruction guidance
- Special thanks to contributors and testers

---

**Remember**: With great power comes great responsibility. This tool is a loaded gun - treat it as such. 🔫💥
