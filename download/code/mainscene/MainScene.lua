require "Player"

MainScene = class("MainScene", LayerBase)

function MainScene:create()
	local ret = MainScene.new()
	return ret
end

function MainScene:init()
	local curType = MyCustom:getDataByKey(CmdName.Air_Type)
	local curLev = MyCustom:getDataByKey(CmdName.Air_Lev * curType)

	local plistName = string.format("ui/plane/p%d_lv%d.plist", curType, curLev)
	local pngName = string.format("ui/plane/p%d_lv%d.png", curType, curLev)

	local boom_plist = string.format("ui/effect/boom_%d.plist", curLev - 1)
	local boom_png = string.format("ui/effect/boom_%d.png", curLev - 1)
	local def_plist = string.format("ui/effect/energy_%d.plist", curLev - 1)
	local def_png = string.format("ui/effect/energy_%d.png", curLev - 1)
	ComMgr:getInstance():loadRes(boom_plist, boom_png)
	ComMgr:getInstance():loadRes(def_plist, def_png)
	table.insert(self._canDelRes, boom_plist)
	table.insert(self._canDelRes, def_plist)

	self.allBullet = CCSpriteBatchNode:create("ui/bullet/user_bullet.png")
	self:addChild(self.allBullet)

	ComMgr:getInstance():loadRes(plistName, pngName)
	table.insert(self._canDelRes, plistName)

	require "SkBtn"
	self._skBtn = SkBtn:create()
	self:addChild(self._skBtn)

	ActionMgr:getInstance():initAirAction(curType, curLev)
	ActionMgr:getInstance():initAirAction(curType, curLev, true)

	self.player = Player:create(curType, curLev)
	self.playerSize = self.player:getContentSize()
	self.player:setPosition(ccp(320, self.playerSize.height*0.5))
	self:addChild(self.player)
	self.player:setTag(CmdName.Player)

	TimerMgr.add(function()
		self.player:shoot()
	end, 0.1, CmdName.Player_Shoot)

	self.posDiffX = nil
	self.posDiffY = nil
	local function onTouch(eventType, x, y)
		if eventType == "began" then
			self.posDiffX = x
			self.posDiffY = y
			return true
		elseif eventType == "moved" then
			local diffX = x - self.posDiffX
			local diffY = y - self.posDiffY
			
			self:updatePlayerPos(diffX, diffY)
			self.posDiffX = x
			self.posDiffY = y
		end
	end

	self:registerScriptTouchHandler(onTouch)
    self:setTouchEnabled(true)
end

function MainScene:BgMove()

end

function MainScene:initBtn()
	self.btn_boom = Button:create()
	self.btn_boom:setPosition(ccp(600, 330))
	self.btn_boom:setTag(1)
	self.btn_boom:loadTextureNormal("btn_boom_normal.png", UI_TEX_TYPE_PLIST)
	self.btn_boom:loadTexturePressed("btn_boom_pressed.png", UI_TEX_TYPE_PLIST)
	self.btn_boom:setTouchEnabled(true)
	local boom_layer = ComMgr:getInstance():createUILayer()
	self:addChild(boom_layer, 100)
	boom_layer:addWidget(self.btn_boom)

	self.btn_def = Button:create()
	self.btn_def:setPosition(ccp(600, 230))
	self.btn_def:setTag(2)
	self.btn_def:loadTextureNormal("btn_def_normal.png", UI_TEX_TYPE_PLIST)
	self.btn_def:loadTexturePressed("btn_def_pressed.png", UI_TEX_TYPE_PLIST)
	self.btn_def:setTouchEnabled(true)
	boom_layer:addWidget(self.btn_def)
end

function MainScene:updatePlayerPos(diffX, diffY)
	if self.player then
		local posX = self.player:getPositionX() + diffX
		local posY = self.player:getPositionY() + diffY
		if posX >= self.playerSize.width*0.5 and posX <= 640 - self.playerSize.width*0.5 then
			self.player:setPositionX(posX)
			if diffX >= 5 then
				if self.player:getIsPlay() == 0 then
					self.player:setIsPlay(1)
					self.player:runAction(self.player:getAction())
				end
			end
		end
		if posY >= self.playerSize.height*0.5 and posY <= 960 - self.playerSize.height*0.5 then
			self.player:setPositionY(posY)
			if diffX <= -5 then
				if self.player:getIsPlay() == 0 then
					self.player:setIsPlay(1)
					self.player:runAction(self.player:getAction(true))
				end
			end
		end
	end
end

function MainScene:getBulletParent()
	return self.allBullet
end