# \<meta>

> 描述html文档的元数据，元数据可以被使用浏览器（如何显示内容或重新加载页面），搜索引擎（关键词），或其他 Web 服务调用

| 属性         | 值                                                                                      | 描述                              | 4/5 |
| ---------- | -------------------------------------------------------------------------------------- | ------------------------------- | --- |
| charset    | character encoding                                                                     | 定义文档的字符编码。                      | 5   |
| content    | some\_text                                                                             | 定义与 http-equiv 或 name 属性相关的元信息。 | 4/5 |
| http-equiv | \*   content-type&#xA;\*   expires&#xA;\*   refresh&#xA;\*   set-cookie                | 把 content 属性关联到 HTTP 头部。        | 4/5 |
| name       | \*   author&#xA;\*   description&#xA;\*   keywords&#xA;\*   generator&#xA;\*   revised | 把 content 属性关联到一个名称。            | 4/5 |
| scheme     | some\_text                                                                             | 定义用于翻译 content 属性值的格式。不支持。      | 4   |

### 实例

-   定义文档关键词，用于搜索引擎
    ```html
    <meta name="keywords" content="HTML, CSS, XML, XHTML, JavaScript">
    ```
-   &#x20;定义web页面描述
    ```html
    <meta name="description" content="Free Web tutorials on HTML and CSS">
    ```
-   定义页面作者
    ```html
    <meta name="author" content="Hege Refsnes">
    ```
-   每30秒刷新页面
    ```html
    <meta http-equiv="refresh" content="30">
    ```
-   页面跳转
    ```html
    <meta http-equiv="refresh" content="3;URL=<?php echo $_GET['url']?>"/>
    ```

### HTML与XHTML区别，

-   在 HTML 中 \<meta> 标签没有结束标签。
-   在 XHTML 中 \<meta> 标签必须包含结束标签。
