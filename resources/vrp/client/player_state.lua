
-- periodic player state update

local state_ready = false
local customization_changed = false

AddEventHandler("playerSpawned",function() -- delay state recording
  state_ready = false

  Citizen.CreateThread(function()
    Citizen.Wait(30000)
    state_ready = true
  end)
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(30000)

    if IsPlayerPlaying(PlayerId()) and state_ready then
      local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
      --vRPserver.ping({})
      vRPserver.updatePos({x,y,z})
      vRPserver.updateHealth({tvRP.getHealth()})
      vRPserver.updateWeapons({tvRP.getWeapons()})
      if customization_changed then
        vRPserver.updateCustomization({tvRP.getCustomization()})
        customization_changed = false
      end
    end
  end
end)

-- WEAPONS

-- def
local weapon_types = {
    "WEAPON_KNIFE",
    "WEAPON_NIGHTSTICK",
    "WEAPON_HAMMER",
    "WEAPON_BAT",
    "WEAPON_GOLFCLUB",
    "WEAPON_CROWBAR",
    "WEAPON_BOTTLE",
    "WEAPON_SWITCHBLADE",
    "WEAPON_PISTOL",
    "WEAPON_COMBATPISTOL",
    "WEAPON_APPISTOL",
    "WEAPON_PISTOL50",
    "WEAPON_FLAREGUN",
    "WEAPON_MARKSMANPISTOL",
    "WEAPON_REVOLVER",
    "WEAPON_MICROSMG",
    "WEAPON_SMG",
    "WEAPON_ASSAULTSMG",
    "WEAPON_COMBATPDW",
    "WEAPON_ASSAULTRIFLE",
    "WEAPON_CARBINERIFLE",
    "WEAPON_ADVANCEDRIFLE",
    "WEAPON_COMPACTRIFLE",
    "WEAPON_MG",
    "WEAPON_COMBATMG",
    "WEAPON_PUMPSHOTGUN",
    "WEAPON_SAWNOFFSHOTGUN",
    "WEAPON_ASSAULTSHOTGUN",
    "WEAPON_BULLPUPSHOTGUN",
    "WEAPON_DOUBLEBARRELSHOTGUN",
    "WEAPON_STUNGUN",
    "WEAPON_SNIPERRIFLE",
    "WEAPON_HEAVYSNIPER",
    "WEAPON_GRENADELAUNCHER",
    "WEAPON_GRENADELAUNCHERSMOKE",
    "WEAPON_RPG",
    "WEAPON_MINIGUN",
    "WEAPON_GRENADE",
    "WEAPON_STICKYBOMB",
    "WEAPON_SMOKEGRENADE",
    "WEAPON_BZGAS",
    "WEAPON_MOLOTOV",
    "WEAPON_FIREEXTINGUISHER",
    "WEAPON_PETROLCAN",
    "WEAPON_SNSPISTOL",
    "WEAPON_SPECIALCARBINE",
    "WEAPON_HEAVYPISTOL",
    "WEAPON_BULLPUPRIFLE",
    "WEAPON_HOMINGLAUNCHER",
    "WEAPON_PROXIMITYMINE",
    "WEAPON_SNOWBALL",
    "WEAPON_VINTAGEPISTOL",
    "WEAPON_DAGGER",
    "WEAPON_FIREWORK",
    "WEAPON_MUSKET",
    "WEAPON_MARKSMANRIFLE",
    "WEAPON_HEAVYSHOTGUN",
    "WEAPON_GUSENBERG",
    "WEAPON_HATCHET",
    "WEAPON_RAILGUN",
    "WEAPON_KNUCKLEDUSTER",
    "WEAPON_MACHETE",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_FLASHLIGHT",
    "WEAPON_BALL",
    "WEAPON_FLARE",
    "WEAPON_NIGHTVISION",
    "WEAPON_PARACHUTE",
    "WEAPON_SWEEPERSHOTGUN",
    "WEAPON_BATTLEAXE",
    "WEAPON_COMPACTGRENADELAUNCHER",
    "WEAPON_MINISMG",
    "WEAPON_PIPEBOMB",
    "WEAPON_POOLCUE",
    "WEAPON_WRENCH",
    "WEAPON_PISTOL_MK2",
    "WEAPON_ASSAULTRIFLE_MK2",
    "WEAPON_CARBINERIFLE_MK2",
    "WEAPON_COMBATMG_MK2",
    "WEAPON_HEAVYSNIPER_MK2",
    "WEAPON_SMG_MK2",
    "WEAPON_REVOLVER_MK2",
    "WEAPON_SPECIALCARBINE_MK2",
    "WEAPON_MARKSMANRIFLE_MK2",
    "WEAPON_PUMPSHOTGUN_MK2",
    "WEAPON_SNSPISTOL_MK2",
    "WEAPON_BULLPUPRIFLE_MK2",
    "WEAPON_DOUBLEACTION",
    "WEAPON_STONEHATCHET",
    "WEAPON_RAYPISTOL",
    "WEAPON_RAYMINIGUN",
    "WEAPON_RAYCARBINE"
}

local weapon_hashes = {
  {"WEAPON_KNIFE",-1716189206},
  {"WEAPON_DAGGER",-1834847097},
  {"WEAPON_BOTTLE",-102323637},
  {"WEAPON_FLASHLIGHT",2343591895},
  {"WEAPON_NIGHTSTICK",1737195953},
  {"WEAPON_HAMMER",1317494643},
  {"WEAPON_BAT",-1786099057},
  {"WEAPON_GOLFCLUB",1141786504},
  {"WEAPON_CROWBAR",-2067956739},
  {"WEAPON_PISTOL",453432689},
  {"WEAPON_SNSPISTOL",-1076751822},
  {"WEAPON_COMBATPISTOL",1593441988},
  {"WEAPON_HEAVYPISTOL",3523564046},
  {"WEAPON_PISTOL50",-1716589765},
  {"WEAPON_VINTAGEPISTOL",137902532},
  {"WEAPON_PISTOL_MK2",-1075685676},
  --{"WEAPON_MACHINEPISTOL",222222222},
  --{"WEAPON_MICROSMG",222222222},
  {"WEAPON_SMG",736523883},
  {"WEAPON_CARBINERIFLE",2210333304},
  {"WEAPON_SPECIALCARBINE",3231910285},
  {"WEAPON_PUMPSHOTGUN",487013001},
  {"WEAPON_STUNGUN",911657153},
  {"WEAPON_FIREEXTINGUISHER",101631238},
  --{"WEAPON_PETROLCAN",222222222},
  {"WEAPON_FLARE",1233104067},
  {"WEAPON_REVOLVER",-1045183535},
  {"WEAPON_SWITCHBLADE",-538741184},
  {"WEAPON_BATTLEAXE",-853065399},
  {"WEAPON_POOLCUE",-1810795771},
  {"WEAPON_WRENCH",419712736},
  {"WEAPON_DOUBLEACTION",-1746263880},
}

function tvRP.getWeaponTypes()
  return weapon_types
end

function tvRP.getWeapons()
  local player = GetPlayerPed(-1)

  local ammo_types = {} -- remember ammo type to not duplicate ammo amount

  local weapons = {}
  for k,v in pairs(weapon_types) do
    local hash = GetHashKey(v)
    if HasPedGotWeapon(player,hash) then
      local weapon = {}
      weapons[v] = weapon

      local atype = Citizen.InvokeNative(0x7FEAD38B326B9F74, player, hash)
      if ammo_types[atype] == nil then
        ammo_types[atype] = true
        weapon.ammo = GetAmmoInPedWeapon(player,hash)
      else
        weapon.ammo = 0
      end
    end
  end

  return weapons
