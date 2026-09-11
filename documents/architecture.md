# System Health Monitoring Tool - Architecture

## 1. Overview

The Linux System Health Monitoring Tool is a Bash-based monitoring application designed for Red Hat Enterprise Linux (RHEL).

The tool collects important system health metrics, compares them with predefined thresholds, generates alerts when abnormal conditions are detected, and stores monitoring reports and logs.

## 2. System Architecture

```text
                    RHEL System
                        |
                        v
              sys_health_monitor.sh
                        |
        +---------------+---------------+
        |               |               |
        v               v               v
     CPU/RAM          Disk/Load      Network
     Monitoring       Monitoring     Monitoring
        |               |               |
        +---------------+---------------+
                        |
                        v
                Threshold Checking
                        |
              +---------+---------+
              |                   |
           Normal              Critical
              |                   |
              v                   v
          Log/Report             Alert
              |                   |
              +---------+---------+
                        |
                        v
               /var/log/sys_health_monitor
```

## 3. Monitoring Components

### CPU Monitoring

The script checks the current CPU utilization and compares it with the configured CPU threshold.

Default threshold:

```text
CPU_THRESHOLD=80%
```

If CPU utilization exceeds the threshold, an alert is generated.

### Memory Monitoring

The script checks system memory usage and calculates the percentage of memory being used.

Default threshold:

```text
MEM_THRESHOLD=80%
```

### Disk Monitoring

Disk utilization is checked for available filesystems.

Default threshold:

```text
DISK_THRESHOLD=85%
```

If filesystem utilization exceeds the threshold, an alert is generated.

### Load Average

The system load average is monitored to identify excessive system workload.

Default threshold:

```text
LOAD_THRESHOLD=4.0
```

### Process Monitoring

The tool identifies the top processes consuming CPU and memory resources.

This helps administrators identify resource-intensive processes.

### Network Monitoring

The tool checks:

* Network interfaces
* IP addresses
* Internet connectivity

Connectivity is tested using a ping request.

### Service Monitoring

Important system services are checked using `systemctl`.

Examples include:

* SSH service
* Firewall service
* NetworkManager

## 4. Logging and Reporting

Monitoring information is stored under:

```text
/var/log/sys_health_monitor/
```

The tool generates:

```text
health_YYYYMMDD.log
report_YYYYMMDD_HHMMSS.txt
```

This provides historical information that can be used for troubleshooting and system analysis.

## 5. Alerting

When a monitored metric exceeds its configured threshold, the tool generates an alert.

Examples:

```text
HIGH CPU USAGE
HIGH MEMORY USAGE
HIGH DISK USAGE
HIGH LOAD AVERAGE
SERVICE NOT RUNNING
```

Email alerting is supported as an optional feature and is disabled by default.

## 6. Automation

The monitoring script can be executed manually:

```bash
./sys_health_monitor.sh
```

It can also run in cron mode:

```bash
./sys_health_monitor.sh --cron
```

Cron can be configured to execute the monitoring script periodically.

## 7. Technologies Used

* Red Hat Enterprise Linux
* Bash Shell Scripting
* Git
* GitHub
* Cron
* systemd
* Linux monitoring utilities

## 8. Main Linux Commands Used

```text
top
free
df
ps
uptime
ip
ping
systemctl
awk
grep
bc
```

## 9. Project Objective

The main objective of this project is to demonstrate practical Linux administration and automation skills by developing a lightweight system monitoring and alerting solution using Bash scripting.
