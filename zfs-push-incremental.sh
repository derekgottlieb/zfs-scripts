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

FS_NO_SLASHES=$(echo "$FS" | sed -e 's/\//-/g')

mkdir -p /var/log/zfs
LOG=/var/log/zfs/${FS_NO_SLASHES}_${REMOTE_SRVR}_`date +%F_%H%M`.log

LATEST_LOCAL=$(zfs list -t snapshot | grep ${FS} | tail -n 1 | awk '{print $1}')

LATEST_REMOTE=$(ssh $REMOTE_SRVR zfs list -t snapshot | grep ${FS} | tail -n 1 | awk '{print $1}')

if [ "$LATEST_LOCAL" != "$LATEST_REMOTE" ]; then
  if [ ! "$RANFROMCRON" = "yes" ]; then
    echo "$LATEST_LOCAL ($HOSTNAME) != $LATEST_REMOTE ($REMOTE_SRVR)"
  fi

  LOCAL_SNAP=$(echo $LATEST_LOCAL | cut -d@ -f2)
  REMOTE_SNAP=$(echo $LATEST_REMOTE | cut -d@ -f2)

  echo "zfs send -R -I @${REMOTE_SNAP} ${FS}@${LOCAL_SNAP} | ssh root@${REMOTE_SRVR} zfs receive -Fv ${FS}" > $LOG
  zfs send -R -I @${REMOTE_SNAP} ${FS}@${LOCAL_SNAP} | ssh -c blowfish root@${REMOTE_SRVR} zfs receive -Fv ${FS} >> $LOG
else
  if [ ! "$RANFROMCRON" = "yes" ]; then
    echo "$LATEST_LOCAL ($HOSTNAME) = $LATEST_REMOTE ($REMOTE_SRVR)" 
  fi
fi