end

local owns_shotgun = false
local owns_smg = false
local stored_shotgun = false
local shotgun_ammo = 0
local stored_smg = false
local smg_ammo = 0

function tvRP.storeCopWeapon(weaponName)
  if weaponName ~= nil then
    weaponName = string.upper(weaponName)
    if weaponName == "WEAPON_PUMPSHOTGUN" then
      if HasPedGotWeapon(GetPlayerPed(-1),GetHashKey(weaponName))  then
        tvRP.removeWeapon(weaponName)
      elseif (stored_shotgun or owns_shotgun) then
        giveStoredWeapon(weaponName)
      end
    elseif weaponName == "WEAPON_SMG" then
      if HasPedGotWeapon(GetPlayerPed(-1),GetHashKey(weaponName))  then
        tvRP.removeWeapon(weaponName)
      elseif (stored_smg or owns_smg) then
        giveStoredWeapon(weaponName)
      end
    end
  end
end

function giveStoredWeapon(weaponName)
  if weaponName ~= nil then
    local player = GetPlayerPed(-1)
    weaponName = string.upper(weaponName)
    local hash = GetHashKey(weaponName)
    if weaponName == "WEAPON_PUMPSHOTGUN" and (stored_shotgun or owns_shotgun) then
      stored_shotgun = false
      GiveWeaponToPed(player, hash, shotgun_ammo, false)
      SetPedAmmo(player, hash, shotgun_ammo)
      tvRP.notify("Shotgun Received")
    elseif weaponName == "WEAPON_SMG" and (stored_smg or owns_smg) then
      stored_smg = false
      GiveWeaponToPed(player, hash, smg_ammo, false)
      SetPedAmmo(player, hash, smg_ammo)
      tvRP.notify("SMG Received")
    end
  end
end

function tvRP.removeWeapon(weaponName)
  if weaponName ~= nil then
    tvRP.setActionLock(true)
    weaponName = string.upper(weaponName)
    local player = GetPlayerPed(-1)
    local hash = GetHashKey(weaponName)
    if HasPedGotWeapon(player,hash) then
      if weaponName == "WEAPON_PUMPSHOTGUN" then
        stored_shotgun = true
        owns_shotgun = true
        shotgun_ammo = GetAmmoInPedWeapon(player, hash)
        tvRP.notify("Shotgun Removed")
      elseif weaponName == "WEAPON_SMG" then
        stored_smg = true
        owns_smg = true
        smg_ammo = GetAmmoInPedWeapon(player, hash)
        tvRP.notify("SMG Removed")
      end
      RemoveWeaponFromPed(player,hash)
      tvRP.RemoveGear(weaponName)
      SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
    end
    Citizen.Wait(1000) -- Artificial wait. Need to add progress bar
    tvRP.setActionLock(false)
  end
end

function tvRP.giveWeapons(weapons,clear_before)
  local player = GetPlayerPed(-1)

  -- give weapons to player

  if clear_before then
    tvRP.RemoveGears()
    RemoveAllPedWeapons(player,true)
  end

  for k,weapon in pairs(weapons) do
    local hash = GetHashKey(k)
    local ammo = weapon.ammo or 0

    GiveWeaponToPed(player, hash, ammo, false)
  end
end

function tvRP.removeAmmo(weapon, ammoQtyRemove)
  tvRP.setActionLock(true)
  local weaponHash = GetHashKey(weapon)
  local ped = GetPlayerPed(-1)
  local ammo = GetAmmoInPedWeapon(ped,weaponHash)
  local newQty = ammo - ammoQtyRemove
  if newQty >= 0 then
    SetPedAmmo(ped, weaponHash, newQty)
  end
  Citizen.Wait(1000) -- Artificial wait. Need to add progress bar
  tvRP.setActionLock(false)
end

function tvRP.getCurrentWeapon()
  local ped = GetPlayerPed(-1)
  local _, hash = GetCurrentPedWeapon(ped, true)
  print('weapon = '..hash)
  for k,v in pairs(weapon_hashes) do
    if v[2] == hash then
      local ammo = GetAmmoInPedWeapon(ped,hash)
      return v[1], ammo
    end
  end
  return nil
end

--[[
function tvRP.dropWeapon()
  SetPedDropsWeapon(GetPlayerPed(-1))
end
--]]

-- PLAYER CUSTOMIZATION

-- parse part key (a ped part or a prop part)
-- return is_proppart, index
local function parse_part(key)
  if type(key) == "string" and string.sub(key,1,1) == "p" then
    return true,tonumber(string.sub(key,2))
  else
    return false,tonumber(key)
  end
end

function tvRP.getDrawables(part)
  local isprop, index = parse_part(part)
  if isprop then
    return GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1),index)
  else
    return GetNumberOfPedDrawableVariations(GetPlayerPed(-1),index)
  end
end

function tvRP.getDrawableTextures(part,drawable)
  local isprop, index = parse_part(part)
  if isprop then
    return GetNumberOfPedPropTextureVariations(GetPlayerPed(-1),index,drawable)
  else
    return GetNumberOfPedTextureVariations(GetPlayerPed(-1),index,drawable)
  end
end

function tvRP.getCustomization()
  local ped = GetPlayerPed(-1)

  local custom = {}

  custom.modelhash = GetEntityModel(ped)

  -- ped parts
  for i=0,20 do -- index limit to 20
    custom[i] = {GetPedDrawableVariation(ped,i), GetPedTextureVariation(ped,i), GetPedPaletteVariation(ped,i)}
  end

  -- props
  for i=0,10 do -- index limit to 10
    custom["p"..i] = {GetPedPropIndex(ped,i), math.max(GetPedPropTextureIndex(ped,i),0)}
  end

  return custom
end

