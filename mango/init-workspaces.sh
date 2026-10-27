#!/bin/sh
# Seed the monitor/tag pairing after both outputs are ready.
i=0
while [ "$i" -lt 50 ]; do
    if mmsg get all-monitors >/dev/null 2>&1; then
        mmsg dispatch viewcrossmon,1,DP-1
        mmsg dispatch viewcrossmon,2,DP-2
        mmsg dispatch focusmon,DP-1
        exit 0
    fi
    i=$((i + 1))
    sleep 0.1
done
