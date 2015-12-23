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
	self.other = 1
end

function EnemyMgr:addEnemy()
	if self.allWave > #EnemyData.wave[self.curWave] then
		--加载下一波敌人
		self.curWave = self.curWave + 1
		self.allWave = 1
		self.other = 1
		self.count = 0
		return
	end
	local _count, _speed, _name, _pos, _delay, _died = EnemyData.getdata(self.curWave, self.other)
	print("max=",_count)
	print("pos=",#_pos)
	print("_speed=",_speed)
	print("_name=",_name)
	for i=1, #_pos do
		print(_pos[i].x, _pos[i].y)
	end
	if self.count >= _count then
		--遍历当前wave的下一个元素
		self.allWave = self.allWave + 1
		self.count = 0
		if not _delay then
			local _newaction = CCSequence:createWithTwoActions(CCDelayTime:create(_delay), CCCallFunc:create(function()
				self:addEnemy()
			end))
			self:runAction(_newaction)
		end
		return
	end

	local start_pos = nil
	local end_pos = nil
	if _pos then
		start_pos= ccp(_pos[1].x, _pos[1].y)
		end_pos = ccp(_pos[2].x, _pos[2].y)
	end
	
	local _enemy = Enemy:create(_name)
	_enemy:setPosition(ccp(start_pos.x, start_pos.y))
	ComData.enemy:addObject(_enemy)
	self:addChild(_enemy)

	local distance = ComMgr:getInstance():getDistance(start_pos, end_pos)
	local _time = distance/_speed
	local _action = CCSequence:createWithTwoActions(CCMoveTo:create(_time, end_pos), CCCallFunc:create(function()
		ComData.enemy:removeObject(_enemy)
		_enemy:removeFromParentAndCleanup(true)
	end))
	_enemy:runAction(_action)

	self.count = self.count + 1
	self.other = self.other + 1

	local __action = CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(function()
		self:addEnemy()
	end))
	self:runAction(__action)
end