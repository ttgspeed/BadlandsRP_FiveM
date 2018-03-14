-- api
local Keys = {["E"] = 38,["ENTER"] = 18,["Y"] = 246}
local intoxication_duration = 2 -- Amount of time (in minutes) it takes for one drink to wear off
local intoxication = 0
local forceRespawn = false


function tvRP.varyHealth(variation)
	local ped = GetPlayerPed(-1)

	local n = math.floor(GetEntityHealth(ped)+variation)
	SetEntityHealth(ped,n)
end

--vary the players health over a given time period in seconds
function tvRP.varyHealthOverTime(variation,variationTime)
	Citizen.CreateThread(function()
		local ped = GetPlayerPed(-1)
		local count = math.abs(variation)
		variationTime = (variationTime/math.abs(variation))*1000
		variation = variation/(math.abs(variation))
		while count >= 0 do
			if tvRP.isInComa() then break end
			count = count - 1
			local n = math.floor(GetEntityHealth(ped)+variation)
			SetEntityHealth(ped,n)
			Citizen.Wait(variationTime)
		end
	end)
end

function tvRP.getHealth()
	return GetEntityHealth(GetPlayerPed(-1))
end

function tvRP.setHealth(health)
	local n = math.floor(health)
	SetEntityHealth(GetPlayerPed(-1),n)
end

function tvRP.setFriendlyFire(flag)
	NetworkSetFriendlyFireOption(flag)
	SetCanAttackFriendly(GetPlayerPed(-1), flag, flag)
end

function tvRP.setPolice(flag)
	local player = PlayerId()
	SetPoliceIgnorePlayer(player, not flag)
	SetDispatchCopsForPlayer(player, flag)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- impact thirst and hunger when the player is running (every 5 seconds)

Citizen.CreateThread(function()
	local current_cycle = 0
	local tick_cycle = 12 -- will trigger every 1 min. 60000/5000
	while true do
		Citizen.Wait(5000)

		if IsPlayerPlaying(PlayerId()) then
			local ped = GetPlayerPed(-1)
			if not tvRP.isHandcuffed() and tvRP.isJailed() == nil and tvRP.isInPrison() == nil and not in_coma then

				-- variations for one minute
				local vthirst = 0
				local vhunger = 0

				-- on foot, increase thirst/hunger in function of velocity
				if IsPedOnFoot(ped) and not tvRP.isNoclip() then
					local factor = math.min(tvRP.getSpeed(),10)

					vthirst = vthirst+1*factor
					vhunger = vhunger+0.5*factor
				end

				-- in melee combat, increase
				if IsPedInMeleeCombat(ped) then
					vthirst = vthirst+10
					vhunger = vhunger+5
				end

				-- injured, hurt, increase
				if IsPedHurt(ped) or IsPedInjured(ped) then
					vthirst = vthirst+2
					vhunger = vhunger+1
				end

				-- do variation
				--if vthirst ~= 0 then
				--	vRPserver.varyThirst({vthirst/12.0})
				--end

				--if vhunger ~= 0 then
				--	vRPserver.varyHunger({vhunger/12.0})
				--end

				if current_cycle >= tick_cycle then
					local thirstTick = cfg.thirst_per_minute
					local hungerTick = cfg.hunger_per_minute
					-- TODO look further why cfg.thirst_per_minute was nil???
					if thirstTick == nil then
						thirstTick = 0.5
					end
					if hungerTick == nil then
						hungerTick = 0.5
					end
					vRPserver.varyThirst({thirstTick})
					vRPserver.varyHunger({hungerTick})
					current_cycle = 0
				else
					current_cycle = current_cycle + 1
				end
			end
		end
	end
end)

function tvRP.play_alcohol()
	intoxication = intoxication + 10
	if (intoxication > 0 and intoxication < 40) then
		buzzed()
	elseif (intoxication > 40) then
		drunk()
	end
end

function sober()
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	ClearTimecycleModifier()
	ResetPedMovementClipset(GetPlayerPed(-1), 0)
	SetPedIsDrunk(GetPlayerPed(-1), false)
	SetPedMotionBlur(GetPlayerPed(-1), false)
	DoScreenFadeIn(1000)
end

function buzzed()
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	SetTimecycleModifier("spectator5")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(GetPlayerPed(-1), true)
	DoScreenFadeIn(1000)
end

function drunk()
	RequestAnimSet("move_m@drunk@verydrunk")
	while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
		Citizen.Wait(0)
	end

	SetTimecycleModifier("spectator5")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedMovementClipset(GetPlayerPed(-1), "move_m@drunk@verydrunk", true)
	SetPedIsDrunk(GetPlayerPed(-1), true)
