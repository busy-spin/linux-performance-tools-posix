#!/bin/sh

num_of_workers=$1
cpu_count=$(nproc)

bind_list=""

for i in $(seq 1 "$cpu_count"); do
  if [ $(( i % 2 )) -ne 0 ]; then
        if [ "$bind_list" = "" ]; then
           bind_list="$i"
        else
           bind_list="$bind_list,$i"
        fi
  fi
done

echo "Number of stress workers $num_of_workers , bind list $bind_list"
stress --cpu $num_of_workers &
sleep 1
pgrep -P $! | xargs -I {} echo "taskset -pc 1 {}"
