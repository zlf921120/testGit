DownView = class("DownView", function()
	CCLayer:create()
end)

function DownView:create()
	local ret = DownView.new()
	ret:init()
	return ret	
end

function DownView:init()
	self.showLab = CCLabelTTF:create("", "Arial", 30)
	self.showLab:setPosition(ccp(480, 320))
	self:addChild(self.showLab)
end

self.update = function(percent)
	if not self.showLab then
		print("lab is null")
		return
	end
	self.showLab:setString(percent)
end
