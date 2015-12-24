require "Object"
XArray = {}

--[[
	XArray : Object
	创建新的实例
--]]
XArray.create = function()
	local this = Object.create()
	this.pool = {}
	this.size = 0
	this.dirty = false
	
	this.add = function(this,item)
				this.size = this.size + 1
				this.pool[this.size] = item 
			end


	this.build = function(this, _table)
		for i = 1 , #_table do
			this:add(_table[i])
		end
	end
			
	this.cleanUp = function(this)
					if(not this.dirty)then
						return
					end
					local v2 = {}
					local v1 = this.pool
					local n = 0
					for i = 1 , this.size do
						if(v1[i] ~= nil)then
							n = n + 1
							v2[n] = v1[i]
						end
					end
					this.pool = v2
					this.size = n
					local i , k
					local n = #this.pool
					local v = this.pool
					k = 0
					i = 1
					while( i <=  n) do
						if(v[i] == nil)then
						    i = i + 1
							while( i <= n) do
								if(v[i] ~= nil)then
									k = k + 1
									v[k] = v[i]
									v[i] = nil
									break
								end
								i = i + 1
							end
						else
							k = k + 1
						end
						i = i + 1
					end
					this.size = k
					--]]
					this.dirty = false
				end
				
	this.forEach = function(this ,context , fnCall)
					this:cleanUp()
					local v = this.pool
					for i = 1 , this.size do
						if(fnCall(v[i] , context))then
							v[i] = nil
							this.dirty = true
						end
					end
				end
	
	this.indexOf = function(this , item)
					local v = this.pool
					local n = this.size
					local k = 0
					for i = 1 , n do
						if(v[i] == item)then
							k = i
							break
						end
					end
					return k
				end
				
	this.removeAt = function(this, idx)
					if(idx == nil or idx < 1 or idx > this.size)then
						return
					end
					local v = this.pool
					v[idx] = nil
					this.dirty = true
				end
				
	this.at = function(this , idx)
				local v = this.pool
				return v[idx]
			end
			
	this.push = function(this , item)
				local v = this.pool
				--this:cleanUp()
				this.size = this.size + 1
				v[this.size] = item
			end
	
	this.pop = function(this)
				this.pool[this.size] = nil
				this.size = this.size - 1
			end
			
	this.findIf = function(this ,fnCondition)
			--this:cleanUp()
			local v = this.pool
			for i = 1 , this.size do
				if(fnCondition(v[i]))then
					return v[i] , i
				end
			end
			return nil , 0
		end
		
	this.find = function(this , item)
		local v = this.pool
		for i = 1, this.size do
			if(v[i] == item)then
				return true , i  
			end
		end
		return false , 0
	end
		
	this.clear = function(this)
					this.pool = {}
					this.size = 0
				end
	
	
	
	
	this.delete = function(this , item)	
		local v = this.pool
		for i = 1 , this.size do
			if(v[i] == item)then
				table.remove(v, i)
				this.size = this.size - 1
				return
			end
		end
	end
	
	
	this.insert = function(this , idx , item)
		local v = this.pool
		table.insert(v , idx , item)
		this.size = this.size + 1
	end
	
	return this
end

XQueue = {}
--[[
	XQueue : XArray
	创建一个queue
	@return 一个具有Array的所有行为，但是增加了获取头节点和删除头节点的功能
--]]
XQueue.create = function()
	local this = XArray.create()
	this.front = function(this)
					if(this.size == 0 )then
						return nil
					else
						return this.pool[1]
					end
				end
	
	this.popFront = function(this)
						local v = this.pool
						local tmp = v[1]
						table.remove(v,1)
						this.size = this.size - 1
						return tmp
					end
	return this
end

XCQueue = {}
--[[
	循环队列
	XCQueue : XQueue
--]]
XCQueue.create = function()
	local this = XQueue.create()
	this.topIdx = 1
	--[[
		获取循环队列的下一个节点
		@return 1 元素
		@return 2 元素所在的下标
	--]]
	this.next = function()
		local tmp = this.pool[this.topIdx]
		this.topIdx = this.topIdx + 1
		if(this.topIdx > this.size)then
			this.topIdx = 1
		end
		return tmp , this.topIdx
	end	
	return this
end