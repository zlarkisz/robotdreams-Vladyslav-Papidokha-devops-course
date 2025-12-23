#!/bin/bash
#===============================================
# Backup script
# Author: Gleb Bufin
# Homework: 04-bash
#===============================================

# === CONFIG ===
SOURCE_DIR="/home/$USER/data"
BACKUP_DIR="/home/$USER/backup"
LOG_FILE="/home/$USER/logs/backup.log"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_NAME="backup_$DATE.tar.gz"

# === LOG FUNCTION ===
log_message() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# === CHECKS ===
if [ ! -d "$SOURCE_DIR" ]; then
  log_message "ERROR: Directory $SOURCE_DIR does not exists!"
  exit 1
fi

mkdir -p "$BACKUP_DIR"

# === CREATING A BACKUP ===
log_message "Start of backup: $SOURCE_DIR"

if tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$(dirname $SOURCE_DIR)" "$(basename $SOURCE_DIR)" 2>> "$LOG_FILE"; then
  BACKUP_SIZE=$(du -h "$BACKUP_DIR/$BACKUP_NAME" | cut -f1)
  log_message "SUCCESS: Created $BACKUP_NAME (size: $BACKUP_SIZE)"
else
  log_message "ERROR: Failed to create backup!"
  exit 1
fi

# === CLEANING OLD BACKUPS ===
DELETED=$(find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +7 -delete -print | wc -l)
if [ "$DELETED" -gt 0 ]; then
    log_message "Old backups deleted: $DELETED"
fi

log_message "Backup completed successfully"
exit 0
