## binlog查询

**（1）查询binlog文件名**

```
show binary logs
```

**（2）根据binlog查询事件**

from 为条件筛选，查询从某个位移之后的事件
```
show binlog events in 'mysql-bin.000005'  from 61601797
```
**（3）清理binglog**

- 删除特定的 Binlog 文件：
```
PURGE BINARY LOGS TO 'mysql-bin.000005';
```

- 删除早于特定时间点的 Binlog 文件：
```
PURGE BINARY LOGS BEFORE 'YYYY-MM-DD HH:MM:SS';
PURGE BINARY LOGS BEFORE DATE_SUB(NOW(), INTERVAL 7 DAY);
```