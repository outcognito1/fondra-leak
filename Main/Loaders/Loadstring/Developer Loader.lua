local Success, Result               = pcall((syn and syn.request) or (fluxus and fluxus.request) or (request), {
	Url                             = "http://localhost:8080/API/DevLoader",
	Method                          = "GET"
})

if not Success then return end
if not Result.Body then return end

loadstring(Result.Body)("Developers", true, "65d8cb4cf9c3b03cb365d649")