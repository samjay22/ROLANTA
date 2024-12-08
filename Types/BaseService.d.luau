--!strict
export type BaseService<T> = {
    Name : string,
    ClassName : string,
    Update : (self : T, dt : number) -> nil?
} & T

type ICharacterService = {
    GetCurrentCharacterForPlayer : (self : ICharacterService, player : Player) -> Model?,
    UpdateCurrentCharacterForPlayer : (self : ICharacterService, player : Player, character : Model) -> nil,
    UpdateCharacterState : (self : ICharacterService, player : Player, state : number, value : any?) -> nil,
    
    EquipItemToLocalPlayer : (self : ICharacterService, player : Player, tool : Tool) -> nil,
    UnequipItemFromLocalPlayer : (self : ICharacterService, player : Player) -> nil,

    CleanupCharacter : (self : ICharacterService, player : Player) -> nil,

    LoadCharacter : (self :  ICharacterService, player : Player) -> nil,
}

type ICharacterActionService = {
    Sprint : (self : ICharacterActionService, state : Enum.UserInputState) -> nil,
}

type IToolService = {
    ActivateTool : (self : IToolService, player : Player) -> nil,

    EquipTool : (self : IToolService, player : Player, tool : Tool) -> nil,
    UnequipTool : (self : IToolService, player : Player) -> nil,
}

export type ToolService = BaseService<IToolService>
export type CharacterActionService = BaseService<ICharacterActionService>
export type CharacterService = BaseService<ICharacterService>

return 0