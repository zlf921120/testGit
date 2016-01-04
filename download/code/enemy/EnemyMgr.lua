EnemyMgr = class("EnemyMgr", function()
	return CCLayer:create()
end)

function EnemyMgr:create()
	local ret = EnemyMgr.new()
	ret:init()
	return ret
end

function EnemyMgr:init()
	self.curWave = 1
	self.count = 0
	self.allWave = 1
	self.other = 2
	--是否全部死光再加载
	self.diedCall = false
	--死光之后回调再次加载
	self.bossBt = CCSpriteBatchNode:create("ui/1.png")
	self:addChild(self.bossBt, 10)
	self.diedCallBack = function()
		self.diedCall = false
		self:addEnemy()
	end
	--注册观察者，退出主场景要删除观察者
	Notifier.regist(CmdName.Died_Call, self.diedCallBack)
end

function EnemyMgr:getBtParent()
	if not self.bossBt then
		return nil
	end
	return self.bossBt
end

function EnemyMgr:addEnemy()
	if self.allWave >= #EnemyData.wave[self.curWave] then
		--加载下一波敌人
		self.curWave = self.curWave + 1
		self.allWave = 1
		self.other = 2
		self.count = 0
		require "Boss"
		ComMgr:getInstance():loadRes("ui/boss/boss1.plist", "ui/boss/boss1.png")
		local _boss = Boss:create("boss_1.png")
		-- ComData.enemy:addObject(_boss)
		self:addChild(_boss)
		return
	end
	self.actionid = EnemyData.getId(self.curWave, self.other)
	print("id=",self.actionid)
	if self.actionid == 1 or self.actionid == 9 or
	   self.actionid == 10 then
		self:runAction1()
	elseif self.actionid == 2 or self.actionid == 5 then
		self:runAction2()
	elseif self.actionid == 3 then
		self:runAction3()
	elseif self.actionid == 4 then
		self:runAction4()
	elseif self.actionid == 6 then
		self:runAction5()
	elseif self.actionid == 7 then
		self:runAction6()
	elseif self.actionid == 8 then
		self:runAction7()
	end
end

--moveto销毁
function EnemyMgr:runAction1()
	local _count, _speed, _name, _pos, _dic, start_index, end_index, _hp, _isshow, _delay, _died = EnemyData.getdata(self.curWave, self.other)
	if self:comCheck(_count, _delay, _died) then
		return
	end

	local _enemy = nil
	local distance = nil
	local _action = nil
	local x,y
	if _dic == 2 then
		_enemy = self:comAdd(_name, ccp(math.random(100, 550), _pos[1].y), 1, _hp, _isshow)
		x,y = self:getParent():getChildByTag(CmdName.Player):getPosition()
		distance = ComMgr:getInstance():getDistance(_pos[1], ccp(x, y))
	else
		_enemy = self:comAdd(_name, _pos[1], 1, _hp, _isshow)
		distance = ComMgr:getInstance():getDistance(_pos[1], _pos[2])
	end
	
	local _time = distance/_speed

	if _dic == 2 then
		_action = CCSequence:createWithTwoActions(CCMoveTo:create(_time, ccp(x, y)), CCCallFunc:create(function()
			if _dic == 0 or _dic == 2 then
				self:comRemove(_enemy)
			end	
		end))
	else
		_action = CCSequence:createWithTwoActions(CCMoveTo:create(_time, _pos[2]), CCCallFunc:create(function()
			if _dic == 0 or _dic == 2 then
				self:comRemove(_enemy)
			end	
		end))
	end
	
	_enemy:runAction(_action)

	self:comFunc(0.3)
end

--moveto停留，不销毁
function EnemyMgr:runAction2()
	local _count, _speed, _name, _pos, _dic, start_index, end_index, _hp, _isshow, _delay, _died = EnemyData.getdata(self.curWave, self.other)

	if self:comCheck(_count, _delay, _died) then
		return
	end

	local s_pos = nil
	local e_pos = nil
	if _dic ~= 0 then
		s_pos = ccp(_pos[1].x, _pos[1].y + 190 * self.count)
		e_pos = ccp(120 * self.count * _dic + _pos[2].x, s_pos.y)
	else
		s_pos = ccp(_pos[1].x + self.count * 120, _pos[1].y)
		e_pos = ccp(s_pos.x, _pos[2].y)
	end
	local _enemy = self:comAdd(_name, s_pos, 1, _hp, _isshow)

	local distance = ComMgr:getInstance():getDistance(s_pos, e_pos)
	local _time = distance/_speed
	print("distance=",distance)

	local _action = CCMoveTo:create(_time, e_pos)
	_enemy:runAction(_action)

	self:comFunc(0.3)
end

--循环moveto，不销毁
function EnemyMgr:runAction3()
	local _count, _speed, _name, _pos, _dic, start_index, end_index, _hp, _isshow, _delay, _died = EnemyData.getdata(self.curWave, self.other)
	
	if self:comCheck(_count, _delay, _died) then
		return
	end

	local _enemy = self:comAdd(_name, _pos[1], 1, _hp, _isshow)

	_enemy:action3Help(_pos, _speed, start_index, end_index)

	self:comFunc(0.3)
end

