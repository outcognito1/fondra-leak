if not Fondra then return end
if not Fondra.Loader then return end
if not Fondra.Loader.Identifier then return end

if not Toggles then return end
if not Toggles.FondraTelemetry then return end

local List 														= { Users = {}, Online = 0, Executions = 0 }
local Success, Socket 											= pcall(WebSocket.connect, string.format("wss://fondra.club/API/Telemetry/%s/%s", Fondra.Loader.Identifier, Fondra.Client.Name))

if not Success then return end
if not Socket then return end

local Handler 													= function(V)
	Socket:Send(tostring(V))

	if V then if not table.find(List.Users, Fondra.Client.Name) then table.insert(List.Users, Fondra.Client.Name) end end
	if not V then if table.find(List.Users, Fondra.Client.Name) then table.remove(List.Users, table.find(List.Users, Fondra.Client.Name)) end end

	getgenv().Telemetry											= List
end

Socket.OnMessage:Connect(function(Unparsed)
	local Parsed 												= Fondra.Services.HttpService:JSONDecode(Unparsed)
		
	if Parsed.Code == "AD-00" then
		-- Anti Disconnect
	end

	if Parsed.Code == "CS-00" then
		List.Executions											= Parsed.Executions
		List.Online												= Parsed.Active
		List.Users 												= Parsed.Clients
		List.Server 											= {}

		for Index, Player in next, Fondra.Services.Players:GetPlayers() do
			if not table.find(List.Users, Player.Name) then continue end

			table.insert(List.Server, Player.Name)
		end

		Fondra.UI["UsersInServer"]:SetText(string.format("Fondra Users in Server: %s", #List.Server))
		Fondra.UI["ActiveUsers"]:SetText(string.format("Active Fondra Users: %s", List.Online))
		Fondra.UI["TotalExecutions"]:SetText(string.format("Total Fondra Executions: %s", List.Executions))
	end

	if Parsed.Code == "NU-00" then
		List.Executions											= Parsed.Executions
		List.Online												= Parsed.Active

		if not table.find(List.Users, Parsed.Client) then table.insert(List.Users, Parsed.Client) end
	end

	if Parsed.Code == "RU-00" then
		List.Executions											= Parsed.Executions
		List.Online												= Parsed.Active

		if table.find(List.Users, Parsed.Client) then table.remove(List.Users, table.find(List.Users, Parsed.Client)) end
	end

	getgenv().Telemetry											= List
end)

Socket.OnClose:Connect(function(Unparsed)
	Library:Notify("Telemetry Disconnecting. [Telemetry wont work, Re-execute]")
end)

Toggles.FondraTelemetry:OnChanged(Handler)
Handler(Toggles.FondraTelemetry.Value)

Library:Notify(string.format("Loaded Telemetry.lua in %.4f MS", tick() - Fondra.Data.Start))