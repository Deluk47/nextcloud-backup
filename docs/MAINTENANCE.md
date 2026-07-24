# Backup maintenance runbook

This document describes routine checks and actions to keep the Nextcloud AIO Borg backup healthy and restorable.

It assumes:

- Nextcloud AIO is running on this host.
- Borg backups are stored at `/mnt/nextcloud/ncdata/backups/borg`.
- The Borg repository is owned by `www-data`.
- The backup encryption password is stored securely outside this repo.

## 1. Routine health checks

### 1.1 Manual health check (recommended weekly and before upgrades)

From the host:

```bash
cd ~/projects/nextcloud-backup
sudo ./scripts/check-backup.sh
```

Expected result:

- Script prints: `Borg repository looks present: /mnt/nextcloud/ncdata/backups/borg`
- A directory listing of the Borg repo is shown, including files like `config`, `README`, `nonce`, `index.*`, `hints.*`, `integrity.*`.

If the script reports a missing directory or missing Borg files, investigate before making any major changes.

### 1.2 Check backups in the AIO interface

In the Nextcloud AIO web UI:

1. Open the **Backup & Restore** section.
2. Confirm the backup path is set to `/mnt/nextcloud/ncdata/backups/borg` [web:30].
3. Check that at least one backup is listed and that the date/time stamps look recent.
4. If available, run the backup integrity check from the AIO interface and confirm it reports success [web:45][web:30].

If integrity checks fail or backups are missing, follow AIO’s guidance and logs before relying on the current backup set [web:45][web:48].

## 2. Scheduled backup behavior

Backups themselves are scheduled and managed by Nextcloud AIO’s Borg integration, not by this repository [web:30][web:24].

To confirm or adjust AIO’s backup schedule:

1. Open the AIO web interface.
2. Go to **Backup & Restore**.
3. Verify that daily backups are enabled (if you use them).
4. Adjust schedule and retention settings according to your storage and RPO/RTO needs [web:30][web:93].

This repo deliberately does **not** add another scheduler; it documents and verifies the existing AIO behavior.

## 3. When the health check fails

If `check-backup.sh` fails:

1. Confirm the path exists:

   ```bash
   sudo ls -lah /mnt/nextcloud/ncdata/backups
   sudo ls -lah /mnt/nextcloud/ncdata/backups/borg
   ```

2. If the directory is missing, recreate it and check the AIO configuration:

   ```bash
   sudo mkdir -p /mnt/nextcloud/ncdata/backups/borg
   sudo chown www-data:root /mnt/nextcloud/ncdata/backups/borg
   ```

   Then validate that AIO still points to this path and trigger a fresh backup [web:32][web:30].

3. If the Borg repo exists but appears corrupt or incomplete:

   - Use the AIO interface’s integrity check and follow any error guidance shown there [web:45][web:47].
   - Consult the official AIO backup section for recovery and migration options [web:30][web:40].

4. Do **not** rely on a backup set that fails integrity checks or looks incomplete.

## 4. Restore drills

Regular restore tests reduce surprises when you actually need to recover.

Recommended cadence: at least once or twice per year, or after major configuration changes.

High‑level steps (see `docs/RESTORE.md` for more detail):

1. Provision a test environment (VM or spare host).
2. Install Docker and Nextcloud AIO.
3. Configure AIO to use the existing Borg repository (local or remote) and provide the backup encryption password [web:13][web:49].
4. Restore a recent backup via the AIO interface.
5. After restore, verify:
   - Nextcloud starts and is reachable over HTTP/HTTPS.
   - You can log in with an expected user account.
   - Files are present and open correctly.
   - Apps and integrations behave as expected.

Document the date and result of each restore drill in a private log or ticketing system.

## 5. Password and secret handling

The Borg encryption password is critical:

- Store it in a password manager or other secure system.
- Make sure at least one recovery path exists (e.g. second admin with access).
- Never commit the password to Git, even in ignored files.

If the password is lost, the Borg backups cannot be used for restore [web:13][web:49].

## 6. When the backup path or storage changes

If you change disks, mount points, or move backups:

1. Update the backup directory path in the AIO interface [web:29][web:43].
2. Ensure the new directory exists on the host and is owned by `www-data`.
3. Update this repo’s documentation (`docs/BACKUP.md` and `README.md`) to reflect the new path.
4. Run `check-backup.sh` against the new path to confirm the Borg repo is present.
5. Optionally perform a restore drill using the new location.

## 7. Future enhancements

Potential future improvements that can be documented and tracked here:

- Off‑host sync of Borg archives (e.g. using `rsync` or remote Borg) as a second backup tier [web:22][web:27].
- A post‑restore smoke‑test script (`scripts/restore-check.sh`) that confirms HTTP status and a few core Nextcloud endpoints.
- Integration with monitoring/alerting to notify if `check-backup.sh` starts failing.

For now, this runbook aims to keep the core AIO Borg backup setup **visible, verifiable, and repeatable** without adding additional moving parts.
