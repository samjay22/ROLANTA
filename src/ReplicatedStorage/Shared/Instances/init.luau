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
        if asset.SystemName == name then
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
            local assetIdToLoad : number = asset.AssetId
            local loadedAsset : Instance = InsertService:LoadAsset(assetIdToLoad)
            local item = unpack(loadedAsset:GetChildren())
            
            --If it should be a tool
            local hasTrigger : Instance? = item and (item:FindFirstChild("Trigger") or  item:FindFirstChild("Tip"))
            if item and  hasTrigger then
                local itemCopy = item
                item = Instance.new("Tool")
                for _, p : Instance in itemCopy:GetChildren() do
                    p.Parent = item
                end                
                item.Name = asset.SystemName
                hasTrigger.Name = "Handle"
            end

            asset.Prefab = item
            table.insert(LoadedAssets, asset)
        end
    end

    LOADED = true
end)

return Directory
