local Keys = {
	["E"] = 38
}
-- this module define some police tools and functions

local handcuffed = false
local shackled = true
local cop = false
local copLevel = 0
local retiredcopLevel = 0
-- set player as cop (true or false)
function tvRP.setCop(flag)
  SetPedAsCop(GetPlayerPed(-1),flag)
  cop = flag
  if cop then
    escortThread()
    restrainThread()
    vRPserver.addPlayerToActivePolive({})
		TriggerEvent("CustomScripts:setCop",true)
		TriggerEvent('chat:addSuggestion', '/carmod', 'Toggle vehicle extras.',{{name = "extra", help = "Number 1-14"},{name = "toggle", help = "0 = on, 1 = off"}})
		TriggerEvent('chat:addSuggestion', '/carlivery', 'Toggle vehicle livery.',{{name = "livery", help = "1 - 4"}})
		TriggerEvent('chat:addSuggestion', '/headgear', 'Change current head gear.',{{name = "id", help = "Number"}})
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
    tvRP.RemoveGear("WEAPON_PUMPSHOTGUN")
    tvRP.RemoveGear("WEAPON_SMG")
    tvRP.RemoveGear("WEAPON_CARBINERIFLE")
    tvRP.RemoveGear("WEAPON_SPECIALCARBINE")
    vRPserver.removePlayerToActivePolive({})
		TriggerEvent("CustomScripts:setCop",false)
		TriggerEvent('chat:removeSuggestion', '/carmod')
		TriggerEvent('chat:removeSuggestion', '/carlivery')
		TriggerEvent('chat:removeSuggestion', '/headgear')
  end
end

function tvRP.isCop()
	return cop
end

function tvRP.setCopLevel(level)
  copLevel = tonumber(level)
end

function tvRP.getCopLevel()
  return copLevel or 0
end

function tvRP.setRetiredCopLevel(level)
  retiredcopLevel = tonumber(level)
end

function tvRP.getRetiredCopLevel(level)
  return retiredcopLevel or 0
end

-- HANDCUFF

function tvRP.toggleHandcuff()
  handcuffed = not handcuffed
  TriggerEvent("customscripts:handcuffed", handcuffed)
  ClearPedSecondaryTask(GetPlayerPed(-1))
	tvRP.UnSetProned()
	tvRP.UnSetCrouch()
  SetEnableHandcuffs(GetPlayerPed(-1), handcuffed)
  tvRP.closeMenu()
	vRPphone.forceClosePhone({})
  if handcuffed then
		if tvRP.getTransformerLock() then
			vRPserver.leaveArea({tvRP.getCurrentTransformer()})
		end
    tvRP.playAnim(false,{{"mp_arresting","idle",1}},true)
    tvRP.setActionLock(true)
    TriggerEvent('chat:setHandcuffState',true)
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'cuff', 0.1)
  else
    tvRP.stopAnim(false)
    tvRP.stopAnim(true)
    SetPedStealthMovement(GetPlayerPed(-1),false,"")
    shackled = true
    tvRP.setActionLock(false)
    TriggerEvent('chat:setHandcuffState',false)
  end
  tvRP.closeMenu()
	vRPphone.forceClosePhone({})
end

function tvRP.setHandcuffed(flag)
  if handcuffed ~= flag then
    tvRP.toggleHandcuff()
  end
end

function tvRP.isHandcuffed()
  return handcuffed
end

function tvRP.setAllowMovement(flag)
  shackled = flag
  tvRP.stopAnim(false)
  tvRP.stopAnim(true)
  if flag then
    tvRP.playAnim(false,{{"mp_arresting","idle",1}},true)
  else
    tvRP.playAnim(true,{{"mp_arresting","idle",1}},true)
  end
end

function tvRP.getAllowMovement()
  return shackled
end

function tvRP.putInNearestVehicleAsPassenger(radius)
  local veh = tvRP.getVehicleAtRaycast(radius)

  if IsEntityAVehicle(veh) then
    for i=1,math.max(GetVehicleMaxNumberOfPassengers(veh),3) do
      if IsVehicleSeatFree(veh,i) then
        TaskWarpPedIntoVehicle(GetPlayerPed(-1),veh,i)
        local carPedisIn = GetVehiclePedIsIn(playerPed, false)
        if carPedisIn ~= nil and carPedisIn == veh then
          tvRP.playAnim(true,{{"mp_arresting","idle",1}},true)
        end
        return true
      end
    end
  end

  return false
