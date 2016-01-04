EnemyData = {}

EnemyData.path = "ui/enemy/"

EnemyData.wave = {}
EnemyData.delay = {}
EnemyData.died = {}
EnemyData.info = {}
EnemyData.plist = {}

EnemyData.boss = {}


EnemyData.wave[1] = {1,2}

EnemyData.plist[1] = {"enemy1", "enemy2", "enemy3", "enemy4", "enemy6", "enemy7", "enemy8", "enemy9", "enemy10"}

EnemyData.delay[1] = {0.1}

EnemyData.died[1] = {1}

EnemyData.info[1] = {} 
EnemyData.info[2] = {} 
EnemyData.info[3] = {} 
EnemyData.info[4] = {} 
EnemyData.info[5] = {} 
EnemyData.info[6] = {}
EnemyData.info[7] = {}
EnemyData.info[8] = {}
EnemyData.info[9] = {}
EnemyData.info[10] = {}
EnemyData.info[11] = {}
EnemyData.info[12] = {}
EnemyData.info[13] = {}


EnemyData.boss[1] = {}
EnemyData.boss[1].circle = 1
EnemyData.boss[1].mainGun = 2
EnemyData.boss[1].oneGun = 3
EnemyData.boss[1].secGun = 4
EnemyData.boss[1].otGun = 5


--[[
	action:
	1表示一次性运动，销毁
	2、5表示停留运动，不销毁
	3表示绕圈运动，不销毁
	4表示贝塞尔曲线，销毁
	6表示随机直线运动，销毁
	7表示停顿后飞走，销毁
	8表示隐身，不销毁
	9代表高血，不销毁(保护其他敌机而存在)
	10代表射向玩家，自爆，销毁
]]


--一次性运动，销毁
EnemyData.info[1].enemyCount = 4
EnemyData.info[1].speed = 400
EnemyData.info[1].pos = {ccp(680, 800), ccp(-80, 200)}
EnemyData.info[1].name = "e3.png"
EnemyData.info[1].isLoop = false
EnemyData.info[1].startPos = nil
EnemyData.info[1].endPos = nil
EnemyData.info[1].action = 1
EnemyData.info[1].dic = 0
EnemyData.info[1].hp = 155
EnemyData.info[1].isShow = 1
EnemyData.info[1].isPlay = 1
EnemyData.info[1].actName = ""

--停留运动，不销毁  横向
EnemyData.info[2].enemyCount = 3
EnemyData.info[2].speed = 300
EnemyData.info[2].pos = {ccp(-80, 430), ccp(200, 430)}
EnemyData.info[2].name = "e3.png"
EnemyData.info[2].startPos = nil
EnemyData.info[2].endPos = nil
EnemyData.info[2].action = 2
EnemyData.info[2].dic = 1
EnemyData.info[2].hp = 165
EnemyData.info[2].isShow = 1

--停留运动，不销毁  横向
EnemyData.info[3].enemyCount = 3
EnemyData.info[3].speed = 300
EnemyData.info[3].pos = {ccp(730, 430), ccp(440, 430)}
EnemyData.info[3].name = "e3.png"
EnemyData.info[3].startPos = nil
EnemyData.info[3].endPos = nil
EnemyData.info[3].action = 2
EnemyData.info[3].dic = -1
EnemyData.info[3].hp = 165
EnemyData.info[3].isShow = 1

--绕圈运动，不销毁
EnemyData.info[4].enemyCount = 4
EnemyData.info[4].speed = 250
EnemyData.info[4].pos = {ccp(-50, -80), ccp(200, 600), ccp(320, 750), ccp(440, 600), ccp(320, 450)}
EnemyData.info[4].name = "e3.png"
EnemyData.info[4].startPos = 2
EnemyData.info[4].endPos = 5
EnemyData.info[4].action = 3
EnemyData.info[4].dic = -1
EnemyData.info[4].hp = 120
EnemyData.info[4].isShow = 1

--贝塞尔曲线，销毁
EnemyData.info[5].enemyCount = 8
EnemyData.info[5].speed = 250
EnemyData.info[5].pos = {ccp(-50, 860), ccp(750, 750), ccp(750, 200), ccp(-50, 266)}
EnemyData.info[5].name = "e3.png"
EnemyData.info[5].startPos = 2
EnemyData.info[5].endPos = 5
EnemyData.info[5].action = 4
EnemyData.info[5].dic = -1
EnemyData.info[5].hp = 180
EnemyData.info[5].isShow = 0

--停留运动，不销毁  纵向
EnemyData.info[6].enemyCount = 3
EnemyData.info[6].speed = 300
EnemyData.info[6].pos = {ccp(200, -80), ccp(200, 800)}
EnemyData.info[6].name = "e3.png"
EnemyData.info[6].startPos = nil
EnemyData.info[6].endPos = nil
EnemyData.info[6].action = 5
EnemyData.info[6].dic = 0
EnemyData.info[6].hp = 180
EnemyData.info[6].isShow = 1

--停留运动，不销毁  纵向
EnemyData.info[7].enemyCount = 3
EnemyData.info[7].speed = 300
EnemyData.info[7].pos = {ccp(200, 1030), ccp(200, 760)}
EnemyData.info[7].name = "e3.png"
EnemyData.info[7].startPos = nil
EnemyData.info[7].endPos = nil
EnemyData.info[7].action = 5
EnemyData.info[7].dic = 0
EnemyData.info[7].hp = 180
EnemyData.info[7].isShow = 1

