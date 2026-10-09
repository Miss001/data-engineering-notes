#!/bin/bash

getfile='cat list.txt'
data=(`${getfile}|awk '{print $NF}'`)

#pyspark
dosomething(){
  spark-submit  --executor-memory 5G main.py default.tmp1 external 2 dt $1
}

for i in ${data[*]}
do
  echo $i
  dosomething $i
done

