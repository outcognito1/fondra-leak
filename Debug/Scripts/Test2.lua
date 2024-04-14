

local Meta = getrawmetatable(game)
setreadonly(Meta, false)

local bb; bb                                        = hookmetamethod(game, "__namecall", function(Self, ...)
    local Arguments                                             = {...}
    local Name                                                  = tostring(Self)
    local Method                                                = getnamecallmethod()
    local Calling                                               = getcallingscript()

    if Method == "Raycast" and Calling.Name == "GunHandler" and not checkcaller()  then        
		print("ggagaa")

		return bb(Self, unpack(Arguments))
    end

    return bb(Self, unpack(Arguments))
end)

task.wait(1)

Meta.__namecall = bb

task.wait(3)

setreadonly(Meta, true)