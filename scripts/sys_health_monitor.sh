#!/bin/bash
#############################################################################
# Script Name : sys_health_monitor.sh
# Description : System Health Monitoring Script for Red Hat Linux (RHEL)
#               Monitors CPU, Memory, Disk, Load Average, Running Processes,
#               and Network status. Generates a timestamped report and
#               raises threshold-based alerts (logged + optional email).
# Author      : Prajwal K
# Usage       : ./sys_health_monitor.sh
#               ./sys_health_monitor.sh --cron   (silent mode for cron jobs)
#############################################################################

# ---------------------------- CONFIGURATION -------------------------------
LOG_DIR="/var/log/sys_health_monitor"
LOG_FILE="${LOG_DIR}/health_$(date +%Y%m%d).log"
REPORT_FILE="${LOG_DIR}/report_$(date +%Y%m%d_%H%M%S).txt"

CPU_THRESHOLD=80        # percent
MEM_THRESHOLD=80        # percent
DISK_THRESHOLD=85       # percent
LOAD_THRESHOLD=4.0      # 1-min load average (tune to CPU core count)

ALERT_EMAIL="admin@example.com"   # change to your email; needs mail/sendmail setup
SEND_EMAIL_ALERTS=false           # set true only if mailx/sendmail is configured

# ------------------------------ SETUP --------------------------------------
# Create log directory if it doesn't exist (needs sudo the first time)
if [ ! -d "$LOG_DIR" ]; then
    sudo mkdir -p "$LOG_DIR"
    sudo chown "$USER":"$USER" "$LOG_DIR"
fi

CRON_MODE=false
if [ "$1" == "--cron" ]; then
    CRON_MODE=true
fi

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# ------------------------------ HELPERS -------------------------------------
log_line() {
    echo "$1" | tee -a "$LOG_FILE" >> "$REPORT_FILE"
}

print_header() {
    if [ "$CRON_MODE" = false ]; then
        echo -e "\n================= $1 ================="
    fi
    echo -e "\n================= $1 =================" >> "$REPORT_FILE"
}

alert() {
    local message="$1"
    echo "[ALERT] $TIMESTAMP - $message" | tee -a "$LOG_FILE"
    echo "[ALERT] $message" >> "$REPORT_FILE"

    if [ "$SEND_EMAIL_ALERTS" = true ] && command -v mail >/dev/null 2>&1; then
        echo "$message" | mail -s "System Health Alert on $(hostname)" "$ALERT_EMAIL"
    fi
}

# ------------------------------ REPORT HEADER --------------------------------
{
echo "############################################################"
echo " SYSTEM HEALTH REPORT"
echo " Hostname : $(hostname)"
echo " Date     : $TIMESTAMP"
echo " OS       : $(cat /etc/redhat-release 2>/dev/null || uname -a)"
echo "############################################################"
} >> "$REPORT_FILE"

[ "$CRON_MODE" = false ] && cat "$REPORT_FILE"

# ------------------------------ CPU USAGE -------------------------------------
print_header "CPU USAGE"
# %idle from mpstat/top, derive usage = 100 - idle
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk -F'id,' '{ split($1, a, ","); print a[length(a)] }' | awk '{print $1}')
CPU_USAGE=$(awk "BEGIN {printf \"%.1f\", 100 - $CPU_IDLE}")
log_line "CPU Usage        : ${CPU_USAGE}%"
log_line "Number of Cores  : $(nproc)"

if (( $(echo "$CPU_USAGE >= $CPU_THRESHOLD" | bc -l) )); then
    alert "High CPU usage detected: ${CPU_USAGE}% (threshold: ${CPU_THRESHOLD}%)"
fi

# ------------------------------ MEMORY USAGE ----------------------------------
print_header "MEMORY USAGE"
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_USAGE=$(awk "BEGIN {printf \"%.1f\", ($MEM_USED/$MEM_TOTAL)*100}")

log_line "Total Memory     : ${MEM_TOTAL} MB"
log_line "Used Memory      : ${MEM_USED} MB"
log_line "Memory Usage     : ${MEM_USAGE}%"
free -h >> "$REPORT_FILE"

if (( $(echo "$MEM_USAGE >= $MEM_THRESHOLD" | bc -l) )); then
    alert "High Memory usage detected: ${MEM_USAGE}% (threshold: ${MEM_THRESHOLD}%)"
fi

# ------------------------------ DISK USAGE ------------------------------------
print_header "DISK USAGE"
df -hP | grep -vE '^Filesystem|tmpfs|cdrom' >> "$REPORT_FILE"
[ "$CRON_MODE" = false ] && df -hP | grep -vE '^Filesystem|tmpfs|cdrom'

while read -r line; do
    USAGE=$(echo "$line" | awk '{print $5}' | tr -d '%')
    PARTITION=$(echo "$line" | awk '{print $6}')
    if [ -n "$USAGE" ] && [ "$USAGE" -ge "$DISK_THRESHOLD" ]; then
        alert "High Disk usage on ${PARTITION}: ${USAGE}% (threshold: ${DISK_THRESHOLD}%)"
    fi
done < <(df -hP | grep -vE '^Filesystem|tmpfs|cdrom')

# ------------------------------ LOAD AVERAGE ----------------------------------
print_header "LOAD AVERAGE"
LOAD_1MIN=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | tr -d ' ')
log_line "Load Average (1/5/15 min): $(uptime | awk -F'load average:' '{print $2}')"

if (( $(echo "$LOAD_1MIN >= $LOAD_THRESHOLD" | bc -l) )); then
    alert "High system load detected: $LOAD_1MIN (threshold: $LOAD_THRESHOLD)"
fi

# ------------------------------ TOP PROCESSES ---------------------------------
print_header "TOP 5 CPU-CONSUMING PROCESSES"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -6 >> "$REPORT_FILE"
[ "$CRON_MODE" = false ] && ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -6

print_header "TOP 5 MEMORY-CONSUMING PROCESSES"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -6 >> "$REPORT_FILE"
[ "$CRON_MODE" = false ] && ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -6

# ------------------------------ NETWORK STATUS --------------------------------
print_header "NETWORK STATUS"
if command -v ip >/dev/null 2>&1; then
    ip -brief addr show >> "$REPORT_FILE"
    [ "$CRON_MODE" = false ] && ip -brief addr show
fi

# Check connectivity to a reliable host
if ping -c 1 -W 2 8.8.8.8 &> /dev/null; then
    log_line "Internet Connectivity : UP"
else
    alert "Internet connectivity check failed (no response from 8.8.8.8)"
fi

# ------------------------------ SERVICE STATUS --------------------------------
print_header "CRITICAL SERVICES STATUS"
SERVICES=("sshd" "firewalld" "network" "NetworkManager")
for svc in "${SERVICES[@]}"; do
    if systemctl is-active --quiet "$svc" 2>/dev/null; then
        log_line "$svc : ACTIVE"
    else
        log_line "$svc : NOT RUNNING / NOT FOUND"
    fi
done

# ------------------------------ SUMMARY ----------------------------------------
print_header "SUMMARY"
log_line "Report saved to : $REPORT_FILE"
log_line "Log file        : $LOG_FILE"

echo -e "\nHealth check completed at $TIMESTAMP"
exit 0

