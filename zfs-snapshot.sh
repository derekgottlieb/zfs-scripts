#!/bin/bash

if [[ -z $1 ]]; then
  echo "Usage: $0 filesystem"
  printf "\tExample: $0 tank/photos\n"
  exit
fi

FS=$1

FS_EXISTS=$(zfs list | grep -c "^$FS ")
if [[ $FS_EXISTS -eq 0 ]]; then
  echo "ERROR: $FS does not exist"
  exit
fi

SNAP=$(date +%F_%H%M%S)

zfs snapshot ${FS}@${SNAP}