-- partial customization (only what is set is changed)
function tvRP.setCustomization(custom, update) -- indexed [drawable,texture,palette] components or props (p0...) plus .modelhash or .model

  Citizen.CreateThread(function() -- new thread
    if custom then
      local ped = GetPlayerPed(-1)
      local user_id = tvRP.getMyVrpId()
      local mhash = nil

      -- model
      if custom.modelhash ~= nil then
        mhash = custom.modelhash
      elseif custom.model ~= nil then
        mhash = GetHashKey(custom.model)
      end

      ped = GetPlayerPed(-1)
      playerModel = GetEntityModel(ped)


      if mhash ~= nil and mhash ~= playerModel then
        local i = 0
        while not HasModelLoaded(mhash) and i < 10000 do
          RequestModel(mhash)
          Citizen.Wait(10)
        end

        if HasModelLoaded(mhash) then
          -- changing player model remove weapons, so save it
          local currentHealth = tvRP.getHealth()
          local weapons = tvRP.getWeapons()
          SetPlayerModel(PlayerId(), mhash)
          tvRP.giveWeapons(weapons,true)
          SetModelAsNoLongerNeeded(mhash)
          tvRP.setHealth(currentHealth)
        end
      end

      local hashMaleMPSkin = GetHashKey("mp_m_freemode_01")
      local hashFemaleMPSkin = GetHashKey("mp_f_freemode_01")
      -- prevent cop uniform on non cops
      if not tvRP.isCop() and not tvRP.isMedic() then
        if playerModel == hashMaleMPSkin then
          if (custom[4] ~= nil and (custom[4][1] == 19 or custom[4][1] == 32 or custom[4][1] == 43)) or
            (custom[5] ~= nil and (custom[5][1] == 37 or custom[5][1] == 38 or custom[5][1] == 52 or custom[5][1] == 59 or custom[5][1] == 70 or custom[5][1] == 74)) or
            (custom[7] ~= nil and (custom[7][1] == 20 or custom[7][1] == 30 or custom[7][1] == 125 or custom[7][1] == 126 or custom[7][1] == 127 or custom[7][1] == 128)) or
            (custom[8] ~= nil and (custom[8][1] == 19 or custom[8][1] == 38 or custom[8][1] == 39 or custom[8][1] == 42 or custom[8][1] == 44 or custom[8][1] == 49 or custom[8][1] == 53 or
             custom[8][1] == 55 or custom[8][1] == 56 or custom[8][1] == 57 or custom[8][1] == 58 or custom[8][1] == 65 or custom[8][1] == 66 or custom[8][1] == 67 or custom[8][1] == 68 or
             custom[8][1] == 104 or custom[8][1] == 105 or custom[8][1] == 106 or custom[8][1] == 131)) or
            (custom[9] ~= nil and ((custom[9][1] == 4 and (custom[9][2] == 2 or custom[9][2] == 3 or custom[9][2] == 4)) or custom[9][1] == 5 or custom[9][1] == 7 or custom[9][1] == 10 or custom[9][1] == 12 or custom[9][1] == 16 or
             custom[9][1] == 18 or custom[9][1] == 19 or custom[9][1] == 21 or custom[9][1] == 24 or custom[9][1] == 26 or custom[9][1] == 28)) or
            (custom[11] ~= nil and (custom[11][1] == 39 or custom[11][1] == 55 or custom[11][1] == 74 or custom[11][1] == 75 or custom[11][1] == 77 or custom[11][1] == 80 or custom[11][1] == 93 or
             custom[11][1] == 118 or (custom[11][1] == 151 and (custom[11][2] == 2 or custom[11][2] == 3 or custom[11][2] == 4 or custom[11][2] == 5)) or custom[11][1] == 154 or (custom[11][1] == 188 and (custom[11][2] == 6 or
             custom[11][2] == 7 or custom[11][2] == 9)) or (custom[11][1] == 189 and (custom[11][2] == 6 or custom[11][2] == 7 or custom[11][2] == 9)) or custom[11][1] == 190 or custom[11][1] == 193 or custom[11][1] == 200 or custom[11][1] == 217 or
             (custom[11][1] == 218 and (custom[11][2] == 8)) or custom[11][1] == 249 or custom[11][1] == 250)) or
            (custom["p0"] ~= nil and (custom["p0"][1] == 10 or custom["p0"][1] == 17 or custom["p0"][1] == 45 or custom["p0"][1] == 46 or custom["p0"][1] == 122)) then
            return
          end
        end
        if playerModel == hashFemaleMPSkin then
          if (custom[4] ~= nil and (custom[4][1] == 18 or custom[4][1] == 31 or custom[4][1] == 48)) or
            (custom[5] ~= nil and (custom[5][1] == 37 or custom[5][1] == 38 or custom[5][1] == 52 or custom[5][1] == 59 or custom[5][1] == 70)) or
            (custom[7] ~= nil and (custom[7][1] == 4 or custom[7][1] == 12 or custom[7][1] == 14 or custom[7][1] == 95 or custom[7][1] == 97 or custom[7][1] == 98)) or
            (custom[8] ~= nil and (custom[8][1] == 2 or custom[8][1] == 3 or custom[8][1] == 8 or custom[8][1] == 18 or custom[8][1] == 19 or custom[8][1] == 27 or custom[8][1] == 30 or custom[8][1] == 31 or custom[8][1] == 32 or
             custom[8][1] == 33 or custom[8][1] == 34 or custom[8][1] == 35 or custom[8][1] == 48 or custom[8][1] == 49 or custom[8][1] == 51 or custom[8][1] == 52 or custom[8][1] == 66 or custom[8][1] == 67 or custom[8][1] == 78 or
             custom[8][1] == 79 or custom[8][1] == 80 or custom[8][1] == 81 or custom[8][1] == 142 or custom[8][1] == 143 or custom[8][1] == 144 or custom[8][1] == 149 or custom[8][1] == 159 or custom[8][1] == 161)) or
            (custom[9] ~= nil and ((custom[9][1] == 3 and (custom[9][2] == 2 or custom[9][2] == 3 or custom[9][2] == 4)) or (custom[9][1] == 4 and (custom[9][2] == 2 or custom[9][2] == 4)) or custom[9][1] == 7 or custom[9][1] == 9 or
             custom[9][1] == 11 or custom[9][1] == 18 or custom[9][1] == 19 or custom[9][1] == 22 or custom[9][1] == 26 or
             custom[9][1] == 28 or custom[9][1] == 30 or custom[9][1] == 31)) or
            (custom[11] ~= nil and (custom[11][1] == 18 or custom[11][1] == 25 or custom[11][1] == 26 or custom[11][1] == 48 or custom[11][1] == 64 or custom[11][1] == 73 or custom[11][1] == 84 or
             (custom[11][1] == 148 and (custom[11][2] == 2 or custom[11][2] == 3 or custom[11][2] == 4 or custom[11][2] == 5)) or custom[11][1] == 151 or custom[11][1] == 172 or
             (custom[11][1] == 190 and (custom[11][2] == 6 or custom[11][2] == 7 or custom[11][2] == 9)) or (custom[11][1] == 191 and (custom[11][2] == 6 or custom[11][2] == 7 or custom[11][2] == 9)) or custom[11][1] == 192 or custom[11][1] == 195 or
              custom[11][1] == 202 or custom[11][1] == 224 or custom[11][1] == 257 or custom[11][1] == 258)) or
            (custom["p0"] ~= nil and (custom["p0"][1] == 10 or custom["p0"][1] == 17 or custom["p0"][1] == 44 or custom["p0"][1] == 45 or custom["p0"][1] == 121)) then
            return
          end
        end
      end

      -- parts
      for k,v in pairs(custom) do
        if k ~= "model" and k ~= "modelhash" then
          local isprop, index = parse_part(k)
          if isprop then
            if v[1] < 0 then
              ClearPedProp(ped,index)
            else
              SetPedPropIndex(ped,index,v[1],v[2],v[3] or 2)
            end
          else
            SetPedComponentVariation(ped,index,v[1],v[2],v[3] or 2)
          end
        end
      end
      -- Police
      if playerModel == hashMaleMPSkin then
        if tvRP.getRetiredCopLevel() <= 0 then
          if tvRP.getCopLevel() == 2 then -- Corporal
            if (custom[11] ~= nil and custom[11][1] == 200) then
              SetPedComponentVariation(ped,10,12,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 193) then
              SetPedComponentVariation(ped,10,12,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 190) then
              SetPedComponentVariation(ped,10,15,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 154) then
              SetPedComponentVariation(ped,11,154,1,2)
            end
          elseif tvRP.getCopLevel() == 3 then -- FTS
            if (custom[11] ~= nil and custom[11][1] == 200) then
              SetPedComponentVariation(ped,10,12,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 193) then
              SetPedComponentVariation(ped,10,12,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 190) then
              SetPedComponentVariation(ped,10,15,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 154) then
              SetPedComponentVariation(ped,11,154,2,2)
            end
          elseif tvRP.getCopLevel() == 4 then -- Sgt
            if (custom[11] ~= nil and custom[11][1] == 200) then
              SetPedComponentVariation(ped,10,12,2,2)
            elseif (custom[11] ~= nil and custom[11][1] == 193) then
              SetPedComponentVariation(ped,10,12,2,2)
            elseif (custom[11] ~= nil and custom[11][1] == 190) then
              SetPedComponentVariation(ped,10,15,2,2)
            elseif (custom[11] ~= nil and custom[11][1] == 154) then
              SetPedComponentVariation(ped,11,154,3,2)
            end
          elseif tvRP.getCopLevel() == 5 then -- Lt
            if (custom[11] ~= nil and custom[11][1] == 200) then
              SetPedComponentVariation(ped,10,45,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 193) then
              SetPedComponentVariation(ped,10,44,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 190) then
              SetPedComponentVariation(ped,10,44,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 154) then
              SetPedComponentVariation(ped,10,44,0,2)
            end
          elseif tvRP.getCopLevel() == 6 then -- Cpt
            if (custom[11] ~= nil and custom[11][1] == 200) then
              SetPedComponentVariation(ped,10,45,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 193) then
              SetPedComponentVariation(ped,10,44,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 190) then
              SetPedComponentVariation(ped,10,44,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 154) then
              SetPedComponentVariation(ped,10,44,1,2)
            end
          elseif tvRP.getCopLevel() == 7 then -- Chief
            if user_id ~= nil and (user_id == 5567 or user_id == 10418) then
              if (custom[11] ~= nil and custom[11][1] == 200) then
                SetPedComponentVariation(ped,10,12,6,2)
              elseif (custom[11] ~= nil and custom[11][1] == 193) then
                SetPedComponentVariation(ped,10,12,6,2)
              elseif (custom[11] ~= nil and custom[11][1] == 190) then
                SetPedComponentVariation(ped,10,15,6,2)
              elseif (custom[11] ~= nil and custom[11][1] == 154) then
                SetPedComponentVariation(ped,11,154,7,2)
              end
            else
              if (custom[11] ~= nil and custom[11][1] == 200) then
                SetPedComponentVariation(ped,10,45,5,2)
              elseif (custom[11] ~= nil and custom[11][1] == 193) then
                SetPedComponentVariation(ped,10,44,5,2)
              elseif (custom[11] ~= nil and custom[11][1] == 190) then
                SetPedComponentVariation(ped,10,44,5,2)
              elseif (custom[11] ~= nil and custom[11][1] == 154) then
                SetPedComponentVariation(ped,10,44,5,2)
              end
            end
          end
        else
          if tvRP.getRetiredCopLevel() == 2 then -- Corporal
            if (custom[11] ~= nil and custom[11][1] == 200) then
              SetPedComponentVariation(ped,10,12,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 193) then
              SetPedComponentVariation(ped,10,12,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 190) then
              SetPedComponentVariation(ped,10,15,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 154) then
              SetPedComponentVariation(ped,11,154,1,2)
            end
          elseif tvRP.getRetiredCopLevel() == 3 then -- FTS
            if (custom[11] ~= nil and custom[11][1] == 200) then
              SetPedComponentVariation(ped,10,12,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 193) then
              SetPedComponentVariation(ped,10,12,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 190) then
              SetPedComponentVariation(ped,10,15,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 154) then
              SetPedComponentVariation(ped,11,154,2,2)
            end
          elseif tvRP.getRetiredCopLevel() == 4 then -- Sgt
            if (custom[11] ~= nil and custom[11][1] == 200) then
              SetPedComponentVariation(ped,10,12,2,2)
            elseif (custom[11] ~= nil and custom[11][1] == 193) then
              SetPedComponentVariation(ped,10,12,2,2)
            elseif (custom[11] ~= nil and custom[11][1] == 190) then
              SetPedComponentVariation(ped,10,15,2,2)
            elseif (custom[11] ~= nil and custom[11][1] == 154) then
              SetPedComponentVariation(ped,11,154,3,2)
            end
          elseif tvRP.getRetiredCopLevel() == 5 then -- Lt
            if (custom[11] ~= nil and custom[11][1] == 200) then
              SetPedComponentVariation(ped,10,45,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 193) then
              SetPedComponentVariation(ped,10,44,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 190) then
              SetPedComponentVariation(ped,10,44,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 154) then
              SetPedComponentVariation(ped,10,44,0,2)
            end
          elseif tvRP.getRetiredCopLevel() == 6 then -- Cpt
            if (custom[11] ~= nil and custom[11][1] == 200) then
              SetPedComponentVariation(ped,10,45,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 193) then
              SetPedComponentVariation(ped,10,44,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 190) then
              SetPedComponentVariation(ped,10,44,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 154) then
              SetPedComponentVariation(ped,10,44,1,2)
            end
          elseif tvRP.getRetiredCopLevel() == 7 then -- Chief
            if user_id ~= nil and (user_id == 5567 or user_id == 10418) then
              if (custom[11] ~= nil and custom[11][1] == 200) then
                SetPedComponentVariation(ped,10,12,6,2)
              elseif (custom[11] ~= nil and custom[11][1] == 193) then
                SetPedComponentVariation(ped,10,12,6,2)
              elseif (custom[11] ~= nil and custom[11][1] == 190) then
                SetPedComponentVariation(ped,10,15,6,2)
              elseif (custom[11] ~= nil and custom[11][1] == 154) then
                SetPedComponentVariation(ped,11,154,7,2)
              end
            else
              if (custom[11] ~= nil and custom[11][1] == 200) then
                SetPedComponentVariation(ped,10,45,5,2)
              elseif (custom[11] ~= nil and custom[11][1] == 193) then
                SetPedComponentVariation(ped,10,44,5,2)
              elseif (custom[11] ~= nil and custom[11][1] == 190) then
                SetPedComponentVariation(ped,10,44,5,2)
              elseif (custom[11] ~= nil and custom[11][1] == 154) then
                SetPedComponentVariation(ped,10,44,5,2)
              end
            end
          end
        end
      elseif playerModel == hashFemaleMPSkin then
        if tvRP.getRetiredCopLevel() <= 0 then
          if tvRP.getCopLevel() == 2 then -- Corporal
            if (custom[11] ~= nil and custom[11][1] == 202) then
              SetPedComponentVariation(ped,10,11,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 195) then
              SetPedComponentVariation(ped,10,11,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 192) then
              SetPedComponentVariation(ped,10,14,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 151) then
              SetPedComponentVariation(ped,151,1,0,2)
            end
          elseif tvRP.getCopLevel() == 3 then -- FTS
            if (custom[11] ~= nil and custom[11][1] == 202) then
              SetPedComponentVariation(ped,10,11,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 195) then
              SetPedComponentVariation(ped,10,11,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 192) then
              SetPedComponentVariation(ped,10,14,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 151) then
              SetPedComponentVariation(ped,151,2,0,2)
            end
          elseif tvRP.getCopLevel() == 4 then -- Sgt
            if (custom[11] ~= nil and custom[11][1] == 202) then
              SetPedComponentVariation(ped,10,11,2,2)
            elseif (custom[11] ~= nil and custom[11][1] == 195) then
              SetPedComponentVariation(ped,10,11,2,2)
            elseif (custom[11] ~= nil and custom[11][1] == 192) then
              SetPedComponentVariation(ped,10,14,2,2)
            elseif (custom[11] ~= nil and custom[11][1] == 151) then
              SetPedComponentVariation(ped,151,3,0,2)
            end
          elseif tvRP.getCopLevel() == 5 then -- Lt
            if (custom[11] ~= nil and custom[11][1] == 202) then
              SetPedComponentVariation(ped,10,53,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 195) then
              SetPedComponentVariation(ped,10,52,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 192) then
              SetPedComponentVariation(ped,10,52,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 151) then
              SetPedComponentVariation(ped,10,52,0,2)
            end
          elseif tvRP.getCopLevel() == 6 then -- Cpt
            if (custom[11] ~= nil and custom[11][1] == 202) then
              SetPedComponentVariation(ped,10,53,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 195) then
              SetPedComponentVariation(ped,10,52,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 192) then
              SetPedComponentVariation(ped,10,52,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 151) then
              SetPedComponentVariation(ped,10,52,1,2)
            end
          elseif tvRP.getCopLevel() == 7 then -- Chief
            if (custom[11] ~= nil and custom[11][1] == 202) then
              SetPedComponentVariation(ped,10,53,5,2)
            elseif (custom[11] ~= nil and custom[11][1] == 195) then
              SetPedComponentVariation(ped,10,52,5,2)
            elseif (custom[11] ~= nil and custom[11][1] == 192) then
              SetPedComponentVariation(ped,10,52,5,2)
            elseif (custom[11] ~= nil and custom[11][1] == 151) then
              SetPedComponentVariation(ped,10,52,5,2)
            end
          end
        else
          if tvRP.getRetiredCopLevel() == 2 then -- Corporal
            if (custom[11] ~= nil and custom[11][1] == 202) then
              SetPedComponentVariation(ped,10,11,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 195) then
              SetPedComponentVariation(ped,10,11,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 192) then
              SetPedComponentVariation(ped,10,14,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 151) then
              SetPedComponentVariation(ped,151,1,0,2)
            end
          elseif tvRP.getRetiredCopLevel() == 3 then -- FTS
            if (custom[11] ~= nil and custom[11][1] == 202) then
              SetPedComponentVariation(ped,10,11,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 195) then
              SetPedComponentVariation(ped,10,11,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 192) then
              SetPedComponentVariation(ped,10,14,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 151) then
              SetPedComponentVariation(ped,151,2,0,2)
            end
          elseif tvRP.getRetiredCopLevel() == 4 then -- Sgt
            if (custom[11] ~= nil and custom[11][1] == 202) then
              SetPedComponentVariation(ped,10,11,2,2)
            elseif (custom[11] ~= nil and custom[11][1] == 195) then
              SetPedComponentVariation(ped,10,11,2,2)
            elseif (custom[11] ~= nil and custom[11][1] == 192) then
              SetPedComponentVariation(ped,10,14,2,2)
            elseif (custom[11] ~= nil and custom[11][1] == 151) then
              SetPedComponentVariation(ped,151,3,0,2)
            end
          elseif tvRP.getRetiredCopLevel() == 5 then -- Lt
            if (custom[11] ~= nil and custom[11][1] == 202) then
              SetPedComponentVariation(ped,10,53,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 195) then
              SetPedComponentVariation(ped,10,52,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 192) then
              SetPedComponentVariation(ped,10,52,0,2)
            elseif (custom[11] ~= nil and custom[11][1] == 151) then
              SetPedComponentVariation(ped,10,52,0,2)
            end
          elseif tvRP.getRetiredCopLevel() == 6 then -- Cpt
            if (custom[11] ~= nil and custom[11][1] == 202) then
              SetPedComponentVariation(ped,10,53,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 195) then
              SetPedComponentVariation(ped,10,52,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 192) then
              SetPedComponentVariation(ped,10,52,1,2)
            elseif (custom[11] ~= nil and custom[11][1] == 151) then
              SetPedComponentVariation(ped,10,52,1,2)
            end
          elseif tvRP.getRetiredCopLevel() == 7 then -- Chief
            if (custom[11] ~= nil and custom[11][1] == 202) then
              SetPedComponentVariation(ped,10,53,5,2)
            elseif (custom[11] ~= nil and custom[11][1] == 195) then
              SetPedComponentVariation(ped,10,52,5,2)
            elseif (custom[11] ~= nil and custom[11][1] == 192) then
              SetPedComponentVariation(ped,10,52,5,2)
            elseif (custom[11] ~= nil and custom[11][1] == 151) then
              SetPedComponentVariation(ped,10,52,5,2)
            end
          end
        end
      -- EMS
      elseif playerModel == hashMaleMPSkin and (custom[11] ~= nil and custom[11][1] == 250) then
        SetPedComponentVariation(ped,10,58,0,0)
      elseif playerModel == hashFemaleMPSkin and (custom[11] ~= nil and custom[11][1] == 258) then
        SetPedComponentVariation(ped,10,66,0,0)
      end
    end
    if update and not tvRP.isMedic() and not tvRP.isCop() then
      customization_changed = true
    end
  end)
