#!/bin/bash
#===============================================
# Website availability monitor
# Author: Gleb Bufin
# Homework: 04-bash
#===============================================

# === CONFIG ===
WEBSITE_URL="${1:-http://localhost}"
LOG_FILE="/home/$USER/logs/website-monitor.log"
TIMEOUT=10

# Create log directory if not exists
mkdir -p "$(dirname $LOG_FILE)"

# === LOG FUNCTION ===
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# === CHECK WEBSITE ===
# curl options:
#   -o /dev/null  - don't output response body
#   -s            - silent mode
#   -w "%{http_code}" - output only HTTP status code
#   --connect-timeout - connection timeout in seconds

HTTP_CODE=$(curl -o /dev/null -s -w "%{http_code}" --connect-timeout "$TIMEOUT" "$WEBSITE_URL" 2>/dev/null)
CURL_EXIT=$?

# === ANALYZE RESULT ===
if [ $CURL_EXIT -ne 0 ]; then
    log_message "DOWN | $WEBSITE_URL | Connection failed (curl exit code: $CURL_EXIT)"
    echo "Website $WEBSITE_URL is DOWN"
    exit 1
elif [ "$HTTP_CODE" -ge 200 ] && [ "$HTTP_CODE" -lt 400 ]; then
    log_message "UP   | $WEBSITE_URL | HTTP $HTTP_CODE"
    echo "Website $WEBSITE_URL is UP (HTTP $HTTP_CODE)"
    exit 0
else
    log_message "WARN | $WEBSITE_URL | HTTP $HTTP_CODE"
    echo "Website $WEBSITE_URL returned HTTP $HTTP_CODE"
    exit 1
fi
