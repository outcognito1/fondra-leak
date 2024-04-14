for i, Part in next, game.Players.LocalPlayer.Character:GetDescendants() do
	for i, Connection in next, getconnections(Part.ChildAdded) do
		Connection:Disconnect()
	end

	for i, Connection in next, getconnections(Part.DescendantAdded) do
		Connection:Disconnect()
	end
end

for i, v in next, game:GetDescendants() do
	if not v:IsA("LocalScript") then continue end
	print(v.Name, v.Parent)
end