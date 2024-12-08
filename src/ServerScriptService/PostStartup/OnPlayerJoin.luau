--!strict
local Players : Players = shared:GetService("Players")
local CharacterService : CharacterService = shared:GetService("CharacterService")

Players.PlayerAdded:Connect(function(player : Player)
    CharacterService:LoadCharacter(player)
end)


return 0