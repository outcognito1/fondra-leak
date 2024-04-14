Fondra.Functions.ClearConnection("Input Started", Fondra.Connections)
Fondra.Functions.ClearConnection("Input Ended", Fondra.Connections)

Fondra.Functions.ClearConnection("Character Added", Fondra.Connections)
Fondra.Functions.ClearConnection("Mouse Move", Fondra.Connections)
Fondra.Functions.ClearConnection("Main", Fondra.Connections)

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

local Toggles                                                   = getgenv().Toggles
local Options                                                   = getgenv().Options

local Fly                                                       = { Forward = 0, Backward = 0, Left = 0, Right = 0, Current = { BodyVelocity = nil, BodyGyro = nil } }
local Fly                                                       = { Forward = 0, Backward = 0, Left = 0, Right = 0, Current = { BodyVelocity = nil, BodyGyro = nil } }
local Vars                                                      = {
    Alive                                                       = true,
    Downed                                                      = false,

    Gun                                                         = { Data = nil, Model = nil },
    Melee                                                       = false
}

do
    BParams.FilterType                                          = Enum.RaycastFilterType.Exclude
    BParams.IgnoreWater                                         = true
    BParams.RespectCanCollide                                   = true
    BParams.FilterDescendantsInstances                          = { Fondra.Services.Workspace.Chars, Fondra.Camera }
end do
    RParams.FilterType                                          = Enum.RaycastFilterType.Exclude
    RParams.IgnoreWater                                         = true
    RParams.RespectCanCollide                                   = true
end

-- #Region // Fly
Fondra.Functions.NewConnection("Input Began", Fondra.Connections, Fondra.Services.UserInputService.InputBegan, function(Key)
	if Key.KeyCode == Enum.KeyCode.W then
		Fly.Forward 	                                        = 1
	end

	if Key.KeyCode == Enum.KeyCode.S then
        Fly.Backward 	                                        = -1
	end

	if Key.KeyCode == Enum.KeyCode.D then
        Fly.Right 	                                            = 1
	end

	if Key.KeyCode == Enum.KeyCode.A then
        Fly.Left 	                                            = -1
	end
end)

Fondra.Functions.NewConnection("Input Ended", Fondra.Connections, Fondra.Services.UserInputService.InputEnded, function(Key)
	if Key.KeyCode == Enum.KeyCode.W then
		Fly.Forward 	                                        = 0
	end

	if Key.KeyCode == Enum.KeyCode.S then
        Fly.Backward 	                                        = 0
	end

	if Key.KeyCode == Enum.KeyCode.D then
        Fly.Right 	                                            = 0
	end

	if Key.KeyCode == Enum.KeyCode.A then
        Fly.Left 	                                            = 0
	end
end)
-- #EndRegion

-- #Region // Checks Functions
Fondra.Functions.EquippedGun                                    = function(Character, Bool)
    local Character                                             = Character

    if not Character then return end

    local RayValue                                              = FindFirstChildWhichIsA(Character, "RayValue")
    local GunStatus                                             = RayValue and FindFirstChild(RayValue, "GunStatus")
    local GunModel                                              = FindFirstChild(Character, "ServerGunModel")

    if RayValue and GunStatus and GunModel then
        if Bool then return { Data = RayValue, Model = GunModel } end

        return RayValue, GunModel
    end

    return
end

Fondra.Functions.EquippedMelee                                  = function(Character)
    if not Character then return end

    local RayValue                                              = FindFirstChildWhichIsA(Character, "RayValue")
    local MeleeStatus                                           = RayValue and FindFirstChild(RayValue, "MeleeStatus")

    if RayValue and MeleeStatus then
        return RayValue, MeleeStatus
    end

    return
end

Fondra.Functions.ValidCheck                                     = function(Character)
    if not Character then return false end
    if not FindFirstChild(Character, "Humanoid") then return false end
    if not FindFirstChild(Character, "HumanoidRootPart") then return false end
    if FindFirstChild(Character, "Humanoid").Health <= 0 then return false end

    return true
end

Fondra.Functions.ForceFieldCheck                                = function(Character)
    return FindFirstChildWhichIsA(Character.Torso, "ForceField") ~= nil
