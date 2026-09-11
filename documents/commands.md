# Linux Commands Used in the Project

## System Information

### Check RHEL Version

```bash
cat /etc/redhat-release
```

### Check Kernel Version

```bash
uname -r
```

### Check Hostname

```bash
hostname
```

### Check Current User

```bash
whoami
```

---

## CPU Monitoring

### Display CPU Information

```bash
lscpu
```

### Monitor CPU Usage

```bash
top
```

### Check Number of CPU Cores

```bash
nproc
```

---

## Memory Monitoring

### Display Memory Usage

```bash
free -m
```

### Human-readable Memory Usage

```bash
free -h
```

---

## Disk Monitoring

### Display Disk Usage

```bash
df -h
```

### Display Block Devices

```bash
lsblk
```

---

## Process Monitoring

### Display Running Processes

```bash
ps aux
```

### Display Top CPU-consuming Processes

```bash
ps aux --sort=-%cpu | head
```

### Display Top Memory-consuming Processes

```bash
ps aux --sort=-%mem | head
```

---

## Load Monitoring

### Display System Load

```bash
uptime
```

---

## Network Monitoring

### Display Network Interfaces

```bash
ip -brief addr
```

### Display IP Address

```bash
ip addr
```

### Test Internet Connectivity

```bash
ping -c 4 8.8.8.8
```

---

## Service Monitoring

### Check Service Status

```bash
systemctl status sshd
```

### Check Whether Service Is Running

```bash
systemctl is-active sshd
```

### List Running Services

```bash
systemctl --type=service --state=running
```

---

## Log Management

### View Monitoring Logs

```bash
ls -lh /var/log/sys_health_monitor/
```

### View a Log File

```bash
cat /var/log/sys_health_monitor/health_YYYYMMDD.log
```

### Follow Log in Real Time

```bash
tail -f /var/log/sys_health_monitor/health_YYYYMMDD.log
```

---

## File Permissions

### Make Script Executable

```bash
chmod +x scripts/sys_health_monitor.sh
```

### Check Permissions

```bash
ls -l scripts/sys_health_monitor.sh
```

---

## Cron Automation

### Edit User Cron Jobs

```bash
crontab -e
```

### Display Cron Jobs

```bash
crontab -l
```

---

## Git Commands

### Initialize Repository

```bash
git init
```

### Check Repository Status

```bash
git status
```

### Add Files

```bash
git add .
```

### Create Commit

```bash
git commit -m "Add system health monitoring tool"
```

### Add GitHub Remote

```bash
git remote add origin <YOUR_GITHUB_REPOSITORY>
```

### Push to GitHub

```bash
git push -u origin main
```

### View Commit History

```bash
git log --oneline
```
