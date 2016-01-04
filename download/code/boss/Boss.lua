require "Gun"
Boss = class("Boss", function(_name)
	local _boss = ComMgr:getInstance():createSprByPlist(_name)
	return _boss
end)

function Boss:create(_name)
	local ret = Boss.new(_name)
	ret:init()
	return ret
end

function Boss:init()
	self.type = 1
	self:setPosition(ccp(320,480))
	self:initWidget()
end

function Boss:initWidget()
	self.tower = {}
	self.tower.down = {}
	self.tower.up = {}
	self.tower.left = {}
	self.tower.right = {}
	self.tower.alltower = {}

	--能旋转的炮
	self.canRt = {}

	local circle = self:getGun("circle.png", 0, 398*0.5, 398*0.5, EnemyData.boss[1].circle)
	local _rotateAct = CCRepeatForever:create(CCRotateBy:create(0.1, 20))
	circle:runAction(_rotateAct)

	local tower_main = self:getGun("tower_main.png", 90, 199, 199, EnemyData.boss[1].mainGun, 0.35)
	self.canRt.tm = tower_main

	local tower1_up = self:getGun("tower_1.png", 0, 200, 243, EnemyData.boss[1].oneGun, 0.35)
	self.canRt.t1u = tower1_up

	local tower1_down = self:getGun("tower_1.png", 0, 199, 155, EnemyData.boss[1].oneGun, 0.35)
	self.canRt.t1d = tower1_down

	local tower1_left = self:getGun("tower_1.png", 0, 155, 199, EnemyData.boss[1].oneGun, 0.35)
	self.canRt.t1l = tower1_left

	local tower1_right = self:getGun("tower_1.png", 0, 244, 198, EnemyData.boss[1].oneGun, 0.35)
	self.canRt.t1r = tower1_right

	local tower2_up = self:getGun("tower_2.png", 30, 199, 321, EnemyData.boss[1].secGun, 0.25)
	self.canRt.t2u = tower2_up

	local tower2_down = self:getGun("tower_2.png", 60, 199, 78, EnemyData.boss[1].secGun, 0.25)
	self.canRt.t2d = tower2_down

	local tower2_left = self:getGun("tower_2.png", 90, 77, 199, EnemyData.boss[1].secGun, 0.25)
	self.canRt.t2l = tower2_left

	local tower2_right = self:getGun("tower_2.png", 120, 321, 199, EnemyData.boss[1].secGun, 0.25)
	self.canRt.t2r = tower2_right

	local pos = {}
	pos.down = {90, ccp(199,126), ccp(199,106), ccp(199,44), ccp(199,25)}
	pos.left = {180, ccp(128,199), ccp(108,199), ccp(49, 199), ccp(29, 199)}
	pos.up = {-90, ccp(199,271), ccp(199,291), ccp(199,352), ccp(199,373)}
	pos.right = {0, ccp(274,199), ccp(294,199), ccp(354,199), ccp(374,199)}

	local _rt = nil

	for k,v in pairs(pos) do
		_rt = nil
		for _,_pos in pairs(v) do
			if _ == 1 then
				_rt = _pos
			else
				local tower = self:getGun("tower3-1.png", _rt, _pos.x, _pos.y, EnemyData.boss[1].otGun)
				if _rt == 0 then
					table.insert(self.tower.down, tower)
				elseif _rt == -90 then
					table.insert(self.tower.left, tower)
				elseif _rt == 180 then
					table.insert(self.tower.up, tower)
				else
					table.insert(self.tower.right, tower)
				end

			end
		end
	end

	local _action = CCRepeatForever:create(CCRotateBy:create(EnemyData.boss[1].rotate[2], EnemyData.boss[1].rotate[3]))
	self:runAction(_action)
	TimerMgr.add(function()
		self:shoot("ui/1.png", 2)
	end, 0.6, "boss_shoot")
	-- TimerMgr.add(function()
	-- 	print("stopAllActions")
	--18620940781
	-- 	TimerMgr.remove("boss_shoot")
	-- 	TimerMgr.remove("boss_oneTime")
	-- 	self:stopAllActions()
	-- 	self:setRotation(0)
	-- end, 3, "boss_oneTime", false)
end

