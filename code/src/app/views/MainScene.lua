
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- add background image

    -- cc.SpriteFrameCache:getInstance()
    ComRes:getInstance():addRes("res/test.plist")
    local node = ComRes:getInstance():createNodes("res/QH_UI.csb")
    -- self:addChild(node)

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
    -- display.setClickEvent(self.btn, function(sender, eventType)
    --     print("xxx")
    -- end)
    -- display.newSprite("MainSceneBg.jpg")
    --     :move(display.center)
    --     :addTo(self)
    
    -- -- add play button
    -- local playButton = cc.MenuItemImage:create("PlayButton.png", "PlayButton.png")
    --     :onClicked(function()
    --         -- self:getApp():enterScene("PlayScene")
    --         Notifier.call("abc", 111)
    --         -- Notifier.remove("abc")
    --     end)

    -- local playButton1 = cc.MenuItemImage:create("PlayButton.png", "PlayButton.png")
    --     :move(480, 320)
    --     :onClicked(function()
    --         -- self:getApp():enterScene("PlayScene")
    --         -- Notifier.call("abc", 111)
    --         Timer.clear()
    --         -- Timer.stop("abc")
    --     end)
    -- cc.Menu:create(playButton, playButton1)
    --     :move(display.cx, display.cy - 200)
    --     :addTo(self)
    -- Timer.start(1, function()
    --     self:testSchedu()
    -- end, "abc")
    -- cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
    --     self:testSchedu()
    -- end, 1)
end

function MainScene:testSchedu()
    -- body
    print("scheduleScriptFunc")
end

return MainScene
