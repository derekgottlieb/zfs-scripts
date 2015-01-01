#!/bin/bash

if [ -z $1 ] || [ -z $2 ]; then
  echo "Usage: $0 filesystem remote_server"
  printf "\tExample: $0 tank/photos backup.example.com\n"
  exit
fi

FS=$1
REMOTE_SRVR=$2

FS_EXISTS=$(zfs list | grep -c "^$FS ")
if [[ $FS_EXISTS -eq 0 ]]; then
  echo "ERROR: $FS does not exist"
  exit
fi

LATEST_SNAPSHOT=$(zfs list -t snapshot | grep "$FS" | tail -n 1 | awk '{print $1}')
$(zfs send -p $LATEST_SNAPSHOT 2>/dev/null | ssh -c blowfish root@$REMOTE_SRVR "zfs recv $LATEST_SNAPSHOT 2>/dev/null") 2>/dev/null

