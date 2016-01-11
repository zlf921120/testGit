Utils = {}

Utils.DEG_BASE = math.pi / 180
Utils.RAD_BASE = 180 / math.pi

--[[
    获取两点之间的角度[-360, 360)
]]
Utils.getAngle = function(a, b)
	local dy = b.y - a.y
    local dx = b.x - a.x

    local rad = math.atan2(dy, dx)
    -- if rad < 0 then
    --     rad = rad + math.pi * 2
    -- end

    return rad * Utils.RAD_BASE
end

--[[
    获取两点之间的弧度, [-math.pi, math.pi)
]]
Utils.getRadian = function(a, b)
	local dy = b.y - a.y
    local dx = b.x - a.x

    return math.atan2(dy, dx)
end