end

function tvRP.reapplyProps(custom) -- indexed [drawable,texture,palette] components or props (p0...) plus .modelhash or .model
  local exit = TUNNEL_DELAYED() -- delay the return values

  Citizen.CreateThread(function() -- new thread
    if custom then
      local ped = GetPlayerPed(-1)

      -- parts
      for k,v in pairs(custom) do
        if k ~= "model" and k ~= "modelhash" then
          local isprop, index = parse_part(k)
          if isprop then
            if v[1] < 0 then
              ClearPedProp(ped,index)
            else
              SetPedPropIndex(ped,index,v[1],v[2],v[3] or 2)
            end
          end
        end
      end
    end

    exit({})
  end)
end

local lastHelmet = nil
function tvRP.removeHelmet()
  if not tvRP.isHandcuffed() and not tvRP.getActionLock() and not tvRP.isInComa() then
    local ped = GetPlayerPed(-1)
    lastHelmet = {GetPedPropIndex(ped,0), math.max(GetPedPropTextureIndex(ped,0),0)}
    tvRP.playAnim(false,{{"veh@common@fp_helmet@","take_off_helmet_stand",1}},false)
    Citizen.Wait(500)
    ClearPedProp(GetPlayerPed(-1), 0)
  end
end

function tvRP.reapplyHelmet()
  if lastHelmet ~= nil and lastHelmet[1] > -1 and not tvRP.isHandcuffed() and not tvRP.getActionLock() and not tvRP.isInComa() then
    tvRP.playAnim(false,{{"veh@common@fp_helmet@","put_on_helmet",1}},false)
    Citizen.Wait(1000)
    SetPedPropIndex(GetPlayerPed(-1),0,lastHelmet[1],lastHelmet[2],lastHelmet[3] or 2)
  end
