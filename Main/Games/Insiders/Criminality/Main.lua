if not LPH_OBFUSCATED then    
    LPH_JIT = function(...) return ... end -- These macros heavily optimize the passed function to run at exponentially higher speeds (in most cases). These macros should be used on large pieces of code that should run fast and don't require super intensive security
    LPH_JIT_MAX = function(...) return ... end -- These macros heavily optimize the passed function to run at exponentially higher speeds [in most cases]. These macros should be used on large pieces of code that should run fast and don't require super intensive security
    LPH_NO_UPVALUES = function(...) return ... end -- Due to the structure of Luraph, virtualized functions will have a much larger amount of upvalues than normal. In order to fix this, LPH_NO_UPVALUES will wrap the passed function in a proxy function with 0 upvalues to fix bugs in certain programs that do not work with high upvalue counts.
    LPH_NO_VIRTUALIZE = function(...) return ... end -- This macro is used to disable obfuscation for certain sections of your code. These macros should be used on large pieces of code that should run fast and don't require super intensive security [like rendering loops or math calculations]
    LPH_ENCSTR = function(...) return ... end -- This macro is used to disable obfuscation for certain sections of your code. These macros should be used on large pieces of code that should run fast and don't require super intensive security [like rendering loops or math calculations]
    LPH_CRASH = function(...) return ... end -- Securely crashes the VM and corrupts the VM context.
end

local IsA                                                       = game.IsA
local GetChildren                                               = game.GetChildren
local WaitForChild                                              = game.WaitForChild
local FindFirstChild                                            = game.FindFirstChild
local FindFirstChildWhichIsA                                    = game.FindFirstChildWhichIsA
local NextInteger                                               = Fondra.Random.NextInteger
local NextNumber                                                = Fondra.Random.NextNumber
local WorldToScreenPoint                                        = Fondra.Camera.WorldToScreenPoint
local GetPlayers                                                = Fondra.Services.Players.GetPlayers
local Raycast                                                   = Fondra.Services.Workspace.Raycast
local RParams                                                   = RaycastParams.new()
local BParams                                                   = RaycastParams.new()
local TParams                                                   = RaycastParams.new()
local Config                                                    = require(WaitForChild(WaitForChild(WaitForChild(WaitForChild(Fondra.Services.ReplicatedStorage, "NewModules"), "Shared"), "Extensions"), "GetConfig"))

local Toggles                                                   = Toggles
local Options                                                   = Options
local Projectiles                                               = { Forward = 0, Backward = 0, Left = 0, Right = 0, Current = { Object = nil, BodyVelocity = nil, BodyGyro = nil } }
local Fly                                                       = { Forward = 0, Backward = 0, Left = 0, Right = 0, Current = { BodyVelocity = nil, BodyGyro = nil } }

do
    TParams.FilterType                                          = Enum.RaycastFilterType.Exclude
    TParams.IgnoreWater                                         = true
    TParams.RespectCanCollide 								    = true
    TParams.FilterDescendantsInstances                          = { Fondra.Camera }
end

do
    BParams.FilterType                                          = Enum.RaycastFilterType.Exclude
    BParams.IgnoreWater                                         = true
    BParams.RespectCanCollide                                   = true
    BParams.FilterDescendantsInstances                          = { Fondra.Services.Workspace.Characters, Fondra.Camera }
end

do
    RParams.FilterType                                          = Enum.RaycastFilterType.Exclude
    RParams.IgnoreWater                                         = true
    RParams.RespectCanCollide                                   = true
end

for Index, Data in next, getgc(true) do
    if typeof(Data) == "table" and typeof(rawget(Data, "CX1")) == "function" then
        Data.CX1 = function() end
    end

    if typeof(Data) == "table" and rawget(Data, "Detected") and typeof(rawget(Data, "Detected")) == "function" then    
        local Old; Old = hookfunction(Data["Detected"], LPH_NO_UPVALUES(function(Action, Info, NoCrash)
            if rawequal(Action, "_") then return true end
            if rawequal(Info, "_") then return true end

            return task.wait(9e9)
        end))
    end

    if typeof(Data) == "function" and debug.getinfo(Data).name == "S_Get" then
        local Toggles  = Toggles
        local Old; Old = hookfunction(Data, LPH_NO_UPVALUES(function(...)
            if Toggles.Stamina.Value then
                return 100, 100
            end

            return Old(...)
        end))
    end
end

local Namecall; Namecall                                        = hookmetamethod(game, "__namecall", LPH_NO_UPVALUES(LPH_JIT_MAX(function(Self, ...)
    local Arguments                                             = {...}
    local Name                                                  = tostring(Self)
    local Method                                                = getnamecallmethod()
    local Calling                                               = getcallingscript()

    if Method == "FireServer" and not checkcaller() then
        local Disablers                                         = Options.Disablers.GetActiveValues(Options.Disablers)

        if Name == "TK_DGM" and Arguments[2] == "Drown" and table.find(Disablers, "Drowning") then return end
        if Name == "__DFfDD" and Arguments[1] == "G_Gh" and table.find(Disablers, "Grinders") then return end
        if Name == "__DFfDD" and Arguments[1] == "BHHh" and table.find(Disablers, "Barbwires") then return end
        if Name == "__DFfDD" and Arguments[1] == "__--r" or Arguments[1] == "-r__r2" and table.find(Disablers, "Ragdoll") then return end
        if Name == "__DFfDD" and Arguments[1] == "FlllD" or Arguments[1] == "FllH" and table.find(Disablers, "Fall Damage") then return end
    end

    if Method == "InvokeServer" and not checkcaller() then if Name == "Remote" and Arguments[1] == "E" and Toggles.NoFail.Value then return end end

    if Method == "Raycast" and not checkcaller() and Fondra.Functions.ValidCheck(Fondra.Client) and Fondra.Functions.EquippedGun(Fondra.Client) and Toggles.LegitBot.Value and not Arguments[69] then
        if (Calling.Name ~= "Visuals") then return Namecall(Self, unpack(Arguments)) end
        
        local Chance                                            = NextInteger(Fondra.Random, 1, 100)
        local Target, Distance, Limb                            = Fondra.Functions.Return({ Get = "Mouse", Part = "Random", Visible = "Check" }, { Downed = Toggles.LegitBotDowned.Value, Friendly = Toggles.LegitBotFriendly.Value, Visible = true }, { Character = Options.LegitBotDistance.Value, Mouse = Options.LegitBotRadius.Value }, Options.LegitBotParts.GetActiveValues(Options.LegitBotParts))

        if Target and Distance and Limb then Arguments[69] = "Going" end
        if Options.LegitBotHitChance.Value <= Chance then Arguments[69] = "Miss" end

        if Target and Distance and Limb and Arguments[69] == "Going" then Arguments[2] = (Limb.Position - Arguments[1]).Unit * 1000000000 end
    end

    return Namecall(Self, unpack(Arguments))
end)))

local NewIndex; NewIndex										= hookmetamethod(game, "__newindex", LPH_NO_UPVALUES(LPH_JIT_MAX(function(Self, Index, Value)
	local Name 													= tostring(Self)
	local Method 												= tostring(Index)
	local Result 												= tostring(Value)
	local Sky 													= Fondra.Visuals.SkyBoxes[Options.SelectedSkyBox.Value] or Fondra.Visuals.SkyBoxes["Default"]

    if (Name == "0924023902330") then return end

	if (Name == "Lighting") and (Method == "Ambient") and (Self == Fondra.Services.Lighting) and (Toggles.Ambience.Value) then
		return NewIndex(Self, Index, Options.AmbienceColor1.Value or Value)
	end

	if (Name == "Lighting") and (Method == "OutdoorAmbient") and (Self == Fondra.Services.Lighting) and (Toggles.Ambience.Value) then
		return NewIndex(Self, Index, Options.AmbienceColor2.Value or Value)
	end

	if (Name == "Lighting") and (Method == "ColorShift_Bottom") and (Self == Fondra.Services.Lighting) and (Toggles.Shift.Value) then
		return NewIndex(Self, Index, Options.ShiftColor1.Value or Value)
	end

	if (Name == "Lighting") and (Method == "ColorShift_Top") and (Self == Fondra.Services.Lighting) and (Toggles.Shift.Value) then
		return NewIndex(Self, Index, Options.ShiftColor2.Value or Value)
	end

	if (Name == "Lighting") and (Method == "GlobalShadows") and (Self == Fondra.Services.Lighting) then
		return NewIndex(Self, Index, Toggles.ShadowMap.Value)
	end

	if (Name == "Lighting") and (Method == "ClockTime") and (Self == Fondra.Services.Lighting) and (Toggles.ForceTime.Value) then
		return NewIndex(Self, Index, Options.SelectedTime.Value)
	end
	
	if (Name == "Lighting") and (Method == "GeographicLatitude") and (Self == Fondra.Services.Lighting) and (Toggles.ForceLatitude.Value) then
		return NewIndex(Self, Index, Options.SelectedLatitude.Value)
	end

	if (Name == "Lighting") and (Method == "EnvironmentDiffuseScale") and (Self == Fondra.Services.Lighting) and (Toggles.ForceDiffuse.Value) then
		return NewIndex(Self, Index, Options.SelectedDiffuse.Value)
	end

	if (Name == "Atmosphere") and (Method == "Decay") and (Self.Parent == Fondra.Services.Lighting) and (Toggles.SkyBox.Value) then
		return NewIndex(Self, Index, Sky["Data"]["Atmos"]["Decay"] or Value)
	end

	if (Name == "Atmosphere") and (Method == "Color") and (Self.Parent == Fondra.Services.Lighting) and (Toggles.SkyBox.Value) then
		return NewIndex(Self, Index, Sky["Data"]["Atmos"]["Color"] or Value)
	end

	if (Name == "Atmosphere") and (Method == "Glare") and (Self.Parent == Fondra.Services.Lighting) and (Toggles.SkyBox.Value) then
		return NewIndex(Self, Index, Sky["Data"]["Atmos"]["Glare"] or Value)
	end

	if (Name == "Atmosphere") and (Method == "Haze") and (Self.Parent == Fondra.Services.Lighting) and (Toggles.SkyBox.Value) then
		return NewIndex(Self, Index, Sky["Data"]["Atmos"]["Haze"] or Value)
	end

	if (Name == "HumanoidRootPart" or Name == "Torso" or Name == "Head") and (Method == "CanCollide") and (Self.Parent == Fondra.Client.Character) and (Toggles.Noclip.Value) then
		return NewIndex(Self, Index, false)
	end

    if (Name == "Humanoid") and (Method == "WalkSpeed") and (Self.Parent == Fondra.Client.Character) and (Toggles.WalkSpeed.Value) then
		return NewIndex(Self, Index, Options.WalkSpeed.Value or Value)
	end

    if (Name == "Humanoid") and (Method == "JumpPower") and (Self.Parent == Fondra.Client.Character) and (Toggles.JumpPower.Value) then
		return NewIndex(Self, Index, Options.JumpPower.Value or Value)
	end

    if (Name == "ROTROOT") and (Method == "Parent") and (Result == "Currents") and (Toggles.SprayAura.Value) then
		return NewIndex(Self, Index, nil)
	end

	return NewIndex(Self, Index, Value)
end)))

