ComWinTips = {}

ComWinTips._ok_func = nil


--[[
	params:正文内容
	params:确定按钮回调函数
	params:父类层
	params:顶部文字
]]
ComWinTips.show = function(text, ok_function, layer, titleText)
	if not layer then
		print("layer is nil value")
		return
	end
	if layer:getChildByTag(CmdName.Com_Win_Tips) then
		print("存在同样的提示框")
		return
	end
	ComWinTips._ok_func = ok_function
	local newtips = ComMgr:getInstance():createUILayer()
	newtips:setTag(CmdName.Com_Win_Tips)
	layer:addChild(newtips)
	local tipswidget = ComMgr:getInstance():createWidget("ui/common/TipsBox.ExportJson")
	newtips:addWidget(tipswidget)

	local lab_title = tolua.cast(tipswidget:getChildByName("lab_title"), "Label")
	if titleText then
		lab_title:setText(titleText)
	end

	local labTex = tolua.cast(tipswidget:getChildByName("lab_text"), "Label")
	labTex:setText(text)
	local btn_yes = tolua.cast(tipswidget:getChildByName("btn_yes"), "Button")
	
	local btn_no = tolua.cast(tipswidget:getChildByName("btn_no"), "Button")
	btn_no:addTouchEventListener(function(sender, event_type)
		if event_type == CmdName.TouchType.ended then
			animate(newtips)
		end
	end)

	btn_yes:addTouchEventListener(function(sender, event_type)
		if event_type == CmdName.TouchType.ended then
			if ComWinTips._ok_func then
				ComWinTips._ok_func()
			end
		end
	end)
end

function animate(context)
	if not context then
		print("不存在提示框")
		return 
	end
	context:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.2, 0.01), CCCallFunc:create(function()
        				context:removeFromParentAndCleanup(false)
        			end)
				)
   			)
end