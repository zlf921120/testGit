StartView = class("StartView", LayerBase)

function StartView:create()
	local ret = StartView.new()
	return ret
end

function StartView:init()
	self.isChange = 0
	ComMgr:getInstance():loadRes("ui/start/startui.plist", "ui/start/startui.png")
	ComMgr:getInstance():loadRes("ui/bullet/user_bullet.plist", "ui/bullet/user_bullet.png")
	table.insert(self._canDelRes, "ui/start/startui.plist")



	self.bg1 = CCSprite:createWithSpriteFrameName("enter_cloud.png")

	self.bgSize = self.bg1:getContentSize()
	local winSize = ComMgr:getSize()
	self.bg1:setPosition(ccp(winSize.width*0.5, winSize.height*0.5))
	self.bg1:getTexture():setAliasTexParameters()
	self:addChild(self.bg1)

	self.bg2 = CCSprite:createWithSpriteFrameName("enter_cloud.png")
	self.bg2:setPosition(ccp(winSize.width*0.5, winSize.height*1.5))
	self.bg2:getTexture():setAliasTexParameters()
	self:addChild(self.bg2)            

	TimerMgr.add(function()
		self:addBg()
	end, 0.01, CmdName.StartBg)

	TimerMgr.add(function()
		self:shoot()
	end, 0.13, CmdName.Start_Shoot)

	local uilayer = ComMgr:getInstance():createUILayer()
	self:addChild(uilayer)
	self._widget = ComMgr:getInstance():createWidget("ui/start/StartView.ExportJson")
	uilayer:addWidget(self._widget)

	self._onViewUpdate = function()
		TimerMgr.add(function()
			self:shoot()
		end, 0.13, CmdName.Start_Shoot)
		uilayer:setVisible(true)
		uilayer:setTouchEnabled(true)
		Notifier.remove(CmdName.Start_View_update, self._onViewUpdate)
	end

	self._onUpdateData = function()
		self:updateData()
		Notifier.remove(CmdName.Start_Update_Data, self._onUpdateData)
	end

	local function Btn_Event(sender,event_type)
		if event_type == CmdName.TouchType.ended then
			local btn_tag = sender:getTag()
			local curPageIndex = self.page_air:getCurPageIndex()
			print("tag=", btn_tag)
			if btn_tag == 12 then
				self:delRes()
				LayerCtrl:getInstance():gameClose()
			elseif btn_tag == 7 then
				TimerMgr.remove(CmdName.Start_Shoot)
				uilayer:setVisible(false)
				uilayer:setTouchEnabled(false)
				local shopView = LayerCtrl:getInstance():open(CmdName.ShopView)
				ComMgr:getInstance():getScene():addChild(shopView)
				Notifier.regist(CmdName.Start_View_update, self._onViewUpdate)
			elseif btn_tag == 6 then
				TimerMgr.remove(CmdName.StartBg)
				TimerMgr.remove(CmdName.Start_Shoot)
				self:delRes()
				LayerCtrl:getInstance():close(self.id)
				--进入游戏，根据飞机的类型和等级加载对应的大图
				self:initData()
				local newScene = CCScene:create()
				local mainscene = LayerCtrl:getInstance():open(CmdName.MainScene)
				newScene:addChild(mainscene)
				SceneCtrl:getInstance():gotoScene(newScene)
			elseif btn_tag == 5 then
				ComWinTips.show("Boss模式尚未开放，敬请期待！", function()
					self:removeChildByTag(CmdName.Com_Win_Tips, false)
				end, self)
			elseif btn_tag == 14 then
				if curPageIndex > 0 then
					self.isChange = 1
					self.page_air:scrollToPage(curPageIndex - 1)
					self:initData()
				end
			elseif btn_tag == 15 then
				if curPageIndex < 5 then
					self.isChange = 1
					self.page_air:scrollToPage(curPageIndex + 1)
					self:initData()
				end
			else
				self:initData()
				TimerMgr.remove(CmdName.Start_Shoot)
				uilayer:setVisible(false)
				uilayer:setTouchEnabled(false)
				local strengView = LayerCtrl:getInstance():open(CmdName.StrengView)
				ComMgr:getInstance():getScene():addChild(strengView)
				Notifier.regist(CmdName.Start_View_update, self._onViewUpdate)
				Notifier.regist(CmdName.Start_Update_Data, self._onUpdateData)
			end
			
		end
	end



	local btn_exit = tolua.cast(self._widget:getChildByName("btn_exit"), "Button")
	btn_exit:addTouchEventListener(Btn_Event)

	local btn_shop = tolua.cast(self._widget:getChildByName("btn_shop"), "Button")
	btn_shop:addTouchEventListener(Btn_Event)

	self.btn_qh = tolua.cast(self._widget:getChildByName("btn_update"), "Button")
	self.btn_qh:addTouchEventListener(Btn_Event)

	local btn_lev = tolua.cast(self._widget:getChildByName("btn_lev"), "Button")
	btn_lev:addTouchEventListener(Btn_Event)

	local btn_boss = tolua.cast(self._widget:getChildByName("btn_boss"), "Button")
	btn_boss:addTouchEventListener(Btn_Event)

	local btn_left = tolua.cast(self._widget:getChildByName("btn_left"), "Button")
	btn_left:addTouchEventListener(Btn_Event)

	local btn_right = tolua.cast(self._widget:getChildByName("btn_right"), "Button")
	btn_right:addTouchEventListener(Btn_Event)



	self.lab_ack = tolua.cast(self._widget:getChildByName("lab_ack"), "Label")
	self.lab_def = tolua.cast(self._widget:getChildByName("lab_def"), "Label")

	self.page_air = tolua.cast(self._widget:getChildByName("pv_air"), "PageView")
	self.page_air:addEventListenerPageView(function(sender, event_type)
		local curIndex = self.page_air:getCurPageIndex()
		self.isChange = 1
		self:initData()
	end)

	self.bar_ack = tolua.cast(self._widget:getChildByName("bar_bat"), "LoadingBar")
	self.bar_def = tolua.cast(self._widget:getChildByName("bar_def"), "LoadingBar")
	
