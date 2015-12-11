LayerBase = class("LayerBase", function()
	return CCLayer:create()
end)

LayerBase.type = nil

function LayerBase:setLayerId(layer_id)
	print("cur layer id=", layer_id)
	self.id = layer_id
	self._canDelRes = {}
end

function LayerBase:close()
	print("remove layer is=",self.id)
	ComMgr:getInstance():removeLayer(self.id)
	self:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.2, 0.01), CCCallFunc:create(function()
				self:delRes()
				self:removeFromParentAndCleanup(true)
			end)
		)
	)
end

function LayerBase:addCloseBtn()
	local close_btn = Button:create()
	close_btn:setPosition(ccp(80, 580))
	self.btn_layout = ComMgr:getInstance():createUILayer(-2000)
	close_btn:setTouchEnabled(true)
	self.btn_layout:setContentSize(close_btn:getContentSize())
	self.btn_layout:addWidget(close_btn)
	self:addChild(self.btn_layout, 300)
	close_btn:setVisible(true)
	close_btn:loadTextures("btn_up_6.png", "btn_down_6.png", "", UI_TEX_TYPE_PLIST)
	close_btn:addTouchEventListener(function(sender, event_type)
			if event_type == CmdName.TouchType.ended then
				LayerCtrl:getInstance():close(self.id)
			end
		end)
end

function LayerBase:setClosePriority(touch_num)
	if self.btn_layout then
		self.btn_layout:setTouchPriority(touch_num)
	end
end

--窗体底层增加默认阴影
function LayerBase:addDefaultShadow()
	self.shadow = CCLayerColor:create(ccc4(0, 0, 0, 180))
	self:addChild(self.shadow)
end

function LayerBase:delRes()
	for k,v in pairs(self._canDelRes) do
		if v then
			ComMgr:getInstance():removeRes(v)
		end
	end
	CCTextureCache:sharedTextureCache():removeUnusedTextures()
end

function LayerBase:listenerReturn()
	self:setKeypadEnabled(true)
	self:registerScriptKeypadHandler(function(event)
		if event == "backClicked" then
			ComWinTips.show("确定要退出游戏吗？", function()
				LayerCtrl:getInstance():gameClose()
			end, self)
		end
	end)
end