
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
  "WEAPON_DAGGER",
  "WEAPON_BOTTLE",
  "WEAPON_STUNGUN",
  "WEAPON_FLASHLIGHT",
  "WEAPON_NIGHTSTICK",
  "WEAPON_HAMMER",
  "WEAPON_BAT",
  "WEAPON_GOLFCLUB",
  "WEAPON_CROWBAR",
  "WEAPON_PISTOL",
  "WEAPON_SNSPISTOL",
  "WEAPON_COMBATPISTOL",
  "WEAPON_HEAVYPISTOL",
  "WEAPON_PISTOL50",
  "WEAPON_VINTAGEPISTOL",
  --"WEAPON_MACHINEPISTOL",
  --"WEAPON_MICROSMG",
  "WEAPON_SMG",
  "WEAPON_CARBINERIFLE",
  "WEAPON_SPECIALCARBINE",
  "WEAPON_PUMPSHOTGUN",
  "WEAPON_STUNGUN",
  "WEAPON_FIREEXTINGUISHER",
  --"WEAPON_PETROLCAN",
  "WEAPON_FLARE",
  "WEAPON_REVOLVER",
  "WEAPON_SWITCHBLADE",
  "WEAPON_BATTLEAXE",
  "WEAPON_POOLCUE",
  "WEAPON_WRENCH"
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

local stored_shotgun = false
local stored_smg = false

function tvRP.storeCopWeapon(weaponName)
  if weaponName ~= nil then
    weaponName = string.upper(weaponName)
    if weaponName == "WEAPON_PUMPSHOTGUN" then
      if stored_shotgun then
        giveStoredWeapon(weaponName)
      else
        removeWeapon(weaponName)
      end
    elseif weaponName == "WEAPON_SMG" then
      if stored_smg then
        giveStoredWeapon(weaponName)
      else
        removeWeapon(weaponName)
      end
    end
  end
end

function giveStoredWeapon(weaponName)
  if weaponName ~= nil then
    local player = GetPlayerPed(-1)
    weaponName = string.upper(weaponName)
    local hash = GetHashKey(weaponName)
    if weaponName == "WEAPON_PUMPSHOTGUN" and stored_shotgun then
      stored_shotgun = false
      GiveWeaponToPed(player, hash, 250, false)
    elseif weaponName == "WEAPON_SMG" and stored_smg then
      stored_smg = false
      GiveWeaponToPed(player, hash, 250, false)
    end
  end
end

