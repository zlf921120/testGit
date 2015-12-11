ActionMgr = class("ActionMgr")

local _instance = nil
local _allAction = {}

function ActionMgr:getInstance()
	if not _instance then
		_instance = ActionMgr.new()
	end
	return _instance
end

--[[
	params:起始下标
	params:图片的固定名字
	params:播放动画的总时间
	params:是否循环
]]
function ActionMgr:getActionByData(startIndex, imgName, playTime, isLoop)
	local all_img_Num = 0
	local img_index = startIndex
	local frames_arr = CCArray:create()
	while(true) do
		local sprName = imgName..tostring(img_index)..".png"
		local actionFrames = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(sprName)
		if not actionFrames then
			break
		end
		frames_arr:addObject(actionFrames)
		img_index = img_index + 1
		all_img_Num = all_img_Num + 1
	end
	local _action = CCAnimation:createWithSpriteFrames(frames_arr)
	_action:setDelayPerUnit(playTime/(all_img_Num))
	if isLoop then
		_action:setLoops(-1)
	end
	frames_arr:removeAllObjects()
	return CCAnimate:create(_action)
end

--[[
	params:要播放的动画
	params:在指定层播放动画
	params:播放的精灵的图片名
	params:播放的位置
]]
function ActionMgr:playAction(action, parent, sprName, x, y)
	local playSpr = ComMgr:getInstance():createSprByPlist(sprName)
	playSpr:setPosition(ccp(x, y))
	parent:addChild(playSpr)
	local _action = CCSequence:createWithTwoActions(action, CCCallFunc:create(function()
		playSpr:removeFromParentAndCleanup(true)
	end))
	playSpr:runAction(_action)
end

function ActionMgr:initAirAction(air_type, air_lev, isLeft)
	local _frames = CCArray:create()
	for i = 1, 5 do
		local imgName
		if isLeft then
			imgName = string.format("p%d_lv%d_r%d.png", air_type, air_lev, i)
		else
			imgName = string.format("p%d_lv%d_l%d.png", air_type, air_lev, i)
		end
		local sprFrames = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(imgName)
		_frames:addObject(sprFrames)
	end
	local reIndex = 4
	for j = 1, 3 do
		local newName
		if isLeft then
			newName = string.format("p%d_lv%d_r%d.png", air_type, air_lev, reIndex)
		else
			newName = string.format("p%d_lv%d_l%d.png", air_type, air_lev, reIndex)
		end
		reIndex = reIndex - 1
		local newFrames = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(newName)
		_frames:addObject(newFrames)
		if j == 3 then
			newName = string.format("p%d_lv%d.png", air_type, air_lev)
			newFrames = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(newName)
			_frames:addObject(newFrames)
		end
	end

	local _action = CCAnimation:createWithSpriteFrames(_frames)
	_action:setDelayPerUnit(0.1)
	_frames:removeAllObjects()
	local name
	if isLeft then
		name = CmdName.Air_Action_Left
	else
		name = CmdName.Air_Action_Right
	end
	CCAnimationCache:sharedAnimationCache():addAnimation(_action, name)
	table.insert(_allAction, name)
end

function ActionMgr:getActionByName(action_name)
	local _action = CCAnimationCache:sharedAnimationCache():animationByName(action_name)
	return CCAnimate:create(_action)
end

function ActionMgr:clearAction()
	for k,v in pairs(_allAction) do
		if v then
			CCAnimationCache:sharedAnimationCache():removeAnimationByName(v)
		end
	end
	_allAction = nil
end