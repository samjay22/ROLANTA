--!strict
local InsertService : InsertService = shared:GetService("InsertService")

---Lets take advantage of roblox CDN
local Directory = {}
local LoadedAssets : {Asset} = {}

local LOADED : boolean = false

function Directory.GetAssetFromLibrary(name : string) : Asset
    repeat task.wait() until LOADED
    local foundAsset : Asset? = nil
    for _, asset : Asset in LoadedAssets do
        if asset.Name == name then
            foundAsset = asset
            break    
        end
    end

    assert(foundAsset, `No asset found under name {name}!`)
    return foundAsset
end


--load assets
task.spawn(function()
    for _, mod in script:GetChildren() do
        for _, asset : Asset in require(mod) do
            local assetIdToLoad : number = asset.Id
            local loadedAsset : Instance = InsertService:LoadAsset(assetIdToLoad)
            local item = unpack(loadedAsset:GetChildren())
            warn(item)
            asset.Prefab = item
            table.insert(LoadedAssets, asset)
        end
    end

    LOADED = true
end)

return Directory
