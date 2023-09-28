# JavaScript 模拟 sleep

```javascript
function sleep(millisecond){
    return new Promise(resolve => {
        setTimeout(resolve,millisecond)
    })
}

//async 异步执行，并且遇到await要先执行完再继续往下
async function  test(){
    const start = new Date().getTime();
    console.log(start);
    await sleep(2000);
    console.log(new Date().getTime() - start);
}

test();
```

```javascript
1631733020548
2019

```
