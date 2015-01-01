#!/bin/bash

echo "##### ZFS Compression Setting #####"
zfs get compress

echo -e "\n##### ZFS Compression Ratios #####"
zfs get compressratio
