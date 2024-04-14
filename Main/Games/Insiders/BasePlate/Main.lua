Instance.new("Atmosphere", Fondra.Services.Lighting)

Toggles.Ambience:OnChanged(function(V)
	if (V) then return end

	Fondra.Services.Lighting.Ambient							= Color3.fromRGB(0, 0, 0)
	Fondra.Services.Lighting.OutdoorAmbient						= Color3.fromRGB(128, 128, 128)

	Options.AmbienceColor1:SetValueRGB(Fondra.Services.Lighting.Ambient)
	Options.AmbienceColor2:SetValueRGB(Fondra.Services.Lighting.OutdoorAmbient)
end)

Toggles.Shift:OnChanged(function(V)
	if (V) then return end

	Fondra.Services.Lighting.ColorShift_Bottom					= Color3.fromRGB(0, 0, 0)
	Fondra.Services.Lighting.ColorShift_Top						= Color3.fromRGB(0, 0, 0)

	Options.ShiftColor1:SetValueRGB(Fondra.Services.Lighting.ColorShift_Bottom)
	Options.ShiftColor2:SetValueRGB(Fondra.Services.Lighting.ColorShift_Top)
end)

Toggles.ShadowMap:OnChanged(function(V)
	Fondra.Services.Lighting.GlobalShadows						= V and V or false
end)

Toggles.ForceTime:OnChanged(function(V)
	Fondra.Services.Lighting.ClockTime							= V and Options.SelectedTime or 14
end)

Toggles.ForceLatitude:OnChanged(function(V)
	Fondra.Services.Lighting.GeographicLatitude					= V and Options.SelectedLatitude.Value or 41.733
end)

Toggles.ForceDiffuse:OnChanged(function(V)
	Fondra.Services.Lighting.EnvironmentDiffuseScale			= V and Options.SelectedDiffuse.Value or 0
end)

Toggles.SkyBox:OnChanged(function(V)
	if not V and Fondra.Services.Lighting:FindFirstChildWhichIsA("Sky") then Fondra.Services.Lighting:FindFirstChildWhichIsA("Sky"):Destroy() end
	if V and not Fondra.Services.Lighting:FindFirstChildWhichIsA("Sky") then Instance.new("Sky", Fondra.Services.Lighting) end
	
	Options.SelectedSkyBox:SetValues(Fondra.Functions.GetSkyBoxes())
	Fondra.Functions.SetSkyBox(not V and "Default" or Options.SelectedSkyBox.Value)
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
	if (not Toggles.Shift.Value) then return end

	Fondra.Services.Lighting.ColorShift_Bottom					= Options.ShiftColor1.Value
	Fondra.Services.Lighting.ColorShift_Top						= Options.ShiftColor2.Value
end)

Options.ShiftColor2:OnChanged(function(V)
	if (not Toggles.Shift.Value) then return end

	Fondra.Services.Lighting.ColorShift_Bottom					= Options.ShiftColor1.Value
	Fondra.Services.Lighting.ColorShift_Top						= Options.ShiftColor2.Value
end)

Options.AmbienceColor1:OnChanged(function(V)
	if (not Toggles.Ambience.Value) then return end

	Fondra.Services.Lighting.Ambient							= Options.AmbienceColor1.Value
	Fondra.Services.Lighting.OutdoorAmbient						= Options.AmbienceColor2.Value
end)

Options.AmbienceColor1:OnChanged(function(V)
	if (not Toggles.Ambience.Value) then return end
	
	Fondra.Services.Lighting.Ambient							= Options.AmbienceColor1.Value
	Fondra.Services.Lighting.OutdoorAmbient						= Options.AmbienceColor2.Value
end)

Options.SelectedSkyBox:OnChanged(function(V)
	Options.SelectedSkyBox:SetValues(Fondra.Functions.GetSkyBoxes())
	Fondra.Functions.SetSkyBox(Toggles.SkyBox.Value and V or nil)
end)

Library:Notify(string.format("Loaded Main.lua in %.4f MS", tick() - Fondra.Data.Start))
Library.SaveManager:LoadAutoloadConfig()