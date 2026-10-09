# 检查环境删除已有安装包
```
rpm -qa |grep mariadb
rpm -e --nodeps mariadb-libs-5.5.56-2.el7.x86_64
find / -name mysql
rm -rf /usr/local/mysql  #安装文件
rm -rf /var/lib/mysql    #数据文件 
rm -rf /etc/my.cnf       #配置文件文件
```

# 下载地址
[https://downloads.mysql.com/archives/community/](https://downloads.mysql.com/archives/community/mysql-8.0.23-linux-glibc2.12-x86_64.tar.xz)

# 解压文件
```
tar -Jxf mysql-8.0.23-linux-glibc2.12-x86_64.tar.xz
mv mysql-8.0.23-linux-glibc2.12-x86_64 /usr/local/mysql
mkdir -p /var/lib/mysql
```

# 编辑配置文件my.cnf
略

# 新建用户授权
```
groupadd mysql
useradd -g mysql mysql
chown -R mysql:mysql /usr/local/mysql
chown -R mysql:mysql /var/lib/mysql
```

# 初始化mysql
```
cd /usr/local/mysql
./bin/mysqld --defaults-file=/etc/my.cnf --initialize  --user=mysql --datadir=/var/lib/mysql --basedir=/usr/local/mysql
```

# 启动mysql
```
cp /usr/local/mysql/support-files/mysql.server  /etc/init.d/mysqld
service mysqld start
```

# 修改登陆密码
```
#获取临时密码 A temporary password is generated for root@localhost: <PASSWORD>
tail -1000f /var/lib/mysql/error.log 
#登陆mysql
mysql -uroot -p
#修改当前用户密码
alter user user() identified by '<PASSWORD>';
#修改用户远程访问权限
use mysql;
update user set host = '%' where user = 'root';
flush privileges;
#授权
grant all privileges  on *.*  to 'root'@'%' with grant option;
#修改密码
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '<PASSWORD>';
#刷新
flush privileges;
```
#
