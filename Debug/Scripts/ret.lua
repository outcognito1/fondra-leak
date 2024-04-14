local Namecall; Namecall = hookmetamethod(game, "__namecall", function(Self, ...)
	return Namecall(Self, ...)
end)

local function Stop()
	local Meta = getrawmetatable(game)
	setreadonly(Meta, false)
	Meta.__namecall = Namecall
	setreadonly(Meta, true)
end

task.wait(1)

Stop()