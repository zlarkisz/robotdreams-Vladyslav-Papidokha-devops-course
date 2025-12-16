#!/bin/bash
#===============================================
# System Resource Monitor
# Author: Gleb Bufin
# Homework: 04-bash
#===============================================

# === CONFIG ===
LOG_DIR="/home/$USER/logs"
REPORT_FILE="$LOG_DIR/system-report_$(date +%Y-%m-%d_%H-%M-%S).txt"

mkdir -p "$LOG_DIR"

# === FUNCTIONS ===
separator() {
    echo "=============================================="
}

# === GENERATE REPORT ===
{
    separator
    echo "SYSTEM RESOURCE REPORT"
    echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Hostname: $(hostname)"
    separator

    echo ""
    echo ">>> UPTIME & LOAD AVERAGE"
    uptime

    echo ""
    echo ">>> MEMORY USAGE"
    free -h

    # Calculate memory percentage
    TOTAL_MEM=$(free | awk '/^Mem:/ {print $2}')
    USED_MEM=$(free | awk '/^Mem:/ {print $3}')
    MEM_PERCENT=$(awk "BEGIN {printf \"%.1f\", $USED_MEM/$TOTAL_MEM*100}")
    echo "Memory used: ${MEM_PERCENT}%"

    echo ""
    echo ">>> DISK USAGE"
    df -h | grep -E '^/dev/'

    echo ""
    echo ">>> TOP 5 PROCESSES BY CPU"
    ps aux --sort=-%cpu | head -6

    echo ""
    echo ">>> TOP 5 PROCESSES BY MEMORY"
    ps aux --sort=-%mem | head -6

    separator
    echo "END OF REPORT"
    separator

} | tee "$REPORT_FILE"

echo ""
echo "Report saved to: $REPORT_FILE"
