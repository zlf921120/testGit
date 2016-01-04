ComMgr = class("ComMgr")

local _instance = nil
local _cacha_arr = {}
local _layer_mgr = {}

function ComMgr:ctor()
	if CCEGLView:sharedOpenGLView():getScaleX() > CCEGLView:sharedOpenGLView():getScaleY() then
		self.min_scale = CCEGLView:sharedOpenGLView():getScaleY()
		self.max_scale = CCEGLView:sharedOpenGLView():getScaleX()
	else
		self.min_scale = CCEGLView:sharedOpenGLView():getScaleX()
		self.max_scale = CCEGLView:sharedOpenGLView():getScaleY()
	end
end

function ComMgr:getInstance()
	if not _instance then
		_instance = ComMgr.new()
	end
	return _instance
end

function ComMgr:createWidget(file_name)
	return GUIReader:shareReader():widgetFromJsonFile(file_name)
end

function ComMgr:createUILayer(TouchPriority)
	local uilayer = TouchGroup:create()
	if TouchPriority ~= nil then
		print("设置优先级为",TouchPriority)
		uilayer:setTouchPriority(TouchPriority)
	end
	return uilayer
end

function ComMgr:loadRes(plist_path, img_path)
	print("load res=",plist_path)
	if not _cacha_arr[plist_path] then
		CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(plist_path, img_path)
		_cacha_arr[plist_path] = plist_path
	end
end

function ComMgr:removeRes(plist_path)
	print("remove res=",plist_path)
	CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFrameByName(plist_path)
	_cacha_arr[plist_path] = nil
end

--返回一个经过比例处理的Layout
function ComMgr:newLayout()
	local fit_layout = CCLayer:create()
	local globa_scalx = CCEGLView:sharedOpenGLView():getScaleX()
 	local globa_scaly = CCEGLView:sharedOpenGLView():getScaleY()

 	fit_layout:setScaleX(1/globa_scalx*self.min_scale)
 	fit_layout:setScaleY(1/globa_scaly*self.min_scale)

 	return fit_layout
end

function ComMgr:setLayerId(layer_id, layer)
	if not _layer_mgr[layer_id] then
		_layer_mgr[layer_id] = layer
	end
end

function ComMgr:getLayerById(layer_id)
	if not _layer_mgr[layer_id] then
		print("cur id is nil")
		return
	end
	return _layer_mgr[layer_id]
end

function ComMgr:removeLayer(layer_id)
	if _layer_mgr[layer_id] then
		_layer_mgr[layer_id] = nil
	end
end

function ComMgr:clearRes()
	for k,v in pairs(_cacha_arr) do
		if v then
			_instance:removeRes(v)
		end
	end
	_cacha_arr = nil
	_layer_mgr = nil
	_instance = nil
	CCTextureCache:sharedTextureCache():removeAllTextures()
end

function ComMgr:createSprByPlist(SprName)
	return CCSprite:createWithSpriteFrameName(SprName)
end

function ComMgr:getSize()
	return CCDirector:sharedDirector():getWinSize()
end

function ComMgr:getScene()
	return CCDirector:sharedDirector():getRunningScene()
end

function ComMgr:getNowTime()
	local curTime = os.date("%Y-%m-%d")
	local time_tab = _instance:substr(curTime, "-")
	return tonumber(time_tab[2]), tonumber(time_tab[3])
end

--[[
	根据分隔符分割字符串，返回分割后的table
--]]
function ComMgr:substr(s, delim)
  assert (type (delim) == "string" and string.len (delim) > 0, "bad delimiter")
  local start = 1
  local t = {}  -- results table

  -- find each instance of a string followed by the delimiter
  while true do
    local pos = string.find(s, delim, start, true) -- plain find
    if not pos then
      break
    end

    table.insert (t, string.sub (s, start, pos - 1))
    start = pos + string.len (delim)
  end -- while

  -- insert final one (after last delimiter)
  table.insert (t, string.sub (s, start))
  return t
end

function ComMgr:getData(key)
	return MyCustom:getDataByKey(key)
end

function ComMgr:setData(key, value)
	if type(value) ~= "number" then
		print("data is not value")
		return
	end
	MyCustom:setDataByKey(key, value)
end

function ComMgr:isCollision(node, pos)
	if not node then
		return false
	end
	local rect = _instance:getRect(node)
	return CCRect.containsPoint(rect, pos)
end

--[[
    获取两点之间的距离
]]
function ComMgr:getDistance(pOne, pTwo)
	print(pTwo.x, pOne.x)
	print(pTwo.y, pOne.y)
	local dx = math.abs(pTwo.x - pOne.x)
	local dy = math.abs(pTwo.y - pOne.x)
	return math.sqrt(dx * dx + dy * dy)
end

function ComMgr:getRect(node)
	local x, y = node:getPosition()
	local size = node:getContentSize()
	-- print(size.height)
	return CCRectMake(x - size.width*0.5, y - size.height*0.5, size.width, size.height)
end

local _max_lenght = 6
--获得正弦值
function ComMgr:getSinData(angle)
	local str_data = tostring(MyCustom:getSin(angle))
	local _sinData = string.sub(str_data, 0, _max_lenght)
	local _data = tonumber(_sinData)
	if math.abs(_data) > 1 then
		return 0
	end
	return tonumber(_sinData)
end

--获得余弦值
function ComMgr:getCosData(angle)
	local str_data = tostring(MyCustom:getCos(angle))
	local _cosData = string.sub(str_data, 0, _max_lenght)
	local _data = tonumber(_cosData)
	if math.abs(_data) > 1 then
		return 0
	end
	return tonumber(_cosData)
end

--获得两个向量的夹角
function ComMgr:getAngleByPos(pos1, pos2)
	local pos = ccpSub(pos2, pos1)
	local _rad = ccpToAngle(pos)
	local str_angle = tostring(math.deg(-1*_rad))
	local _angle = string.sub(str_angle, 0, 4)
	return tonumber(_angle)
end