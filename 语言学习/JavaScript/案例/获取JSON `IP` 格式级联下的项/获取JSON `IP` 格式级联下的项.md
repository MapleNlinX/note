# 获取JSON \`IP\` 格式级联下的项

如果键值为类似`172.168.1.1`这种IP格式的获取方法

方法一

```javascript
var obj = JSON.parse(text);
var str = "159.203.93.255";
console.log(obj[str].basic.location.city);
```

方法二：

Object.keys()返回`object`上所以可枚举的`key`

```javascript
var obj = JSON.parse(text);
console.log(Object.keys(obj));
console.log(obj[Object.keys(obj)[0]].basic.location.city);

```

方法三：

Reflect.ownKeys()返回所有属性key

```javascript
var obj = JSON.parse(text);
var str = "159.203.93.255";
console.log(Reflect.ownKeys(obj));
console.log(obj[Reflect.ownKeys(obj)].basic.location.city);
```

JSON例子：

```json
{
         "159.203.93.255": {
            "samples": [],
            "tags_classes": [],
            "judgments": [
              "IDC"
            ],
            "intelligences": {
                "threatbook_lab": [
                    {
                        "source": "ThreatBook Labs",
                        "confidence": 70,
                        "expired": false,
                        "intel_tags": [],
                        "find_time": "2016-05-17 20:18:33",
                        "intel_types": [
                            "IDC"
                        ],
                        "update_time": "2016-05-17 20:18:33"
                    },
                    {
                        "source": "ThreatBook Labs",
                        "confidence": 90,
                        "expired": true,
                        "intel_tags": [],
                        "find_time": "2018-05-04 17:56:17",
                        "intel_types": [
                            "IDC"
                        ],
                        "update_time": "2018-08-02 21:02:25"
                    }
                ],
                "x_reward": [],
                "open_source": []
            },
            "scene": "",
            "basic": {
                "carrier": "digitalocean.com",
                "location": {
                    "country": "United States",
                    "province": "New York",
                    "city": "New York City",
                    "lng": "-74.006",
                    "lat": "40.713",
                    "country_code": "US"
                }
            },
            "asn": {
                "rank": 2,
                "info": "DIGITALOCEAN-ASN - DigitalOcean, LLC, US",
                "number": 14061
            },
            "ports": [],
            "cas": [],
            "update_time": "2016-05-17 20:18:33",
            "rdns_list": [],
            "sum_cur_domains": "0"
        }

}
```
