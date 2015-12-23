EnemyData = {}

EnemyData.wave = {}
EnemyData.delay = {}
EnemyData.died = {}
EnemyData.info = {}

EnemyData.wave[1] = {1,1,1,1,1,1}

EnemyData.delay[1] = {1,1.1,1.2,1.3,1.4}

EnemyData.died[1] = {0,0,0,0,0}

EnemyData.info[1] = {} 

EnemyData.info[1].enemyCount = 4
EnemyData.info[1].speed = 400
EnemyData.info[1].pos = {ccp(680, 800), ccp(-80, 200)}
EnemyData.info[1].name = "e3.png"


EnemyData.getdata = function(wave_index, other_index)
	local _index1 = EnemyData.wave[wave_index]
	if not _index1 then
		return
	end
	local _info = _index1[other_index]
	local _enemyCount = EnemyData.info[_info].enemyCount
	local _speed = EnemyData.info[_info].speed
	local _name = EnemyData.info[_info].name
	local _pos = EnemyData.info[_info].pos
	if other_index > 1 then
		return _enemyCount, _speed, _name, _pos, EnemyData.delay[_info][other_index-1], EnemyData.died[_info][other_index-1]
	else
		return _enemyCount, _speed, _name, _pos
	end
end