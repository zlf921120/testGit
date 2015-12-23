require "CCBReaderLoad"
require "Cocos2d"
require "CocoStudio"
require "extern"
require "Cocos2d"
require "AudioEngine" 
require "CmdName"
require "ComMgr"
require "Notifier"
require "ComTextTips"
require "ComWinTips"
require "TimerMgr"
require "LayerBase"
require "LayerCtrl"
require "SceneCtrl"
require "ActionMgr"
require "ComData"
require "TaskText"

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

    ComMgr:getInstance():loadRes("ui/common/common.plist", "ui/common/common.png")
    math.randomseed(os.time())
    if ComMgr:getInstance():getData(CmdName.Frist_Game) ~= 1 then
        ComMgr:getInstance():setData(CmdName.Frist_Game, 1)
        for i=1,6 do
            print("111")
            --设置飞机的最大强化等级
            ComMgr:getInstance():setData(CmdName.Air_Max_Lev * i, i * 2 + 4)
            --设置初始强化等级 2 3 4 5 6 7CmdName.Air_Lev
            ComMgr:getInstance():setData(CmdName.Air_Ack_Lev * i, i + 1)
            ComMgr:getInstance():setData(CmdName.Air_Def_Lev * i, i + 1)
            --设置初始等级
            ComMgr:getInstance():setData(CmdName.Air_Lev * i, 1)
        end
    end
    -- run
    local sceneGame = CCScene:create()
    local startView = LayerCtrl:getInstance():open(CmdName.StartView)
    sceneGame:addChild(startView)
    SceneCtrl:getInstance():gotoScene(sceneGame)
end

xpcall(main, __G__TRACKBACK__)
