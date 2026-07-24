#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="/mnt/nextcloud/ncdata/backups/borg"

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo."
  exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
  echo "Backup directory missing: $BACKUP_DIR"
  exit 1
fi

required_files=(config README nonce)
for f in "${required_files[@]}"; do
  if [ ! -e "$BACKUP_DIR/$f" ]; then
    echo "Missing Borg repo file: $BACKUP_DIR/$f"
    exit 1
  fi
done

echo "Borg repository looks present: $BACKUP_DIR"
ls -lah "$BACKUP_DIR"
