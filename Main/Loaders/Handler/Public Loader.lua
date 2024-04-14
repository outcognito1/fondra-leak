repeat task.wait() until game:IsLoaded()

makefolder("Fondra")
makefolder("Fondra/Logs")
makefolder("Fondra/Assets")
makefolder("Fondra/Games")
makefolder("Fondra/Themes")

if ({...})[1] == nil then ({...})[1] = "Public" end
if ({...})[2] == nil then ({...})[2] = true end
if ({...})[3] == nil then ({...})[3] = "" end

if Fondra and Fondra.Functions.Unload then Fondra.Functions.Unload() end

getgenv().Fondra                        = {}
Fondra.UI                               = {}
Fondra.Cooldowns                        = {}

Fondra.Functions                        = {}
Fondra.Connections                      = {}
Fondra.Hooks                            = {}

Fondra.Data                             = { Start = tick(), Game = "" }
Fondra.Loader                           = { Version = ({...})[1], Greeting = false, Identifier = ({...})[3] }

Fondra.Services                         = setmetatable({}, {
    __index = function(Self, Key)
        return game.GetService(game, Key)
    end
})

Fondra.Client                           = Fondra.Services.Players.LocalPlayer
Fondra.Camera                           = Fondra.Services.Workspace.CurrentCamera
Fondra.Mouse                            = Fondra.Client.GetMouse(Fondra.Client)
Fondra.Random                           = Random.new()
Fondra.Method                           = request

Fondra.Functions.SecureGet              = function(Link, Custom)
    local Success, Result               = pcall(Fondra.Method, Custom or {
        Url                             = Link,
        Method                          = "GET"
    })

    if not Success then writefile("Fondra/Logs/Fondra-[" .. os.time() .. "]-.log", Result) return game:Shutdown() end
    if not typeof(Result) == "table" then writefile("Fondra/Logs/Fondra-[" .. os.time() .. "]-.log", Result) return game:Shutdown() end
    
    return Result.Body
end

Fondra.Functions.DownloadAsset          = function(Path, Link)
    local Path                          = string.format("Fondra/Assets/%s", Path)
    local Directorys 				    = {}

    Path:gsub("([^/]+)", function(Directory)
        table.insert(Directorys, Directory)
    end)

    table.remove(Directorys, #Directorys)
    
    for _, Directory in next, Directorys do
        local Directory                 = table.concat(Directorys, "/", 1, _)

        if isfolder(Directory) then continue end

        makefolder(Directory)
    end

    if (not isfile(Path)) then
        writefile(Path, Fondra.Functions.SecureGet(Link))
    end

    return true
end

Fondra.Functions.GetAsset               = function(Path)
    if not isfile(string.format("Fondra/Assets/%s", Path)) then return "rbxassetid://0" end

    return getcustomasset(string.format("Fondra/Assets/%s", Path))
end

Fondra.Functions.ClearHooks             = function(Table)
    local MT                            = getrawmetatable(game)

    setreadonly(MT, false)

    if Table.NewIndex then MT.__newindex = Table.NewIndex end
    if Table.Namecall then MT.__namecall = Table.Namecall end
    if Table.Index then MT.__index = Table.Index end

    setreadonly(MT, true)
end

Fondra.Functions.ClearConnections 		= function(Table)
	for Name, Connection in next, Table do
        Fondra.Functions.ClearConnection(Name, Table)
	end
end

Fondra.Functions.ClearConnection 		= function(Name, Table)
	if Table[Name] then
		Table[Name]:Disconnect()
		Table[Name] = nil

		return true
	end

	return false
end

Fondra.Functions.NewConnection		    = function(Name, Table, Type, Callback)
    local Connection 					= Type:Connect(Callback)

    Table[Name]                         = Connection

	return Connection
end

local Init                              = function()
    local MessageBox                    = Fondra.Functions.SecureGet("https://raw.githubusercontent.com/lncoognito/Linoria/main/MessageBox.lua")
    local Greeting                      = Fondra.Functions.SecureGet("https://raw.githubusercontent.com/Fondra-Hub/Assets/main/Greeting.lua")
    local HTTP                          = Fondra.Functions.SecureGet(string.format("https://astolfo.host/p/raw/y4uxf8v8ag"))

    local Success, Function             = pcall(loadstring, MessageBox)
	local Success, Decoded 			    = pcall(Fondra.Services.HttpService.JSONDecode, Fondra.Services.HttpService, HTTP)

    local MessageBox                    = Function()

    if not Success then
        return MessageBox.Show({
            Text                        = "Fondra",
            Description                 = "The host is currently down.\nPlease try again later.\nJoin the Discord for more information.",
            MessageBoxIcon              = "Error",
            MessageBoxButtons           = "OK",
            Position                    = UDim2.fromScale(0.5, 0.5)
        })
    end

   

    if (os.time() - Decoded.GameLast) > 2592000 then
        return MessageBox.Show({
            Text                        = "Fondra",
            Description                 = string.format("Game Detected: %s\n\nThis game has not received updates or reviews for over a month, which suggests existing ones could be malfunctioning.\nDo you wish to proceed?", Decoded.GameName),
            MessageBoxIcon              = "Question",
            MessageBoxButtons           = "YesNo",
            Position                    = UDim2.fromScale(0.5, 0.5),

            Result                      = function(Response)
                if Response ~= "Yes" then return end

                if Decoded.UI then loadstring(Decoded.UI)() end
                if Decoded.Visual then loadstring(Decoded.Visual)() end
                if Decoded.Main then loadstring(Decoded.Main)() end
    
                if getgenv().Blacklisted then return end
    
                if Decoded.Telemetry then loadstring(Decoded.Telemetry)() end
                if Fondra.Loader.Greeting then loadstring(Greeting)() end
            end
        })
    end

    return MessageBox.Show({
        Text                            = "Fondra",
        Description                     = string.format("Game Detected: %s\nWould you like to proceed?", Decoded.GameName),
        MessageBoxIcon                  = "Question",
        MessageBoxButtons               = "YesNo",
        Position                        = UDim2.fromScale(0.5, 0.5),

        Result                          = function(Response)
            if Response ~= "Yes" then return end

            if Decoded.UI then loadstring(Decoded.UI)() end
            if Decoded.Visual then loadstring(Decoded.Visual)() end
            if Decoded.Main then loadstring(Decoded.Main)() end

            if getgenv().Blacklisted then return end

            if Decoded.Telemetry then loadstring(Decoded.Telemetry)() end
            if Fondra.Loader.Greeting then loadstring(Greeting)() end
        end
    })
end

Init()