# API 使用

## 用户脚本标题[#](https://www.cnblogs.com/grubber/p/12560522.html#826405481 "#")

### @name[#](https://www.cnblogs.com/grubber/p/12560522.html#2583506524 "#")

脚本的名称。

### @namespace[#](https://www.cnblogs.com/grubber/p/12560522.html#2933492508 "#")

脚本的命名空间。

### @version[#](https://www.cnblogs.com/grubber/p/12560522.html#2191907574 "#")

脚本版本。这用于更新检查，以防脚本未从userscript.org安装，或者 TM 检索脚本元数据时出现问题。

### @author[#](https://www.cnblogs.com/grubber/p/12560522.html#781811370 "#")

脚本作者。

### @description[#](https://www.cnblogs.com/grubber/p/12560522.html#3551423575 "#")

一个简短的重要描述。

### @homepage、@homepageURL、@website和@source[#](https://www.cnblogs.com/grubber/p/12560522.html#2244233891 "#")

在选项页中使用的作者主页从脚本名称链接到给定页面。请注意，如果@namespace标签以"http\://"开头，其内容也将用于此。

### @icon、@iconURL和@defaulticon[#](https://www.cnblogs.com/grubber/p/12560522.html#4020786807 "#")

低分辨率下的脚本图标。

### @icon64和@icon64URL[#](https://www.cnblogs.com/grubber/p/12560522.html#1268753735 "#")

此脚本图标为 64x64 像素。如果此标记，但@icon给出@icon图像将在选项页上的某些位置缩放。

### @updateURL[#](https://www.cnblogs.com/grubber/p/12560522.html#2759041924 "#")

用户脚本的更新 URL。 &#x20;
注意：需要@version标记才能使更新检查正常工作。

### @downloadURL[#](https://www.cnblogs.com/grubber/p/12560522.html#1202582790 "#")

定义当检测到更新时将从其中下载脚本的URL。如果使用none值，则不会执行更新检查。

### @supportURL[#](https://www.cnblogs.com/grubber/p/12560522.html#4148118494 "#")

定义用户可以报告问题和获得个人支持的 URL。

### @include[#](https://www.cnblogs.com/grubber/p/12560522.html#2040280041 "#")

