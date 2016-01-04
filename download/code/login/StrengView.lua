StrengView = class("StrengView", LayerBase)
local _type = nil
local max_lev = nil
local _lev = nil


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
			local _oldLayer = ComMgr:getInstance():getLayerById(CmdName.StartView)
			if _oldLayer then
				_oldLayer:listenerReturn()
			end
			LayerCtrl:getInstance():close(self.id)
			Notifier.dispatchCmd(CmdName.Start_View_update)
			Notifier.dispatchCmd(CmdName.Start_Update_Data)
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

	local function checkLev()
		local ackLev = ComMgr:getInstance():getData(CmdName.Air_Ack_Lev * _type)
		local defLev = ComMgr:getInstance():getData(CmdName.Air_Def_Lev * _type)
		if ackLev/max_lev >= 1 and defLev/max_lev >= 1 then
			if _lev < 3 then
				ComWinTips.show("恭喜！战机等级提升..\n战力大幅度提升", function()
					self:removeChildByTag(CmdName.Com_Win_Tips, false)
				end, self)
				ComMgr:getInstance():setData(CmdName.Air_Lev * _type, _lev + 1)
				ComMgr:getInstance():setData(CmdName.Air_Ack_Lev * _type, _type + 1)
				ComMgr:getInstance():setData(CmdName.Air_Def_Lev * _type, _type + 1)
			else
				ComTextTips.show("战机已经完美了！", self)
			end
		end
		
	end

	local btn_act = tolua.cast(self._widget:getChildByName("btn_act"), "Button")
	btn_act:addTouchEventListener(function(sender, event_type)
		if event_type == CmdName.TouchType.ended then
			local ackLev = ComMgr:getInstance():getData(CmdName.Air_Ack_Lev * _type)
			if ackLev >= max_lev and _lev < 3 then
				ComTextTips.show("攻击等级已经达到满级！\n当战机等级提升时可以再次提升攻击等级", self)
				return
			end
			cclog("ack=%d, max=%d", ackLev, max_lev)
			if ackLev < max_lev then
				ComMgr:getInstance():setData(CmdName.Air_Ack_Lev * _type, ackLev + 1)
			end
			checkLev()
			self:updateData()
		end
	end)

	local btn_def = tolua.cast(self._widget:getChildByName("btn_def"), "Button")
	btn_def:addTouchEventListener(function(sender, event_type)
		if event_type == CmdName.TouchType.ended then
			local defLev = ComMgr:getInstance():getData(CmdName.Air_Def_Lev * _type)
			if defLev >= max_lev and _lev < 3 then
				ComTextTips.show("防御等级已经达到满级！\n当战机等级提升时可以再次提升防御等级", self)
				return
			end
			cclog("def=%d, max=%d", defLev, max_lev)
			if defLev < max_lev then
				ComMgr:getInstance():setData(CmdName.Air_Def_Lev * _type, defLev + 1)
			end
			checkLev()
			self:updateData()
		end
	end)

end


function StrengView:initView()
	_type = MyCustom:getDataByKey(CmdName.Air_Type)
	

	self:updateData()

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
	self.lab_name:setText(name)
end

function StrengView:updateData()
	_lev = MyCustom:getDataByKey(CmdName.Air_Lev * _type)
	print("lev=",_lev)
	self.img_air:loadTexture(string.format("a%d_%d.png", _type, _lev), UI_TEX_TYPE_PLIST)
	max_lev = ComMgr:getInstance():getData(CmdName.Air_Max_Lev * _type)
	local defLev = ComMgr:getInstance():getData(CmdName.Air_Def_Lev * _type)
	local ackLev = ComMgr:getInstance():getData(CmdName.Air_Ack_Lev * _type)
	self.lab_act_lev:setText("攻击等级："..tostring(ackLev).."/"..tostring(max_lev))
	self.lab_def_lev:setText("防御等级："..tostring(defLev).."/"..tostring(max_lev))

	self.bar_act:setPercent(ackLev/max_lev*100)
	self.bar_def:setPercent(defLev/max_lev*100)

	self.lab_act_icon:setText(tostring(self:getStrengIcon(_type, _lev, ackLev)))
	self.lab_def_icon:setText(tostring(self:getStrengIcon(_type, _lev, defLev)))
end

--[[
	1：类型
	2：等级
	3：阶段
]]
function StrengView:getStrengIcon(curtype, curLev, curStage)
	print("money=",(curtype + curLev + curStage) * 500)
	return (curtype + curLev + curStage) * 500
end