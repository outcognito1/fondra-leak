-- // Clear
if Fondra.Functions.CleanUp then Fondra.Functions.CleanUp() end

local Repository												= "https://raw.githubusercontent.com/lncoognito/Linoria/main/"

local Library 													= loadstring(Fondra.Functions.SecureGet(Repository .. "Library.lua"))()
local ThemeManager 												= loadstring(Fondra.Functions.SecureGet(Repository .. "Addons/ThemeManager.lua"))()
local SaveManager 												= loadstring(Fondra.Functions.SecureGet(Repository .. "Addons/SaveManager.lua"))()

do
    Fondra.Data.FOV                                             = Drawing.new("Circle")
    Fondra.Data.FOV.Radius                                      = 30
    Fondra.Data.FOV.Visible                                     = false
    Fondra.Data.FOV.Thickness                                   = 2
end

local Window 													= Library:CreateWindow({
    Title 														= "Fondra - V4",
    Center 														= true,
    AutoShow 													= true,
    TabPadding 													= 1,
    MenuFadeTime 												= 0.1
})

local Main 													    = Window:AddTab("Main") do
	local RageBot 												= Main:AddLeftGroupbox("RageBot") do
        RageBot:AddToggle("RageBot", {
            Text                = "Enabled",
            Default             = false
        }):AddKeyPicker("RageBotKey", {
            Default 			= "Esc",
            SyncToggleState 	= true,
            Mode 				= "Toggle",
        
            Text 				= "Rage Bot",
            NoUI 				= false
        })

        RageBot:AddToggle("RageBotFriendly", {
            Text                = "Friendly Check",
            Default             = false
        })
        
        RageBot:AddToggle("RageBotDowned", {
            Text                = "Downed Check",
            Default             = false
        })    

        RageBot:AddDivider()

        RageBot:AddDropdown("RageBotMode", {
            Values              = {"Auto", "Hold"},
            Default             = 1,
            Multi               = false,
            AllowNull           = false,
            Text                = "Mode"
        })

        RageBot:AddDropdown("RageBotParts", {
            Values              = {"Head", "Right Arm", "Left Arm", "Right Leg", "Left Leg"}, 
            Default             = 1,
            Multi               = true,
            AllowNull           = false,
            Text                = "Hit Parts"
        })

        RageBot:AddSlider("RageBotDistance", {
            Text                = "Distance",
            Min                 = 0,
            Max                 = 2000,
            Default             = 500,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " Meters",
        })
	end

	local LegitBot 											    = Main:AddRightGroupbox("LegitBot") do
        LegitBot:AddToggle("LegitBot", {
            Text                = "Enabled",
            Default             = false
        }):AddKeyPicker("LegitBotKey", {
            Default 			= "Esc",
            SyncToggleState 	= true,
            Mode 				= "Toggle",
        
            Text 				= "Legit Bot",
            NoUI 				= false
        })

        LegitBot:AddToggle("LegitBotFriendly", {
            Text                = "Friendly Check",
            Default             = false
        })
        
        LegitBot:AddToggle("LegitBotDowned", {
            Text                = "Downed Check",
            Default             = false
        })

        LegitBot:AddToggle("LegitBotFOV", {
            Text                = "Show FOV",
            Default             = false
        })

        LegitBot:AddDivider()

        LegitBot:AddDropdown("LegitBotParts", {
            Values              = {"Head", "Torso", "Right Arm", "Left Arm", "Right Leg", "Left Leg"}, 
            Default             = 1,
            Multi               = true,
            AllowNull           = false,
            Text                = "Hit Parts"
        })

        LegitBot:AddSlider("LegitBotRadius", {
            Text                = "Radius",
            Min                 = 0,
            Max                 = 500,
            Default             = 100,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " PX",
        })

        LegitBot:AddSlider("LegitBotDistance", {
            Text                = "Distance",
            Min                 = 0,
            Max                 = 2000,
            Default             = 500,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " Meters",
        })

        LegitBot:AddSlider("LegitBotHitChance", {
            Text                = "Hit Chance",
            Min                 = 0,
            Max                 = 100,
            Default             = 100,
            Rounding            = 0,
            Compact             = true,
            Suffix              = "%",
        })
	end

    local MeleeAura 										    = Main:AddLeftGroupbox("Melee Aura") do
        MeleeAura:AddToggle("MeleeAura", {
            Text                = "Enabled",
            Default             = false
        })

        MeleeAura:AddToggle("MeleeAuraFriendly", {
            Text                = "Friendly Check",
            Default             = false
        })
        
        MeleeAura:AddToggle("MeleeAuraDowned", {
            Text                = "Downed Check",
            Default             = false
        })

        MeleeAura:AddDivider()

        MeleeAura:AddDropdown("MeleeAuraParts", {
            Values              = {"Head", "Torso", "Right Arm", "Left Arm", "Right Leg", "Left Leg"}, 
            Default             = 1,
            Multi               = true,
            AllowNull           = false,
            Text                = "Hit Parts"
        })

        MeleeAura:AddSlider("MeleeAuraDistance", {
            Text                = "Distance",
            Min                 = 0,
            Max                 = 15,
            Default             = 15,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " Meters",
        })
	end

    local TriggerBot 												= Main:AddRightGroupbox("TriggerBot") do
        TriggerBot:AddToggle("TriggerBot", {
            Text                = "Enabled",
            Default             = false
        }):AddKeyPicker("TriggerBotKey", {
            Default 			= "Esc",
            SyncToggleState 	= true,
            Mode 				= "Toggle",
        
            Text 				= "Trigger Bot",
            NoUI 				= false
        })

        TriggerBot:AddToggle("TriggerBotFriendly", {
            Text                = "Friendly Check",
            Default             = false
        })
        
        TriggerBot:AddToggle("TriggerBotDowned", {
            Text                = "Downed Check",
            Default             = false
        })

        TriggerBot:AddDivider()

        TriggerBot:AddDropdown("TriggerBotParts", {
            Values              = {"Head", "Torso", "Right Arm", "Left Arm", "Right Leg", "Left Leg"}, 
            Default             = 1,
            Multi               = true,
            AllowNull           = false,
            Text                = "Hit Parts"
        })

        TriggerBot:AddSlider("TriggerBotDelay", {
            Text                = "Shoot Delay",
            Min                 = 0,
            Max                 = 1000,
            Default             = 50,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " MS",
        })

        TriggerBot:AddSlider("TriggerBotDelayBS", {
            Text                = "Delay Between Shots",
            Min                 = 0,
            Max                 = 100,
            Default             = 50,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " MS",
        })

        TriggerBot:AddSlider("TriggerBotDistance", {
            Text                = "Distance",
            Min                 = 0,
            Max                 = 2000,
            Default             = 500,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " Meters",
        })

        TriggerBot:AddSlider("TriggerBotShootChance", {
            Text                = "Shoot Chance",
            Min                 = 0,
            Max                 = 100,
            Default             = 100,
            Rounding            = 0,
            Compact             = true,
            Suffix              = "%",
        })
	end