end

function tvRP.putInNearestVehicleAsPassengerBeta(radius)
  local player = GetPlayerPed(-1)
  local vehicle = tvRP.getVehicleAtRaycast(radius)

  if IsEntityAVehicle(vehicle) then
    for i=1,math.max(GetVehicleMaxNumberOfPassengers(vehicle),3) do
      if IsVehicleSeatFree(vehicle,i) then
				ClearPedTasks(player)
        TaskWarpPedIntoVehicle(player,vehicle,i)
				tvRP.stopEscort()
        local carPedisIn = GetVehiclePedIsIn(player, false)
        if carPedisIn ~= nil and carPedisIn == vehicle then
          tvRP.playAnim(true,{{"mp_arresting","idle",1}},true)
        end
        return true
      end
    end
  end

  return false
end

function tvRP.pullOutNearestVehicleAsPassenger(radius)
  local veh = tvRP.getVehicleAtRaycast(radius)
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

function tvRP.impoundVehicle(adminImpound)
	if adminImpound == nil then
		adminImpound = false
	end
  player = GetPlayerPed(-1)
  vehicle = GetVehiclePedIsIn(player, false)
  px, py, pz = table.unpack(GetEntityCoords(player, true))
  coordA = GetEntityCoords(player, true)
  local plate = nil
  local carName = nil

  for i = 1, cfg.max_players do
    coordB = GetOffsetFromEntityInWorldCoords(player, 0.0, (10.0)/i, 0.0)
    targetVehicle = tvRP.GetVehicleInDirection(coordA, coordB)
    if targetVehicle ~= nil and targetVehicle ~= 0 then
      vx, vy, vz = table.unpack(GetEntityCoords(targetVehicle, false))
        if GetDistanceBetweenCoords(px, py, pz, vx, vy, vz, false) then
          distance = GetDistanceBetweenCoords(px, py, pz, vx, vy, vz, false)
          break
        end
    end
  end
  impounded = false
  if distance ~= nil and distance <= 5 and targetVehicle ~= 0 or vehicle ~= 0 then

    if vehicle == 0 then
      vehicle = targetVehicle
    end

    carModel = GetEntityModel(vehicle)
    carName = GetDisplayNameFromVehicleModel(carModel)
    plate = GetVehicleNumberPlateText(vehicle)
    args = tvRP.stringsplit(plate)
		if args ~= nil then
	    plate = args[1]

	    SetEntityAsMissionEntity(vehicle,true,true)
	    SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle))
	    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
		else
			tvRP.notify("No Vehicle Nearby.")
			return
		end
  else
    -- This is a backup to the impound. Mainly will be triggered for motorcyles and bikes
    vehicle = tvRP.getVehicleAtRaycast(5)
    plate = GetVehicleNumberPlateText(vehicle)
    if plate ~= nil and vehicle ~= nil then
      args = tvRP.stringsplit(plate)
			if args ~= nil then
	      plate = args[1]
	      carModel = GetEntityModel(vehicle)
	      carName = GetDisplayNameFromVehicleModel(carModel)

	      SetEntityAsMissionEntity(vehicle,true,true)
	      SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle))
	      Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
			else
				tvRP.notify("No Vehicle Nearby.")
				return
			end
    end
  end
  -- check if the vehicle failed to impound. This happens if another player is nearby
  local vehicle_out = tvRP.searchForVeh(player,10,plate,carName)
  if plate ~= nil and carName ~= nil and not vehicle_out then
    impounded = true
		if adminImpound then
			tvRP.notify("Vehicle Deleted.")
    	vRPserver.setVehicleOutStatusPlate({plate,string.lower(carName),0,0})
		else
			tvRP.notify("Vehicle Impounded.")
			vRPserver.setVehicleOutStatusPlate({plate,string.lower(carName),0,1})
		end
  end
  if not impounded then
    tvRP.notify("No Vehicle Nearby.")
  end
end

-- keep handcuffed animation
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10000)
    if handcuffed then
      if not IsEntityPlayingAnim(GetPlayerPed(-1),"mp_arresting","idle",3) then
        if shackled then
          tvRP.playAnim(false,{{"mp_arresting","idle",1}},true)
        else
          tvRP.playAnim(true,{{"mp_arresting","idle",1}},true)
        end
      end
    end
  end
