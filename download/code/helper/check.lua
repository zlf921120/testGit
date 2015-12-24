check = {}

check.updateCollision = function()
	local _BtLenght = ComData.playerBullet:count()-1
	local _EmLenght = ComData.enemy:count()-1
	if _BtLenght < 0 or _EmLenght < 0 then
		print("no check")
		return
	end
	-- print("xxx=",_BtLenght)
	print("yyy=",_EmLenght*_BtLenght)
	local _BtArr = CCArray:create()
	for i = 0, _EmLenght do
		local _Em = ComData.enemy:objectAtIndex(i)
		local x, y = _Em:getPosition()
		for j = 0, _BtLenght do
			local _Bt = ComData.playerBullet:objectAtIndex(j)
			if ComMgr:isCollision(_Bt, ccp(x, y)) then
				_BtArr:addObject(_Bt)
			end
		end
	end
	for i=0, _BtArr:count()-1 do
		local _Bt = _BtArr:objectAtIndex(i)
		ComData.playerBullet:removeObject(_Bt)
		_Bt:removeFromParentAndCleanup(true)
	end
	_BtArr:removeAllObjects()
end