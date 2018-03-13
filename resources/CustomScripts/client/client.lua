-- Source https://forum.fivem.net/t/release-cellphone-camera/43599

phone = false
phoneId = 0
handcuffed = false

RegisterNetEvent('customscripts:handcuffed')
AddEventHandler('customscripts:handcuffed', function(flag)
  handcuffed = flag
end)

local function chatMessage(msg)
  TriggerEvent('chatMessage', '', {0, 0, 0}, msg)
end

phones = {
  [0] = "Michael's",
  [1] = "Trevor's",
  [2] = "Franklin's",
  [4] = "Prologue"
}

RegisterNetEvent('camera:phone')
AddEventHandler('camera:phone', function(message)
  local id = tonumber(string.sub(message, 7, 8))

  if id == 0 or id == 1 or id == 2 or id == 4 then
    ChangePhone(id)
  else
    chatMessage("^1/phone [ID]")
    chatMessage("^10 - Michael's phone")
    chatMessage("^11 - Trevor's phone")
    chatMessage("^12 - Franklin's phone")
    chatMessage("^14 - Prologue phone")
  end
end)

function ChangePhone(flag)
  if flag == 0 or flag == 1 or flag == 2 or flag == 4 then
    phoneId = flag
    chatMessage("^2Changed phone to "..phones[flag].." phone")
  end
end

frontCam = false

function CellFrontCamActivate(activate)
  return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

-- RemoveLoadingPrompt()

TakePhoto = N_0xa67c35c56eb1bd9d
WasPhotoTaken = N_0x0d6ca79eeebd8ca3
SavePhoto = N_0x3dec726c25a11bac
ClearPhoto = N_0xd801cc02177fa3f1

Citizen.CreateThread(function()
DestroyMobilePhone()
  while true do
    Citizen.Wait(0)
    local ped = GetPlayerPed(-1)

    if IsControlJustPressed(0, 170) and phone == true then -- SELFIE MODE
      frontCam = not frontCam
      CellFrontCamActivate(frontCam)
    end

    if IsControlJustPressed(0, 170) then -- OPEN PHONE
      CreateMobilePhone(phoneId)
      CellCamActivate(true, true)
      phone = true
      TriggerEvent('camera:hideUI',false)
    end

    if IsControlJustPressed(0, 177) and phone == true then -- CLOSE PHONE
      DestroyMobilePhone()
      phone = false
      TriggerEvent('camera:hideUI',true)
      CellCamActivate(false, false)
      if firstTime == true then
        firstTime = false
        Citizen.Wait(2500)
        displayDoneMission = true
      end
    end

    if phone == true then
      if handcuffed == true then
        DestroyMobilePhone()
        phone = false
        TriggerEvent('camera:hideUI',true)
        CellCamActivate(false, false)
        if firstTime == true then
          firstTime = false
          Citizen.Wait(2500)
          displayDoneMission = true
        end
      else
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(19)
        HideHudAndRadarThisFrame()
      end
    end

    -- If hold F while getting out of vehicle, door will stay open
    -- https://github.com/ToastinYou/KeepMyDoorOpen
    if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
      Citizen.Wait(150)
      if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
        local veh = GetVehiclePedIsIn(ped, false)
        TaskLeaveVehicle(ped, veh, 256)
      end
    end
  end
end)

-----------------
--TRAFFIC DENSITY
--source:https://github.com/TomGrobbe/vBasic/
-----------------
traffic_density = 0.50
ped_density = 0.50
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local current_zone = GetNameOfZone(pos.x, pos.y, pos.z)
    if current_zone == 'ARMYB' then
      SetVehicleDensityMultiplierThisFrame(tonumber(0.0))
      SetRandomVehicleDensityMultiplierThisFrame(tonumber(0.0))
      SetParkedVehicleDensityMultiplierThisFrame(tonumber(0.0))
      SetPedDensityMultiplierThisFrame(tonumber(0.0))
    else
      SetVehicleDensityMultiplierThisFrame(tonumber(traffic_density))
      SetRandomVehicleDensityMultiplierThisFrame(tonumber(traffic_density))
      SetParkedVehicleDensityMultiplierThisFrame(tonumber(traffic_density))
      SetPedDensityMultiplierThisFrame(tonumber(ped_density))
    end
  end