end)

-- force stealth movement while handcuffed (prevent use of fist and slow the player)
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if handcuffed then
      --SetPedStealthMovement(GetPlayerPed(-1),true,"")
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
      DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
    end
    -- Clean up weapons that ai drop (https://pastebin.com/8EuSv2r1)
    RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
    RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
    RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
    RemoveAllPickupsOfType(0x88EAACA7) -- golfclub
  end
end)

-- JAIL

local jail = nil

-- jail the player in a no-top no-bottom cylinder
function tvRP.jail(x,y,z,radius)
  tvRP.teleport(x,y,z) -- teleport to center
  jail = {x+0.0001,y+0.0001,z+0.0001,radius+0.0001}
  tvRP.setFriendlyFire(false)
  tvRP.setAllowMovement(false)
  TriggerEvent('chat:setJailState',true)
end

-- unjail the player
function tvRP.unjail()
  jail = nil
  tvRP.setFriendlyFire(true)
  TriggerEvent('chat:setJailState',false)
end

function tvRP.isJailed()
  return jail
end

-- Prison (time based)
local prison = nil
local prisonTime = 0

function tvRP.prison(time)
  local x = 1761.2507324219
  local y = 2552.001953125
  local z = 45.564987182617
  local radius = 15
  jail = nil -- release from HQ cell
  prison = {x+0.0001,y+0.0001,z+0.0001,radius+0.0001}
  tvRP.teleport(x,y,z) -- teleport to center
  prisonTime = time * 60
  tvRP.setFriendlyFire(false)
  tvRP.setHandcuffed(false)
  TriggerEvent('chat:setPrisonState',true)
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
  TriggerEvent('chat:setPrisonState',false)
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
    Citizen.Wait(30000)
    if prison then
			local ped = GetPlayerPed(-1)
			TriggerEvent("izone:isPlayerInZone", "prisonPen", function(cb)
        if cb ~= nil and not cb then
					SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)
					SetEntityCoordsNoOffset(ped,prison[1],prison[2],prison[3],true,true,true)
        end
      end)
      RemoveAllPedWeapons(ped, true)
      SetEntityInvincible(ped, true)
      if IsPedInAnyVehicle(ped, false) then
          ClearPedTasksImmediately(ped)
      end
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
			if prisonTime > 0 then
				tvRP.missionText("~r~Release from prison in ~w~" .. tonumber(prisonTime) .. " ~r~ seconds", 1500)
			else
				tvRP.missionText("~r~Release is being processed. You will be escorted out shortly.", 1500)
			end
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

function tvRP.stopEscort()
  escort = false
  otherPed = 0
end

function tvRP.getIsBeingEscorted()
	return escort
end

function escortPlayer()
	Citizen.CreateThread(function()
		while escort do
			Citizen.Wait(0)
			local myped = GetPlayerPed(-1)
			AttachEntityToEntity(myped, otherPed, 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		end
		DetachEntity(GetPlayerPed(-1), true, false)
	end)
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
				if target ~= 0 and IsEntityAPed(target) and (IsEntityPlayingAnim(target,"random@mugging3","handsup_standing_base",3) or IsEntityPlayingAnim( target, "random@arrests@busted", "idle_a", 3 )) then
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
			if nearServId ~= nil and not IsPedInAnyVehicle(ped, true) then
				local target = GetPlayerPed(GetPlayerFromServerId(nearServId))
				if target ~= 0 and IsEntityAPed(target) and IsEntityPlayingAnim(target,"mp_arresting","idle",3) and not IsPedInAnyVehicle(target, true) then
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
local robbingBank = false

function tvRP.robbingBank(status)
	robbingBank = status
	if not status then
    SetPlayerWantedLevel(PlayerId(),0,false)
    SetPlayerWantedLevelNow(PlayerId(),false)
	end
end

-- update wanted level
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    --ClearPlayerWantedLevel(PlayerId())
    SetPlayerWantedLevel(PlayerId(),0,false)
    SetPlayerWantedLevelNow(PlayerId(),false)
  end
end)