end

local lastGlasses = nil
function tvRP.removeGlasses()
  if not tvRP.isHandcuffed() and not tvRP.isInComa() and not tvRP.getActionLock() then
    local ped = GetPlayerPed(-1)
    lastGlasses = {GetPedPropIndex(ped,1), math.max(GetPedPropTextureIndex(ped,1),0)}
    tvRP.playAnim(false,{{"veh@common@fp_helmet@","take_off_helmet_stand",1}},false)
    Citizen.Wait(500)
    ClearPedProp(GetPlayerPed(-1), 1)
  end
end

function tvRP.reapplyGlasses()
  if lastGlasses ~= nil and lastGlasses[1] > -1 and not tvRP.isHandcuffed() and not tvRP.isInComa() and not tvRP.getActionLock() then
    tvRP.playAnim(false,{{"missheistdockssetup1hardhat@","put_on_hat",1}},false)
    Citizen.Wait(1000)
    SetPedPropIndex(GetPlayerPed(-1),1,lastGlasses[1],lastGlasses[2],lastGlasses[3] or 2)
  end
end

local lastMask = nil
function tvRP.removeMask(cancelAnim)
  if (not tvRP.isHandcuffed() and not tvRP.isInComa() and not tvRP.getActionLock()) or cancelAnim then
    local ped = GetPlayerPed(-1)
    lastMask = {GetPedDrawableVariation(ped,1), GetPedTextureVariation(ped,1), GetPedPaletteVariation(ped,1)}
    if cancelAnim == nil or not cancelAnim then
      tvRP.playAnim(true,{{"missprologueig_6@first_person","remove_balaclava",1}},false)
    end
    Citizen.Wait(500)
    SetPedComponentVariation(ped, 1, 0, 0, 0)
  end
