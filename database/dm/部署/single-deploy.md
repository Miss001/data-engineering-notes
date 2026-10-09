# 创建用户
```
groupadd dinstall
useradd-g dinstall dmdba
passwd dmdba
```
# 创建目录
```
#安装目录
mkdir /opt/dm8
chown dmdba:dinstall -R /opt/dm8/

#设置TMP临时目录：
su dmdba
mkdir-p /home/dmdba/tmp
##设置环境变量
vi /home/dmdba/.bash_profile
export DM_INSTALL_TMPDIR=/home/dmdba/tmp
source /home/dmdba/.bash_profile
```

# 挂载镜像
```
mount -o loop dm8_20241227_x86_rh7_64.iso  /mnt
```

# 安装
```
su dmdba
cd /mnt
./DMInstall.bin  -i
#等待安装完成后切换至root用户执行
/opt/dm8/script/root/root_installer.sh
```

# 创建数据库实例
```
su dmdba
cd /opt/dm8/bin
./dminit DB_NAME=PROD INSTANCE_NAME=TEST PORT_NUM=5237 PATH=/opt/dm8/data SYSDBA_PWD=<PASSWORD> SYSAUDITOR_PWD=<PASSWORD>
```

# 注册数据库服务
```
./script/root/dm_service_installer.sh -t dmserver -p TEST -dm_ini /opt/dm8/data/PROD/dm.ini
```

# 启动数据库
```
su dmdba
cd /opt/dm8/bin
./DmServiceTEST start
```

# 连接
```
su dmdba
cd /opt/dm8/
./tool/disql
connect sysdba@<HOST_IP>:5237
```
