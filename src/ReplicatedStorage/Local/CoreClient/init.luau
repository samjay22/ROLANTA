--!strict
local CharacterService = shared:GetService("CharacterService")

local sprintEvent = shared:CreateSubscriptionEvent(Enum.KeyCode.LeftShift)
sprintEvent.Event:Connect(function(state)
    CharacterService:Sprint(state)
end)

return 0