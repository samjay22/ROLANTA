--!strict

export type Enums = Enum & {
    CharacterState : {
        IsRunning : number,
        IsDown : number,
        IsBleeding : number,
        IsCrouched : number,
        IsDamageImmune : number,
        IsToolEquipped : number,
    },
}

declare shared: {
    GetService : <T>(self : any, serviceName : string) -> T,
    FindService : <T>(self : any, serviceName : string) -> T?,
    RegisterService : (self : any, serviceName : string) -> boolean,

    CreateSubscriptionEvent : (self : any, eventKey : any) -> BindableEvent,
    GetSubscriptionEvent : (self : any, eventKey : any) -> BindableEvent,

    SendRequest : (self : any, player : Player, requestEndpoint : string, requestData : any?) ->( {[string] : any, RequestSender : RemoteEvent | RemoteFunction, AddToQueue : boolean}, BindableEvent),
    
    Enums : Enums & typeof(Enum)   
}

export type Delegate = (...any) -> (...any)

export type Asset = {
    Prefab : Instance?,
    SystemId : number,
    AssetId : number,
    DisplayName : string,
    SystemName : string,
}