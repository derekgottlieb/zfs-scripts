#!/bin/bash

non_4k_pools=$(zdb | grep ashift | grep -v "12" | wc -l)

if [[ $non_4k_pools -gt 0 ]]; then
  echo "WARNING: Some pools incompatible with advanced format 4K-sector drives!"
fi

zdb | grep ashift
