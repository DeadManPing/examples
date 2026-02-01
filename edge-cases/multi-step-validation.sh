#!/bin/bash
# Multi-Step Backup Validation Example
# Problem: Backup job has multiple steps (database dump, file sync, notification) - some succeed, others fail
# Solution: Verify each step and track failures, send failed steps count in payload
# Documentation: https://deadmanping.com/blog/detect-cron-job-partial-failure

set -e

MONITOR_ID="YOUR_MONITOR_ID"  # Replace with your actual monitor ID
FAILED_STEPS=()

# Step 1: Database backup
if ! pg_dump mydb > /backups/db.sql; then
  FAILED_STEPS+=("database_backup")
fi

# Step 2: File sync
if ! rsync -avz /data/ user@server:/backup/; then
  FAILED_STEPS+=("file_sync")
fi

# Step 3: Send notification
if ! ./send-notification.sh; then
  FAILED_STEPS+=("send_notification")
fi

# Single ping with step completion data in payload
# In DeadManPing panel: set validation rule "failed_steps_count" == 0
# Panel will automatically detect if any steps failed
FAILED_STEPS_COUNT=${#FAILED_STEPS[@]}
curl -X POST "https://deadmanping.com/api/ping/$MONITOR_ID?failed_steps_count=$FAILED_STEPS_COUNT"
