# CSS

## CSS

***

### ✨ css(name|pro|\[,val|fn])

> 访问匹配元素的样式属性

| name                        | 属性名称，也可以是多个CSS属性组成的数组                              |
| --------------------------- | -------------------------------------------------- |
| properties                  | 要设置为样式属性的名/值对                                      |
| name,value                  | 属性名,属性值                                            |
| name,function(index, value) | 此函数返回要设置的属性值&#xA;index为元素在对象集合中的索引位置，value是原先的属性值。 |

-   例子
    > 获取width属性值
    ```javascript
    $("#sel").css('width')
    ```
    > 获取多个属性值
    ```javascript
    $("#sel").css(['width','height'])
    ```
    > 为每个p设置字体颜色
    ```javascript
    $('p').css("color","red");
    ```
    > 一次性设置多个属性
    ```javascript
    $('p').css({"color":"red","background":"blue"});
    ```

## 位置

***

### ✨offset(\[coordinates])

> 获取匹配元素在当前视口的相对偏移，top和left，以像素为单位

| coordinates            | 规定以像素计的 top 和 left 坐标                                         |
| ---------------------- | ------------------------------------------------------------- |
| function(index,coords) | 返回被选元素新偏移坐标的函数&#xA;index 接受选择器的 index 位置， oldvalue 接受选择器的当前坐标 |

-   例子
    > 获取偏移
    ```javascript
    var a =  $('#2').offset(); // {top:10,left:20}
    console.log(a.left+"  "+a.top)
    ```
    > 设置偏移
    ```javascript
    $('#2').offset({top:0,left:10});
    ```

### ✨ position()

> 获取匹配元素相对父元素的偏移，不能用于设置，返回一个包含left和top的对象

-   例子
    > 获取偏移
    ```javascript
    var a =  $('#2').position();
    console.log(a.left+"  "+a.top)
    ```

### ✨ scrollTop(\[val])

> 获取匹配元素相对滚动条顶部的偏移。此方法对可见和隐藏元素均有效。

| val | 设定垂直滚动条值 |
| --- | -------- |

-   例子
    > 获取偏移
    ```javascript
    $("p").scrollTop(); //10
    ```
    > 设置偏移
    ```javascript
    $("p").scrollTop(30);
    ```

### ✨ scrollLeft(\[val])

> 获取匹配元素相对滚动条左侧的偏移，用法与scrollTop一致

## 尺寸

***

### ✨ height(\[val|fn])

> 取得匹配元素当前计算的高度值（px）

| val                     | CSS中 'height' 的值                     |
| ----------------------- | ------------------------------------ |
| function(index, height) | 返回用于设置高度的一个函数。接收元素的索引位置和元素旧的高度值作为参数。 |

-   例子
    > 获取高度
    ```javascript
    $("p").height()
    ```
    > 设置高度
    ```javascript
    $("p").height(300)
    ```

### ✨ width(\[val|fn])

> 取得第一个匹配元素当前计算的宽度值（px），用法与`height`一致

### ✨ innerHeight()

> 获取第一个匹配元素内部区域高度，`innerHeight` = `padding` + `height`

-   例子
    > 获取内部区域高度
    ```javascript
    $("p").height()
    ```

### ✨ innerWidth()

> 获取第一个匹配元素内部区域宽度，`padding` + `width` ,用法与`innerHeight`一致

### ✨ outerHeight(\[options])

> 获取第一个匹配元素外部高度，`outerHeight `= `height `+ `padding` + `border`

| options | true ：`outerHeight `= `height `+ `padding` + `border` + `margin`&#xA;false：`outerHeight `= `height `+ `padding` + `border`    （默认） |
| ------- | ---------------------------------------------------------------------------------------------------------------------------------- |

-   例子
    > 获取高度，包括边框、外边距、内边距
    ```javascript
    $("p").outerHeight(true)
    ```

### ✨ outerWidth(\[options])

> 获取第一个匹配元素外部快读，用法与`outerHeight`一致

添加模板
