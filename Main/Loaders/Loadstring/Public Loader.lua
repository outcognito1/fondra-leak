local Success, Result               = pcall((syn and syn.request) or (fluxus and fluxus.request) or (request), {
	Url                             = "https://fondra.club/API/Loader",
	Method                          = "GET"
})

if not Success then return end
if not Result.Body then return end

loadstring(Result.Body)("Insiders", true, "Key")