# 创建目录
```
mkdir -p /opt/elasticsearch/logstash/pipeline
mkdir -p /opt/elasticsearch/logstash/data
chmod 777 /opt/elasticsearch/logstash/pipeline
chmod 777 /opt/elasticsearch/logstash/data
```

# 配置logstash.conf
vi /opt/elasticsearch/logstash/pipeline/logstash.conf
```
input {
  jdbc {
    jdbc_connection_string => "jdbc:mysql://<HOST_IP>:3306/test?characterEncoding=UTF-8&autoReconnect=true"
    jdbc_user => "root"
    jdbc_password => "<PASSWORD>"
    jdbc_driver_library => "/usr/share/logstash/mysql-connector-java-8.0.27.jar"
    jdbc_driver_class => "com.mysql.cj.jdbc.Driver"
    # 查询语句
    statement => "SELECT id, task_name, task_desc, bz, 
                  date_format(begin_time,'%Y-%m-%d %H:%i:%s') as begin_time, 
                  date_format(end_time,'%Y-%m-%d %H:%i:%s') as end_time 
                  FROM tj_log 
                  WHERE end_time > :sql_last_value 
                  ORDER BY end_time ASC"
    # statement_filepath => "mysqlquery.sql"

  
    # 记录增量同步字段（必须是时间字段）
    tracking_column => "end_time"

    # 记录上次同步的时间
    last_run_metadata_path => "/usr/share/logstash/data/last_run.txt"

    # 记录上次同步字段的值
    use_column_value => true
    tracking_column_type => "timestamp"
    
    # 开启分页查询，提高查询效率
    jdbc_paging_enabled => "true"
    jdbc_page_size => "500"
    
    # 同步频率 (每分钟同步一次)
    schedule => "* * * * *"

    # 调试模式 (可选)
    sql_log_level => "warn"

  }
}

output {
  elasticsearch {
    hosts => ["https://<HOST_IP>:9200"]
    index => "tj_log"
    user => "elastic"
    password => "<PASSWORD>"
    # 关闭证书验证
    ssl => true
    ssl_certificate_verification => false  
    #cacert => "CloudSearchService.cer"
    document_id => "%{id}"
  }
  stdout {
    codec => json_lines
  }
}
```

# 启动
```
docker run -d --name mysql2es \
  -v /opt/elasticsearch/logstash/pipeline:/usr/share/logstash/pipeline \
  -v /opt/elasticsearch/logstash/mysql-connector-java-8.0.27.jar:/usr/share/logstash/mysql-connector-java-8.0.27.jar \
  -v /opt/elasticsearch/logstash/data:/usr/share/logstash/data \
  --network host \
  docker.elastic.co/logstash/logstash:8.17.1

```
