#!/usr/bin/env bash

TARGET_DIR=""
DEST_DIR="$PWD"
PURGE_OLD=false

function log_scoped() {
  echo "[backup_rsync_compress]: $1"
}

function show_help() {
  echo ""
  echo "Backup files & folders using rsync and tar. Works great as a cronjob!"
  echo ""
  echo "Usage: ./backup_rsync_compress.sh [options]"
  echo ""
  echo "Options:"
  echo ""
  echo "  -h, --help    show this help information"
  echo "  -i, --input   the directory or file to backup"
  echo "  -o, --output  the directory where the files to backup are copied to"
  echo "  -p, --purge   delete backups created that are older than 30 days. This will delete any file older than 30 days in the output directory!"
  echo ""
  exit 0
}

while [[ $# -gt 0 ]]; do
  arg="$1"
  case $arg in
    -i|--input)
      TARGET_DIR=$2
      shift
      ;;
    -o|--output)
      DEST_DIR="$2"
      shift
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    -p|--purge)
      PURGE_OLD=true
      shift
      ;;
    *)
      echo "[Error] Unrecognized option $1"
      exit 1
      ;;
  esac
  shift
done

function do_backup() {
  local cleanDirName
  cleanDirName=$(basename "$TARGET_DIR" | sed 's/ /_/')

  local backupDirWithSuffix
  backupDirWithSuffix="$DEST_DIR/$cleanDirName-$(date +%Y-%m-%d)"

  log_scoped "$(date +%D" "%r): Starting backup task with params:"
  echo "  Target directory: $TARGET_DIR"
  echo "  Destination directory: $backupDirWithSuffix"
  echo ""

  if [ ! -d "$backupDirWithSuffix" ]; then
    log_scoped "Destination directory $backupDirWithSuffix does not exist. Creating it first"
    mkdir -p "$backupDirWithSuffix"
  fi

  log_scoped "Performing backup..."
  if rsync -Ra "$TARGET_DIR" "$backupDirWithSuffix"; then
    log_scoped "Successfully backed up $TARGET_DIR"
  else
    log_scoped "Failed backing up $TARGET_DIR"
  fi

  log_scoped "Compressing backup directory to tgz..."
  if tar -czf "$backupDirWithSuffix.tgz" "$backupDirWithSuffix" &> /dev/null; then
    rm -rf "$backupDirWithSuffix"
    echo "  Compressed $backupDirWithSuffix to $backupDirWithSuffix.tgz"
    echo ""
  else
    rm -rf "$backupDirWithSuffix"
    echo "  Failed compressing $backupDirWithSuffix to $backupDirWithSuffix.tgz"
    echo ""
    log_scoped "$(date +%D" "%r): Backup failed"
    echo ""
    exit 1
  fi

  if [ $PURGE_OLD == true ]; then
    log_scoped "Removing backups older than 30 days..."
    find "$DEST_DIR" -name '*.tgz' -mtime +30 -delete -print || \
      echo "  Failed purging older backups..."
  fi

  log_scoped "$(date +%D" "%r): Backup complete"
}

do_backup "$@"
