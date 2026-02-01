#!/bin/bash
# Backup Didn't Run - Dead Man Switch Detection
# Problem: Backup job is scheduled but doesn't execute (cron disabled, script fails, etc.)
# Solution: Dead man switch - send explicit ping when backup completes successfully
# Documentation: https://deadmanping.com/blog/backup-didnt-run-how-to-detect

set -e

MONITOR_ID="YOUR_MONITOR_ID"  # Replace with your actual monitor ID

# Run backup
./backup.sh

# Dead man switch: Ping on success - if backup doesn't run, ping won't arrive
# DeadManPing will alert if ping doesn't arrive within expected interval
curl -X POST "https://deadmanping.com/api/ping/$MONITOR_ID"
