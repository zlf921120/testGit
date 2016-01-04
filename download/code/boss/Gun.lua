Gun = class("Gun", function(_name)
	return ComMgr:getInstance():createSprByPlist(_name)	
end)

function Gun:create(_name)
	local ret = Gun.new(_name)
	ret:init()
	return ret
end

function Gun:init()
	self.hp = 0
	self.id = 100
	self.type = 0
end

function Gun:getId()
	return self.id
end

function Gun:setHp(_hp)
	self.hp = _hp
end

function Gun:getHp()
	return self.hp
end

function Gun:setType(_type)
	self.type = _type
end

function Gun:getType()
	return self.type
end

function Gun:updateHp(hurt)
	self.hp = self.hp - hurt
end