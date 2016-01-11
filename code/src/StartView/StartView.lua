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

function StartView:init()
	local _ss = display.newSprite("Star.png")
	_ss:setPosition(cc.p(480, 320))
	cclog("xxx")
	self:addChild(_ss)
end
print("aaaa")