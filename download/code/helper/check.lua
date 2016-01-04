check = {}

check.updateCollision = function()
	local _BtLenght = ComData.playerBullet:count()-1
	local _EmLenght = ComData.enemy:count()-1
	if _BtLenght < 0 or _EmLenght < 0 then
		return
	end
	local _BtArr = CCArray:create()
	local _EmArr = CCArray:create()
	local x = nil
	local y = nil
	for i = 0, _EmLenght do
		local _Em = ComData.enemy:objectAtIndex(i)
		for j = 0, _BtLenght do
			local _Bt = ComData.playerBullet:objectAtIndex(j)
			if _Em:getId() ~= 100 then
				x, y = _Em:getPosition()
			else
				local pos = _Em:convertToWorldSpace(ccp(0, 0))
				x,y = pos.x, pos.y
			end
			if ComMgr:isCollision(_Bt, ccp(x, y)) then
				-- print("pos=",x, y)
				if (_Em:getId() ~= 100 and (not _Em:getIsHide())) or _Em:getId() == 100 then
					_BtArr:addObject(_Bt)
					local hp = _Em:getHp()
					if hp > 15 then
						_Em:updateHp(15)
					else
						_EmArr:addObject(_Em)
					end
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
		if _Em:getId() ~= 100 then
			local _parent = _Em:getParent()
			--父类有个公共的删除方法
			_parent:comRemove(_Em)
		end
		
	end

	_BtArr:removeAllObjects()
	_EmArr:removeAllObjects()
end