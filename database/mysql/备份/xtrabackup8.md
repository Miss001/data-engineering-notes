==命令：xtrabackup==

- `--defaults-file=`：my.cnf 的路径
- `--socket=`：mysql.sock 的路径
- `--datadir=`：mysql数据文件的路径
- `--user=`：连接mysql数据库的用户名
- `--password=`：连接mysql数据库的密码
- `--port=`：连接mysql数据库的端口
- `--host=`：连接mysql数据库的IP
- `--backup`：备份（指定操作为备份操作）
- `--target-dir=`：备份的文件名
- `--databases`或`--databases-file =`：单个库备份是指定需要备份的数据库(mysql sys performance_schema恢复时需要使用因此需要一起备份)
- `--tables`或`--tables-file= `：单表备份时指定需要备份的表名
- `--parallel=`：指定并行数
- `--stream=xbstream`：指定流式备份
- `--compress`：压缩
- `--incremental-basedir=`：增量备份时指定上一次备份的文件路径
- `--prepare`：恢复备份时准备备份文件
- `--export `：单库单表恢复时指定export
- `--apply-log-only`：增量恢复时除了最后一次其余增量需指定
- `--incremental-dir=`：增量恢复时指定增量备份的文件名



#### 1.1.1 软件安装 ####

下载地址 ： [https://www.percona.com/downloads/Percona-XtraBackup-LATEST/#](https://www.percona.com/downloads/Percona-XtraBackup-LATEST/# "percona-xtrabackup-80-8.0.23-16.1.el7.x86_64.rpm")

yum安装

    yum -y install percona-xtrabackup-80-8.0.23-16.1.el7.x86_64.rpm
    
    #若报错需要安装关联包:
    rpm -ivh libev-4.15-1.el6.rf.x86_64.rpm
    rpm -ivh libev-4.15-1.el6.rf.x86_64.rpm
    yum -y install perl-DBI
    yum -y install perl perl-devel libaio libaio-devel perl-Time-HiRes perl-DBD-MySQL
    yum -y install perl-Digest-MD5

检查是否安装成功

    rpm -qa | grep -i xtrabackup


压缩依赖安装：

  下载地址：[http://www.quicklz.com/](http://www.quicklz.com/ "qpress-11-linux-x64.tar")

  解压安装

    tar xvf qpress-11-linux-x64.tar
    cp qpress /usr/bin/



#### 1.1.2 本地备份/恢复 ####


服务器：<HOST_IP>:3306 


所有命令均在该服务器上执行

##### 1.1.2.1 全量备份/恢复 #####

**备份**

mysql状态：启动

```
#全量备份
xtrabackup --defaults-file=/etc/my.cnf  --socket=/tmp/mysql.sock  --user=bak --password=<PASSWORD> --host=<HOST_IP> --port=3306  --backup --target-dir=/opt/bak --parallel=2
```

**恢复**

mysql状态：关闭

    #准备备份-使用全量备份文件
    xtrabackup --defaults-file=/etc/my.cnf  --prepare --target-dir=/opt/bak --parallel=2
    
    #查看备份的binlog的position 
    cat /opt/bak/xtrabackup_binlog_info   #(mysql-bin.000014   156)
    
    #拷贝mysql-bin.000014及之后的binlog文件至备份目录
    cp /var/lib/mysql/mysql-bin.000014  /opt/
    
    #清空mysql数据文件
    rm -rf /var/lib/mysql/*
    
    #恢复备份-将备份文件移入mysql数据文件中
    rsync -avrP /opt/bak/* --exclude='xtrabackup*' /var/lib/mysql/
    
    #修改文件所属
    chown -R mysql:mysql /var/lib/mysql
    
    #开启mysql服务
    service mysqld start
    
    #获取需要还原的binlog文件以及开始和结束位置 ，将二进制转为sql文件
    mysqlbinlog --start-position=156  /opt/mysql-bin.000014 > /opt/binlog_bak.sql
    
    #执行sql文件
    mysql -uroot -p<PASSWORD> < /opt/binlog_bak.sql


##### 1.1.2.2 增量备份/恢复 #####

**备份**

mysql状态：启动

    #全量备份
    xtrabackup --defaults-file=/etc/my.cnf  --socket=/tmp/mysql.sock  --user=bak --password=<PASSWORD> --host=<HOST_IP> --port=3306  --backup --target-dir=/opt/bak --parallel=2
    
    #第一次增量备份
    #增加--incremental-basedir(指定上一次全量备份的文件)
    xtrabackup --defaults-file=/etc/my.cnf  --socket=/tmp/mysql.sock  --user=bak --password=<PASSWORD> --host=<HOST_IP> --port=3306  --backup --incremental-basedir=/opt/bak  --target-dir=/opt/bak_ict1 --parallel=2
    
    #第二次增量备份
    #增加--incremental-basedir(指定上一次增量备份的文件)
    xtrabackup --defaults-file=/etc/my.cnf  --socket=/tmp/mysql.sock  --user=bak --password=<PASSWORD> --host=<HOST_IP> --port=3306   --backup --incremental-basedir=/opt/bak_ict1  --target-dir=/opt/bak_ict2  --parallel=2

**恢复**

mysql状态：关闭

    #准备第一次全量数据
    xtrabackup --defaults-file=/etc/my.cnf  --socket=/tmp/mysql.sock  --user=bak --password=<PASSWORD> --host=<HOST_IP> --port=3306  --prepare --apply-log-only --target-dir=/opt/bak  --parallel=2
    
    #准备第一次增量数据
    xtrabackup --defaults-file=/etc/my.cnf  --socket=/tmp/mysql.sock  --user=bak --password=<PASSWORD> --host=<HOST_IP> --port=3306  --prepare --apply-log-only --target-dir=/opt/bak   --incremental-dir=/opt/bak_ict1 --parallel=2
    
    # 准备第二次（最后一次）增量数据
    xtrabackup --defaults-file=/etc/my.cnf  --socket=/tmp/mysql.sock  --user=bak --password=<PASSWORD> --host=<HOST_IP> --port=3306 --prepare --target-dir=/opt/bak   --incremental-dir=/opt/bak_ict2 --parallel=2
    
    #查看最后一次增量备份的binlog的position 
    cat /opt/bak/xtrabackup_binlog_info   #(mysql-bin.000005	   156)
    
    #拷贝mysql-bin.000005及之后的binlog文件至备份目录
    cp /var/lib/mysql/mysql-bin.000005  /opt/
    
    #清空mysql数据文件
    rm -rf /var/lib/mysql/*
    
    #恢复备份-将备份文件移入mysql数据文件中
    rsync -avrP /opt/bak/* --exclude='xtrabackup*' /var/lib/mysql/
    
    #修改文件所属
    chown -R mysql:mysql /var/lib/mysql
    
    #开启mysql服务
    service mysqld start
    
    #获取需要还原的binlog文件以及开始和结束位置 ，将二进制转为sql文件
    mysqlbinlog --start-position=156 --stop-position=935  mysql-bin.000005 > /opt/binlog_bak.sql
    
    #执行sql文件
    mysql -uroot -p<PASSWORD> < /opt/binlog_bak.sql

##### 1.1.2.3 单库备份/恢复

drop database 备份恢复ceshi库的数据

==建议利用新库恢复后将数据导入原来的库或者全备恢复==

**备份**

mysql状态：启动

```
#指定数据库备份
xtrabackup --defaults-file=/etc/my.cnf  --socket=/tmp/mysql.sock  --user=bak --password=<PASSWORD> --host=<HOST_IP> --port=3306  --databases='mysql sys performance_schema ceshi' --backup --target-dir=/opt/bak --parallel=2

#导出ceshi库的表
mysqldump  -d --databases ceshi --triggers --routines --events --single-transaction --master-data=2 -uroot  -p<PASSWORD>  > /opt/backup.sql
```

**恢复**

mysql状态：启动

    #刷新日志
    flush binary logs;
    
    #创建数据库
    create database ceshi;
    
    #导入ceshi库所有表结构
    mysql -uroot -p<PASSWORD>  ceshi </opt/backup.sql
    
    #删除ceshi库所有表空间文件
    ##构建批量sql语句：select concat('ALTER TABLE ' ,table_schema,'.',table_name,' DISCARD TABLESPACE; ' )from information_schema.`TABLES` where table_schema='ceshi'
    ALTER TABLE ceshi.tmp1 DISCARD TABLESPACE;  ###（ 若报错：Cannot delete or update a parent row: a foreign key constraint fails () 则设置 set foreign_key_checks=0  完成后设置set foreign_key_checks=1）
    
    #准备备份-使用全量备份文件
    xtrabackup --defaults-file=/etc/my.cnf  --prepare --export --target-dir=/opt/bak --parallel=2
    
    #查看备份的binlog的position 
    cat /opt/bak/xtrabackup_binlog_info   #(mysql-bin.000003   156)
    
    #拷贝mysql-bin.000003至刷新前的所有binlog文件至备份目录
    cp /var/lib/mysql/mysql-bin.000003  /opt/
    
    #恢复备份-将备份文件移入mysql数据文件中
    rsync -avrP  /opt/bak/ceshi/*.ibd  /var/lib/mysql/ceshi/
    
    #修改文件所属
    chown -R mysql:mysql /var/lib/mysql/ceshi
    
    #导入ceshi库所有表空间文件
    ##构建sql执行：select concat('ALTER TABLE ' ,table_schema,'.',table_name,' IMPORT TABLESPACE; ' )from information_schema.`TABLES` where table_schema='ceshi'
    ALTER TABLE ceshi.tmp1 IMPORT TABLESPACE;
    
    #查询drop database 事件的位移
    show binlog events in 'mysql-bin.000003';
    
    #获取需要还原的binlog文件以及开始和结束位置 ，将二进制转为sql文件(此处指定数据库若binlog中包含create table ceshi1.tmp1 as select * from ceshi.tmp1此类sql，导出文件会包含ceshi1.tmp1的建表语句)
    mysqlbinlog --database=ceshi --start-position=156 --stop-position=1345 /opt/mysql-bin.000003> /opt/binlog_bak.sql
    
    #执行sql文件，忽略错误
    mysql -uroot -p<PASSWORD> ceshi -f < /opt/binlog_bak.sql

##### 1.1.2.4 单表备份/恢复

drop table 备份恢复ceshi1库tmp1表的数据

==建议利用新库恢复后将数据导入原来的库或者全备恢复==

**备份**

mysql状态：启动

```
#指定表备份
xtrabackup --defaults-file=/etc/my.cnf  --socket=/tmp/mysql.sock  --user=bak --password=<PASSWORD> --host=<HOST_IP> --port=3306  --tables='^ceshi1[.]tmp1' --backup --target-dir=/opt/bak --parallel=2

#导出ceshi库的tmp1表结构
mysqldump  -d --databases ceshi1 --tables tmp1 --single-transaction --master-data=2 -uroot  -p<PASSWORD>  > /opt/backup.sql
```

**恢复**

mysql状态：启动

    #刷新日志
    flush binary logs;
    
    #导入ceshi库tmp1表结构
    mysql -uroot -p<PASSWORD>  ceshi1 </opt/backup.sql
    
    #删除ceshi库所有表空间文件
    ALTER TABLE ceshi1.tmp1 DISCARD TABLESPACE;  ###（ 若报错：Cannot delete or update a parent row: a foreign key constraint fails () 则设置 set foreign_key_checks=0  完成后设置set foreign_key_checks=1）
    
    #准备备份-使用全量备份文件
    xtrabackup --defaults-file=/etc/my.cnf  --prepare --export --target-dir=/opt/bak --parallel=2
    
    #查看备份的binlog的position 
    cat /opt/bak/xtrabackup_binlog_info   #(mysql-bin.000010   156)
    
    #拷贝mysql-bin.000010至刷新前的所有binlog文件至备份目录
    cp /var/lib/mysql/mysql-bin.000010  /opt/
    
    #恢复备份-将备份文件移入mysql数据文件中
    rsync -avrP  /opt/bak/ceshi1/*.ibd  /var/lib/mysql/ceshi1/
    
    #修改文件所属
    chown -R mysql:mysql /var/lib/mysql/ceshi1
    
    #导入ceshi库所有表空间文件
    ALTER TABLE ceshi1.tmp1 IMPORT TABLESPACE;
    
    #查询drop table 事件的位移
    show binlog events in 'mysql-bin.000010';
    
    #获取需要还原的binlog文件以及开始和结束位置 ，将二进制转为sql文件
    mysqlbinlog --database=ceshi1 --start-position=156 --stop-position=2126 /opt/mysql-bin.000010 > /opt/binlog_bak.sql
    ###过滤tmp1表:grep -A4 -B2 -w '`ceshi1`.`tmp1`' -A是显示匹配后和它后面的n行;-B是显示匹配行和它前面的n行(由于实际情况无法确定匹配语句前几行或后几行才是正确的，因此过滤表有可能会造成数据错误风险，建议不采用过滤表的方式)
    
    #创建一个账号只对tmp1表有增删改查的权限
    CREATE USER 'tmp1'@'localhost' IDENTIFIED BY '<PASSWORD>';
    GRANT select, insert, update, delete, alter  ON ceshi1.tmp1 TO 'tmp1'@'localhost';
    GRANT SESSION_VARIABLES_ADMIN,REPLICATION_APPLIER  ON *.* TO 'tmp1'@'localhost';
    
    #执行sql文件，忽略错误
    mysql -uroot -p<PASSWORD> ceshi1 -f < /opt/binlog_bak.sql



#### 1.1.3 本地备份发送至远程服务器 ####

本地服务器：<HOST_IP>:3306 

远程服务器：<HOST_IP>:3306 

两台服务器均安装 xtrabackup；本地服务器能ssh上远程服务器

##### 1.1.3.1 全量备份/恢复 #####

**备份**

	#远程服务器创建备份文件夹
	mkdir -p /opt/bak
	
	#本地服务器执行备份
	xtrabackup --defaults-file=/etc/my.cnf  --socket=/tmp/mysql.sock  --user=bak --password=<PASSWORD> --host=<HOST_IP> --port=3306  --compress  --stream=xbstream  --backup --target-dir=/opt/bak --parallel=2 | ssh root@<HOST_IP> "xbstream -x  -C /opt/bak"

**恢复**

mysql状态：关闭

在远程服务器执行以下命令

    #解压缩-使用全量备份文件
    xtrabackup --decompress  --remove-original --target-dir=/opt/bak --parallel=2
    
    #准备备份
    xtrabackup  --prepare --target-dir=/opt/bak --parallel=2
    
    #查看最后一次增量备份的binlog的position 
    cat /opt/bak/xtrabackup_binlog_info   #(mysql-bin.000017   156)
    
    #拷贝mysql-bin.000017及之后的binlog文件至备份目录（本地服务器执行）
    scp -r mysql-bin.000017 @<HOST_IP>:/opt/
    
    #清空mysql数据文件
    rm -rf /var/lib/mysql/*
    
    #恢复备份-将备份文件移入mysql数据文件中
    rsync -avrP /opt/bak/* --exclude='xtrabackup*' /var/lib/mysql/
    
    #修改文件所属
    chown -R mysql:mysql /var/lib/mysql
    
    #开启mysql服务
    service mysqld start
    
    #获取需要还原的binlog文件以及开始和结束位置 ，将二进制转为sql文件
    mysqlbinlog  --start-position=156  /opt/mysql-bin.000017 > /opt/binlog_bak.sql
    
    #执行sql文件
    mysql -uroot -p<PASSWORD> < /opt/binlog_bak.sql


##### 1.1.3.2 增量备份/恢复 #####

**备份**

mysql状态：开启

--target-dir 指向本地路径，实际并不存储数据

--extra-lsndir 只存放此次备份的xtrabackup_checkpoints文件

--incremental-basedir 指向前一次的extra-lsndir目录

	#远程服务器创建备份文件夹
	mkdir -p /opt/bak/ql
	
	#本地服务器执行全量备份
	xtrabackup --defaults-file=/etc/my.cnf  --socket=/tmp/mysql.sock  --user=bak --password=<PASSWORD> --host=<HOST_IP> --port=3306  --compress  --stream=xbstream  --backup --extra-lsndir=/opt/bak/ql --target-dir=/opt/bak/data --parallel=2 | ssh root@<HOST_IP> "xbstream -x  -C /opt/bak/ql"
	
	#远程服务器创建备份文件夹
	mkdir -p /opt/bak/zl1
	
	#本地服务器执行第一次增量备份
	xtrabackup --defaults-file=/etc/my.cnf  --socket=/tmp/mysql.sock  --user=bak --password=<PASSWORD> --host=<HOST_IP> --port=3306  --compress  --stream=xbstream  --backup --extra-lsndir=/opt/bak/zl --incremental-basedir=/opt/bak/ql --target-dir=/opt/bak/data --parallel=2 | ssh root@<HOST_IP> "xbstream -x  -C /opt/bak/zl1"
	
	#远程服务器创建备份文件夹
	mkdir -p /opt/bak/zl2
	
	#本地服务器执行第二次（最后一次）增量备份
	xtrabackup --defaults-file=/etc/my.cnf  --socket=/tmp/mysql.sock  --user=bak --password=<PASSWORD> --host=<HOST_IP> --port=3306  --compress  --stream=xbstream  --backup --extra-lsndir=/opt/bak/zls --incremental-basedir=/opt/bak/zl --target-dir=/opt/bak/data --parallel=2 | ssh root@<HOST_IP> "xbstream -x  -C /opt/bak/zl2"

**恢复**

mysql状态：关闭

以下命令均在远程服务器执行

	#解压缩-使用全量备份文件
	xtrabackup --decompress  --remove-original --target-dir=/opt/bak/ql --parallel=2
	
	#解压缩-使用第一次增量备份文件
	xtrabackup --decompress  --remove-original --target-dir=/opt/bak/zl1 --parallel=2
	
	#解压缩-使用第二次（最后一次）增量备份文件
	xtrabackup --decompress  --remove-original --target-dir=/opt/bak/zl2 --parallel=2
	
	#准备第一次全量数据
	xtrabackup  --prepare --apply-log-only --target-dir=/opt/bak/ql --parallel=2
	
	#准备第一次增量数据
	xtrabackup  --prepare --apply-log-only --target-dir=/opt/bak/ql --incremental-dir=/opt/bak/zl1 --parallel=2
	
	# 准备第二次（最后一次）增量数据
	xtrabackup  --prepare --target-dir=/opt/bak/ql --incremental-dir=/opt/bak/zl2 --parallel=2
	
	#查看最后一次增量备份的binlog的position 
	cat /opt/bak/ql/xtrabackup_binlog_info   #(mysql-bin.000021	   156)
	
	#拷贝mysql-bin.000021及之后的binlog文件至备份目录（本地服务器执行）
	scp -r /var/lib/mysql/mysql-bin.000021 @<HOST_IP>:/opt/
	
	#清空mysql数据文件
	rm -rf /var/lib/mysql/*
	
	#恢复备份-将备份文件移入mysql数据文件中
	rsync -avrP /opt/bak/ql/* --exclude='xtrabackup*' /var/lib/mysql/
	
	#修改文件所属
	chown -R mysql:mysql /var/lib/mysql
	
	#开启mysql服务
	service mysqld start
	
	#获取需要还原的binlog文件以及开始和结束位置 ，将二进制转为sql文件
	mysqlbinlog --start-position=156  /opt/mysql-bin.000021 > /opt/binlog_bak.sql
	
	#执行sql文件
	mysql -uroot -p<PASSWORD> < /opt/binlog_bak.sql



#### 1.1.4 远程备份/恢复--报错 ####

本地服务器：<HOST_IP>:3306 

远程服务器：<HOST_IP>:3306  

远程服务器安装 xtrabackup 

##### 1.1.4.1 全量备份/恢复 #####

**备份**

	#远程服务器创建备份文件夹
	mkdir -p /opt/bak
	
	#拷贝本地服务器的/etc/my.cnf 至远程服务器
	scp -r /etc/my.cnf root@<HOST_IP>:/etc/my.cnf
	
	#远程服务器执行备份
	xtrabackup --defaults-file=/etc/my.cnf  --socket=/tmp/mysql.sock  --user=bak --password=<PASSWORD> --host=<HOST_IP> --port=3306  --backup --target-dir=/opt/bak --parallel=2

远程服务器未安装mysql的报错情况：
![五1 1 4 1 1](https://github.com/user-attachments/assets/0ad051bd-de82-4cd7-9549-ce422566adb6)

远程服务器已安装mysql的报错情况：
![五1 1 4 1 2](https://github.com/user-attachments/assets/ffae79cf-07a8-4e93-93cd-8bbe6b6e8cc9)


