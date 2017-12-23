-- api
local Keys = {["E"] = 38,["ENTER"] = 18}
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
			if not tvRP.isHandcuffed() and tvRP.isJailed() == nil and tvRP.isInPrison() == nil then

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
local emergencyCalled = false
local knocked_out = false
local revived = false
local check_delay = 0

Citizen.CreateThread(function()
	-- main loop thing
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local pedPos = GetEntityCoords(ped, nil)

		-- if not emergencyCalled and not knocked_out then
		-- 	DisplayHelpText("~w~Press ~g~E~w~ to spawn chest")
		-- 	if (IsControlJustReleased(1, Keys['E'])) then
		-- 		emergencyCalled = true
		-- 		--local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
		-- 		local moneybag = CreateObject(0x113FD533, math.floor(pedPos.x)+0.000001, math.floor(pedPos.y)+0.000001, pedPos.z, true, false, false)
		-- 		SetEntityCollision(moneybag, false)
		-- 		PlaceObjectOnGroundProperly(moneybag)
		-- 		Citizen.Wait(100)
		-- 		FreezeEntityPosition(moneybag, true)
		-- 		local bagPos = GetEntityCoords(moneybag, nil) --Get the pos for the bag because flooring x/y could potentially put pedPos.z underground
		-- 		vRPserver.create_temp_chest({GetPlayerServerId(PlayerId()), bagPos.x, bagPos.y, bagPos.z+1})
		-- 		SetTimeout(1 * 1000, function()
		-- 			emergencyCalled = false
		-- 		end)
		-- 	end
		-- end

		-- Dead player detect. Find damage cause and apply coma or knocked out state
		if IsEntityDead(ped) then
			revived = false
			if not tvRP.isAdmin() then
				tvRP.closeMenu()
			end
			if not in_coma then
				check_delay = 30
				if GetPedCauseOfDeath(ped) == '0xA2719263' then -- 0xA2719263 = unarmed
					if not knocked_out then
						coma_left = 30 -- 30 seconds??
					end
					knocked_out = true
				else
					knocked_out = false
				end

				local x,y,z = tvRP.getPosition()
				NetworkResurrectLocalPlayer(x, y, z, true, true, false)
				Citizen.Wait(1)
				SetEveryoneIgnorePlayer(PlayerId(), true)
				vRPserver.updateHealth({cfg.coma_threshold}) -- force health update
				SetEntityHealth(ped, cfg.coma_threshold)

				if not knocked_out then
					in_coma = true
					vRPserver.setAliveState({0})
					coma_left = cfg.coma_duration*60
					vRPserver.setLastDeath({})
					-- 	local moneybag = CreateObject(0x113FD533, pedPos.x, pedPos.y, pedPos.z, true, false, false)
				end

				tvRP.playScreenEffect(cfg.coma_effect,-1)
				tvRP.ejectVehicle()
				tvRP.setRagdoll(true)
			else
				local x,y,z = tvRP.getPosition()
				NetworkResurrectLocalPlayer(x, y, z, true, true, false)
				Citizen.Wait(1)
				in_coma = true
				vRPserver.setAliveState({0})
				vRPserver.updateHealth({cfg.coma_threshold}) -- force health update
				SetEntityHealth(ped, cfg.coma_threshold)
				SetEntityInvincible(ped,true)
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
					SetEntityHealth(ped,cfg.coma_threshold + 1) --heal out of coma
				end
				tvRP.applyWantedLevel(0) -- no longer wanted
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
				-- Waiting for respawn
				if coma_left > 0 then
					tvRP.missionText("~r~Respawn available in ~w~" .. coma_left .. " ~r~ seconds", 10)
				else
					if not tvRP.isHandcuffed() then
		  				tvRP.missionText("~r~Press ~w~ENTER~r~ to respawn")
			  			if (IsControlJustReleased(1, Keys['ENTER'])) then -- TODO change keybind for this
			  				tvRP.stopEscort()
			  				check_delay = 30
							in_coma = false
							emergencyCalled = false
							knocked_out = false
							revived = false
							forceRespawn = false
							SetEntityInvincible(ped,false)
							tvRP.setRagdoll(false)
							tvRP.stopScreenEffect(cfg.coma_effect)
							SetEveryoneIgnorePlayer(PlayerId(), false)

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
						TriggerServerEvent("vRPcli:playerSpawned") -- Respawn
					end
					revived = false
					forceRespawn = false
				end
		  		tvRP.applyWantedLevel(0) -- no longer wanted
			end
		end
	end
end)

-- Allows a player to request emergency service if not already requested. Can only request 5 min
function promptForRevive()
	if not emergencyCalled and not forceRespawn then
		DisplayHelpText("~w~Press ~g~E~w~ to request medic.")
		if (IsControlJustReleased(1, Keys['E'])) then
			emergencyCalled = true
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
			vRPserver.sendServiceAlert({GetPlayerServerId(PlayerId()),"EMS/Fire",x,y,z,"Player requesting medic."})
			coma_left = coma_left + 300
			SetTimeout(30 * 1000, function()
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

Citizen.CreateThread(function() -- coma decrease thread
	while true do
		Citizen.Wait(1000)
		if coma_left > 0 then
			coma_left = coma_left-1
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
