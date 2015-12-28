require "LuaFile"
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
        -- ComMgr:getInstance():setData(CmdName.Frist_Game, 1)
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
    -- local aa = {ccp(1,2), ccp(3,4)}
    -- print(aa[1].x, aa[1].y)
    -- print(aa[2].x, aa[2].y)
    -- local a,b,c,d,e,f,g,h,i = EnemyData.getdata(1, 2)
    -- print(a,b,c,d,e,f,g,h,i)
    local startView = LayerCtrl:getInstance():open(CmdName.StartView)
    sceneGame:addChild(startView)
    SceneCtrl:getInstance():gotoScene(sceneGame)
end

xpcall(main, __G__TRACKBACK__)
