--!strict
export type BaseService<T> = {
    Name : string,
    ClassName : string,
} & T

return 0