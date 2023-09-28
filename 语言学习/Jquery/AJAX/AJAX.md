# AJAX

## ✨ \$.ajax(url,\[settings])

> \$.ajax() 是底层的AJAX实现，一般情况下如果不需要一些不常用的操作选项，不需要用到\$.ajax() ，其它的例如 \$.get, \$.post 等更易于使用，也够用了

### 回调函数

| beforeSend | 在发送请求之前调用&#xA;- 传入一个XMLHttpRequest作为参数                                     |
| ---------- | -------------------------------------------------------------------------- |
| error      | 在请求出错时调用&#xA;- 传入XMLHttpRequest对象，描述错误类型的字符串以及一个异常对象（如果有的话）                |
| dataFilter | 在请求成功之后调用&#xA;- 传入返回的数据以及"dataType"参数的值。并且必须返回新的数据（可能是处理过的）传递给success回调函数。 |
| success    | 当请求之后调用。&#xA;- 传入返回后的数据，以及包含成功代码的字符串                                       |
| complete   | 当请求完成之后调用这个函数，无论成功或失败&#xA;- 传入XMLHttpRequest对象，以及一个包含成功或错误代码的字符串。          |

### 简单使用

> 加载并执行一个 JS 文件

```javascript
$.ajax({
  type: "GET",
  url: "test.js",
  dataType: "script"
});
```

> 保存数据到服务器，成功时显示信息

```javascript
$.ajax({
   type: "POST",
   url: "some.php",
   data: "name=John&location=Boston",
   success: function(msg){
     alert( "Data Saved: " + msg );
   }
});
```

> 装入一个 HTML 网页最新版本。

```javascript
$.ajax({
  url: "test.html",
  cache: false,
  success: function(html){
    $("#results").append(html);
  }
});
```

> 同步加载数据。发送请求时锁住浏览器。需要锁定用户交互操作时使用同步方式

```javascript
var html = $.ajax({
  url: "some.php",
  async: false
 }).responseText;
```

> 发送 XML 数据至服务器。设置 processData 选项为 false，防止自动转换数据格式。

```javascript
 var xmlDocument = [create xml document];
 $.ajax({
   url: "page.php",
   processData: false,
   data: xmlDocument,
   success: handleResponse
 });
```

## ✨  \$.get(url, \[data], \[callback], \[type])

> HTTP GET 请求

| url      | 待载入页面的URL地址                                     |
| -------- | ----------------------------------------------- |
| data     | 待发送 Key/value 参数                                |
| callback | 载入成功时回调函数                                       |
| type     | 返回内容格式，xml, html, script, json, text, \_default |

-   例子
    > 请求 test.php 网页，忽略返回值
    ```javascript
    $.get("test.php");
    ```
    > 请求 test.php 网页，传送2个参数，忽略返回值。
    ```javascript
    $.get("test.php", { name: "John", time: "2pm" } );
    ```
    > 显示 test.php 返回值(HTML 或 XML，取决于返回值)
    ```javascript
    $.get("test.php", function(data){
              alert("Data Loaded: " + data);
    });
    ```
    > 显示 test.cgi 返回值(HTML 或 XML，取决于返回值)，添加一组请求参数。
    ```javascript
    $.get("test.cgi", { name: "John", time: "2pm" },
              function(data){
              alert("Data Loaded: " + data);
    });
    ```
    > 类似\$.ajax()使用对象参数
    ```javascript
    $.get({
          url: "/example"
    });
    ```

## ✨  \$.getJSON(url, \[data], \[callback])

> 通过 HTTP GET 请求载入 JSON 数据

| url      | 发送请求地址。          |
| -------- | ---------------- |
| data     | 待发送 Key/value 参数 |
| callback | 载入成功时回调函数        |

-   例子
    > 从 Flickr JSONP API 载入 4 张最新的关于猫的图片
    ```javascript
    $.getJSON("https://api.flickr.com/services/feeds/photos_public.gne?tags=cat&tagmode=any&format
    =json&jsoncallback=?", function(data){
      $.each(data.items, function(i,item){
        $("<img/>").attr("src", item.media.m).appendTo("#images");
        if ( i == 3 ) return false;
      });
    });
    ```
    > 从 test.js 载入 JSON 数据并显示 JSON 数据中一个 name 字段数据
    ```javascript
    $.getJSON("test.js", function(json){
      alert("JSON Data: " + json.users[3].name);
    });
    ```
    > 从 test.js 载入 JSON 数据，附加参数，显示 JSON 数据中一个 name 字段数据
    ```javascript
    $.getJSON("test.js", { name: "John", time: "2pm" }, function(json){
      alert("JSON Data: " + json.users[3].name);
    });
    ```

## ✨  \$.getScript(url, \[callback])

> 通过 HTTP GET 请求载入并执行一个 JavaScript 文件

| url      | 待载入 JS 文件地址 |
| -------- | ----------- |
| callback | 成功载入后回调函数   |

-   例子
    > 加载并执行 test.js
    ```javascript
    $.getScript("test.js");
    ```
    > 加载插件再执行函数
    ```javascript
    jQuery.getScript("https://dev.jquery.com/view/trunk/plugins/color/jquery.color.js", function(){
      $("#go").click(function(){
        $(".block").animate( { backgroundColor: 'pink' }, 1000)
          .animate( { backgroundColor: 'blue' }, 1000);
      });
    });
    ```

## ✨  \$.post(url, \[data], \[callback], \[type])

> 通过远程 HTTP POST 请求载入信息

| url      | 发送请求地址                                          |
| -------- | ----------------------------------------------- |
| data     | 待发送 Key/value 参数                                |
| callback | 发送成功时回调函数                                       |
| type     | 返回内容格式，xml, html, script, json, text, \_default |

