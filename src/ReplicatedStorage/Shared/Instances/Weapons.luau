--!strict
local weaponList =  {} :: {Asset}

local function _addWeapon(systemName : string, displayName : string, assetId : number)
    table.insert(weaponList, {
        DisplayName = displayName,
        SystemName = systemName,
        AssetId = assetId,
        SystemId = #weaponList + 1
    })
end


_addWeapon("Advanced_Rifle", "Advanced Rifle", 83808311229653)
_addWeapon("Advanced_Rifle_MK_II", "Advanced Rifle MK II", 97988446263795)

_addWeapon("Light_Pistol", "Light Pistol", 82857073527674)
_addWeapon("AP_Pistol", "AP Pistol", 76737220251001)
_addWeapon("Heavy_Pistol", "Heavy_Pistol", 90640750936332)

_addWeapon("Heavy_Rifle", "Heavy Rifle", 109381925065282)
_addWeapon("SMG", "SMG", 131446671890195)
_addWeapon("SMG_MK_II", "SMG MK II", 96509016095637)

_addWeapon("Assault_Rifle", "Assult Rifle", 90092481706594)
_addWeapon("Heavy_Assault_Rifle", "Heavy Assault Rifle", 133496639361998)

_addWeapon("Revolver", "Revolver", 102857259515974)

_addWeapon("Combat_Shotgun", "Combat Shotgun", 111033819822935)
_addWeapon("Automatic_Combat_Pistol", "Automatic Combat Pistol", 106879438336430)
_addWeapon("Combat_Machinegun", "Combat Machinegun", 126829073620171)
_addWeapon("Combat_Sniper_Rifle", "Combat Sniper Rifle", 138779509891508)
_addWeapon("Combat_Rifle", "Combat Rifle", 123278352640226)

_addWeapon("Tactical_Shotgun", "Tactical Shotgun", 77781008152441)
_addWeapon("Tactical_Rifle", "Tactical Rifle", 124003837854972)
_addWeapon("Tactical_Sniper_Rifle", "Tactical Sniper Rifle", 127979400072005)
_addWeapon("Tactical_Shotgun_MK_II", "Tactical Shotgun MK II", 124727644495957)

_addWeapon("Pump_Shotgun", "Pump Shotgun", 108043850678670)

_addWeapon("Bat", "Bat", 118660524019803)
_addWeapon("Baton", "Baton", 134244335804890)
_addWeapon("Crowbar", "Crowbar", 126778243540150)

_addWeapon("Grenade", "Grenade", 122304498766091)
_addWeapon("Sticky_Grenade", "Sticky Grenade", 116949564800461)


return weaponList