end

Fondra.Functions.DownedCheck                                    = function(Character)
    return Character.GetAttribute(Character, "Downed")
end

Fondra.Functions.FriendlyCheck                                  = function(Player)
    return Player.IsFriendsWith(Player, Fondra.Client.UserId)
end

Fondra.Functions.VisibleCheck                                   = function(Character, Limb, Method)
	if (Method == "Wallbang") and (Character.HumanoidRootPart.Position - Fondra.Client.Character.HumanoidRootPart.Position).Magnitude < 30 then return true end
    if (Method == "None") then return true end

	local Data, Model                                           = Vars.Gun.Data, Vars.Gun.Model
	local Origin 										        = Fondra.Client.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, -3)

    if not Data then return false end
    if not Model then return false end

    local Result                                                = Fondra.Functions.CustomRaycast(Origin.Position, Limb.Position - Origin.Position, {
        Fondra.Services.Workspace.Chars,
		Fondra.Client.Character,
        Fondra.Camera,
		Character,
	})

    if Result then
        return false
    else
        return true
    end
end
-- #EndRegion

-- #Region // Fondra Functions
Fondra.Functions.Unload                                         = function()
    cleardrawcache()
    Fondra.Functions.ClearConnections(Fondra.Connections)
    Fondra.Functions.ClearHooks(Fondra.Hooks)
end

Fondra.Functions.RandomString                                   = function(Length)
    local Result    = ""

    for i = 1, Length do
        Result = Result .. string.char(NextInteger(Fondra.Random, 97, 122))
    end

    return Result
end

Fondra.Functions.CustomRaycast									= function(Origin, Direction, Blacklist)
	RParams.FilterDescendantsInstances                     	 	= Blacklist

	local Result 											    = Raycast(Fondra.Services.Workspace, Origin, Direction, RParams)
	
	if Result and Result.Instance then
		table.insert(Blacklist, Result.Instance)

		if Result.Instance.Transparency == 1 then
			return Fondra.Functions.CustomRaycast(Origin, Direction, Blacklist)
		end

		if not Result.Instance.CanCollide then
			return Fondra.Functions.CustomRaycast(Origin, Direction, Blacklist)
		end

		return Result
	else
		return false
	end
end

