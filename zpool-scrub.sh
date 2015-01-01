#!/bin/bash

for pool in $(zpool list -H | awk '{print $1}')
do
 zpool scrub $pool
done
