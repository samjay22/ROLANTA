--!strict
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

function Controller:ProcessRequest(request : Request<any>)
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

--To send requests
function shared:SendRequest(player : Player, requestEndpoint : string, requestData : any?)
    local payload : Request<any> = {
        Player = player,
        Endpoint = requestEndpoint,
        Traceback = debug.traceback("", 0),
        Data = requestData,
        AddToQueue = false,
    }

    local beforeSendArgs : {[string] : any, requestSender : RemoteFunction | RemoteEvent | UnreliableRemoteEvent, AddToQueue : boolean} = {} :: any
    local requestCompleted : BindableEvent = Instance.new("BindableEvent")
    task.defer(function()
        task.wait(.25)
        if not beforeSendArgs.requestSender then
            warn("No sender specified, using remote event as default!")
            beforeSendArgs.requestSender = game.ReplicatedStorage.Shared.Remotes.RemoteEvent
        end

        for key, value in beforeSendArgs do
            payload[key] = value
        end

        local isEvent : boolean = beforeSendArgs.requestSender.ClassName:find("Event") ~= nil
        local response : any? = nil
        if RS:IsServer() then
            if isEvent then
                (beforeSendArgs.requestSender :: RemoteEvent):FireClient(payload.Player, payload) 
            else
                error("Cannot invoke client due to garbage collection issues")
            end
        else
            if isEvent then
                (beforeSendArgs.requestSender :: RemoteEvent):FireServer(payload)
            else
                response = (beforeSendArgs.requestSender :: RemoteFunction):InvokeServer(payload)
            end
        end

        requestCompleted:Fire(response)
    end)

    return beforeSendArgs, requestCompleted
end

return Controller