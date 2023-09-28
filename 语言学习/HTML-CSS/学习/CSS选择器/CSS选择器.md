# CSS选择器

## CSS选择器分类

### 标签选择器

```css
div {}
```

### 类选择器

```css
.class {}
```

### ID选择器

```css
#id {}
```

### 全局选择器

```css
* {}
```

### 后代选择器

```css
div p {} /*只作用于div内的所有p 包括子子孙孙代*/
```

### 子选择器

```css
div>p {} /*只作用于div内的子代p 孙辈不适用*/
```

### 相邻孩子选择器

```css
div+p {}  /*只作用于与div同级并且紧跟在后面的p元素*/
```

### 伪类选择器

```css
a:link {}
div:hover {}
```

### 伪元素选择器

```css
p::after {} 
p::befor {}

```

### !important

```css
div { width:100px !important; } /*优先级最高*/
```

### 组合选择器

```css
.name.name{}    /*选择class中同时有name1和name2的*/
div.name{}      /*选择class中同时有name的div元素*/
div,p {}        /*选择所有p和div元素*/
```

### 属性选择器

#### 精准搜索

```css
[key] {}           /*作用于含有key属性的元素*/
[key="value"] {}   /*作用于含有key属性，并且值为value的元素*/
[key~="value"] {}  /*作用于含有key属性，并且值含有value的元素，但是要有空格分开
                     ，比如1 value vv */
```

#### 模糊搜索

```css
[key|=val] {} /*含有key属性的元素，并且值为以val（包括val）或val-开头的单词开头的*/
[key^=val] {} /*含有key属性的元素，并且值为以val（包括val）开头的*/
[key$=val] {} /*含有key属性的元素，并且值为以val（包括val）结尾的*/
[key*=val] {} /*含有key属性的元素，并且值含有val的*/

```

## 层叠优先级

### 优先级从高到低

-   !important，在属性后面加上!important
-   内联样式，在标签中写的`style`
-   ID选择器数量
-   类，伪类，属性选择器的数量
-   元素，伪元素选择器的数量
-   标签选择器数量
-   数量相同，后面的比前面高

### 伪类优先级从高到低

> 记忆：lvhfa（你好烦啊）

-   ：link
-   ：visited
-   ：hover
-   ：focus
-   ：active

### 按来源不同优先级从高到低

-   内联样式
-   内部样式
-   外部样式
-   浏览器用户自定义样式
-   浏览器默认样式

## 继承

-   继承的优先级最低
-   只有在没有定义样式的情况下，才会继承祖先的样式
