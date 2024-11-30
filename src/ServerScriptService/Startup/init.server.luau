--!strict
local ServiceContainer = require(game.ReplicatedStorage.Shared.Modules.ServiceContainer)
local containerObject = ServiceContainer.new(game.ServerStorage.Services)
setmetatable(shared, containerObject)

--Load all other core functionality
require(game.ServerScriptService.PostStartup)