end

function tvRP.reapplyMask()
  if lastMask ~= nil and lastMask[1] > -1 and not tvRP.isHandcuffed() and not tvRP.isInComa() and not tvRP.getActionLock() then
    tvRP.playAnim(true,{{"veh@common@fp_helmet@","put_on_helmet",1}},false)
    Citizen.Wait(1000)
    SetPedComponentVariation(GetPlayerPed(-1),1,lastMask[1],lastMask[2],lastMask[3] or 2)
  end
end

function tvRP.removeTargetMask_cl()
  local ped = GetPlayerPed(-1)
  local pos = GetEntityCoords(ped)
  local nearServId = tvRP.getNearestPlayer(2)
  if nearServId ~= nil then
    local target = GetPlayerPed(GetPlayerFromServerId(nearServId))
    if target ~= 0 and IsEntityAPed(target) then
      if HasEntityClearLosToEntityInFront(ped,target) then
        vRPserver.removeTargetMask_sv({nearServId})
        tvRP.playAnim(true,{{"ped","push_l_front",1}},false)
      end
    end
  end
end
-- fix invisible players by resetting customization every minutes

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(60000)
    if state_ready then
      local custom = tvRP.getCustomization()
      custom.model = nil
      custom.modelhash = nil
      tvRP.setCustomization(custom,false)
    end
  end
end)


-- PLAYER POINTING ACTION
local mp_pointing = false
local keyPressed = false

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local once = true
local oldval = false
local oldvalped = false

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if once then
            once = false
        end
        if not tvRP.isHandcuffed() then
          if not keyPressed then
              if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                  Wait(200)
                  if not IsControlPressed(0, 29) then
                      keyPressed = true
                      startPointing()
                      mp_pointing = true
                  else
                      keyPressed = true
                      while IsControlPressed(0, 29) do
                          Wait(50)
                      end
                  end
              elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                  keyPressed = true
                  mp_pointing = false
                  stopPointing()
              end
          end

          if keyPressed then
              if not IsControlPressed(0, 29) then
                  keyPressed = false
              end
          end
        else
          mp_pointing = false
        end

        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

            end
        end
    end
end)
-- END PLAYER POINTING ACTION

--[[
-- Player crouch
local crouched = false

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(1)

        local ped = GetPlayerPed(-1)

        if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
            DisableControlAction(0, 36, true) -- INPUT_DUCK

            if (not IsPauseMenuActive() and not IsPedInAnyVehicle(GetPlayerPed(-1))) then
                if (IsDisabledControlJustPressed(0, 36)) then
                    RequestAnimSet("move_ped_crouched")

                    while (not HasAnimSetLoaded("move_ped_crouched")) do
                        Citizen.Wait(100)
                    end

                    if (crouched == true) then
                        ResetPedMovementClipset(ped, 0)
                        crouched = false
                    elseif (crouched == false) then
                        SetPedMovementClipset(ped, "move_ped_crouched", 0.25)
                        crouched = true
                    end
                end
            end
        end
    end
end)
-- end player crouch
]]--

-- Player quickfire, firedelay, drawdelay
local firingBlockTime = 0
local meleeActive = false
local meleeDelay = 50

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    local ped = GetPlayerPed(-1)
    if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
      pedSpeed = GetEntitySpeed(ped)
      if pedSpeed > 8 then
        if not IsPedInAnyVehicle(ped, -1) and (IsAimCamActive() or IsPlayerFreeAiming(ped) or IsPedShooting(ped)) then
          SetPedToRagdoll(ped, 10000, 10000, 0, 0, 0, 0)
        end
      end
      if GetIsTaskActive(ped, 56) then
        firingBlockTime = GetGameTimer() + 2000
      end
      --if IsPedInMeleeCombat(GetPlayerPed(-1)) then
      --  if IsControlPressed(0,24) or IsControlPressed(0,47) or IsControlPressed(0,58) or IsControlPressed(0,263) or IsControlPressed(0,264) or IsControlPressed(0,257) or IsControlPressed(0,140) or IsControlPressed(0,141) or IsControlPressed(0,142) or IsControlPressed(0, 106) then
      --    startMeleeDelay()
      --  end
      --end
    end
  end
end)

function startMeleeDelay()
  if not meleeActive then
    meleeActive = true
    local delay = 0
    Citizen.CreateThread(function()
        while delay < meleeDelay do
          Citizen.Wait(0)
          delay = delay + 1
          DisableControlAction(0,24,true) -- disable attack
          DisableControlAction(0,47,true) -- disable weapon
          DisableControlAction(0,58,true) -- disable weapon
          DisableControlAction(0,263,true) -- disable melee
          DisableControlAction(0,264,true) -- disable melee
          DisableControlAction(0,257,true) -- disable melee
          DisableControlAction(0,140,true) -- disable melee
          DisableControlAction(0,141,true) -- disable melee
          DisableControlAction(0,142,true) -- disable melee
          DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
          DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
        end
        meleeActive = false
    end)
  end
end

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)

        if (firingBlockTime > GetGameTimer()) then
          DisablePlayerFiring(ped, true) -- Disable weapon firing
          DisableControlAction(0,24,true) -- disable attack
          DisableControlAction(0,47,true) -- disable weapon
          DisableControlAction(0,58,true) -- disable weapon
          DisableControlAction(0,263,true) -- disable melee
          DisableControlAction(0,264,true) -- disable melee
          DisableControlAction(0,257,true) -- disable melee
          DisableControlAction(0,140,true) -- disable melee
          DisableControlAction(0,141,true) -- disable melee
          DisableControlAction(0,142,true) -- disable melee
          DisableControlAction(0,143,true) -- disable melee
          DisableControlAction(0,47,true) -- disable weapon
          DisableControlAction(0,58,true) -- disable weapon
          DisableControlAction(0,257,true) -- disable melee
          DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
        end
    end
end)
-- end player quickfire

-- DISABLE SHOOTING FROM VEHICLE START
-- Author: Scammer
-- Source: https://forum.fivem.net/t/release-scammers-script-collection-09-03-17/3313

local player_incar = false

Citizen.CreateThread(function()
  while true do
    Wait(1)

    playerPed = GetPlayerPed(-1)
    car = GetVehiclePedIsIn(playerPed, false)
    if car then
      --Switch players current weapon to unarmed when in a vehicle
      --Prevents shooting, but allow flipping the bird
      if player_incar and not tvRP.synchronizedData["admin"]["wepAllowed"] then
        SetCurrentPedWeapon(playerPed,0xA2719263,true)
        if IsPedOnAnyBike(playerPed) then
          DisableControlAction(1, 323, true)
        end
      end
      if GetPedInVehicleSeat(car, -1) == playerPed then --Driver
        --Eject player from driver seat if restrained
        if tvRP.isHandcuffed() then
          ClearPedTasksImmediately(playerPed)
          Citizen.Wait(1)
          if tvRP.isHandcuffed() then
            if not IsEntityPlayingAnim(GetPlayerPed(-1),"mp_arresting","idle",3) then
              if tvRP.getAllowMovement() then
                tvRP.playAnim(false,{{"mp_arresting","idle",1}},true)
              else
                tvRP.playAnim(true,{{"mp_arresting","idle",1}},true)
              end
            end
          end
        end
      end
      if car ~= 0 then
        player_incar = true
      else
        player_incar = false
      end
    else
      player_incar = true
    end
  end
end)
-- DISABLE SHOOTING FROM VEHICLE END

