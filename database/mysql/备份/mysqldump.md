== 命令：mysqldump ==

- `-u=`：连接mysql数据库的用户名

- `-p=`：连接mysql数据库的密码

- `-P=`：连接mysql数据库的端口

- `-h=`：连接mysql数据库的IP

- `--all-databases`：备份所有数据库

- `--triggers`：备份触发器

- `--routines`：备份函数

- `--events `：备份事件

- `--flush-logs`：刷新日志

- `--single-transaction`：事务一致

- `--master-data=2`：增加注释备份所处位移等语句

- `set-gtid-purged=OFF`：gtid模式下不重新生成gtid

- `--databases=`：指定需要备份的数据库名

- `--tables=`：指定需要备份的表名

- `-d`：只导出结构不导出数据

#### 1.2.1 本地备份/恢复 ####

服务器：<HOST_IP>:3306 

本地备份与远程备份无区别，都是通过连接mysql读取数据

##### 1.2.1.1 全量备份/恢复 #####

**备份**

mysql状态：启动

```
#全量备份
mysqldump -h<HOST_IP> -P3306 -uroot -p<PASSWORD> --all-databases  --triggers --routines --events  --flush-logs --single-transaction --master-data=2  >/opt/backup.sql
```

**恢复**

mysql状态：启动

	#恢复全量数据
	mysql -uroot -p<PASSWORD>  </opt/backup.sql
	或
	source  /opt/backup.sql
	
	#查看当前binlog位置
	less /opt/backup.sql #(CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000029', MASTER_LOG_POS=156;)
	
	#拷贝mysql-bin.000029及之后的binlog
	mysqlbinlog --start-position=156  /opt/mysql-bin.000029 > /opt/binlog_bak.sql
	
	#执行sql文件
	mysql -uroot -p<PASSWORD> < /opt/binlog_bak.sql

##### 1.2.1.2 单库备份/恢复

drop database 备份恢复ceshi库的数据

==建议利用新库恢复后将数据导入原来的库或者全备恢复==

**备份**

mysql状态：启动

```
#单库备份
mysqldump -h<HOST_IP> -P3306 -uroot -p<PASSWORD> --databases ceshi  --triggers --routines --events  --flush-logs --single-transaction --master-data=2  >/opt/backup.sql
```

**恢复**

mysql状态：启动

	#刷新日志
	flush binary logs;
	
	#恢复全量数据
	mysql -uroot -p<PASSWORD> ceshi1 </opt/backup.sql
	
	#查看当前binlog位置
	less /opt/backup.sql #(CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000013', MASTER_LOG_POS=156;)
	
	#拷贝mysql-bin.000013至刷新前的所有binlog文件至备份目录
	cp /var/lib/mysql/mysql-bin.000013  /opt/
	
	#查询drop database 事件的位移
	show binlog events in 'mysql-bin.000013';
	
	#获取需要还原的binlog文件以及开始和结束位置 ，将二进制转为sql文件(此处指定数据库若binlog中包含create table ceshi1.tmp1 as select * from ceshi.tmp1此类sql，导出文件会包含ceshi1.tmp1的建表语句)
	mysqlbinlog --database=ceshi --start-position=156 --stop-position=2287 /opt/mysql-bin.000013> /opt/binlog_bak.sql
	
	#执行sql文件，忽略错误
	mysql -uroot -p<PASSWORD> ceshi -f < /opt/binlog_bak.sql

##### 1.2.1.3 单表备份/恢复

drop table 备份恢复ceshi1库tmp1的数据

==建议利用新库恢复后将数据导入原来的库或者全备恢复==

**备份**

mysql状态：启动

```
#单表备份
mysqldump -h<HOST_IP> -P3306 -uroot -p<PASSWORD> --databases ceshi1  --tables tmp1  --flush-logs --single-transaction --master-data=2  >/opt/backup.sql
```

**恢复**

mysql状态：启动

	#刷新日志
	flush binary logs;
	
	#恢复全量数据
	mysql -uroot -p<PASSWORD> ceshi1 </opt/backup.sql
	
	#查看当前binlog位置
	less /opt/backup.sql #(CHANGE MASTER TO MASTER_LOG_FILE='mysql-bin.000015', MASTER_LOG_POS=156;)
	
	#拷贝mysql-bin.000015至刷新前的所有binlog文件至备份目录
	cp /var/lib/mysql/mysql-bin.000015  /opt/
	
	#查询drop database 事件的位移
	show binlog events in 'mysql-bin.000015';
	
	#获取需要还原的binlog文件以及开始和结束位置 ，将二进制转为sql文件
	mysqlbinlog --database=ceshi1 --start-position=156 --stop-position=2246  /opt/mysql-bin.000015> /opt/binlog_bak.sql
	
	#创建一个账号只对tmp1表有增删改查的权限
	CREATE USER 'tmp1'@'localhost' IDENTIFIED BY '<PASSWORD>';
	GRANT select, insert, update, delete, alter  ON ceshi1.tmp1 TO 'tmp1'@'localhost';
	GRANT SESSION_VARIABLES_ADMIN,REPLICATION_APPLIER  ON *.* TO 'tmp1'@'localhost';
	
	#执行sql文件，忽略错误
	mysql -uroot -p<PASSWORD> ceshi1 -f < /opt/binlog_bak.sql

##### 1.2.1.4 表结构备份/恢复

**备份**

mysql状态：启动

```
#结构备份
mysqldump -h<HOST_IP> -P3306 -uroot -p<PASSWORD> -d ceshi  --flush-logs --single-transaction --master-data=2  >/opt/backup.sql
```

**恢复**

mysql状态：启动

	#执行sql文件（包含drop、create语句）
	mysql -uroot -p<PASSWORD> ceshi < /opt/backup.sql