local Index; Index                                             	= hookmetamethod(game, "__index", LPH_NO_UPVALUES(LPH_JIT_MAX(function(Self, Value)
	local Name 													= tostring(Self)
	local Method 												= tostring(Value)
	local Calling 												= getcallingscript()
    
	if (Name == "FP_Offset") and (Method == "Value") and (not checkcaller()) and (Toggles.Viewmodel.Value) then
        return Vector3.new(Options.ViewmodelXOffset.Value / 7, Options.ViewmodelYOffset.Value / 7, Options.ViewmodelZOffset.Value / 7)
    end

    if (Name == "Ammo") and (Method == "Value") and (string.find(Self.Parent.Name, "Pepper")) and (not checkcaller()) and (Toggles.InfinitePepperSpray.Value) then
        return 100
    end
  
    return Index(Self, Value)
end)))

hookfunction(Config, function(Tool)
    local GunData                                               = {}
    local Config                                                = require(WaitForChild(Tool, "Config"))

    for Index, Value in next, Config do
        if (Index == "Recoil") or (string.find(Index, "_Max")) or (string.find(Index, "_Min")) then
            GunData[Index]                                      = Value * (Options.RecoilPercentage.Value / 100)

            continue
        end

        if (Index == "Spread") then
            GunData[Index]                                      = Value * (Options.SpreadPercentage.Value / 100)

            continue
        end

        GunData[Index]                                          = Value
    end

    return GunData
end)

for Index, Object in next, Fondra.Services.Workspace.Filter.Parts.F_Parts:FindFirstChild("RG_Part", true).Parent:GetChildren() do
    Object:Destroy()
end

Fondra.Services.Workspace.Debris.VParts.ChildAdded:Connect(function(Object)
	task.wait()

	if (Object.Name == "RPG_Rocket" and Toggles.RLController.Value) then
		Fondra.Camera.CameraSubject 						    = Object
		Fondra.Client.Character.HumanoidRootPart.Anchored 	    = true

		pcall(function()
			Object.BodyForce:Destroy()
			Object.RotPart.BodyAngularVelocity:Destroy()
			Object.Sound:Destroy()
		end)
		
		local BV 											    = Instance.new("BodyVelocity", Object)
    	BV.MaxForce 										    = Vector3.new(1e9, 1e9, 1e9)
    	BV.Velocity 										    = Vector3.new()
    	
    	local BG 											    = Instance.new("BodyGyro", Object)
        BG.D 												    = 750
    	BG.P 												    = 50000
    	BG.MaxTorque 										    = Vector3.new(1e4, 1e4, 1e4)

		Projectiles.Current.BodyVelocity					    = BV
		Projectiles.Current.BodyGyro						    = BG
		Projectiles.Current.Object							    = Object
	end

	if (Object.Name == "GrenadeLauncherGrenade" and Toggles.GLController.Value) then
		Fondra.Camera.CameraSubject 						    = Object
		Fondra.Client.Character.HumanoidRootPart.Anchored 	    = true

		pcall(function()
			Object.BodyForce:Destroy()
			Object.RotPart.BodyAngularVelocity:Destroy()
			Object.Sound:Destroy()
		end)
		
		local BV 											    = Instance.new("BodyVelocity", Object)
    	BV.MaxForce 										    = Vector3.new(1e9, 1e9, 1e9)
    	BV.Velocity 										    = Vector3.new()
    	
    	local BG 											    = Instance.new("BodyGyro", Object)
        BG.D 												    = 750
    	BG.P 												    = 50000
    	BG.MaxTorque 										    = Vector3.new(1e4, 1e4, 1e4)

		Projectiles.Current.BodyVelocity					    = BV
		Projectiles.Current.BodyGyro						    = BG
		Projectiles.Current.Object							    = Object
	end

	if (Object.Name == "TransIgnore" and Toggles.C4Controller.Value) then
		Fondra.Camera.CameraSubject 						    = Object
		Fondra.Client.Character.HumanoidRootPart.Anchored 	    = true

		pcall(function()
			Object.BodyForce:Destroy()
			Object.RotPart.BodyAngularVelocity:Destroy()
			Object.Sound:Destroy()
		end)
		
		local BV 											    = Instance.new("BodyVelocity", Object)
    	BV.MaxForce 										    = Vector3.new(1e9, 1e9, 1e9)
    	BV.Velocity 										    = Vector3.new()

    	local BG 											    = Instance.new("BodyGyro", Object)
        BG.D 												    = 750
    	BG.P 												    = 50000
    	BG.MaxTorque 										    = Vector3.new(1e4, 1e4, 1e4)

		Projectiles.Current.BodyVelocity					    = BV
		Projectiles.Current.BodyGyro						    = BG
		Projectiles.Current.Object							    = Object
	end
end)

Fondra.Services.Workspace.Debris.ChildAdded:Connect(function(Object)
    task.wait()

	if (not FindFirstChild(Object, "Creator")) then return end
	if (Object.Creator.Value ~= Fondra.Client) then return end

	Projectiles.Current.BodyVelocity						    = nil
	Projectiles.Current.BodyGyro							    = nil
	Projectiles.Current.Object								    = nil

	Fondra.Camera.CameraSubject 							    = Fondra.Client.Character.Humanoid
	Fondra.Client.Character.HumanoidRootPart.Anchored 		    = false
end)

Fondra.Services.UserInputService.InputBegan:Connect(function(Key)
	if Key.KeyCode == Enum.KeyCode.W then
		Projectiles.Forward 	                                = 1
		Fly.Forward 	                                        = 1
	end

	if Key.KeyCode == Enum.KeyCode.S then
		Projectiles.Backward 	                                = -1
        Fly.Backward 	                                        = -1
	end

	if Key.KeyCode == Enum.KeyCode.D then
		Projectiles.Right 		                                = 1
        Fly.Right 	                                            = 1
	end

	if Key.KeyCode == Enum.KeyCode.A then
		Projectiles.Left 		                                = -1
        Fly.Left 	                                            = -1
	end
end)

Fondra.Services.UserInputService.InputEnded:Connect(function(Key)
	if Key.KeyCode == Enum.KeyCode.W then
		Projectiles.Forward 	                                = 0
		Fly.Forward 	                                        = 0
	end

	if Key.KeyCode == Enum.KeyCode.S then
		Projectiles.Backward 	                                = 0
        Fly.Backward 	                                        = 0
	end

	if Key.KeyCode == Enum.KeyCode.D then
		Projectiles.Right 		                                = 0
        Fly.Right 	                                            = 0
	end

	if Key.KeyCode == Enum.KeyCode.A then
		Projectiles.Left 		                                = 0
        Fly.Left 	                                            = 0
	end
end)

--

Fondra.Functions.Decrypt                                        = LPH_NO_VIRTUALIZE(function(Number, String)
    Number                                                      = Number + 2
    local Data                                                  = {}
    local A, B, C                                               = pairs(string.split(String, "."))

    for D, E in A, B, C do
        if E == "" then continue end
        
        table.insert(Data, D, bit32.bxor(E, Number))
    end

    return string.char(table.unpack(Data))
end)

Fondra.Functions.RandomString                                   = LPH_NO_VIRTUALIZE(function(Length)
    local Result    = ""

    for i = 1, Length do
        Result = Result .. string.char(NextInteger(Fondra.Random, 97, 122))
    end

    return Result
end)

Fondra.Functions.ValidCheck                                     = LPH_NO_VIRTUALIZE(function(Player)
    if not Player.Character then return false end
    if not FindFirstChild(Player.Character, "Humanoid") then return false end
    if not FindFirstChild(Player.Character, "HumanoidRootPart") then return false end
    if FindFirstChild(Player.Character, "Humanoid").Health <= 0 then return false end

    return true
end)

