local RecycleScroller = class("RecycleScroller")
--[[
    此组件适用于数据较多、cell的类不同、cell的大小不等的情况

    -- scrollView初始化参数
    params: {
        scrollView: （必填）
        space: cell之间的间隔，不包括顶部和底部（选填）
        topSpace: 顶部留空（选填）
        bottomSpace: 底部留空（选填）
        cacheLoadLength: 提前多少距离开始预加载，当大小覆盖总长时即一次性全部显加载消除停顿，但会增加初次加载时间（选填）
        cacheLoadMaxCount：预加载最大次数，默认为 1，建议不改，如果需要预加载就一次性全部加载不然意义不大（选填）
        cacheShowLength: 提前多少距离开始预显示，可减弱快速滑动时刷新不及时的情况，但会增加显示的cell（选填）
        initialContentSizeLength: 预设容器大小，如果设置成最终的大小效果最佳，如果太小会增加停顿次数（选填，建议设置成最终的大小）
        coefficient: 当内容大小超出容器大小时，扩展容器大小的系数（选填）
        isNeedDispose:是否需要在RecycleScroller销毁时将所有cell执行dispose（选填）
        dividePieces: 将内容分成几个部分，用于刷新时的优化（选填）
        onScrollToEnd: 滑动到最底部时触发的回调（选填）
        onScrollMove: 滑动时触发的回调（选填）
        isVerticalOptimize:垂直滚动时优化，开启可有效避免滚动时候扩展前回滚导致的停顿，缺点是获取centent垂直的percent会不正确,要使用getVerticalPercent获取（选填）
        preExtendContentLength:提前多少距离开始扩展content,防止刷新间回弹（选填）
    }

    -- cell数据和配置参数
    dataParams:{
        path: 节点类的路径（必填）
        data: 数据，在显示cell时会执行cell的setData方法并传入data（选填）
        marginBottom: cell的下边距，后面的cell会根据 “上一个cell的” 此参数调整此cell与上一个cell的间隔，因此只有第2-n的cell会使用（选填）
        marginTop: cell的上边距，cell会根据此参数调整与上一个cell的间隔，因此只有第2-n的cell会使用（选填）
        isJumpToStart: 初次加载后跳转到开始位置（选填）
    }

    -- cell要实现的方法（必须）
    setData: 每次显示都会适用这个方法并传入两个参数，分别是对应数据和下标
    getContentSize: 用于获取大小
    getAnchorPoint: 用于获取锚点，cell会垂直/水平对齐，可通过实现此方法修改位置

    -- tips
    1.space、marginBottom、marginTop作用会叠加
    2.垂直滚动才需要预设initialContentSizeLength，水平滚动不需要
    3.如果可以预测容器的总大小，在不使用isVerticalOptimize情况下，强烈建议预设initialContentSizeLength为容器大小
    4.重新设置内容时，可先用setInitialContentSizeLength方法重新设置容器的大小，再用setDatas设置内容
    5.如果数量不多，且容器大小不确定，可设置cacheLoadLength覆盖内容大小，即可消除第一次底部卡顿，但是会增加打开的加载速度
    6.在垂直滚动时候强烈建议使用isVerticalOptimize，开启优化，可有效避免滚动时候还没扩展之前因为回滚导致的停顿
]]
function RecycleScroller.create(params)
    local recycleScroller = RecycleScroller.new(params)
    recycleScroller:init()
    return recycleScroller
end

function RecycleScroller:ctor(params)
    self._scrollView = params.scrollView
    self._space = params.space or 0
    self._topSpace = params.topSpace or 0
    self._bottomSpace = params.bottomSpace or 0
    self._cacheLoadLength = params.cacheLoadLength or 0
    self._cacheLoadMaxCount = params.cacheLoadMaxCount or 1
    self._cacheShowLength = params.cacheShowLength or 0
    self._initialContentSizeLength = params.initialContentSizeLength or 10000
    self._isNeedDispose = params.isNeedDispose == nil and true or params.isNeedDispose
    self._coefficient = params.coefficient or 2
    self._refreshDelay = params.refreshDelay or 0.05
    self._isVerticalOptimize = params.isVerticalOptimize == nil and true or params.isVerticalOptimize
    self._preExtendContentLength = params.preExtendContentLength or 1000
    self._dividePieces = params.dividePieces or 10
    self._onScrollToEnd = params.onScrollToEnd
    self._onScrollMove = params.onScrollMove

    ----------------数据矫正--------------------------
    if self._coefficient <= 1 then
        print("invalid coefficient :" .. self._coefficient)
        self._coefficient = 2
    end
    if self._preExtendContentLength < 0 then
        print("invalid preExtendContentLength :" .. self._preExtendContentLength)
        self._preExtendContentLength = 0
    end
    if self._dividePieces < 1 then
        print("invalid dividePieces :" .. self._dividePieces)
        self._dividePieces = 1
    end
    if self._cacheShowLength > self._cacheLoadLength then
        -- 预显示比预加载还大则不需要预加载
        self._cacheLoadMaxCount = 0
    end

    self._dataParams = {}
