ShopView = class("ShopView", LayerBase)

function ShopView:create()
	local ret = ShopView.new()
	return ret
end

function ShopView:init()
	ComMgr:getInstance():loadRes("ui/shop/shopui.plist", "ui/shop/shopui.png")
	table.insert(self._canDelRes, "ui/shop/shopui.plist")

	local _uiLayer = ComMgr:getInstance():createUILayer()
	self:addChild(_uiLayer)
	self._widget = ComMgr:getInstance():createWidget("ui/shop/ShopView.ExportJson")
	_uiLayer:addWidget(self._widget)

	self.list_shop = tolua.cast(self._widget:getChildByName("list_shop"), "ListView")
	self.list_bar = tolua.cast(self._widget:getChildByName("list_bar"), "ListView")
	self.list_bar:setVisible(false)
	self.list_bar:setTouchEnabled(false)

	local btn_close = tolua.cast(self._widget:getChildByName("btn_close"), "Button")
	btn_close:addTouchEventListener(function(sender, event_type)
		if event_type == CmdName.TouchType.ended then
			LayerCtrl:getInstance():close(self.id)
			Notifier.dispatchCmd(CmdName.Start_View_update)
		end
	end)

	local btn_shop = tolua.cast(self._widget:getChildByName("btn_shop"), "Button")

	local btn_bar = tolua.cast(self._widget:getChildByName("btn_bar"), "Button")
	btn_bar:loadTextureNormal("btn_bag_off.png", UI_TEX_TYPE_PLIST)
	btn_bar:addTouchEventListener(function(sender, event_type)
		if event_type == CmdName.TouchType.ended then
			if self.list_bar:getPositionX() > 0 then
				btn_shop:loadTextureNormal("btn_shop_off.png", UI_TEX_TYPE_PLIST)
				btn_bar:loadTextureNormal("btn_bag_normal.png", UI_TEX_TYPE_PLIST)
				self.list_shop:setPositionX(self.list_bar:getPositionX())
				self.list_shop:setVisible(false)
				self.list_shop:setTouchEnabled(false)
				self.list_bar:setPositionX(0)
				self.list_bar:setVisible(true)
				self.list_bar:setTouchEnabled(true)
			end
		end
	end)

	btn_shop:addTouchEventListener(function(sender, event_type)
		if event_type == CmdName.TouchType.ended then
			if self.list_shop:getPositionX() > 0 then
				btn_bar:loadTextureNormal("btn_bag_off.png", UI_TEX_TYPE_PLIST)
				btn_shop:loadTextureNormal("btn_shop_normal.png", UI_TEX_TYPE_PLIST)
				self.list_bar:setPositionX(self.list_shop:getPositionX())
				self.list_bar:setVisible(false)
				self.list_bar:setTouchEnabled(false)
				self.list_shop:setPositionX(0)
				self.list_shop:setVisible(true)
				self.list_shop:setTouchEnabled(true)
			end
		end
	end)
end