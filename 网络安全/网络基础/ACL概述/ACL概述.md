# ACL概述

> （ Access Control Lists ）访问控制列表：是应用在路由器接口的指令列表 ，用来告诉路由器哪些数据包可以接收转发，哪些数据包需要拒绝。

> 工作原理：读取第三层及第四层包头中的信息 ，根据预先定义好的规则对包 进行过滤

### ACL作用

-   提供网络访问的基本安全手段
-   可用于Qos，控制数据流量
-   控制通信量

### ACL匹配原则

-   最小特权原则，只给受控对象完成任务所必须的最小的权限
-   最靠近受控对象原则（只要发现符合条件的ACL就立刻转发，不再检测下一条ACL语句）
-   默认丢弃原则

### Deny和permit命令

```javascript
access-list 1 dany 172.16.4.13   0.0.0.0
access-list 1 permit 172.16.0.0   0.0.255.255
interface ethernet 0
ip access-group 1 in  
```

### ACL分类

-   标准ACL：（1-99）检查源地址，通常允许或拒绝整个协议簇
-   扩展ACL：（100-199）检查源地址和目的地址，通常允许或拒绝特定协议和应用程序

### 扩展ACL操作符

| 操作符 | 意义     |
| --- | ------ |
| eq  | 等于端口号  |
| gt  | 大于端口号  |
| lt  | 小于端口号  |
| neq | 不等于端口号 |

### 扩展ACL配置

创建拒绝来自 172.16.4.0 去往 172.16.3.0 的 telnet 流量的 ACL（telnet 使用tcp 端口为23）

```javascript
access-list 101 deny tcp 172.16.4.0  0.0.0.255 172.16.3.0 0.0.0.255 eq 23
//（允许其它所有）
access-list 101 permit ip any any
```

### 命名ACL

-   在标准ACL和扩展ACL中，使用字母和数字组合的字符串代替ACL的表号
-   命名ACL允许删除列表中单个条目，也可以添加，但会被添加到列表末尾
-   不能一个名字命名多个ACL
-   permit 和 deny 命令的语法格式会有所不同

### 命名ACL配置

```javascript
//创建ACL
ip access-list extended cisco
//指定条件
deny tcp 172.16.4.0 0.0.0.255  172.16.3.0 0.0.0.255 eq 23
permit ip any any
//（没有配置序列号，默认从10开始，以10为单位递增，no 序列号 可以去除某条配置）
//应用到接口
interface Ethernet 0
ip access-group cisco out
```
