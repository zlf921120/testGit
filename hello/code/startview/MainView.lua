MainView = class("MainView", function()
	return CCLayer:create()
end)

function MainView:create()
	local ret = MainView.new()
	ret:init()
	return ret
end

function MainView:init()
    AudioEngine.playMusic("sound/background.mp3", true)

    local bg = CCSprite:create("ui/bg.jpg")
    bg:setPosition(ccp(480, 320))
    self:addChild(bg)

	local test_lab = CCLabelTTF:create("test hot dasdsadsa", "Arial", 30)
	test_lab:setPosition(ccp(480, 320))
	self:addChild(test_lab)
end