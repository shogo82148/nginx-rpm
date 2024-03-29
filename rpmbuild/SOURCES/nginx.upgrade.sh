#!/bin/sh

[ ! -f /var/run/nginx.pid ] && exit 1
echo "Start new nginx master..."
/bin/systemctl kill --signal=SIGUSR2 nginx.service
sleep 5

[ ! -f /var/run/nginx.pid.oldbin ] && sleep 10
if [ ! -f  /var/run/nginx.pid.oldbin ]; then
    echo "Failed to start new nginx master."
    exit 1
fi
echo "Stop old nginx master gracefully..."
oldpid=$(/usr/bin/cat /var/run/nginx.pid.oldbin 2>/dev/null)
/bin/kill -s QUIT "$oldpid" 2>/dev/null
sleep 5
[ -f /var/run/nginx.pid.oldbin ] && sleep 10
if [ -f  /var/run/nginx.pid.oldbin ]; then
    echo "Failed to stop old nginx master."
    exit 1
fi
