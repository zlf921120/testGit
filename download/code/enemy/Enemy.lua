Enemy = class("Enemy", function(_name)
	-- local name = EnemyData.info[_type].name
	return ComMgr:getInstance():createSprByPlist(_name)	
end)

function Enemy:create(_name)
	local ret = Enemy.new(_name)
	ret:init()
	return ret
end

function Enemy:init()
	self.hp = 0
	self.isdied = false
	self.id = -1
	self.index = 1
	self.hide = false
	self.allHp = 0
end

function Enemy:setHp(_hp)
	self.hp = _hp
end

function Enemy:setAllHp(_all)
	self.allHp = _all
end

function Enemy:getHp()
	return self.hp
end

function Enemy:setIsDied(_died)
	self.isdied = _died
end

function Enemy:getIsDied()
	return self.isdied
end

function Enemy:setId(_id)
	self.id = _id
end

function Enemy:getId()
	return self.id
end

function Enemy:setIndex(_index)
	self.index = _index
end

function Enemy:getIndex()
	return self.index
end

function Enemy:setIsHide(_hide)
	self.hide = _hide
end

function Enemy:getIsHide()
	return self.hide
end

function Enemy:createHp()
	self.hpBg = ComMgr:getInstance():createSprByPlist("hpbg.png")
	local size = self:getContentSize()
	local x,y = self:getPosition()
	local pos = self:convertToNodeSpace(ccp(x, y + size.height*0.5))
	self.hpBg:setPosition(pos)
	self:addChild(self.hpBg)
	local hpSpr = ComMgr:getInstance():createSprByPlist("hp.png")
	self.hpPt = CCProgressTimer:create(hpSpr)
	self.hpPt:setType(1)
	self.hpPt:setMidpoint(ccp(0, 0.5))
	self.hpPt:setBarChangeRate(ccp(1, 0))
	self.hpPt:setPosition(pos)
	self.hpPt:setPercentage(100)
	self:addChild(self.hpPt)
end

function Enemy:updateHp(hurt)
	local _percentage = (self.hp - hurt)/self.allHp * 100

	if _percentage <= 0 then
		_percentage = 0
	end
	if self.hpPt then
		self.hpPt:setPercentage(_percentage)
	end
	self:setHp(self.hp - hurt)
end

--隐身的循环
function Enemy:action7Help(curPos, _speed)
	if not self then
		return
	end

	local targetPos = ccp(math.random(200, 500), math.random(300, 800))
	local distance = ComMgr:getInstance():getDistance(targetPos, curPos)
	local _time = distance/_speed

	local _bt = CCMoveTo:create(_time, targetPos)
	local _fi = nil
	
	if self.hide then
		_fi = CCFadeIn:create(0.8)
		self.hide = false
	else
		_fi = CCFadeOut:create(0.8)
		self.hide = true
	end

	local _actArr = CCArray:create()
	_actArr:addObject(_bt)
	_actArr:addObject(_fi)
	local _sp = CCSpawn:create(_actArr)
	self:runAction(_sp)

	local _action = CCSequence:createWithTwoActions(CCDelayTime:create(1.5), CCCallFunc:create(function()
		if self ~= nil then
			self:action7Help(targetPos, _speed)
		end
	end))
	self:runAction(_action)
end

--绕圈的循环
function Enemy:action3Help(_pos, _speed, start_index, end_index)
	if not self then
		return
	end

	local index = self:getIndex()
	local s_pos = _pos[index]
	index = index + 1
	self:setIndex(index)
	if index > end_index then
		index = start_index
		self:setIndex(index)
	end

	local targetPos = _pos[index]
	local distance = ComMgr:getInstance():getDistance(s_pos, targetPos)
	local _time = distance/_speed

	local _action = CCSequence:createWithTwoActions(CCMoveTo:create(_time, targetPos), CCCallFunc:create(function()
		self:action3Help(_pos, _speed, start_index, end_index)
	end))

	self:runAction(_action)
end

--停顿后飞走
function Enemy:action6Help(targetPos, _pos, _speed)
	if not self then
		return
	end

	local distance = ComMgr:getInstance():getDistance(targetPos, _pos[3])
	local _time = distance/_speed

	local dt = CCDelayTime:create(2.3)
	local bt = CCMoveTo:create(_time, _pos[3])
	local cf = CCCallFunc:create(function()
		self:getParent():comRemove(self)
	end)
	local _actArr = CCArray:create()
	_actArr:addObject(dt)
	_actArr:addObject(bt)
	_actArr:addObject(cf)
	local _action = CCSequence:create(_actArr)

	self:runAction(_action)

end