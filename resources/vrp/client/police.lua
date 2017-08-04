local Keys = {
	["E"] = 38
}
-- this module define some police tools and functions

local handcuffed = false
local shackled = false
local cop = false

-- set player as cop (true or false)
function tvRP.setCop(flag)
  SetPedAsCop(GetPlayerPed(-1),flag)
  cop = flag
  if cop then
    escortThread()
    restrainThread()
  else
    -- Remove cop weapons when going off duty
    RemoveWeaponFromPed(GetPlayerPed(-1),0x678B81B1) -- WEAPON_NIGHTSTICK
    RemoveWeaponFromPed(GetPlayerPed(-1),0x3656C8C1) -- WEAPON_STUNGUN
    RemoveWeaponFromPed(GetPlayerPed(-1),0x5EF9FEC4) -- WEAPON_COMBATPISTOL
    RemoveWeaponFromPed(GetPlayerPed(-1),0xD205520E) -- WEAPON_HEAVYPISTOL
    RemoveWeaponFromPed(GetPlayerPed(-1),0x1D073A89) -- WEAPON_PUMPSHOTGUN
    RemoveWeaponFromPed(GetPlayerPed(-1),0x2BE6766B) -- WEAPON_SMG
    RemoveWeaponFromPed(GetPlayerPed(-1),0x83BF0278) -- WEAPON_CARBINERIFLE
    RemoveWeaponFromPed(GetPlayerPed(-1),0xC0A3098D) -- WEAPON_SPECIALCARBINE
    RemoveWeaponFromPed(GetPlayerPed(-1),0x8BB05FD7) -- WEAPON_FLASHLIGHT
    RemoveWeaponFromPed(GetPlayerPed(-1),0x34A67B97) -- WEAPON_PETROLCAN
    RemoveWeaponFromPed(GetPlayerPed(-1),0x497FACC3) -- WEAPON_FLARE
  end
end

function tvRP.isCop()
	return cop
end

-- HANDCUFF

function tvRP.toggleHandcuff()
  handcuffed = not handcuffed

  ClearPedSecondaryTask(GetPlayerPed(-1))
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
    for i=1,math.max(GetVehicleMaxNumberOfPassengers(veh),3) do
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
    tvRP.notify("Vehicle impounded process started. Walk away to cancel.")
    SetTimeout(5 * 1000, function()
      local nveh2 = tvRP.getNearestVehicle(2)
      if nveh == nveh2 then
        SetEntityAsMissionEntity(nveh,true,true)
        SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(nveh))
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(nveh))
        tvRP.notify("Vehicle Impounded.")
      else
        tvRP.notify("Vehicle Impound Cancelled.")
      end
    end)
  else
    tvRP.notify("No Vehicle Nearby.")
  end
end

-- keep handcuffed animation
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10000)
    if handcuffed then
      if not IsEntityPlayingAnim(GetPlayerPed(-1),"mp_arresting","idle",3) then
	      tvRP.playAnim(true,{{"mp_arresting","idle",1}},true)
	    end
		end
  end
end)

