require "LayerType"
LayerCtrl = class("LayerCtrl")


local _instance = nil

function LayerCtrl:getInstance()
	if not _instance then
		_instance = LayerCtrl.new()
	end
	return _instance
end

function LayerCtrl:open(layer_id)
	if not layer_id then
		print("layer_id is nil")
		return
	end
	local open_layer = nil
	print("open layer=",layer_id)
	if layer_id == CmdName.StartView then
		require "StartView"
		open_layer = StartView:create()
		open_layer.type = LayerType.second
	elseif layer_id == CmdName.MainScene then
		require "MainScene"
		open_layer = MainScene:create()
		open_layer.type = LayerType.second
	elseif layer_id == CmdName.StrengView then
		require "StrengView"
		open_layer = StrengView:create()
		open_layer.type = LayerType.second
	elseif layer_id == CmdName.ShopView then
		require "ShopView"
		open_layer = ShopView:create()
		open_layer.type = LayerType.second
	elseif layer_id == CmdName.TaskView then
		require "TaskView"
		open_layer = TaskView:create()
		open_layer.type = LayerType.second
	end

	ComMgr:getInstance():setLayerId(layer_id, open_layer)
	ComMgr:getInstance():removeLayer(CmdName.CurLayer)
    ComMgr:getInstance():setLayerId(CmdName.CurLayer, open_layer)
	open_layer:setLayerId(layer_id)
	open_layer:init()
	open_layer:listenerReturn()

	return open_layer
end

function LayerCtrl:close(layer_id)
	local curLayer = ComMgr:getInstance():getLayerById(layer_id)
	if not curLayer then
		print("layer_id有误")
		return
	end
	curLayer:close()
	ComMgr:getInstance():removeLayer(layer_id)
	ComMgr:getInstance():removeLayer(CmdName.CurLayer)
end

function LayerCtrl:gameClose()
	_instance = nil
	ComMgr:getInstance():clearRes()
	TimerMgr.clear()
	ActionMgr:clearAction()
	MyCustom:gameClose()
	EnemyData = nil
end

function LayerCtrl:destroy()
	print("game destroy")
	print("game destroy")
	print("game destroy")
	print("game destroy")
	_instance = nil
	ComMgr:getInstance():clearRes()
	TimerMgr.clear()
	ActionMgr:clearAction()
	ComData.clear()
	EnemyData = nil
end