end

-- tick away at players intoxication
Citizen.CreateThread(function()
	while true do
		if intoxication > 0 then
			intoxication = intoxication - 1
			if intoxication == 0 then
				sober()
			else
				--None of this works right now. Will fix later.
				local evt = math.random(1,10)
				-- local amount = math.random(1,intoxication)*100
				-- local gait = math.random(1,20)*100
				-- local speed = math.random(1,intoxication)*10
				-- local ped = GetPlayerPed(-1)
				if (evt < 4 and IsPedSittingInAnyVehicle(ped)) then
					--SimulatePlayerInputGait(PlayerId(), amount, gait, speed, 1, 0)
				elseif (evt == 4) then
					DoScreenFadeOut(1000)
					Citizen.Wait(1000)
					DoScreenFadeIn(1000)
				end
			end
		end
		Citizen.Wait(6000*intoxication_duration)
	end
end)

-- COMA SYSTEM

local in_coma = false
local coma_left = 0
local in_coma_time = 0
local emergencyCalled = false
local knocked_out = false
local revived = false
local check_delay = 0
local medicalCount = 0

function deathDetails()
	local ped = GetPlayerPed(-1)
	local player = PlayerId()
	local killer, killerweapon = NetworkGetEntityKillerOfPlayer(player)
	local killerentitytype = GetEntityType(killer)
	local killertype = -1
	local killerinvehicle = "false"
	local killervehiclename = ''
	local killervehicleseat = 0
	if killerentitytype == 1 then
		killertype = GetPedType(killer)
		if IsPedInAnyVehicle(killer, false) == 1 then
			killerinvehicle = "true"
			killervehiclename = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(killer)))
			killervehicleseat = GetPedVehicleSeat(killer)
		else
			killerinvehicle = "false"
		end
	end

	local killerid = GetPlayerByEntityID(killer)
	if killer ~= ped and killerid ~= nil and NetworkIsPlayerActive(killerid) then
		killerid = GetPlayerServerId(killerid)
	else
		killerid = -1
	end

	-- Killer is not a player or self
	if killer == ped or killer == -1 then
		knocked_out = false
		local x,y,z = table.unpack(GetEntityCoords(ped))
		vRPserver.logDeathEventBySelf({x,y,z})
	-- Killer is player
	else
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local kx,ky,kz = table.unpack(GetEntityCoords(GetPlayerPed(killerid)))
		killer_vRPid = tvRP.getUserId(GetPlayerPed(killerid))
		--if killerweapon == 2725352035 then -- 2725352035 = unarmed
		--	if not knocked_out then
		--		coma_left = cfg.knockout_duration*60
		--	end
		--	knocked_out = true
		--else
			knocked_out = false
		--end
		vRPserver.logDeathEventByPlayer({x,y,z,kx,ky,kz,killertype,killerweapon,killerinvehicle,killervehicleseat,killervehiclename,killer_vRPid})
	end
end

