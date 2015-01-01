#!/bin/bash

for POOL in $(zpool list -H | awk '{print $1}')
do
 echo "$POOL: `zfs list -H $POOL | awk '{print $3}'`"
done
