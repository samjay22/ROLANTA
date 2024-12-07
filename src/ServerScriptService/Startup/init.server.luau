--!strict
local Shared = game.ReplicatedStorage:WaitForChild("Shared")

local Modules = Shared:WaitForChild("Modules")

local ServiceContainer = require(Modules.ServiceContainer)
local containerObject = ServiceContainer.new(game.ServerStorage.Services)
setmetatable(shared, containerObject)

--Load all other core functionality
require(Modules:WaitForChild("Utilitys"):WaitForChild("GlobalFunctions"))
require(game.ServerScriptService.PostStartup)