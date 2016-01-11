ComRes = class("ComRes")

local _instance = nil
local _allRes = {}

function ComRes:getInstance()
	if not _instance then
		_instance = ComRes.new()
	end
	return _instance
end

function ComRes:addRes(resPath)
	if cc.FileUtils:getInstance():isFileExist(resPath) == false then
        print("error:加载不存在的配置文件", resPath)
        return
    end
	if _allRes[resPath] then
		print(resPath.."已经加载过")
		return
	end
	print("加载纹理",resPath)
	cc.SpriteFrameCache:getInstance():addSpriteFrames(resPath)
	_allRes[resPath] = resPath
end

function ComRes:removeRes(resPath)
	if not _allRes[resPath] then
		print(resPath.."已经被删除")
		return
	end
	print("删除纹理",resPath)
	cc.SpriteFrameCache:getInstance():removeSpriteFrameByName(resPath)
	_allRes[resPath] = nil
end

function ComRes:clear()
	for k,v in pairs(_allRes) do
		-- print(k,v)
		_instance:removeRes(k)
	end
end

function ComRes:createNodes(csb_name)
	cc.CSLoader:setCsbUseType(true)
    local node = cc.CSLoader:createNode(csb_name)
    return node
end