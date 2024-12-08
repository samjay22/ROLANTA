--!strict
local CharacterActionService : CharacterActionService = shared:GetService("CharacterActionService")

local sprintEvent = shared:CreateSubscriptionEvent(Enum.KeyCode.LeftShift)
sprintEvent.Event:Connect(function(state)
    CharacterActionService:Sprint(state)
end)

return 0