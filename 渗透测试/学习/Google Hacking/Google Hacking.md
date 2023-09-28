# Google Hacking

## 基本语法

-   逻辑与：and
-   逻辑或：or
-   逻辑非：-
-   完整匹配："关键词"
-   通配符： \*?

## 高级语法

#### site：设置搜索范围域名

```纯文本
site:baidu.com
```

#### intext：搜索正文含有关键字

```纯文本
intext:后台登陆
```

#### allintitle：类似intext，但是可以指定多个关键词

```纯文本
allintitle:后台 管理员
```

#### inurl：url中含有的关键字

```纯文本
inurl:login
```

#### allinurl：用法和inur类似，可以指定多个词

```纯文本
allinurl:login admin
```

#### like：正文中包含的链接

```纯文本
like:www.baidu.com
```

#### related：相似类型的网页

```纯文本
related:www.baidu.com 
```

#### info:返回站点的指定信息

```纯文本
info:www.baidu.com
```

#### define：返回某个词语的定义

```纯文本
define:白帽
```