function Boss:getGun(_name, _rotate, x, y, gunType, isChange)
	local _gun = Gun:create(_name)
	_gun:setRotation(_rotate)
	if isChange ~= nil then
		_gun:setAnchorPoint(ccp(isChange, 0.5))
	end
	_gun:setPosition(ccp(x, y))
	_gun:setType(gunType)
	_gun:setHp(EnemyData.boss[1].hp[gunType])
	ComData.enemy:addObject(_gun)
	table.insert(self.tower.alltower, _gun)
	self:addChild(_gun)
	return _gun
end

function Boss:getAllTower()
	return self.tower
end

local noShoot = false

function Boss:shoot(bt_name, _type)
	-- local bt = CCSprite:create(bt_name)
	-- local bt = ComMgr:getInstance():createSprByPlist(bt_name)
	if _type == 0 then
		for k,v in pairs(self.tower.alltower) do
			self:stShoot(v, bt_name, 300)
		end
	elseif _type == 1 then
		for k,v in pairs(self.tower.alltower) do
			if v:getType() ~= 1 and v:getType() ~= 5 then
				local _parent = self:getParent():getParent()
				local player = _parent:getChildByTag(CmdName.Player)
				local x,y = player:getPosition()
				-- print("pos=",x,y)
				self:rtAllGun(ccp(x,y))
				self:stShoot(v, bt_name, 300)
			end
		end
	elseif _type == 2 then
		for k,v in pairs(self.tower.alltower) do
			if v:getType() == 3 or v:getType() == 4 then
				-- local _parent = self:getParent():getParent()
				-- local player = _parent:getChildByTag(CmdName.Player)
				-- local x,y = player:getPosition()
				self:rtAllGun(ccp(320, 40))
				self:stShoot(v, bt_name, 75)
			end
		end
	else
		for k,v in pairs(self.tower.alltower) do
			if v:getType() == 3 or v:getType() == 4 or v:getType() == 5 then
				self:stShoot(v, bt_name, 300)
			end
		end
	end
end

function Boss:stShoot(sender, bt_name, speed)
	local rt = sender:getRotation()
	local bt = CCSprite:create(bt_name)
	bt:setRotation(rt)
	local pos = sender:convertToWorldSpace(ccp(0, 0))
	bt:setPosition(pos)
	self:getParent():getBtParent():addChild(bt)
	local move_x = ComMgr:getInstance():getCosData(rt)*400
	local move_y = ComMgr:getInstance():getSinData(rt)*400*-1
	local distance = math.sqrt(move_x*move_x + move_y*move_y)
	local _time = distance/speed
	-- print("time=",_time)
	bt:runAction(CCSequence:createWithTwoActions(CCMoveBy:create(_time, ccp(move_x, move_y)), CCCallFunc:create(function()
		bt:removeFromParentAndCleanup(true)
	end)))
end

function Boss:rtAllGun(pos)
	for k,v in pairs(self.canRt) do
		local _pos = v:convertToWorldSpace(ccp(0, 0))
		local rt = ComMgr:getInstance():getAngleByPos(_pos, pos)
		v:runAction(CCRotateTo:create(0.1, rt))
	end
end

local rtTime = 0
local stTime = 0
function Boss:rtAct()
	if EnemyData.boss[1].rotate[1] then
		local _action = CCRepeatForever:create(CCRotateBy:create(EnemyData.boss[1].rotate[2], EnemyData.boss[1].rotate[3]))
		self:runAction(_action)

		TimerMgr.add(function()
			if noShoot then
				stTime = stTime + 0.2
				if stTime > EnemyData.boss[1].shootDelay[self.type] then
					self.type = self.type + 1
					noShoot = false
				end
				return
			end
			
			if stTime >= EnemyData.boss[1].shootTime[self.type] then
				stTime = 0
				noShoot = true
				return
			end
			self:shoot("ui/1.png", EnemyData.boss[1].shootType[self.type])
			stTime = stTime + 0.2
		end, 0.2, CmdName.Boss_Shoot)

		TimerMgr.add(function()
			self:addTime()
		end, 1, CmdName.Boss_Rt_Act)
	end
end

function Boss:addTime()
	if rtTime >= EnemyData.boss[1].rotate[4] then
		self:stopAllActions()
		TimerMgr.remove(CmdName.Boss_Rt_Act)
		rtTime = 0
		self:mtAct()
		return
	end
	rtTime = rtTime + 1
end

function Boss:mtAct()
end