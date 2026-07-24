# Restore notes

This document describes the restore-related facts for the current Nextcloud AIO Borg backup setup.

## Restore prerequisites

- The Borg repository must exist at `/mnt/nextcloud/ncdata/backups/borg`.
- The backup encryption password must be available.
- The person restoring the backup must run the health-check script with `sudo` if they need to inspect the repository on disk.

## Restore guidance

Use the Nextcloud AIO web interface to restore from the Borg backup repository.

Before restoring, confirm:

- The repository is present.
- The repository contains Borg metadata.
- The backup password is available and correct.

After restoring, verify:

- Nextcloud starts successfully.
- Files are accessible.
- The database is healthy.
- Apps and integrations load normally.
