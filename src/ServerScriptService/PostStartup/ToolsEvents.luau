--!strict
--Constructor for tools
local Instances = require(game.ReplicatedStorage.Shared.Instances)

local ToolsEvents : {[string] : Delegate} = {}
ToolsEvents.M9 = function(player : Player)
    print(player, "test")
end


for eventKey, eventDelegate : Delegate in ToolsEvents do
    local event : BindableEvent = shared:CreateSubscriptionEvent(eventKey)
    event.Event:Connect(eventDelegate)
end

return 0


