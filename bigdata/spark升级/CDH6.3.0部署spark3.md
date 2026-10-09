# 九 组件升级

## 1) spark版本升级

从spark2升级到spark3.1.1，版本与kylin4使用的版本兼容

**参考链接**

[spark3.3.1 for CDH6.3.2 打包_spark3 cdh6.3.2-CSDN博客](https://blog.csdn.net/qq_36610426/article/details/127997188)

[CDH6.3.2 升级 Spark3.3.0 版本 - 掘金 (juejin.cn)](https://juejin.cn/post/7140053569431928845)

**环境准备**

| 组件  | 版本                          |
| ----- | ----------------------------- |
| java  | jdk1.8.0_91                   |
| scala | scala-2.12.18.tgz             |
| maven | apache-maven-3.6.3-bin.tar.gz |
| spark | spark-3.1.1.tgz               |

**源码下载**

[Index of /dist/spark/spark-3.1.1 (apache.org)](https://archive.apache.org/dist/spark/spark-3.1.1/)

**编译**

进入spark目录下

```
./dev/make-distribution.sh \
--name 3.0.0-cdh6.3.0 --tgz  -Pyarn -Phadoop-3.0 \
-Phive -Phive-thriftserver -Dhadoop.version=3.0.0-cdh6.3.0 -X
```

**编译安装包地址**

链接：<TOKEN> 
提取码：<TOKEN>

**升级**

（1）安装

```
tar -zxvf spark-3.1.1-bin-3.0.0-cdh6.3.0.tgz -C /opt/cloudera/parcels/CDH/lib
cd /opt/cloudera/parcels/CDH/lib
mv spark-3.1.1-bin-3.0.0-cdh6.3.0/ spark3
```

（2）修改配置文件

​    将 原集群的 spark-env.sh 复制到 /opt/cloudera/parcels/CDH/lib/spark3/conf 下

```
cp /etc/spark/conf/spark-env.sh  /opt/cloudera/parcels/CDH/lib/spark3/conf
chmod +x /opt/cloudera/parcels/CDH/lib/spark3/conf/spark-env.sh

#修改 spark-env.sh
vi /opt/cloudera/parcels/CDH/lib/spark3/conf/spark-env.sh

export SPARK_HOME=/opt/cloudera/parcels/CDH/lib/spark3
```

   将 hive-site.xml 复制到 spark3/conf 目录下，不需要做变动

```
cp /etc/hive/conf/hive-site.xml /opt/cloudera/parcels/CDH/lib/spark3/conf/
```
   将 yarn_conf 复制到 spark3/conf 目录下，不需要做变动

```
cp /opt/cloudera/parcels/CDH/lib/spark/conf/yarn_conf /opt/cloudera/parcels/CDH/lib/spark3/conf/yarn_conf
```
   将 yarn-site.xml 复制到 spark3/conf 目录下，不需要做变动

```
cp /opt/cloudera/parcels/CDH/lib/spark/conf/yarn_conf/yarn-site.xml /opt/cloudera/parcels/CDH/lib/spark3/conf/yarn-site.xml
```
   将 hdfs-site.xml 复制到 spark3/conf 目录下，不需要做变动

```
cp /opt/cloudera/parcels/CDH/lib/spark/conf/yarn_conf/hdfs-site.xml /opt/cloudera/parcels/CDH/lib/spark3/conf/hdfs-site.xml
```
（3）配置conf

```
cd /opt/cloudera/parcels/CDH/lib/spark3/conf
## 开启日志
mv log4j2.properties.template log4j2.properties
## spark-defaults.conf 配置
cp /opt/cloudera/parcels/CDH/lib/spark/conf/spark-defaults.conf ./

## 修改 spark-defaults.conf
vi /opt/cloudera/parcels/CDH/lib/spark3/conf/spark-defaults.conf
# 删除
spark.extraListeners
spark.sql.queryExecutionListeners
spark.yarn.jars
# 添加 
spark.yarn.jars=hdfs:///spark3jar/*
spark.sql.hive.metastore.version=2.1.1
spark.sql.hive.metastore.jars=/opt/cloudera/parcels/CDH/lib/hive/lib/*

##上传jar包至hdfs
hadoop fs -mkdir -p /spark3jar
cd /opt/cloudera/parcels/CDH/lib/spark3/jars
hadoop fs -put *.jar /spark3jar
```

（4）创建spark3_submit

cp /opt/cloudera/parcels/CDH/bin/spark-submit.sh  spark3-submit.sh  </br>
vi /opt/cloudera/parcels/CDH/bin/spark3-submit.sh

```
#!/usr/bin/env bash
SOURCE="${BASH_SOURCE[0]}"
BIN_DIR="$( dirname "$SOURCE" )"
while [ -h "$SOURCE" ]
do
 SOURCE="$(readlink "$SOURCE")"
 [[ $SOURCE != /* ]] && SOURCE="$BIN_DIR/$SOURCE"
 BIN_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
done
BIN_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
LIB_DIR=/opt/cloudera/parcels/CDH/lib
export HADOOP_HOME=$LIB_DIR/hadoop

# Autodetect JAVA_HOME if not defined
. $LIB_DIR/bigtop-utils/bigtop-detect-javahome

# disable randomized hash for string in Python 3.3+
export PYTHONHASHSEED=0

exec $LIB_DIR/spark3/bin/spark-class org.apache.spark.deploy.SparkSubmit "$@"
```

（5）创建spark3_sql

cp /opt/cloudera/parcels/CDH/bin/spark-sql.sh  spark3-sql.sh  </br>
vi /opt/cloudera/parcels/CDH/bin/spark3-sql.sh

```
#!/usr/bin/env bash
SOURCE="${BASH_SOURCE[0]}"
BIN_DIR="$( dirname "$SOURCE" )"
while [ -h "$SOURCE" ]
do
 SOURCE="$(readlink "$SOURCE")"
 [[ $SOURCE != /* ]] && SOURCE="$BIN_DIR/$SOURCE"
 BIN_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
done
BIN_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
LIB_DIR=$BIN_DIR/../lib
export HADOOP_HOME=$LIB_DIR/hadoop

# Autodetect JAVA_HOME if not defined
. $LIB_DIR/bigtop-utils/bigtop-detect-javahome

exec $LIB_DIR/spark3/bin/spark-submit --class org.apache.spark.sql.hive.thriftserver.SparkSQLCLIDriver "$@"
```

（6）创建快捷方式

```
chmod +755 /opt/cloudera/parcels/CDH/bin/spark3-submit
alternatives --install /usr/bin/spark3-submit spark3-submit /opt/cloudera/parcels/CDH/bin/spark3-submit 1
chmod +755 /opt/cloudera/parcels/CDH/bin/spark3-sql
alternatives --install /usr/bin/spark3-sql spark3-sql /opt/cloudera/parcels/CDH/bin/spark3-sql 1
```

（7）配置环境变量
vi /etc/profile

```
export SPARK2_HOME=/opt/cloudera/parcels/CDH/lib/spark
export SPARK3_HOME=/opt/cloudera/parcels/CDH/lib/spark3
alias use_spark2="export SPARK_HOME=$SPARK2_HOME"
alias use_spark3="export SPARK_HOME=$SPARK3_HOME"
use_spark2
export PATH=$SPARK_HOME/bin:$PATH
```
（8）测试
```
spark3_sql
```

（9）同步至其他节点