end)

---------------
-- Pickup snowballs
-- https://github.com/TomGrobbe/Snowballs
---------------
-- Snowballs disabled while 24/7 snow.
--[[
Citizen.CreateThread(function()
    showHelp = true
    while true do
        Citizen.Wait(0) -- prevent crashing
        if IsNextWeatherType('XMAS') then -- check for xmas weather type
            RequestAnimDict('anim@mp_snowball') -- pre-load the animation
            if IsControlJustReleased(0, 58) and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not IsPlayerFreeAiming(PlayerId()) and not IsPedSwimming(PlayerPedId()) and not IsPedSwimmingUnderWater(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedRunning(PlayerPedId()) and not IsPedSprinting(PlayerPedId()) then -- check if the snowball should be picked up
                TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 1, 0, 0, 0) -- pickup the snowball
                Citizen.Wait(1950) -- wait 1.95 seconds to prevent spam clicking and getting a lot of snowballs without waiting for animatin to finish.
                GiveWeaponToPed(GetPlayerPed(-1), GetHashKey('WEAPON_SNOWBALL'), 2, false, true) -- get 2 snowballs each time.
            end
        else
          if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_SNOWBALL') then
            ClearPedSecondaryTask(GetPlayerPed(-1))
          end
          RemoveWeaponFromPed(GetPlayerPed(-1),0x787F0BB) -- WEAPON_SNOWBALL
        end
        if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_SNOWBALL') then
            -- SetCanAttackFriendly(PlayerPedId(), false, false)
            SetPlayerWeaponDamageModifier(PlayerId(), 0.0)
            SetPedSuffersCriticalHits(PlayerPedId(), false)
        else
            -- SetCanAttackFriendly(PlayerPedId(), true, false)
            SetPedSuffersCriticalHits(PlayerPedId(), true)
        end
    end
end)
]]--
---------------------------------------------------------------
--Source https://github.com/D3uxx/hypr9stun
--Extended stun time

-- Included disable vehicle rewards
---------------------------------------------------------------
local stunTime = 7000 -- in miliseconds >> 1000 ms = 1s

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsPedBeingStunned(GetPlayerPed(-1)) then
      SetPedMinGroundTimeForStungun(GetPlayerPed(-1), stunTime)
    end
    DisablePlayerVehicleRewards(PlayerId())
  end
end)

---------------------------------------------------------------
--Source https://github.com/indilo53/fxserver-pubg_aim
--PUBG style aiming. Right click will toggle 1/3 mode. Hold it will still act as aiming
---------------------------------------------------------------
local useFirstPerson = false
local justpressed = 0
local lastThirdView = 0

Citizen.CreateThread( function()
  while true do
    Citizen.Wait(1)

    local playerId = PlayerId()

    if IsControlPressed(0, 25) then -- Right click/weapon aim
      justpressed = justpressed + 1
    end

    if IsControlJustReleased(0, 25) then -- Right click/weapon aim
      if justpressed < 20 then
        useFirstPerson = true
      end
      justpressed = 0
    end

    if useFirstPerson then
      local currentView = GetFollowPedCamViewMode()
      if currentView ~= 4 then
        lastThirdView = currentView
        SetFollowPedCamViewMode(4)
      else
        SetFollowPedCamViewMode(lastThirdView)
      end
    useFirstPerson = false
    end
  end
end)

