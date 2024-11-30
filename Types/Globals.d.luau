--!strict
declare shared: {
    GetService : <T>(self : any, serviceName : string) -> T?,
    FindService : <T>(self : any, serviceName : string) -> T?,
    RegisterService : (self : any, serviceName : string) -> boolean,
}

export type Delegate = (...any) -> (...any)