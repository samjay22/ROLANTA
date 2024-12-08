--!strict
local Instances = require(game.ReplicatedStorage.Shared.Instances)

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
    local characterAsset: Asset = Instances.GetAssetFromLibrary("DefaultCharacter")
    local charaterModel : Model? = characterAsset.Prefab:Clone() :: any

    local characterData : Character = {
        CurrentModel = charaterModel,
        CurrentHumanoid = charaterModel:WaitForChild("Humanoid") :: Humanoid,
    }

    characterData.CurrentHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Subject

    charaterModel.Humanoid.Died:Connect(function()
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

    charaterModel.Name = player.Name
    player.Character = charaterModel
    charaterModel.Parent = game.Workspace
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