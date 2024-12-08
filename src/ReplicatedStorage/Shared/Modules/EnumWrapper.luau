--!strict
local CharacterStates = {
    IsRunning = 1,
    IsDown = 2,
    IsBleeding = 3,
    IsCrouched = 4,
    IsDamageImmune = 5,
    IsToolEquipped = 6,
}

shared.Enums = setmetatable({}, {__index = Enum}) :: any
shared.Enums.CharacterState = CharacterStates

return 0