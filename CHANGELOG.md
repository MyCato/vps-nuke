# Changelog

All notable changes to the VPS Nuke script will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-10-21

### Added
- **Complete VPS destruction functionality** with comprehensive data coverage
- **Enhanced argument parsing** with proper error handling
- **Multi-mode operation**: files-only, disk-wipe, and full destruction modes
- **Comprehensive data destruction** covering:
  - Database destruction (MySQL, PostgreSQL, Redis)
  - Container data removal (Docker, Kubernetes)
  - Web server configuration cleanup (Nginx, Apache)
  - Browser history and cache removal
  - Version control data destruction (Git, SVN)
  - SSL/TLS certificate removal
  - Network configuration cleanup
  - Cron job and scheduled task removal
  - Mail data destruction
  - Kernel module cleanup
  - Memory and hibernation file clearing
- **Disk wiping capability** with random data overwrite and zero-fill
- **Safety mechanisms** including confirmation prompts and device validation
- **Multi-distribution support** for various Linux distributions
- **Comprehensive logging** with timestamps

### Security
- **Enhanced data destruction** with thorough coverage of sensitive data
- **Memory clearing** including memory cache and hibernation file destruction
- **Free space wiping** to prevent data recovery
- **Secure file deletion** using shred where appropriate
