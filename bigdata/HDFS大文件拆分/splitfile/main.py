import pyspark
from pyspark.sql import SparkSession
import sys
if __name__ == '__main__':
    origin_file=sys.argv[1]
    dest_file=sys.argv[2]
    process=int(sys.argv[3])

    spark = SparkSession \
        .builder \
        .appName('SplitFile_task') \
        .enableHiveSupport() \
        .getOrCreate()
    spark.conf.set('spark.yarn.jars', 'hdfs:///sparkjars/*.jar')
    spark.sparkContext.setLogLevel('WARN')

    df=spark.read.option("delimiter","\t").text("hdfs://"+origin_file)
    df.coalesce(process).write.mode("overwrite").save(dest_file)

    # spark-submit --executor-memory 5G main.py /tmp/origin.txt /tmp/dest.txt 4