Citizen.CreateThread(function()
	-- main loop thing
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local player = PlayerId()
		local pedPos = GetEntityCoords(ped, nil)

		-- Dead player detect. Find damage cause and apply coma or knocked out state
		if IsEntityDead(ped) then
			revived = false
			if not tvRP.isAdmin() then
				tvRP.closeMenu()
			end
			if not in_coma then
				check_delay = 30

				deathDetails()

				local x,y,z = tvRP.getPosition()
				NetworkResurrectLocalPlayer(x, y, z, true, true, false)
				Citizen.Wait(1)
				SetEveryoneIgnorePlayer(PlayerId(), true)
				vRPserver.updateHealth({cfg.coma_threshold}) -- force health update
				SetEntityHealth(ped, cfg.coma_threshold)

				if not knocked_out then
					in_coma = true
					TriggerEvent('chat:setComaState',true)
					vRPserver.setAliveState({0})
					coma_left = cfg.coma_duration*60
					vRPserver.setLastDeath({})
					-- 	local moneybag = CreateObject(0x113FD533, pedPos.x, pedPos.y, pedPos.z, true, false, false)
				end
				vRPserver.stopEscortRemote({2})

				tvRP.playScreenEffect(cfg.coma_effect,-1)
				tvRP.ejectVehicle()
				tvRP.setRagdoll(true)
				--Citizen.Trace("I got here")
			else
				--Citizen.Trace("I got here 2")
				local x,y,z = tvRP.getPosition()
				NetworkResurrectLocalPlayer(x, y, z, true, true, false)
				Citizen.Wait(1)
				if not knocked_out then
					in_coma = true
					TriggerEvent('chat:setComaState',true)
					vRPserver.setAliveState({0})
					SetEntityInvincible(ped,true)
				end
				vRPserver.updateHealth({cfg.coma_threshold}) -- force health update
				SetEntityHealth(ped, cfg.coma_threshold)

				tvRP.playScreenEffect(cfg.coma_effect,-1)
				tvRP.ejectVehicle()
				tvRP.setRagdoll(true)
			end
		else
			if knocked_out and not in_coma then
				if not tvRP.isAdmin() then
					tvRP.closeMenu()
				end
				SetEveryoneIgnorePlayer(PlayerId(), true)
				tvRP.missionText("~r~Knocked Out", 10)
				if coma_left <= 0 then
					check_delay = 30
					knocked_out = false
					tvRP.setRagdoll(false)
					tvRP.stopScreenEffect(cfg.coma_effect)
					SetEntityHealth(ped,cfg.coma_threshold + 5) --heal out of coma
				end
			elseif in_coma then
				if not tvRP.isAdmin() then
					tvRP.closeMenu()
				end
				SetEntityInvincible(ped,true)
				SetEveryoneIgnorePlayer(PlayerId(), true)

				-- Promp and check for revive
				promptForRevive()

				-- Maintain player health
				if GetEntityHealth(ped) < cfg.coma_threshold then
					SetEntityHealth(ped, cfg.coma_threshold)
				end

				bleedOutTime = cfg.max_bleed_out - in_coma_time
				-- Waiting for respawn
				if coma_left > 0 and bleedOutTime > 0 then
					if (bleedOutTime/60) > 1 then
						bleedTimeString = (math.ceil(bleedOutTime/60)).." ~r~minutes"
					else
						bleedTimeString = bleedOutTime.." ~r~seconds"
					end
					tvRP.missionText("~r~Respawn available in ~w~" .. coma_left .. " ~r~seconds.~n~~r~You will bleed out in ~w~"..bleedTimeString, 10)
				else
					if not tvRP.isHandcuffed() then
						if bleedOutTime > 0 then
							if (bleedOutTime/60) > 1 then
								bleedTimeString = (math.ceil(bleedOutTime/60)).." ~r~minutes"
							else
								bleedTimeString = bleedOutTime.." ~r~seconds"
							end
							tvRP.missionText("~r~Press ~w~Y~r~ to respawn.~n~~r~You will bleed out in ~w~"..bleedTimeString)
						end
						if (IsControlJustReleased(1, Keys['Y'])) or (tvRP.getMedicCopCount() < 1) or bleedOutTime < 1 then
							tvRP.stopEscort()
							check_delay = 30
							in_coma = false
							TriggerEvent('chat:setComaState',false)
							in_coma_time = 0
							emergencyCalled = false
							knocked_out = false
							revived = false
							forceRespawn = false
							SetEntityInvincible(ped,false)
							tvRP.setRagdoll(false)
							tvRP.stopScreenEffect(cfg.coma_effect)
							SetEveryoneIgnorePlayer(PlayerId(), false)
							RemoveAllPedWeapons(ped,true)
							vRPserver.updateWeapons({{}})

							TriggerServerEvent("vRPcli:playerSpawned") -- Respawn
							vRPserver.setAliveState({1})
							SetEntityHealth(ped, 200)
							vRPserver.updateHealth({200})
						end
					end
				end
				-- Revived by medkit
				if revived or forceRespawn then
					tvRP.stopEscort()
					check_delay = 30
					in_coma = false
					TriggerEvent('chat:setComaState',false)
					in_coma_time = 0
					emergencyCalled = false
					knocked_out = false
					SetEntityInvincible(ped,false)
					tvRP.setRagdoll(false)
					tvRP.stopScreenEffect(cfg.coma_effect)
					SetEveryoneIgnorePlayer(PlayerId(), false)
					vRPserver.setAliveState({1})
					SetEntityHealth(ped, 200)
					vRPserver.updateHealth({200})
					if revived then
						if tvRP.isHandcuffed() then
							tvRP.playAnim(false,{{"mp_arresting","idle",1}},true)
							SetTimeout(3000, function()
								tvRP.playAnim(false,{{"mp_arresting","idle",1}},true)
							end)
						end
					end
					if forceRespawn then
						RemoveAllPedWeapons(ped,true)
						vRPserver.updateWeapons({{}})
						tvRP.RemoveGears()
						TriggerServerEvent("vRPcli:playerSpawned") -- Respawn
					end
					revived = false
					forceRespawn = false
				end
			end
		end
	end
end)

