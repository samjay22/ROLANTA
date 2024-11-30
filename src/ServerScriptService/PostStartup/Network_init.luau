--!strict
local NetworkTypes = require(game.ReplicatedStorage.Shared.Types.NetworkTypes)

local NetworkController = require(game.ReplicatedStorage.Shared.Modules.NetworkController)

local networkObject = NetworkController.new(game.ServerStorage.Controllers)

local Remotes = game.ReplicatedStorage.Shared.Remotes

Remotes.RemoteEvent.OnServerEvent:Connect(function(player : Player, requests : NetworkTypes.Request<any>)
    requests.Player = player
    requests.AddToQueue = true
    return networkObject:ProcessRequest(requests)
end)

Remotes.UnreliableEvent.OnServerEvent:Connect(function(player : Player, requests : NetworkTypes.Request<any>)
    requests.Player = player
    requests.AddToQueue = false
    return networkObject:ProcessRequest(requests)
end)

--There needs to be a manual specification to determine if we add requests to the queue or not for these requests.
Remotes.RemoteFunction.OnClientInvoke = (function(player : Player, requests : NetworkTypes.Request<any>)
    requests.Player = player
    return networkObject:ProcessRequest(requests)
end)

return 0