Fondra.Functions.ForceFieldCheck                                = LPH_NO_VIRTUALIZE(function(Player)
    return FindFirstChildWhichIsA(Player.Character, "ForceField") ~= nil
end)

Fondra.Functions.FriendlyCheck                                  = LPH_NO_VIRTUALIZE(function(Player)
    return Player.IsFriendsWith(Player, Fondra.Client.UserId)
end)

Fondra.Functions.DownedCheck                                    = LPH_NO_VIRTUALIZE(function(Player)
    if not FindFirstChild(Fondra.Services.ReplicatedStorage.CharStats, Player.Name) then return true end

    return Fondra.Services.ReplicatedStorage.CharStats[Player.Name].Downed.Value
end)

Fondra.Functions.EquippedMelee                                  = LPH_NO_VIRTUALIZE(function(Player)
    if not FindFirstChildWhichIsA(Player.Character, "Tool") then return false end
    if not FindFirstChild(FindFirstChildWhichIsA(Player.Character, "Tool"), "Client") then return false end        
    if not FindFirstChild(FindFirstChildWhichIsA(Player.Character, "Tool"), "Melee") then return false end

    return true
end)

Fondra.Functions.EquippedGun                                    = LPH_NO_VIRTUALIZE(function(Player)
    if not FindFirstChildWhichIsA(Player.Character, "Tool") then return false end
    if not FindFirstChild(FindFirstChildWhichIsA(Player.Character, "Tool"), "Client") then return false end
    if not FindFirstChild(FindFirstChildWhichIsA(Player.Character, "Tool"), "Gun") then return false end

    return true
end)