-- Hands up action by pressing X
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if IsControlJustPressed(1, 323) then --Start holding X
      if not IsEntityDead(GetPlayerPed(-1)) and not handcuffed and not tvRP.isInComa() then
				if ( IsEntityPlayingAnim( GetPlayerPed(-1), "random@arrests@busted", "idle_a", 3 ) ) then
					TaskPlayAnim( GetPlayerPed(-1), "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
					Wait (3000)
					TaskPlayAnim( GetPlayerPed(-1), "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )
					Wait (1000)
					ClearPedSecondaryTask(GetPlayerPed(-1))
				end
        if IsEntityPlayingAnim(GetPlayerPed(-1),"random@mugging3","handsup_standing_base",3) then
          ClearPedSecondaryTask(GetPlayerPed(-1))
        else
          tvRP.playAnim(true,{{"random@mugging3", "handsup_standing_base", 1}},true)
					vRPphone.forceClosePhone({})
        end
      end
      if tvRP.getTransformerLock() then
        vRPserver.leaveArea({tvRP.getCurrentTransformer()})
      end
    end
		if IsDisabledControlJustPressed( 0, 36 ) then
			if not IsEntityDead(GetPlayerPed(-1)) and not handcuffed and not tvRP.isInComa() and not IsPedInAnyVehicle(GetPlayerPed(-1), false) and not tvRP.isInWater() then
        if IsEntityPlayingAnim(GetPlayerPed(-1),"random@mugging3","handsup_standing_base",3) then
					ClearPedSecondaryTask(GetPlayerPed(-1))
          tvRP.kneelHU()
				end
				if IsEntityPlayingAnim( GetPlayerPed(-1), "random@arrests@busted", "idle_a", 3 ) then
					TaskPlayAnim( GetPlayerPed(-1), "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
					Wait (3000)
					TaskPlayAnim( GetPlayerPed(-1), "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )
					Wait (1000)
					ClearPedSecondaryTask(GetPlayerPed(-1))
				end
      end
		end
  end
end)

-- Weapon cleanup
Citizen.CreateThread( function()
  while true do
    Citizen.Wait(500)
    if not tvRP.synchronizedData["admin"]["wepAllowed"] then
        local ped = GetPlayerPed(-1)
    	local pos = GetEntityCoords(ped)
        if not cop then
    			if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, 136.17930603028, -761.70587158204, 234.15194702148, true) > 15
    			and GetDistanceBetweenCoords(pos.x, pos.y, pos.z, 2800.000, -3800.000, 100.000, true) > 250
    			and GetDistanceBetweenCoords(pos.x, pos.y, pos.z, 458.80065917968,-3094.4453125,6.0700526237488, true) > 29.75) then
    	      RemoveWeaponFromPed(ped,0x1D073A89) -- remove pumpshot shotgun. Only cops have access 0xDF711959
    	      RemoveWeaponFromPed(ped,0x83BF0278) -- carbine rifle from fbi2 vehicle
    	      RemoveWeaponFromPed(ped,0x3656C8C1) -- stun gun
    	      RemoveWeaponFromPed(ped,0x678B81B1) -- nightstick
    	      RemoveWeaponFromPed(ped,0x2BE6766B) -- WEAPON_SMG
    	      RemoveWeaponFromPed(ped,0x5EF9FEC4) -- WEAPON_COMBATPISTOL
    	      RemoveWeaponFromPed(ped,0xD205520E) -- WEAPON_HEAVYPISTOL
    	      RemoveWeaponFromPed(ped,0xC0A3098D) -- WEAPON_SPECIALCARBINE
    				local armour = GetPedArmour(GetPlayerPed(-1))
    				if armour > 25 then
    	      	SetPedArmour(ped,0)
    				end
    			end
        end

        if not tvRP.isMedic() and not cop then
          RemoveWeaponFromPed(GetPlayerPed(-1),0x497FACC3) -- WEAPON_FLARE
          RemoveWeaponFromPed(GetPlayerPed(-1),0x060EC506) -- WEAPON_FIREEXTINGUISHER
        end
        --RemoveWeaponFromPed(ped,0x05FC3C11) -- sniper rifle
        RemoveWeaponFromPed(ped,0x0C472FE2) -- heavy sniper rifle

    RemoveWeaponFromPed(ped,0xEFE7E2DF) -- WEAPON_ASSAULTSMG
    RemoveWeaponFromPed(ped,0xAF113F99) -- WEAPON_ADVANCEDRIFLE
    RemoveWeaponFromPed(ped,0x9D07F764) -- WEAPON_MG
    RemoveWeaponFromPed(ped,0x7FD62962) -- WEAPON_COMBATMG
    RemoveWeaponFromPed(ped,0x7846A318) -- WEAPON_SAWNOFFSHOTGUN
    RemoveWeaponFromPed(ped,0xE284C527) -- WEAPON_ASSAULTSHOTGUN
    RemoveWeaponFromPed(ped,0x9D61E50F) -- WEAPON_BULLPUPSHOTGUN
    RemoveWeaponFromPed(ped,0x33058E22) -- WEAPON_REMOTESNIPER
    RemoveWeaponFromPed(ped,0xA284510B) -- WEAPON_GRENADELAUNCHER
    RemoveWeaponFromPed(ped,0x4DD2DC56) -- WEAPON_GRENADELAUNCHER_SMOKE
    RemoveWeaponFromPed(ped,0xB1CA77B1) -- WEAPON_RPG
    RemoveWeaponFromPed(ped,0x687652CE) -- WEAPON_STINGER
    RemoveWeaponFromPed(ped,0x42BF8A85) -- WEAPON_MINIGUN
    RemoveWeaponFromPed(ped,0x93E220BD) -- WEAPON_GRENADE
    RemoveWeaponFromPed(ped,0x2C3731D9) -- WEAPON_STICKYBOMB
    RemoveWeaponFromPed(ped,0xFDBC8A50) -- WEAPON_SMOKEGRENADE
    RemoveWeaponFromPed(ped,0xA0973D5E) -- WEAPON_BZGAS
    RemoveWeaponFromPed(ped,0x24B17070) -- WEAPON_MOLOTOV
    RemoveWeaponFromPed(ped,0x61012683) -- WEAPON_GUSENBERG
    RemoveWeaponFromPed(ped,0x7F229F94) -- WEAPON_BULLPUPRIFLE
    RemoveWeaponFromPed(ped,0xA89CB99E) -- WEAPON_MUSKET
    RemoveWeaponFromPed(ped,0x3AABBBAA) -- WEAPON_HEAVYSHOTGUN
    RemoveWeaponFromPed(ped,0xC734385A) -- WEAPON_MARKSMANRIFLE
    RemoveWeaponFromPed(ped,0x63AB0442) -- WEAPON_HOMINGLAUNCHER
    --RemoveWeaponFromPed(ped,0x7F7497E5) -- WEAPON_FIREWORK
    RemoveWeaponFromPed(ped,0xAB564B93) -- WEAPON_PROXMINE
    --RemoveWeaponFromPed(ped,0x787F0BB) -- WEAPON_SNOWBALL
    RemoveWeaponFromPed(ped,0x47757124) -- WEAPON_FLAREGUN
    RemoveWeaponFromPed(ped,0xDC4DB296) -- WEAPON_MARKSMANPISTOL
    RemoveWeaponFromPed(ped,0x0A3D4D34) -- WEAPON_COMBATPDW
    RemoveWeaponFromPed(ped,0xD8DF3C3C) -- WEAPON_KNUCKLE
    RemoveWeaponFromPed(ped,0x6D544C99) -- WEAPON_RAILGUN
    RemoveWeaponFromPed(ped,0xDD5DF8D9) -- WEAPON_MACHETE
    RemoveWeaponFromPed(ped,0xEF951FBB) -- WEAPON_DBSHOTGUN
    RemoveWeaponFromPed(ped,0x624FE830) -- WEAPON_COMPACTRIFLE
    RemoveWeaponFromPed(ped,0x12E82D3D) -- WEAPON_AUTOSHOTGUN
    RemoveWeaponFromPed(ped,0x0781FE4A) -- WEAPON_COMPACTLAUNCHER
    --RemoveWeaponFromPed(ped,0xCD274149) -- WEAPON_BATTLEAXE
    RemoveWeaponFromPed(ped,0xBD248B55) -- WEAPON_MINISMG
    RemoveWeaponFromPed(ped,0xBA45E8B8) -- WEAPON_PIPEBOMB
    --RemoveWeaponFromPed(ped,0x94117305) -- WEAPON_POOLCUE
    --RemoveWeaponFromPed(ped,0x19044EE0) -- WEAPON_WRENCH

        RemoveWeaponFromPed(ped,0x22D8FE39) -- WEAPON_APPISTOL
        RemoveWeaponFromPed(ped,0xBFEFFF6D) -- WEAPON_ASSAULTRIFLE
        RemoveWeaponFromPed(ped,0x166218FF) -- WEAPON_PASSENGER_ROCKET
        RemoveWeaponFromPed(ped,0x13579279) -- WEAPON_AIRSTRIKE_ROCKET
        RemoveWeaponFromPed(ped,0x23C9F95C) -- WEAPON_BALL
        RemoveWeaponFromPed(ped,0xBEFDC581) -- WEAPON_VEHICLE_ROCKET
        RemoveWeaponFromPed(ped,0x48E7B178) -- WEAPON_BARBED_WIRE
        --RemoveWeaponFromPed(ped,0xBFE256D4) -- WEAPON_PISTOL_MK2
        RemoveWeaponFromPed(ped,0x78A97CD0) -- WEAPON_SMG_MK2
        RemoveWeaponFromPed(ped,0x394F415C) -- WEAPON_ASSAULTRIFLE_MK2
        RemoveWeaponFromPed(ped,0xFAD1F1C9) -- WEAPON_CARBINERIFLE_MK2
        RemoveWeaponFromPed(ped,0xDBBD7280) -- WEAPON_COMBATMG_MK2
        RemoveWeaponFromPed(ped,0xA914799) -- WEAPON_HEAVYSNIPER_MK2
        RemoveWeaponFromPed(ped,0xDB1AA450) -- WEAPON_MACHINEPISTOL
        RemoveWeaponFromPed(ped,0x13532244) -- WEAPON_MICROSMG
        -- RemoveWeaponFromPed(ped,0xAF3696A1﻿) -- WEAPON_RAYPISTOL
        -- RemoveWeaponFromPed(ped,0x476BF155﻿) -- WEAPON_RAYCARBINE
        -- RemoveWeaponFromPed(ped,0xB62D1F67﻿﻿) -- WEAPON_RAYMINIGUN
      end
  end
end)

---------------
--SPIKE STRIP
-- source https://forum.fivem.net/t/release-police-spike-strip-non-scripthook-version/41587
---------------
local spike_deployed = false

RegisterNetEvent('c_setSpike')
AddEventHandler('c_setSpike', function()
    tvRP.setSpikesOnGround()
end)

function tvRP.setSpikesOnGround()
  if not spike_deployed then
    local ped = GetPlayerPed(-1)
    local pedCoord = GetEntityCoords(ped)
    if DoesObjectOfTypeExistAtCoords(pedCoord["x"], pedCoord["y"], pedCoord["z"], 2.0, GetHashKey("P_ld_stinger_s"), true) then
      tvRP.pickupSpikestrip(pedCoord["x"],pedCoord["y"],pedCoord["z"])
    else
  		local rot = GetEntityHeading(ped)
  		local x, y, z = table.unpack(GetEntityCoords(ped, true))
  		local fx,fy,fz = table.unpack(GetEntityForwardVector(ped))
  		x = x+(fx*2.0)
  		y = y+(fy*2.0)

      spike = GetHashKey("P_ld_stinger_s")

      RequestModel(spike)
      while not HasModelLoaded(spike) do
        Citizen.Wait(1)
      end

      local object = CreateObject(spike, x, y, z, true, true, false) -- x+1
  		SetEntityHeading(object, rot-180)
  		PlaceObjectOnGroundProperly(object)
      tvRP.notify("Spikestrip deployed")
      tvRP.playAnim(true,{{"pickup_object","pickup_low",1}},false)
      spike_deployed = true
      Citizen.CreateThread(function()
        local spikeObj = object
        local spikex = x
        local spikey = y
        local spikez = z
        while spike_deployed do
          Citizen.Wait(5000)
          pedx, pedy, pedz = table.unpack(GetEntityCoords(ped, true))
          local distance = GetDistanceBetweenCoords(pedx,pedy,pedz,spikex,spikey,spikez)
          if distance > 25 then
            tvRP.pickupSpikestrip(spikex,spikey,spikez)
            spike_deployed = false
            tvRP.notify("Spikestrip returned")
          end
        end
      end)
    end
  else
    tvRP.pickupSpikestrip()
  end
end

function tvRP.pickupSpikestrip(x,y,z)
  if x == nil and y == nil and z == nil then
    local ped = GetPlayerPed(-1)
    local pedCoord = GetEntityCoords(ped)
    if DoesObjectOfTypeExistAtCoords(pedCoord["x"], pedCoord["y"], pedCoord["z"], 2.0, GetHashKey("P_ld_stinger_s"), true) then
      spike = GetClosestObjectOfType(pedCoord["x"], pedCoord["y"], pedCoord["z"], 2.0, GetHashKey("P_ld_stinger_s"), false, false, false)
      SetEntityAsMissionEntity(spike, true, true)
      DeleteObject(spike)
      spike_deployed = false
      tvRP.notify("Spikestrip returned")
      tvRP.playAnim(true,{{"pickup_object","pickup_low",1}},false)
      return true
    end
    return false
  else
    if DoesObjectOfTypeExistAtCoords(x, y, z, 0.9, GetHashKey("P_ld_stinger_s"), true) then
      spike = GetClosestObjectOfType(x, y, z, 0.9, GetHashKey("P_ld_stinger_s"), false, false, false)
      SetEntityAsMissionEntity(spike, true, true)
      DeleteObject(spike)
      spike_deployed = false
      return true
    end
    return false
  end
  return false
end

local odds_list = {
  "a",
  "b",
  "c",
  "d",
  "e",
}

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    local vehCoord = GetEntityCoords(veh)
    if IsPedInAnyVehicle(ped, false) then
      if DoesObjectOfTypeExistAtCoords(vehCoord["x"], vehCoord["y"], vehCoord["z"], 0.9, GetHashKey("P_ld_stinger_s"), true) then
        -- Front Driver
        rnd = math.random(#odds_list)
        if rnd == 1 or rnd == 3 or rnd == 5 then
          SetVehicleTyreBurst(veh, 0, true, 50.0)
        else
          SetVehicleTyreBurst(veh, 0, true, 5.0)
        end
        -- Front Passenger
        rnd = math.random(#odds_list)
        if rnd == 1 or rnd == 3 or rnd == 5 then
          SetVehicleTyreBurst(veh, 1, true, 50.0)
        else
          SetVehicleTyreBurst(veh, 1, true, 5.0)
        end
        Citizen.Wait(1000)
        -- Rear Driver
        rnd = math.random(#odds_list)
        if rnd == 2 or rnd == 4 then
          SetVehicleTyreBurst(veh, 2, true, 50.0)
        else
          SetVehicleTyreBurst(veh, 2, true, 5.0)
        end
        -- Rear Passenger
        rnd = math.random(#odds_list)
        if rnd == 2 or rnd == 4 then
          SetVehicleTyreBurst(veh, 3, true, 50.0)
        else
          SetVehicleTyreBurst(veh, 3, true, 5.0)
        end
        Citizen.Wait(1000)
        SetVehicleTyreBurst(veh, 4, true, 5.0)
        SetVehicleTyreBurst(veh, 5, true, 5.0)
        SetVehicleTyreBurst(veh, 6, true, 5.0)
        SetVehicleTyreBurst(veh, 7, true, 5.0)
       end
     end
   end
end)
--------------------------------------------------------------------------------------------------------------
-- Spike strip end
--------------------------------------------------------------------------------------------------------------

function tvRP.setArmour(amount)
  SetPedArmour(GetPlayerPed(-1),amount)
end

-- Hand on radio
-- Modified to prevent players from diyng while in animation
Citizen.CreateThread(function()
  while true do
    Citizen.Wait( 0 )
    local ped = PlayerPedId()
    if DoesEntityExist( ped ) and not IsEntityDead( ped ) and (tvRP.isCop() or tvRP.isMedic()) then
      if not tvRP.isInWater() then
        if not IsPauseMenuActive() then
          loadAnimDict( "random@arrests" )
          if IsControlJustReleased( 0, 20 ) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'off', 0.05)
            ClearPedTasks(ped)
            SetEnableHandcuffs(ped, false)
          else
            if IsControlJustPressed( 0, 20 ) and not IsPlayerFreeAiming(PlayerId()) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
              TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.05)
              TaskPlayAnim(ped, "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
              SetEnableHandcuffs(ped, true)
            elseif IsControlJustPressed( 0, 20 ) and IsPlayerFreeAiming(PlayerId()) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
              TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.05)
              TaskPlayAnim(ped, "random@arrests", "radio_chatter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
              SetEnableHandcuffs(ped, true)
            end
            if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "generic_radio_enter", 3) then
              DisableActions(ped)
            elseif IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "radio_chatter", 3) then
              DisableActions(ped)
            end
          end
        end
      else
        if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "generic_radio_enter", 3) or IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "radio_chatter", 3) then
          TriggerServerEvent('InteractSound_SV:PlayOnSource', 'off', 0.05)
          ClearPedTasks(ped)
          SetEnableHandcuffs(ped, false)
        end
      end
    end
  end