-- force stealth movement while handcuffed (prevent use of fist and slow the player)
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if handcuffed then
      SetPedStealthMovement(GetPlayerPed(-1),true,"")
      DisableControlAction(0,21,true) -- disable sprint
      DisableControlAction(0,24,true) -- disable attack
      DisableControlAction(0,25,true) -- disable aim
      DisableControlAction(0,47,true) -- disable weapon
      DisableControlAction(0,58,true) -- disable weapon
      DisableControlAction(0,263,true) -- disable melee
      DisableControlAction(0,264,true) -- disable melee
      DisableControlAction(0,257,true) -- disable melee
      DisableControlAction(0,140,true) -- disable melee
      DisableControlAction(0,141,true) -- disable melee
      DisableControlAction(0,142,true) -- disable melee
      DisableControlAction(0,143,true) -- disable melee
      DisableControlAction(0,75,true) -- disable exit vehicle
      DisableControlAction(27,75,true) -- disable exit vehicle
      DisableControlAction(0,21,true) -- disable sprint
      DisableControlAction(0,36,true) -- disable exit duck
      DisableControlAction(0,47,true) -- disable weapon
      DisableControlAction(0,58,true) -- disable weapon
      DisableControlAction(0,257,true) -- disable melee
      DisableControlAction(0,44,true) -- disable cover
      DisableControlAction(0,22,true) -- disable cover
    end
    -- Clean up weapons that ai drop (https://pastebin.com/8EuSv2r1)
    RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
    RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
    RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
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
  return prison
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

-- Escort

local otherPed = 0
local escort = false

function tvRP.toggleEscort(pl)
  otherPed = GetPlayerPed(GetPlayerFromServerId(pl))
  escort = not escort
  if escort then escortPlayer() end
end

function escortPlayer()
	while escort do
		Citizen.Wait(5)
		local myped = GetPlayerPed(-1)
		AttachEntityToEntity(myped, otherPed, 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
	end
	DetachEntity(GetPlayerPed(-1), true, false)
end

function restrainThread()
	Citizen.CreateThread(function()
		while cop do
			Citizen.Wait(10)
			local ped = GetPlayerPed(-1)
			local pos = GetEntityCoords(ped)
			local nearServId = tvRP.getNearestPlayer(2)
			if nearServId ~= nil then
				local target = GetPlayerPed(GetPlayerFromServerId(nearServId))
				if target ~= 0 and IsEntityAPed(target) and IsEntityPlayingAnim(target,"random@mugging3","handsup_standing_base",3) then
					if HasEntityClearLosToEntityInFront(ped,target) then
						DisplayHelpText("Press ~g~E~s~ to restrain")
						if IsControlJustReleased(1, Keys['E']) then
							vRPserver.restrainPlayer({nearServId})
						end
					end
				end
			end
		end
	end)
end

function escortThread()
	Citizen.CreateThread(function()
		while cop do
			Citizen.Wait(10)
			local ped = GetPlayerPed(-1)
			local pos = GetEntityCoords(ped)
			local nearServId = tvRP.getNearestPlayer(2)
			if nearServId ~= nil then
				local target = GetPlayerPed(GetPlayerFromServerId(nearServId))
				if target ~= 0 and IsEntityAPed(target) and IsEntityPlayingAnim(target,"mp_arresting","idle",3) then
					if HasEntityClearLosToEntityInFront(ped,target) then
						DisplayHelpText("Press ~g~E~s~ to escort")
						if IsControlJustReleased(1, Keys['E']) then
							vRPserver.escortPlayer({nearServId})
						end
					end
				end
			end
		end
	end)
end


-- WANTED

-- wanted level sync
local wanted_level = 0
local wanted_time_left = 0
local robbingBank = false

function tvRP.applyWantedLevel(new_wanted)
  Citizen.CreateThread(function()
    local old_wanted = GetPlayerWantedLevel(PlayerId())
    local wanted = math.max(old_wanted,new_wanted)
    ClearPlayerWantedLevel(PlayerId())
    SetPlayerWantedLevelNow(PlayerId(),false)
    Citizen.Wait(10)
    SetPlayerWantedLevel(PlayerId(),wanted,false)
    SetPlayerWantedLevelNow(PlayerId(),false)
  end)
end

function tvRP.robbingBank(status)
	robbingBank = status
	if not status then
		tvRP.applyWantedLevel(0)
	end
end

Citizen.CreateThread(function() -- coma decrease thread
  while true do
    Citizen.Wait(1000)
    if wanted_time_left > 0 then
      wanted_time_left = wanted_time_left-1
    end
  end
end)

-- update wanted level
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(2000)

    -- if cop, reset wanted level
    if cop then
      ClearPlayerWantedLevel(PlayerId())
      SetPlayerWantedLevelNow(PlayerId(),false)
    end

    -- update level
    local nwanted_level = GetPlayerWantedLevel(PlayerId())
    if nwanted_level ~= wanted_level then
      wanted_level = nwanted_level
      vRPserver.updateWantedLevel({wanted_level})
    end
  end
end)

-- detect vehicle stealing
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    local ped = GetPlayerPed(-1)
    if IsPedJacking(ped) then
      Citizen.Wait(2000) -- wait x seconds before setting wanted
      local ok,vtype,name = tvRP.getNearestOwnedVehicle(5)
      if not ok then -- prevent stealing detection on owned vehicle
        for i=0,4 do -- keep wanted for 1 minutes 30 seconds
          tvRP.applyWantedLevel(2)
          Citizen.Wait(15000)
        end
      end
		end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    local ped = GetPlayerPed(-1)
    if IsPedInMeleeCombat(ped) or IsPedShooting(ped) then
      Citizen.Wait(2000) -- wait x seconds before setting wanted
      tvRP.applyWantedLevel(2)
      Citizen.Wait(15000) -- wait 15 seconds before checking again
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if IsControlJustPressed(1, 323) then --Start holding X
      if not IsEntityDead(GetPlayerPed(-1)) and not handcuffed then
        if IsEntityPlayingAnim(GetPlayerPed(-1),"random@mugging3","handsup_standing_base",3) then
          ClearPedSecondaryTask(GetPlayerPed(-1))
        else
          tvRP.playAnim(true,{{"random@mugging3", "handsup_standing_base", 1}},true)
        end
      end
    end
  end
end)