Fondra.Functions.ReturnInteractiveProp                          = LPH_NO_VIRTUALIZE(function(Folder, Max)
    local Prop                                                  = nil
    local Distance                                              = Max or math.huge

    local Client                                                = Fondra.Client
    local Character                                             = Client.Character

    if not Client then return end
    if not Character then return end

    if not FindFirstChild(Character, "HumanoidRootPart") then return end
    if not FindFirstChild(Character, "Humanoid") then return end

    for Index, Object in next, Fondra.Services.Workspace.Map[Folder]:GetChildren() do
        if not FindFirstChild(Object, "MainPart") then continue end

        if (Object.MainPart.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

        Prop                                                    = Object
        Distance                                                = (Object.MainPart.Position - Character.HumanoidRootPart.Position).Magnitude
    end

    return Prop
end)

Fondra.Functions.ReturnCash                                     = LPH_NO_VIRTUALIZE(function(Max)
    local Cash                                                  = nil
    local Distance                                              = Max or math.huge

    local Client                                                = Fondra.Client
    local Character                                             = Client.Character

    if not Client then return end
    if not Character then return end

    if not FindFirstChild(Character, "HumanoidRootPart") then return end
    if not FindFirstChild(Character, "Humanoid") then return end

    for Index, Object in next, Fondra.Services.Workspace.Filter.SpawnedBread:GetChildren() do
        if (Object.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

        Cash                                                    = Object
        Distance                                                = (Object.Position - Character.HumanoidRootPart.Position).Magnitude
    end

    return Cash
end)

Fondra.Functions.ReturnScrap                                    = LPH_NO_VIRTUALIZE(function(Max)
    local Scrap                                                 = nil
    local Distance                                              = Max or math.huge

    local Client                                                = Fondra.Client
    local Character                                             = Client.Character

    if not Client then return end
    if not Character then return end

    if not FindFirstChild(Character, "HumanoidRootPart") then return end
    if not FindFirstChild(Character, "Humanoid") then return end

    for Index, Object in next, Fondra.Services.Workspace.Filter.SpawnedPiles:GetChildren() do
        if not string.find(Object.Name, "S") then continue end
        if not Object.PrimaryPart then continue end
        if (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

        Scrap                                                   = Object
        Distance                                                = (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude
    end

    return Scrap
end)

Fondra.Functions.ReturnCrate                                    = LPH_NO_VIRTUALIZE(function(Max)    
    local Crate                                                 = nil
    local Distance                                              = Max or math.huge

    local Client                                                = Fondra.Client
    local Character                                             = Client.Character

    if not Client then return end
    if not Character then return end

    if not FindFirstChild(Character, "HumanoidRootPart") then return end
    if not FindFirstChild(Character, "Humanoid") then return end

    for Index, Object in next, Fondra.Services.Workspace.Filter.SpawnedPiles:GetChildren() do
        if not string.find(Object.Name, "C") then continue end
        if not Object.PrimaryPart then continue end
        if (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

        Crate                                                   = Object
        Distance                                                = (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude
    end

    return Crate
end)

Fondra.Functions.ReturnTool                                     = LPH_NO_VIRTUALIZE(function(Max)
    local Tool                                                  = nil
    local Distance                                              = Max or math.huge

    local Client                                                = Fondra.Client
    local Character                                             = Client.Character

    if not Client then return end
    if not Character then return end

    if not FindFirstChild(Character, "HumanoidRootPart") then return end
    if not FindFirstChild(Character, "Humanoid") then return end

    for Index, Object in next, Fondra.Services.Workspace.Filter.SpawnedTools:GetChildren() do
        if not Object.PrimaryPart then continue end
        if (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

        Tool                                                    = Object
        Distance                                                = (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude
    end

    return Tool
end)

Fondra.Functions.ReturnBreadMaker                               = LPH_NO_VIRTUALIZE(function(Type, Max)
    local BreakMaker                                            = nil
    local Distance                                              = Max or math.huge

    local Client                                                = Fondra.Client
    local Character                                             = Client.Character

    if not Client then return end
    if not Character then return end

    if not FindFirstChild(Character, "HumanoidRootPart") then return end
    if not FindFirstChild(Character, "Humanoid") then return end

    for Index, Object in next, Fondra.Services.Workspace.Map.BredMakurz:GetChildren() do
        if not FindFirstChild(Object, "MainPart") then continue end
        if not FindFirstChild(Object, "Values") then continue end

        if not string.find(Object.Name, Type) then continue end
        if Object.Values.Broken.Value then continue end

        if (Object.MainPart.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end
        
        BreakMaker                                              = Object
        Distance                                                = (Object.MainPart.Position - Character.HumanoidRootPart.Position).Magnitude
    end

    return BreakMaker
end)

Fondra.Functions.ReturnDoor                                     = LPH_NO_VIRTUALIZE(function(Max)
    local Door                                                  = nil
    local Distance                                              = Max or math.huge

    local Client                                                = Fondra.Client
    local Character                                             = Client.Character

    if not Client then return end
    if not Character then return end

    if not FindFirstChild(Character, "HumanoidRootPart") then return end
    if not FindFirstChild(Character, "Humanoid") then return end

    for Index, Object in next, Fondra.Services.Workspace.Map.Doors:GetChildren() do
        if not FindFirstChild(Object, "DFrame") then continue end
        if not FindFirstChild(Object, "Values") then continue end
        if not FindFirstChild(Object.Values, "Locked") then continue end
        if not FindFirstChild(Object.Values, "Broken") then continue end

        if Object.Values.Broken.Value then continue end
        if not Object.Values.Locked.Value then continue end

        if (Object.DFrame.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end
        
        Door                                                    = Object
        Distance                                                = (Object.DFrame.Position - Character.HumanoidRootPart.Position).Magnitude
    end

    return Door
end)

Fondra.Functions.LocalCharacter                                 = LPH_JIT_MAX(function(Character)
    local HumanoidRootPart                                      = WaitForChild(Character, "HumanoidRootPart")
    local Humanoid                                              = WaitForChild(Character, "Humanoid")
    local Torso                                                 = WaitForChild(Character, "Torso")
    local Head                                                  = WaitForChild(Character, "Head")
    local Part                                                  = WaitForChild(Torso, "Part")

    task.wait(0.5)

    for _, Connection in pairs(getconnections(HumanoidRootPart.ChildAdded)) do
        Connection:Disable()
    end

    for _, Connection in pairs(getconnections(HumanoidRootPart.DescendantAdded)) do
        Connection:Disable()
    end

    for _, Object in next, GetChildren(Torso) do
        if not IsA(Object, "Motor6D") then continue end

        Object:GetPropertyChangedSignal("Enabled"):Connect(function(Value)
            if not Toggles.Fly.Value and not Toggles.WalkSpeed.Value and not Toggles.JumpPower.Value then return end
            if Value then return end

            Object.Enabled                                      = true
        end)
    end

    Head.ChildAdded:Connect(function(Object)
        task.wait()

        if not Toggles.Fly.Value and not Toggles.WalkSpeed.Value and not Toggles.JumpPower.Value then return end
        if not string.find(Object.Name, "Scream") then return end

        Object:Destroy()
    end)

    Part.CanCollide                                             = false
    Fondra.Functions.SpinBot(Fondra.Client, Character)
end)

Fondra.Functions.Shoot                                          = LPH_JIT_MAX(function(Target)
    if not isrbxactive() then return end
    if not Toggles.TriggerBot.Value then return end
    if not Fondra.Functions.EquippedGun(Fondra.Client) then return end
    if Options.TriggerBotShootChance.Value <= NextInteger(Fondra.Random, 1, 100) then return end

	local Target												= Fondra.Services.Players:GetPlayerFromCharacter(Target)
	local Tool 													= FindFirstChildWhichIsA(Fondra.Client.Character, "Tool")

	if Fondra.Functions.ForceFieldCheck(Target) then return end
	if Fondra.Functions.FriendlyCheck(Target) and Toggles.TriggerBotFriendly.Value then return end
	if Fondra.Functions.DownedCheck(Target) and Toggles.TriggerBotDowned.Value then return end

	Tool:Activate()

	task.wait()

	if not FindFirstChildWhichIsA(Fondra.Client.Character, "Tool") then return end

	Tool:Deactivate()
end)

Fondra.Functions.GunAnimation                                   = LPH_JIT_MAX(function(Tool, Name)
    local A, B, C                                               = pairs(GetChildren(getrenv()._G.GSFFLDR))
    local Bxor                                                  = Fondra.Services.ReplicatedStorage.Values.BxorValue
    local Animations                                            = nil 
    
    for Index, Folder in A, B, C do
        local DecryptedName                                     = Fondra.Functions.Decrypt(Bxor.Value, Folder.Name)
    
        if DecryptedName == Tool.Name then
            Animations                                          = Folder

            break
        end
    end

    if not Animations then return end
    
    local A, B, C                                               = pairs(GetChildren(Animations))
    local Loaded                                                = nil

    for Index, Animation in A, B, C do
        local DecryptedName                                     = Fondra.Functions.Decrypt(Animation:GetAttribute("K"), Animation.Name)
        
        if DecryptedName == Name then
            Loaded                                              = Fondra.Client.Character.Humanoid:LoadAnimation(Animation)
            Loaded:Play()

            break
        end
    end
end)

Fondra.Functions.GunSound                                       = LPH_JIT_MAX(function(Tool, Directory, Name)
    if not FindFirstChild(Tool, "WeaponHandle") then return end
    if not FindFirstChild(Tool.WeaponHandle, Directory) then return end
    if not FindFirstChild(Tool.WeaponHandle[Directory], Name) then return end

    local Clone                                                 = Tool.WeaponHandle[Directory][Name]:Clone()
    Clone.Name                                                  = string.format("%s_Clone", Name)
    Clone.Parent                                                = Fondra.Client.Character.HumanoidRootPart
    Clone.PlaybackSpeed                                         = NextNumber(Fondra.Random, 0.8, 1.2)
    Clone:Play()

    Fondra.Services.Debris:AddItem(Clone, Clone.TimeLength)
end)

Fondra.Functions.VisibleCheck                                   = LPH_JIT_MAX(function(Player, Limb, Method)
    if (Method == "Wallbang") and (Player.Character.HumanoidRootPart.Position - Fondra.Client.Character.HumanoidRootPart.Position).Magnitude < 35 then return true end
    if (Method == "None") then return true end

    if not Fondra.Functions.EquippedGun(Fondra.Client) then return false end

    local Tool                                                  = FindFirstChildWhichIsA(Fondra.Client.Character, "Tool")

    if not Tool then return false end
    if not FindFirstChild(Tool, "WeaponHandle") then return false end
    if not FindFirstChild(Tool.WeaponHandle, "FirePos") then return false end

    do
        RParams.FilterDescendantsInstances                      = {
            Fondra.Client.Character,
            Player.Character,
            Fondra.Camera,
    
            Fondra.Services.Workspace.Debris,
            Fondra.Services.Workspace.Filter,
            Fondra.Services.Workspace.Characters,
            Fondra.Services.Workspace.Map.Parts.Grinders,
            
            Fondra.Services.Workspace.Map.VendingMachines,
            Fondra.Services.Workspace.Map.StreetLights,
            Fondra.Services.Workspace.Map.BredMakurz,
            Fondra.Services.Workspace.Map.Security,
            Fondra.Services.Workspace.Map.Doors,
            Fondra.Services.Workspace.Map.Shopz,
            Fondra.Services.Workspace.Map.ATMz
        }
    end

    local Handle                                                = FindFirstChild(Tool, "WeaponHandle")
    local Fire                                                  = FindFirstChild(Tool.WeaponHandle, "FirePos").WorldPosition
    local Result                                                = Raycast(Fondra.Services.Workspace, Fire, Limb.Position - Fire, RParams)

    if Result and Result.Instance then
        return false
    else
        return true
    end
end)

Fondra.Functions.Return                                         = LPH_JIT_MAX(function(Methods, Checks, Lengths, Limbs)
    local Methods                                               = Methods or { Get = "Character", Part = "Random", Visible = "Default" }
    local Checks                                                = Checks or { Downed = true, Friendly = true }
	local Limbs 												= Limbs or {}

    local Target, Distance, Limb								= nil, nil, nil

    if (Methods.Get == "Mouse") then
        for Index, Player in next, GetPlayers(Fondra.Services.Players) do
			if Player == Fondra.Client then continue end

            if not Fondra.Functions.ValidCheck(Player) then continue end
            if Fondra.Functions.ForceFieldCheck(Player) then continue end
            if Checks.Downed and Fondra.Functions.DownedCheck(Player) then continue end
            if Checks.Friendly and Fondra.Functions.FriendlyCheck(Player) then continue end

            local Total                                         = {}
            local Selected                                      = nil

            local Vector, OnScreen                              = WorldToScreenPoint(Fondra.Camera, Player.Character.HumanoidRootPart.Position)
            local MouseBetween                                  = (Vector2.new(Fondra.Mouse.X, Fondra.Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).Magnitude
            local CharacterBetween                              = (Player.Character.HumanoidRootPart.Position - Fondra.Client.Character.HumanoidRootPart.Position).Magnitude

            for Index, Object in next, Limbs do
                if not FindFirstChild(Player.Character, Object) then continue end
        
                table.insert(Total, FindFirstChild(Player.Character, Object))
            end

            if not Selected then Selected = Player.Character["Torso"] end
            if not Distance then Distance = Lengths.Mouse end

            if (MouseBetween <= Distance) and (CharacterBetween <= Lengths.Character) and (OnScreen) then
                Selected                                        = Total[NextInteger(Fondra.Random, 1, #Total)]

                if Checks.Visible and not Fondra.Functions.VisibleCheck(Player, Selected, Methods.Visible) then continue end

                Target                                          = Player
                Distance                                        = CharacterBetween
                Limb                                            = Selected
            end
        end
    end

    if (Methods.Get == "Character") then
        for Index, Player in next, GetPlayers(Fondra.Services.Players) do
			if Player == Fondra.Client then continue end                          

            if not Fondra.Functions.ValidCheck(Player) then continue end
            if Fondra.Functions.ForceFieldCheck(Player) then continue end
            if Checks.Downed and Fondra.Functions.DownedCheck(Player) then continue end
            if Checks.Friendly and Fondra.Functions.FriendlyCheck(Player) then continue end

            local Total                                         = { Player.Character["Torso"] }
            local Selected                                      = nil
            local CharacterBetween                              = (Player.Character.HumanoidRootPart.Position - Fondra.Client.Character.HumanoidRootPart.Position).Magnitude

            for Index, Object in next, Limbs do
                if not FindFirstChild(Player.Character, Object) then continue end
        
                table.insert(Total, Player.Character[Object])
            end

            if not Selected then Selected = Total[NextInteger(Fondra.Random, 1, #Total)] end
            if not Distance then Distance = Lengths.Character end

            if (CharacterBetween <= Distance) then
                if Checks.Visible and not Fondra.Functions.VisibleCheck(Player, Selected, Methods.Visible) then continue end

                Target                                          = Player
                Distance                                        = CharacterBetween
                Limb                                            = Selected
            end
        end
    end

    if not Target then return end
    if not Distance then return end
    if not Limb then return end

    return Target, Distance, Limb
end)

-- // Main Functions

Fondra.Functions.Visualize                                      = LPH_JIT_MAX(function(Client, Character)
    if not Client then return end
    if not Character then return end

    if (not Toggles.LegitBot.Value) or (not Fondra.Functions.EquippedGun(Client)) then Fondra.Data.FOV.Visible = false return end
    
    Fondra.Data.FOV.Visible                                     = Toggles.LegitBotFOV.Value
    Fondra.Data.FOV.Color                                       = Options.AccentColor.Value
    Fondra.Data.FOV.Position                                    = Fondra.Services.UserInputService:GetMouseLocation()
    Fondra.Data.FOV.Radius                                      = Options.LegitBotRadius.Value
end)

Fondra.Functions.ProjectileController                           = LPH_JIT_MAX(function(Client, Character)
    if not Client then return end
    if not Character then return end

    if not Projectiles.Current.BodyVelocity then return end
	if not Projectiles.Current.BodyGyro then return end
	if not Projectiles.Current.Object then return end

	Projectiles.Current.BodyGyro.CFrame 					    = Fondra.Camera.CFrame
    Projectiles.Current.BodyVelocity.Velocity				    = ((Fondra.Camera.CFrame.LookVector * Projectiles.Forward) + (Fondra.Camera.CFrame.LookVector * Projectiles.Backward) + (Fondra.Camera.CFrame.RightVector * Projectiles.Right) + (Fondra.Camera.CFrame.RightVector * Projectiles.Left)) * Options.ProjectileSpeed.Value
	Fondra.Camera.CFrame 									    = Projectiles.Current.Object.CFrame * CFrame.new(Vector3.new(0, 2, 3))
end)

Fondra.Functions.FlyController                                  = LPH_JIT_MAX(function(Client, Character)
    if not Client then return end
    if not Character then return end

    if not FindFirstChild(Character, "HumanoidRootPart") then return end
    if not FindFirstChild(Character, "Humanoid") then return end

    if not Toggles.Fly.Value then return end
    if not Fondra.Cooldowns.Fly then Fondra.Cooldowns.Fly = tick() end

    if not Fly.Current then return end
    if not Fly.Current.BodyGyro then return end
    if not Fly.Current.BodyVelocity then return end
    
    Character.Humanoid.AutoRotate                               = false
	Fly.Current.BodyGyro.CFrame 					            = Fondra.Camera.CFrame
    Fly.Current.BodyVelocity.Velocity				            = ((Fondra.Camera.CFrame.LookVector * Fly.Forward) + (Fondra.Camera.CFrame.LookVector * Fly.Backward) + (Fondra.Camera.CFrame.RightVector * Fly.Right) + (Fondra.Camera.CFrame.RightVector * Fly.Left)) * Options.FlySpeed.Value
    
    if ((tick() - Fondra.Cooldowns.Fly) > 1) and (Options.FlyMethod.Value == "Bypass") then
        Fondra.Cooldowns.Fly                                    = tick()
        Fondra.Services.ReplicatedStorage.Events.__DFfDD:FireServer(
            "-r__r2", 
            Vector3.new(0, 0, 0), 
            Character.HumanoidRootPart.CFrame
        )
    end
end)

Fondra.Functions.Stats                                          = LPH_JIT_MAX(function(Client, Character)
    if not Client then return end
    if not Character then return end
    if not Toggles.WalkSpeed.Value and not Toggles.JumpPower.Value then return end

    local Stats                                                 = FindFirstChild(Fondra.Services.ReplicatedStorage.CharStats, Client.Name)
    local Humanoid                                              = FindFirstChild(Character, "Humanoid")
    local HumanoidRootPart                                      = FindFirstChild(Character, "HumanoidRootPart")
    
    if not Fondra.Cooldowns.Stats then Fondra.Cooldowns.Stats = tick() end
    if not Stats then return end
    if not Humanoid then return end
    if not HumanoidRootPart then return end

    Stats.RagdollTime.Value                                     = 0
    Stats.RagdollTime.RagdollSwitch2.Value                      = false
    Stats.RagdollTime.RagdollSwitch.Value                       = false
    Stats.RagdollTime.SRagdolled.Value                          = false

    if ((tick() - Fondra.Cooldowns.Stats) > 1) and (Options.StatsMethod.Value == "Bypass") then
        Fondra.Cooldowns.Stats                                  = tick()
        Fondra.Services.ReplicatedStorage.Events.__DFfDD:FireServer(
            "-r__r2", 
            Vector3.new(0, 0, 0), 
            Character.HumanoidRootPart.CFrame
        )
    end
end)

Fondra.Functions.BHop                                           = LPH_JIT_MAX(function(Client, Character)
    if not Client then return end
    if not Character then return end
    if not Toggles.BHop.Value then return end
    if not FindFirstChild(Character, "HumanoidRootPart") then return end

    local Result                                                = Raycast(Fondra.Services.Workspace, Character.HumanoidRootPart.Position, Vector3.new(0, -3.25, 0), BParams)

    if not Result then return end
    if not Result.Instance then return end

    Character.HumanoidRootPart.Velocity                         = Vector3.new(Character.HumanoidRootPart.Velocity.X, 32.5, Character.HumanoidRootPart.Velocity.Z)
end)

Fondra.Functions.Fly                                            = LPH_JIT_MAX(function(Client, Character)
    if not Client then return end
    if not Character then return end
    
    if not FindFirstChild(Character, "Humanoid") then return end
    if not FindFirstChild(Character, "HumanoidRootPart") then return end

    if Toggles.Fly.Value then
        if Fly.Current.BodyGyro then return end
        if Fly.Current.BodyVelocity then return end

        Fly.Current.BodyVelocity                                = Instance.new("BodyVelocity", Character.HumanoidRootPart)
        Fly.Current.BodyGyro                                    = Instance.new("BodyGyro", Character.HumanoidRootPart)

        Fly.Current.BodyGyro.MaxTorque                          = Vector3.new(math.huge, math.huge, math.huge)
        Fly.Current.BodyGyro.D                                  = 500
        Fly.Current.BodyGyro.P                                  = 90000

        Fly.Current.BodyVelocity.P                              = 1250
        Fly.Current.BodyVelocity.MaxForce                       = Vector3.new(math.huge, math.huge, math.huge)
        Fly.Current.BodyVelocity.Velocity                       = Vector3.new(0, 0, 0)

        Fly.Current.BodyGyro.Name                               = Fondra.Functions.RandomString(30)
        Fly.Current.BodyVelocity.Name                           = Fondra.Functions.RandomString(30)
    end
    
    if not Toggles.Fly.Value then
        if not Fly.Current.BodyGyro then return end
        if not Fly.Current.BodyVelocity then return end

        Fly.Current.BodyGyro:Destroy()
        Fly.Current.BodyVelocity:Destroy()

        Fly.Current.BodyGyro                                    = nil
        Fly.Current.BodyVelocity                                = nil

        Character.Humanoid.AutoRotate                           = true
    end
end)

Fondra.Functions.SpinBot                                        = LPH_JIT_MAX(function(Client, Character)
    if not Client then return end
    if not Character then return end
    if not FindFirstChild(Character, "HumanoidRootPart") then return end

    if Toggles.SBot.Value then
        if FindFirstChild(Character.HumanoidRootPart, "SpinBot") then 
            Character.HumanoidRootPart.SpinBot.AngularVelocity  = Vector3.new(0, Options.SpinSpeed.Value ,0)

            return 
        end

        local Angular                                           = Instance.new("BodyAngularVelocity")
        Angular.Name                                            = "SpinBot"
        Angular.Parent                                          = Character.HumanoidRootPart
        Angular.MaxTorque                                       = Vector3.new(0, math.huge, 0)
        Angular.AngularVelocity                                 = Vector3.new(0, Options.SpinSpeed.Value ,0)
    end
    
    if not Toggles.SBot.Value then
        if not FindFirstChild(Character.HumanoidRootPart, "SpinBot") then return end

        Character.HumanoidRootPart.SpinBot:Destroy()
    end
end)

Fondra.Functions.FakeLag                                        = LPH_JIT_MAX(function(Client, Character)
    if not Client then return end
    if not Character then return end
    if not Toggles.FLag.Value then return end
    if not Fondra.Cooldowns.FakeLag then Fondra.Cooldowns.FakeLag = tick() end

    if (tick() - Fondra.Cooldowns.FakeLag) > Options.LagAmount.Value then
        Character.Archivable                                    = true
        Fondra.Cooldowns.FakeLag                                = tick()

        if Toggles.FLagVisual.Value then
            local Folder                                        = FindFirstChild(Character, "Visual") or Instance.new("Folder")
            Folder.Parent                                       = Character
            Folder.Name                                         = "Visual"
            
            local Clone                                         = Character:Clone()
            Clone.Parent                                        = Folder
    
            for Index, Object in next, Clone:GetDescendants() do
                if IsA(Object, "Folder") or IsA(Object, "Script") or IsA(Object, "LocalScript") or IsA(Object, "ForceField") or IsA(Object, "Accessory") or IsA(Object, "Humanoid") or IsA(Object, "Decal") then 
                    Object:Destroy()
                end
    
                if IsA(Object, "BasePart") or IsA(Object, "MeshPart") then 
                    Object.Material                             = Enum.Material.ForceField
                    Object.Anchored                             = true
                    Object.CanCollide                           = false
                    Object.Transparency                         = 1
                end
    
                if string.find(Object.Name, "Collider") then
                    Object.Transparency                         = 0
                    Object.Color                                = Options.AccentColor.Value
                end
            end
    
            task.delay(Options.LagAmount.Value, function() Clone:Destroy() end) 
        end

        Fondra.Services.NetworkClient:SetOutgoingKBPSLimit(9e9)

        return
    end

    Fondra.Services.NetworkClient:SetOutgoingKBPSLimit(1)
end)

Fondra.Functions.TriggerBot                                     = LPH_JIT_MAX(function(Client, Character)
    if not Client then return end
    if not Character then return end
    if not Toggles.TriggerBot.Value then return end

	local Delay 												= (Options.TriggerBotDelay.Value / 1000)
	local Randomized 											= (NextNumber(Fondra.Random, 0, Options.TriggerBotDelayBS.Value) / 1000)

	local Point 												= Fondra.Camera:ScreenPointToRay(Fondra.Mouse.X, Fondra.Mouse.Y)
    local Result 												= Raycast(Fondra.Services.Workspace, Point.Origin, Point.Direction * 500, TParams)
	
	if not Result then return end
	if not Result.Instance then return end
	if not Result.Instance.Parent then return end
	if not Result.Instance.Parent.Parent then return end

	local Target 												= Result.Instance
	local Player 												= Fondra.Services.Players:GetPlayerFromCharacter(Target.Parent)

    if Target.Name == "Handle" then
		TParams:AddToFilter(Target)

        return
    end

    if Target.Parent.Parent ~= Fondra.Services.Workspace.Characters then return end
    if not table.find(Options.TriggerBotParts:GetActiveValues(), Target.Name) then return end
	if not Fondra.Functions.VisibleCheck(Player, Target, "Default") then return end
	if (Player.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude >= Options.TriggerBotDistance.Value then return end

    task.delay(Delay + Randomized, function()
		Fondra.Functions.Shoot(Target.Parent)
	end)
end)

Fondra.Functions.AutoPickScraps                                 = LPH_JIT_MAX(function(Client, Character)
    if not Toggles.AutoPickScraps.Value then return end
    if Fondra.Cooldowns.PickUp then return end

    if not Client then return end
    if not Character then return end

    local Scrap                                                 = Fondra.Functions.ReturnScrap(Options.AutoPickRange.Value)

    if not Scrap then return end

    Fondra.Cooldowns.PickUp                                     = true

    task.wait(0.25 + Options.AutoPickDelay.Value)

    if not Scrap then Fondra.Cooldowns.PickUp = false return end

    Fondra.Services.ReplicatedStorage.Events.PIC_PU:FireServer(string.reverse(Scrap:GetAttribute("jzu")))
    Fondra.Cooldowns.PickUp                                     = false
end)

Fondra.Functions.AutoPickCrates                                 = LPH_JIT_MAX(function(Client, Character)
    if not Toggles.AutoPickCrates.Value then return end
    if Fondra.Cooldowns.PickUp then return end

    if not Client then return end
    if not Character then return end

    local Crate                                                 = Fondra.Functions.ReturnCrate(Options.AutoPickRange.Value)

    if not Crate then return end

    Fondra.Cooldowns.PickUp                                     = true

    task.wait(0.25 + Options.AutoPickDelay.Value)

    if not Crate then Fondra.Cooldowns.PickUp = false return end

    Fondra.Services.ReplicatedStorage.Events.PIC_PU:FireServer(string.reverse(Crate:GetAttribute("jzu")))
    Fondra.Cooldowns.PickUp                                     = false
end)

Fondra.Functions.AutoPickTools                                  = LPH_JIT_MAX(function(Client, Character)
    if not Toggles.AutoPickTools.Value then return end
    if Fondra.Cooldowns.PickUp then return end

    if not Client then return end
    if not Character then return end

    local Tool                                                  = Fondra.Functions.ReturnTool(Options.AutoPickRange.Value)

    if not Tool then return end

    Fondra.Cooldowns.PickUp                                     = true

    task.wait(0.25 + Options.AutoPickDelay.Value)

    if not Tool then Fondra.Cooldowns.PickUp = false return end

    Fondra.Services.ReplicatedStorage.Events.PIC_TLO:FireServer(Tool.PrimaryPart)
    Fondra.Cooldowns.PickUp                                     = false
end)   

Fondra.Functions.AutoPickCash                                   = LPH_JIT_MAX(function(Client, Character)
    if not Toggles.AutoPickCash.Value then return end
    if Fondra.Cooldowns.PickUp then return end

    if not Client then return end
    if not Character then return end

    local Cash                                                  = Fondra.Functions.ReturnCash(Options.AutoPickRange.Value)

    if not Cash then return end

    Fondra.Cooldowns.PickUp                                     = true

    task.wait(0.25 + Options.AutoPickDelay.Value)

    if not Cash then Fondra.Cooldowns.PickUp = false return end

    Fondra.Services.ReplicatedStorage.Events.CZDPZUS:FireServer(Cash) 
    Fondra.Cooldowns.PickUp                                     = false
end)   

Fondra.Functions.AutoBreakDoors                                 = LPH_JIT_MAX(function(Client, Character)
    if not Toggles.BreakDoors.Value then return end
    if Fondra.Cooldowns.BreakDoors then return end

    if not Client then return end
    if not Character then return end

    local Door                                                  = Fondra.Functions.ReturnDoor(10)
    local Tool                                                  = FindFirstChildWhichIsA(Client.Character, "Tool")
    local Seed                                                  = nil

    if not Door then return end
    if not Tool then return end

    Fondra.Cooldowns.BreakDoors                                 = true

    if (Options.DoorMethod.Value == "Lockpick" or Options.DoorMethod.Value == "Both") and Tool.Name == "Lockpick" then
        task.wait(0.5)

        Seed = Tool.Remote:InvokeServer("S", Door, "d")
        Tool.Remote:InvokeServer("D", Door, "d", Seed)
        Tool.Remote:InvokeServer("C")

        task.wait(0.45)

        Door.Events.Toggle:FireServer("Open", Door.Knob1)

        task.wait(0.05)
    end

    if (Options.DoorMethod.Value == "Lockpick" or Options.DoorMethod.Value == "Both") and Tool.Name ~= "Lockpick" and FindFirstChild(Character, "Right Leg") and Fondra.Functions.EquippedMelee(Client) then
        Seed = Fondra.Services.ReplicatedStorage.Events["XMHH.2"]:InvokeServer(
            "\240\159\141\158", 
            tick(), 
            Tool, 
            "DZDRRRKI",
            Door, 
            "Door"
        )
        
        task.wait(0.5)

        Fondra.Services.ReplicatedStorage.Events["XMHH2.2"]:FireServer(
            "\240\159\141\158", 
            tick(), 
            Tool, 
            "2389ZFX34", 
            Seed, 
            false, 
            Character["Right Leg"], 
            Door.DoorBase, 
            Door, 
            Door.DoorBase.Position, 
            Door.DoorBase.Position
        )
    end

    task.wait(0.5)

    Fondra.Cooldowns.BreakDoors                                 = false
end)

Fondra.Functions.AutoBreakSafes                                 = LPH_JIT_MAX(function(Client, Character)
    if not Toggles.BreakSafes.Value then return end
    if Fondra.Cooldowns.BreakSafes then return end

    if not Client then return end
    if not Character then return end

    local Safe                                                  = Fondra.Functions.ReturnBreadMaker("Safe", 15)
    local Tool                                                  = FindFirstChildWhichIsA(Client.Character, "Tool")
    local Seed                                                  = nil

    if not Safe then return end
    if not Tool then return end

    Fondra.Cooldowns.BreakSafes                                 = true

    if (Options.SafeMethod.Value == "Lockpick" or Options.SafeMethod.Value == "Both") and Tool.Name == "Lockpick" then
        Seed = Tool.Remote:InvokeServer("S", Safe, "s")
        Tool.Remote:InvokeServer("D", Safe, "s", Seed)
        Tool.Remote:InvokeServer("C")

        task.wait(0.5)
    end

    if (Options.SafeMethod.Value == "Melee" or Options.SafeMethod.Value == "Both") and Tool.Name == "Crowbar" then
        Seed = Fondra.Services.ReplicatedStorage.Events["XMHH.2"]:InvokeServer(
            "\240\159\141\158", 
            tick(), 
            Tool, 
            "DZDRRRKI",
            Safe, 
            "Register"
        )
        
        task.wait(0.5)

        Fondra.Services.ReplicatedStorage.Events["XMHH2.2"]:FireServer(
            "\240\159\141\158", 
            tick(), 
            Tool, 
            "2389ZFX34", 
            Seed, 
            false, 
            Tool.Handle, 
            Safe.MainPart, 
            Safe, 
            Safe.MainPart.Position, 
            Safe.MainPart.Position
        )
    end

    task.wait(0.5)

    Fondra.Cooldowns.BreakSafes                                 = false
end)

Fondra.Functions.AutoBreakRegisters                             = LPH_JIT_MAX(function(Client, Character)
    if not Toggles.BreakRegisters.Value then return end
    if Fondra.Cooldowns.BreakRegisters then return end

    if not Client then return end
    if not Character then return end

    local Register                                              = Fondra.Functions.ReturnBreadMaker("Register", 15)
    local Tool                                                  = FindFirstChildWhichIsA(Client.Character, "Tool")
    local Seed                                                  = nil

    if not Register then return end
    if not Tool then return end

    Fondra.Cooldowns.BreakRegisters                             = true

    if FindFirstChild(Character, "Right Arm") and Fondra.Functions.EquippedMelee(Client) then
        Seed = Fondra.Services.ReplicatedStorage.Events["XMHH.2"]:InvokeServer(
            "\240\159\141\158", 
            tick(), 
            Tool, 
            "DZDRRRKI",
            Register, 
            "Register"
        )
        
        task.wait(0.5)

        Fondra.Services.ReplicatedStorage.Events["XMHH2.2"]:FireServer(
            "\240\159\141\158", 
            tick(), 
            Tool, 
            "2389ZFX34", 
            Seed, 
            false, 
            Character["Right Arm"], 
            Register.MainPart, 
            Register, 
            Register.MainPart.Position, 
            Register.MainPart.Position
        )
    end

    task.wait(0.5)

    Fondra.Cooldowns.BreakRegisters                             = false
end)

Fondra.Functions.AutoPickUp                                     = LPH_JIT_MAX(function(Client, Character)
    task.spawn(Fondra.Functions.AutoPickScraps, Client, Character)
    task.spawn(Fondra.Functions.AutoPickCrates, Client, Character)
    task.spawn(Fondra.Functions.AutoPickTools, Client, Character)
    task.spawn(Fondra.Functions.AutoPickCash, Client, Character)
end)

Fondra.Functions.AutoBreak                                      = LPH_JIT_MAX(function(Client, Character)
    task.spawn(Fondra.Functions.AutoBreakDoors, Client, Character)
    task.spawn(Fondra.Functions.AutoBreakSafes, Client, Character)
    task.spawn(Fondra.Functions.AutoBreakRegisters, Client, Character)
end)

Fondra.Functions.Reload                                         = LPH_JIT_MAX(function(Client, Character)
    if not Client then return end
    if not Character then return end

    if Fondra.Cooldowns.Reload then return end
    if not Toggles.InstantReload.Value then return end
    if not Fondra.Functions.EquippedGun(Client) then return end

    Fondra.Cooldowns.Reload                                     = true

    local Tool                                                  = FindFirstChildWhichIsA(Character, "Tool")
    local Values                                                = Tool.Values
    local Config                                                = require(Tool.Config)

    if (Values.Ammo.Value < (Config.MagSize - 1)) or (Values.StoredAmmo.Value ~= Config.StoredAmmo) then
        Fondra.Services.ReplicatedStorage.Events.GNX_R:FireServer(tick(), "KLWE89U0", Tool)
        Fondra.Services.ReplicatedStorage.Events.GNX_R:FireServer(tick(), "KLWE89U0", Tool)
    end

    task.wait(0.5)
    
    Fondra.Cooldowns.Reload                                     = false
end)

Fondra.Functions.SprayAura                                      = LPH_JIT_MAX(function(Client, Character)
    if not Client then return end
    if not Character then return end
	
    if not Toggles.SprayAura.Value then return end
    if Fondra.Functions.DownedCheck(Client) then return end
    if Fondra.Cooldowns.SprayAura then return end

    local Target, Distance, Limb                                = Fondra.Functions.Return({ Get = "Character", Part = "Random", Visible = "None" }, { Downed = Toggles.SprayAuraDowned.Value, Friendly = Toggles.SprayAuraFriendly.Value, Visible = false }, { Character = Options.SprayAuraDistance.Value }, { "Torso" })
    local Tool                                                  = FindFirstChildWhichIsA(Character, "Tool")

    if not Target then return end
    if not Distance then return end
    if not Limb then return end

    if not Tool then return end
    if Tool.Name ~= "Pepper-spray" then return end

    local Origin                                                = Character.HumanoidRootPart.Position
    local End                                                   = Limb.Position
    local Result                                                = Vector3.new(End.X, Origin.Y, End.Z)

    Fondra.Cooldowns.SprayAura                                  = true
    Character.HumanoidRootPart.CFrame                           = CFrame.lookAt(Origin, Result)
    
    Tool.RemoteEvent:FireServer("Spray", true)
    Tool.RemoteEvent:FireServer("Hit", Target.Character)
    Tool.RemoteEvent:FireServer("Spray", false)
    
    task.wait()

    Fondra.Cooldowns.SprayAura                                  = false
end)

Fondra.Functions.MeleeAura                                      = LPH_JIT_MAX(function(Client, Character)
    if not Client then return end
    if not Character then return end

    if not Toggles.MeleeAura.Value then return end
    if not Fondra.Functions.EquippedMelee(Client) then return end
    if Fondra.Functions.DownedCheck(Client) then return end
    if Fondra.Cooldowns.MeleeAura then return end

    local Target, Distance, Limb                                = Fondra.Functions.Return({ Get = "Character", Part = "Random", Visible = "None" }, { Downed = Toggles.MeleeAuraDowned.Value, Friendly = Toggles.MeleeAuraFriendly.Value, Visible = false }, { Character = Options.MeleeAuraDistance.Value }, Options.MeleeAuraParts:GetActiveValues())
    local Tool                                                  = FindFirstChildWhichIsA(Character, "Tool")
    local Config                                                = Tool and require(Tool.Config) or nil
    local Handle                                                = FindFirstChild(Tool, "Handle") or FindFirstChild(Tool, "WeaponHandle") or FindFirstChild(Character, "Right Arm")

    if not Target then return end
    if not Distance then return end
    if not Limb then return end

    if not Tool then return end
    if not Handle then return end

    Fondra.Cooldowns.MeleeAura                                  = true

    local Seed                                                  = Fondra.Services.ReplicatedStorage.Events["XMHH.2"]:InvokeServer(
        "\240\159\141\158", 
        tick(), 
        Tool, 
        "43TRFWX", 
        "Normal", 
        tick(), 
        true
    )

    task.wait(Config.Mains["S1"].DebounceTime / 3)
    
    Fondra.Services.ReplicatedStorage.Events["XMHH2.2"]:FireServer(
        "\240\159\141\158", 
        tick(), 
        Tool, 
        "2389ZFX34",
        Seed, 
        true, 
        Handle,
        Limb, 
        Target.Character, 
        Handle.Position, 
        Limb.Position
    )

    task.wait(0.15)

    Fondra.Cooldowns.MeleeAura                                  = false
end)

Fondra.Functions.FinishAura                                     = LPH_JIT_MAX(function(Client, Character)
    if not Client then return end
    if not Character then return end

    if not Toggles.FinishAura.Value then return end
    if not Fondra.Functions.EquippedMelee(Client) then return end
    if Fondra.Functions.DownedCheck(Client) then return end
    if Fondra.Cooldowns.FinishAura then return end

    local Target, Distance, Limb                                = Fondra.Functions.Return({ Get = "Character", Part = "Random", Visible = "None" }, { Downed = false, Friendly = Toggles.FinishAuraFriendly.Value, Visible = false }, { Character = Options.FinishAuraDistance.Value }, { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" })
    local Tool                                                  = FindFirstChildWhichIsA(Character, "Tool")
    local Handle                                                = FindFirstChild(Character, "Right Leg")

    if not Target then return end
    if not Distance then return end
    if not Limb then return end

    if not Tool then return end
    if not Handle then return end
    if not Fondra.Functions.DownedCheck(Target) then return end

    Fondra.Cooldowns.FinishAura                                 = true

    local Config                                                = require(Tool.Config)
    local Seed                                                  = Fondra.Services.ReplicatedStorage.Events["XMHH.2"]:InvokeServer(
        "\240\159\141\158", 
        tick(), 
        Tool, 
        "EXECQX"
    )

    task.wait(0.25)
    
    Fondra.Services.ReplicatedStorage.Events["XMHH2.2"]:FireServer(
        "\240\159\141\158", 
        tick(), 
        Tool, 
        "2389ZFX34", 
        Seed, 
        false, 
        Handle, 
        Limb, 
        Target.Character, 
        Handle.Position, 
        Limb.Position
    )

    task.wait(0.15)

    Fondra.Cooldowns.FinishAura                                 = false
end)

Fondra.Functions.RageBot                                        = LPH_JIT_MAX(function(Client, Character)
    if not Client then return end
    if not Character then return end

    if not Toggles.RageBot.Value then return end
    if not Fondra.Functions.EquippedGun(Client) then return end
    if Fondra.Functions.DownedCheck(Client) then return end

    local Tool                                                  = FindFirstChildWhichIsA(Character, "Tool")
    local Config                                                = require(Tool.Config)

    if not Tool then return end
    if not Config then return end
    if not Fondra.Cooldowns.RageBot then Fondra.Cooldowns.RageBot = tick() end
    if Options.RageBotMode.Value == "Hold" and not Fondra.Services.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

    if ((tick() - Fondra.Cooldowns.RageBot) > ((Toggles.RageBotFasterHit.Value and 0.15) or (Toggles.RageBotInstantHit.Value and 0.005) or (1 / Config.FireRate))) and (Tool.Values.SERVER_Ammo.Value > 0) then
        Fondra.Cooldowns.RageBot                                = tick()

        local Target, Distance, Limb                            = Fondra.Functions.Return({ Get = "Character", Part = "Random", Visible = "Wallbang" }, { Downed = Toggles.RageBotDowned.Value, Friendly = Toggles.RageBotFriendly.Value, Visible = true }, { Character = Options.RageBotDistance.Value }, Options.RageBotParts:GetActiveValues())

        if not Target then return end
        if not Distance then return end
        if not Limb then return end

        if Toggles.RageBotAnimation.Value then Fondra.Functions.GunAnimation(Tool, "Fire") end
        if Toggles.RageBotSound.Value then Fondra.Functions.GunSound(Tool, "Muzzle", "FireSound1") end
        if Toggles.RageBotNotify.Value then Library:Notify(string.format("%s, %s Meters, %s", Target.Name, math.floor(Distance), Limb.Name)) end

        local Key                                               = Fondra.Functions.RandomString(30)..0
        local Part1                                             = Instance.new("Part", Fondra.Camera.Bullets)
        Part1.Size                                              = Vector3.new(0.25, 0.25, 0.25)
        Part1.Transparency                                      = 1
        Part1.CanCollide                                        = false
        Part1.CFrame                                            = CFrame.new(getrenv()._G.FP and Fondra.Services.Workspace.Camera.ViewModel.Tool.WeaponHandle.FirePos.WorldCFrame.Position or Tool.WeaponHandle.FirePos.WorldCFrame.Position)
        Part1.Anchored                                          = true
        
        local Part2                                             = Instance.new("Part", Fondra.Camera.Bullets)
        Part2.Size                                              = Vector3.new(0.25, 0.25, 0.25)
        Part2.Transparency                                      = 0
        Part2.CanCollide                                        = false
        Part2.CFrame                                            = CFrame.new(Limb.Position)
        Part2.Anchored                                          = true
        Part2.Color                                             = Options.MainColor.Value

        local Attachment0                                       = Instance.new("Attachment", Part1)
        local Attachment1                                       = Instance.new("Attachment", Part2)

        local Beam                                              = Instance.new("Beam", Part1)
        Beam.FaceCamera                                         = true
        Beam.Color                                              = ColorSequence.new({ ColorSequenceKeypoint.new(0, Options.AccentColor.Value), ColorSequenceKeypoint.new(1, Options.AccentColor.Value), })
        Beam.Attachment0                                        = Attachment0
        Beam.Attachment1                                        = Attachment1
        Beam.LightEmission                                      = 0
        Beam.LightInfluence                                     = 0
        Beam.Width0                                             = 0.05
        Beam.Width1                                             = 0.05

        local FirePosition                                      = Tool.WeaponHandle.FirePos.WorldCFrame.p
        local HitPositions                                      = {}

        for Index = 1, Config.BulletsPerShot do table.insert(HitPositions, CFrame.new(FirePosition, Limb.Position).LookVector) end

        Fondra.Services.ReplicatedStorage.Events.GNX_S:FireServer(
            tick(),
            Key,
            Tool,
            "FDS9I83",
            FirePosition,
            HitPositions,
            false
        )
                
        task.wait(0.1)

        for Index, HitPosition in next, HitPositions do Fondra.Services.ReplicatedStorage.Events.ZFKLF_H:FireServer(
            "\240\159\141\175",
            Tool,
            Key,
            Index,
            Limb,
            Limb.Position,
            HitPosition,
            nil,
            nil
        ) end

        Tool.Hitmarker:Fire(Limb)
        Tool.Values.Ammo.Value                                  = Tool.Values.SERVER_Ammo.Value
        Tool.Values.StoredAmmo.Value                            = Tool.Values.SERVER_StoredAmmo.Value

        task.delay(5, function()
            for i = 0.5, 1, 0.02 do
                task.wait()

                Beam.Transparency                               = NumberSequence.new(i)
                Part2.Transparency                              = i
            end

            Part1:Destroy()
            Part2:Destroy()
        end)
    end
end)

-- // Main Handlers

task.spawn(Fondra.Functions.LocalCharacter, Fondra.Client.Character)
Fondra.Client.CharacterAdded:Connect(Fondra.Functions.LocalCharacter)

Options.SelectedSkyBox:SetValues(Fondra.Functions.GetSkyBoxes())
Options.SelectedSkyBox:SetValue("Default")
Options.SelectedHitMarker:SetValues(Fondra.Functions.GetHitMarkers())
Options.SelectedHitMarker:SetValue("Default")

Toggles.Ambience:OnChanged(function(V)
	if (V) then return end

	Fondra.Services.Lighting.Ambient							= Fondra.Services.Lighting["DefaultLightingConfig"]["Ambient"].Value
	Fondra.Services.Lighting.OutdoorAmbient						= Fondra.Services.Lighting["DefaultLightingConfig"]["OutdoorAmbient"].Value

	Options.AmbienceColor1:SetValueRGB(Fondra.Services.Lighting.Ambient)
	Options.AmbienceColor2:SetValueRGB(Fondra.Services.Lighting.OutdoorAmbient)
end)

Toggles.Shift:OnChanged(function(V)
	if (V) then return end

	Fondra.Services.Lighting.ColorShift_Bottom					= Fondra.Services.Lighting["DefaultLightingConfig"]["ColorShift_Bottom"].Value
	Fondra.Services.Lighting.ColorShift_Top						= Fondra.Services.Lighting["DefaultLightingConfig"]["ColorShift_Top"].Value

	Options.ShiftColor1:SetValueRGB(Fondra.Services.Lighting.ColorShift_Bottom)
	Options.ShiftColor2:SetValueRGB(Fondra.Services.Lighting.ColorShift_Top)
end)

Toggles.ShadowMap:OnChanged(function(V)
	Fondra.Services.Lighting.GlobalShadows						= V and V or Fondra.Services.Lighting["DefaultLightingConfig"]["GlobalShadows"].Value
end)

Toggles.ForceTime:OnChanged(function(V)
	Fondra.Services.Lighting.ClockTime							= V and Options.SelectedTime or Fondra.Services.Lighting["DefaultLightingConfig"]["ClockTime"].Value
end)

Toggles.ForceLatitude:OnChanged(function(V)
	Fondra.Services.Lighting.GeographicLatitude					= V and Options.SelectedLatitude.Value or Fondra.Services.Lighting["DefaultLightingConfig"]["GeographicLatitude"].Value
end)

Toggles.ForceDiffuse:OnChanged(function(V)
	Fondra.Services.Lighting.EnvironmentDiffuseScale			= V and Options.SelectedDiffuse.Value or Fondra.Services.Lighting["DefaultLightingConfig"]["EnvironmentDiffuseScale"].Value
end)

Toggles.SkyBox:OnChanged(function(V)
	Options.SelectedSkyBox:SetValues(Fondra.Functions.GetSkyBoxes())
	Fondra.Functions.SetSkyBox(not V and "Default" or Options.SelectedSkyBox.Value)
end)

Toggles.CustomHitMarker:OnChanged(function(V)
	Options.SelectedHitMarker:SetValues(Fondra.Functions.GetHitMarkers())
	Fondra.Functions.SetHitMarker(not V and "Default" or Options.SelectedHitMarker.Value)
end)

Toggles.RageBot:OnChanged(function(V)
    if not V then return end

    if Toggles.LegitBot.Value then Toggles.LegitBot:SetValue(false) Library:Notify("Turned off LegitBot because RageBot has been turned on.") end
end)

Toggles.LegitBot:OnChanged(function(V)
    if not V then return end

    if Toggles.RageBot.Value then Toggles.RageBot:SetValue(false) Library:Notify("Turned off RageBot because LegitBot has been turned on.") end
end)

Toggles.Fly:OnChanged(function(V)
    Fondra.Functions.Fly(Fondra.Client, Fondra.Client.Character)
end)

Toggles.SBot:OnChanged(function(V)
    Fondra.Functions.SpinBot(Fondra.Client, Fondra.Client.Character)
end)

Toggles.FLag:OnChanged(function(V)
    Fondra.Services.NetworkClient:SetOutgoingKBPSLimit(9e9)
end)

Toggles.ChatLogs:OnChanged(function(V)
    local ChatFrame                                             = Fondra.Client.PlayerGui.Chat.Frame
	ChatFrame.ChatChannelParentFrame.Visible                    = V
	ChatFrame.ChatBarParentFrame.Position                       = V and (ChatFrame.ChatChannelParentFrame.Position + UDim2.new(UDim.new(), ChatFrame.ChatChannelParentFrame.Size.Y)) or (UDim2.new(0, 0, 0, 0))
end)

Options.SpinSpeed:OnChanged(function(V)
    Fondra.Functions.SpinBot(Fondra.Client, Fondra.Client.Character)
end)

Options.SelectedHitMarker:OnChanged(function(V)
	Options.SelectedHitMarker:SetValues(Fondra.Functions.GetHitMarkers())
	Fondra.Functions.SetHitMarker(Toggles.CustomHitMarker.Value and V or nil)
end)

Options.SelectedTime:OnChanged(function(V)
	if (not Toggles.ForceTime.Value) then return end

	Fondra.Services.Lighting.ClockTime							= Options.SelectedTime.Value
end)

Options.SelectedLatitude:OnChanged(function(V)
	if (not Toggles.ForceLatitude.Value) then return end

	Fondra.Services.Lighting.GeographicLatitude					= Options.SelectedLatitude.Value
end)

Options.ShiftColor1:OnChanged(function(V)
	Fondra.Services.Lighting.ColorShift_Bottom					= Options.ShiftColor1.Value
	Fondra.Services.Lighting.ColorShift_Top						= Options.ShiftColor2.Value
end)

Options.ShiftColor2:OnChanged(function(V)
	Fondra.Services.Lighting.ColorShift_Bottom					= Options.ShiftColor1.Value
	Fondra.Services.Lighting.ColorShift_Top						= Options.ShiftColor2.Value
end)

Options.SelectedSkyBox:OnChanged(function(V)
	Options.SelectedSkyBox:SetValues(Fondra.Functions.GetSkyBoxes())
	Fondra.Functions.SetSkyBox(Toggles.SkyBox.Value and V or nil)
end)

Fondra.Services.RunService:UnbindFromRenderStep("Main.lua")
Fondra.Services.RunService:BindToRenderStep("Main.lua", Enum.RenderPriority.Camera.Value + 1, function(Delta)
    task.spawn(Fondra.Functions.ProjectileController, Fondra.Client, Fondra.Client.Character)
    task.spawn(Fondra.Functions.FlyController, Fondra.Client, Fondra.Client.Character)
    task.spawn(Fondra.Functions.Visualize, Fondra.Client, Fondra.Client.Character)

    if Fondra.Functions.ValidCheck(Fondra.Client) then
        task.spawn(Fondra.Functions.BHop, Fondra.Client, Fondra.Client.Character)
        task.spawn(Fondra.Functions.Stats, Fondra.Client, Fondra.Client.Character)
        task.spawn(Fondra.Functions.FakeLag, Fondra.Client, Fondra.Client.Character)
        task.spawn(Fondra.Functions.TriggerBot, Fondra.Client, Fondra.Client.Character)

        task.spawn(Fondra.Functions.AutoPickUp, Fondra.Client, Fondra.Client.Character)
        task.spawn(Fondra.Functions.AutoBreak, Fondra.Client, Fondra.Client.Character)
        task.spawn(Fondra.Functions.Reload, Fondra.Client, Fondra.Client.Character)

        task.spawn(Fondra.Functions.RageBot, Fondra.Client, Fondra.Client.Character)
        task.spawn(Fondra.Functions.SprayAura, Fondra.Client, Fondra.Client.Character)
        task.spawn(Fondra.Functions.MeleeAura, Fondra.Client, Fondra.Client.Character)
        task.spawn(Fondra.Functions.FinishAura, Fondra.Client, Fondra.Client.Character)
    end
end)

Library:Notify(string.format("Loaded Main.lua in %.4f MS", tick() - Fondra.Data.Start))
Library.SaveManager:LoadAutoloadConfig()