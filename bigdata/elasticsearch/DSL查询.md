## range范围查询
字段类型为： <br>
integer_range <br>
float_range <br>
long_range <br>
double_range <br>
date_range <br>
ip_range <br>
```
{
	"query": {
		"bool": {
			"must": [
                                 {"range":{"num":{"gte":10,"lte":100}}}
				]
			}
		}
	}
```
```
{
	"query": {
		"bool": {
			"must": [
                                 {"range":{"timestamp" : {
				                "gte": "2015-01-01 00:00:00", 
				                "lt": "2016-01-01 00:00:00",
                                                "format": "yyyy-MM-dd HH:mm:ss"
				                "time_zone": "+01:00"
				            }
					}
				   }
				]
			}
		}
	}
```
## script范围查询
字段类型为: keyword
```
{
	"query": {
		"bool": {
			"must": [{
					"script": {
						"script": "
					  	if (doc['je'].size() > 0 && doc['je'].value != \"\" && Float.parseFloat(doc['je'].value)>=100 && Float.parseFloat(doc['je'].value)<=500) {return true}
							else {return false}
							"
						}
					}
				]
			}
		}
	}
```
字段类型为: date
```
{
	"query": {
		"bool": {
			"must": [{
					"script": {
						"script": "
					  	if (doc['kssj'].size() == 0 ) {return new Date().getTime()> doc['jssj'].value.getMillis()}
						else {return doc['kssj'].value.getMillis() > doc['jssj'].value.getMillis()}
						"
						}
					}
				]
			}
		}
	}
```