------------------------------------------------------------------------------------------
-- Modify the vehicle traction value when not on a named road. Applies after specified time
-- resets when back on a road
------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
  local offRoadTime = 0
  local startingTraction = 1.0
  local baseTraction = 1.0
  local inVeh = false
  local pedVeh = nil
  local triggerValue = 100
  while true do
    Citizen.Wait(0)
    local playerPed = GetPlayerPed(-1)
    if GetPedInVehicleSeat(GetVehiclePedIsIn(playerPed, false), -1) == playerPed and IsPedOnAnyBike(playerPed) then
      pedVeh = GetVehiclePedIsIn(playerPed,false)
      if not inVeh then
        inVeh = true
        SetVehicleHandlingFloat(pedVeh,"CHandlingData","fTractionLossMult", baseTraction)
      end
      currentTraction = GetVehicleHandlingFloat(pedVeh,"CHandlingData","fTractionLossMult")
      -- TODO remove below output
      --missionText("traction"..currentTraction.." offroad "..offRoadTime,1)
      local pos = GetEntityCoords(playerPed)
      local onRoad = IsPointOnRoad(pos.x,pos.y,pos.z,pedVeh)
      if onRoad then
        if offRoadTime > 0 then
          SetVehicleHandlingFloat(pedVeh,"CHandlingData","fTractionLossMult", baseTraction)
        end
        offRoadTime = 0
      else
        if offRoadTime < triggerValue then
          offRoadTime = offRoadTime + 1
        else
          if offRoadTime == triggerValue then
            SetVehicleHandlingFloat(pedVeh, "CHandlingData","fTractionLossMult", 2.5)
            offRoadTime = triggerValue + 1
          end
        end
      end
    else
      if inVeh then
        if pedVeh ~= nil then
          SetVehicleHandlingFloat(pedVeh,"CHandlingData","fTractionLossMult", baseTraction)
        end
        offRoadTime = 0
        inVeh = false
      end
    end
  end
end)
-- TODO remove below function
function missionText(text, time)
        ClearPrints()
        SetTextEntry_2("STRING")
        AddTextComponentString(text)
        DrawSubtitleTimed(time, 1)
end

-------------------------------------------------------------------------------
-- Disable air control on vehicles. Also prevent rollover correction.
-------------------------------------------------------------------------------
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1)) then
      if not IsVehicleOnAllWheels(GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
        DisableControlAction(0, 59, true)
        DisableControlAction(0, 60, true)
        DisableControlAction(0, 61, true)
        DisableControlAction(0, 62, true)
        DisableControlAction(0, 63, true)
        DisableControlAction(0, 64, true)
      end
    end
  end
end)

-------------------------------------------------------------------------------
-- Title: Speed limiter.
-- Author: Serpico
-- Description: This script will restict the speed of the vehicle when
--              INPUT_MP_TEXT_CHAT_TEAM is pressed. To disable, press
--              INPUT_VEH_SUB_ASCEND + INPUT_MP_TEXT_CHAT_TEAM
-------------------------------------------------------------------------------
local useMph = true -- if false, it will display speed in kph

Citizen.CreateThread(function()
  local resetSpeedOnEnter = true
  while true do
    Citizen.Wait(0)
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed,false)
    if GetPedInVehicleSeat(vehicle, -1) == playerPed and IsPedInAnyVehicle(playerPed, false) then

      -- This should only happen on vehicle first entry to disable any old values
      if resetSpeedOnEnter then
        maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
        SetEntityMaxSpeed(vehicle, maxSpeed)
        resetSpeedOnEnter = false
      end
      -- Disable speed limiter
      if IsControlJustReleased(0,246) and IsControlPressed(0,131) then
        maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
        SetEntityMaxSpeed(vehicle, maxSpeed)
        showHelpNotification("Speed limiter disabled")
      -- Enable speed limiter
      elseif IsControlJustReleased(0,246) then
        cruise = GetEntitySpeed(vehicle)
        SetEntityMaxSpeed(vehicle, cruise)
        if useMph then
          cruise = math.floor(cruise * 2.23694 + 0.5)
          showHelpNotification("Speed limiter set to "..cruise.." mph. ~INPUT_VEH_SUB_ASCEND~ + ~INPUT_MP_TEXT_CHAT_TEAM~ to disable.")
        else
          cruise = math.floor(cruise * 3.6 + 0.5)
          showHelpNotification("Speed limiter set to "..cruise.." km/h. ~INPUT_VEH_SUB_ASCEND~ + ~INPUT_MP_TEXT_CHAT_TEAM~ to disable.")
        end
      end
    else
      resetSpeedOnEnter = true
    end
  end
end)

function showHelpNotification(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end

RegisterNetEvent('walkstyle')
AddEventHandler('walkstyle', function(style)
  Citizen.Trace(style)
  if style ~= "clear" then
    RequestAnimSet(style)
    while not HasAnimSetLoaded(style) do
      Citizen.Wait(0)
    end
    SetPedMovementClipset(GetPlayerPed(-1),style,0.2)
  else
    ResetPedMovementClipset(GetPlayerPed(-1), 0.2)
  end
end)
