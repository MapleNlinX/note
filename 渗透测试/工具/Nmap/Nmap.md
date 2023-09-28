# Nmap

## Nmap扫描参数

| 参数(注意区分大小写)     | 说明                                                |
| --------------- | ------------------------------------------------- |
| -sT             | TCP connect()扫描，这种方式会在目标主机的日志中记录大批连接请求和错误信息。      |
| -sS             | 半开扫描，很少有系统能把它记入系统日志。不过，需要Root权限。                  |
| -sF  -sN        | 秘密FIN数据包扫描、Xmas Tree、Null扫描模式                     |
| -sP             | ping扫描，Nmap在扫描端口时，默认都会使用ping扫描，只有主机存活，Nmap才会继续扫描。 |
| -sU             | UDP扫描，但UDP扫描是不可靠的                                 |
| -sA             | 这项高级的扫描方法通常用来穿过防火墙的规则集                            |
| -sV             | 探测端口服务版本                                          |
| -Pn             | 扫描之前不需要用ping命令，有些防火墙禁止ping命令。可以使用此选项进行扫描          |
| -v              | 显示扫描过程，推荐使用                                       |
| -h              | 帮助选项，是最清楚的帮助文档                                    |
| -p              | 指定端口，如“1-65535、1433、135、22、80”等                   |
| -O              | 启用远程操作系统检测，存在误报                                   |
| -A              | 全面系统检测、启用脚本检测、扫描等                                 |
| -oN -oX&#xA;-oG | 将报告写入文件，分别是正常、XML、grepable 三种格式                   |
| -T4             | 针对TCP端口禁止动态扫描延迟超过10ms                             |
| -iL             | 读取主机列表，例如，“-iL C:\ip.txt”                         |

## 基础用法

### 1、扫描单个目标

nmap ip

```纯文本
如：nmap 192.168.0.101
```

### 2、扫描多个目标

nmap ip1 ip2 适用于目标地址不再同一个网段或在同一网段不连续且数量不多的情况。

```纯文本
如：nmap 192.168.0.101 192.168.0.110
```

### 3、扫描一个范围内的目标

nmap xxx.xxx.xxx.xxx-xxx

```纯文本
如：nmap 192.168.0.100-110
```

### 4、扫描目标地址所在某网段

namp xxx.xxx.xxx.xxx/xx

```纯文本
如：nmap 192.168.0.1/24
```

### 5、扫描包含主机列表的文件中的所有地址

nmap -iL&#x20;

```纯文本
如：nmap -iL /root/target.txt
```

### 6、扫描除了一个目标地址之外的所有地址

nmap ip段 -exclude 被排除的ip

```纯文本
如：nmap 192.168.0.100-110 -exclude 192.168.0.103
   nmap 192.168.0.1/24 -exclude 192.168.0.103 
```

### 7、扫描除了某一个文件中的地址之外的所有地址

nmap ip段 -excludefile \<file path>

```纯文本
如：nmap 192.168.0.100-110 -excludefile /root/targets.txt
   nmap 192.168.0.1/24 -excludefile /root/targets.txt
```

### 8、扫描目标地址的指定端口

nmap ip -p 端口1，端口2，端口3……

```纯文本
如:nmap 192.168.0.101 -p 80,8080,3306,3389
```

### 9、对目标地址进行路由跟踪

nmap --traceroute ip

```纯文本
如：nmap --traceroute 192.168.0.101
```

### 10、扫描目标地址C段的在线主机

nmap -sP ip段

```纯文本
如：nmap -sP 192.168.0.1/24
```

### 11、扫描目标地址进行操作系统版本

nmap -O ip

```纯文本
如：nmap -O 192.168.0.101
```

### 12、扫描目标所开放的全部端口（半开式）

nmap -sS -p 端口号-多个用逗号(，)隔开 -v ip

```纯文本
如：nmap -sS -p 1-65535 192.168.0.101
```

### 13、扫描目标地址开放服务(端口)版本

nmap -sV ip

```纯文本
如：nmap -sV 192.168.0.101
```

### 14、探测防火墙

nmap -sF -T4 ip

```纯文本
如：nmap -sF -T4 192.168.0.101
```

### 15、绕过防火墙进行全面扫描

nmap -Pn -A ip

```纯文本
如：nmap -Pn -A 192.168.0.101
```

## 进阶用法

> 💡nmap --script=xx 使用某个脚本进行扫描

### 1、弱口令扫描

nmap --script=auth ip 对某个主机或某网段主机的应用进行弱口令检测

```纯文本
如：nmap --script=auth 192.168.0.101
```

### 2、暴力破解

nmap --script=brute ip 可以对胡句酷、MB、SNMP等进行简单的暴力破解

```纯文本
如：nmap --script=brute 192.168.0.101
```

### 3、扫描常见漏洞

nmap --script=vuln ip

```纯文本
如：nmap --script=vuln 192.168.0.101
```

### 4、使用脚本进行应用服务扫描

nmap --script=xxx ip 对常见应用服务进行扫描 如：VNC、MySQL、Telnet、Rync等服务

```纯文本
如VNC服务：nmap --script=realvnc-auth-bypass 192.168.0.101
```

### 5、探测局域网内服务开放情况

nmap -n -p 端口号 --script=broadcast ip

```纯文本
如：nmap -n -p 80,3306 --script=broadcast 192.168.0.101
```

### 6、Whois解析

nmap -script external url

```纯文本
如：nmap -script external baidu.com
```

### 7、扫描Web敏感目录

nmap -p 80 --script=http-enum.nse ip

```纯文本
nmap -p 80 --script=http-enum.nse 192.168.0.101
```
