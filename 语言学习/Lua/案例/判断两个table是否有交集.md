#Lua 

# 需求
- 判断两个**有序table**是否有交集，无需返回交集
# 方案
```lua
local function contains(table1,table2)
    local maxTable, minTable = table1, table2
    if #table1 < #table2 then
        maxTable, minTable = table2, table1
    end

    local set = {}
    for _, v in ipairs(minTable) do
        set[v] = true
    end
    for _, v in ipairs(maxTable) do
        if set[v] then
            return true
        end
    end

    return false
end
```
# 分析

- 先将一个table转成set表
- 循环另一个table判断是否存在set表中
- **将元素较小的表转成set表**（因为赋值比索引性能开销更大）
# 测试
```lua
local function contains(table1,table2)
	-- 先判断大小，将元素较少的table设为set表
    local maxTable, minTable = table1, table2
    if #table1 < #table2 then
        maxTable, minTable = table2, table1
    end

    local set = {}
    for _, v in ipairs(minTable) do
        set[v] = true
    end
    for _, v in ipairs(maxTable) do
        if set[v] then
            return true
        end
    end

    return false
end

local function contains2(table1,table2)
	-- 先判断大小，将元素较多的table设为set表
    local maxTable, minTable = table1, table2
    if #table1 < #table2 then
        maxTable, minTable = table2, table1
    end

    local set = {}
    for _, v in ipairs(maxTable) do
        set[v] = true
    end
    for _, v in ipairs(minTable) do
        if set[v] then
            return true
        end
    end

    return false
end

local function contains3(table1,table2)
	-- 不判断大小，将元素较少的table设为set表
    local set = {}
    for _, v in ipairs(table2) do
        set[v] = true
    end
    for _, v in ipairs(table1) do
        if set[v] then
            return true
        end
    end

    return false
end

local function contains4(table1,table2)
	-- 不判断大小，将元素较多的table设为set表
    local set = {}
    for _, v in ipairs(table1) do
        set[v] = true
    end
    for _, v in ipairs(table2) do
        if set[v] then
            return true
        end
    end

    return false
end

local function contains5(table1,table2)
	-- 双循环
    local set = {}
    for _, v1 in ipairs(table1) do
        for __,v2 in ipairs(table2) do
            if v1 == v2 then
                return true
            end
        end
    end

    return false
end

local table1 = {}
for i = 1, 1000000 do
    table.insert(table1, math.random(10000000000))
end

local table2 = {}
for i = 1, 10000 do
    table.insert(table2, math.random(10000000000))
end

local startTime = socket.gettime()
contains(table1,table2)
local startTime1 = socket.gettime()
contains2(table1,table2)
local startTime2 = socket.gettime()
contains3(table1,table2)
local startTime3 = socket.gettime()
contains4(table1,table2)
local startTime4 = socket.gettime()
contains5(table1,table2)
local startTime5 = socket.gettime()
print(startTime1 - startTime,startTime2-startTime1,startTime3-startTime2,startTime4-startTime3,startTime5-startTime4)
```
多次执行测试结果如下：
```
0.011972427368164  0.11765670776367  0.011966705322266  0.11443710327148  7.926721572876

0.0054244995117188  0.12067604064941  0.0059833526611328  0.12452697753906  1.1164951324463

0.010948181152344  0.12765693664551  0.011991500854492  0.13661193847656  6.1594390869141

0.010946273803711  0.11868286132813  0.010971069335938  0.11472129821777  7.8690223693848

0.0050125122070313  0.1246395111084  0.0049858093261719  0.12367057800293  1.7528591156006
```
在第二条结果中，方法1需要循环判断783657次，而在方法2中循环判断只需要4511次，但是方法2性能上还是差很多
# 结论
- 双循环的时间变化跨度很大，性能最差
- 增加一步#table判断不消耗性能
- 赋值操作比索引操作性能消耗较大