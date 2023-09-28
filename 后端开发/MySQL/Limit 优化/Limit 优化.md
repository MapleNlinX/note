# Limit 优化

LIMIT的优化问题，其实是OFFSET的问题，它会导致MySql扫描大量不需要的行然后再抛弃掉。可以借助书签的思想记录上次取数据的位置，那么下次就可以直接从该书签记录的位置开始扫描，这样就避免了使用OFFSET。可以把主键当做书签使用，例如下面的查询：

```sql
SELECT * FROM sakila.rental ORDER BY rental_id DESC LIMIT 20;
```

假设上面的查询返回的是主键为16049到16030的租借记录，那么下一页查询就可以直接从16030这个点开始：

```sql
SELECT * FROM sakila.rental WHERE rental_id < 16030
ORDER BY rental_id DESC LIMIT 20;
```
