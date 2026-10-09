## hive表查询权限控制

配置hive使用sentry
![image-20211008141431614](（图片待补）)


关闭hive用户模拟功能
![image-20211008141357844](（图片待补）)


添加sentry-site.xml参数
![image-20211008141504559](（图片待补）)


配置hue使用sentry
![image-20211008141539585](（图片待补）)


hdfs配置
![image-20211008143848671](（图片待补）)

       

**配置hive权限**

  ```
  #1.使用hive用户登录
  beeline -u jdbc:hive2://host1:10000 -n hive 

  #创建admin角色
  create role admin; 

  #授权
  grant all on server server1 to role admin; 
  grant role admin to group hive;
  grant role admin to group root;
  
  #2.linux上创建用户（每台节点）
  useradd <ORG>_dw
  chattr -i /etc/passwd
  chattr -i /etc/shadow
  
  3.hive节点上授权
  #创建角色
  create role analyse;
  grant select on server server1 to role analyse; --授予所有表查询权限 
  grant create on database <ORG>_dw to role analyse;--授予创建表权限
  
  #回收权限
  revoke create on database kylin_fact from role analyse;
  
  #授权给用户
  grant role analyse to group <ORG>_dw;
  
  4.hdfs授权
  #查看hive目录权限
  hdfs dfs -getfacl /hive/extwarehouse
  #添加新权限并保留原有权限
  hdfs dfs setfacl -R -m user:<ORG>_dw:r-x /hive/extwarehouse
  
  hdfs dfs setfacl -m group:<ORG>_dw:r-x /hive/extwarehouse
  #删除指定权限并保留原有权限
  hdfs dfs setfacl -R -x user::r-x <ORG>_dw /hive/extwarehouse
  
  #将用户添加到hive组
  usermod -a -G hive <ORG>_dw
  #将用户从hive组删除
  gpasswd -d <ORG>_dw hive
  
  
  ```

**hive 外部表添加sentry控制权限**

创建外部表目录

  ```
  su hdfs -c"hdfs dfs mkdir -p /hive/extwarehouse"
  su hdfs -c"hdfs dfs -chown -R hive:hive /hive"
  su hdfs -c"hdfs dfs -chmod -R 771 /hive"
  ```

页面配置
![image-20211125135749204](（图片待补）)


**解决hive表和字段注释乱码**

在存储元数据的mysql中执行：

```
alter table `columns_v2` modify column `COMMENT` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL;
alter table `table_params` modify column `PARAM_VALUE` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;

```

