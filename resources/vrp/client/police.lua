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
    --escortThread()
    restrainThread()
    --cop = flag
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
      DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
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
  return jail
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
  tvRP.setHandcuffed(false)
  Citizen.Wait(5)
  tvRP.teleport(x,y,z) -- teleport to center
  prison = {x+0.0001,y+0.0001,z+0.0001,radius+0.0001}
  prisonTime = time * 60
  tvRP.setFriendlyFire(false)
end

-- unprison the player
function tvRP.unprison()
  prison = nil
  prisonTime = 0
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
  local recentlySynchronized = false
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
        vRPserver.updatePrisonTime({0})
      else
        -- Sync remaining prison time every 5 minutes
        if (math.fmod((prisonTime/60),5) == 0) and not recentlySynchronized then
          local timeLeft = prisonTime/60
          vRPserver.updatePrisonTime({timeLeft})
          -- this is to prevent spam of the above tunnel call
          recentlySynchronized = true
          SetTimeout(5000,function()
            recentlySynchronized = false
          end)
        end
      end
    end
  end
end)

Citizen.CreateThread(function() -- prison time decrease thread
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
    if not robbingBank then
      ClearPlayerWantedLevel(PlayerId())
      SetPlayerWantedLevelNow(PlayerId(),false)
    end
    if wanted_time_left < 1 and not (cop or tvRP.isMedic() or prison ~= nil or jail ~= nil) then
      vRPserver.updateWantedLevel({new_wanted})
      wanted_level = new_wanted
      wanted_time_left = 30
    end
    if not robbingBank then
      ClearPlayerWantedLevel(PlayerId())
      SetPlayerWantedLevelNow(PlayerId(),false)
    end
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
    Citizen.Wait(1)
      -- if cop, medic, in prison, in jail, reset wanted level. Also exempt them from wanted alerts
    if cop or tvRP.isMedic() or prison ~= nil or jail ~= nil then
      ClearPlayerWantedLevel(PlayerId())
      SetPlayerWantedLevelNow(PlayerId(),false)
    else
      local nwanted_level = GetPlayerWantedLevel(PlayerId())
      if nwanted_level ~= wanted_level then
        tvRP.applyWantedLevel(nwanted_level)
      end
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
        tvRP.applyWantedLevel(2)
      end
      Citizen.Wait(15000) -- wait 15 seconds before checking again
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

Citizen.CreateThread( function()
  while true do
    Citizen.Wait(500)
    if not cop then
      RemoveWeaponFromPed(GetPlayerPed(-1),0x1D073A89) -- remove pumpshot shotgun. Only cops have access 0xDF711959
      RemoveWeaponFromPed(GetPlayerPed(-1),0x83BF0278) -- carbine rifle from fbi2 vehicle
      RemoveWeaponFromPed(GetPlayerPed(-1),0x3656C8C1) -- stun gun
      RemoveWeaponFromPed(GetPlayerPed(-1),0x678B81B1) -- nightstick
      RemoveWeaponFromPed(GetPlayerPed(-1),0x2BE6766B) -- WEAPON_SMG
      RemoveWeaponFromPed(GetPlayerPed(-1),0x5EF9FEC4) -- WEAPON_COMBATPISTOL
      RemoveWeaponFromPed(GetPlayerPed(-1),0xD205520E) -- WEAPON_HEAVYPISTOL
      RemoveWeaponFromPed(GetPlayerPed(-1),0xC0A3098D) -- WEAPON_SPECIALCARBINE
    end
    RemoveWeaponFromPed(GetPlayerPed(-1),0x05FC3C11) -- sniper rifle
    RemoveWeaponFromPed(GetPlayerPed(-1),0x0C472FE2) -- heavy sniper rifle

    RemoveWeaponFromPed(GetPlayerPed(-1),0xEFE7E2DF) -- WEAPON_ASSAULTSMG
    RemoveWeaponFromPed(GetPlayerPed(-1),0xAF113F99) -- WEAPON_ADVANCEDRIFLE
    RemoveWeaponFromPed(GetPlayerPed(-1),0x9D07F764) -- WEAPON_MG
    RemoveWeaponFromPed(GetPlayerPed(-1),0x7FD62962) -- WEAPON_COMBATMG
    RemoveWeaponFromPed(GetPlayerPed(-1),0x7846A318) -- WEAPON_SAWNOFFSHOTGUN
    RemoveWeaponFromPed(GetPlayerPed(-1),0xE284C527) -- WEAPON_ASSAULTSHOTGUN
    RemoveWeaponFromPed(GetPlayerPed(-1),0x9D61E50F) -- WEAPON_BULLPUPSHOTGUN
    RemoveWeaponFromPed(GetPlayerPed(-1),0x33058E22) -- WEAPON_REMOTESNIPER
    RemoveWeaponFromPed(GetPlayerPed(-1),0xA284510B) -- WEAPON_GRENADELAUNCHER
    RemoveWeaponFromPed(GetPlayerPed(-1),0x4DD2DC56) -- WEAPON_GRENADELAUNCHER_SMOKE
    RemoveWeaponFromPed(GetPlayerPed(-1),0xB1CA77B1) -- WEAPON_RPG
    RemoveWeaponFromPed(GetPlayerPed(-1),0x687652CE) -- WEAPON_STINGER
    RemoveWeaponFromPed(GetPlayerPed(-1),0x42BF8A85) -- WEAPON_MINIGUN
    RemoveWeaponFromPed(GetPlayerPed(-1),0x93E220BD) -- WEAPON_GRENADE
    RemoveWeaponFromPed(GetPlayerPed(-1),0x2C3731D9) -- WEAPON_STICKYBOMB
    RemoveWeaponFromPed(GetPlayerPed(-1),0xFDBC8A50) -- WEAPON_SMOKEGRENADE
    RemoveWeaponFromPed(GetPlayerPed(-1),0xA0973D5E) -- WEAPON_BZGAS
    RemoveWeaponFromPed(GetPlayerPed(-1),0x24B17070) -- WEAPON_MOLOTOV
    RemoveWeaponFromPed(GetPlayerPed(-1),0x61012683) -- WEAPON_GUSENBERG
    RemoveWeaponFromPed(GetPlayerPed(-1),0x7F229F94) -- WEAPON_BULLPUPRIFLE
    RemoveWeaponFromPed(GetPlayerPed(-1),0x92A27487) -- WEAPON_DAGGER
    RemoveWeaponFromPed(GetPlayerPed(-1),0xA89CB99E) -- WEAPON_MUSKET
    RemoveWeaponFromPed(GetPlayerPed(-1),0x3AABBBAA) -- WEAPON_HEAVYSHOTGUN
    RemoveWeaponFromPed(GetPlayerPed(-1),0xC734385A) -- WEAPON_MARKSMANRIFLE
    RemoveWeaponFromPed(GetPlayerPed(-1),0x63AB0442) -- WEAPON_HOMINGLAUNCHER
	RemoveWeaponFromPed(GetPlayerPed(-1),0x7F7497E5) -- WEAPON_FIREWORK
    RemoveWeaponFromPed(GetPlayerPed(-1),0xAB564B93) -- WEAPON_PROXMINE
    RemoveWeaponFromPed(GetPlayerPed(-1),0x787F0BB) -- WEAPON_SNOWBALL
    RemoveWeaponFromPed(GetPlayerPed(-1),0x47757124) -- WEAPON_FLAREGUN
    RemoveWeaponFromPed(GetPlayerPed(-1),0xDC4DB296) -- WEAPON_MARKSMANPISTOL
    RemoveWeaponFromPed(GetPlayerPed(-1),0x0A3D4D34) -- WEAPON_COMBATPDW
    RemoveWeaponFromPed(GetPlayerPed(-1),0xD8DF3C3C) -- WEAPON_KNUCKLE
    RemoveWeaponFromPed(GetPlayerPed(-1),0x6D544C99) -- WEAPON_RAILGUN
    RemoveWeaponFromPed(GetPlayerPed(-1),0xDD5DF8D9) -- WEAPON_MACHETE
    RemoveWeaponFromPed(GetPlayerPed(-1),4019527611) -- WEAPON_DBSHOTGUN
    RemoveWeaponFromPed(GetPlayerPed(-1),1649403952) -- WEAPON_COMPACTRIFLE
    RemoveWeaponFromPed(GetPlayerPed(-1),0x12E82D3D) -- WEAPON_AUTOSHOTGUN
    RemoveWeaponFromPed(GetPlayerPed(-1),0x0781FE4A) -- WEAPON_COMPACTLAUNCHER
    RemoveWeaponFromPed(GetPlayerPed(-1),0xCD274149) -- WEAPON_BATTLEAXE
    RemoveWeaponFromPed(GetPlayerPed(-1),0xBD248B55) -- WEAPON_MINISMG
    RemoveWeaponFromPed(GetPlayerPed(-1),0xBA45E8B8) -- WEAPON_PIPEBOMB
    RemoveWeaponFromPed(GetPlayerPed(-1),0x94117305) -- WEAPON_POOLCUE
    RemoveWeaponFromPed(GetPlayerPed(-1),0x19044EE0) -- WEAPON_WRENCH

    RemoveWeaponFromPed(GetPlayerPed(-1),0x22D8FE39) -- WEAPON_APPISTOL
    RemoveWeaponFromPed(GetPlayerPed(-1),0xBFEFFF6D) -- WEAPON_ASSAULTRIFLE
    RemoveWeaponFromPed(GetPlayerPed(-1),0x166218FF) -- WEAPON_PASSENGER_ROCKET
    RemoveWeaponFromPed(GetPlayerPed(-1),0x13579279) -- WEAPON_AIRSTRIKE_ROCKET
    RemoveWeaponFromPed(GetPlayerPed(-1),0x23C9F95C) -- WEAPON_BALL
    RemoveWeaponFromPed(GetPlayerPed(-1),0xBEFDC581) -- WEAPON_VEHICLE_ROCKET
    RemoveWeaponFromPed(GetPlayerPed(-1),0x48E7B178) -- WEAPON_BARBED_WIRE
  end
end)

---------------
--SPIKE STRIP
---------------
RegisterNetEvent('c_setSpike')
AddEventHandler('c_setSpike', function()
    SetSpikesOnGround()
end)

function SetSpikesOnGround()
    x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))

    spike = GetHashKey("P_ld_stinger_s")

    RequestModel(spike)
    while not HasModelLoaded(spike) do
      Citizen.Wait(1)
    end

    local object = CreateObject(spike, x, y+2, z, true, true, false) -- x+1
    local direction = GetEntityHeading(GetPlayerPed(-1))
    PlaceObjectOnGroundProperly(object)
    SetEntityRotation(object,0.0,0.0,direction,0,true)
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    local vehCoord = GetEntityCoords(veh)
    if IsPedInAnyVehicle(ped, false) then
      if DoesObjectOfTypeExistAtCoords(vehCoord["x"], vehCoord["y"], vehCoord["z"], 0.9, GetHashKey("P_ld_stinger_s"), true) then
         RemoveSpike()
         SetVehicleTyreBurst(veh, 0, true, 1000.0)
         SetVehicleTyreBurst(veh, 1, true, 1000.0)
         Citizen.Wait(200)
         SetVehicleTyreBurst(veh, 2, true, 1000.0)
         SetVehicleTyreBurst(veh, 3, true, 1000.0)
         Citizen.Wait(200)
         SetVehicleTyreBurst(veh, 4, true, 1000.0)
         SetVehicleTyreBurst(veh, 5, true, 1000.0)
         SetVehicleTyreBurst(veh, 6, true, 1000.0)
         SetVehicleTyreBurst(veh, 7, true, 1000.0)
       end
     end
   end
end)

function RemoveSpike()
   local ped = GetPlayerPed(-1)
   local veh = GetVehiclePedIsIn(ped, false)
   local vehCoord = GetEntityCoords(veh)
   if DoesObjectOfTypeExistAtCoords(vehCoord["x"], vehCoord["y"], vehCoord["z"], 0.9, GetHashKey("P_ld_stinger_s"), true) then
      spike = GetClosestObjectOfType(vehCoord["x"], vehCoord["y"], vehCoord["z"], 0.9, GetHashKey("P_ld_stinger_s"), false, false, false)
      SetEntityAsMissionEntity(spike, true, true)
      DeleteObject(spike)
   end
end

function tvRP.setArmour(amount)
  SetPedArmour(GetPlayerPed(-1),amount)
end