function tvRP.isPedInCar()
  return player_incar
end

local tpLoopContinue = true
local canTP = false
function tvRP.disableTPMark()
  Citizen.Wait(30000) -- delay checking, if too early, it is missed.
  local ped = GetPlayerPed(-1)
  local playerPos = GetEntityCoords(ped, true)
  if (Vdist(playerPos.x, playerPos.y, playerPos.z, -22.017194747925, -584.33850097656, 90.114814758301) > 50.0) then
    tpLoopContinue = false
  end
end

function tvRP.canUseTP(flag)
  canTP = flag
  tvRP.disableTPMark()
end
Citizen.CreateThread(function()
  while tpLoopContinue do
    Citizen.Wait(0)

    local ped = GetPlayerPed(-1)
    local playerPos = GetEntityCoords(ped, true)

    DrawMarker(1, -22.017194747925,-584.33850097656,90.114814758301-1, 0, 0, 0, 0, 0, 0, 1.0,1.0,0.5, 255, 165, 0,165, 0, 0, 2, 0, 0, 0, 0)
    if (Vdist(playerPos.x, playerPos.y, playerPos.z, -22.017194747925, -584.33850097656, 90.114814758301) < 2.0) and canTP then
      tvRP.teleport(-256.33142089844,-295.1545715332,21.626396179199)
      tpLoopContinue = false
    end
  end
end)

--[[------------------------------------------------------------------------
    Remove Reticle on ADS (Third Person)
------------------------------------------------------------------------]]--
local allowed =
{
    --911657153,  -- WEAPON_STUNGUN
    100416529   -- SniperRifle (reticle handled in hunting)
}

function HashInTable(hash)
  for k, v in pairs(allowed) do
    if (hash == v) then
      return true
    end
  end

  return false
end

function ManageReticle()
  local ped = GetPlayerPed(-1)

  if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
    local _, hash = GetCurrentPedWeapon(ped, true)
    if hash ~= nil then
      if not HashInTable(hash) then
        HideHudComponentThisFrame(14)
      end
    end
  end
end

Citizen.CreateThread( function()
  while true do
    HideHudComponentThisFrame(1)
    HideHudComponentThisFrame(3)
    HideHudComponentThisFrame(4)
    HideHudComponentThisFrame(7)
    HideHudComponentThisFrame(9)
    HideHudComponentThisFrame(13)
    ManageReticle()
    Citizen.Wait(0)
  end
end)

-- Prevent player from shuffling seats
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
      if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
        if GetIsTaskActive(GetPlayerPed(-1), 165) and not IsControlPressed(0,47) then
          SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
        end
      end
    end
  end
end)

------------------------------------------------------------------
-- Remove weapons rewards from vehicles. Prevent known exploit
-- Original only deals with police vehicles
-- https://forum.fivem.net/t/release-police-vehicle-weapon-deleter/39514
------------------------------------------------------------------

local vehWeapons = {
  0x1D073A89, -- ShotGun
  0x83BF0278, -- Carbine
  0x5FC3C11, -- Sniper
  0x1B06D571, -- Pistol
  0x2BE6766B, -- SMG
  0x440E4788, -- Golf club
  0x958A4A8F, -- Bat
  0x4E875F73, -- Hammer
  0x99B507EA, -- Knife
  0x84BD7BFD, -- Crowbar
  0xBFD21232, -- SNS
  0x083839C4, -- Vintage
  0xC1B3C3D1, -- Revolver
  0x99AEEB3B, -- Pistol50
  0xF9E6AA4B, -- Bottle
  0x92A27487, -- Dagger
  0x34A67B97, -- Petrol Can
}

local hasBeenInVehicle = false
local alreadyHaveWeapon = {}

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
      if not hasBeenInVehicle then
        hasBeenInVehicle = true
      end
    else
      if hasBeenInVehicle then
        for i,k in pairs(vehWeapons) do
          if not alreadyHaveWeapon[i] then
            TriggerEvent("PoliceVehicleWeaponDeleter:drop",k)
          end
        end
        hasBeenInVehicle = false
      end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if(not IsPedInAnyVehicle(GetPlayerPed(-1))) then
      for i=1,#vehWeapons do
        if(HasPedGotWeapon(GetPlayerPed(-1), vehWeapons[i], false)==1) then
          alreadyHaveWeapon[i] = true
        else
          alreadyHaveWeapon[i] = false
        end
      end
    end
    Citizen.Wait(5000)
  end
end)


RegisterNetEvent("PoliceVehicleWeaponDeleter:drop")
AddEventHandler("PoliceVehicleWeaponDeleter:drop", function(wea)
  RemoveWeaponFromPed(GetPlayerPed(-1), wea)
end)

----------------------------------------
--- Player Tackle start
---------------------------------------
local tackleThreadStarted = false
local tackleCooldown = 0
local tackleHandicapCooldown = 0

AddEventHandler("playerSpawned",function()
    if not tackleThreadStarted then
        tackleThreadStarted = true
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                if (IsControlPressed(1, 32) and IsControlPressed(1, 21)) then
                  DisableControlAction(0, 44, true)
                  if IsDisabledControlJustPressed(1, 44) and tackleCooldown <= 0 and not tvRP.isInComa() and not tvRP.isHandcuffed() then
                    if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                        tackleCooldown = 10 --seconds
                        local target = tvRP.getNearestPlayer(1.5)
                        if target ~= nil then
                            --if HasEntityClearLosToEntityInFront(GetPlayerPed(-1),target) then
                                vRPserver.tackle({target})
                            --end
                        end
                        SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
                        tvRP.closeMenu()
                      	vRPphone.forceClosePhone({})
                    end
                  end
                end
            end
        end)
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(1000)
                if tackleCooldown > 0 then
                    tackleCooldown = tackleCooldown-1
                end
            end
        end)
    end
end)

-- This is applied to the victim of the tackle
function tvRP.tackleragdoll()
    if not tvRP.isHandcuffed() and not tvRP.isInComa() then
        -- Don't override any existance cooldown with a lower value
        if tackleCooldown < 2 then
          tackleCooldown = 2
        end
        SetPedToRagdoll(GetPlayerPed(-1), 1500, 1500, 0, 0, 0, 0)
        tvRP.closeMenu()
      	vRPphone.forceClosePhone({})
    end
end
----------------------------------------
--- Player Tackle end
---------------------------------------

-- Register decors to be used
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if NetworkIsSessionStarted() then
    DecorRegister("SpeedBomb",  3)
          DecorRegister("OfferedDrugs",  3)
          DecorRegister("AiRevived",  3)
          DecorRegister("DestroyedClear",  2)
          DecorRegister("lockpicked",  2)
          DecorRegister("VehicleID",1)
          return
        end
    end
end)

---------------------------------------
-- GSR Stuff start
---------------------------------------
local recently_fired = false
local gsr_countdown = 0
local gsr_cooldown = 5*60 -- minutes
local gsr_test_cooldown = 0

function tvRP.setGunFired()
  recently_fired = true
  gsr_countdown = gsr_cooldown
end

