## 升级kylin4

从kylin2.6升级到kylin4.0

**参考文档**

[Deploy Kylin 4 on CDH 6 - Deploy Kylin 4 on CDH 6 - Apache Software Foundation](https://cwiki.apache.org/confluence/display/KYLIN/Deploy+Kylin+4+on+CDH+6)

[Apache Kylin | 从旧版本升级](https://kylin.apache.org/cn/docs31/howto/howto_upgrade.html)

**安装包**

链接：<TOKEN> 
提取码：<TOKEN>

**解压**

```
tar -xzf apache-kylin-4.0.4-bin-spark3.tar.gz
```

**配置环境变量**

vi /etc/profile 

```
export KYLIN_HOME=/home/apache-kylin-2.6.3-bin-cdh60
export PATH=$PATH:${KYLIN_HOME}/bin
```

source /etc/profile

**kylin.properties配置**

```
#### METADATA | ENV ###
kylin.metadata.url=kylin_metadata@jdbc,url=jdbc:mysql://localhost:3306/kylin4,username=root,password=<PASSWORD>,maxActive=10,maxIdle=10
kylin.env.hdfs-working-dir=/kylin4
kylin.env.zookeeper-is-local=false
kylin.env.zookeeper-base-path=/kylin4
kylin.env.zookeeper-connect-string=bigdata1:2181,bigdata2:2181,bigdata3:2181

#### SERVER | WEB | RESTCLIENT ###
kylin.server.mode=all
kylin.server.cluster-servers=kylin-1:7070,kylin-2:7070,kylin-3:7070

#### PUBLIC CONFIG ###
kylin.source.hive.database-for-flat-table=kylin4

#### STORAGE ###
kylin.storage.clean-after-delete-operation=true
kylin.storage.hbase.coprocessor-check=false

###################################
#### SPARK BUILD ENGINE CONFIGS ###
kylin.env.hadoop-conf-dir=/etc/hadoop/conf

kylin.engine.spark-home=/opt/cloudera/parcels/CDH/lib/spark3
kylin.engine.spark-conf.spark.master=yarn
kylin.engine.spark-conf.spark.submit.deployMode=client
kylin.engine.spark-conf.spark.submit=spark3-submit
kylin.engine.spark-conf.spark.yarn.queue=kylin4
kylin.engine.spark-conf.spark.eventLog.dir=hdfs\:///kylin4/spark-history
kylin.engine.spark-conf.spark.history.fs.logDirectory=hdfs\:///kylin4/spark-history
kylin.engine.spark-conf.spark.shuffle.useOldFetchProtocol=true

kylin.query.auto-sparder-context-enabled=true
kylin.query.spark-conf.spark.driver.maxResultSize=1G
kylin.query.spark-conf.spark.sql.hive.metastore.version=2.1.1
kylin.query.spark-conf.spark.sql.hive.metastore.jars=/opt/cloudera/parcels/CDH/lib/hive/lib/*:/opt/cloudera/parcels/CDH/lib/hadoop/*:/opt/cloudera/parcels/CDH/lib/hadoop/lib/*:/opt/cloudera/parcels/CDH/lib/hadoop-hdfs/*:/opt/cloudera/parcels/CDH/lib/hadoop-yarn/*:/opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/*
kylin.engine.spark-conf.spark.sql.hive.metastore.version=2.1.1
kylin.engine.spark-conf.spark.sql.hive.metastore.jars=/opt/cloudera/parcels/CDH/lib/hive/lib/*:/opt/cloudera/parcels/CDH/lib/hadoop/*:/opt/cloudera/parcels/CDH/lib/hadoop/lib/*:/opt/cloudera/parcels/CDH/lib/hadoop-hdfs/*:/opt/cloudera/parcels/CDH/lib/hadoop-yarn/*:/opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/*

```

**/tomcat/conf/server.xml配置（修改端口）**
```
<Server port="9007" shutdown="SHUTDOWN">
<Connector port="7077" protocol="HTTP/1.1"
                   connectionTimeout="20000"
                   redirectPort="7444"
                   compression="on"
                   compressionMinSize="2048"
                   noCompressionUserAgents="gozilla,traviata"
                   compressableMimeType="text/html,text/xml,text/javascript,application/javascript,application/json,text/css,text/plain"
                   URIEncoding="UTF-8"
        />
 <Connector port="7444" protocol="org.apache.coyote.http11.Http11Protocol"
                   maxThreads="150" SSLEnabled="true" scheme="https" secure="true"
                   keystoreFile="conf/.keystore" keystorePass="changeit"
                   clientAuth="false" sslProtocol="TLS" />

</Server>
```

**上传jar包至lib目录**

```
commons-configuration-1.10.jar
hive-exec-1.21.2.3.1.0.0-78.jar
mysql-connector-java-5.1.48.jar
stax2-api-3.1.4.jar
kylin-shaded-guava-3.1.0.jar
```

**上传jar包至tool目录**

```
commons-dbcp-1.4.jar
mysql-connector-java-5.1.48.jar
```

**上传jar包至ext目录**

```
mysql-connector-java-5.1.48.jar
```

**cdh包拷贝**

```
cd /opt/cloudera/parcels/CDH-6.3.0-1.cdh6.3.0.p0.1279813/lib/spark3

cp scala-reflect-2.12.10.jar scala-reflect.jar
cp scala-library-2.12.10.jar  scala-library.jar
```

**conf.cloudera.yarn目录拷贝**

```
cd $KYLIN_HOME
mkdir -p etc/hadoop
ln -s /etc/hadoop/conf.cloudera.yarn  $KYLIN_HOME/etc/hadoop/conf.cloudera.yarn
```

**hive事实表迁移**

1. 查询需要导出结构的表名

   ```
   hive -e"use kylin_fact;show tables;" >> exporttable.txt
   ```

2. 导出表结构

   ```
   #!/bin/bash
   
   cat exporttable.txt |while read eachline
   do
   hive -e"use kylin_fact;show create table $eachline" >> exporttableddl.txt
   echo ";" >> exporttableddl.txt
   done
   ```

3. 导入表结构

   ```
   #增加开头
   use kylin_fact;
   
   #替换hdfs路径
   sed -i 's/hdfs:\/\/master:8020\/var\/hadoop/hdfs:\/\/bigdata2:8020\/user/g' exporttableddl.txt
   
   #执行
   su hive -c"hive -f exporttableddl.txt"
   ```

**旧版kylin元数据导出**

```
cd $KYLIN_HOME
./bin/metastore.sh backup
```
**删除无需迁移文件**

```
rm -rf cube_statistics
rm -rf dict
rm -rf execute
rm -rf execute_output
rm -rf table_acl
rm -rf table_exd
rm -rf table_snapshot
rm -rf user
rm -rf UUID
rm -rf query
rm -rf bad_query
```

**删除segment信息**

vi  cube/xxx.json
```
{

"status":"DISABLED",

"segments":[]

}
```

**kylin元数据导入**

```
./bin/kylin.sh org.apache.kylin.tool.CubeMigrationCLI -srcConfig metadata -dstConfig conf/kylin.properties -allCubes 
```