-- Allows a player to request emergency service if not already requested. Can only request 5 min
function promptForRevive()
	if not emergencyCalled and not forceRespawn then
		local msg = " "
		if tvRP.getMedicCopCount() > 0 then
			DisplayHelpText("~w~Press ~g~E~w~ to request medic.")
		else
			DisplayHelpText("~w~Press ~g~E~w~ to request medic.~n~~w~No medical services available at this time.")
		end
		if (IsControlJustReleased(1, Keys['E'])) then
			emergencyCalled = true
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
			vRPserver.sendServiceAlert({GetPlayerServerId(PlayerId()),"EMS/Fire",x,y,z,"Player requesting medic."})
			coma_left = coma_left + 300
			SetTimeout(300 * 1000, function()
				emergencyCalled = false
			end)
		end
	end
end

function tvRP.isInComa()
	return in_coma
end

-- kill the player if in coma
function tvRP.killComa()
	if in_coma then
		coma_left = 0
		in_coma_time = 0
		forceRespawn = true
	end
end

function tvRP.isRevived()
	revived = true
end

function tvRP.isCheckDelayed()
	return check_delay
end

-- Outside of resource
RegisterNetEvent('vrp:setCheckDelayed')
AddEventHandler('vrp:setCheckDelayed',function (time)
	tvRP.setCheckDelayed(time)
end)

function tvRP.setCheckDelayed(time)
	check_delay = time
end

function tvRP.dropItems(items,cleanup_timeout)
	Citizen.CreateThread(function() -- Create thread to keep track of moneybag reference
		cleanup_timeout = cleanup_timeout or 300000
		local ped = GetPlayerPed(-1)
		local pedPos = GetEntityCoords(ped, nil)

		local moneybag = CreateObject(0x113FD533, math.floor(pedPos.x)+0.000001, math.floor(pedPos.y)+0.000001, pedPos.z, true, false, false)
		SetEntityCollision(moneybag, false)
		PlaceObjectOnGroundProperly(moneybag)
		Citizen.Wait(10)
		FreezeEntityPosition(moneybag, true)
		local bagPos = GetEntityCoords(moneybag, nil) --Get the pos for the bag because flooring x/y could potentially put pedPos.z underground
		vRPserver.create_temp_chest({GetPlayerServerId(PlayerId()), bagPos.x, bagPos.y, bagPos.z+1, items, cleanup_timeout})
		Citizen.Wait(cleanup_timeout)
		while true do
			Citizen.Wait(1000)
			SetEntityVisible(moneybag, false)
			DeleteEntity(moneybag)
		end
	end)
end

function tvRP.dropItemsAtCoords(items,cleanup_timeout,coords)
	Citizen.CreateThread(function() -- Create thread to keep track of moneybag reference
		cleanup_timeout = cleanup_timeout or 300000

		local moneybag = CreateObject(0x113FD533, coords[1], coords[2], coords[3], true, false, false)
		SetEntityCollision(moneybag, false)
		PlaceObjectOnGroundProperly(moneybag)
		Citizen.Wait(10)
		FreezeEntityPosition(moneybag, true)
		local bagPos = GetEntityCoords(moneybag, nil) --Get the pos for the bag because flooring x/y could potentially put pedPos.z underground
		vRPserver.create_temp_chest({GetPlayerServerId(PlayerId()), coords[1], coords[2], coords[3], items, cleanup_timeout})
		Citizen.Wait(cleanup_timeout)
		while true do
			Citizen.Wait(1000)
			SetEntityVisible(moneybag, false)
			DeleteEntity(moneybag)
		end
	end)
end

Citizen.CreateThread(function() -- coma decrease thread
	while true do
		Citizen.Wait(1000)
		if coma_left > 0 then
			coma_left = coma_left-1
		end
		if in_coma then
			in_coma_time = in_coma_time + 1
		end
		if check_delay > 0 then
			check_delay = check_delay-1
		end
	end
end)

Citizen.CreateThread(function() -- disable health regen, conflicts with coma system
	while true do
		Citizen.Wait(100)
		-- prevent health regen
		SetPlayerHealthRechargeMultiplier(PlayerId(), 0)
	end
end)

-- Infinite satmina
Citizen.CreateThread( function()
	while true do
		Citizen.Wait(1000)
		ResetPlayerStamina(PlayerId())
	end
end)

function GetPlayerByEntityID(id)
	for i=0,cfg.max_players do
		if(NetworkIsPlayerActive(i) and GetPlayerPed(i) == id) then return i end
	end
	return nil
end

function GetPedVehicleSeat(ped)
	local vehicle = GetVehiclePedIsIn(ped, false)
	for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
		if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
	end
	return -2
end
