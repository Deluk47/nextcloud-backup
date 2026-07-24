# nextcloud-backup

Documentation and health checks for the BorgBackup repository used by a self‑hosted Nextcloud AIO instance.

This repository does **not** replace the built‑in Nextcloud AIO backup feature.  
Instead, it documents the confirmed backup location, adds a simple health‑check script, and provides notes for restore and ongoing maintenance.

## Scope

This repo assumes you are running Nextcloud AIO with its optional Borg‑based backup solution enabled [web:30][web:40].

On this host:

- Nextcloud AIO is configured to store Borg backups at:  
  `/mnt/nextcloud/ncdata/backups/borg`
- The Borg repository directory is owned by `www-data`, so root privileges are required to inspect it.
- The backup encryption password is stored **outside Git** (for example, in a password manager), and is required for any restore operation [web:13].

The repository focuses on:

- Describing the current backup state of the AIO instance.
- Providing a small `check-backup.sh` script to verify that the Borg repo exists and looks healthy.
- Documenting restore prerequisites and high‑level restore steps via the AIO interface [web:13].

## What this repo includes

- `docs/BACKUP.md`  
  Current Nextcloud AIO Borg backup configuration and what is confirmed to be present.

- `docs/RESTORE.md`  
  Restore prerequisites and guidance for restoring the instance from the Borg backup via the AIO interface.

- `scripts/check-backup.sh`  
  Root‑level health‑check script that confirms the Borg repository directory exists and contains the expected Borg metadata files.

- `.gitignore`  
  Ensures local paths like `backups/`, `logs/`, and `.env` (if present) are not committed.

## What is backed up (AIO Borg)

Nextcloud AIO’s Borg integration backs up:

- Nextcloud application data.
- Database contents.
- Nextcloud data directory.
- AIO‑managed configuration files [web:30][web:38].

By design, this **does not** automatically include:

- External storage mounted into Nextcloud via the external storage app.
- Non‑AIO host configuration, Docker engine config, or unrelated containers [web:13][web:24].

Those should be backed up separately if required.

## Usage

### 1. Run the backup health check

Because the Borg repository is owned by `www-data`, run the check script with `sudo`:

```bash
cd ~/projects/nextcloud-backup
sudo ./scripts/check-backup.sh
```

The script will:

- Verify that `/mnt/nextcloud/ncdata/backups/borg` exists.
- Check for key Borg repo metadata files (`config`, `README`, `nonce`, etc.).
- List the contents of the repository directory if everything looks correct.

If the directory is missing or key files are absent, investigate the backup configuration in the Nextcloud AIO interface first [web:30].

### 2. Confirm backups via the AIO interface

In the Nextcloud AIO web interface:

1. Open the **Backup & Restore** section.
2. Confirm that the backup path is set to `/mnt/nextcloud/ncdata/backups/borg`.
3. Trigger a backup or check existing backups as needed.
4. Use the built‑in integrity check to verify Borg archives when available [web:30][web:45].

### 3. Restore overview

`docs/RESTORE.md` contains high‑level restore notes. In summary:

- You must have:
  - Access to the Borg repository at `/mnt/nextcloud/ncdata/backups/borg`.
  - The Borg encryption password.
- Restores are performed via the Nextcloud AIO interface’s Borg restore workflow, not directly from this repository [web:13].

After a restore, you should verify:

- Nextcloud starts successfully and the web UI is reachable.
- Users can log in and see their files.
- Apps and integrations (e.g. reverse proxy, DNS) behave as expected.

## Security and secrets

- The Borg encryption password is **never** stored in this repository.
- Do not place the password in `.env` or any tracked file.
- Use a password manager or other secure storage and ensure that a restore operator can access it when needed [web:13].

## Future ideas

Potential extensions for this repo:

- A small `docs/MAINTENANCE.md` with guidance on:
  - How often to run the health check.
  - When to perform restore drills.
  - How to handle changes to the backup path or storage.
- Optional off‑host sync (e.g. `rsync` or remote Borg) documented as a second backup tier [web:22][web:27].

For now, the focus is to keep this repository small, clear, and aligned with the official AIO Borg backup mechanism.
