#!/bin/bash
set -e
echo "params $@"
cat /etc/hosts
IP1=$(/sbin/ifconfig eth0 | awk '/inet addr/{print $2}' | cut -d: -f2)
sh -c "serf agent -log-level=debug -event-handler="/serf/serfmount/handler.sh" -node=**`hostname`** -bind=$IP1:7496" >> /serf/logs.txt &
sleep 10
if [ "$1." != "." ]; then
  ip=$(cat /etc/hosts | grep -w "$1" | awk '/ .*/{print $1}' | tr -d '\n')
  echo "joining IP $ip"
  serf join $ip:7496
  tail -f /serf/logs.txt
else
  echo "Pass correct parameters"
fi

tail -f /serf/logs.txt
