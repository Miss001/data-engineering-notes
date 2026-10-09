- 1.下载地址
```
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.17.1-linux-x86_64.tar.gz
```
- 2.解压
```
tar -zxvf elasticsearch-8.17.1-linux-x86_64.tar.gz
```
- 3.创建用户
```
useradd elastic
chown -R elastic:elastic /opt/elasticsearch-8.17.1
```
- 4.配置 `.yml` 文件
```
cluster.name: elastic-cluster
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#
node.name: node-1
#
# Add custom attributes to the node:
#
node.attr.rack: r1
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
#
path.data: /opt/elasticsearch-8.17.1/data
#
# Path to log files:
#
path.logs: /opt/elasticsearch-8.17.1/logs
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
#
bootstrap.memory_lock: false
#
# Make sure that the heap size is set to about half the memory available
# on the system and that the owner of the process is allowed to use this
# limit.
#
# Elasticsearch performs poorly when the system is swapping the memory.
#
# ---------------------------------- Network -----------------------------------
#
# By default Elasticsearch is only accessible on localhost. Set a different
# address here to expose this node on the network:
#
network.host: <HOST_IP>
#
# By default Elasticsearch listens for HTTP traffic on the first free port it
# finds starting at 9200. Set a specific HTTP port here:
#
http.port: 9200
transport.tcp.port: 9300

```
- 5.启动
```
su elastic -c"bin/elasticsearch -d" 
```
- 6.重置密码
```
./bin/elasticsearch-reset-password -u elastic -i
```
- 7.访问
```
https://<HOST_IP>:9200/
```
参考连接：      
https://blog.csdn.net/weixin_54106903/article/details/130939114     
https://cloud.tencent.com/developer/article/2455893
