# fetch

## 简单使用

```javascript
fetch('https://api.github.com/users/ruanyf')
  .then(response => response.json())
  .then(json => console.log(json))
  .catch(err => console.log('Request Failed', err)); 

```

```javascript
//方法一
fetch('http://favserver/getdata.php?data=2')
    .then((res) => {
        if (res.status == 200) {
            return res.json();
        } else {
            return 'error';
        }
    }).then(res => {
        console.log(res.data);
    })


//方法二
async function getData() {
    const res = await fetch('http://favserver/getdata.php?data=2');
    console.log(res);
    const resText = await res.text();
    console.log(resText);
}
getData()
```

### **POST 请求**

```javascript
const response = await fetch(url, {
  method: 'POST',
  headers: {
    "Content-type": "application/x-www-form-urlencoded; charset=UTF-8",
  },
  body: 'foo=bar&lorem=ipsum',
});

const json = await response.json();
```

### **提交 JSON 数据**

```javascript
const user =  { name:  'John', surname:  'Smith'  };
const response = await fetch('/article/fetch/post/user', {
  method: 'POST',
  headers: {
   'Content-Type': 'application/json;charset=utf-8'
  }, 
  body: JSON.stringify(user) 
});
```

### **提交表单**

```javascript
const form = document.querySelector('form');

const response = await fetch('/users', {
  method: 'POST',
  body: new FormData(form)
})
```

### 文件上传

> 如果表单里面有文件选择器，可以用前一个例子的写法，上传的文件包含在整个表单里面，一起提交。

-   另一种方法是用脚本添加文件，构造出一个表单，进行上传，请看下面的例子

```javascript
const input = document.querySelector('input[type="file"]');

const data = new FormData();
data.append('file', input.files[0]);
data.append('user', 'foo');

fetch('/avatars', {
  method: 'POST',
  body: data
});

```

### **直接上传二进制数据**

```javascript
let blob = await new Promise(resolve =>   
  canvasElem.toBlob(resolve,  'image/png')
);

let response = await fetch('/article/fetch/post/image', {
  method:  'POST',
  body: blob
});

```

## fetch配置对象的完整 API

```javascript
const response = fetch(url, {
  method: "GET",
  headers: {
    "Content-Type": "text/plain;charset=UTF-8"
  },
  body: undefined,
  referrer: "about:client",
  referrerPolicy: "no-referrer-when-downgrade",
  mode: "cors", 
  credentials: "same-origin",
  cache: "default",
  redirect: "follow",
  integrity: "",
  keepalive: false,
  signal: undefined
});

```
