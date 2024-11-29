--!strict
local BaseService = require(game.ReplicatedStorage.Shared.Types.BaseService)

local Container = {}
Container.__index = Container

local _createdServices : {BaseService.BaseService<any>} = {}
local servicesNameTrie = {}

local function _generateServiceSuggestion(self, name : string)
    local closest = {}
    for _, char in string.split(name, "") do
        if servicesNameTrie[char] then
            table.insert(closest, char)
        end    
    end

    return table.concat(closest)
end

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

function Container.new()
    return setmetatable({}, Container)
end

function Container:GetService<T>(name : string) : T?
    return _findService(name) 
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
        local closest = _generateServiceSuggestion(self, name)
        error(`Service under {name} does not exist. {if #closest > 0 then string.format("did you mean: %s", closest) else ""}`)
    end
end

local function _makeStringMatchTrie(node : any, charsLeft : {string})
    if #charsLeft == 0 then
        return
    end

    local key : string = table.remove(charsLeft, 1)
    if not key then
        return
    end

    node[key] = {}
    
    _makeStringMatchTrie(node[key], charsLeft)
end

function Container:AddServiceDirectory(folder : Folder)
    if self.ServiceDirectory then
        error("Service directory already exists")
    end

    for _, serviceModule : ModuleScript in folder do
        local name : string = serviceModule.Name
        local splitName = string.split(name, "")
        local head = {[table.remove(splitName, 1)] = {}}
        _makeStringMatchTrie(head)
        servicesNameTrie = head
    end

    self.ServiceDirectory = folder
end

return Container.new()