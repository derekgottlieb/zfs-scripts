#!/bin/bash

LOCK=/tmp/$(basename $0).lock

if [[ ! -z $LOCK ]]; then
  echo "ERROR:$LOCK found"
  exit
fi
touch $LOCK

pools=$(zpool list -H | awk '{print $1}')

for pool in $pools
do
 zpool scrub $pool
done

# wait until all scrubs are finished
while [[ $(zpool status $pool | grep "scan:" | grep -c "in progress") -gt 0 ]]
do
  sleep 900
done

# scrubs should be completed, check for errors
for pool in $pools
do
  ERRORS=$(zpool status $pool | grep "scan:" | grep -c -v "with 0 errors")
  if [[ $ERRORS -gt 0 ]]; then
    echo "Scrub detected errors in $pool!"
  fi
done

rm -f $LOCK 
exit 0