end

function RecycleScroller:init()
    self._content = self._scrollView:getInnerContainer()
    self._originContentSize = self._scrollView:getContentSize()
    self._isVertical = self._scrollView:getDirection() == ccui.ScrollViewDir.vertical
    if self._isVerticalOptimize and self._isVertical then
        -- 垂直滚动，在需要扩展的时候让他高度向y轴的负方向扩展，目的是如果是正方向扩展，则需要调整content的位置来回到初始位置，会影响滚动
        -- 缺点是getScrolledPercentVertical不再准确，可使用getVerticalPercent替代
        self._content:setAnchorPoint(self._content:getAnchorPoint().x, 1)
    end
    self._cellContentNode = cc.Node:create()
    self._content:addChild(self._cellContentNode)

    self:_initContentSize()
    self:jumpToStart()
    self:_initLibrary(true)
    self:_initListeners()
end

function RecycleScroller:_initContentSize()
    if self._isVertical then
        if self._isVerticalOptimize and self._initialContentSizeLength < self._originContentSize.height then
            self._initialContentSizeLength = self._originContentSize.height
        end
        self._content:setContentSize(cc.size(self._originContentSize.width, self._initialContentSizeLength))
    else
        self._content:setContentSize(cc.size(self._initialContentSizeLength, self._originContentSize.height))
    end
    if self._isVertical then
        self._cellContentNode:setPosition(self._originContentSize.width / 2, self._initialContentSizeLength)
    else
        self._cellContentNode:setPosition(0, self._originContentSize.height / 2)
    end
end

--[[
    @_indexToLength: length包括自身大小、space、marginBottom、marginTop、bottomSpace，（不包括topSpace，topSpace仅体现在pos）
    @_rangPosPoint: 用于刷新优化，记录间隔节点的位置，用于在数据较多的时候减少遍历时间
]]
function RecycleScroller:_initLibrary(isInit)
    self._showingCellToIndex = {}
    self._indexToShowingCell = {}

    self._indexToPos = {}
    self._indexToLength = {}
    self._indexToTotalLength = {}

    self._rangPosPoint = {}
    if isInit then
        self._path2RecyclePoolMap = {}
    end
    self._totalCellLength = 0
    self._cacheLoadCount = 0
end

function RecycleScroller:jumpToStart(isIntercept)
    self.isIntercept = isIntercept
    if self._isVertical then
        if self._isVerticalOptimize then
            self._content:setPositionY(self._originContentSize.height)
        else
            self._scrollView:jumpToTop()
        end
    else
        self._scrollView:jumpToLeft()
    end
    self.isIntercept = false
end

function RecycleScroller:setInitialContentSizeLength(length)
    if length then
        self._initialContentSizeLength = length
        self:_initContentSize()
        self:jumpToStart(true)
    end
end