end

local Visual 													= Window:AddTab("Visual") do
	local Player 												= Visual:AddLeftGroupbox("Player") do
        Player:AddToggle("PlayerV", {
            Text                = "Enabled",
            Default             = false
        })

        Player:AddToggle("PlayerVBox", {
            Text                = "Box",
            Default             = false
        }):AddColorPicker("PlayerBC", { 
            Title               = "Box",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("PlayerBOC", { 
            Title               = "Box Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })

        Player:AddToggle("PlayerVHealthBar", {
            Text                = "Health Bar",
            Default             = false
        }):AddColorPicker("PlayerHBLC", { 
            Title               = "Health Low",
            Default             = Color3.fromRGB(255, 92, 51)
        }):AddColorPicker("PlayerHBFC", { 
            Title               = "Health Full",
            Default             = Color3.fromRGB(0, 255, 157)
        })

        Player:AddToggle("PlayerVNameText", {
            Text                = "Name Text",
            Default             = false
        }):AddColorPicker("PlayerNTC", { 
            Title               = "Text",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("PlayerNTOC", { 
            Title               = "Text Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })

        Player:AddToggle("PlayerVToolText", {
            Text                = "Tool Text",
            Default             = false
        }):AddColorPicker("PlayerTTC", { 
            Title               = "Text",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("PlayerTTOC", { 
            Title               = "Text Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })

        Player:AddToggle("PlayerVHealthText", {
            Text                = "Health Text",
            Default             = false
        }):AddColorPicker("PlayerHTC", { 
            Title               = "Text",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("PlayerHTOC", { 
            Title               = "Text Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })

        Player:AddToggle("PlayerVDistanceText", {
            Text                = "Distance Text",
            Default             = false
        }):AddColorPicker("PlayerDTC", { 
            Title               = "Text",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("PlayerDTOC", { 
            Title               = "Text Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })

        Player:AddToggle("PlayerVTelemetryText", {
            Text                = "Telemetry Text",
            Default             = false
        }):AddColorPicker("PlayerWTC", { 
            Title               = "Text",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("PlayerWTOC", { 
            Title               = "Text Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })
        
        Player:AddDivider()

        Player:AddSlider("PlayerVOBT", {
            Text                = "Overlay Box Transparency",
            Min                 = 0,
            Max                 = 1,
            Default             = 0.4,
            Rounding            = 2,
            Compact             = true,
            Suffix              = "",
        })

        Player:AddSlider("PlayerVUpdateRate", {
            Text                = "Update Rate",
            Min                 = 0,
            Max                 = 500,
            Default             = 150,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " MS",
        })

        Player:AddSlider("PlayerVFont", {
            Text                = "Font",
            Min                 = 0,
            Max                 = 3,
            Default             = 1,
            Rounding            = 0,
            Compact             = true,
            Suffix              = "",
        })

        Player:AddSlider("PlayerVMaxDistance", {
            Text                = "Distance",
            Min                 = 0,
            Max                 = 2000,
            Default             = 500,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " Meters",
        })
    end

	local Dealer 												= Visual:AddRightGroupbox("Dealer") do
        Dealer:AddToggle("DealerV", {
            Text                = "Enabled",
            Default             = false
        })

        Dealer:AddToggle("DealerVBox", {
            Text                = "Box",
            Default             = false
        }):AddColorPicker("DealerBC", { 
            Title               = "Box",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("DealerBOC", { 
            Title               = "Box Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })
        
        Dealer:AddToggle("DealerVTypeText", {
            Text                = "Type Text",
            Default             = false
        }):AddColorPicker("DealerTTC", { 
            Title               = "Text",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("DealerTTOC", { 
            Title               = "Text Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })

        Dealer:AddToggle("DealerVDistanceText", {
            Text                = "Distance Text",
            Default             = false
        }):AddColorPicker("DealerDTC", { 
            Title               = "Text",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("DealerDTOC", { 
            Title               = "Text Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })

        Dealer:AddDivider()

        Dealer:AddSlider("DealerVOBT", {
            Text                = "Overlay Box Transparency",
            Min                 = 0,
            Max                 = 1,
            Default             = 0.4,
            Rounding            = 2,
            Compact             = true,
            Suffix              = "",
        })

        Dealer:AddSlider("DealerVUpdateRate", {
            Text                = "Update Rate",
            Min                 = 0,
            Max                 = 500,
            Default             = 150,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " MS",
        })

        Dealer:AddSlider("DealerVFont", {
            Text                = "Font",
            Min                 = 0,
            Max                 = 3,
            Default             = 1,
            Rounding            = 0,
            Compact             = true,
            Suffix              = "",
        })

        Dealer:AddSlider("DealerVMaxDistance", {
            Text                = "Distance",
            Min                 = 0,
            Max                 = 2000,
            Default             = 500,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " Meters",
        })
    end

	local Register 												= Visual:AddLeftGroupbox("Register") do
        Register:AddToggle("RegisterV", {
            Text                = "Enabled",
            Default             = false
        })

        Register:AddToggle("RegisterVBox", {
            Text                = "Box",
            Default             = false
        }):AddColorPicker("RegisterBC", { 
            Title               = "Box",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("RegisterBOC", { 
            Title               = "Box Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })

        Register:AddToggle("RegisterVTypeText", {
            Text                = "Type Text",
            Default             = false
        }):AddColorPicker("RegisterTTC", { 
            Title               = "Text",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("RegisterTTOC", { 
            Title               = "Text Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })
        
        Register:AddToggle("RegisterVStatusText", {
            Text                = "Status Text",
            Default             = false
        }):AddColorPicker("RegisterSTC", { 
            Title               = "Text",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("RegisterSTOC", { 
            Title               = "Text Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })

        Register:AddToggle("RegisterVDistanceText", {
            Text                = "Distance Text",
            Default             = false
        }):AddColorPicker("RegisterDTC", { 
            Title               = "Text",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("RegisterDTOC", { 
            Title               = "Text Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })

        Register:AddToggle("RegisterVBrokenCheck", {
            Text                = "Broken Check",
            Default             = false
        })

        Register:AddDivider()

        Register:AddSlider("RegisterVOBT", {
            Text                = "Overlay Box Transparency",
            Min                 = 0,
            Max                 = 1,
            Default             = 0.4,
            Rounding            = 2,
            Compact             = true,
            Suffix              = "",
        })

        Register:AddSlider("RegisterVUpdateRate", {
            Text                = "Update Rate",
            Min                 = 0,
            Max                 = 500,
            Default             = 150,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " MS",
        })

        Register:AddSlider("RegisterVFont", {
            Text                = "Font",
            Min                 = 0,
            Max                 = 3,
            Default             = 1,
            Rounding            = 0,
            Compact             = true,
            Suffix              = "",
        })

        Register:AddSlider("RegisterVMaxDistance", {
            Text                = "Distance",
            Min                 = 0,
            Max                 = 1000,
            Default             = 500,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " Meters",
        })
    end

	local Safe 													= Visual:AddRightGroupbox("Safe") do
        Safe:AddToggle("SafeV", {
            Text                = "Enabled",
            Default             = false
        })

        Safe:AddToggle("SafeVBox", {
            Text                = "Box",
            Default             = false
        }):AddColorPicker("SafeBC", { 
            Title               = "Box",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("SafeBOC", { 
            Title               = "Box Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })

        Safe:AddToggle("SafeVTypeText", {
            Text                = "Type Text",
            Default             = false
        }):AddColorPicker("SafeTTC", { 
            Title               = "Text",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("SafeTTOC", { 
            Title               = "Text Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })

        Safe:AddToggle("SafeVStatusText", {
            Text                = "Status Text",
            Default             = false
        }):AddColorPicker("SafeSTC", { 
            Title               = "Text",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("SafeSTOC", { 
            Title               = "Text Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })

        Safe:AddToggle("SafeVDistanceText", {
            Text                = "Distance Text",
            Default             = false
        }):AddColorPicker("SafeDTC", { 
            Title               = "Text",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("SafeDTOC", { 
            Title               = "Text Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })

        Safe:AddToggle("SafeVBrokenCheck", {
            Text                = "Broken Check",
            Default             = false
        })

        Safe:AddDivider()

        Safe:AddSlider("SafeVOBT", {
            Text                = "Overlay Box Transparency",
            Min                 = 0,
            Max                 = 1,
            Default             = 0.4,
            Rounding            = 2,
            Compact             = true,
            Suffix              = "",
        })

        Safe:AddSlider("SafeVUpdateRate", {
            Text                = "Update Rate",
            Min                 = 0,
            Max                 = 500,
            Default             = 150,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " MS",
        })

        Safe:AddSlider("SafeVFont", {
            Text                = "Font",
            Min                 = 0,
            Max                 = 3,
            Default             = 1,
            Rounding            = 0,
            Compact             = true,
            Suffix              = "",
        })

        Safe:AddSlider("SafeVMaxDistance", {
            Text                = "Distance",
            Min                 = 0,
            Max                 = 1000,
            Default             = 500,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " Meters",
        })
    end

    local World 												= Visual:AddLeftGroupbox("World") do
        World:AddToggle("Ambience", {
            Text                = "Ambience",
            Default             = false
        }):AddColorPicker("AmbienceColor1", {
            Default             = Color3.fromRGB(0, 99, 228),
            Title               = "Ambience 1",
        }):AddColorPicker("AmbienceColor2", {
            Default             = Color3.fromRGB(0, 99, 228),
            Title               = "Ambience 2",
        })

        World:AddToggle("Shift", {
            Text                = "Color Shift",
            Default             = false
        }):AddColorPicker("ShiftColor1", {
            Default             = Color3.fromRGB(0, 99, 228),
            Title               = "Shift Color 1",
        }):AddColorPicker("ShiftColor2", {
            Default             = Color3.fromRGB(0, 99, 228),
            Title               = "Shift Color 2",
        })

        World:AddToggle("SkyBox", {
            Text                = "Sky Box",
            Default             = false
        })

        World:AddToggle("ShadowMap", {
            Text                = "Shadow Map",
            Default             = true
        })

        World:AddToggle("ForceTime", {
            Text                = "Force Time",
            Default             = false
        })

        World:AddToggle("ForceLatitude", {
            Text                = "Force Latitude",
            Default             = false
        })

        World:AddToggle("ForceDiffuse", {
            Text                = "Force Diffuse",
            Default             = false
        })

        World:AddDivider()

        World:AddDropdown("SelectedSkyBox", {
            Values              = {"Default"}, 
            Default             = 0,
            Multi               = false,
            Text                = "Sky Box"
        })

        World:AddButton({
            Text                = "Refresh List",
            DoubleClick         = false,
            Func                = function()
                Options.SelectedSkyBox:SetValues(Fondra.Functions.GetSkyBoxes())
                Options.SelectedSkyBox:SetValue("Default")
            end
        })

        World:AddDivider()

        World:AddSlider("SelectedTime", {
            Text                = "Time",
            Min                 = 0,
            Max                 = 24,
            Default             = 12,
            Rounding            = 2,
            Compact             = true,
            Suffix              = "",
        })

        World:AddSlider("SelectedLatitude", {
            Text                = "Latitude",
            Min                 = -90,
            Max                 = 90,
            Default             = 0,
            Rounding            = 2,
            Compact             = true,
            Suffix              = "",
        })

        World:AddSlider("SelectedDiffuse", {
            Text                = "Diffuse",
            Min                 = 0,
            Max                 = 1,
            Default             = 0,
            Rounding            = 2,
            Compact             = true,
            Suffix              = "",
        })
    end

    local Viewmodel 											= Visual:AddRightGroupbox("Viewmodel") do
        Viewmodel:AddToggle("Viewmodel", {
            Text                = "Enabled",
            Default             = false
        }):AddColorPicker("ViewmodelToolColor", {
            Default             = Color3.fromRGB(0, 99, 228),
            Title               = "Tools Color",
        }):AddColorPicker("ViewmodelRArmColor", {
            Default             = Color3.fromRGB(0, 99, 228),
            Title               = "Right Arm Color",
        }):AddColorPicker("ViewmodelLArmColor", {
            Default             = Color3.fromRGB(0, 99, 228),
            Title               = "Left Arm Color",
        })

        Viewmodel:AddDivider()

        Viewmodel:AddSlider("ViewmodelToolTransparency", {
            Text                = "Tool Transparency",
            Min                 = 0,
            Max                 = 1,
            Default             = 0,
            Rounding            = 2,
            Compact             = true,
            Suffix              = "",
        })

        Viewmodel:AddSlider("ViewmodelRArmTransparency", {
            Text                = "Right Arm Transparency",
            Min                 = 0,
            Max                 = 1,
            Default             = 0,
            Rounding            = 2,
            Compact             = true,
            Suffix              = "",
        })

        Viewmodel:AddSlider("ViewmodelLArmTransparency", {
            Text                = "Left Arm Transparency",
            Min                 = 0,
            Max                 = 1,
            Default             = 0,
            Rounding            = 2,
            Compact             = true,
            Suffix              = "",
        })

        Viewmodel:AddDivider()

        Viewmodel:AddSlider("ViewmodelXOffset", {
            Text                = "X Offset",
            Min                 = -25,
            Max                 = 25,
            Default             = 0,
            Rounding            = 2,
            Compact             = true,
            Suffix              = "",
        })

        Viewmodel:AddSlider("ViewmodelYOffset", {
            Text                = "Y Offset",
            Min                 = -25,
            Max                 = 25,
            Default             = 0,
            Rounding            = 2,
            Compact             = true,
            Suffix              = "",
        })

        Viewmodel:AddSlider("ViewmodelZOffset", {
            Text                = "Z Offset",
            Min                 = -25,
            Max                 = 25,
            Default             = 0,
            Rounding            = 2,
            Compact             = true,
            Suffix              = "",
        })

        Viewmodel:AddDivider()
 
        Viewmodel:AddDropdown("ViewmodelArmsMaterial", {
            Values              = {"SmoothPlastic", "ForceField"}, 
            Default             = 1,
            Multi               = false,
            Text                = "Arms Material"
        })

        Viewmodel:AddDropdown("ViewmodelToolsMaterial", {
            Values              = {"SmoothPlastic", "ForceField"}, 
            Default             = 1,
            Multi               = false,
            Text                = "Tools Material"
        })
    end
end

local Misc = Window:AddTab("Misc") do 
    local Player 											    = Misc:AddLeftGroupbox("Player") do        
        Player:AddToggle("Fly", {
            Text                = "Fly",
            Default             = false
        }):AddKeyPicker("FlyKey", {
            Default 			= "Esc",
            SyncToggleState 	= true,
            Mode 				= "Toggle",
        
            Text 				= "Fly",
            NoUI 				= false
        })

        Player:AddToggle("Noclip", {
            Text                = "Noclip",
            Default             = false
        }):AddKeyPicker("NoclipKey", {
            Default 			= "Esc",
            SyncToggleState 	= true,
            Mode 				= "Toggle",
        
            Text 				= "Noclip",
            NoUI 				= false
        })

        Player:AddToggle("FLag", {
            Text                = "Fake Lag",
            Default             = false
        }):AddKeyPicker("FakeLagKey", {
            Default 			= "Esc",
            SyncToggleState 	= true,
            Mode 				= "Toggle",
        
            Text 				= "Fake Lag",
            NoUI 				= false
        })

        Player:AddToggle("FLagVisual", {
            Text                = "Lag Visual",
            Default             = false
        }):AddKeyPicker("FakeLagVisualizeKey", {
            Default 			= "Esc",
            SyncToggleState 	= true,
            Mode 				= "Toggle",
        
            Text 				= "Lag Visualize",
            NoUI 				= false
        })
        
        Player:AddToggle("SBot", {
            Text                = "Spin Bot",
            Default             = false
        }):AddKeyPicker("SpinBotKey", {
            Default 			= "Esc",
            SyncToggleState 	= true,
            Mode 				= "Toggle",
        
            Text 				= "Spin Bot",
            NoUI 				= false
        })

        Player:AddToggle("BHop", {
            Text                = "Bunny Hop",
            Default             = false
        }):AddKeyPicker("BunnyHopKey", {
            Default 			= "Esc",
            SyncToggleState 	= true,
            Mode 				= "Toggle",
        
            Text 				= "Bunny Hop",
            NoUI 				= false
        })

        Player:AddToggle("WalkSpeed", {
            Text                = "Walk Speed",
            Default             = false
        })

        Player:AddToggle("JumpPower", {
            Text                = "Jump Power",
            Default             = false
        })

        Player:AddDivider()

        Player:AddDropdown("Disablers", {
            Values              = {"Stamina Penalty", "Fall Damage", "Ragdoll", "Lockpick Fail"},
            Default             = 0,
            Multi               = true,
            AllowNull           = false,
            Text                = "Disablers"
        })

        Player:AddDivider()

        Player:AddSlider("FlySpeed", {
            Text                = "Fly Speed",
            Min                 = 0,
            Max                 = 100,
            Default             = 50,
            Rounding            = 0,
            Compact             = true,
            Suffix              = "",
        })

        Player:AddSlider("SpinSpeed", {
            Text                = "Spin Speed",
            Min                 = 0,
            Max                 = 50,
            Default             = 50,
            Rounding            = 0,
            Compact             = true,
            Suffix              = "",
        })

        Player:AddSlider("LagAmount", {
            Text                = "Lag Amount",
            Min                 = 0,
            Max                 = 1,
            Default             = 0.25,
            Rounding            = 3,
            Compact             = true,
            Suffix              = "",
        })

        Player:AddSlider("WalkSpeed", {
            Text                = "Walk Speed",
            Min                 = 0,
            Max                 = 70,
            Default             = 50,
            Rounding            = 0,
            Compact             = true,
            Suffix              = "",
        })

        Player:AddSlider("JumpPower", {
            Text                = "Jump Power",
            Min                 = 0,
            Max                 = 100,
            Default             = 50,
            Rounding            = 0,
            Compact             = true,
            Suffix              = "",
        })
    end

    local Break  											    = Misc:AddRightGroupbox("Break") do
        Break:AddToggle("BreakDoors", {
            Text                = "Doors",
            Default             = false
        })

        Break:AddToggle("BreakSafes", {
            Text                = "Safes",
            Default             = false
        })

        Break:AddToggle("BreakRegisters", {
            Text                = "Registers",
            Default             = false
        })

        Break:AddDivider()

        Break:AddDropdown("SafeMethod", {
            Values              = {"Melee", "Lockpick", "Both"},
            Default             = 1,
            Multi               = false,
            AllowNull           = false,
            Text                = "Safe Method"
        })

        Break:AddDivider()

        Break:AddDropdown("DoorMethod", {
            Values              = {"Melee", "Lockpick", "Both"},
            Default             = 1,
            Multi               = false,
            AllowNull           = false,
            Text                = "Door Method"
        })

        Break:AddButton({
            Text                = "Fix",
            DoubleClick         = false,
            Func                = function()
                Fondra.Cooldowns.BreakSafes                 = false
                Fondra.Cooldowns.BreakRegisters             = false
                Fondra.Cooldowns.BreakDoors                 = false
            end
        })
    end

    local Misc 											        = Misc:AddRightGroupbox("Hitmarker") do        
        Misc:AddToggle("CustomHitMarker", {
            Text                = "Custom Hit Marker",
            Default             = false
        })

        Misc:AddDropdown("SelectedHitMarker", {
            Values              = {"Default"},
            Default             = 1,
            Multi               = false,
            AllowNull           = false,
            Text                = "Sound"
        })

        Misc:AddButton({
            Text                = "Refresh List",
            DoubleClick         = false,
            Func                = function()
                Options.SelectedHitMarker:SetValues(Fondra.Functions.GetHitMarkers()) 
                Options.SelectedHitMarker:SetValue("Default")
            end
        })
    end
end

local Settings = Window:AddTab("Settings") do end

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder("Fondra/Themes")
SaveManager:SetFolder("Fondra/Games/Blackout")

SaveManager:BuildFolderTree()
ThemeManager:BuildFolderTree()

SaveManager:SetIgnoreIndexes({})
SaveManager:IgnoreThemeSettings()

SaveManager:BuildConfigSection(Settings)
ThemeManager:BuildThemeSection(Settings)

Library.SaveManager             = SaveManager
Library.ThemeManager            = ThemeManager

Library:Notify(string.format("Loaded UI.lua in %.4f MS", tick() - Fondra.Data.Start))