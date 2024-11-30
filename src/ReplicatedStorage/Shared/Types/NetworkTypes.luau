--!strict
export type Request<T> = {
    Player : Player,
    Endpoint : string,
    Traceback : string,
    Data : T,

    --Do we process in the queue? Can be used to determine if it needs to be sync not async
    AddToQueue : boolean,
}

return 0