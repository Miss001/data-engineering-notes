import pyspark
from pyspark.sql import SparkSession
from pyspark.sql.functions import concat_ws
import sys

if __name__ == '__main__':
    tableName = sys.argv[1] #表名
    tableType = sys.argv[2] #表类型（外部表或内部表）
    process = int(sys.argv[3]) #线程
    pt_str = sys.argv[4] #分区字段
    pt = sys.argv[5] #分区值

    spark = SparkSession \
        .builder \
        .appName('MergeFile_' + tableName + '_' + pt) \
        .enableHiveSupport() \
        .getOrCreate()
    spark.conf.set('spark.yarn.jars', 'hdfs:///sparkjars/*.jar')
    spark.sparkContext.setLogLevel('WARN')
    #拼接路径
    if tableType == 'external':
        db = tableName.split('.')[0]
        orgTableName = tableName.split('.')[1]
        origin_table_path = f"hdfs:///user/hive/warehouse/{db}/{orgTableName}/{pt}"
    else:
        db = tableName.split('.')[0] + '.db'
        orgTableName = tableName.split('.')[1]
        origin_table_path = f"hdfs:///user/hive/warehouse/{db}/{orgTableName}/{pt_str}={pt}"
    tmp_path = f"hdfs:///tmp/{db}/{orgTableName}/"

    #读取数据保存至临时文件
    df = spark.sql(f"select * from {tableName} where {pt_str}='{pt}'").drop(f"{pt_str}")
    df.rdd.map(lambda row: "\t".join([str(elem) for elem in row])).coalesce(process).saveAsTextFile(tmp_path)

    # 文件导入覆盖原表
    spark.read.option("delimiter","\t").text(tmp_path).write.mode("overwrite").text(origin_table_path)

    # #临时文件清理
    hadoop_conf = spark._jsc.hadoopConfiguration()
    spark.sparkContext._gateway.jvm.org.apache.hadoop.fs.FileSystem.get(hadoop_conf).delete(spark.sparkContext._jvm.org.apache.hadoop.fs.Path(tmp_path), True)

    spark.catalog.clearCache()
    spark.stop()
    #  spark-submit  --executor-memory 5G main.py default.tmp1 external 2 dt 000000

