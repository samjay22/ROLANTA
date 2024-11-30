--!strict
local Players : Players = shared:GetService("Players")

export type KeybindAction = {
    Name : string,
    AnimationId : number,
    InputBegin : BindableEvent,
    InputEnd : BindableEvent
}

local keybinds : {[Enum.KeyCode] : KeybindAction} = {}


return (function()
    local topStackTrace : string = debug.traceback("", 0)
    local shiftEvent : BindableEvent = Instance.new("BindableEvent")
    shiftEvent.Event:Connect(function(state : Enum.UserInputState)
        local player = Players.LocalPlayer
        local character = player.Character
        assert(character, `No character model for user {player.Name} {topStackTrace}`)

        local humanoid : Humanoid = character:FindFirstChild("Humanoid") :: Humanoid
        assert(humanoid, `No humanoid object for user {player.Name} {topStackTrace}`)

        humanoid.WalkSpeed = state == Enum.UserInputState.Begin and 20 or 16
    end)

    keybinds[Enum.KeyCode.LeftShift] = {
        Name = "Sprint",
        AnimationId = 0,
        InputBegin = shiftEvent,
        InputEnd = shiftEvent,
    }

    return keybinds
end)()