end

function StartView:addBg()
	local pos1 = self.bg1:getPositionY()
	local pos2 = self.bg2:getPositionY()
	local Speed = 2
	pos1 = pos1 - Speed
	pos2 = pos2 - Speed
	local winHeight = self.bgSize.height
	if pos1 < -winHeight * 0.5 then
		pos2 = winHeight * 0.5
		pos1 = winHeight * 1.5
	end
	if pos2 < -winHeight *0.5 then
		pos1 = winHeight * 0.5
		pos2 = winHeight * 1.5
	end
	self.bg1:setPositionY(pos1)
	self.bg2:setPositionY(pos2)
end

function StartView:initData()
	local curType = self.page_air:getCurPageIndex() + 1
	MyCustom:setDataByKey(CmdName.Air_Type, curType)
end

local delay_time = 0

function StartView:shoot()
	-- local lev = MyCustom:getDataByKey(CmdName.Air_Lev)p1_bt_lv3.png
	if self.isChange == 1 then
		delay_time = delay_time + 1
		print("time=", delay_time)
		if delay_time >= 3 then
			self.isChange = 0
			delay_time = 0
		end
		return
	end
	local _type = self.page_air:getCurPageIndex() + 1
	local show_bullet = ComMgr:getInstance():createSprByPlist(string.format("p%d_bt_lv3.png", _type))
	show_bullet:setPosition(ccp(320, 650))
	self:addChild(show_bullet)
	local _action = CCSequence:createWithTwoActions(CCMoveBy:create(0.3, ccp(0, 500)), CCCallFunc:create(function()
		show_bullet:removeFromParentAndCleanup(false)
	end))
	show_bullet:runAction(_action)
end

function StartView:getAirImg()
	local curIndex = self.page_air:getCurPageIndex() + 1
	local _panel = tolua.cast(self.page_air:getChildByName(string.format("panel_air%d", curIndex)), "Layout")
	local _airImg = tolua.cast(_panel:getChildByName("img_air"), "ImageView")
	return _airImg
end

function StartView:updateData()
	print("Notifier call back")
	local curIndex = self.page_air:getCurPageIndex() + 1
	local curLev = ComMgr:getInstance():getData(CmdName.Air_Lev * curIndex)
	local allLev = ComMgr:getInstance():getData(curIndex * CmdName.Air_Max_Lev)
	local curAckLev = ComMgr:getInstance():getData(curIndex * CmdName.Air_Ack_Lev)
	local curDefLev = ComMgr:getInstance():getData(curIndex * CmdName.Air_Def_Lev)
	self.bar_ack:setPercent((curAckLev/allLev)*100)
	self.bar_def:setPercent((curDefLev/allLev)*100)

	self.lab_def:setText(tostring(curDefLev).."/"..tostring(allLev))
	self.lab_ack:setText(tostring(curAckLev).."/"..tostring(allLev))

	local img_air = self:getAirImg()
	img_air:loadTexture(string.format("a%d_%d.png", curIndex, curLev), UI_TEX_TYPE_PLIST)
end