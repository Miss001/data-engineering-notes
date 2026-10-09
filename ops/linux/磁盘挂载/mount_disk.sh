#!/bin/bash

device=$1  # /dev/vdx
folder=$2  # /data/1 

mkdir -p $folder

echo "mklabel gpt
mkpart p1
xfs
0G
-1
quit
"|parted $device

kk="${device}1"

sleep 5

mkfs.xfs -f $kk

sleep 5

mount -o noatime $kk $folder


lines=`cat /etc/fstab | grep --line-number "${folder}" | cut -d: -f1`

sed_line=''
for line in $lines
do 
  sed_line=${sed_line}${line}d';'
done

sed -i ''${sed_line}'' /etc/fstab

echo `blkid $kk | awk '{print $2}' | sed 's/\"//g'` $folder xfs defaults,noatime 0 0 >> /etc/fstab


