require "XArray"

Notifier = {}
--[[
	类似于Global里面的事件，不过这个可以支持闭包
--]]

--发送消息
Notifier.dispatchCmd = nil
--注册
Notifier.regist = nil
--取消注册
Notifier.remove = nil
--哈希表
local fnMap = {}
--------------华丽的分割线-----------------------
--[[
	创建回调的结构体
--]]
local CreateDeletegate = function()
	local ret = {}
	ret.fnCallback = nil
	ret.context = nil
	ret.key = nil
	ret.instance = nil
	return ret
end
--[[
	发送指令
	@param cmdName
	@param param
--]]
Notifier.dispatchCmd = function(cmdName , param)
	local array = fnMap[cmdName]
	if(array == nil)then
		return
	else
		if(array.dirty)then
			array:cleanUp()
		end
		local v = array.pool
		local i ,it
		for i = 1 , #v do
			-- it = v[i]
			local needRemove
			local delegate = v[i]
			local callback = delegate.fnCallback
			needRemove = callback(param, delegate.context)
			-- local needRemove = v[i].fnCallback(param , v[i].context)
			if(needRemove)then
				array:removeAt(i)
			end
		end
	end
end
--[[
	注册事件
	@param cmdName 事件名
	@param fnCallback function(param , context) --todo end
	@param context
	@param instance 回调函数的实例/nil
--]]
Notifier.regist = function(cmdName,fnCallback,context)
	local array = fnMap[cmdName]
	local it
	local needAdd = false
	if(array == nil)then
		array = XArray.create()
		fnMap[cmdName] = array
		needAdd = true
	else
		if(array:findIf(
			function(x)
				if(x == nil)then
					return  false 
				end
				return x.fnCallback == fnCallback 
			end) == nil)then
			needAdd = true
		end
	end
	if(needAdd)then
		it = CreateDeletegate()
		it.fnCallback = fnCallback
		it.context = context
		it.key = cmdName
		array:add(it)
	end
end

--[[
	移除事件
--]]
Notifier.remove = function(cmdName,fnCallback)
	local array = fnMap[cmdName]
	if(array ~= nil)then
		local it ,idx = array:findIf(
		function(x)
			if(x ~= nil)then
				return x.fnCallback == fnCallback
			else
				return false
			end
		end)
		array:removeAt(idx)
	end
end

--[[
	移除事件监听
--]]
Notifier.removeByName = function(cmdName)
	fnMap[cmdName] = nil
end