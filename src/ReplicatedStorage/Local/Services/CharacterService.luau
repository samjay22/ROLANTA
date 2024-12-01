--!strict
local Players : Players = shared:GetService("Players")

local Service = {}

type Character = {
    CurrentTool : Tool?,
    CurrentModel : Model?,
    CurrentHumanoid : Humanoid?,
    
    CurrentAnimations : {
        [string] : AnimationTrack,
    },

    IsRunning : boolean,
    IsDown : boolean,
    IsBleeding : boolean,
    IsCrouched : boolean,
    IsDamageImmune : boolean,
} 

local CharacterData : {[number] : Character} = {}

local function _GetCharacterData(player : Player)
    local charData : Character? = CharacterData[player.UserId]
    assert(charData, `No character data found for user {player}`)

    return charData
end

function _GetHumanoidFromCharacterData(player : Player)
    local charData : Character = _GetCharacterData(player)
    local humanoid : Humanoid? = charData.CurrentHumanoid
    assert(humanoid, `Cannot find humanoid for character {player}`)

    return humanoid
end

function Service:GetCurrentCharacterForPlayer(player : Player)
    local charData : Character = _GetCharacterData(player)

    return charData.CurrentModel
end

function Service:UpdateCurrentCharacterForPlayer(player : Player, model : Model & {Humanoid : Humanoid})
    local characterData = _GetCharacterData(player)
    characterData.CurrentModel = model
    characterData.CurrentHumanoid = model:FindFirstAncestorWhichIsA("Humanoid") :: Humanoid
    player.Character = model

end

function Service:EquipItemToLocalPlayer(player : Player, tool : Tool)
    local charData : Character = _GetCharacterData(player)
    local humanoid : Humanoid = _GetHumanoidFromCharacterData(player)
    humanoid:EquipTool(tool)

    charData.CurrentTool = tool
end


function Service:UnequipItemFromLocalPlayer(player : Player)
    local charData : Character = _GetCharacterData(player)
    local humanoid : Humanoid = _GetHumanoidFromCharacterData(player)
    local tool : Tool? = charData.CurrentTool
    assert(tool, `Cannot remove tool from user {player} as it does not exist.`)
    humanoid:UnequipTools()

    charData.CurrentTool = nil
end


function Service:CleanupCharacter(player : Player)
    local charData : Character = _GetCharacterData(player)
    local char : Model = Service:GetCurrentCharacterForPlayer(player) :: any
    char:Destroy()
    charData.IsBleeding = false
    charData.IsCrouched = false
    charData.IsDamageImmune = false
    charData.IsDown = false
    charData.IsRunning = false
end

function Service:Sprint(state : Enum.UserInputState)
    local player : Player = Players.LocalPlayer
    local humanoid : Humanoid = _GetHumanoidFromCharacterData(player)
    local characterData : Character = _GetCharacterData(player)

    characterData.IsRunning = state == Enum.UserInputState.Begin

    if characterData.IsRunning then
        humanoid.WalkSpeed = 22
    else
        humanoid.WalkSpeed = 16
    end
end

return Service