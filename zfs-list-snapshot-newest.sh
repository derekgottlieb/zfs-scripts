#!/bin/bash

if [[ -z $1 ]]; then
  echo "Usage: $0 filesystem"
  exit
fi

FS=$1

FS_EXISTS=$(zfs list | grep -c "^$FS ")

if [[ $FS_EXISTS -eq 0 ]]; then
  echo "ERROR: $FS doesn't exist"
  exit
fi

zfs list -t snapshot | grep $fs | tail -n 1
