Timer = {}

Timer.func_id = {}

Timer.start = function(time, func, token)
	if not func or not token then
		print("缺少必要参数，func或者token")
		return
	end

	if Timer.func_id.token then
		print("该定时器已经存在，并且在执行中")
		return
	end

	local id = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
				func()
   	end, time, false)

	Timer.func_id.token = id
	print("add id=",Timer.func_id.token)
end

Timer.stop = function(token)
	if not Timer.func_id.token then
		print(token.."定时器不存在")
		return
	end
	local funcId = Timer.func_id.token
	print("remove id=",funcId)
	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(funcId)
	
	Timer.func_id.token = nil
end

Timer.clear = function()
	for k,v in pairs(Timer.func_id) do
		Timer.stop(k)
	end
end