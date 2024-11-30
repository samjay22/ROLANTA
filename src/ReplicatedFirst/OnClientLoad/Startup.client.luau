--!strict
local Local = game.ReplicatedStorage:WaitForChild("Local")
local Shared = game.ReplicatedStorage:WaitForChild("Shared")

local Modules = Shared:WaitForChild("Modules")
local Services = Local:WaitForChild("Services")

local ServiceContainer = require(Modules:WaitForChild("ServiceContainer"))
local containerObject = ServiceContainer.new(Services)
setmetatable(shared, {__index = containerObject})

--Load rest of data
require(Local:WaitForChild("CoreClient"))