#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 /dev/sdX"
  exit 1
fi

BACKUP_DRIVE=$1

parted --script "$BACKUP_DRIVE" mklabel gpt
parted --script "$BACKUP_DRIVE" mkpart primary ext4 0% 100%


PARTITION="${BACKUP_DRIVE}1"

mkfs.ext4 $PARTITION
