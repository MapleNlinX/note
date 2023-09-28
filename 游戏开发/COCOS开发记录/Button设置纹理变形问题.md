#CocosCreator #cocos2dx 
# 版本
- Cocos Creator v1.9
- cocos2dx

### 问题：
- 在使用Cocos生成的按钮预制体时，`contentsize` 不会随着设置 `loadTextureNormal` 而变动，导致图像会发生变形。
- 但是在通过代码中使用 `ccui.Button:create()` 生成按钮时，`contentsize` 会自动设置为图片大小。
- 尽管设置 `contentsize` 不会影响与父节点或子节点的坐标值（相对于父节点的坐标值不变），但在视觉上子节点会发生位移。

### 原因：
- Cocos生成的按钮中 `_ignoreSize` 的默认值为 `false`，而代码生成的按钮默认为 `true`。

### 相关代码：

```cpp
/*
	这里是设置contentSize时的逻辑；
	当_ignoreSize为true时才会应用成纹理的大小
*/
void Widget::updateContentSizeWithTextureSize(const cocos2d::Size &size)
{
    if (_unifySize)
    {
        this->setContentSize(size);
        return;
    }
    if (_ignoreSize)
    {
        this->setContentSize(size);
    }
    else
    {
        this->setContentSize(_customSize);
    }
}

/* 
	这里是通过代码生成的button时会触发的方法；
	Cocos生成的没去研究，但通过isIgnoreContentAdaptWithSize方法可知值为false；
*/
bool Widget::init()
{
    if (ProtectedNode::init())
    {
        /* 省略其它代码 */
        ignoreContentAdaptWithSize(true);
        /* 省略其它代码 */
    }
    return false;
}
```

### 解决方案：
- 通过使用 `ignoreContentAdaptWithSize(isIgnore)` 方法，可以修改 `_ignoreSize` 的值，将其设置为 `true` 时，会忽略控件大小而使用纹理大小。
- 类似地，RichText也采用了相同的模式。Cocos生成的预制体也会限制大小，如果长度过长会自动换行显示，设置 `ignoreContentAdaptWithSize(true)` 后会让内容整行显示。