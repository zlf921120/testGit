Notifier = {}

local _fn = {}

Notifier.add = function(id, func)
	if not func then
		print("缺少必要参数，回调函数")
		return
	end
	if _fn.id then
		print("为"..id.."添加多个函数,lenght=", table.maxn(_fn.id))
		-- return
	else
		_fn.id = {}
		print("add func id=", id)
	end
	table.insert(_fn.id, func)
end

Notifier.call = function(id, params)
	local fnCall = _fn.id 
	if not fnCall then
		print("找不到对应的函数")
		return
	end
	for k,v in pairs(fnCall) do
		if not params then
			v()
		else
			v(params)
		end
	end
	
end

Notifier.remove = function(id)
	if not _fn.id then
		print(id.."没有注册")
		return
	end
	print("remove id=",id)
	_fn.id = nil
end

Notifier.clear = function()
	for k,v in pairs(_fn) do
		if v then
			Notifier.remove(k)
		end
	end
end