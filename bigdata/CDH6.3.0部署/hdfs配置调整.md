## hdfs

设置节点存储方式：

```
 dfs.datanode.fsdataset.volume.choosing.policy：可用空间法
 dfs.datanode.available-space-volume-choosing-policy.balanced-space-threshold：1000G 设置开启磁盘预留空间：避免磁盘过小的节点
 dfs.datanode.du.reserved：1000G 设置开启磁盘预留空间：避免磁盘过小的节点
 dfs.datanode.available-space-volume-choosing-policy.balanced-space-preference-fraction:0.75f(默认)
```

hdfs设置 磁盘间均衡 配置开启

```
<property><name>dfs.disk.balancer.enabled</name><value>true</value></property>
<property><name>dfs.disk.balancer.max.disk.throughputInMBperSec</name><value>30</value></property><property><name>dfs.disk.balancer.block.tolerance.percent</name><value>5</value></property>
```

节点上执行命令平衡：

su hdfs -c"hdfs diskbalancer -plan host1"

su hdfs -c"hdfs diskbalancer -execute /system/diskbalancer/2022-Sep-27-09-20-33/host1.plan.json"

su hdfs -c"hdfs diskbalancer -query host1"
