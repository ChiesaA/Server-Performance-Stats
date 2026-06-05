#!/usr/bin/env bash

set -euo pipefail

print_title() {
  echo
  echo "========================================"
  echo "$1"
  echo "========================================"
}

print_title "SERVER PERFORMANCE STATS"

echo "Hostname: $(hostname)"
echo "Date:     $(date)"

print_title "OS VERSION"

if [ -f /etc/os-release ]; then
  . /etc/os-release
  echo "${PRETTY_NAME:-Unknown Linux}"
else
  uname -a
fi

print_title "UPTIME & LOAD AVERAGE"

uptime

print_title "LOGGED IN USERS"

who || true

print_title "TOTAL CPU USAGE"

CPU_USAGE=$(
  top -bn1 | awk '
    /Cpu\(s\)|%Cpu/ {
      for (i = 1; i <= NF; i++) {
        if ($i ~ /id/) {
          idle=$(i-1)
          gsub(",", "", idle)
          printf "%.2f", 100 - idle
          exit
        }
      }
    }
  '
)

if [ -n "${CPU_USAGE:-}" ]; then
  echo "CPU Used: ${CPU_USAGE}%"
else
  echo "CPU Used: Unable to calculate"
fi

print_title "MEMORY USAGE"

free -h

MEM_INFO=$(free | awk '/Mem:/ {
  used=$3
  total=$2
  free=$4
  percent=used/total*100
  printf "Used: %.2f GB | Free: %.2f GB | Usage: %.2f%%", used/1024/1024, free/1024/1024, percent
}')

echo "$MEM_INFO"

print_title "DISK USAGE"

df -h --total | awk '
  $1 == "total" {
    print "Used: " $3 " | Free: " $4 " | Usage: " $5
  }
'

echo
df -h --exclude-type=tmpfs --exclude-type=devtmpfs

print_title "TOP 5 PROCESSES BY CPU USAGE"

ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head -n 6

print_title "TOP 5 PROCESSES BY MEMORY USAGE"

ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%mem | head -n 6

print_title "FAILED LOGIN ATTEMPTS"

if command -v lastb >/dev/null 2>&1; then
  if [ -r /var/log/btmp ]; then
    lastb | head -n 10 || true
  else
    echo "No permission to read /var/log/btmp. Try running with sudo."
  fi
else
  echo "lastb command not found."
fi

print_title "DONE"
