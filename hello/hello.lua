require "CCBReaderLoad"
require "Cocos2d"
require "CocoStudio"
require "extern"
require "Cocos2d"
require "AudioEngine" 

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    print("----------------------------------------")
end

local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    local cclog = function(...)
        print(string.format(...))
    end
    
    -- run
    local sceneGame = CCScene:create()
    require "code.startview.MainView"
    local test_layer = MainView:create()
    sceneGame:addChild(test_layer)
    CCDirector:sharedDirector():runWithScene(sceneGame)
end

xpcall(main, __G__TRACKBACK__)
