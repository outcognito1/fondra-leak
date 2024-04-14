-- // Clear
if Fondra.Functions.CleanUp then Fondra.Functions.CleanUp() end

local Repository												= "https://raw.githubusercontent.com/lncoognito/Linoria/main/"

local Library 													= loadstring(Fondra.Functions.SecureGet(Repository .. "Library.lua"))()
local ThemeManager 												= loadstring(Fondra.Functions.SecureGet(Repository .. "Addons/ThemeManager.lua"))()
local SaveManager 												= loadstring(Fondra.Functions.SecureGet(Repository .. "Addons/SaveManager.lua"))()

local Window 													= Library:CreateWindow({
    Title 														= "Fondra - V4",
    Center 														= true,
    AutoShow 													= true,
    TabPadding 													= 1,
    MenuFadeTime 												= 0.1
})

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
            Default             = 10,
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

    local World 												= Visual:AddRightGroupbox("World") do
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
end

local Settings = Window:AddTab("Settings") do end

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder("Fondra/Themes")
SaveManager:SetFolder("Fondra/Games/Baseplate")

SaveManager:BuildFolderTree()
ThemeManager:BuildFolderTree()

SaveManager:SetIgnoreIndexes({})
SaveManager:IgnoreThemeSettings()

SaveManager:BuildConfigSection(Settings)
ThemeManager:BuildThemeSection(Settings)

Library.SaveManager             = SaveManager
Library.ThemeManager            = ThemeManager
Library:Notify(string.format("Loaded UI.lua in %.4f MS", tick() - Fondra.Data.Start))