#!/bin/bash

# ps aux | grep "mariach" | grep -v "vscode" | awk '{print $2}' | xargs -t kill

ps aux | grep "mariach" | grep -v grep | grep "run.sh" | awk '{print $2}'  | xargs -t kill
ps aux | grep "mariach" | grep -v grep | grep "run_cgexec.sh" | awk '{print $2}' | xargs -t kill
xargs -a /sys/fs/cgroup/memory/memlim/cgroup.procs kill

# Get process IDs using jps
process_ids=$(jps | grep -v Jps | awk '{print $1}')


# Loop through each process ID and kill it
for pid in $process_ids; do
    if [ "$pid" != "$$" ]; then
        echo "Killing process with ID: $pid"
        kill -9 "$pid"
    else
        echo "Skipping self (script's PID): $pid"
    fi
done