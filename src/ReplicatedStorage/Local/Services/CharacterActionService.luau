--!strict
local Players : Players = shared:GetService("Players")

local Service = {}

function Service:Sprint(state : Enum.UserInputState)
    local player : Player = Players.LocalPlayer
    local character = player.Character
    assert(character, `No character for {player.Name}`)
    
    local humanoid : Humanoid = character:FindFirstChild("Humanoid") :: Humanoid
    local isRunning : boolean = state == Enum.UserInputState.Begin

    if isRunning then
        humanoid.WalkSpeed = 22
    else
        humanoid.WalkSpeed = 16
    end

    local otherArgs, onCompleted = shared:SendRequest(player, "ActivateSprint", {Active = isRunning})
    otherArgs.RequestSender = game.ReplicatedStorage.Shared.Remotes.RemoteFunction
    otherArgs.AddToQueue = true

    local isValid : boolean = onCompleted.Event:Wait()
    if not isValid then
        humanoid.WalkSpeed = 16
        warn(`Player {player.Name} is not allowed to sprint`)
    end
end

return Service