--随机直线运动，销毁  下至上
EnemyData.info[8].enemyCount = 8
EnemyData.info[8].speed = 400
EnemyData.info[8].pos = {ccp(0, -50), ccp(0, 1000)}
EnemyData.info[8].name = "e3.png"
EnemyData.info[8].startPos = nil
EnemyData.info[8].endPos = nil
EnemyData.info[8].action = 6
EnemyData.info[8].dic = 0
EnemyData.info[8].hp = 200
EnemyData.info[8].isShow = 1

-- 随机直线运动，销毁  上至下
EnemyData.info[9].enemyCount = 8
EnemyData.info[9].speed = 400
EnemyData.info[9].pos = {ccp(0, 1000), ccp(0, -50)}
EnemyData.info[9].name = "e3.png"
EnemyData.info[9].startPos = nil
EnemyData.info[9].endPos = nil
EnemyData.info[9].action = 6
EnemyData.info[9].dic = 0
EnemyData.info[9].hp = 200
EnemyData.info[9].isShow = 1

-- 停顿后飞走，销毁
EnemyData.info[10].enemyCount = 3
EnemyData.info[10].speed = 400
EnemyData.info[10].pos = {ccp(-80, 960), ccp(200, 760), ccp(750, 1000)}
EnemyData.info[10].name = "e3.png"
EnemyData.info[10].startPos = nil
EnemyData.info[10].endPos = nil
EnemyData.info[10].action = 7
EnemyData.info[10].dic = 0
EnemyData.info[10].hp = 200
EnemyData.info[10].isShow = 1

--隐身，不销毁
EnemyData.info[11].enemyCount = 4
EnemyData.info[11].speed = 400
EnemyData.info[11].pos = {ccp(-80, -80), ccp(100, 760), ccp(1000, 750)}
EnemyData.info[11].name = "e3.png"
EnemyData.info[11].startPos = nil
EnemyData.info[11].endPos = nil
EnemyData.info[11].action = 8
EnemyData.info[11].dic = 0
EnemyData.info[11].hp = 200
EnemyData.info[11].isShow = 0

--高血  肉盾
EnemyData.info[12].enemyCount = 1
EnemyData.info[12].speed = 100
EnemyData.info[12].pos = {ccp(-80, 400), ccp(320, 400)}
EnemyData.info[12].name = "e3.png"
EnemyData.info[12].startPos = nil
EnemyData.info[12].endPos = nil
EnemyData.info[12].action = 9
EnemyData.info[12].dic = 1
EnemyData.info[12].hp = 350
EnemyData.info[12].isShow = 1

-- 射向玩家，自爆，销毁
EnemyData.info[13].enemyCount = 8
EnemyData.info[13].speed = 333
EnemyData.info[13].pos = {ccp(-80, 1000)}
EnemyData.info[13].name = "e3.png"
EnemyData.info[13].startPos = nil
EnemyData.info[13].endPos = nil
EnemyData.info[13].action = 10
EnemyData.info[13].dic = 2
EnemyData.info[13].hp = 178
EnemyData.info[13].isShow = 1


EnemyData.boss[1].hp = {800, 400, 1000, 1300, 600}
EnemyData.boss[1].rotate = {true, 0.1, 50, 5}
EnemyData.boss[1].pos = {ccp(160, 640), ccp(320, 480), ccp(480, 640), ccp(320, 800), ccp(320, 640), ccp(320, 480), ccp(320, 730), ccp(160, 730), ccp(640, 730)}
EnemyData.boss[1].isLoop = true
EnemyData.boss[1].startPos = 8
EnemyData.boss[1].endPos = 9
--循环持续的时间，时间到了就换别的方式
EnemyData.boss[1].loopTime = 3
--[[
	发射类型：
	0，火力全开
	1，只开main,1和2
	2，只开main和3
	3，只开1，2和3
]]
EnemyData.boss[1].shootType = {0,1,3,2,3,1,0,0,2}
--发射间隔的时间,比持续时间少1个长度
EnemyData.boss[1].shootDelay = {0.8, 1, 0.8, 1.1, 1, 1, 1}
--发射持续的时间
EnemyData.boss[1].shootTime = {1,1,1,1,1,1,1,1}






--[[
	@params:wave_index  大的波数 EnemyData.wave[wave_index]
	@params:other_index  具体的下标 EnemyData.wave[wave_index][other_index]
	注：died数组和delay数组用的下标都是 other_index - 1
		died数组和delay数组的第一个下标要用wave_index  要不然就报错
]]
EnemyData.getdata = function(wave_index, other_index)
	local _index1 = EnemyData.wave[wave_index]
	if not _index1 then
		return
	end

	local _info = _index1[other_index - 1]
	local _enemyCount = EnemyData.info[_info].enemyCount
	local _speed = EnemyData.info[_info].speed
	local _name = EnemyData.info[_info].name
	local _pos = EnemyData.info[_info].pos
	local _isLoop = EnemyData.info[_info].isLoop
	local _startPos = EnemyData.info[_info].startPos
	local _endPos = EnemyData.info[_info].endPos
	local _dic = EnemyData.info[_info].dic
	local _hp = EnemyData.info[_info].hp
	local _isShow = EnemyData.info[_info].isShow
	if other_index > 1 then
		return _enemyCount, _speed, _name, _pos, _dic, _startPos, _endPos, _hp, _isShow, EnemyData.delay[wave_index][other_index-1], EnemyData.died[wave_index][other_index-1]
	else
		return _enemyCount, _speed, _name, _pos, _dic, _startPos, _endPos, _hp, _isShow
	end
end

EnemyData.getId = function(wave_index, other_index)
	local _index1 = EnemyData.wave[wave_index]
	if not _index1 then
		return nil
	end
	local _info = _index1[other_index - 1]
	if not _info then
		return nil
	end
	return EnemyData.info[_info].action
end