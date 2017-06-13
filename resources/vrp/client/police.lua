
-- this module define some police tools and functions

local handcuffed = false
local cop = false
-- set player as cop (true or false)
function tvRP.setCop(flag)
  SetPedAsCop(GetPlayerPed(-1),flag)
  cop = flag
end

function tvRP.isCop()
	return cop
end

-- HANDCUFF

function tvRP.toggleHandcuff()
  handcuffed = not handcuffed

  SetEnableHandcuffs(GetPlayerPed(-1), handcuffed)
  if handcuffed then
    tvRP.playAnim(true,{{"mp_arresting","idle",1}},true)
  else
    tvRP.stopAnim(true)
    SetPedStealthMovement(GetPlayerPed(-1),false,"")
  end
end

function tvRP.setHandcuffed(flag)
  if handcuffed ~= flag then
    tvRP.toggleHandcuff()
  end
end

function tvRP.isHandcuffed()
  return handcuffed
end

-- (experimental, based on experimental getNearestVehicle)
function tvRP.putInNearestVehicleAsPassenger(radius)
  local veh = tvRP.getNearestVehicle(radius)

  if IsEntityAVehicle(veh) then
    for i=1,GetVehicleMaxNumberOfPassengers(veh) do
      if IsVehicleSeatFree(veh,i) then
        SetPedIntoVehicle(GetPlayerPed(-1),veh,i)
        return true
      end
    end
  end

  return false
end

function tvRP.pullOutNearestVehicleAsPassenger(radius)
  local veh = tvRP.getNearestVehicle(radius)
  if IsEntityAVehicle(veh) then
    tvRP.ejectVehicle()
  end
  return false
end

function tvRP.putInNetVehicleAsPassenger(net_veh)
  local veh = NetworkGetEntityFromNetworkId(net_veh)
  if IsEntityAVehicle(veh) then
    for i=1,GetVehicleMaxNumberOfPassengers(veh) do
      if IsVehicleSeatFree(veh,i) then
        SetPedIntoVehicle(GetPlayerPed(-1),veh,i)
        return true
      end
    end
  end
end

function tvRP.putInVehiclePositionAsPassenger(x,y,z)
  local veh = tvRP.getVehicleAtPosition(x,y,z)
  if IsEntityAVehicle(veh) then
    for i=1,GetVehicleMaxNumberOfPassengers(veh) do
      if IsVehicleSeatFree(veh,i) then
        SetPedIntoVehicle(GetPlayerPed(-1),veh,i)
        return true
      end
    end
  end
end

function tvRP.impoundVehicle()
  local xa,ya,za = tvRP.getPosition()
  local nveh = tvRP.getNearestVehicle(2)
  if nveh ~= 0 then
    SetTimeout(10 * 1000, function()
      local nveh2 = tvRP.getNearestVehicle(2)
      if nveh == nveh2 then
        SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(nveh))
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(nveh))
        tvRP.notify("Vehicle Impounded.")
      else
        tvRP.notify("Vehicle Impound Cancelled.")
      end
    end)
  else
    tvRP.notify("No Owned Vehicle Nearby.")
  end
end

-- keep handcuffed animation
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10000)
    if handcuffed then
      tvRP.playAnim(true,{{"mp_arresting","idle",1}},true)
    end
  end
end)

-- force stealth movement while handcuffed (prevent use of fist and slow the player)
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if handcuffed then
      --SetPedStealthMovement(GetPlayerPed(-1),true,"")
      DisableControlAction(0, 24, active) -- Attack
      DisableControlAction(0, 25, active) -- Aim
      DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
      DisableControlAction(0,263,true) -- disable melee
      DisableControlAction(0,264,true) -- disable melee
      DisableControlAction(0,140,true) -- disable melee
      DisableControlAction(0,141,true) -- disable melee
      DisableControlAction(0,143,true) -- disable melee
      DisableControlAction(0,75,true) -- disable exit vehicle
      DisableControlAction(27,75,true) -- disable exit vehicle
    end
  end
end)

-- JAIL

local jail = nil

-- jail the player in a no-top no-bottom cylinder
function tvRP.jail(x,y,z,radius)
  tvRP.teleport(x,y,z) -- teleport to center
  jail = {x+0.0001,y+0.0001,z+0.0001,radius+0.0001}
  tvRP.setFriendlyFire(false)
end

-- unjail the player
function tvRP.unjail()
  jail = nil
  tvRP.setFriendlyFire(true)
end

function tvRP.isJailed()
  return jail ~= nil
end

-- Prison (time based)
local prison = nil
local prisonTime = 0

function tvRP.prison(time)
  local x = 1659.96997070313
  local y = 2605.52514648438
  local z = 45.5648880004883
  local radius = 158
  jail = nil -- release from HQ cell
  handcuffed = false -- release from restraints
  Citizen.Wait(5)
  tvRP.teleport(x,y,z) -- teleport to center
  prison = {x+0.0001,y+0.0001,z+0.0001,radius+0.0001}
  prisonTime = time * 60
  tvRP.setFriendlyFire(false)
end

-- unprison the player
function tvRP.unprison()
  prison = nil
  local ped = GetPlayerPed(-1)
  local x = 1851.15979003906
  local y = 2603.15283203125
  local z = 45.6285972595215
  tvRP.setFriendlyFire(true)
  SetEntityInvincible(ped, false)
  tvRP.teleport(x,y,z) -- teleport to center
