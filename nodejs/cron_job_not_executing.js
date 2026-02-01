#!/usr/bin/env node
/**
 * Backup Didn't Run - Dead Man Switch Detection
 * Problem: Backup job is scheduled but doesn't execute (cron disabled, script fails, etc.)
 * Solution: Dead man switch - send explicit ping when backup completes successfully
 * Documentation: https://deadmanping.com/blog/backup-didnt-run-how-to-detect
 */

const https = require('https');

const MONITOR_ID = 'YOUR_MONITOR_ID';  // Replace with your actual monitor ID

// Run backup
async function run() {
  await performBackup();
  
  // Dead man switch: Ping on success - if backup doesn't run, ping won't arrive
  // DeadManPing will alert if ping doesn't arrive within expected interval
  https.request(`https://deadmanping.com/api/ping/${MONITOR_ID}`, { method: 'POST' }).end();
}

run().catch((err) => {
  // If backup fails, ping won't arrive - DeadManPing will detect missing ping
  process.exit(1);
});
