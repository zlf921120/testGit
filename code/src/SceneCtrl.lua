-- cclog
cclog = function(...)
    print(string.format(...))
end

SceneCtrl = class("SceneCtrl")

local _instance = nil

function SceneCtrl:getInstance()
	if not _instance then
		_instance = SceneCtrl.new()
	end
	return _instance
end

function SceneCtrl:destroy()
	_instance = nil
end

function SceneCtrl:gotoScene(scene)
	if not scene then
		print("scene is nil")
		return
	end
	if cc.Director:getInstance():getRunningScene() then
		cc.Director:getInstance():replaceScene(scene)
	else
		cc.Director:getInstance():runWithScene(scene)
	end
end