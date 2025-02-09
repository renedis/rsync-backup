Container for daily backups based on rsync
---

## Script
### `disk-backup`
This script creates a backup using rsync of a local or a remote directory.
Environment variables are used to configure the script. When MAX_AGE variable is set it calls a second script on completion.
All log output of rsync and scripts are sent to docker if --log-file=/dev/stdout is set.
SSH option is currently off. By removing the # in disk-backup.sh in the ARGS you can enable it.

I run a local crontab to run the container daily.

## Variables
```bash
TARGET_DIR=         # path where the backups are stored
SOURCE_DIR=         # local or remote path to backup eg. /home/foobar OR foobar@some.host.com:/home/foobar
SSH_OPTIONS=        # ssh options to pass into rsync eg. -o UserKnownHostsFile=/dev/null
RSYNC_OPTIONS=      # additional rsync options
MAX_AGE=            # oldest backup to keep in days, anything older will be deleted. If not set, it's ignored.
EXCLUDE=            # option to exclude folders that you dont want to be backupped.
```
## Usage Scenario
#### Docker compose
```bash
version: "3"
services:
  rsync-backup:
    container_name: rsync-backup
    environment:
      - EXCLUDE: "examplefolder/examplesubfolder/ .anotherfolder/"
      - MAX_AGE: "30"
      - RSYNC_OPTIONS: --recursive --verbose --perms --chmod=a+rwx --stats --progress --log-file=/dev/stdout
      - SOURCE_DIR: /source
      - TARGET_DIR: /target
      - TZ: Europe/Amsterdam
    volumes:
      - /SOURCE-FOLDER-TO-SYNC:/source:ro
      - /DESTINATION-FOLDER-TO-SYNC:/target
    image: renedis/rync-backup:latest
```
