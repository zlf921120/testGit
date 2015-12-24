TimerMgr = {}

TimerMgr.func_id = {}


--[[
	公共定时器
	params:回调方法
	params:间隔时间
	params:定时器标志
	params:是否暂停
]]
TimerMgr.add = function(func, time, token, isLoop)
	if not func then
		print("没有回调方法")
		return
	end
	if TimerMgr.func_id[token] ~= nil then
		print("该定时器已经存在，并且在执行中")
		return
	end

	-- print("token=",type(toekn))
	-- if not type(toekn) then
	-- 	print("请指定定时器的标志")
	-- 	return
	-- end
	local fucid = nil
	if isLoop then
		fucid = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function()
			func()
		end, time, isLoop)
	else
		fucid = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function()
			func()
		end, time, false)
	end
	
	if not TimerMgr.func_id[token] then
		print("loop func id=",fucid)
		print("token = ", token)
		TimerMgr.func_id[token] = fucid
	end
end

TimerMgr.remove = function(token)
	print("stop token = ", token)
	local funcId = TimerMgr.func_id[token]
	if not funcId then
		print("没有对应回调方法")
		return
	end
	print("stop func id=",funcId)
	CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(funcId)
	TimerMgr.func_id[token]= nil
end

TimerMgr.clear = function()
	for k,v in pairs(TimerMgr.func_id) do
		if k then
			TimerMgr.remove(k)
		end
	end
	TimerMgr.func_id = nil
	TimerMgr = nil
end