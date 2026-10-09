
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
  elasticsearch {
    hosts => ["https://<HOST_IP>:9200"]
    index => "tj_log"
    user => "elastic"
    password => "<PASSWORD>"
    # 关闭证书验证
    ssl => true
    ssl_certificate_verification => false  
    #cacert => "CloudSearchService.cer"
    # 查询语句
    query => '{ "query": { "match_all": {} } }' 
    scroll => "5m"
    docinfo => true
  }
}

output {
   jdbc {
    jdbc_connection_string => "jdbc:mysql://<HOST_IP>:3306/test?characterEncoding=UTF-8&autoReconnect=true"
    jdbc_user => "root"
    jdbc_password => "<PASSWORD>"
    jdbc_driver_library => "/usr/share/logstash/mysql-connector-java-8.0.27.jar"
    jdbc_driver_class => "com.mysql.cj.jdbc.Driver"
    # 查询语句
    statement =>  [
      "INSERT INTO your_table (id, field1, field2) VALUES (?, ?, ?) 
       ON DUPLICATE KEY UPDATE field1=VALUES(field1), field2=VALUES(field2)",
       "id", "field1", "field2"
    ]
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
