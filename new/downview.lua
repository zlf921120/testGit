function printJindu(params)
	MyCustom:toLuaTest()
	MyCustom:addLuaPath()
	local path = CCFileUtils:sharedFileUtils():fullPathForFilename("cocos2dx-update-temp-package.zip")
	print("path=",path)
	local isDelete = os.remove(path)
	print("return num=", isDelete)
end

function destroy(params)
	require "code.windows.LayerCtrl"
	print("c++ 回调 lua")
	print("c++ 回调 lua")
	print("c++ 回调 lua")
	print("c++ 回调 lua")
	LayerCtrl:getInstance():destroy()
end