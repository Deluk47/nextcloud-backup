# Nextcloud AIO backup state

This repository documents the current backup state of the Nextcloud AIO instance.

## Confirmed backup location

AIO backups are stored on the host at:

`/mnt/nextcloud/ncdata/backups/borg`

## Repository ownership

The Borg repository directory is owned by `www-data`, so the local health-check script must be run with `sudo` to read the backup contents.

## Confirmed repository state

The repository is present and contains Borg metadata files, including:

- `config`
- `README`
- `nonce`
- `data/`
- `hints.*`
- `index.*`
- `integrity.*`

This confirms that the Borg repository has been initialized correctly.

## Backup password

The AIO backup encryption password must be stored safely outside this repository.

Do not commit the password to Git.
Do not place it in `.env` or any tracked file.
Use a password manager or another secure storage method.
