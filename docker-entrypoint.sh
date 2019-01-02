#!/bin/bash
set -e

/usr/local/bin/iptables.sh | /sbin/iptables-restore --counters
iptables -L -n -v -t mangle

if [[ "$FW_DISABLE" != "1" ]]; then
  env > /etc/environment
  cronCmd="(/usr/local/bin/iptables.sh | /sbin/iptables-restore --counters)"
  cronJob="0 1 * * * $cronCmd > /proc/1/fd/1 2>/proc/1/fd/2"
  echo "$cronJob" | crontab -
fi

cron -f
