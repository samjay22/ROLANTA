--!strict
local NetworkTypes = require(game.ReplicatedStorage.Shared.Types.NetworkTypes)

local RS : RunService = shared:GetService("RunService")

local Controller = {}
Controller.__index = Controller

function Controller.new(controllerDirectory : Folder)
    local controllerObject = {
        Endpoints = {},
        RequestQueue = {},
    }
    
    for _, module : (ModuleScript) in controllerDirectory:GetChildren() :: {ModuleScript} do
        local controllerData = require(module)
        for endpoint : string, delegate in controllerData do
            controllerObject.Endpoints[endpoint] = delegate            
        end
    end

    --Process queue items
    RS.Heartbeat:Connect(function(_ : number)
        local queueItem = table.remove(controllerObject.RequestQueue)
        if queueItem then
            queueItem.Delegate()
        end
    end)

    return setmetatable(controllerObject, Controller)
end

function Controller:ProcessRequest(request : NetworkTypes.Request<any>)
    local endpoint : string = request.Endpoint
    local delegate = self.Endpoints[endpoint]
    assert(delegate, `Endpoint with the name {endpoint} does not exist.`)

    local completedEvent : BindableEvent = Instance.new("BindableEvent")
    if request.AddToQueue then
        table.insert(self.RequestQueue, {
            Delegate = function()
                completedEvent:Fire(pcall(delegate(request.Player, unpack(request.Data))))
            end,
            Traceback = request.Traceback,
        })
    else
        completedEvent:Fire(pcall(delegate(request.Player, unpack(request.Data))))
    end

    local okay, resp = completedEvent.Event:Wait()
    completedEvent:Destroy()
    if not okay then
        resp = nil
        warn(`Request from {request.Player} to endpoint {endpoint} has failed. {request.Traceback}`)
    end

    return resp
end

return Controller