Player = class("Player", function(air_type, air_lev)
	local sprName = string.format("p%d_lv%d.png", air_type, air_lev)
	return ComMgr:getInstance():createSprByPlist(sprName)
end)

function Player:create(air_type, air_lev)
	local ret = Player.new(air_type, air_lev)
	self._type = air_type
	ret:init()
	return ret
end

function Player:init()
	self.isPlayAction = 0
	self.canSk = 0
end

function Player:setIsPlay(_isPlay)
	self.isPlayAction = _isPlay
end

function Player:getIsPlay()
	return self.isPlayAction
end

function Player:getAction(isLeft)
	local aminate
	if isLeft then
		aminate = ActionMgr:getActionByName(CmdName.Air_Action_Left)
	else
		aminate = ActionMgr:getActionByName(CmdName.Air_Action_Right)
	end
	local _action = CCSequence:createWithTwoActions(aminate, CCCallFunc:create(function()
		self:setIsPlay(0)
	end))
	return _action
end

function Player:playEffect(isBoom)
	if isBoom then
		print("play boom")
		if self.canSk == 1 then
			ComTextTips.show("技能释放中,请稍候..", self:getParent())
			return
		end
		self.canSk = 1
		self:runBoomEfc()
		TimerMgr.add(function()
			self:runBoomEfc()
		end, 0.9, CmdName.Boom_Efc)
	else
		print("play def")
		if self.canSk == 2 then
			ComTextTips.show("技能释放中,请稍候..", self:getParent())
			return
		end
		self.canSk = 2
		self:runDefEfc()
		TimerMgr.add(function()
			self:runDefEfc()
		end, 0.8, CmdName.Def_Efc)
	end
end

function Player:shoot()
end

local cur_boom_num = 0
local cur_def_num = 0

function Player:runBoomEfc()
	local curLev = MyCustom:getDataByKey(CmdName.Air_Lev * self._type)
	if cur_boom_num >= 9 then
		TimerMgr.remove(CmdName.Boom_Efc)
		cur_boom_num = 0
		self.canSk = 0
		Notifier.dispatchCmd(CmdName.Skill_Btn_update, CmdName.Boom)
		return
	end
	local parent = self:getParent()
	local rondom_X = math.random(50, 590)
	local rondom_Y = math.random(50, 910)
	cclog("x = %d, y = %d", rondom_X, rondom_Y)
	local _action = ActionMgr:getInstance():getActionByData(0, string.format("boom_%d_", curLev - 1), 0.9)
	ActionMgr:getInstance():playAction(_action, parent, string.format(CmdName.Bomb_Png_Name, curLev - 1), rondom_X, rondom_Y)
	cur_boom_num = cur_boom_num + 1
end

function Player:runDefEfc()
	local curLev = MyCustom:getDataByKey(CmdName.Air_Lev * self._type)
	if cur_def_num >= curLev * 3 + 2 then
		TimerMgr.remove(CmdName.Def_Efc)
		cur_def_num = 0
		self.canSk = 0
		Notifier.dispatchCmd(CmdName.Skill_Btn_update, CmdName.Def)
		return
	end
	local pos = self:convertToNodeSpace(ccp(self:getPositionX(), self:getPositionY()))
	local _action = ActionMgr:getInstance():getActionByData(0, string.format("energy_%d_", curLev - 1), curLev * 0.3 + 0.8)
	ActionMgr:getInstance():playAction(_action, self, string.format(CmdName.Def_Png_Name, curLev - 1), pos.x, pos.y)
	cur_def_num = cur_def_num + 1
end