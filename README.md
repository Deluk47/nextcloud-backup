# nextcloud-backup

Documentation and health checks for the Nextcloud AIO Borg backup repository.

## Confirmed state

- Backups are stored at `/mnt/nextcloud/ncdata/backups/borg`.
- The Borg repository is owned by `www-data`.
- The repository contains Borg metadata and is initialized.
- The backup encryption password is stored outside Git.

## Included files

- `docs/BACKUP.md`
- `docs/RESTORE.md`
- `scripts/check-backup.sh`

## Usage

Run the health check with:

```bash
sudo ./scripts/check-backup.sh
```
