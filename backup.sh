#!/bin/bash

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 /dev/sdX"
  exit 1
fi

mkdir -p /mnt/backup
mount $1 /mnt/backup
sfdisk -d /dev/nvme0n1 > /mnt/backup/partition_table
vgcfgbackup -f /mnt/backup/volgroup_backup
fsarchiver savefs -j16 -v -o /mnt/backup/lv_root.fsa /dev/mapper/volgroup0-lv_root -A
fsarchiver savefs -j16 -v -o /mnt/backup/efi_partition_p1.fsa /dev/nvme0n1p1 -A
fsarchiver savefs -j16 -v -o /mnt/backup/boot_partition_p2.fsa /dev/nvme0n1p2 -A
mkdir -p /mnt/backup/home
fsarchiver savefs -j16 -s 8000 -v -o /mnt/backup/home/lv_home.fsa /dev/mapper/volgroup0-lv_home -A 
umount /mnt/backup
rm -r /mnt/backup
