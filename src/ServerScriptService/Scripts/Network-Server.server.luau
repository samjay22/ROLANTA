local Server = require(game.ReplicatedStorage.NetworkClient)
local Endpoints = game.ServerStorage.Endpoints
Server.API = (function()
    local endpoints = {}
    for _, mod in Endpoints:GetChildren() do
        local modName : string = mod.Name
        for method, v in require(mod) do
            endpoints[`{modName}/{method}`] = v
        end
    end
    return endpoints
end)()
-- The server-side doesn't need to send requests, but it can process incoming requests from clients.