
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

-- require "config"
-- require "init"
require "ComName"
require "SceneCtrl"
require "ComRes"
require "Notifier"
require "TimerMgr"
require "StartView"

local function main()
	-- cc.CSLoader:setCsbUseType(true)
    -- require("app.MyApp"):create():run()
    local _start = StartView:create()
    -- -- if not StartView then
    -- -- 	print("nil")
    -- -- end
    -- local _ss = display.newLayer()
    local _cs = display.newScene()
    _cs:addChild(_start)
    -- -- cc.Director:getInstance():runWithScene(_cs)
    -- cclog("xxxxxx")
    SceneCtrl:getInstance():gotoScene(_cs)
    -- cc.CSLoader:setCsbUseType(true)
    if cc.CSLoader:getCsbUseType() then
    	print("使用缓存")
    end
    local function a(aaa)
    	print(aaa)
    end
    local function b()
    	print("test more call func")
    end
    Notifier.add("abc", a)
    Notifier.add("abc", b)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