end

function tvRP.isInPrison()
  return prison ~= nil
end

-- Escort

local otherid = 0
local drag = false

function tvRP.toggleEscort(pl)
  otherid = pl
  drag = not drag
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    if jail then
      local x,y,z = tvRP.getPosition()

      local dx = x-jail[1]
      local dy = y-jail[2]
      local dist = math.sqrt(dx*dx+dy*dy)

      if dist >= jail[4] then
        local ped = GetPlayerPed(-1)
        SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001) -- stop player

        -- normalize + push to the edge + add origin
        dx = dx/dist*jail[4]+jail[1]
        dy = dy/dist*jail[4]+jail[2]

        -- teleport player at the edge
        SetEntityCoordsNoOffset(ped,dx,dy,z,true,true,true)
      end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    if prison then
      local x,y,z = tvRP.getPosition()

      local dx = x-prison[1]
      local dy = y-prison[2]
      local dist = math.sqrt(dx*dx+dy*dy)
      local ped = GetPlayerPed(-1)
      if dist >= prison[4] then
        SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001) -- stop player

        -- normalize + push to the edge + add origin
        dx = dx/dist*prison[4]+prison[1]
        dy = dy/dist*prison[4]+prison[2]

        -- teleport player at the edge
        --1850.8837890625,2602.92724609375,45.6136436462402
        SetEntityCoordsNoOffset(ped,dx,dy,z,true,true,true)
      end
      RemoveAllPedWeapons(ped, true)
      SetEntityInvincible(ped, true)
      if IsPedInAnyVehicle(ped, false) then
          ClearPedTasksImmediately(ped)
      end
      tvRP.missionText("~r~Release from prison in ~w~" .. prisonTime .. " ~r~ seconds", 10)
      if prisonTime <= 0 then
        prison = nil
        tvRP.unprison()
      end
    end
  end
end)

Citizen.CreateThread(function() -- coma decrease thread
  while true do
    Citizen.Wait(1000)
    if prison then
      prisonTime = prisonTime-1
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    if drag then
      local ped = GetPlayerPed(GetPlayerFromServerId(otherid))
      local myped = GetPlayerPed(-1)
      AttachEntityToEntity(myped, ped, 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    else
      DetachEntity(GetPlayerPed(-1), true, false)
    end
  end
end)

-- WANTED

-- wanted level sync
local wanted_level = 0

function tvRP.applyWantedLevel(new_wanted)
  Citizen.CreateThread(function()
    ClearPlayerWantedLevel(PlayerId())
    SetPlayerWantedLevelNow(PlayerId(),false)
    wanted_level = new_wanted
  end)
end

-- update wanted level
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(2000)
      -- if cop, medic, in prison, in jail, reset wanted level. Also exempt them from wanted alerts
    if cop or tvRP.isMedic() or prison ~= nil or jail ~= nil then
      ClearPlayerWantedLevel(PlayerId())
      SetPlayerWantedLevelNow(PlayerId(),false)
    else
      local nwanted_level = GetPlayerWantedLevel(PlayerId())
      if nwanted_level ~= wanted_level then
        tvRP.applyWantedLevel(nwanted_level)
      end
      vRPserver.updateWantedLevel({nwanted_level})
    end
  end
end)

-- detect vehicle stealing
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    local ped = GetPlayerPed(-1)
    if IsPedTryingToEnterALockedVehicle(ped) or IsPedJacking(ped) or IsPedInMeleeCombat(ped) or IsPedShooting(ped) then
      Citizen.Wait(2000) -- wait x seconds before setting wanted
      local ok,vtype,name = tvRP.getNearestOwnedVehicle(5)
      if not ok then -- prevent stealing detection on owned vehicle
        for i=0,4 do -- keep wanted for 1 minutes 30 seconds
          tvRP.applyWantedLevel(2)
          Citizen.Wait(15000)
        end
      end
      Citizen.Wait(15000) -- wait 15 seconds before checking again
    end
  end
end)

local handup_state = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if IsControlJustPressed(1, 323) then --Start holding X
      if not IsEntityDead(GetPlayerPed(-1)) and not handcuffed then
        TriggerEvent("Handsup", source)
      end
      --TaskHandsUp(GetPlayerPed(-1), 1000, -1, -1, true) -- Perform animation.
    end
    if handup_state then
      DisableControlAction(0, 24, active) -- Attack
      DisableControlAction(0, 25, active) -- Aim
      DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
      DisableControlAction(0,263,true) -- disable melee
      DisableControlAction(0,264,true) -- disable melee
      DisableControlAction(0,140,true) -- disable melee
      DisableControlAction(0,141,true) -- disable melee
      DisableControlAction(0,143,true) -- disable melee
    end
  end
end)

RegisterNetEvent("Handsup")
AddEventHandler("Handsup", function()
  local lPed = GetPlayerPed(-1)
  if DoesEntityExist(lPed) then
    Citizen.CreateThread(function()
      RequestAnimDict("random@mugging3")
      while not HasAnimDictLoaded("random@mugging3") do
        Citizen.Wait(100)
      end

      if handup_state then
        ClearPedSecondaryTask(lPed)
        handup_state = false
      else
        TaskPlayAnim(lPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
        handup_state = true
      end
    end)
  end
end)

