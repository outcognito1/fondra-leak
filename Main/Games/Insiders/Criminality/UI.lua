local Repository												= "https://raw.githubusercontent.com/lncoognito/Linoria/main/"

local Library 													= loadstring(Fondra.SecureGet(Repository .. "Library.lua"))()
local ThemeManager 												= loadstring(Fondra.SecureGet(Repository .. "Addons/ThemeManager.lua"))()
local SaveManager 												= loadstring(Fondra.SecureGet(Repository .. "Addons/SaveManager.lua"))()

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

local Main 														= Window:AddTab("Main") do
	local RageBot 												= Main:AddLeftGroupbox("RageBot") do
        RageBot:AddToggle("RageBot", {
            Text                = "Enabled",
            Default             = false
        }):AddKeyPicker("FondraRageBotKey", {
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
        
        RageBot:AddToggle("RageBotFasterHit", {
            Text                = "Faster Hit",
            Default             = false,
            Risky               = true
        }):AddKeyPicker("FondraFasterHitKey", {
            Default 			= "Esc",
            SyncToggleState 	= true,
            Mode 				= "Toggle",
        
            Text 				= "Faster Hit",
            NoUI 				= false
        })

        RageBot:AddToggle("RageBotInstantHit", {
            Text                = "Instant Hit",
            Default             = false,
            Risky               = true
        }):AddKeyPicker("FondraInstantHitKey", {
            Default 			= "Esc",
            SyncToggleState 	= true,
            Mode 				= "Toggle",
        
            Text 				= "Instant Hit",
            NoUI 				= false
        })

        RageBot:AddDivider()

        RageBot:AddToggle("RageBotNotify", {
            Text                = "Hit Notify",
            Default             = false
        })

        RageBot:AddToggle("RageBotAnimation", {
            Text                = "Fire Animation",
            Default             = false
        })

        RageBot:AddToggle("RageBotSound", {
            Text                = "Fire Sound",
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
            Values              = {"Head", "Torso", "Right Arm", "Left Arm", "Right Leg", "Left Leg"}, 
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

	local LegitBot 												= Main:AddRightGroupbox("LegitBot") do
        LegitBot:AddToggle("LegitBot", {
            Text                = "Enabled",
            Default             = false
        }):AddKeyPicker("FondraLegitBotKey", {
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

    local MeleeAura 												= Main:AddLeftGroupbox("Melee Aura") do
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
        }):AddKeyPicker("FondraTriggerBotKey", {
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

	local FinishAura 											= Main:AddLeftGroupbox("Finish Aura") do
        FinishAura:AddToggle("FinishAura", {
            Text                = "Enabled",
            Default             = false
        })

        FinishAura:AddToggle("FinishAuraFriendly", {
            Text                = "Friendly Check",
            Default             = false
        })

        FinishAura:AddSlider("FinishAuraDistance", {
            Text                = "Distance",
            Min                 = 0,
            Max                 = 10,
            Default             = 10,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " Meters",
        })
	end

	local GunMods 												= Main:AddRightGroupbox("Gun Mods") do
        GunMods:AddSlider("RecoilPercentage", {
            Text                = "Recoil",
            Min                 = 0,
            Max                 = 100,
            Default             = 100,
            Rounding            = 0,
            Compact             = true,
            Suffix              = "%",
        })

        GunMods:AddSlider("SpreadPercentage", {
            Text                = "Spread",
            Min                 = 0,
            Max                 = 100,
            Default             = 100,
            Rounding            = 0,
            Compact             = true,
            Suffix              = "%",
        })
	end

    local SprayAura 											= Main:AddLeftGroupbox("Spray Aura") do
        SprayAura:AddToggle("SprayAura", {
            Text                = "Enabled",
            Default             = false
        })

        SprayAura:AddToggle("SprayAuraFriendly", {
            Text                = "Friendly Check",
            Default             = false
        })
        
        SprayAura:AddToggle("SprayAuraDowned", {
            Text                = "Downed Check",
            Default             = false
        })

        SprayAura:AddDivider()

        SprayAura:AddSlider("SprayAuraDistance", {
            Text                = "Distance",
            Min                 = 0,
            Max                 = 15,
            Default             = 15,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " Meters",
        })
	end

	local Projectile 											= Main:AddRightGroupbox("Projectile Controllers") do
        Projectile:AddToggle("GLController", {
            Text                = "Grenade Launcher",
            Default             = false
        })

        Projectile:AddToggle("HLController", {
            Text                = "Hallow's Launcher",
            Default             = false
        })

        Projectile:AddToggle("RLController", {
            Text                = "Rocket Launcher",
            Default             = false
        })

        Projectile:AddToggle("C4Controller", {
            Text                = "C4",
            Default             = false
        })

        Projectile:AddDivider()

        Projectile:AddSlider("ProjectileSpeed", {
            Text                = "Projectiles Speed",
            Min                 = 0,
            Max                 = 200,
            Default             = 25,
            Rounding            = 0,
            Compact             = true,
            Suffix              = "",
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

        Player:AddToggle("PlayerVLookAngle", {
            Text                = "Look Angle",
            Default             = false
        }):AddColorPicker("PlayerLAC", { 
            Title               = "Look Angle",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("PlayerLAOC", { 
            Title               = "Look Angle Outline",
            Default             = Color3.fromRGB(0, 0, 0)
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
        })
        
        Dealer:AddToggle("DealerVTypeText", {
            Text                = "Type Text",
            Default             = false
        })

        Dealer:AddToggle("DealerVDistanceText", {
            Text                = "Distance Text",
            Default             = false
        })

        Dealer:AddDivider()

        Dealer:AddLabel("Illegal"):AddColorPicker("IllegalBC", { 
            Title               = "Dealer Box",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("IllegalBOC", { 
            Title               = "Dealer Box Outline",
            Default             = Color3.fromRGB(255, 166, 0)
        })

        Dealer:AddLabel("Armory"):AddColorPicker("ArmoryBC", { 
            Title               = "Dealer Box",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("ArmoryBOC", { 
            Title               = "Dealer Box Outline",
            Default             = Color3.fromRGB(0, 119, 255)
        })

        Dealer:AddDivider()

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
        })

        Safe:AddToggle("SafeVTypeText", {
            Text                = "Type Text",
            Default             = false
        })

        Safe:AddToggle("SafeVStatusText", {
            Text                = "Status Text",
            Default             = false
        })

        Safe:AddToggle("SafeVDistanceText", {
            Text                = "Distance Text",
            Default             = false
        })

        Safe:AddToggle("SafeVRarityText", {
            Text                = "Rarity Text",
            Default             = false
        })

        Safe:AddToggle("SafeVBrokenCheck", {
            Text                = "Broken Check",
            Default             = false
        })

        Safe:AddDivider()

        Safe:AddLabel("Small"):AddColorPicker("SafeSBC", { 
            Title               = "Safe Box",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("SafeSBOC", { 
            Title               = "Safe Box Outline",
            Default             = Color3.fromRGB(0, 255, 224)
        })

        Safe:AddLabel("Big"):AddColorPicker("SafeBBC", { 
            Title               = "Safe Box",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("SafeBBOC", { 
            Title               = "Safe Box Outline",
            Default             = Color3.fromRGB(255, 58, 58)
        })

        Safe:AddDivider()

        Safe:AddDropdown("SafeVSize", {
            Values              = {"Big", "Small"}, 
            Default             = 1,
            Multi               = true,
            AllowNull           = false,
            Text                = "Size"
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
    
	local Scrap 												= Visual:AddLeftGroupbox("Scrap") do
        Scrap:AddToggle("ScrapV", {
            Text                = "Enabled",
            Default             = false
        })

        Scrap:AddToggle("ScrapVBox", {
            Text                = "Box",
            Default             = false
        }):AddColorPicker("ScrapBC", { 
            Title               = "Box",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("ScrapBOC", { 
            Title               = "Box Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })

        Scrap:AddToggle("ScrapVTypeText", {
            Text                = "Type Text",
            Default             = false
        }):AddColorPicker("ScrapTTC", { 
            Title               = "Text",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("ScrapTTOC", { 
            Title               = "Text Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })
        
        Scrap:AddToggle("ScrapVDistanceText", {
            Text                = "Distance Text",
            Default             = false
        }):AddColorPicker("ScrapDTC", { 
            Title               = "Text",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("ScrapDTOC", { 
            Title               = "Text Outline",
            Default             = Color3.fromRGB(0, 0, 0)
        })

        Scrap:AddDivider()

        Scrap:AddSlider("ScrapVMaxDistance", {
            Text                = "Distance",
            Min                 = 0,
            Max                 = 1000,
            Default             = 500,
            Rounding            = 0,
            Compact             = true,
            Suffix              = " Meters",
        })
    end

	local Crate 												= Visual:AddRightGroupbox("Crate") do
        Crate:AddToggle("CrateV", {
            Text                = "Enabled",
            Default             = false
        })

        Crate:AddToggle("CrateVBox", {
            Text                = "Box",
            Default             = false
        })

        Crate:AddToggle("CrateVTypeText", {
            Text                = "Type Text",
            Default             = false
        })

        Crate:AddToggle("CrateVDistanceText", {
            Text                = "Distance Text",
            Default             = false
        })

        Crate:AddToggle("CrateVRarityText", {
            Text                = "Rarity Text",
            Default             = false
        })

        Crate:AddDivider()

        Crate:AddLabel("Green"):AddColorPicker("CrateGBC", { 
            Title               = "Safe Box",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("CrateGBOC", { 
            Title               = "Safe Box Outline",
            Default             = Color3.fromRGB(0, 255, 224)
        })

        Crate:AddLabel("Red"):AddColorPicker("CrateRBC", { 
            Title               = "Safe Box",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("CrateRBOC", { 
            Title               = "Safe Box Outline",
            Default             = Color3.fromRGB(255, 58, 58)
        })

        Crate:AddLabel("Gold"):AddColorPicker("CrateLBC", { 
            Title               = "Safe Box",
            Default             = Color3.fromRGB(255, 255, 255)
        }):AddColorPicker("CrateLBOC", { 
            Title               = "Safe Box Outline",
            Default             = Color3.fromRGB(255, 174, 0)
        })

        Crate:AddDivider()

        Crate:AddDropdown("CrateVRarities", {
            Values              = {"Gold", "Red", "Green"}, 
            Default             = 2,
            Multi               = true,
            AllowNull           = false,
            Text                = "Rarities"
        })

        Crate:AddSlider("CrateVMaxDistance", {
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
            Transparency        = 0,
        }):AddColorPicker("AmbienceColor2", {
            Default             = Color3.fromRGB(0, 99, 228),
            Title               = "Ambience 2",
            Transparency        = 0,
        })

        World:AddToggle("Shift", {
            Text                = "Color Shift",
            Default             = false
        }):AddColorPicker("ShiftColor1", {
            Default             = Color3.fromRGB(0, 99, 228),
            Title               = "Shift Color 1",
            Transparency        = 0,
        }):AddColorPicker("ShiftColor2", {
            Default             = Color3.fromRGB(0, 99, 228),
            Title               = "Shift Color 2",
            Transparency        = 0,
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
            Transparency        = 0,
        }):AddColorPicker("ViewmodelRArmColor", {
            Default             = Color3.fromRGB(0, 99, 228),
            Title               = "Right Arm Color",
            Transparency        = 0,
        }):AddColorPicker("ViewmodelLArmColor", {
            Default             = Color3.fromRGB(0, 99, 228),
            Title               = "Left Arm Color",
            Transparency        = 0,
        })

        Viewmodel:AddDivider()

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
 
        Viewmodel:AddDropdown("ViewmodeArmsMaterial", {
            Values              = {"SmoothPlastic", "ForceField"}, 
            Default             = 1,
            Multi               = false,
            Text                = "Arms Material"
        })

        Viewmodel:AddDropdown("ViewmodeToolsMaterial", {
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
        }):AddKeyPicker("FondraFlyKey", {
            Default 			= "Esc",
            SyncToggleState 	= true,
            Mode 				= "Toggle",
        
            Text 				= "Fly",
            NoUI 				= false
        })

        Player:AddToggle("Noclip", {
            Text                = "Noclip",
            Default             = false
        }):AddKeyPicker("FondraNoclipKey", {
            Default 			= "Esc",
            SyncToggleState 	= true,
            Mode 				= "Toggle",
        
            Text 				= "Noclip",
            NoUI 				= false
        })

        Player:AddToggle("FLag", {
            Text                = "Fake Lag",
            Default             = false
        }):AddKeyPicker("FondraFakeLagKey", {
            Default 			= "Esc",
            SyncToggleState 	= true,
            Mode 				= "Toggle",
        
            Text 				= "Fake Lag",
            NoUI 				= false
        })

        Player:AddToggle("FLagVisual", {
            Text                = "Lag Visual",
            Default             = false
        }):AddKeyPicker("FondraFakeLagVisualizeKey", {
            Default 			= "Esc",
            SyncToggleState 	= true,
            Mode 				= "Toggle",
        
            Text 				= "Lag Visualize",
            NoUI 				= false
        })
        
        Player:AddToggle("SBot", {
            Text                = "Spin Bot",
            Default             = false
        }):AddKeyPicker("FondraSpinBotKey", {
            Default 			= "Esc",
            SyncToggleState 	= true,
            Mode 				= "Toggle",
        
            Text 				= "Spin Bot",
            NoUI 				= false
        })

        Player:AddToggle("BHop", {
            Text                = "Bunny Hop",
            Default             = false
        }):AddKeyPicker("FondraBunnyHopKey", {
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

        Player:AddToggle("InstantReload", {
            Text                = "Instant Reload",
            Default             = false
        })

        Player:AddToggle("Stamina", {
            Text                = "Infinite Stamina",
            Default             = false
        })

        Player:AddToggle("NoFail", {
            Text                = "No Lockpick Fail",
            Default             = false
        })

        Player:AddDivider()

        Player:AddDropdown("Disablers", {
            Values              = {"Grinders", "Barbwires", "Drowning", "Ragdoll", "Fall Damage"},
            Default             = 0,
            Multi               = true,
            AllowNull           = false,
            Text                = "Disablers"
        })

        Player:AddDivider()

        Player:AddDropdown("StatsMethod", {
            Values              = {"Default", "Bypass"},
            Default             = 2,
            Multi               = false,
            AllowNull           = false,
            Text                = "Stats Method"
        })

        Player:AddDivider()

        Player:AddDropdown("FlyMethod", {
            Values              = {"Default", "Bypass"},
            Default             = 2,
            Multi               = false,
            AllowNull           = false,
            Text                = "Fly Method"
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

    local TabBox  											    = Misc:AddRightTabbox() do
        local Auto = TabBox:AddTab("Pickup") do
            Auto:AddToggle("AutoPickScraps", {
                Text            = "Auto Pickup Scraps",
                Default         = false
            })
    
            Auto:AddToggle("AutoPickCrates", {
                Text            = "Auto Pickup Crates",
                Default         = false
            })
    
            Auto:AddToggle("AutoPickTools", {
                Text            = "Auto Pickup Tools",
                Default         = false
            })
    
            Auto:AddToggle("AutoPickCash", {
                Text            = "Auto Pickup Cash",
                Default         = false
            })
    
            Auto:AddDivider()

            Auto:AddSlider("AutoPickRange", {
                Text            = "Range",
                Min             = 5,
                Max             = 10,
                Default         = 5,
                Rounding        = 2,
                Compact         = true,
                Suffix          = " Meters",
            }) 
            
            Auto:AddSlider("AutoPickDelay", {
                Text            = "Delay",
                Min             = 0.25,
                Max             = 5,
                Default         = 0.25,
                Rounding        = 2,
                Compact         = true,
                Suffix          = " Seconds",
            }) 
        end

        local Break = TabBox:AddTab("Break") do
            Break:AddToggle("BreakDoors", {
                Text            = "Doors",
                Default         = false
            })

            Break:AddToggle("BreakSafes", {
                Text            = "Safes",
                Default         = false
            })

            Break:AddToggle("BreakRegisters", {
                Text            = "Registers",
                Default         = false
            })

            Break:AddDivider()

            Break:AddDropdown("SafeMethod", {
                Values          = {"Melee", "Lockpick", "Both"},
                Default         = 1,
                Multi           = false,
                AllowNull       = false,
                Text            = "Safe Method"
            })

            Break:AddDivider()

            Break:AddDropdown("DoorMethod", {
                Values          = {"Melee", "Lockpick", "Both"},
                Default         = 1,
                Multi           = false,
                AllowNull       = false,
                Text            = "Door Method"
            })

            Break:AddButton({
                Text            = "Fix",
                DoubleClick     = false,
                Func            = function()
                    Fondra.Cooldowns.BreakSafes                 = false
                    Fondra.Cooldowns.BreakRegisters             = false
                    Fondra.Cooldowns.BreakDoors                 = false
                end
            })
        end
    end

    local Misc 											        = Misc:AddRightGroupbox("Misc") do        
        Misc:AddToggle("ChatLogs", {
            Text                = "Show Chat Logs",
            Default             = false
        })

        Misc:AddToggle("InfinitePepperSpray", {
            Text                = "Infinite Pepper Spray",
            Default             = false
        })

        Misc:AddDivider()

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
SaveManager:SetFolder("Fondra/Games/Criminality")

SaveManager:BuildFolderTree()
ThemeManager:BuildFolderTree()

SaveManager:SetIgnoreIndexes({})
SaveManager:IgnoreThemeSettings()

SaveManager:BuildConfigSection(Settings)
ThemeManager:BuildThemeSection(Settings)

Library.SaveManager             = SaveManager
Library.ThemeManager            = ThemeManager

Library:Notify(string.format("Loaded UI.lua in %.4f MS", tick() - Fondra.Data.Start))