Fondra.Functions.Return                                         = function(Methods, Checks, Lengths, Limbs)
    local Methods                                               = Methods or { Get = "Character", Part = "Random", Visible = "Default" }
    local Checks                                                = Checks or { Downed = true, Friendly = true }
	local Limbs 												= Limbs or {}

    local Target, Distance, Limb								= nil, nil, nil

    if (Methods.Get == "Mouse") then
        for Index, Player in next, GetPlayers(Fondra.Services.Players) do
			if Player == Fondra.Client then continue end

            if not Fondra.Functions.ValidCheck(Player.Character) then continue end
            if Fondra.Functions.ForceFieldCheck(Player.Character) then continue end
            if Checks.Downed and Fondra.Functions.DownedCheck(Player.Character) then continue end
            if Checks.Friendly and Fondra.Functions.FriendlyCheck(Player) then continue end

			local Data 										    = {}
            local Total                                         = #Limbs <= 0 and { Player.Character["Torso"] } or {}
            local Selected                                      = nil

            local Vector, OnScreen                              = WorldToScreenPoint(Fondra.Camera, Player.Character.HumanoidRootPart.Position)
            local MouseBetween                                  = (Vector2.new(Fondra.Mouse.X, Fondra.Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).Magnitude
            local CharacterBetween                              = (Player.Character.HumanoidRootPart.Position - Fondra.Client.Character.HumanoidRootPart.Position).Magnitude

			if not OnScreen then continue end

            for Index, Object in next, Limbs do
                if not FindFirstChild(Player.Character, Object) then continue end
        
				local Limb 									    = FindFirstChild(Player.Character, Object)
				local Vector, OnScreen                          = WorldToScreenPoint(Fondra.Camera, Limb.Position)
				local Difference	                            = (Vector2.new(Fondra.Mouse.X, Fondra.Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).Magnitude

                table.insert(Total, Limb)

				if not OnScreen then continue end

				Data[Player.Character[Object]]				    = Difference
            end

            if not Selected then Selected = Player.Character["Torso"] end
            if not Distance then Distance = Lengths.Mouse end

            if (MouseBetween <= Distance) and (CharacterBetween <= Lengths.Character) then
				for Limb, Difference in next, Data do
					if not Limb then continue end
					if not Difference then continue end
					if Difference >= Distance then continue end

					Distance								    = Difference
					Selected								    = Limb
				end

                if Checks.Visible and not Fondra.Functions.VisibleCheck(Player.Character, Selected, Methods.Visible) then continue end

                Target                                          = Player.Character
                Distance                                        = MouseBetween
                Limb                                            = Selected
            end
        end
    end

    if (Methods.Get == "Character") then
        for Index, Player in next, GetPlayers(Fondra.Services.Players) do
			if Player == Fondra.Client then continue end                          

            if not Fondra.Functions.ValidCheck(Player.Character) then continue end
            if Fondra.Functions.ForceFieldCheck(Player.Character) then continue end
            if Checks.Downed and Fondra.Functions.DownedCheck(Player.Character) then continue end
            if Checks.Friendly and Fondra.Functions.FriendlyCheck(Player) then continue end

            local Total                                         = #Limbs <= 0 and { Player.Character["Torso"] } or {}
            local Selected                                      = nil
            local CharacterBetween                              = (Player.Character.HumanoidRootPart.Position - Fondra.Client.Character.HumanoidRootPart.Position).Magnitude

            for Index, Object in next, Limbs do
                if not FindFirstChild(Player.Character, Object) then continue end
        
                table.insert(Total, Player.Character[Object])
            end

            if not Selected then Selected = Total[NextInteger(Fondra.Random, 1, #Total)] end
            if not Distance then Distance = Lengths.Character end

            if (CharacterBetween <= Distance) then
                if Checks.Visible and not Fondra.Functions.VisibleCheck(Player.Character, Selected, Methods.Visible) then continue end

                Target                                          = Player.Character
                Distance                                        = CharacterBetween
                Limb                                            = Selected
            end
        end
    end

    if not Target then return end
    if not Distance then return end
    if not Limb then return end

    return Target, Distance, Limb
end

Fondra.Functions.LocalCharacter                                 = function(Character)
    local HumanoidRootPart                                      = WaitForChild(Character, "HumanoidRootPart")
    local Humanoid                                              = WaitForChild(Character, "Humanoid")
    local Torso                                                 = WaitForChild(Character, "Torso")
    local Head                                                  = WaitForChild(Character, "Head")

    task.wait(0.5)

    Vars.Alive                                                  = true
    Vars.Downed                                                 = false

    Vars.Gun                                                    = { Data = nil, Model = nil }
    Vars.Melee                                                  = false

    Character.ChildAdded:Connect(function(Tool)
        if IsA(Tool, "RayValue") then return end

        Vars.Gun                                                = Fondra.Functions.EquippedGun(Character, true)
        Vars.Melee                                              = Fondra.Functions.EquippedMelee(Character)
    end)

    Character.ChildRemoved:Connect(function(Tool)
        if IsA(Tool, "RayValue") then return end

        Vars.Gun                                                = { Data = nil, Model = nil }
        Vars.Melee                                              = false
    end)

    Humanoid.HealthChanged:Connect(function()
        Vars.Alive                                              = Fondra.Functions.ValidCheck(Character)
        Vars.Downed                                             = Fondra.Functions.DownedCheck(Character)
    end)

    Fondra.Functions.SpinBot(Fondra.Client, Character)
end

Fondra.Functions.Shoot                                          = function(Target)
    if not isrbxactive() then return end

	local Data, Model                                           = Vars.Gun.Data, Vars.Gun.Model
	local Status 												= Data and FindFirstChild(Data, "GunStatus")

    if not Data then return end
    if not Model then return end
    if not Status then return end
    if Status:GetAttribute("Magazine") <= 0 then return end

    if not Toggles.TriggerBot.Value then return end
    if Options.TriggerBotShootChance.Value <= NextInteger(Fondra.Random, 1, 100) then return end

    local Character                                             = Target
	local Target												= Fondra.Services.Players:GetPlayerFromCharacter(Target)

	if Fondra.Functions.ForceFieldCheck(Character) then return end
	if Fondra.Functions.DownedCheck(Character) and Toggles.TriggerBotDowned.Value then return end
	if Fondra.Functions.FriendlyCheck(Target) and Toggles.TriggerBotFriendly.Value then return end
    
	mouse1press()

	task.wait()

	if not FindFirstChildWhichIsA(Fondra.Client.Character, "RayValue") then return end

	mouse1release()
end
-- #EndRegion

-- #Region // Main.Functions
Fondra.Functions.FlyController                                  = function(Client, Character)
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
end

Fondra.Functions.Fly                                            = function(Client, Character)
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
end

Fondra.Functions.RageBot								        = function(Client, Character)
	if not Client then return end
    if not Character then return end

    if not Toggles.RageBot.Value then return end
    if Fondra.Functions.DownedCheck(Character) then return end
    if Options.RageBotMode.Value == "Hold" and not Fondra.Services.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

	local Data, Model                                           = Vars.Gun.Data, Vars.Gun.Model
	local Settings 											    = Model and FindFirstChild(Model, "Settings") and require(Model.Settings)
	local Status 												= Data and FindFirstChild(Data, "GunStatus")

    if not Data then return end
    if not Model then return end
    if not Status then return end
	
	if Status:GetAttribute("Magazine") > 0 then
		Fondra.Cooldowns.Reload									= false
	end

	if Status:GetAttribute("Magazine") <= 0 and not Fondra.Cooldowns.Reload then
		Fondra.Cooldowns.Reload									= true

		Library:Notify("Bullets = haram")

		return Fondra.Services.ReplicatedStorage.GunStorage.Events.Reload:InvokeServer(nil)
	end

    if (tick() - Fondra.Cooldowns.RageBot <= 0.15) then return end

	Fondra.Cooldowns.RageBot									= tick()

	local Target, Distance, Limb                                = Fondra.Functions.Return({ Get = "Character", Part = "Random", Visible = "Wallbang" }, { Downed = Toggles.RageBotDowned.Value, Friendly = Toggles.RageBotFriendly.Value, Visible = true }, { Character = Options.RageBotDistance.Value }, Options.RageBotParts:GetActiveValues())

	if not Target then return end
	if not Distance then return end
	if not Limb then return end

	local Origin                                                = CFrame.lookAt((Client.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, -3)).Position, Limb.Position)
    local Random1                                           	= math.random(4000, 8000)
    local Random2                                           	= math.floor(Random1 / 2.25)

	local Part1                                             	= Instance.new("Part", Fondra.Camera)
	Part1.Size                                              	= Vector3.new(0.25, 0.25, 0.25)
	Part1.Transparency                                      	= 1
	Part1.CanCollide                                        	= false
	Part1.CFrame                                            	= Origin
	Part1.Anchored                                          	= true

	local Part2                                             	= Instance.new("Part", Fondra.Camera)
	Part2.Size                                              	= Vector3.new(0.25, 0.25, 0.25)
	Part2.Transparency                                      	= 0
	Part2.CanCollide                                        	= false
	Part2.CFrame                                            	= CFrame.new(Limb.Position)
	Part2.Anchored                                          	= true
	Part2.Color                                             	= Options.MainColor.Value

	local Attachment0                                       	= Instance.new("Attachment", Part1)
	local Attachment1                                       	= Instance.new("Attachment", Part2)

	local Beam                                              	= Instance.new("Beam", Part1)
	Beam.FaceCamera                                         	= true
	Beam.Color                                              	= ColorSequence.new({ ColorSequenceKeypoint.new(0, Options.AccentColor.Value), ColorSequenceKeypoint.new(1, Options.AccentColor.Value), })
	Beam.Attachment0                                        	= Attachment0
	Beam.Attachment1                                        	= Attachment1
	Beam.LightEmission                                      	= 0
	Beam.LightInfluence                                     	= 0
	Beam.Width0                                             	= 0.05
	Beam.Width1                                             	= 0.05

    Fondra.Services.ReplicatedStorage.GunStorage.Events.Shoot:FireServer(Origin.Position, Origin, 1, 1, Random1, Random2)
    Fondra.Services.ReplicatedStorage.GunStorage.Events.Hit:FireServer(Limb, Random2)

	task.delay(5, function()
		for i = 0.5, 1, 0.02 do
			task.wait()

			Beam.Transparency                               	= NumberSequence.new(i)
			Part2.Transparency                              	= i
		end

		Part1:Destroy()
		Part2:Destroy()
	end)
end

Fondra.Functions.MeleeAura 									    = function(Client, Character)
    if not Client then return end
    if not Character then return end

    if not Toggles.MeleeAura.Value then return end
    if not Fondra.Functions.EquippedMelee(Character) then return end
    if Fondra.Functions.DownedCheck(Character) then return end
    if (tick() - Fondra.Cooldowns.MeleeAura <= 0.15) then return end

    local Target, Distance, Limb                                = Fondra.Functions.Return({ Get = "Character", Part = "Random", Visible = "None" }, { Downed = Toggles.MeleeAuraDowned.Value, Friendly = Toggles.MeleeAuraFriendly.Value, Visible = false }, { Character = Options.MeleeAuraDistance.Value }, Options.MeleeAuraParts:GetActiveValues())

    if not Target then return end
    if not Distance then return end
    if not Limb then return end

	Fondra.Cooldowns.MeleeAura                                  = tick()
	Fondra.Services.ReplicatedStorage.MeleeStorage.Events.Swing:InvokeServer()
	Fondra.Services.ReplicatedStorage.MeleeStorage.Events.Hit:FireServer(Limb, Limb.Position)
end

Fondra.Functions.TriggerBot                                     = function(Client, Character)
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

    if Target.Parent.Parent ~= Fondra.Services.Workspace.Chars then return end
    if not table.find(Options.TriggerBotParts:GetActiveValues(), Target.Name) then return end
	if not Fondra.Functions.VisibleCheck(Player, Target, "Default") then return end
	if (Player.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude >= Options.TriggerBotDistance.Value then return end

    task.delay(Delay + Randomized, function()
		Fondra.Functions.Shoot(Target.Parent)
	end)
end

Fondra.Functions.FakeLag                                        = function(Client, Character)
    if not Client then return end
    if not Character then return end
    if not Toggles.FLag.Value then return end

    if (tick() - Fondra.Cooldowns.FakeLag) > Options.LagAmount.Value then
        Character.Archivable                                    = true
        Fondra.Cooldowns.FakeLag                                = tick()

        if Toggles.FLagVisual.Value then
            getgenv().FLagVisual:SetPrimaryPartCFrame(Fondra.Client.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0.01, 0))
        end

        Fondra.Services.NetworkClient:SetOutgoingKBPSLimit(9e9)

        return
    end

    Fondra.Services.NetworkClient:SetOutgoingKBPSLimit(1)
end

Fondra.Functions.SpinBot                                        = function(Client, Character)
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
end

Fondra.Functions.BHop                                           = function(Client, Character)
    if not Client then return end
    if not Character then return end
    if not Toggles.BHop.Value then return end
    if not FindFirstChild(Character, "HumanoidRootPart") then return end

    local Result                                                = Raycast(Fondra.Services.Workspace, Character.HumanoidRootPart.Position, Vector3.new(0, -4, 0), BParams)

    if not Result then return end
    if not Result.Instance then return end

    Character.HumanoidRootPart.Velocity                         = (Fondra.Camera.CFrame * CFrame.new(0, 65, -50)).p - Fondra.Camera.CFrame.p
end

Fondra.Functions.NoClip                                         = function(Client, Character)
    if not Client then return end
    if not Character then return end

    if Toggles.Noclip.Value then
        for Index, Object in next, Character:GetChildren() do
            if not Object:IsA("BasePart") then continue end
            if not Object.CanCollide then continue end

            Object.CanCollide                                   = false
        end
    end

    if not Toggles.Noclip.Value then
        Character.HumanoidRootPart.CanCollide                   = true
        Character.HeadPart.CanCollide                           = true
        Character.Torso.CanCollide                              = true

        return
    end
end
-- #EndRegion

-- #Region // Hooks
local Namecall; Namecall                                        = hookmetamethod(game, "__namecall", function(Self, ...)
    local Arguments                                             = {...}
    local Method                                                = getnamecallmethod()
    local Calling                                               = getcallingscript()

    if Method == "Raycast" and Calling.Name == "GunHandler" and not checkcaller() then 
        local Data, Model                                       = Vars.Gun.Data, Vars.Gun.Model
        local Chance                                            = NextInteger(Fondra.Random, 1, 100)

        if (not Data) or (not Model) or (Options.LegitBotHitChance.Value <= Chance) then return Namecall(Self, table.unpack(Arguments)) end

        local Target, Distance, Limb                            = Fondra.Functions.Return({ Get = "Mouse", Part = "Random", Visible = "Check" }, { Downed = Toggles.LegitBotDowned.Value, Friendly = Toggles.LegitBotFriendly.Value, Visible = true }, { Character = Options.LegitBotDistance.Value, Mouse = Options.LegitBotRadius.Value }, Options.LegitBotParts.GetActiveValues(Options.LegitBotParts))

        if (not Target) or (not Distance) or (not Limb) then return Namecall(Self, table.unpack(Arguments)) end

        local Size                                              = Limb.Size / 2
        local Randomized                                        = Vector3.new(NextNumber(Fondra.Random, -Size.X, Size.X), NextNumber(Fondra.Random, -Size.Y, Size.Y), NextNumber(Fondra.Random, -Size.Z, Size.Z))

        Arguments[2]                                            = ((Limb.CFrame.Position) - Arguments[1]).Unit * 1000

        return Namecall(Self, table.unpack(Arguments))
    end

    return Namecall(Self, table.unpack(Arguments))
end)

local NewIndex; NewIndex										= hookmetamethod(game, "__newindex", function(Self, Index, Value)
	local Name 													= tostring(Self)
	local Method 												= tostring(Index)
	local Result 												= tostring(Value)

    if not Fondra.SkyBoxes then return NewIndex(Self, Index, Value) end

	local Sky 													= Fondra.SkyBoxes[Options.SelectedSkyBox.Value] or nil

	-- Lighting
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

	-- Atmosphere
	if (Name == "Atmosphere") and (Method == "Decay") and (Self.Parent == Fondra.Services.Lighting) and (Toggles.SkyBox.Value) then
		return NewIndex(Self, Index, Sky and Sky["Data"]["Atmos"]["Decay"] or Value)
	end

	if (Name == "Atmosphere") and (Method == "Color") and (Self.Parent == Fondra.Services.Lighting) and (Toggles.SkyBox.Value) then
		return NewIndex(Self, Index, Sky and Sky["Data"]["Atmos"]["Color"] or Value)
	end

	if (Name == "Atmosphere") and (Method == "Glare") and (Self.Parent == Fondra.Services.Lighting) and (Toggles.SkyBox.Value) then
		return NewIndex(Self, Index, Sky and Sky["Data"]["Atmos"]["Glare"] or Value)
	end

	if (Name == "Atmosphere") and (Method == "Haze") and (Self.Parent == Fondra.Services.Lighting) and (Toggles.SkyBox.Value) then
		return NewIndex(Self, Index, Sky and Sky["Data"]["Atmos"]["Haze"] or Value)
	end

	-- Viewmodel
	if (Name == "Left Arm") and (Method == "Color") and (Self.Parent == getgenv().ViewModel) and (Toggles.Viewmodel.Value) and Fondra.Functions.FP() then
		return NewIndex(Self, Index, Options.ViewmodelLArmColor.Value or Value)
	end

	if (Name == "Right Arm") and (Method == "Color") and (Self.Parent == getgenv().ViewModel) and (Toggles.Viewmodel.Value) and Fondra.Functions.FP() then
		return NewIndex(Self, Index, Options.ViewmodelRArmColor.Value or Value)
	end

	if (Name == "Left Arm") and (Method == "Transparency") and (Self.Parent == getgenv().ViewModel) and (Toggles.Viewmodel.Value) and Fondra.Functions.FP() then
		return NewIndex(Self, Index, Options.ViewmodelLArmTransparency.Value or Value)
	end

	if (Name == "Right Arm") and (Method == "Transparency") and (Self.Parent == getgenv().ViewModel) and (Toggles.Viewmodel.Value) and Fondra.Functions.FP() then
		return NewIndex(Self, Index, Options.ViewmodelRArmTransparency.Value or Value)
	end

	if (Name == "Left Arm" or Name == "Right Arm") and (Method == "Material") and (Self.Parent == getgenv().ViewModel) and (Toggles.Viewmodel.Value) and Fondra.Functions.FP() then
		return NewIndex(Self, Index, Enum.Material[Options.ViewmodelArmsMaterial.Value] or Value)
	end

    -- Character
    if (Name == "Humanoid") and (Method == "WalkSpeed") and (Self.Parent == Fondra.Client.Character) and (Toggles.WalkSpeed.Value) then
		return NewIndex(Self, Index, Options.WalkSpeed.Value or Value)
	end

    if (Name == "Humanoid") and (Method == "JumpPower") and (Self.Parent == Fondra.Client.Character) and (Toggles.JumpPower.Value) then
		return NewIndex(Self, Index, Options.JumpPower.Value or Value)
	end

	return NewIndex(Self, Index, Value)
end)

Fondra.Hooks.Namecall                                           = Namecall
Fondra.Hooks.NewIndex                                           = NewIndex
-- #EndRegion

-- #Region // Handler
do
    Fondra.Cooldowns.RageBot									= 0
	Fondra.Cooldowns.MeleeAura									= 0
    Fondra.Cooldowns.FakeLag                                    = 0
end

task.spawn(Fondra.Functions.LocalCharacter, Fondra.Client.Character)

Options.SelectedSkyBox:SetValues(Fondra.Functions.GetSkyBoxes())
Options.SelectedSkyBox:SetValue("Default")
Options.SelectedHitMarker:SetValues(Fondra.Functions.GetHitMarkers())
Options.SelectedHitMarker:SetValue("Default")

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
    if getgenv().FLagVisual then getgenv().FLagVisual:Destroy() end

    Fondra.Services.NetworkClient:SetOutgoingKBPSLimit(9e9)
end)

Toggles.FLagVisual:OnChanged(function(V)
    if not V then if getgenv().FLagVisual then getgenv().FLagVisual:Destroy() end return end

    local Model                                                 = Instance.new("Model")
    local Limbs                                                 = {
        ["Head"]                                                = Instance.new("Part"),
        ["Torso"]                                               = Instance.new("Part"),
        ["Left Arm"]                                            = Instance.new("Part"),
        ["Right Arm"]                                           = Instance.new("Part"),
        ["Left Leg"]                                            = Instance.new("Part"),
        ["Right Leg"]                                           = Instance.new("Part")
    }

    Limbs["Head"].Parent                                        = Model
    Limbs["Head"].Size                                          = Vector3.new(1, 1, 1)
    Limbs["Head"].Position                                      = Vector3.new(0, -0.45, 0)
    Limbs["Head"].CanCollide									= false
    Limbs["Head"].Anchored										= true

    Limbs["Torso"].Parent                                       = Model
    Limbs["Torso"].Size                                         = Vector3.new(2, 2, 1)
    Limbs["Torso"].Position                                     = Vector3.new(0, -2, 0)
    Limbs["Torso"].CanCollide									= false
    Limbs["Torso"].Anchored										= true

    Limbs["Left Arm"].Parent                                    = Model
    Limbs["Left Arm"].Size                                      = Vector3.new(1, 2, 1)
    Limbs["Left Arm"].Position                                  = Vector3.new(-1.55, -2, 0)
    Limbs["Left Arm"].CanCollide								= false
    Limbs["Left Arm"].Anchored									= true

    Limbs["Right Arm"].Parent                                   = Model
    Limbs["Right Arm"].Size                                     = Vector3.new(1, 2, 1)
    Limbs["Right Arm"].Position                                 = Vector3.new(1.55, -2, 0)
    Limbs["Right Arm"].CanCollide								= false
    Limbs["Right Arm"].Anchored									= true

    Limbs["Left Leg"].Parent                                    = Model
    Limbs["Left Leg"].Size                                      = Vector3.new(1, 2, 1)
    Limbs["Left Leg"].Position                                  = Vector3.new(-0.5, -4.05, 0)
    Limbs["Left Leg"].CanCollide								= false
    Limbs["Left Leg"].Anchored									= true

    Limbs["Right Leg"].Parent                                   = Model
    Limbs["Right Leg"].Size                                     = Vector3.new(1, 2, 1)
    Limbs["Right Leg"].Position                                 = Vector3.new(0.5, -4.05, 0)
    Limbs["Right Leg"].CanCollide								= false
    Limbs["Right Leg"].Anchored									= true

    for i, v in next, Limbs do
        v.Name 													= i
        v.Transparency											= 0.5
        v.Material 												= Enum.Material.ForceField
        v.Color													= Color3.fromRGB(0, 0, 255)

        local SpecialMesh 										= Instance.new("SpecialMesh")
        SpecialMesh.Parent										= v
        SpecialMesh.Scale										= v.Size
        SpecialMesh.MeshType									= Enum.MeshType.Brick
        SpecialMesh.TextureId									= "rbxassetid://2163189692"
        SpecialMesh.VertexColor									= Vector3.new(0, 0.45, 1)
    end

    Model.Name													= "FakeLagVisual"
    Model.Parent												= Fondra.Camera
    Model.PrimaryPart											= Limbs["Torso"]

    getgenv().FLagVisual                                        = Model
    
    if not Toggles.FLag.Value then return end

    getgenv().FLagVisual:SetPrimaryPartCFrame(Fondra.Client.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0.01, 0))
end)

Options.SpinSpeed:OnChanged(function(V)
    Fondra.Functions.SpinBot(Fondra.Client, Fondra.Client.Character)
end)

Fondra.Functions.NewConnection("Character Added", Fondra.Connections, Fondra.Client.CharacterAdded, Fondra.Functions.LocalCharacter)
Fondra.Functions.NewConnection("Mouse Move", Fondra.Connections, Fondra.Mouse.Move, function()
	local Data, Model                                           = Vars.Gun.Data, Vars.Gun.Model

    Fondra.Data.FOV.Position									= Fondra.Services.UserInputService:GetMouseLocation()
    Fondra.Data.FOV.Color                                       = Options.AccentColor.Value
    Fondra.Data.FOV.Radius                                      = Options.LegitBotRadius.Value
    Fondra.Data.FOV.Visible										= (Toggles.LegitBotFOV.Value and Toggles.LegitBot.Value and Data) and true or false
end)

Fondra.Functions.NewConnection("Main", Fondra.Connections, Fondra.Services.RunService.RenderStepped, function(Delta)
    task.spawn(Fondra.Functions.FlyController, Fondra.Client, Fondra.Client.Character)
    
	if Fondra.Functions.ValidCheck(Fondra.Client.Character) then
		task.spawn(Fondra.Functions.RageBot, Fondra.Client, Fondra.Client.Character)
		task.spawn(Fondra.Functions.MeleeAura, Fondra.Client, Fondra.Client.Character)

        task.spawn(Fondra.Functions.BHop, Fondra.Client, Fondra.Client.Character)
        task.spawn(Fondra.Functions.NoClip, Fondra.Client, Fondra.Client.Character)

        task.spawn(Fondra.Functions.FakeLag, Fondra.Client, Fondra.Client.Character)
        task.spawn(Fondra.Functions.TriggerBot, Fondra.Client, Fondra.Client.Character)
	end
end)

Library:Notify(string.format("Loaded Main.lua in %.4f MS", tick() - Fondra.Data.Start))
Library.SaveManager:LoadAutoloadConfig()
-- #EndRegion