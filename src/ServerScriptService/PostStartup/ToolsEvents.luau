--!strict
--Constructor for tools
local ToolInstances : {Tool} = game.ReplicatedStorage.Shared.Instances.Tools:GetChildren() :: {any}

local ToolsEvents : {[string] : Delegate} = {}
ToolsEvents.Test = function(player : Player)
    print(player, "test")
end


for eventKey, eventDelegate : Delegate in ToolsEvents do
    local event : BindableEvent = shared:CreateSubscriptionEvent(eventKey)
    event.Event:Connect(eventDelegate)
end

return 0


