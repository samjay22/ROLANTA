--!strict
(game:GetService("Players") :: Players).CharacterAutoLoads = false


local Shared = game.ReplicatedStorage:WaitForChild("Shared")

local Modules = Shared:WaitForChild("Modules")

local ServiceContainer = require(Modules.ServiceContainer)
local containerObject = ServiceContainer.new(game.ServerStorage.Services)
setmetatable(shared, {__index = containerObject})


--Load all other core functionality
require(game.ReplicatedStorage.Shared.Instances)
require(Modules:WaitForChild("Utilitys"):WaitForChild("GlobalFunctions"))
require(Shared.Modules:WaitForChild("EnumWrapper"))
require(game.ServerScriptService.PostStartup)