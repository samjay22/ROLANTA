--!strict
local BaseService = require(game.ReplicatedStorage.Shared.Types.BaseService)

local StringMatcher

local Container = {}
Container.__index = Container

local _createdServices : {BaseService.BaseService<any>} = {}

local function _findService<T>(name : string) : T?
    local foundService : T? = nil
    for index, value in next, _createdServices do
        if value.Name == name then
            foundService = value
            break
        end
    end
    
    return foundService
end

function Container.new(folder : Folder)
    assert(folder, "No service directory was given!")
    local self = setmetatable({}, Container)

    local strings : {string} = {}
    for _, serviceModule : ModuleScript in folder do
        local name : string = serviceModule.Name
        table.insert(strings, name)
    end


    StringMatcher = require(game.ReplicatedStorage.Shared.Modules.Utilitys.StringMatcher).new(strings)
    self.ServiceDirectory = folder

    return self
end

function Container:GetService<T>(name : string) : T?
    local manualService : ModuleScript? = self.ServiceDirectory:FindFirstChild(name)
    local foundService : T? = _findService(name)
    if foundService then
        return foundService
    end

    table.insert(_createdServices, manualService and require(manualService) or game:GetService(name))
end

function Container:FindService<T>(name : string) : T?
    return _findService(name)
end

function Container:RegisterService(name : string) : boolean
    if _findService(name) then
        error(`{name} already exists`)
    end

    local serviceModule : ModuleScript? self.ServiceDirectory:FindFirstChild(name)
    if not serviceModule then
        local closest = StringMatcher:GenerateSuggestion(name)
        error(`Service under {name} does not exist. {if #closest > 0 then string.format("did you mean: %s", closest) else ""}`)
    end
end

return Container