--贝塞尔，销毁
function EnemyMgr:runAction4()
	local _count, _speed, _name, _pos, _dic, start_index, end_index, _hp, _isshow, _delay, _died = EnemyData.getdata(self.curWave, self.other)
	
	if self:comCheck(_count, _delay, _died) then
		return
	end

	local _enemy = self:comAdd(_name, _pos[1], 1, _hp, _isshow)

	local _bez_pos = ccBezierConfig()
	_bez_pos.endPosition = _pos[4]
	_bez_pos.controlPoint_1 = _pos[2]
	_bez_pos.controlPoint_2 = _pos[3]
	local _bez = CCBezierTo:create(1.5, _bez_pos)
	local _rotate = CCRotateBy:create(1.5, 180)
	local _sp = self:getOneTimeAct(_bez, _rotate)
	local _action = CCSequence:createWithTwoActions(_sp, CCCallFunc:create(function()
		self:comRemove(_enemy)
	end))

	_enemy:runAction(_action)

	self:comFunc(0.25)
end

--随机直线运动，销毁
function EnemyMgr:runAction5()
	local _count, _speed, _name, _pos, _dic, start_index, end_index, _hp, _isshow, _delay, _died = EnemyData.getdata(self.curWave, self.other)
	
	if self:comCheck(_count, _delay, _died) then
		return
	end

	local x = math.random(80, 580)
	local _enemy = self:comAdd(_name, ccp(x, _pos[1].y), 1, _hp, _isshow)

	local distance = math.abs(_pos[1].y - _pos[2].y)
	local _time = distance/_speed
	-- print(_pos[1].y, _pos[2].y)
	print("time=",_time)
	local _action = CCSequence:createWithTwoActions(CCMoveTo:create(_time, ccp(x, _pos[2].y)), CCCallFunc:create(function()
		self:comRemove(_enemy)
	end))

	_enemy:runAction(_action)

	self:comFunc(0.4)
end

--停顿后走，销毁
function EnemyMgr:runAction6()
	local _count, _speed, _name, _pos, _dic, start_index, end_index, _hp, _isshow, _delay, _died = EnemyData.getdata(self.curWave, self.other)
	
	if self:comCheck(_count, _delay, _died) then
		return
	end

	local _enemy = self:comAdd(_name, _pos[1], 1, _hp, _isshow)


	local targetPos = ccp(_pos[2].x + self.count * 120, _pos[2].y)
	local distance = ComMgr:getInstance():getDistance(_pos[1], targetPos)
	local _time = distance/_speed
	_enemy:runAction(CCMoveTo:create(_time, targetPos))

	local _action = CCSequence:createWithTwoActions(CCDelayTime:create(0.6), CCCallFunc:create(function()
		_enemy:action6Help(targetPos, _pos, _speed)
		self.count = self.count + 1
		self:addEnemy()
	end))

	self:runAction(_action)


end

--隐身
function EnemyMgr:runAction7()
	local _count, _speed, _name, _pos, _dic, start_index, end_index, _hp, _isshow, _delay, _died = EnemyData.getdata(self.curWave, self.other)
	
	if self:comCheck(_count, _delay, _died) then
		return
	end

	local _enemy = self:comAdd(_name, _pos[1], 1, _hp, _isshow)

	local targetPos = ccp(math.random(100, 300), math.random(100, 550))
	local distance = ComMgr:getInstance():getDistance(targetPos, _pos[1])
	local _time = distance/_speed

	local _bt = CCMoveTo:create(_time, targetPos)
	local _fo = CCFadeOut:create(0.8)
	local _sp = self:getOneTimeAct(_bt, _fo)
	_enemy:setIsHide(true)
	_enemy:runAction(_sp)

	local _action = CCSequence:createWithTwoActions(CCDelayTime:create(0.6), CCCallFunc:create(function()
		_enemy:action7Help(targetPos, _speed)
		self.count = self.count + 1
		self:addEnemy()
	end))

	self:runAction(_action)
end























































































function EnemyMgr:comCheck(curCount, _delay, _died)
	print("is died=", _died)
	if self.count >= curCount then
		self.allWave = self.allWave + 1
		self.other = self.other + 1
		self.count = 0
		if _died == 0 then
			self.diedCall = false
			local _newaction = CCSequence:createWithTwoActions(CCDelayTime:create(_delay), CCCallFunc:create(function()
				self:addEnemy()
			end))
			self:runAction(_newaction)
		else
			self.diedCall = true
		end
		return true
	else
		return false
	end
end

function EnemyMgr:getFlag()
	return self.diedCall
end

function EnemyMgr:comFunc(dt)
	self.count = self.count + 1
	local _action = CCSequence:createWithTwoActions(CCDelayTime:create(dt), CCCallFunc:create(function()
		self:addEnemy()
	end))
	self:runAction(_action)
end

function EnemyMgr:comRemove(sender)
	if sender then
		ComData.enemy:removeObject(sender)
		if ComData.enemy:count() == 0 then
			if self:getFlag() then
				Notifier.dispatchCmd(CmdName.Died_Call)
			end
		end
		sender:removeFromParentAndCleanup(true)
	end
end

function EnemyMgr:comAdd(_name, pos, index, _hp, _isshow)
	local _enemy = Enemy:create(_name)
	_enemy:setHp(_hp)
	_enemy:setAllHp(_hp)
	if _isshow == 1 then
		_enemy:createHp()
	end
	_enemy:setPosition(pos)
	ComData.enemy:addObject(_enemy)
	self:addChild(_enemy)
	_enemy:setIndex(index)
	return _enemy
end

--同时动作
function EnemyMgr:getOneTimeAct(...)
	local _actTab = {...}
	local _actArr = CCArray:create()
	for i,v in ipairs(_actTab) do
		_actArr:addObject(v)
	end
	local _sp = CCSpawn:create(_actArr)
	return _sp
end

--顺序动作
function EnemyMgr:getOrderAct(...)
	local _actTab = {...}
	local _actArr = CCArray:create()
	for i,v in ipairs(_actTab) do
		_actArr:addObject(v)
	end
	local _sp = CCSequence:create(_actArr)
	return _sp
end