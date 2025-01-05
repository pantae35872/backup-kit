#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 /dev/sdX"
  exit 1
fi

mkdir -p /mnt/backup
mount $1 /mnt/backup
sfdisk -d /dev/nvme0n1 > /mnt/backup/partition_table
vgcfgbackup -f /mnt/backup/volgroup_backup
fsarchiver savefs /mnt/backup/lv_root.fsa /dev/mapper/volgroup0-lv_root
fsarchiver savefs /mnt/backup/lv_home.fsa /dev/mapper/volgroup0-lv_home
fsarchiver savefs /mnt/backup/lv_swap.fsa /dev/mapper/volgroup0-lv_swap
umount /mnt/backup
rm -r /mnt/backup
