#!/bin/bash -l

if [ ! -z "$RANFROMCRON" ]; then
  MAILCMD=$(which mailx)
  rc=$?
  if [[ $rc -ne 0 ]]; then
    MAILCMD=$(which mail)
    rc=$?
    if [[ $rc -ne 0 ]]; then
      echo "ERROR: No mail program detected."
      exit 1
    fi
  fi
fi

OFFLINE_POOL=$(zpool list -H | grep -c -v ONLINE)

# Have to configure DC line to grep for the drive names
#DC=$(zpool status | grep ata | awk '{print $2}' | grep -c -v ONLINE)

if [ $OFFLINE_POOL -ne 0 ]; then
  if [ -z "$RANFROMCRON" ]; then
    echo "WARNING: One or more pools aren't ONLINE!"
    zpool status -v
  else
    zpool status -v | $MAILCMD -s "WARNING: One or more pools aren't ONLINE on `hostname`" root
  fi
fi

# Verify we haven't run out of disk space...
for percent_used in $(zpool list -H | awk '{ print $5 }')
do
  if [ "${percent_used%'%'}" -ge "75" ]; then
    if [ -z "$RANFROMCRON" ]; then
      echo "WARNING: ZFS filesystem filling up"
      zpool list
    else
      zpool list | $MAILCMD -s "WARNING: ZFS filesystem filling up on `hostname`" root
    fi
  fi 
done
