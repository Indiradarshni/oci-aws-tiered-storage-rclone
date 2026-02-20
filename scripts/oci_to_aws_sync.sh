#!/bin/bash

# Near real-time OCI Object Storage → AWS S3 sync using rclone
# Demo / PoC: Run from OCI Cloud Shell
# Production: Run continuously on an OCI Compute VM (cron)

set -euo pipefail

# =========================
# Configuration
# =========================

# Source: OCI Object Storage (HOT tier)
OCI_BUCKET="oci:ag-decoded-bucket"

# Destination: AWS S3 (WARM tier)
AWS_BUCKET="aws:aws-backup-warm"

# Sync interval in seconds (controls near real-time behavior)
SYNC_INTERVAL=30

# Log file location
LOG_FILE="$HOME/rclone-sync.log"

# =========================
# Pre-flight checks
# =========================

if ! command -v rclone >/dev/null 2>&1; then
  echo "ERROR: rclone is not installed or not in PATH"
  exit 1
fi

# =========================
# Sync loop
# =========================

echo "Starting OCI → AWS near real-time sync"
echo "Source bucket      : $OCI_BUCKET"
echo "Destination bucket : $AWS_BUCKET"
echo "Sync interval      : ${SYNC_INTERVAL}s"
echo "Log file           : $LOG_FILE"
echo

while true; do
  echo "$(date) - Sync started" | tee -a "$LOG_FILE"

  rclone sync "$OCI_BUCKET" "$AWS_BUCKET" \
    --fast-list \
    --transfers 8 \
    --checkers 16 \
    --retries 5 \
    --low-level-retries 10 \
    --log-level INFO \
    --log-file "$LOG_FILE"

  echo "$(date) - Sync completed" | tee -a "$LOG_FILE"
  echo | tee -a "$LOG_FILE"

  sleep "$SYNC_INTERVAL"
done
