--!strict
local CAS : ContextActionService = shared:GetService("ContextActionService")
local UIS: UserInputService = shared:GetService("UserInputService")
local RS : RunService = shared:GetService("RunService")

local InputQueue : {{Event : BindableEvent, State : Enum.UserInputState}} = {}

UIS.InputBegan:Connect(function(input)
    local eventObject : BindableEvent = shared:GetSubscriptionEvent(input.KeyCode)
    if not eventObject then
        return
    end
    
    table.insert(InputQueue, {eventObject, Enum.UserInputState.Begin}) 
end)

UIS.InputEnded:Connect(function(input)
    local eventObject : BindableEvent = shared:GetSubscriptionEvent(input.KeyCode)
    if not eventObject then
        return
    end
    
    table.insert(InputQueue, {Event = eventObject, State = Enum.UserInputState.End}) 
end)



RS.RenderStepped:Connect(function(dt : number)
    local inputEvent = table.remove(InputQueue)
    if not inputEvent then
        return
    end

   inputEvent.Event:Fire(inputEvent.State)
end)
