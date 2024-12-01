--!strict
declare shared: {
    GetService : <T>(self : any, serviceName : string) -> T?,
    FindService : <T>(self : any, serviceName : string) -> T?,
    RegisterService : (self : any, serviceName : string) -> boolean,

    CreateSubscriptionEvent : (self : any, eventKey : any) -> BindableEvent,
    GetSubscriptionEvent : (self : any, eventKey : any) -> BindableEvent,
}

export type Delegate = (...any) -> (...any)