#!/usr/bin/env bash

while sleep 10 2> /dev/null; do
	#uptime > /tmp/tiempo
       sudo sysctl -w vm.drop_caches=3 2> /dev/null
       sync ; echo 3 > /proc/sys/vm/drop_caches > /tmp/tiempo
done
