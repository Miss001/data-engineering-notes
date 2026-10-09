## 元数据锁查询
```
select * from mysql.tidb_mdl_view
```
## 释放锁
```
kill session id
```
## 表分布查看
```
show table t1 regions;
```
## 表大小查看
```
select * from INFORMATION_SCHEMA.table_storage_stats where table_schema='mysql'
```
## 慢查询
大于10分钟的SQL查询
```
select * from INFORMATION_SCHEMA.cluster_slow_query where query_time>=600 order by time desc
```
## 正在执行的事务
```
select * from INFORMATION_SCHEMA.cluster_tidb_trx
```
## 显示集群级别的任务
```
select * from INFORMATION_SCHEMA.analyze_status
```
## 显示集群配置变量
```
select * from INFORMATION_SCHEMA.cluster_config WHERE type='tikv' AND `key` LIKE 'coprocessor%'
```
## 显示集群日志
```
select * from INFORMATION_SCHEMA.cluster_log WHERE time>='' and time<='' AND message LIKE '%'
```