-   例子
    > 请求 test.php 网页，忽略返回值
    ```javascript
    $.post("test.php");
    ```
    > 请求 test.php 页面，并一起发送一些额外的数据（同时仍然忽略返回值）
    ```javascript
    $.post("test.php", { name: "John", time: "2pm" } );

    ```
    > 向服务器传递数据数组（同时仍然忽略返回值）
    ```javascript
    $.post("test.php", { 'choices[]': ["Jon", "Susan"] });

    ```
    > 使用 ajax 请求发送表单数据
    ```javascript
    $.post("test.php", $("#testform").serialize());

    ```
    > 输出来自请求页面 test.php 的结果（HTML 或 XML，取决于所返回的内容）
    ```javascript
    $.post("test.php", function(data){
        alert("Data Loaded: " + data);
    });

    ```
    > 获得 test.php 页面的内容，并存储为 XMLHttpResponse 对象，并通过 process() 这个 JavaScript 函数进行处理
    ```javascript
    $.post("test.php", { name: "John", time: "2pm" },
        function(data){
        process(data);
    }, "xml");

    ```
    > 获得 test.php 页面返回的 json 格式的内容
    ```javascript
    $.post("test.php", { "func": "getNameAndTime" },
        function(data){
        alert(data.name); // John
        console.log(data.time); //  2pm
    }, "json");
    ```

## ✨  ajaxComplete(callback)

> AJAX 请求完成时执行函数

| callback | 待执行函数 |
| -------- | ----- |

-   例子
    > AJAX 请求完成时执行函数
    ```javascript
     $("#msg").ajaxComplete(function(event,request, settings){
       $(this).append("<li>请求完成.</li>");
     });
    ```
    > 当 AJAX 请求正在进行时显示“正在加载”的指示
    ```javascript
    $("#txt").ajaxStart(function(){
      $("#wait").css("display","block");
    });
    $("#txt").ajaxComplete(function(){
      $("#wait").css("display","none");
    });
    ```

## ✨  ajaxError(callback)

> AJAX 请求发生错误时执行函数

| callback | 待执行函数 |
| -------- | ----- |

```javascript
function (event, XMLHttpRequest, ajaxOptions, thrownError) {
      // thrownError 只有当异常发生时才会被传递
      this; // 监听的 dom 元素
}
```

-   例子
    > AJAX 请求失败时显示信息
    ```javascript
    $("#msg").ajaxError(function(event,request, settings){
         $(this).append("<li>出错页面:" + settings.url + "</li>");
    });
    ```

## ✨  ajaxSend(callback)

> AJAX 请求发送前执行函数

-   例子
    > AJAX 请求发送前显示信息
    ```javascript
    $("#msg").ajaxSend(function(evt, request, settings){
       $(this).append("<li>开始请求: " + settings.url + "</li>");
     });
    ```

## ✨  ajaxStart(callback)

> AJAX 请求开始时执行函数，先于ajaxSend，创建xhr的时候就会调用，还没执行open

-   如果同时有多个ajax请求只会执行一次
-   例子
    > AJAX 请求开始时显示信息。
    ```javascript
    $("#loading").ajaxStart(function(){
       $(this).show();
     });
    ```

## ✨  ajaxStop(callback)

> AJAX 请求结束时执行函数

-   如果同时有多个ajax请求只会执行最后一次
-   例子
    > AJAX 请求结束后隐藏信息
    ```javascript
     $("#loading").ajaxStop(function(){
       $(this).hide();
     });
    ```

## ✨  ajaxSuccess(callback)

> AJAX 请求成功时执行函数

-   例子
    > 当 AJAX 请求成功后显示消息。
    ```javascript
    $("#msg").ajaxSuccess(function(evt, request, settings){
       $(this).append("<li>请求成功!</li>");
    });
    ```

添加模板

## ✨  load(url, \[data], \[callback])

> 载入远程 HTML 文件代码并插入至 DOM 中，默认使用 GET 方式 - 传递附加参数时自动转换为 POST 方式

-   可以指定选择符，来筛选载入的 HTML 文档，DOM 中将仅插入筛选出的 HTML 代码

| url      | 待装入 HTML 网页网址                                |
| -------- | -------------------------------------------- |
| data     | 发送至服务器的 key/value 数据。在jQuery 1.3中也可以接受一个字符串了 |
| callback | 载入成功时回调函数                                    |

-   例子
    > 加载文章侧边栏导航部分至一个无序列表
    ```javascript
    $("#links").load("/Main_Page #p-Getting-Started li");
    ```
    > 加载 feeds.html 文件内容
    ```javascript
    $("#feeds").load("feeds.html");

    ```
    > 以 POST 形式发送附加参数并在成功时显示信息
    ```javascript
    $("#feeds").load("feeds.php", {limit: 25}, function(){
       alert("The last 25 entries in the feed have been loaded");
    });
    ```

## ✨  serialize()

> 序列表表格内容为字符串，多用于 Ajax 请求，返回的是`key=val&key=val`格式

-   例子
    ```javascript
    $("#results").append( "<tt>" + $("form").serialize() + "</tt>" );
    ```

## ✨  serializeArray()

> 序列化表格元素 (类似 '.serialize()' 方法) 返回 JSON 数据结构数据

-   此方法返回的是JSON对象而非JSON字符串
-   例子
    > 取得表单内容并插入到网页中。
    ```javascript
    var fields = $("select, :radio").serializeArray();
    jQuery.each( fields, function(i, field){
      $("#results").append(field.value + " ");
    });
    ```
