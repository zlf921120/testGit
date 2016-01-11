require "Utils"
StartView = class("StartView", function()
	return display.newLayer()
end)

function StartView:ctor()
	print("bbbb")
end

function StartView:create()
	local ret = StartView.new()
	ret:init()
	return ret
end

StartView.TouchEnd = function(touch, event)
	print("ev=",event)
end

function StartView:init()
	 ComRes:getInstance():addRes("res/test.plist")
    local node = ComRes:getInstance():createNodes("res/QH_UI.csb")
    self:addChild(node)

    self.btn = ccui.Button:create()
    self.btn:loadTextureNormal("res/PlayButton.png")
    self.btn:loadTexturePressed("res/PlayButton.png")
    self.btn:setPosition(cc.p(display.cx, display.cy))
    self:addChild(self.btn)
    self.btn:addTouchEventListener(function(sender, eventType)
        if eventType == ComName.TouchEnd then
            print("xxx")
        end
    end)
	
	local p1 = cc.p(30, 30)
	local p2 = cc.p(60, 60)
	local p = Utils.getAngle(p1, p2)
	-- local p = cc.pSub(p1, p2)
	-- local q = cc.pToAngleSelf(p)
	print("angle=",p)
	
	local listenner = cc.EventListenerTouchOneByOne:create()
	listenner:registerScriptHandler(function(touch, event)    
   		local location = touch:getLocation()  
   		print("onTouch")    
   		return true    
	end, cc.Handler.EVENT_TOUCH_BEGAN )  
  
	listenner:registerScriptHandler(function(touch, event)  
   		local locationInNodeX = self:convertToNodeSpace(touch:getLocation()).x         
   		print("onTouchMoved")    
	end, cc.Handler.EVENT_TOUCH_MOVED )    
  
  	-- listenner:registerScriptHandler(self.TouchEnd, cc.Handler.EVENT_TOUCH_ENDED)
	listenner:registerScriptHandler(function(touch, event)    
   		local locationInNodeX = self:convertToNodeSpace(touch:getLocation()).x    
   		print("onTouched")    
	end, cc.Handler.EVENT_TOUCH_ENDED )    
      
	local eventDispatcher = self:getEventDispatcher()    
	eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, self) 
end