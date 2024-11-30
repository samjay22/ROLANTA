--!strict

--Format is NON_NULL/IS_NULL DATA_TYPE DEFAULT_VALUE
return function (schemeSet : any)
    local defaultData = {}
    for key, scheme in schemeSet do
        local splitScheme = string.split(scheme, " ")
        local IS_NULL, DATA_TYPE, DEFAULT_VALUE = splitScheme[1] == "IS_NULL", splitScheme[2]:lower(), splitScheme[3]
        
        if IS_NULL then
            continue
        end

        local defaultValue = (DATA_TYPE == "number" and tonumber(DEFAULT_VALUE)) 
        or (DATA_TYPE == "table" and {}) or (DATA_TYPE == "string" and tostring(DEFAULT_VALUE))
    end
    
    return defaultData
end