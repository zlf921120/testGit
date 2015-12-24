Object = {}

Object.create = function()
	local this = {}
	this.Class = Object
	this.name = "Object"

	function this.instanceOf(Class)
		return this.Class == Class
	end

	return this
end