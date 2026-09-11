# 🛡️ Linux System Health Monitoring & Alerting

<p align="center">
  <strong>Automated Infrastructure Health Monitoring for Red Hat Enterprise Linux</strong>
</p>

<p align="center">
  <em>Monitor • Detect • Alert • Report • Automate</em>
</p>

<p align="center">

![RHEL](https://img.shields.io/badge/RHEL-Enterprise%20Linux-red?style=for-the-badge\&logo=redhat\&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-Scripting-black?style=for-the-badge\&logo=gnu-bash\&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-System%20Administration-yellow?style=for-the-badge\&logo=linux\&logoColor=black)
![Git](https://img.shields.io/badge/Git-Version%20Control-orange?style=for-the-badge\&logo=git\&logoColor=white)
![Cron](https://img.shields.io/badge/Cron-Automation-blue?style=for-the-badge)

</p>

---

## 📌 About The Project

**Linux System Health Monitoring & Alerting** is a lightweight infrastructure monitoring solution built with **Bash Shell Scripting** for **Red Hat Enterprise Linux (RHEL)**.

The project automates common Linux administrator tasks by collecting system-health metrics, evaluating resource utilization against configurable thresholds, identifying resource-intensive processes, checking network connectivity and critical services, and generating timestamped reports.

Instead of manually executing multiple Linux commands to understand server health, this project provides a **single automated health-check workflow**.

> **From manual server inspection → automated infrastructure visibility.**

---

## 🎯 Problem Statement

Linux administrators frequently need to monitor:

* CPU utilization
* Memory consumption
* Disk capacity
* System load
* Resource-heavy processes
* Network availability
* Critical services

Performing these checks manually across multiple servers can become repetitive and inefficient.

### 💡 Solution

This project combines commonly used Linux administration utilities into one automated monitoring script.

```text
              Linux Server
                   │
                   ▼
        ┌─────────────────────┐
        │ Health Monitor      │
        │ Bash Script         │
        └──────────┬──────────┘
                   │
       ┌───────────┼───────────┐
       ▼           ▼           ▼
      CPU        Memory       Disk
       │           │           │
       └───────────┼───────────┘
                   │
       ┌───────────┼───────────┐
       ▼           ▼           ▼
      Load      Network     Services
                   │
                   ▼
          Threshold Analysis
                   │
          ┌────────┴────────┐
          ▼                 ▼
       HEALTHY             ALERT
          │                 │
          └────────┬────────┘
                   ▼
          Logs + Reports
```

---

# ✨ Core Capabilities

### 🧠 Resource Monitoring

* CPU utilization monitoring
* Memory utilization monitoring
* Filesystem/disk utilization
* System load average
* CPU and memory intensive processes

### 🌐 Infrastructure Monitoring

* Network interface status
* IP address information
* Internet connectivity
* Critical Linux service status

### 🚨 Alerting

* Threshold-based alerts
* High CPU detection
* High memory detection
* High disk utilization detection
* High system load detection
* Network connectivity failure detection
* Service availability detection

### 📊 Reporting

* Timestamped health reports
* Daily monitoring logs
* System information
* Resource utilization
* Process information
* Service status

### ⚙️ Automation

* Manual execution
* Cron-compatible execution
* Silent monitoring mode
* Automated log/report generation

## The current implementation supports normal execution and a `--cron` silent mode intended for scheduled jobs.

# 🏗️ Architecture

```text
                         ┌──────────────────────┐
                         │    RHEL SERVER       │
                         └──────────┬───────────┘
                                    │
                                    ▼
                    ┌───────────────────────────┐
                    │ sys_health_monitor.sh     │
                    └─────────────┬─────────────┘
                                  │
          ┌───────────────────────┼───────────────────────┐
          │                       │                       │
          ▼                       ▼                       ▼
    ┌───────────┐           ┌───────────┐          ┌───────────┐
    │ Resources │           │ Processes │          │ Network   │
    │ CPU/RAM   │           │ CPU/MEM   │          │ & Services│
    │ Disk/Load │           │ Top 5     │          │           │
    └─────┬─────┘           └─────┬─────┘          └─────┬─────┘
          │                       │                      │
          └───────────────────────┼──────────────────────┘
                                  ▼
                     ┌────────────────────────┐
                     │ Threshold Evaluation   │
                     └───────────┬────────────┘
                                 │
                    ┌────────────┴────────────┐
                    ▼                         ▼
              ┌───────────┐             ┌───────────┐
              │  HEALTHY  │             │   ALERT   │
              └─────┬─────┘             └─────┬─────┘
                    │                         │
                    └────────────┬────────────┘
                                 ▼
                     ┌────────────────────────┐
                     │ Logs & Reports         │
                     │ /var/log/...           │
                     └────────────────────────┘
```

---

# 📊 Monitoring Matrix

| Component | Metric           | Default Threshold | Action           |
| --------- | ---------------- | ----------------: | ---------------- |
| CPU       | Utilization      |               80% | Generate alert   |
| Memory    | Utilization      |               80% | Generate alert   |
| Disk      | Filesystem usage |               85% | Generate alert   |
| Load      | 1-minute load    |               4.0 | Generate alert   |
| Processes | CPU usage        |             Top 5 | Report           |
| Processes | Memory usage     |             Top 5 | Report           |
| Network   | Connectivity     |      Reachability | Alert on failure |
| Services  | Active state     |           Running | Alert/status     |

The default thresholds are defined in the current script as CPU 80%, memory 80%, disk 85%, and load 4.0.

---

# 🔍 Monitoring Components

## CPU Monitoring

The script calculates CPU utilization and compares the result against the configured threshold.

```text
CPU Usage
Number of CPU Cores
Threshold Evaluation
Alert Generation
```

---

## Memory Monitoring

Memory statistics are collected using Linux memory information and converted into a utilization percentage.

```text
Total Memory
      ↓
Used Memory
      ↓
Memory Utilization %
      ↓
Threshold Check
```

---

## Disk Monitoring

Filesystem utilization is collected using `df`.

```text
Filesystem
    │
    ├── Mount Point
    ├── Used Space
    ├── Available Space
    └── Utilization %
```

Each monitored filesystem is evaluated against the disk threshold.

---

## Load Average

The system's:

```text
1 Minute
5 Minutes
15 Minutes
```

load averages are recorded.

The 1-minute load average is evaluated against the configured threshold.

---

## Process Analysis

The tool identifies the **top 5 CPU-consuming processes** and **top 5 memory-consuming processes**.

Example:

```text
PID     COMMAND       %CPU    %MEM
-----------------------------------
1234    process-A     45.2    12.3
2345    process-B     28.7     8.4
```

---

# 🌐 Network Monitoring

The project collects network interface information using:

```bash
ip -brief addr show
```

Internet connectivity is checked using a controlled ping request.

```text
Network Interface
       ↓
IP Information
```
