ComTextTips = {}


--[[
	params:提示的内容
	params:父类层
]]
ComTextTips.show = function(text, sender)
	if sender then
		local oldtips = sender:getChildByTag(CmdName.Com_Text_Tips)
		if oldtips then
			oldtips:stopAllActions()
			oldtips:runAction(CCSequence:createWithTwoActions(CCScaleTo:create(0.2, 0.01), CCCallFunc:create(function()
        			oldtips:removeFromParentAndCleanup(false)
        			ComTextTips.createNewTips(sender, text)
   				end))
   			)
   		else
   			ComTextTips.createNewTips(sender, text)
		end
		
	end
end

ComTextTips.createNewTips = function(layer, text)
	local newtips = ComMgr:getInstance():createUILayer()
	newtips:setTag(CmdName.Com_Text_Tips)
	local tipswidget = ComMgr:getInstance():createWidget("ui/common/TipsText.ExportJson")
	local labTxt = tolua.cast(tipswidget:getChildByName("lab_title"),"Label")
	labTxt:setText(text)

	local img9bg = tolua.cast(tipswidget:getChildByName("img_bgaleart"),"ImageView")
    img9bg:setSize(CCSizeMake( labTxt:getSize().width + 50, labTxt:getSize().height + 20 ))

	newtips:addWidget(tipswidget)
	layer:addChild(newtips)
	local arr = CCArray:create()
    arr:addObject(CCScaleTo:create(0.12, 1.1))
    arr:addObject(CCScaleTo:create(0.1,1))
   	arr:addObject(CCDelayTime:create(1))
    arr:addObject(CCScaleTo:create(0.1,0.01))
    arr:addObject(CCCallFunc:create(function()
       	newtips:removeFromParentAndCleanup(false)
   	end))
   	newtips:stopAllActions()
    newtips:runAction(CCSequence:create(arr))
end