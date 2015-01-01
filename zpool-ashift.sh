#!/bin/bash

non_4k_pools=$(zdb | grep ashift | grep -v "12" | wc -l)

if [[ $non_4k_pools -gt 0 ]]; then
  echo "WARNING: Some pools incompatible with advanced format 4K-sector drives!"
fi

echo "##### List of zpools and ashift setting per child vdev #####"
zdb | grep -E " name|ashift"

echo -e "\nNOTE: An ashift of 12 is desirable for 4K-sector drives, but may be 9 if ZFS detected 512b-sector drives"
