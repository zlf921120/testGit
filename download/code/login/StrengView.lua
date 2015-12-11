StrengView = class("StrengView", LayerBase)

function StrengView:create()
	local ret = StrengView.new()
	return ret
end

function StrengView:init()
	ComMgr:getInstance():loadRes("ui/streng/strengui.plist", "ui/streng/strengui.png")
	table.insert(self._canDelRes, "ui/streng/strengui.plist")

	local _uiLayer = ComMgr:getInstance():createUILayer()
	self:addChild(_uiLayer)
	self._widget = ComMgr:getInstance():createWidget("ui/streng/StrengView.ExportJson")
	_uiLayer:addWidget(self._widget)

	local btn_close = tolua.cast(self._widget:getChildByName("btn_close"), "Button")
	btn_close:addTouchEventListener(function(sender, event_type)
		if event_type == CmdName.TouchType.ended then
			LayerCtrl:getInstance():close(self.id)
			Notifier.dispatchCmd(CmdName.Start_View_update)
		end
	end)

	self.img_air = tolua.cast(self._widget:getChildByName("img_air"), "ImageView")

	self.lab_act_icon = tolua.cast(self._widget:getChildByName("lab_act_icon"), "Label")
	self.lab_def_icon = tolua.cast(self._widget:getChildByName("lab_def_icon"), "Label")

	self.lab_name = tolua.cast(self._widget:getChildByName("lab_name"), "Label")

	self.bar_act = tolua.cast(self._widget:getChildByName("bar_act"), "LoadingBar")
	self.bar_def = tolua.cast(self._widget:getChildByName("bar_def"), "LoadingBar")

	self.lab_act_lev = tolua.cast(self._widget:getChildByName("lab_act_lev"), "Label")
	self.lab_def_lev = tolua.cast(self._widget:getChildByName("lab_def_lev"), "Label")

	self:initView()

	local btn_act = tolua.cast(self._widget:getChildByName("btn_act"), "Button")
	btn_act:addTouchEventListener(function(sender, event_type)
		if event_type == CmdName.TouchType.ended then

		end
	end)

	local btn_def = tolua.cast(self._widget:getChildByName("btn_def"), "Button")
	btn_def:addTouchEventListener(function(sender, event_type)
		if event_type == CmdName.TouchType.ended then
			
		end
	end)

end

function StrengView:initView()
	local _type = MyCustom:getDataByKey(CmdName.Air_Type)
	local _lev = MyCustom:getDataByKey(CmdName.Air_Lev * _type)
	self.img_air:loadTexture(string.format("a%d_%d.png", _type, _lev), UI_TEX_TYPE_PLIST)
	local name
	if _type == 1 then
		name = "军 刀"
	elseif _type == 2 then
		name = "红 龙"
	elseif _type == 3 then
		name = "魅 蓝"
	elseif _type == 4 then
		name = "战 旗"
	elseif _type == 5 then
		name = "铁 血"
	else
		name = "赤 焰"
	end
	self.lab_name：setText(name)
end

--[[
	1：类型
	2：等级
	3：阶段
]]
function StrengView:getStrengIcon(curtype, curLev, curStage)
	return (curtype + curLev + curStage) * 500
end