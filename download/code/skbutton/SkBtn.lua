SkBtn = class("SkBtn", function()
	return ComMgr:getInstance():createUILayer()
end)

function SkBtn:create()
	local ret = SkBtn.new()
	ret:init()
	return ret
end

function SkBtn:init()
	self.isCanTouch = true
	self.parent = ComMgr:getLayerById(CmdName.MainScene)

	self:initBtn()

	self.skCall = function(tag)
		if tag == CmdName.Boom then
			self.btn_boom:setBright(true)
        	self.btn_boom:setTouchEnabled(true)
		else
			self.btn_def:setBright(true)
        	self.btn_def:setTouchEnabled(true)
		end
	end

	Notifier.regist(CmdName.Skill_Btn_update, self.skCall)

end

function SkBtn:initBtn()

	local function BTN_EVENT(sender, event)
		if event ~= CmdName.TouchType.ended then
			return
		end
		local tag = sender:getTag()
		local player = self.parent:getChildByTag(CmdName.Player)
		if not player then
			ComTextTips.show("player是空的", self.parent)
			return
		end
		sender:setBright(false)
        -- sender:setTouchEnabled(false)
		if tag == CmdName.Boom then
			player:playEffect(true)
		else
			player:playEffect()
		end
	end

	self.btn_boom = Button:create()
	self.btn_boom:setPosition(ccp(600, 330))
	self.btn_boom:setTag(CmdName.Boom)
	self.btn_boom:loadTextureNormal("btn_boom_normal.png", UI_TEX_TYPE_PLIST)
	self.btn_boom:loadTexturePressed("btn_boom_pressed.png", UI_TEX_TYPE_PLIST)
	self.btn_boom:loadTextureDisabled("btn_boom_pressed.png", UI_TEX_TYPE_PLIST)
	self.btn_boom:setTouchEnabled(true)
	self.btn_boom:addTouchEventListener(BTN_EVENT)
	self:addWidget(self.btn_boom)

	self.btn_def = Button:create()
	self.btn_def:setPosition(ccp(600, 230))
	self.btn_def:setTag(CmdName.Def)
	self.btn_def:loadTextureNormal("btn_def_normal.png", UI_TEX_TYPE_PLIST)
	self.btn_def:loadTexturePressed("btn_def_pressed.png", UI_TEX_TYPE_PLIST)
	self.btn_def:loadTextureDisabled("btn_def_pressed.png", UI_TEX_TYPE_PLIST)
	self.btn_def:setTouchEnabled(true)
	self.btn_def:addTouchEventListener(BTN_EVENT)
	self:addWidget(self.btn_def)
end