# docker拉取指定mysql版本镜像

   ```
    docker pull mysql:8.0.23
   ```

# 查看安装的mysql镜像

   ```
    docker images
   ```

# 创建mysql 数据目录和配置文件目录

   ```
   mkdir /opt/docker/mysql8.0.23
   mkdir /opt/docker/mysql8.0.23/mysql32001
   mkdir /opt/docker/mysql8.0.23/mysql32001/conf
   mkdir /opt/docker/mysql8.0.23/mysql32001/data
   
   vim /opt/docker/mysql8.0.23/mysql32001/conf/my.cnf（参考安装包安装步骤配置文件）
   #修改权限：
   chown -R mysql:mysql /opt/docker/mysql8.0.23/mysql32001
   ```

# 启动mysql

   ```
   docker run -d -p 32001:3306 --name mysql32001 --privileged=true \
        -v /opt/docker/mysql8.0.23/mysql32001/conf:/etc/mysql/conf.d \
        -v /opt/docker/mysql8.0.23/mysql32001/logs:/logs \
        -v /opt/docker/mysql8.0.23/mysql32001/data:/var/lib/mysql \
        -v /etc/localtime:/etc/localtime \
        -e MYSQL_ROOT_PASSWORD=<PASSWORD> \
        mysql:8.0.23
   ```

   <!--报错：docker: Error response from daemon: Conflict. The container name "/mysql32001" is already in use by container "33f1d5af46ff0f75b61ea0c2c29f2b94c0f10dc3cdc4a13c678ce968bbb3115d". You have to remove (or rename) that container to be able to reuse that name 原因：已经生成了一个，必须删除再重新执行 docker rm mysql32001-->

# 查看mysql运行情况

   ```
    docker ps –a
   ```

# 登陆mysql

   ```
   docker exec -it mysql32001 /bin/bash
   ```

# docker 停止正在运行的mysql

   ```
    docker stop mysql32001
    #强制停止 
    docker kill mysql32001
   ```

# docker 查看容器日志

   ```
   docker logs mysql32001
   ```

# 登录mysql 

   ```
    mysql -uroot -p<PASSWORD> --socket=/var/lib/mysql/mysql.sock
    #或
    mysql -uroot -p<PASSWORD>
   ```

