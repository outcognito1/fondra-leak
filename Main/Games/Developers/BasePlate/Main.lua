Library:Notify(string.format("Loaded Main.lua in %.4f MS", tick() - Fondra.Data.Start))

Fondra.Functions.Unload                                         = function()
    cleardrawcache()
    Fondra.Functions.ClearConnections(Fondra.Connections)
    Fondra.Functions.ClearHooks(Fondra.Hooks)
end