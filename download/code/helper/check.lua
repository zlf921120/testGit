check = {}

check.updateCollision = function()
	local _BtLenght = ComData.playerBullet:count()-1
	local _EmLenght = ComData.enemy:count()-1
	if _BtLenght < 0 or _EmLenght < 0 then
		return
	end
	local _BtArr = CCArray:create()
	local _EmArr = CCArray:create()
	for i = 0, _EmLenght do
		local _Em = ComData.enemy:objectAtIndex(i)
		local x, y = _Em:getPosition()
		for j = 0, _BtLenght do
			local _Bt = ComData.playerBullet:objectAtIndex(j)
			if ComMgr:isCollision(_Bt, ccp(x, y)) and (not _Em:getIsHide()) then
				_BtArr:addObject(_Bt)
				local hp = _Em:getHp()
				if hp > 10 then
					_Em:updateHp(15)
				else
					_EmArr:addObject(_Em)
				end
			end
		end
	end

	for i=0, _BtArr:count()-1 do
		local _Bt = _BtArr:objectAtIndex(i)
		ComData.playerBullet:removeObject(_Bt)
		_Bt:removeFromParentAndCleanup(true)
	end

	for i=0, _EmArr:count()-1 do
		local _Em = _EmArr:objectAtIndex(i)
		local _parent = _Em:getParent()
		--父类有个公共的删除方法
		_parent:comRemove(_Em)
	end

	_BtArr:removeAllObjects()
	_EmArr:removeAllObjects()
end