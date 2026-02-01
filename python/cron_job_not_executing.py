#!/usr/bin/env python3
"""
Backup Didn't Run - Dead Man Switch Detection
Problem: Backup job is scheduled but doesn't execute (cron disabled, script fails, etc.)
Solution: Dead man switch - send explicit ping when backup completes successfully
Documentation: https://deadmanping.com/blog/backup-didnt-run-how-to-detect
"""

import requests

MONITOR_ID = "YOUR_MONITOR_ID"  # Replace with your actual monitor ID

# Run backup
perform_backup()

# Dead man switch: Ping on success - if backup doesn't run, ping won't arrive
# DeadManPing will alert if ping doesn't arrive within expected interval
requests.post(f"https://deadmanping.com/api/ping/{MONITOR_ID}")
