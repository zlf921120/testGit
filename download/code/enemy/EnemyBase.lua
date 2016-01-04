EnemyBase = class("EnemyBase", function(_name)
	return ComMgr:getInstance():createSprByPlist(_name)	
end)

EnemyBase.allHp = 0

EnemyBase.hp = 0

function EnemyBase:create(_name)
	local ret = EnemyBase.new(_name)
	-- ret:init()
	return ret
end

function EnemyBase:updateHp(hurt)
	local _percentage = (self.hp - hurt)/self.allHp * 100

	if _percentage <= 0 then
		_percentage = 0
	end
	if self.hpPt then
		self.hpPt:setPercentage(_percentage)
	end
	self:setHp(self.hp - hurt)
end

function EnemyBase:setHp(_hp)
	self.hp = _hp
end

function EnemyBase:setAllHp(_all)
	self.allHp = _all
end

function EnemyBase:getHp()
	return self.hp
end

function EnemyBase:createHp()
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