function removeWeapon(weaponName)
  if weaponName ~= nil then
    weaponName = string.upper(weaponName)
    local player = GetPlayerPed(-1)
    local hash = GetHashKey(weaponName)
    if HasPedGotWeapon(player,hash) then
      if weaponName == "WEAPON_PUMPSHOTGUN" then
        stored_shotgun = true
      elseif weaponName == "WEAPON_SMG" then
        stored_smg = true
      end
      RemoveWeaponFromPed(player,hash)
      tvRP.RemoveGear(weaponName)
      tvRP.notify("Weapon removed")
    end
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

  local exit = TUNNEL_DELAYED() -- delay the return values

  Citizen.CreateThread(function() -- new thread
    if custom then
      local ped = GetPlayerPed(-1)
      local mhash = nil

      -- model
      if custom.modelhash ~= nil then
        mhash = custom.modelhash
      elseif custom.model ~= nil then
        mhash = GetHashKey(custom.model)
      end

      if mhash ~= nil then
        local i = 0
        while not HasModelLoaded(mhash) and i < 10000 do
          RequestModel(mhash)
          Citizen.Wait(10)
        end

        if HasModelLoaded(mhash) then
          -- changing player model remove weapons, so save it
          local weapons = tvRP.getWeapons()
          SetPlayerModel(PlayerId(), mhash)
          tvRP.giveWeapons(weapons,true)
          SetModelAsNoLongerNeeded(mhash)
        end
      end

      ped = GetPlayerPed(-1)
      playerModel = GetEntityModel(ped)
      local hashMaleMPSkin = GetHashKey("mp_m_freemode_01")
      local hashFemaleMPSkin = GetHashKey("mp_f_freemode_01")
      -- prevent cop uniform on non cops
      if not tvRP.isCop() and not tvRP.isMedic() then
        if playerModel == hashMaleMPSkin then
          if (custom[11] ~= nil and (custom[11][1] == 55 or custom[11][1] == 250)) or
            (custom[7] ~= nil and (custom[7][1] == 125 or custom[7][1] == 126 or custom[7][1] == 127 or custom[7][1] == 128)) or
            (custom[8] ~= nil and (custom[8][1] == 58 or custom[8][1] == 129)) then
            return
          end
        end
        if playerModel == hashFemaleMPSkin then
          if (custom[11] ~= nil and (custom[11][1] == 48 or custom[11][1] == 82 or custom[11][1] == 258)) or
              (custom[7] ~= nil and (custom[7][1] == 95 or custom[7][1] == 96 or custom[7][1] == 97 or custom[7][1] == 98)) or
              (custom[8] ~= nil and (custom[8][1] == 35 or custom[8][1] == 159)) then
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
      if playerModel == hashMaleMPSkin and (custom[11] ~= nil and custom[11][1] == 55) then
        if tvRP.getCopLevel() < 3 then
          SetPedComponentVariation(ped,10,0,0,2)
        elseif tvRP.getCopLevel() < 4 then
          SetPedComponentVariation(ped,10,8,1,2)
        elseif tvRP.getCopLevel() < 5 then
          SetPedComponentVariation(ped,10,8,2,2)
        elseif tvRP.getCopLevel() < 8 then
          SetPedComponentVariation(ped,10,8,3,2)
        else
          SetPedComponentVariation(ped,10,0,0,2)
        end
      elseif playerModel == hashFemaleMPSkin and (custom[11] ~= nil and custom[11][1] == 48) then
        if tvRP.getCopLevel() < 3 then
          SetPedComponentVariation(ped,10,0,0,2)
        elseif tvRP.getCopLevel() < 4 then
          SetPedComponentVariation(ped,10,7,1,2)
        elseif tvRP.getCopLevel() < 5 then
          SetPedComponentVariation(ped,10,7,2,2)
        elseif tvRP.getCopLevel() < 8 then
          SetPedComponentVariation(ped,10,7,3,2)
        else
          SetPedComponentVariation(ped,10,0,0,2)
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
    exit({})
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

function tvRP.removeHelmet()
  ClearPedProp(GetPlayerPed(-1), 0)
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

-- Player quickfire
local firingBlockTime = 0

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    local ped = GetPlayerPed(-1)
    if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
      if GetIsTaskActive(ped, 56) then
        firingBlockTime = GetGameTimer() + 2000
      end
    end
  end
end)

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
      if player_incar then
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
											local ped = GetPlayerPed(-1)
											local pedPos = GetEntityCoords(ped, nil)
											if(Vdist(pedPos.x, pedPos.y, pedPos.z, 195.22776794434,-933.8046875,30.68678855896) > 175.0 or tvRP.isCop())then
                        tackleCooldown = 10 --seconds
                        local target = tvRP.getNearestPlayer(1.5)
                        if target ~= nil then
                            --if HasEntityClearLosToEntityInFront(GetPlayerPed(-1),target) then
                                vRPserver.tackle({target})
                            --end
                        end
                        SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
											end
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
    end
end
----------------------------------------
--- Player Tackle end
---------------------------------------

-- Register decors to be used
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsSessionStarted() then
            DecorRegister("OfferedDrugs",  3)
            DecorRegister("DestroyedClear",  2)
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
-- GSR Stuff end
---------------------------------------

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if NetworkIsSessionStarted() then
            DecorRegister("OfferedDrugs",  3)
            DecorRegister("DestroyedClear",  2)
            return
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

          while firingPinThreadActive do
              Wait(0)
              SetCurrentPedWeapon(ped, unarmed_hash, true)
          end
          DisablePlayerFiring(ped, false) -- Enable weapon firing
        end)
      end
    else
      firingPinThreadActive = false
    end
  end
end