end )

function loadAnimDict( dict )
  while ( not HasAnimDictLoaded( dict ) ) do
    RequestAnimDict( dict )
    Citizen.Wait( 0 )
  end
end

function DisableActions(ped)
  DisableControlAction(1, 140, true)
  DisableControlAction(1, 141, true)
  DisableControlAction(1, 142, true)
  DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
  DisablePlayerFiring(ped, true) -- Disable weapon firing
end

-- Search for given vechile. Vehicle name and plate.
-- Returns true if found, false if not.
function tvRP.searchForVeh(player,radius,vplate,vname)
  player = GetPlayerPed(-1)
  px, py, pz = table.unpack(GetEntityCoords(player, true))
  coordA = GetEntityCoords(player, true)
  if player ~= nil and vplate ~= nil and vname ~= nil then
    if radius == nil then
      radius = 5
    end
    vehicle = GetVehiclePedIsIn(player, false)
    for i = 1, cfg.max_players do
      coordB = GetOffsetFromEntityInWorldCoords(player, 0.0, (10.0)/i, 0.0)
      targetVehicle = tvRP.GetVehicleInDirection(coordA, coordB)
      if targetVehicle ~= nil and targetVehicle ~= 0 then
        vx, vy, vz = table.unpack(GetEntityCoords(targetVehicle, false))
          if GetDistanceBetweenCoords(px, py, pz, vx, vy, vz, false) then
            distance = GetDistanceBetweenCoords(px, py, pz, vx, vy, vz, false)
            break
          end
      end
    end
    if distance ~= nil and distance <= 5 and targetVehicle ~= 0 or vehicle ~= 0 then

      if vehicle == 0 then
        vehicle = targetVehicle
      end
      carModel = GetEntityModel(vehicle)
      carName = GetDisplayNameFromVehicleModel(carModel)
      plate = GetVehicleNumberPlateText(vehicle)
      args = tvRP.stringsplit(plate)
			if args ~= nil then
	      plate = args[1]
	      if vplate == plate and string.lower(vname) == string.lower(carName) then
	        return true
	      else
	        return false
	      end
			else
				return false
			end
    else
      -- This is a backup to the impound. Mainly will be triggered for motorcyles and bikes
      vehicle = tvRP.getVehicleAtRaycast(5)
      plate = GetVehicleNumberPlateText(vehicle)
      if plate ~= nil and vehicle ~= nil then
        args = tvRP.stringsplit(plate)
				if args ~= nil then
	        plate = args[1]
	        carModel = GetEntityModel(vehicle)
	        carName = GetDisplayNameFromVehicleModel(carModel)
	        if vplate == plate and string.lower(vname) == string.lower(carName) then
	          return true
	        else
	          return false
	        end
				else
					return false
				end
      end
    end
    return false
  end
  return false
end

function tvRP.kneelHU()
	local player = GetPlayerPed( -1 )
	vRPphone.forceClosePhone({})
	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
		loadAnimDict( "random@arrests" )
		loadAnimDict( "random@arrests@busted" )
		if ( IsEntityPlayingAnim( player, "random@arrests@busted", "idle_a", 3 ) ) then
			TaskPlayAnim( player, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (3000)
			TaskPlayAnim( player, "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )
		else
			TaskPlayAnim( player, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (4000)
			TaskPlayAnim( player, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (500)
			TaskPlayAnim( player, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
			Wait (1000)
			TaskPlayAnim( player, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
		end
	end
end
