--!strict
local EventCollection : {[string] : BindableEvent} = {}
function shared:CreateSubscriptionEvent(eventKey : any)
    local event : BindableEvent = Instance.new("BindableEvent")
    EventCollection[eventKey] = event

    return event
end

function shared:GetSubscriptionEvent(eventKey : any)
    return EventCollection[eventKey]
end

return 0