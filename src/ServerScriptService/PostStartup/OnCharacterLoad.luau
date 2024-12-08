--!strict
local RunService : RunService = shared:GetService("RunService")
local CharacterService : CharacterService = shared:GetService("CharacterService")
local Players : Players = shared:GetService("Players")

Players.PlayerAdded:Connect(function(player : Player)
    player.CharacterAdded:Connect(function(character : Model)
        CharacterService:UpdateCharacterState(player, shared.Enums.CharacterState.IsBleeding, true)
        task.wait(5)
        CharacterService:UpdateCharacterState(player, shared.Enums.CharacterState.IsBleeding, false)
    end)
end)


RunService.Heartbeat:Connect(function(dt : number)
    CharacterService:Update(dt)
end)


return 0