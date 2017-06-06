
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

-- (deprecated, based on deprecated getNearestVehicle)
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

-- keep handcuffed animation
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(30000)
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
    if drag then
      local ped = GetPlayerPed(GetPlayerFromServerId(otherid))
      local myped = GetPlayerPed(-1)
      AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
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
      -- if cop, reset wanted level
    if cop then
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

