# jQuery对象

-   jQuery对象是dom对象的一个包装集

> dom对象转换成jQuery对象

```javascript
var div1 = document.getElementById("one");
var $div1 = $(div1);
```

> jQuery对象转换成dom对象

```javascript
//方法一：使用下标来取出来
var $divs = $('div');
console.log($divs);
var div1 = $divs[0];
console.log(div1);
//方法二：使用get方法获取
var div2 = $divs.get(1);
console.log(div2);

```

添加模板
