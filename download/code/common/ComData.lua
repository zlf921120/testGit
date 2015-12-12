ComData = {}

ComData.init = function()
	ComData.enemy = CCArray:create()
	ComData.enemy:retain()

	ComData.enemyBullet = CCArray:create()
	ComData.enemyBullet:retain()

	ComData.playerBullet = CCArray:create()
	ComData.playerBullet:retain()
end



ComData.clear = function()
	ComData.enemyBullet:removeAllObjects()
	ComData.enemyBullet:release()
	ComData.enemy:removeAllObjects()
	ComData.enemy:release()
	ComData.playerBullet:removeAllObjects()
	ComData.playerBullet:release()
	ComData = nil
end