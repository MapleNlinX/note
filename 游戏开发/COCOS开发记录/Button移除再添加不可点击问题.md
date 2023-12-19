# 版本
- cocos2dx-lua： 3.16
# 重现
- 将一个Button（或包含Button的）结点用`removeFromParent、parent:removeChildByName`方法从父节点中移除
- 然后再用`addChild`添加到任意父节点（包括原父节点）
- button的点击事件会失效，即使重新设置点击事件也无效
# 原因
Node的remove方法中有一个cleanup参数，默认情况下都为true，当使用这些方法移除节点时，会移除该节点（包括所以子节点）的所有**动作、计时器和事件**
*但为什么重新设置事件后还是不行暂时还没看出来，不确定是版本bug还是其它原因*
```c++
void Node::removeFromParent()
{
    this->removeFromParentAndCleanup(true);
}

void Node::removeFromParentAndCleanup(bool cleanup)
{
    if (_parent != nullptr)
    {
        _parent->removeChild(this,cleanup);
    } 
}

/* "remove" logic MUST only be on this method
* If a class want's to extend the 'removeChild' behavior it only needs
* to override this method
*/
void Node::removeChild(Node* child, bool cleanup /* = true */)
{
    // explicit nil handling
    if (_children.empty())
    {
        return;
    }

    ssize_t index = _children.getIndex(child);
    if( index != CC_INVALID_INDEX )
        this->detachChild( child, index, cleanup );
}

void Node::detachChild(Node *child, ssize_t childIndex, bool doCleanup)
{
	// ··············
    if (doCleanup)
    {
        child->cleanup();
    }
    // ··············
}

void Node::cleanup()
{
#if CC_ENABLE_SCRIPT_BINDING
    if (_scriptType == kScriptTypeJavascript)
    {
        if (ScriptEngineManager::sendNodeEventToJS(this, kNodeOnCleanup))
            return;
    }
    else if (_scriptType == kScriptTypeLua)
    {
        ScriptEngineManager::sendNodeEventToLua(this, kNodeOnCleanup);
    }
#endif // #if CC_ENABLE_SCRIPT_BINDING
    
    // actions
    this->stopAllActions();
    // timers
    this->unscheduleAllCallbacks();

    _eventDispatcher->removeEventListenersForTarget(this);
    
    for( const auto &child: _children)
        child->cleanup();
}
```
# 解决
将cleanup参数设为false，不让他清除事件既可
```lua
button:removeFromParentAndCleanup(false) -- or button:removeFromParent(false)
```