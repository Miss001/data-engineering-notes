# elasticsearch
```
docker pull docker.elastic.co/elasticsearch/elasticsearch:8.17.1
docker run --name es01 --net host -p 9200:9200 -it -m 1GB docker.elastic.co/elasticsearch/elasticsearch:8.17.1

#修改密码
docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic
docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana

#访问：
docker cp es01:/usr/share/elasticsearch/config/certs/http_ca.crt .
curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD https://localhost:9200
```

# kibana
```
docker pull docker.elastic.co/kibana/kibana:8.17.1
docker run --name kib01 --net host -p 5601:5601 docker.elastic.co/kibana/kibana:8.17.1
#生成token
docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana
```

# logstash
```
docker pull docker.elastic.co/logstash/logstash:8.17.1 
docker run --rm -it -v ~/settings/logstash.yml:/usr/share/logstash/config/logstash.yml docker.elastic.co/logstash/logstash:8.17.1

```


