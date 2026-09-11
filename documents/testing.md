# System Health Monitoring Tool - Testing

## 1. Testing Objective

The purpose of testing is to verify that the monitoring script correctly collects system information, detects abnormal conditions, generates alerts, creates reports, and records logs.

## 2. Environment

| Component         | Configuration            |
| ----------------- | ------------------------ |
| Operating System  | Red Hat Enterprise Linux |
| Shell             | Bash                     |
| Platform          | VMware Virtual Machine   |
| Monitoring Method | Bash Script              |
| Automation        | Cron                     |
| Version Control   | Git                      |

## 3. Functional Tests

### Test 1 - Script Execution

**Command:**

```bash
./scripts/sys_health_monitor.sh
```

**Expected Result:**

The script executes successfully and displays system health information.

**Status:** PASS

---

### Test 2 - CPU Monitoring

**Objective:** Verify CPU utilization monitoring.

**Expected Result:**

The script displays the current CPU utilization and checks it against the configured threshold.

**Status:** PASS

---

### Test 3 - Memory Monitoring

**Objective:** Verify memory utilization monitoring.

**Expected Result:**

The script displays memory usage percentage and generates an alert if the threshold is exceeded.

**Status:** PASS

---

### Test 4 - Disk Monitoring

**Objective:** Verify filesystem utilization.

**Command:**

```bash
df -h
```

**Expected Result:**

The script identifies filesystems with high disk utilization.

**Status:** PASS

---

### Test 5 - Process Monitoring

**Objective:** Identify high CPU and memory consuming processes.

**Expected Result:**

The script displays the top CPU-consuming and memory-consuming processes.

**Status:** PASS

---

### Test 6 - Network Monitoring

**Objective:** Verify network interface and connectivity monitoring.

**Commands:**

```bash
ip -brief addr
ping -c 2 8.8.8.8
```

**Expected Result:**

Network interfaces and connectivity status are displayed.

**Status:** PASS

---

### Test 7 - Service Monitoring

**Objective:** Check important system services.

**Command:**

```bash
systemctl status sshd
```

**Expected Result:**

The monitoring script identifies whether configured services are running.

**Status:** PASS

---

### Test 8 - Alert Generation

**Objective:** Verify that threshold alerts are generated.

**Method:**

Temporarily reduce a monitoring threshold and execute the script.

Example:

```bash
CPU_THRESHOLD=1
```

**Expected Result:**

A CPU alert should be generated when the actual CPU usage exceeds the temporary threshold.

**Status:** PASS

---

### Test 9 - Log Generation

**Objective:** Verify that monitoring logs are created.

**Command:**

```bash
ls -lh /var/log/sys_health_monitor/
```

**Expected Result:**

Log files and reports are generated.

**Status:** PASS

---

### Test 10 - Cron Automation

**Objective:** Verify automatic execution using cron.

**Command:**

```bash
crontab -l
```

**Expected Result:**

The monitoring script is configured to execute periodically.

**Status:** PASS

## 4. Test Result

The System Health Monitoring Tool successfully performs system monitoring, threshold checking, logging, reporting, and automated execution.

All major functional components were tested in the RHEL environment.
