--!strict
local Players : Players = shared:GetService("Players")

local Service = {}

type Character = {
    CurrentModel : Model?,
    CurrentHumanoid : Humanoid?,

    --For enums
    [number] : boolean?
}

local CharacterData : {[number] : Character} = {}
local CharacterDataMapping : {number} = {}

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

function Service:LoadCharacter(player : Player)
    local characterModelClone : Model = game.ReplicatedStorage.Shared.Instances.Characters.StarterCharacter:Clone()

    local characterData : Character = {
        CurrentModel = characterModelClone,
        CurrentHumanoid = characterModelClone:WaitForChild("Humanoid") :: Humanoid,
    }

    characterModelClone.Humanoid.Died:Connect(function()
        Service:CleanupCharacter(player)
    end)

    characterData[shared.Enums.CharacterState.IsBleeding] = false
    characterData[shared.Enums.CharacterState.IsCrouched] = false
    characterData[shared.Enums.CharacterState.IsDamageImmune] = false
    characterData[shared.Enums.CharacterState.IsDown] = false
    characterData[shared.Enums.CharacterState.IsRunning] = false
    characterData[shared.Enums.CharacterState.IsToolEquipped] = false

    CharacterData[player.UserId] = characterData
    
    table.insert(CharacterDataMapping, player.UserId)

    game.re
    characterModelClone.Parent = game.Workspace
    player.Character = characterModelClone
end


function Service:CleanupCharacter(player : Player)
    local charData : Character = _GetCharacterData(player)
    local char : Model = Service:GetCurrentCharacterForPlayer(player) :: any
    char:Destroy()

    charData[shared.Enums.CharacterState.IsBleeding] = false
    charData[shared.Enums.CharacterState.IsCrouched] = false
    charData[shared.Enums.CharacterState.IsDamageImmune] = false
    charData[shared.Enums.CharacterState.IsDown] = false
    charData[shared.Enums.CharacterState.IsRunning] = false
    charData[shared.Enums.CharacterState.IsToolEquipped] = false

    table.remove(CharacterDataMapping, table.find(CharacterDataMapping, player.UserId))
end

function Service:UpdateCharacterState(player : Player, state : number, value : any?)
    local charData : Character = _GetCharacterData(player)
    assert(charData[state] ~= nil, `{state} is not a valid character state!`)

    charData[state] = value :: any
end

function Service:Update(dt : number)
    for _ : number, userId : number in CharacterDataMapping do
        local charData = CharacterData[userId]
        if charData[shared.Enums.CharacterState.IsBleeding] then
            charData.CurrentHumanoid:TakeDamage(10 * dt)
        else
            charData.CurrentHumanoid.Health += (1) * dt
        end
    end
end

return Service