-- api
local Keys = {["E"] = 38,["ENTER"] = 18}
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
				if vthirst ~= 0 then
					vRPserver.varyThirst({vthirst/12.0})
				end

				if vhunger ~= 0 then
					vRPserver.varyHunger({vhunger/12.0})
				end

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
		Citizen.Wait(3000)
	end
end)

-- COMA SYSTEM

local in_coma = false
local coma_left = cfg.coma_duration*60
local emergencyCalled = false
local knocked_out = false
local revived = false
local check_delay = 0

Citizen.CreateThread(function() -- coma thread
  	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)

		local health = GetEntityHealth(ped)
		if health <= cfg.coma_threshold and coma_left > 0 then
			if not tvRP.isAdmin() then
				tvRP.closeMenu()
			end
			if not in_coma then -- go to coma state
				if IsPedInMeleeCombat(ped) and HasPedBeenDamagedByWeapon(ped,0,1) then
					knocked_out = true
				end
				SetEntityHealth(ped,0) -- remove agro
				SetEveryoneIgnorePlayer(PlayerId(), true)
				if IsEntityDead(ped) then -- if dead, resurrect
					local x,y,z = tvRP.getPosition()
					NetworkResurrectLocalPlayer(x, y, z, true, true, false)
					Citizen.Wait(0)
				end

				-- coma state
				in_coma = true
				vRPserver.updateHealth({cfg.coma_threshold}) -- force health update
				SetEntityHealth(ped, cfg.coma_threshold)
				SetEntityInvincible(ped,true)
				tvRP.playScreenEffect(cfg.coma_effect,-1)
				tvRP.ejectVehicle()
				tvRP.setRagdoll(true)
				vRPserver.setLastDeath({})
			else -- in coma
				SetEveryoneIgnorePlayer(PlayerId(), true)
				if not emergencyCalled and not knocked_out then
					DisplayHelpText("~w~Press ~g~E~w~ to request medic.")
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

				if knocked_out then
					tvRP.missionText("~r~Knocked Out", 10)
					if coma_left < ((cfg.coma_duration*60) - 30) then
						SetEntityHealth(ped,cfg.coma_threshold + 1) --heal out of coma
					end
				else
					tvRP.missionText("~r~Respawn available in ~w~" .. coma_left .. " ~r~ seconds", 10)
				end

				-- maintain life
				tvRP.applyWantedLevel(0) -- no longer wanted
				if health < cfg.coma_threshold then
					SetEntityHealth(ped, cfg.coma_threshold)
				end
	  		end
		else
	  		if in_coma then -- get out of coma state
	  			if revived then
	  				check_delay = 30
	  				in_coma = false
					emergencyCalled = false
					knocked_out = false
					revived = false
					SetEntityInvincible(ped,false)
					tvRP.setRagdoll(false)
					tvRP.stopScreenEffect(cfg.coma_effect)
					SetEveryoneIgnorePlayer(PlayerId(), false)

					SetTimeout(5000, function()  -- able to be in coma again after coma death after 5 seconds
						coma_left = cfg.coma_duration*60
					end)
					if tvRP.isHandcuffed() then
						tvRP.playAnim(false,{{"mp_arresting","idle",1}},true)
						SetTimeout(3000, function()
							tvRP.playAnim(false,{{"mp_arresting","idle",1}},true)
						end)
					end
				elseif forceRespawn then
					check_delay = 30
	  				forceRespawn = false
	  				in_coma = false
					emergencyCalled = false
					knocked_out = false
					revived = false
					SetEntityInvincible(ped,false)
					tvRP.setRagdoll(false)
					tvRP.stopScreenEffect(cfg.coma_effect)
					SetEveryoneIgnorePlayer(PlayerId(), false)

					if coma_left <= 0 then -- get out of coma by death
						SetEntityHealth(ped, 0)
					end

					SetTimeout(5000, function()  -- able to be in coma again after coma death after 5 seconds
						coma_left = cfg.coma_duration*60
					end)
	  			elseif not tvRP.isHandcuffed() then
	  				tvRP.missionText("~r~Press ~w~ENTER~r~ to respawn")
		  			if (IsControlJustReleased(1, Keys['ENTER'])) then
		  				check_delay = 30
						in_coma = false
						emergencyCalled = false
						knocked_out = false
						revived = false
						SetEntityInvincible(ped,false)
						tvRP.setRagdoll(false)
						tvRP.stopScreenEffect(cfg.coma_effect)
						SetEveryoneIgnorePlayer(PlayerId(), false)

						if coma_left <= 0 then -- get out of coma by death
							SetEntityHealth(ped, 0)
						end

						SetTimeout(5000, function()  -- able to be in coma again after coma death after 5 seconds
							coma_left = cfg.coma_duration*60
						end)
		  			end
	  			end
	  		end
		end
  	end
end)

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

Citizen.CreateThread(function() -- coma decrease thread
	while true do
		Citizen.Wait(1000)
		if in_coma then
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
