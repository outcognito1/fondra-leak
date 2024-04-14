--[[
    made by funeral 
    funerals1337 / 379265183496798209 / github.com/funerals1337
    credits to yukino for framework ideas
    credits to matas for thread optimisations & metatable ideas
    feel free to use
    -- NOTE:
    NOT SURE IF THIS VERSION WORKS, IF IT DOESNT FEEL FREE TO CONTACT ME

    updated.
]]

-- // Tables
local cheat_client = {
    esp = {
        base = {},
        bases = {},
        player = {
            enabled = true,
            distance_limit = 3000,    

            box = true,
            name = true,
            health = true,
            weapon = true,
            status = true
        }
    },
    shared = {
        window_focused = true
    },
    renders = {},
    connections = {}
}

-- // Services
local userinputservice = game:GetService("UserInputService")
local runservice = game:GetService("RunService") 
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")

--// Variables
local round, floor = math.round, math.round
local remove, clear, find = table.remove, table.clear, table.find
local wait = task.wait
local resume, create = coroutine.resume, coroutine.create
local newdrawing, newvector2, newvector3, newrgb = Drawing.new, Vector2.new, Vector3.new, Color3.fromRGB

--// Locals
local local_player = players.LocalPlayer
local camera = workspace.CurrentCamera

--// Functions
do
    function cheat_client:handle_connection(connection, callback)
        local proxy = {
            connection = connection:Connect(callback)
        }

        function proxy:disconnect()
            self.connection:Disconnect()
            remove(cheat_client.connections, find(cheat_client.connections, proxy))
        end

        self.connections[#self.connections + 1] = proxy
        return proxy
    end

    function cheat_client:handle_function(func, name, ...)
        local func = name and function()
            local pass, error = pcall(func)
            --
            if not pass then
                warn("funeral haxx\n", "              " .. name .. " - ", error)
            end
        end or func
        local thread = create(func)
        --
        resume(thread, ...)
        return thread
    end

    function cheat_client:handle_render(type, properties)
        local render = newdrawing(type)

        for i, v in next, properties do
            render[i] = v
        end
        
        self.renders[#self.renders + 1] = render
        return render
    end

    function cheat_client:unload()
        for _, connection in next, self.connections do
            connection:disconnect()
        end
        
        for _, base in next, self.esp.bases do
            base:remove()
        end
    end

    function cheat_client:get_character(player)
        return player.Character
    end

    function cheat_client:get_humanoid(character)
        return character:FindFirstChildOfClass("Humanoid")
    end

    function cheat_client:get_rootpart(humanoid)
        return humanoid.RootPart
    end

    function cheat_client:get_parts(player)
        local character = cheat_client:get_character(player)
        local humanoid = (character and cheat_client:get_humanoid(character))
        local rootpart = (humanoid and cheat_client:get_rootpart(humanoid))

        return character, humanoid, rootpart
    end

    function cheat_client:can_render()
        return self.esp.player.enabled and self.shared.window_focused
    end

    -- // ESP
    do
        function cheat_client:render_on_player(player)
            local esp = setmetatable({
                player = player,
                renders = {
                    name = cheat_client:handle_render("Text", {ZIndex = 5, Text = player.Name, Visible = false, Size = 13, Center = true, Color = newrgb(255, 255, 255), Outline = true, OutlineColor = newrgb(0, 0, 0), Font = Drawing.Fonts.Plex, Transparency = 1}),
                    weapon = cheat_client:handle_render("Text", {ZIndex = 5, Visible = false, Size = 13, Center = true, Color = newrgb(255, 255, 255), Outline = true, OutlineColor = newrgb(0, 0, 0), Font = Drawing.Fonts.Plex, Transparency = 1}),
                    status = cheat_client:handle_render("Text", {ZIndex = 5, Visible = false, Size = 13, Color = newrgb(255, 255, 255), Outline = true, OutlineColor = newrgb(0, 0, 0), Font = Drawing.Fonts.Plex, Transparency = 1}),
                    box = cheat_client:handle_render("Square", {ZIndex = 5, Thickness = 1, Visible = false, Filled = false, Color = newrgb(38, 104, 245), Transparency = 1}),
                    box_outline = cheat_client:handle_render("Square", {ZIndex = 1, Thickness = 3, Visible = false, Filled = false, Color = newrgb(0, 0, 0), Transparency = 1}),
                    health = cheat_client:handle_render("Square", {ZIndex = 5, Thickness = 1, Visible = false, Filled = true, Color = newrgb(0, 255, 0), Transparency = 1}),
                    health_outline = cheat_client:handle_render("Square", {ZIndex = 1, Thickness = 1, Visible = false, Filled = true, Color = newrgb(0, 0, 0), Transparency = 1})
                }
            }, {__index = cheat_client.esp.base})

            cheat_client.esp.bases[esp.player] = esp
            return esp
        end

        -- add cheat_client.esp.base functions -- done

        function cheat_client.esp.base:remove()
            for _, render in next, rawget(self, "renders") do
                render:Remove()
                remove(cheat_client.renders, find(cheat_client.renders, render))
            end
        end

        function cheat_client.esp.base:set(bool)
            for _, render in next, rawget(self, "renders") do
                if render.Visible ~= bool then
                    render.Visible = bool
                end
            end
        end

        function cheat_client.esp.base:update()
            if cheat_client:can_render() then
                local player = rawget(self, "player")
                if player then
                    local character, humanoid, rootpart = cheat_client:get_parts(player)

                    if character and humanoid and rootpart then
                        local root_position = rootpart.Position
                        local screen_position, screen_visible = camera:WorldToViewportPoint(root_position)

                        if screen_visible then
                            local magnitude = round((camera.CFrame.Position - root_position).Magnitude)

                            if magnitude <= cheat_client.esp.player.distance_limit then
                                local plrhealth, plrmaxhealth = humanoid.Health, humanoid.MaxHealth

                                if plrhealth > 0 then
                                    local size = (camera:WorldToViewportPoint(root_position - newvector3(0, 3, 0)).Y - camera:WorldToViewportPoint(root_position + newvector3(0, 2.6, 0)).Y) / 2
                                    local box_size = newvector2(floor(size * 1.5), floor(size * 1.9))
                                    local box_position = newvector2(floor(screen_position.X - size * 1.5 / 2), floor(screen_position.Y - size * 1.6 / 2))

                                    if box_size and box_position then
                                        local renders = rawget(self, "renders")
                                        do -- name
                                            if cheat_client.esp.player.name then
                                                name = renders.name
                                                name.Text = player.Name
                                                name.Position = box_position + newvector2(box_size.X / 2, -17)
                                                name.Visible = true
                                            end
                                        end

                                        do -- boxes
                                            if cheat_client.esp.player.box then
                                                box = renders.box
                                                box.Size = box_size
                                                box.Position = box_position
                                                box.Visible = true
                                                
                                                box_outline = renders.box_outline
                                                box_outline.Size = box_size
                                                box_outline.Position = box_position
                                                box_outline.Visible = true
                                            end
                                        end

                                        do -- health
                                            if cheat_client.esp.player.box then
                                                health = renders.health
                                                health_size = floor(box_size.Y * (plrhealth / plrmaxhealth))
                                                health.Size = newvector2(2, health_size)
                                                health.Position = newvector2(box_position.X - 5, ((box_position.Y + box_size.Y) - health_size))
                                                health.Color = newrgb(255, 0, 0):Lerp(newrgb(0, 255, 0), plrhealth / plrmaxhealth)
                                                health.Visible = true

                                                health_outline = renders.health_outline
                                                health_outline.Size = newvector2(4, box_size.Y + 2)
                                                health_outline.Position = newvector2(box_position.X - 6, box_position.Y - 1)
                                                health_outline.Visible = true
                                            end
                                        end

                                        do -- weapon
                                            if cheat_client.esp.player.weapon then
                                                if character:FindFirstChildOfClass("RayValue") then
                                                    weapon = renders.weapon
                                                    weapon.Text = tostring(character:FindFirstChildOfClass("RayValue"))
                                                    weapon.Position = box_position + newvector2(box_size.X / 2, (box_size.Y + 2))
                                                    weapon.Visible = true
                                                else
                                                    renders.weapon.Visible = false
                                                end
                                            end
                                        end

                                        do -- status
                                            if cheat_client.esp.player.status then
                                                status = renders.status
                                                status_string = ""

                                                if character:FindFirstChildOfClass("ForceField") then
                                                    status_string ..= "[FF]\n"
                                                end

                                                if plrhealth <= 15 then
                                                    status_string ..= "[DW]"
                                                end

                                                status.Text = status_string
                                                status.Position = newvector2(box_size.X + box_position.X + 1, box_position.Y - 2)
                                                status.Visible = true
                                            end
                                        end
                                        return
                                    end
                                end
                            end
                        end
                    end
                    return self:set(false)
                end
                return self:remove()
            end
            return self:set(false)
        end
    end
end

--// Initialize

cheat_client:handle_connection(runservice.RenderStepped, function()
    for _, base in next, cheat_client.esp.bases do
        cheat_client:handle_function(function() 
            base:update()
        end, "esp")
    end
end)

cheat_client:handle_connection(userinputservice.InputBegan, function(input, processed)
    if input.KeyCode == Enum.KeyCode.Delete then
        cheat_client:unload()
    end
end)

cheat_client:handle_connection(userinputservice.WindowFocused, function() 
    cheat_client.shared.window_focused = true
end)

cheat_client:handle_connection(userinputservice.WindowFocusReleased, function() 
    cheat_client.shared.window_focused = false
end)

cheat_client:handle_connection(players.PlayerAdded, function(player) 
    cheat_client:render_on_player(player)
end)

for _, player in next, players:GetPlayers() do
    if player ~= local_player then
        cheat_client:render_on_player(player)
    end
end