#!/bin/bash

for pool in $(zpool list -H | awk '{print $1}')
do
  NO_SCRUB=$(zpool status $pool | grep -c "scan: none requested")

  if [[ $NO_SCRUB -gt 0 ]]; then
    echo "$pool hasn't been scrubbed yet..."
    continue
  fi
  
  RUNNING=$(zpool status $pool | grep "scan:" | grep -c "in progress")
  if [[ $RUNNING -gt 0 ]]; then
    echo "Scrub for $pool still running... $(zpool status $pool | grep 'to go')"
    continue
  fi

  ERRORS=$(zpool status $pool | grep "scan:" | grep -c -v "with 0 errors")
  if [[ $ERRORS -gt 0 ]]; then
    echo "Scrub detected errors in $pool!"
  fi
done

exit 0
