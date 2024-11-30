--!strict
local DataService : DataStoreService = shared:GetService("DataStoreService")

local ConvertSchemeToData = require(game.ServerStorage.DataSchemes.ConvertSchemeToDefaultData)

local Service = {}
local Tables : {DataStore} = {}

function Service:GetTable(tableName : string) : DataStore?
    local foundTable : DataStore? = nil
    for _, table in Tables do
        if table.Name == tableName  then
            foundTable = table
        end
    end

    return foundTable
end

function Service:LoadTable(tableName : string, scope : string?, options : DataStoreOptions?)
    local dataTable : DataStore = DataService:GetDataStore(tableName, scope, options)
    table.insert(Tables, dataTable)
end

local function _validateDataSchmea(schema, data)
    for key, value in data do
        if schema[key] and string.split(schema[key], " ")[1]:lower() == string.lower("NON_NULL") then
            error(`Data does not have field that exists for field {key}`)
        end
        
        if schema[key] and string.split(schema[key], " ")[2]:lower() ~= typeof(value):lower() then
            error(`Data type does not have correct type for field {key}`)
        end

        if not schema[key] then
            error(`Schema does not have field that exists for field {key}`)
        end

    end
end

function Service:LoadData(tableName : string, loadKey : string, dataScheme : any?)
    local dataTable : DataStore? = self:GetTable(tableName)
    assert(dataTable, `No table found under name {tableName}`)

    return dataTable:GetAsync(loadKey) or ConvertSchemeToData(dataScheme)
end

function Service:SaveDataFromDataSchema(tableName : string, saveKey : string, schema : any, dataToSave : any)
    local dataTable : DataStore? = self:GetTable(tableName)
    assert(dataTable, `No table found under name {tableName}`)

    _validateDataSchmea(schema, dataToSave)

    dataTable:UpdateAsync(saveKey, function(old : any)
        return dataToSave or old
    end)
end

return Service