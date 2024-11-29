--!strict
export type BaseService<T> = {
    Name : string,
    ServiceId : string,
} & T

return 0