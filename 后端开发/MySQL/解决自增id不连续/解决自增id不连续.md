# 解决自增id不连续

-   在每次添加新数据时候先执行以下语句重置一下自增量

```sql
alter table tablename auto_increment = 1;
```

> 这里`auto_increment` 不会变为1，而是变为自增id最大值加1
