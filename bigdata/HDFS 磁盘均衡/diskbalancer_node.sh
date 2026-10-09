#!/bin/bash

hostname=$1  # host1
dates=`date "+%Y-%b-%d-%H-%M"`

su hdfs -c"hdfs diskbalancer -plan ${hostname} "

directory=`hdfs dfs -ls /system/diskbalancer/ |grep $dates | awk '{print $8 }'`
su hdfs -c"hdfs diskbalancer -execute ${directory}/${hostname}.plan.json"


#su hdfs -c"hdfs diskbalancer -query ${hostname}"