function tvRP.getGunFired()
  if gsr_test_cooldown < 1 then
    gsr_test_cooldown = 15 -- seconds
    local random = math.random(1, 10)
    if random ~= 5 then
      return recently_fired
    else
      return false
    end
  else
    return false
  end
end

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if gsr_countdown > 0 then
            gsr_countdown = gsr_countdown - 1
            if gsr_countdown < 1 then
              recently_fired = false
            end
        end
        if gsr_test_cooldown > 0 then
          gsr_test_cooldown = gsr_test_cooldown - 1
        end
    end
end)

---------------------------------------
-- Firing pin Stuff
-- Param flag: true = give pin, false = remove pin
---------------------------------------
local firingPinThreadActive = false
local unarmed_hash = GetHashKey("WEAPON_UNARMED")
function tvRP.setFiringPinState(flag)
  if flag ~= nil then
    local ped = GetPlayerPed(-1)
    if not flag then
      if not firingPinThreadActive then
        Citizen.CreateThread(function()
          firingPinThreadActive = true
          if tvRP.isCop() then
            vRPserver.removePlayerToActivePolive({})
          end
          while firingPinThreadActive do
              Wait(0)
              SetCurrentPedWeapon(ped, unarmed_hash, true)
          end
          DisablePlayerFiring(ped, false) -- Enable weapon firing
        end)
      end
    else
      if firingPinThreadActive then
        if tvRP.isCop() then
          vRPserver.addPlayerToActivePolive({})
        end
      end
      firingPinThreadActive = false
    end
  end
end

function tvRP.getFiringPinState()
  return firingPinThreadActive
end

function tvRP.applyFlashlightMod()
  local currentWeaponHash = GetSelectedPedWeapon(GetPlayerPed(-1))
  if currentWeaponHash == GetHashKey("WEAPON_PISTOL") then -- WEAPON_PISTOL
    GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))
  elseif currentWeaponHash == GetHashKey("WEAPON_COMBATPISTOL") then -- WEAPON_COMBATPISTOL
    GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_COMBATPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))
  elseif currentWeaponHash == GetHashKey("WEAPON_PISTOL50") then -- WEAPON_PISTOL50
    GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), GetHashKey("COMPONENT_AT_PI_FLSH"))
  elseif currentWeaponHash == GetHashKey("WEAPON_PUMPSHOTGUN") then -- WEAPON_PUMPSHOTGUN
    GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PUMPSHOTGUN"), GetHashKey("COMPONENT_AT_AR_FLSH"))
  elseif currentWeaponHash == GetHashKey("WEAPON_HEAVYPISTOL") then -- WEAPON_HEAVYPISTOL
    GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_HEAVYPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))
  elseif currentWeaponHash == GetHashKey("WEAPON_SMG") then -- WEAPON_SMG
    GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SMG"), GetHashKey("COMPONENT_AT_AR_FLSH"))
  else
    tvRP.notify("The flashlight attachement is not compatible with your item in hand.")
  end
end

local male_pd_headgear = {
  -- item id, texture id, allow texture select
  [1] = {46,0,false}, -- patrol cap
  [2] = {17,1,false}, -- motor helmet
  [3] = {49,0,false}, -- bicyle helmet
  [4] = {10,6,false}, -- ball cap
}
local female_pd_headgear = {
  -- item id, texture id, allow texture select
  [1] = {45,0,false}, -- patrol cap
  [2] = {17,1,false}, -- motor helmet
  [3] = {47,0,false}, -- bicyle helmet
  [4] = {10,2,false}, -- ball cap
}
local male_fd_headgear = {
  -- item id, texture id, allow texture select
  [1] = {44,2,false}, -- ball cap
  [2] = {45,0,true}, -- fd helmet
}
local female_fd_headgear = {
  -- item id, texture id, allow texture select
  [1] = {43,2,false}, -- ball cap
  [2] = {44,0,true}, -- fd helmet
}

RegisterNetEvent("vRP:setHeadGear")
AddEventHandler("vRP:setHeadGear", function(id, variation)
  if id ~= nil then
    local ped = GetPlayerPed(-1)
    local hashMaleMPSkin = GetHashKey("mp_m_freemode_01")
    local hashFemaleMPSkin = GetHashKey("mp_f_freemode_01")
    local currentModel = GetEntityModel(ped)
    if tvRP.isCop() then
      local current_headgear = {GetPedPropIndex(ped,0), math.max(GetPedPropTextureIndex(ped,0),0)}
      Citizen.Trace("Current headgear ID = "..current_headgear[1].." Current texture ID = "..current_headgear[2])
      if id == 0 then
        tvRP.playAnim(false,{{"veh@common@fp_helmet@","take_off_helmet_stand",1}},false)
        Citizen.Wait(500)
        ClearPedProp(ped,0)
      elseif current_headgear[1] ~= id then
        tvRP.playAnim(false,{{"veh@common@fp_helmet@","put_on_helmet",1}},false)
        Citizen.Wait(1000)
        if currentModel == hashMaleMPSkin and male_pd_headgear[id] then
          SetPedPropIndex(ped,0,male_pd_headgear[id][1],male_pd_headgear[id][2],2)
        elseif currentModel == hashFemaleMPSkin and female_pd_headgear[id] then
          SetPedPropIndex(ped,0,female_pd_headgear[id][1],female_pd_headgear[id][2],2)
        end
      end
    elseif tvRP.isMedic() then
      local current_headgear = {GetPedPropIndex(ped,0), math.max(GetPedPropTextureIndex(ped,0),0)}
      Citizen.Trace("Current headgear ID = "..current_headgear[1].." Current texture ID = "..current_headgear[2])
      if id == 0 then
        tvRP.playAnim(false,{{"veh@common@fp_helmet@","take_off_helmet_stand",1}},false)
        Citizen.Wait(500)
        ClearPedProp(ped,0)
      elseif current_headgear[1] ~= id then
        tvRP.playAnim(false,{{"veh@common@fp_helmet@","put_on_helmet",1}},false)
        Citizen.Wait(1000)
        if currentModel == hashMaleMPSkin and male_fd_headgear[id] then
          local texture = male_fd_headgear[id][2]
          if variation ~= nil and male_fd_headgear[id][3] then
            texture = variation
          end
          SetPedPropIndex(ped,0,male_fd_headgear[id][1],texture,2)
        elseif currentModel == hashFemaleMPSkin and female_fd_headgear[id] then
          local texture = female_fd_headgear[id][2]
          if variation ~= nil and female_fd_headgear[id][3] then
            texture = variation
          end
          SetPedPropIndex(ped,0,female_fd_headgear[id][1],texture,2)
        end
      end
    end
  end
end)

RegisterNetEvent("vRP:ChangeStethoscopeColor")
AddEventHandler("vRP:ChangeStethoscopeColor", function(color)
  if color ~= nil then
    local ped = GetPlayerPed(-1)
    local hashMaleMPSkin = GetHashKey("mp_m_freemode_01")
    local hashFemaleMPSkin = GetHashKey("mp_f_freemode_01")
    local currentModel = GetEntityModel(ped)
    local neckItem = {GetPedDrawableVariation(ped,7), GetPedTextureVariation(ped,7), GetPedPaletteVariation(ped,7)}
    if currentModel == hashMaleMPSkin and neckItem[1] == 30 then
      SetPedComponentVariation(ped,7,30,color,2)
    elseif currentModel == hashFemaleMPSkin and neckItem[1] == 14 then
      SetPedComponentVariation(ped,7,14,color,2)
    end
  end
end)


function tvRP.GetZoneName(x, y, z)
  local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }
  return zones[GetNameOfZone(x, y, z)] or "No Location Found"
end
