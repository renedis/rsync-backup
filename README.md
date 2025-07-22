# rsync-backup: Containerized Daily Backup Solution

A lightweight, versatile container designed for daily backups using `rsync`. Supports local and remote directory synchronization with configurable retention policies and logging.

---

## Overview

### `disk-backup` Script

The core of this container is the `disk-backup` script, which performs backups of specified local or remote directories using `rsync`. Configuration is managed through environment variables, allowing flexible customization without modifying the container.

Key features include:

- Supports backup of both local and remote directories.
- Optional retention management via the `MAX_AGE` variable, which triggers cleanup of backups older than the specified number of days.
- Comprehensive logging of `rsync` operations and script execution, outputting to Docker logs when `--log-file=/dev/stdout` is enabled.
- SSH support is available but disabled by default; it can be enabled by uncommenting the relevant line in `disk-backup.sh`.
- Multi-architecture compatibility: x86_64 (AMD64), ARMv7 (32-bit), and ARM64 (64-bit).

For automated daily execution, a local crontab can be configured to restart the container, for example:

```bash
30 1 * * * docker restart rsync-backup
```

---

## Configuration

The following environment variables control the behavior of the backup process:

```bash
TARGET_DIR=         # Destination path where backups are stored
SOURCE_DIR=         # Source path to backup; can be local (e.g., /home/user) or remote (e.g., user@host:/path)
SSH_OPTIONS=        # Optional SSH parameters to pass to rsync (e.g., -o UserKnownHostsFile=/dev/null)
RSYNC_OPTIONS=      # Additional rsync command-line options
MAX_AGE=            # Retention period in days; backups older than this will be deleted. If unset, no deletion occurs.
EXCLUDE_FILE=       # Path to a file listing files/directories to exclude from backup (one per line)
```

---

## Example Usage with Docker Compose

Below is a sample Docker Compose service configuration demonstrating how to deploy the container with typical environment variables and volume mounts:

```yaml
services:
  rsync-backup:
    container_name: rsync-backup
    image: renedis/rsync-backup:latest
    environment:
      - EXCLUDE_FILE=/exclude/excludelist.txt
      - MAX_AGE=30
      - RSYNC_OPTIONS=--recursive --verbose --perms --chmod=a+rwx --stats --progress --log-file=/dev/stdout
      - SOURCE_DIR=/source
      - TARGET_DIR=/target
      - TZ=Europe/Amsterdam
    volumes:
      - /SOURCE-FOLDER-TO-SYNC:/source:ro
      - /DESTINATION-FOLDER-TO-SYNC:/target
      - /DESTINATION-FOLDER-TO-EXCLUDE-FILE:/exclude
```

---
