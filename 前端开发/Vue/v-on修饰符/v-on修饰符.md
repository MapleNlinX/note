# v-on修饰符

## 事件修饰符

| stop                  | 调用 event.stopPropagation()  |
| --------------------- | --------------------------- |
| prevent               | 调用 event.preventDefault()   |
| capture               | 添加事件侦听器时使用 capture 模式。      |
| self                  | 只当事件是从侦听器绑定的元素本身触发时才触发回调    |
| once                  | 只触发一次回调                     |
| passive               | 以 { passive: true } 模式添加侦听器 |
| {keyCode \| keyAlias} | 只当事件是从特定键触发时才触发回调           |
| native                | 监听组件根元素的原生事件                |
| left                  | 只当点击鼠标左键时触发                 |
| right                 | 只当点击鼠标右键时触发                 |
| middle                | 只当点击鼠标中键时触发                 |

> 简单使用

```html
<!-- 只当在 event.target 是当前元素自身时才触发处理函数 -->
<!-- 比如如果是 -->
<div v-on:click.self="doThat">...</div>
```

> 从 `2.4.0` 开始，`v-on` 支持不带参数绑定一个事件/监听器键值对的对象

```html
<!-- 阻止默认点击行为，执行dothis -->
<button @click.prevent="doThis"></button>

<!-- 阻止默认点击行为，也不执行任何表达式 -->
<form @submit.prevent></form>

```

> 修饰符支持串联

```html
<!-- 阻止默认行为，也阻止冒泡 -->
<button @click.stop.prevent="doThis"></button>

<!-- 只阻止元素自身的默认行为 -->
<button @click.self.prevent="doThis"></button>

```

> 从 `2.4.0` 开始，支持对象语法

```html
<!-- 对象语法 (2.4.0+) -->
<button v-on="{ mousedown: doThis, mouseup: doThat }"></button>
```

## 系统修饰符

-   ctrl
-   alt
-   shift
-   meta（win\cmd\等 按不同操作系统对应不同的键）

```html
<!-- Alt + C -->
<input v-on:keyup.alt.67="clear">

<!-- Ctrl + Click -->
<div v-on:click.ctrl="doSomething">Do something</div>
```
