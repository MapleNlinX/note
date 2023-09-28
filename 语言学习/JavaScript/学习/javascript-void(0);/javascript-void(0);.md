# javascript:void(0);

> 当点击超级链接时，什么都不发生

```html
<a href="javascript:void(0);"></a><br>
```

> 执行void操作符当中的代码

```html
<a href="javascript:void(alert('test'))"></a><br>
```

> 点击a链接不跳转，执行点击事件

```html
<a href="javascript:void(0)" onclick="sub()"></a>
```

> 点击a链接返回

```html
<a href="javascript:void(0)" onclick="javascript:history.back();">返回</a>
```

-   `javascript:void(0);` 与 `#` 的区别
    -   `#` 可以跳转到设置了id的目的地，就算不设置也会跳转到顶部
    -   `javascript:void(0)` 则停留在原地，无操作
