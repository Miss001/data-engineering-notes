# 主服务器

```
#查看状态
show global variables like '%gtid_mode%';
show global variables like '%enforce_gtid_consistency%';

#修改状态（主从分别执行完才能进行下一步）
set global enforce_gtid_consistency =warn;

#查看日志确认无警告后执行
set global enforce_gtid_consistency = on;
set global gtid_mode = off_permissive;
set global gtid_mode=on_permissive;

#检查
show status like '%ongoing_anonymous_transaction_count%'; 都为0才可执行下一步
flush logs;

#开启gtid
set global gtid_mode=on;

#修改配置my.cnf
gtid_mode = on
enforce-gtid-consistency=on
```

# 从服务器

```
#停止复制
stop slave;

#查看状态
show global variables like '%gtid_mode%';
show global variables like '%enforce_gtid_consistency%';

#修改状态（主从分别执行完才能进行下一步）
set global enforce_gtid_consistency =warn;

#查看日志确认无警告后执行
set global enforce_gtid_consistency = on;
set global gtid_mode = off_permissive;
set global gtid_mode=on_permissive;

#检查
show status like '%ongoing_anonymous_transaction_count%'; 都为0才可执行下一步
flush logs;

#开启gtid
set global gtid_mode=on;

#设置主链路
change master to master_auto_position=1;

#开启复制
start slave;
```

主从服务器修改配置my.cnf

```
#开启gtid
gtid_mode = on
enforce-gtid-consistency=on
```