function RecycleScroller:setDatas(dataParams)
    if self._dataParams and #self._dataParams > 0 then
        -- 重新设置数据
        self:_recycleAllCell()
        self:_initLibrary(false)
    end
    self:jumpToStart(true)
    self._dataParams = dataParams

    self._divideNum = 1 -- 用于刷新优化，每隔多少个节点记录一下，1为不记录
    if #dataParams > self._dividePieces then
        self._divideNum = math.floor(#dataParams / self._dividePieces)
    end
    self:refreshScrollView()
end

function RecycleScroller:refreshScrollView()
    ------------------计算要显示的范围-----------------------------
    local curtContentSize = self._content:getContentSize()
    local start, over, offset, endLength = nil, nil, nil, nil
    if self._isVertical then
        if self._isVerticalOptimize then
            offset = self._content:getPositionY() - self._originContentSize.height
            start = -offset
        else
            offset = self._content:getPositionY()
            start = -(curtContentSize.height - self._originContentSize.height + offset)
        end
        over = start - self._originContentSize.height
        -- 提前显示
        start = start + self._cacheShowLength
        over = over - self._cacheShowLength
        endLength = -over
    else
        offset = self._content:getPositionX()
        start = -offset
        over = start + self._originContentSize.width
        -- 提前显示
        start = start - self._cacheShowLength
        over = over + self._cacheShowLength
        endLength = over
    end

    ------------------计算从哪个位置开始显示------------
    local startIndex = 1
    if self._divideNum ~= 1 then
        local isFind = false
        for i, pointParams in ipairs(self._rangPosPoint) do
            if start > pointParams.posPoint then
                startIndex = (i - 1) * self._divideNum
                isFind = true
                break
            end
            if i == #self._rangPosPoint and not isFind then
                startIndex = (i - 1) * self._divideNum
            end
        end
        startIndex = startIndex ~= 0 and startIndex or 1
    end

    ------------------------回收---------------------------
    for index, cell in pairs(self._indexToShowingCell) do
        if index < startIndex or not self:_checkIsNeedShow(index, start, over) then
            self:_recycleCell(cell)
        end
    end

    ------------------------显示和预加载-------------------
    local isHasCreate = false
    local isOverShow = false
    local isFinishPreload = #self._indexToPos == #self._dataParams
    local cacheLoadLength = 0
    for index = startIndex, #self._dataParams do
        local pos = self._indexToPos[index]
        local cell = self._indexToShowingCell[index]
        if pos then
            if not isOverShow and not cell and self:_checkIsNeedShow(index, start, over) then
                local nodeCell = self:_dequeueCell(index)
                nodeCell:setPosition(pos)
            end
        else
            isHasCreate = true
            self:_buildNewCell(index)
        end
        if not isOverShow and self._indexToTotalLength[index] + self._topSpace >= endLength then
            -- 已显示到底边,不需要再显示
            isOverShow = true
            if index == #self._indexToPos then
                -- 已达滚动底部，刷新预加载
                self._cacheLoadCount = math.min(self._cacheLoadCount + 1,self._cacheLoadMaxCount)
                cacheLoadLength = self._cacheLoadLength * (math.min(self._cacheLoadCount,self._cacheLoadMaxCount))
            end
        end
        if isOverShow and not isFinishPreload and self._totalCellLength + self._topSpace >= endLength + cacheLoadLength then
            -- 已预加载完成,不需要新增
            isFinishPreload = true
        end

        if isOverShow and isFinishPreload then
            break
        end
    end

    -----------------------扩展容器---------------------------
    if isHasCreate then
        self:refreshScrollerContent()
    end
end

function RecycleScroller:_buildNewCell(index)
    local nodeCell = self:_dequeueCell(index)
    local size = nodeCell:getContentSize()
    local length = self._isVertical and size.height or size.width
    local p = -self._totalCellLength - self._topSpace
    self._totalCellLength = self._totalCellLength + length
    if index > 1 then
        local marginTop = self._dataParams[index].marginTop or 0
        local marginBottom = self._dataParams[index - 1].marginBottom or 0
        p = p - self._space - marginBottom - marginTop
        self._totalCellLength = self._totalCellLength + self._space + marginBottom + marginTop
        length = length + self._space + marginBottom + marginTop
    end
    if index == #self._dataParams then
        self._totalCellLength = self._totalCellLength + self._bottomSpace
        length = length + self._bottomSpace
    end
    local anchorPoint = nodeCell:getAnchorPoint()
    local pos
    if self._isVertical then
        pos = cc.p(-(1 - anchorPoint.x) * (size.width / 2), p + (1 - anchorPoint.y) * size.height)
    else
        p = -p
        pos = cc.p(p + anchorPoint.x * size.height, -size.height / 2)
    end
    if self._divideNum ~= 1 then
        if index % self._divideNum == 0 or index == #self._dataParams then
            table.insert(self._rangPosPoint, {index = index, posPoint = p})
        end
    end
    nodeCell:setPosition(pos)

    self:_setIndexData({index = index, totalLength = self._totalCellLength, pos = pos, length = length})
end

function RecycleScroller:_checkIsNeedShow(index, start, over)
    local pos = self._indexToPos[index]
    local cellLength = self._indexToLength[index]
    local posParm = self._isVertical and pos.y or pos.x
    if index > 1 then
        local marginTop = self._dataParams[index].marginTop or 0
        local marginBottom = self._dataParams[index - 1].marginBottom or 0
        if self._isVertical then
            posParm = posParm + self._space + marginBottom + marginTop
        else
            posParm = posParm - self._space - marginBottom - marginTop
        end
    end
    if self._isVertical then
        return posParm - cellLength <= start and posParm >= over
    else
        return posParm + cellLength >= start and posParm <= over
    end
end

function RecycleScroller:refreshScrollerContent()
    local contentSize = self._content:getContentSize()
    local length = self._topSpace + self._totalCellLength
    local target = self._isVertical and "height" or "width"
    local lastLength = contentSize[target]

    if #self._indexToPos == #self._dataParams and contentSize[target] ~= length then
        contentSize[target] = math.max(self._originContentSize[target], length)
        self._content:setContentSize(contentSize)
        print("recommend initialContentSize " .. target .. ":" .. contentSize[target])
    elseif length > contentSize[target] then
        while length > contentSize[target] do
            contentSize[target] = contentSize[target] * self._coefficient
        end
        self._content:setContentSize(contentSize)
    end

    if self._isVertical and lastLength ~= contentSize[target] then
        self._cellContentNode:setPositionY(contentSize[target])
        if not self._isVerticalOptimize then
            -- 由于修改setContentSize大小改变是以xy正方向改变的，但是实际想要的y轴是向下增加，所以要偏移回原来的位置
            local offsetLength = contentSize[target] - lastLength
            self._content:setPositionY(self._content:getPositionY() - offsetLength)
            self._scrollView:scrollToPercentVertical(self:getVerticalPercent() + 1, 1, true)
        end
    end
end

function RecycleScroller:getVerticalPercent()
    local percent
    if self._isVerticalOptimize then
        local y = self._content:getPositionY()
        local offsetY = y - self._originContentSize.height
        local totalHeight = self._content:getContentSize().height - self._originContentSize.height
        percent = offsetY / totalHeight * 100
    else
        percent = self._scrollView:getScrolledPercentVertical()
    end

    if percent ~= percent then
        --判斷值是否為NAN
        percent = 100
    end
    percent = percent > 100 and 100 or percent
    percent = percent < 0 and 0 or percent

    return percent
end

function RecycleScroller:getHorizontalPercent()
    local percent = self._scrollView:getScrolledPercentHorizontal()
    if percent ~= percent then
        --判斷值是否為NAN
        percent = 100
    end
    percent = percent > 100 and 100 or percent
    percent = percent < 0 and 0 or percent
    return percent
end

function RecycleScroller:jumpToIndex(index)
    -- 使用此功能时节点必须已生成
    local pos = self._indexToPos[index]
    if not pos then
        return
    end
    if self._isVertical then
        local offset = -pos.y
        if self._isVerticalOptimize then
            offset = offset + self._originContentSize.height
            self._content:setPositionY(offset)
            self:_onListenerFunc(nil, ccui.ScrollviewEventType.containerMoved)
        else
            local totalHeight = self._content:getContentSize().height - self._originContentSize.height
            self._scrollView:jumpToPercentVertical(offset / totalHeight * 100)
        end
    else
        local offset = pos.x
        local totalWidth = self._content:getContentSize().width - self._originContentSize.width
        self._scrollView:jumpToPercentHorizontal(offset / totalWidth * 100)
    end
end

function RecycleScroller:getCurtShowFirstIndex()
    local i = nil
    for index, _ in pairs(self._indexToShowingCell) do
        if i == nil or index < i then
            i = index
        end
    end
    return i
end

function RecycleScroller:_setIndexData(datas)
    local index = datas.index

    self._indexToPos[index] = datas.pos
    self._indexToLength[index] = datas.length
    self._indexToTotalLength[index] = datas.totalLength
end

------------------------回收-----------------------------------------
function RecycleScroller:_createNewCell(path)
    local cell = require(path).create()
    self._cellContentNode:addChild(cell)
    return cell
end

function RecycleScroller:_getRecyclePoolByPath(path)
    if not self._path2RecyclePoolMap[path] then
        self._path2RecyclePoolMap[path] = {}
    end
    return self._path2RecyclePoolMap[path]
end

function RecycleScroller:_recycleCell(cell)
    cell:setVisible(false)
    local index = self._showingCellToIndex[cell]
    self._showingCellToIndex[cell] = nil
    self._indexToShowingCell[index] = nil
    local recyclePool = self:_getRecyclePoolByPath(self._dataParams[index].path)
    table.insert(recyclePool, cell)
end

function RecycleScroller:_recycleAllCell()
    for _, cell in pairs(self._indexToShowingCell) do
        self:_recycleCell(cell)
    end
end

function RecycleScroller:_dequeueCell(index)
    local cell = nil
    local recyclePool = self:_getRecyclePoolByPath(self._dataParams[index].path)
    if #recyclePool <= 0 then
        cell = self:_createNewCell(self._dataParams[index].path)
    else
        cell = table.remove(recyclePool, 1)
        cell:setVisible(true)
    end
    self._showingCellToIndex[cell] = index
    self._indexToShowingCell[index] = cell
    local data = self._dataParams[index].data
    cell:setData(data, index)
    return cell
end

function RecycleScroller:_preExtendContent()
    -- 避免在滚动过程中 ，需要扩展content但是还没扩展，引起回弹，影响体验，所以提前检测并扩展
    if #self._indexToPos == #self._dataParams then
        return
    end
    local contentSize = self._content:getContentSize()
    if self._isVertical then
        if not self._isVerticalOptimiz then return end -- 如果垂直滚动没开启优化则会在扩展时使用scrollToPercentVertical，所以不用预扩展
        local posY = self._content:getPositionY()
        if contentSize.height - posY <= self._preExtendContentLength then
            while contentSize.height - posY <= self._preExtendContentLength do
                contentSize.height = contentSize.height * self._coefficient
            end
            self._content:setContentSize(contentSize)
            self._cellContentNode:setPositionY(contentSize.height)
        end
    else
        local posX = self._content:getPositionX()
        if contentSize.width + posX <= self._preExtendContentLength then
            while contentSize.width + posX <= self._preExtendContentLength do
                contentSize.width = contentSize.width * self._coefficient
            end
            self._content:setContentSize(contentSize)
        end
    end
    
end

function RecycleScroller:_onListenerFunc(sender, evenType)
    if evenType == ccui.ScrollviewEventType.containerMoved then
        if self.isIntercept then
            return
        end
        self:_preExtendContent()
        if self.isRefreshing then
            self.delayRefresh = true
        else
            self.isRefreshing = true
            self:refreshScrollView()
            callFunc(self._onScrollMove)
            self.scheduler =
                sche.performAfterDelay(
                function()
                    self.isRefreshing = false
                    if self._scrollView and self._scrollView:isValid() and self.delayRefresh then
                        self.delayRefresh = false
                        self:refreshScrollView()
                        callFunc(self._onScrollMove)
                    end
                end,
                self._refreshDelay
            )
        end
    elseif evenType == ccui.ScrollviewEventType.bounceBottom then
        if self._scrollView:getDirection() == ccui.ScrollViewDir.vertical then
            callFunc(self._onScrollToEnd)
        end
    elseif evenType == ccui.ScrollviewEventType.bounceRight then
        if self._scrollView:getDirection() == ccui.ScrollViewDir.horizontal then
            callFunc(self._onScrollToEnd)
        end
    end
end

function RecycleScroller:_initListeners()
    if self._isInitListeners then
        return
    end
    self._scrollView:addEventListener(handler(self, self._onListenerFunc))
    self._isInitListeners = true
end

function RecycleScroller:getIndexToShowingCellMap()
    return self._indexToShowingCell
end

function RecycleScroller:dispose()
    if self.scheduler then
        sche.unschedule(self.scheduler)
    end
    if self._isNeedDispose then
        for _, pool in pairs(self._path2RecyclePoolMap) do
            for i, cell in ipairs(pool) do
                if cell.dispose then
                    cell:dispose()
                end
            end
        end
    end
end

return RecycleScroller
