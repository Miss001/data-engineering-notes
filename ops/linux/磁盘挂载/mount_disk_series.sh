#!/bin/bash

if [ $# -lt 2 ];then
  echo "script needs 2 paramters"
  echo "USAGE: $0 <start device name: example: sdb/vdb>  <device number: example: 12>"
  exit 1  
fi


start_device=$1
device_number=$2

device_prefix=${start_device:0:2}
device_index=${start_device:2:3}

device_list=""

alphabet="a b c d e f g h i j k l m n o p q r s t u v w x y z"

begin=0
for i in $alphabet; do
  if [ "$i" == "$device_index" ];then
       break
   fi
   ((begin=$begin+2))
done

echo $begin
sub_alphabet=${alphabet:$begin}
echo $sub_alphabet

index=1
for i in $sub_alphabet
do
  /load/script/mount_disk.sh /dev/$device_prefix$i /data/$index >> /tmp/mount.log 2>&1
  echo "mount /dev/$device_prefix$i to /data/$index"
  ((index=index+1))
  if [ $index -gt $device_number ]; then
     break
  fi 
  sleep 5
done