该脚本应运行的页面。允许多个标记实例。请注意，@include不支持 URL 哈希参数。请访问此论坛主题了解更多信息：[点击](http://forum.tampermonkey.net/viewtopic.php?p=3094#p3094 "点击")。

**代码：**

Copy

`// @include http://*  // @include https://*  // @include *`&#x20;

### @match[#](https://www.cnblogs.com/grubber/p/12560522.html#2923405948 "#")

或多或少等于@include标记。 您可以[在这里](http://code.google.com/chrome/extensions/match_patterns.html "在这里")得到更多信息。注意：尚不支持'\<all\_urls>'语句，方案部分还接受'http \*：//'。允许多个标签实例。

### @exclude[#](https://www.cnblogs.com/grubber/p/12560522.html#2141905534 "#")

排除 URL，即使它们也包含在@include或@match。 &#x20;
允许多个标记实例。

### @require[#](https://www.cnblogs.com/grubber/p/12560522.html#2885778812 "#")

指向在脚本本身开始运行之前加载并执行的JavaScript文件。注意:通过@require加载的脚本及其“use strict”语句可能会影响userscript的strict模式!

**代码：**

Copy

`// @require https://code.jquery.com/jquery-2.1.4.min.js  // @require https://code.jquery.com/jquery-2.1.3.min.js#sha256=23456...  // @require https://code.jquery.com/jquery-2.1.2.min.js#md5=34567...,sha256=6789...`&#x20;

有关如何确保完整性的详细信息，请查看[子资源完整性](https://www.cnblogs.com/grubber/p/12560522.html#Subresource_Integrity "子资源完整性")部分。允许多个标记实例。

### @resource[#](https://www.cnblogs.com/grubber/p/12560522.html#3610374920 "#")

通过脚本预加载可以通过GM getResourceURL和GM getResourceText访问的资源。

**代码：**

Copy

`// @resource icon1 http://www.tampermonkey.net/favicon.ico  // @resource icon2 /images/icon.png  // @resource html http://www.tampermonkey.net/index.html  // @resource xml http://www.tampermonkey.net/crx/tampermonkey.xml  // @resource SRIsecured1 http://www.tampermonkey.net/favicon.ico#md5=123434...  // @resource SRIsecured2 http://www.tampermonkey.net/favicon.ico#md5=123434...;sha256=234234...`&#x20;

有关如何确保完整性的详细信息，请查看[子资源完整性](https://www.cnblogs.com/grubber/p/12560522.html#Subresource_Integrity "子资源完整性")部分。允许多个标记实例。

### @connect[#](https://www.cnblogs.com/grubber/p/12560522.html#1938669248 "#")

此标记定义域（无顶级域），包括允许通过[GM\_xmlhttpRequest](https://www.cnblogs.com/grubber/p/12560522.html#GM_xmlhttpRequest "GM_xmlhttpRequest")检索的子域

**代码：**

Copy

`// @connect <value>`&#x20;

`<value>`可以具有以下值：

-   像 [tampermonkey.net](http://tampermonkey.net "tampermonkey.net") 这样的域(这也将允许所有子域)
-   子域即 [safari.tampermonkey.net](http://safari.tampermonkey.net "safari.tampermonkey.net")
-   将脚本当前运行的域列入白名单
-   `localhost` 访问本地主机
-   1.2.3.4 连接到一个IP地址
-   *\**

如果无法声明 userscript 可能连接到的所有域，则最好执行以下操作：**声明脚本可能连接的所有已知域或至少所有常见域**。这样，大多数用户都可以避免确认对话框。此外，将“@connect”添加到脚本中。通过这样做，Tampermonkey仍然会问用户是否允许下一个连接未提及的域，但也**提供了一个"始终允许所有域"按钮**。如果用户单击此按钮，则将自动允许所有将来的请求。用户还可以通过在脚本设置选项卡上将 " \*" 添加到用户域白名单来将所有请求列入白名单。

注意：

-   初始URL和最终URL都将被检查！
-   对于脚本[@domain](https://github.com/scriptish/scriptish/wiki/Manual:-Metadata-Block#user-content-domain-new-in-scriptish "@domain")标记的向后兼容性，也进行了解释。

允许多个标记实例。

### @run-at[#](https://www.cnblogs.com/grubber/p/12560522.html#3904898246 "#")

定义脚本被注入的时刻。与其他脚本处理程序相反，@run-at定义了脚本想要运行的第一个可能时刻。这意味着可能会发生这样的情况，使用@require标记的脚本可能会在文档已经加载之后执行，因为获取所需的脚本需要很长时间。无论如何，在给定的注入时刻之后发生的所有domnodeinsert和DOMContentLoaded事件都会被缓存，并在注入脚本时交付给脚本。

**代码：**

Copy

`// @run-at document-start`&#x20;

脚本将尽快注入。

**代码：**

Copy

`// @run-at document-body`&#x20;

如果正文元素存在，将注入脚本。

**代码：**

Copy

`// @run-at document-end`&#x20;

在调度 DOM内容加载事件时或之后，将注入脚本。

**代码：**

Copy

`// @run-at document-idle`&#x20;

在调度 DOM内容加载事件后，将注入脚本。如果未给出@run时标记，则这是默认值。

**代码：**

Copy

`// @run-at context-menu`&#x20;

如果在浏览器上下文菜单上单击脚本(仅在基于桌面chrome的浏览器上)，脚本将被注入。注意:如果使用这个值，所有的@include和@exclude语句都将被忽略，但是这在将来可能会改变。

### @grant[#](https://www.cnblogs.com/grubber/p/12560522.html#2638851348 "#")

@grant用于将GM\_ \*函数，unsafeWindow对象和一些强大的窗口函数列入白名单。 如果没有给出@grant标签，TM会猜测脚本的需求。

**代码：**

Copy

`// @grant GM_setValue  // @grant GM_getValue  // @grant GM_setClipboard  // @grant unsafeWindow  // @grant window.close  // @grant window.focus`&#x20;

由于关闭和聚焦选项卡是一个强大的特性，因此也需要将它添加到@grant语句中。

如果@grant后面跟着“none”，那么沙箱将被禁用，脚本将直接在页面上下文中运行。在这种模式下，没有GM \*函数，但是GM信息属性是可用的。

**代码：**

Copy

`// @grant none`&#x20;

### @noframes[#](https://www.cnblogs.com/grubber/p/12560522.html#226399824 "#")

此标记使脚本在主页上运行，但不是在 iframe 上运行。

### @unwrap[#](https://www.cnblogs.com/grubber/p/12560522.html#283022112 "#")

此标签被忽略，因为，这是不需要在谷歌Chrome/Chromium。

### @nocompat[#](https://www.cnblogs.com/grubber/p/12560522.html#754293747 "#")

目前，TM试图通过查找@match标记来检测是否使用了谷歌Chrome/Chromium编写的脚本，但并不是每个脚本都使用它。这就是为什么TM支持这个标签来禁用所有可能需要的优化来运行为Firefox/Greasemonkey编写的脚本。要保持此标记的可扩展性，可以添加可由脚本处理的浏览器名称。

**代码：**

Copy

`// @nocompat Chrome`&#x20;

## 应用程序编程接口[#](https://www.cnblogs.com/grubber/p/12560522.html#2365044821 "#")

### unsafeWindow[#](https://www.cnblogs.com/grubber/p/12560522.html#3604923344 "#")

unsafeWindow对象提供了对页面javascript函数和变量的完全访问。

### Subresource Integrity[#](https://www.cnblogs.com/grubber/p/12560522.html#3120445593 "#")

@resource 和 @require 标记 URL 的哈希组件可用于此目的。

**代码：**

Copy

`// @resource SRIsecured1 http://www.tampermonkey.net/favicon1.ico#md5=ad34bb...  // @resource SRIsecured2  http://www.tampermonkey.net/favicon2.ico#md5=ac3434...,sha256=23fd34...  // @require https://code.jquery.com/jquery-2.1.1.min.js#md5=45eef...  // @require https://code.jquery.com/jquery-2.1.2.min.js#md5=ac56d...,sha256=6e789...`&#x20;

TM 支持 MD5 哈希作为本机回退，所有其他（SHA-1、SHA-256、SHA-384 和 SHA-512）取决于[window.crypto](https://developer.mozilla.org/en-US/docs/Web/API/Crypto "window.crypto").如果给多个哈希（用逗号或分号分隔），TM 将使用当前支持的最后一个哈希。如果外部资源的内容与所选哈希不匹配，则资源不会传递到userscript。所有哈希都需要以十六进制或 Base64 格式进行编码。

### GM\_addStyle(css)[#](https://www.cnblogs.com/grubber/p/12560522.html#2534731758 "#")

将给定的样式添加到文档并返回注入的样式元素。

### GM\_deleteValue(name)[#](https://www.cnblogs.com/grubber/p/12560522.html#1043101902 "#")

从存储区删除'name'。

### GM\_listValues()[#](https://www.cnblogs.com/grubber/p/12560522.html#2831167693 "#")

列出存储的所有名称。

### GM\_addValueChangeListener(name, function(name, old\_value, new\_value, remote) {})[#](https://www.cnblogs.com/grubber/p/12560522.html#96565543 "#")

将更改侦听器添加到存储中并返回侦听器ID。'name'是观察到的变量的名称。回调函数的'remote'参数显示这个值是在另一个选项卡的实例中修改的(true)还是在这个脚本实例中修改的(false)。因此，不同浏览器选项卡的脚本可以使用此功能进行通信。

### GM\_removeValueChangeListener(listener\_id)[#](https://www.cnblogs.com/grubber/p/12560522.html#4148637463 "#")

删除更改侦听器的 ID。

### GM\_setValue(name, value)[#](https://www.cnblogs.com/grubber/p/12560522.html#4064180380 "#")

将"name"的值设置为存储。

### GM\_getValue(name, defaultValue)[#](https://www.cnblogs.com/grubber/p/12560522.html#2587249029 "#")

从存储中获取"name"的值。

### GM\_log(message)[#](https://www.cnblogs.com/grubber/p/12560522.html#592114046 "#")

将消息记录到控制台。

### GM\_getResourceText(name)[#](https://www.cnblogs.com/grubber/p/12560522.html#812342091 "#")

在脚本标头上获取预定义的@resource标记的内容。

### GM\_getResourceURL(name)[#](https://www.cnblogs.com/grubber/p/12560522.html#3493029792 "#")

在脚本标头处获取预定义的@resource标记的base64编码的URI。

### GM\_registerMenuCommand(name, fn, accessKey)[#](https://www.cnblogs.com/grubber/p/12560522.html#491070177 "#")

注册一个要在Tampermonkey菜单中显示的菜单，该脚本在其中运行并返回菜单命令ID。

### GM\_unregisterMenuCommand(menuCmdId)[#](https://www.cnblogs.com/grubber/p/12560522.html#3537055742 "#")

用给定的菜单命令ID注销之前由GM registerMenuCommand注册的菜单命令。

### GM\_openInTab(url, options), GM\_openInTab(url, loadInBackground)[#](https://www.cnblogs.com/grubber/p/12560522.html#1237081056 "#")

使用此url打开一个新选项卡。options对象可以有以下属性：

-   **active**决定是否应对新选项卡进行聚焦，
-   **insert**在当前选项卡之后插入新选项卡，
-   **SetParent**使浏览器在关闭时重新聚焦当前选项卡，然后
-   **incognito**选项卡在隐身模式/专用模式窗口中打开。

否则只会追加新选项卡。**loadInBackground**和**active**有相反的含义，添加它是为了实现Greasemonkey 3.x兼容性。如果未提供**active**或**loadInBackground**，则选项卡将不会聚焦。此函数返回一个对象，该对象具有函数**close**、侦听器**onclosed**和一个称为**closed**的标记。

### GM\_xmlhttpRequest(details)[#](https://www.cnblogs.com/grubber/p/12560522.html#421791435 "#")

制作一个xmlHttpRequest。

**detail**具有以下属性：

-   **method**GET, HEAD, POST的其中之一
-   **url**目标 URL
-   **headers**ie的user-agent, referer等（Safari 和 Android 浏览器不支持某些特殊标头）
-   **data**通过POST请求发送的一些字符串
-   **cookie**要打补丁到发送的cookie集合中的cookie
-   **binary**在二进制模式下发送数据字符串
-   **timeout**ms中的超时
-   **context**将添加到响应对象的属性
-   **responseType**arraybuffer, blob, json中的一个
-   **overrideMimeType**请求的MIME类型
-   **anonymous**不发送带有请求的Cookie（请参阅 fetch 说明）
-   **fetch(beta)** 使用 fetch 替换 xhr 请求 &#x20;

    （这会导致在Chrome上xhr.abort，details.timeout和xhr.onprogress无法正常工作，并使xhr.onreadystatechange仅接收readyState 4事件）
-   **username**用于身份验证的用户名
-   **password**密码
-   **onabort**如果请求被中止，将执行的回调
-   **onerror**如果请求以错误结束，则执行回调
-   **onloadstart**如果请求开始加载，将执行回调
-   **onprogress**如果请求取得一些进展，将执行回调
-   **onreadystatechange**如果请求的就绪状态更改，将执行回调
-   **ontimeout**如果请求由于超时而失败，则执行回调
-   **onload**如果加载了请求，则执行回调 &#x20;

    它获取一个具有以下属性的参数：
    -   **finalUrl** 所有从数据加载位置重定向后的最终URL
    -   **readyState** 就绪状态
    -   **status** 请求状态
    -   **statusText** 请求状态文本
    -   **responseHeaders** 请求响应标头
    -   **response** 如果设置了details.responseType，则将响应数据作为对象
    -   **responseXML** 响应数据作为XML文档
    -   **responseText** 响应数据作为纯字符串

返回具有以下属性的对象：

-   **abort** 取消此请求要调用的函数

**注意：** 不支持**detail**处的**synchronous**标志**重要提示：** 如果要使用此方法，请另外请查看有关[@connect](https://www.cnblogs.com/grubber/p/12560522.html#_connect "@connect")的文档。

### GM\_download(details), GM\_download(url, name)[#](https://www.cnblogs.com/grubber/p/12560522.html#1280222183 "#")

将给定URL下载到本地磁盘。*details* 可以具有以下属性：

-   **URL** 从中下载数据的URL（必填）
-   **name** 文件名-出于安全原因，需要在Tampermonkey的选项页上将文件扩展名列入白名单（必填）
-   **headers** 有关详细信息，请参阅**GM\_xmlhttpRequest**
-   **saveAs** 布尔值，显示一个另存为对话框
-   **onerror** 如果此下载以错误结束，则执行回调
-   **onload** 下载完成后要执行的回调
-   **onprogress** 如果此下载取得一些进展，则执行回调
-   **超时回调** 如果此下载由于超时而失败，则执行回调

onerror回调的download参数可以具有以下属性：

-   **error** 错误原因
    -   **not\_enabled** 用户未启用下载功能
    -   **not\_whitelisted** 请求的文件扩展名未列入白名单
    -   **not\_permitted** 用户启用了下载功能，但未授予下载权限
    -   **not\_supported** 浏览器/版本不支持下载功能
    -   **not\_succeeded** 下载未启动或失败，*details* 属性可能会提供更多信息
-   **details** 有关该错误的详细信息：

返回具有以下属性的对象：

-   **abort** 取消下载的调用函数

根据下载模式的不同，**GM\_info**提供一个名为**downloadMode**的属性，它被设置为以下值之一:**native**、**disabled**或**browser**。

### GM\_getTab(callback)[#](https://www.cnblogs.com/grubber/p/12560522.html#3417695607 "#")

只要此选项卡处于打开状态，就可以获取持久对象。

### GM\_saveTab(tab)[#](https://www.cnblogs.com/grubber/p/12560522.html#2059923480 "#")

保存选项卡对象以在页面卸载后重新打开它。

### GM\_getTabs(callback)[#](https://www.cnblogs.com/grubber/p/12560522.html#3783371477 "#")

获取所有选项卡对象作为哈希值，以与其他脚本实例进行通信。

### GM\_notification(details, ondone), GM\_notification(text, title, image, onclick)[#](https://www.cnblogs.com/grubber/p/12560522.html#1390767330 "#")

显示 HTML5 桌面通知和/或突出显示当前选项卡。

*detail* 可以具有以下属性：

-   **text** 通知文字（除非设置了突出显示，否则为必填）
-   **title** 通知的标题
-   **image** 通知图像
-   **highlight** 一个布尔型标志，是否突出显示发送通知的选项卡（除非设置了文本，否则为必需）
-   **silent** 一个布尔值是否不播放声音
-   **timeout** 通知将被隐藏的时间（0 =禁用）
-   **ondone** 在通知关闭时（无论是由超时还是单击触发）或突出显示选项卡时调用
-   **onclick** 在用户单击通知时调用

所有参数的作用与它们对应的details属性项完全相同。

### GM\_setClipboard(data, info)[#](https://www.cnblogs.com/grubber/p/12560522.html#1965803084 "#")

将数据复制到剪贴板。 参数“ info”可以是“ {type：'text'，mimetype：'text / plain'}”之类的对象，也可以是表示类型的字符串（“ text”或“ html”）。

### GM\_info[#](https://www.cnblogs.com/grubber/p/12560522.html#1976176477 "#")

获取有关脚本和TM的一些信息。 该对象可能如下所示：

**代码：**

Copy

`Object+   ---> script: Object+   ------> author: ""  ------>copyright: "2012+, You"  ------>description: "enter something useful"  ------>excludes: Array[0]   ------>homepage: null  ------>icon: null  ------>icon64: null  ------>includes: Array[2]   ------>lastUpdated: 1338465932430  ------>matches: Array[2]   ------>downloadMode: 'browser'  ------>name: "Local File Test"  ------>namespace: "http://use.i.E.your.homepage/"  ------>options: Object+   --------->awareOfChrome: true  --------->compat_arrayleft: false  --------->compat_foreach: false  --------->compat_forvarin: false  --------->compat_metadata: false  --------->compat_prototypes: false  --------->compat_uW_gmonkey: false  --------->noframes: false  --------->override: Object+   ------------>excludes: false  ------------>includes: false  ------------>orig_excludes: Array[0]   ------------>orig_includes: Array[2]   ------------>use_excludes: Array[0]   ------------>use_includes: Array[0]   --------->run_at: "document-end"  ------>position: 1  ------>resources: Array[0]   ------>run-at: "document-end"  ------>system: false  ------>unwrap: false  ------>version: "0.1"  ---> scriptMetaStr: undefined  ---> scriptSource: "// ==UserScript==\n// @name       Local File Test\n ...."  ---> scriptUpdateURL: undefined  ---> scriptWillUpdate: false  ---> scriptHandler: "Tampermonkey"  ---> isIncognito: false   ---> version: "4.0.25"`&#x20;

### <>\<!\[CDATA\[your\_text\_here]]>\</>

Tampermonkey支持这种存储元数据的方式。TM尝试自动检测脚本是否需要启用此兼容性选项。

[Tampermonkey • 文档.html](<file/Tampermonkey • 文档_7Taj-5Ifh-.html> "Tampermonkey • 文档.html")
