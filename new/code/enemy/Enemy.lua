Enemy = class("Enemy", function(_name)
	-- local name = EnemyData.info[_type].name
	return ComMgr:getInstance():createSprByPlist(_name)	
end)

function Enemy:create(_name)
	local ret = Enemy.new(_name)
	return ret
end