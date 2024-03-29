# CSRF与SSRF

# CSRF

> 📌（Cross-site request forgery）跨站请求伪造：不攻击网站服务器，而是冒充用户在站内的正常操作。通常由于服务端没有对请求头做严格过滤引起的。

### 攻击原理及过程

1.  用户访问受信任的网站A，通过认证并产生Cookie
2.  在Cookie还没过期的时候访问恶意网站B
3.  网站返回恶意代码，并发出请求要访问网站A
4.  用户浏览器接收到请求，携带Cookie信息访问A网站，并执行恶意请求

​

### 构成CSRF的条件

-   客户端必须一个网站并生成cookie凭证存储在浏览器中
-   该cookie没有清除，客户端又tab一个页面进行访问别的网站

### 服务器端防御

-   敏感操作使用验证码
-   验证HTTP Referer字段，该字段记录了此次HTTP请求的来源地址
-   为每个表单添加令牌token并验证，token令牌不存储在cookie中，每次请求都要验证token令牌

# SSRF

> 📌（Server-Side Request Forgery）服务端请求伪造:一种由攻击者构造形成由服务端发起请求的一个安全漏洞。

> 💡通过篡改获取资源的请求发送给服务器，但是服务器并没有检测这个请求是否合法的，然后服务器以他的身份来访问其他服务器的资源。

### 攻击原理及过程

1.  A网站能发送请求到B网站，攻击者不能访问B网站但能访问A网站
2.  攻击者通过安全漏洞令网站A发送请求到B网站，B网站响应通过A服务器返回到攻击者

### 构成SSRF的条件

-   服务器端没有对请求参数做出过滤

### 服务器端防御

-   ​过滤返回的信息
-   限制请求端口
-   使用Host白名单
-   禁用不常用的协议
-   统一错误信息，避免用户可以根据错误信息来判断远程服务器的端口状态
