TaskView = class("TaskView", LayerBase)

function TaskView:create()
	local ret = TaskView.new()
	return ret
end

function TaskView:init()
	local _uilayer = ComMgr:getInstance():createUILayer()
	self:addChild(_uilayer)

	local _widget = ComMgr:getInstance():createWidget("ui/task/TaskView.ExportJson")
	_uilayer:addWidget(_widget)


	local img_bg = tolua.cast(_widget:getChildByName("img_bg"), "ImageView")
	img_bg:setVisible(false)
	img_bg:setTouchEnabled(true)
	img_bg:addTouchEventListener(function(sender, event)
		self.isShowAll = 1
		self:stopAllActions()
		self:quickShow()
	end)

	self.taskLab = tolua.cast(_widget:getChildByName("lab_task"), "Label")
end

function TaskView:setShowText(text)
	self._text = text
	self.len = 1
	self.isShowAll = 0
	self:showText()
end

--[[
	递归，打字机效果
]]
function TaskView:showText()
	if self.isShowAll == 1 then
		return
	end
	if self.len > string.len(self._text) then
		local delay = CCDelayTime:create(0.6)
		local _action = CCSequence:createWithTwoActions(delay, CCCallFunc:create(function()
			LayerCtrl:getInstance():close(self.id)
		end))
		self:runAction(_action)
		return
	end
	local t1 = string.sub(self._text, self.len, self.len)
	local t2
	if t1:byte() > 128 then
		t2 = string.sub(self._text, 1, self.len+2)
		self.len = self.len + 3
	else
		t2 = string.sub(self._text, 1, self.len)
		self.len = self.len + 1
	end
	print("text=",t2)
	self.taskLab:setText(t2)
	local delay = CCDelayTime:create(0.2)
	local _action = CCSequence:createWithTwoActions(delay, CCCallFunc:create(function()
		self:showText()
	end))
	self:runAction(_action)
end

function TaskView:quickShow()
	self.taskLab:setText(self._text)
	local delay = CCDelayTime:create(0.6)
	local _action = CCSequence:createWithTwoActions(delay, CCCallFunc:create(function()
		LayerCtrl:getInstance():close(self.id)
	end))
	self:runAction(_action)
end

--[[
	 local ss = "我1a韩庚A!啊"
    -- print("len=",string.len(ss))
    -- print("utf8len=",string.utf8len(ss))
    local cc = 1
    -- print("3=",string.sub(ss, 4, 4))
    local aa
    local bb
    while(cc < string.len(ss)) do
      bb = string.sub(ss, cc, cc)
      local bt = bb:byte()
      if bt > 128 then
        aa = string.sub(ss, cc, cc+2)
        cc=cc+3
      else
        aa=string.sub(ss, cc, cc)
        cc=cc+1
      end
      print("aa=",aa)
    end
]]