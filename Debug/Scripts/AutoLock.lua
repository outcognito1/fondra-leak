local BunkerLockers = {}
--
for Index, Locker in pairs(Bunker:GetDescendants()) do
	if Locker.Name == "BunkerLocker" then
		Insert(BunkerLockers, Locker)
	end
end

local function OpenClosestLocker()
	for Index, Locker in pairs(BunkerLockers) do
		if Locker:FindFirstChild("LootBase") then
			local Base = Locker:FindFirstChild("LootBase")
			--
			if Base and (Base.CFrame.Position - Fondra.Client.Character.HumanoidRootPart.Position).Magnitude < 8 then
				print("real near it?")

				local Arguments = {
					[1] = Locker,
					[2] = true
				}
				
				Fondra.Services.ReplicatedStorage:WaitForChild("Events"):WaitForChild("Loot"):WaitForChild("MinigameResult"):FireServer(table.unpack(Arguments))
			else
				print("not near")
			end
		end
	end
end


Fondra.Functions.ClearConnection("Lockpick", Fondra.Connections)
Fondra.Functions.NewConnection("Lockpick", Fondra.Connections, Fondra.Services.UserInputService.InputBegan, function(Input)
    if Input.UserInputType == Enum.UserInputType.Keyboard then
        if Input.KeyCode == Enum.KeyCode.Delete then
			OpenClosestLocker()
        end
    end
end)