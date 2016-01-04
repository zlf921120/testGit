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