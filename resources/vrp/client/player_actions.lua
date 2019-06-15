-- Script Created by Giant Cheese Wedge (AKA Blü)
-- Script Modified and fixed by Hoopsure

local crouched = false
local proned = false
local hashFemaleMPSkin = GetHashKey("mp_f_freemode_01")
crouchKey = 26
proneKey = 36

function tvRP.getIsProned()
	return proned
end

Citizen.CreateThread( function()
	while true do
		Citizen.Wait( 1 )
		local ped = GetPlayerPed( -1 )
		if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
			ProneMovement()
			DisableControlAction( 0, proneKey, true )
			if ( not IsPauseMenuActive() ) then
				--[[
				if ( (IsDisabledControlJustPressed(0, proneKey) and IsControlPressed(0,131)) and not crouched and not IsPedInAnyVehicle(ped, true) and not IsPedFalling(ped) and not IsPedDiving(ped) and not IsPedInCover(ped, false) and not IsPedInParachuteFreeFall(ped) and (GetPedParachuteState(ped) == 0 or GetPedParachuteState(ped) == -1) ) and not tvRP.isHandcuffed() and not tvRP.getActionLock() and not tvRP.isInComa() then
					if proned then
						Citizen.Wait(200)
						ClearPedTasksImmediately(ped)
						proned = false
						coord = GetEntityCoords(ped)
						SetEntityCoords(ped,coord.x,coord.y,coord.z)
					elseif not proned and not IsPedJumping(ped) then
						Citizen.Wait(200)
						RequestAnimSet( "move_crawl" )
						while ( not HasAnimSetLoaded( "move_crawl" ) ) do
							Citizen.Wait( 100 )
						end
						ClearPedTasksImmediately(ped)
						proned = true
						if IsPedSprinting(ped) or IsPedRunning(ped) or GetEntitySpeed(ped) > 5 then
							TaskPlayAnim(ped, "move_jump", "dive_start_run", 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
							Citizen.Wait(1000)
						end
						SetProned()
					end
				elseif ( IsDisabledControlJustPressed( 0, proneKey ) ) then
				]]--
				if ( IsDisabledControlJustPressed( 0, proneKey ) ) and not IsPedInAnyVehicle(ped, true) then
					if proned then
						tvRP.UnSetProned()
					else
						RequestAnimSet( "move_ped_crouched" )
						while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do
							Citizen.Wait( 100 )
						end
						playerModel = GetEntityModel(ped)
						animName = "MOVE_M@GENERIC"
						if playerModel == hashFemaleMPSkin then
							animName = "MOVE_F@GENERIC"
						end
						RequestAnimSet(animName)
						while ( not HasAnimSetLoaded( animName ) ) do
							Citizen.Wait( 100 )
						end

						if ( crouched and not proned ) then
							ResetPedMovementClipset( ped, 0.0 )
							ResetPedStrafeClipset(ped)
							SetPedMovementClipset( ped,animName, 0.5)
							crouched = false
							if playerModel == hashFemaleMPSkin then
								Citizen.Wait(600)
								ResetPedMovementClipset(ped, 0.0)
							end
						elseif ( not crouched and not proned ) and
								not IsEntityPlayingAnim(ped,"random@mugging3","handsup_standing_base",3) and
								not IsEntityPlayingAnim( ped, "random@arrests@busted", "idle_a", 3 ) then
							SetPedMovementClipset( ped, "move_ped_crouched", 0.55 )
							SetPedStrafeClipset(ped, "move_ped_crouched_strafing")
							crouched = true
						end
					end
				end
			end
		else
			proned = false
			crouched = false
		end
		if proned or crouched then
			if tvRP.isInWater() then
				tvRP.UnSetCrouch()
			else
				SetPlayerSprint(ped, false)
				DisableControlAction(0, 23, true)

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
	      DisableControlAction(0,47,true) -- disable weapon
	      DisableControlAction(0,58,true) -- disable weapon
	      DisableControlAction(0,257,true) -- disable melee
	      DisableControlAction(0,44,true) -- disable cover
	      DisableControlAction(0,22,true) -- disable cover
	      DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
			end
		end
	end
end)

function SetProned()
	ped = PlayerPedId()
	ClearPedTasksImmediately(ped)
	TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
end

function tvRP.UnSetCrouch()
	print("Crouch unset")
	ped = PlayerPedId()
	ClearPedTasksImmediately(ped)
	proned = false
	crouched = false
	--coord = GetEntityCoords(ped)
	--SetEntityCoords(ped,coord.x,coord.y,coord.z)
end

function tvRP.UnSetProned()
	ped = PlayerPedId()
	ClearPedTasksImmediately(ped)
	proned = false
	coord = GetEntityCoords(ped)
	SetEntityCoords(ped,coord.x,coord.y,coord.z)
end

function ProneMovement()
	if proned then
		ped = PlayerPedId()
		if IsPedInAnyVehicle(ped, true) then
			local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			if veh ~= nil then
				TaskLeaveVehicle(ped, veh, 16 )
				tvRP.UnSetProned()
				return
			end
		else
			if IsControlPressed(0, 32) or IsControlPressed(0, 33) then
				DisablePlayerFiring(ped, true)
			 elseif IsControlJustReleased(0, 32) or IsControlJustReleased(0, 33) then
			 	DisablePlayerFiring(ped, false)
			 end
			if IsControlJustPressed(0, 32) and not movefwd then
				Citizen.Wait(200)
				movefwd = true
			    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 47, 1.0, 0, 0)
			elseif IsControlJustReleased(0, 32) and movefwd then
				Citizen.Wait(200)
			    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
				movefwd = false
			end
			if IsControlJustPressed(0, 33) and not movebwd then
				Citizen.Wait(200)
				movebwd = true
			    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_bwd", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 47, 1.0, 0, 0)
			elseif IsControlJustReleased(0, 33) and movebwd then
				Citizen.Wait(200)
			    TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_bwd", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
			    movebwd = false
			end
			if IsControlPressed(0, 34) then
				SetEntityHeading(ped, GetEntityHeading(ped)+2.0 )
			elseif IsControlPressed(0, 35) then
				SetEntityHeading(ped, GetEntityHeading(ped)-2.0 )
			end
		end
	end
end


-- https://github.com/IndianaBonesUrMom/fivem-seatbelt
local gForcesToEject = 20
local gForcesToConcuss = 35
local minSpeed = 19.25 --THIS IS IN m/s
local strings = { belt_on = 'Seatbelt on.', belt_off = 'Seatbelt off' }
local speedBuffer = {}
local velBuffer = {}
local beltOn = false
local wasInCar = false
local gForce = 9.8	--acceleration due to gravity M/H

IsCar = function(veh)
			local vc = GetVehicleClass(veh)
			return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 15 and vc <= 20)
		end

function Fwv(entity)
  local hr = GetEntityHeading(entity) + 90.0
  if hr < 0.0 then hr = 360.0 + hr end
  hr = hr * 0.0174533
  return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

function tvRP.getSeatbeltStatus()
	return beltOn
end
--Thread to monitor speed, I may have gotten carried away with this
function speedBuffer.new()
	speedBuffer.max = 0
	speedBuffer.min = 0
	speedBuffer.maxTime = 0
	speedBuffer.minTime = 0
	speedBuffer.tickCount = 0
end

function speedBuffer.push(value)
	if value > speedBuffer.max then
		speedBuffer.max = value
		speedBuffer.maxTime = speedBuffer.tickCount

		--reset the min because we only care about deceleration
		speedBuffer.min = value
		speedBuffer.minTime = speedBuffer.tickCount
	elseif value < speedBuffer.min then
		speedBuffer.min = value
		speedBuffer.minTime = speedBuffer.tickCount
	end

	--max is expiring
	if speedBuffer.maxTime + 10 < speedBuffer.tickCount  then
		speedBuffer.max = value
		speedBuffer.maxTime = speedBuffer.tickCount

		--reset the min because we only care about deceleration
		speedBuffer.min = value
		speedBuffer.minTime = speedBuffer.tickCount
	end
end

speedBuffer.new()

Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do
		Citizen.Wait(100)
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped)

		while wasInCar do
			Citizen.Wait(10)

			speedBuffer.push(GetEntitySpeed(car))
			speedBuffer.tickCount = speedBuffer.tickCount + 1

			local max = speedBuffer.max
			local min = speedBuffer.min

			local appliedGForces = ((max - min)/0.1)/gForce

			--DEBUG-------------
			-- if appliedGForces > 5 then
			-- 	print("High Gs: "..tostring(appliedGForces).."Gs")
			-- 	print(max)
			-- 	print(min)
			-- end
			--END DEBUG---------

			if appliedGForces > gForcesToEject or appliedGForces > gForcesToConcuss then
				print("High G Crash: "..tostring(appliedGForces).."Gs")
				if GetEntitySpeedVector(car, true).y > 1.0
					 and max > minSpeed
					 and appliedGForces > gForcesToEject
					 and not tvRP.isHandcuffed()
					 and not tvRP.isInComa()
					 and not beltOn then
						 	print("Ejected")
						 	local co = GetEntityCoords(ped)
							local fw = Fwv(ped)
							SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
							SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
							Citizen.Wait(1)
							SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
							tvRP.setHandicapped(true)
				elseif GetEntitySpeedVector(car, true).y > 1.0
					 and max > minSpeed
					 and appliedGForces > gForcesToConcuss
					 and not tvRP.isHandcuffed()
					 and not tvRP.isInComa()
					 and beltOn then
						  print("Knocked out")
							tvRP.setKnockedOut(true)
							tvRP.playAnim(true, {{"random@crash_rescue@car_death@std_car", "loop", 1}},true)
							tvRP.setHandicapped(true)
							tvRP.setConcussion(true)
							speedBuffer.new()
				end
			end

			velBuffer[2] = velBuffer[1]
			velBuffer[1] = GetEntityVelocity(car)
		end
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do

		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped)

		if car ~= 0 and (wasInCar or IsCar(car)) then

			wasInCar = true

			if beltOn then DisableControlAction(0, 75) end

			if IsDisabledControlJustReleased(0,75) and beltOn then
				tvRP.notify("You need to remove your seatbelt to do that")
			end

			if IsControlJustReleased(0, 311) then
				beltOn = not beltOn
				if beltOn then
					tvRP.notify(strings.belt_on)
				else
					tvRP.notify(strings.belt_off)
				end
			end

		elseif wasInCar then
			wasInCar = false
			beltOn = false
			speedBuffer.new()
		end
		Citizen.Wait(10)
	end
end)

function tvRP.sendCarCrashEvent()
	local ped = GetPlayerPed(-1)
	local car = GetVehiclePedIsIn(ped)

	if car ~= 0 and IsPedInAnyVehicle(ped) and not tvRP.isHandcuffed() and not beltOn then
		local co = GetEntityCoords(ped)
		local fw = Fwv(ped)
		SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
		SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
		Citizen.Wait(1)
		SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
	end
end

local customEmoteBinds = {
	["f1"] = nil,
	["f2"] = nil,
	["f3"] = nil,
	["f5"] = nil,
	["f6"] = nil,
	["f7"] = nil,
	["f9"] = nil,
	["f10"] = nil,
	["f11"] = nil,
}


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if (IsDisabledControlPressed(0, 121) or IsControlPressed(0, 121)) and (IsDisabledControlJustPressed(0, 288) or IsControlJustPressed(0, 288)) then
			playBoundEmote("f1")
		elseif (IsDisabledControlPressed(0, 121) or IsControlPressed(0, 121)) and (IsDisabledControlJustPressed(0, 289) or IsControlJustPressed(0, 289)) then
			playBoundEmote("f2")
		elseif (IsDisabledControlPressed(0, 121) or IsControlPressed(0, 121)) and (IsDisabledControlJustPressed(0, 170) or IsControlJustPressed(0, 170)) then
			playBoundEmote("f3")
		elseif (IsDisabledControlPressed(0, 121) or IsControlPressed(0, 121)) and (IsDisabledControlJustPressed(0, 318) or IsControlJustPressed(0, 318)) then
			playBoundEmote("f5")
		elseif (IsDisabledControlPressed(0, 121) or IsControlPressed(0, 121)) and (IsDisabledControlJustPressed(0, 167) or IsControlJustPressed(0, 167)) then
			playBoundEmote("f6")
		elseif (IsDisabledControlPressed(0, 121) or IsControlPressed(0, 121)) and (IsDisabledControlJustPressed(0, 168) or IsControlJustPressed(0, 168)) then
			playBoundEmote("f7")
		elseif (IsDisabledControlPressed(0, 121) or IsControlPressed(0, 121)) and (IsDisabledControlJustPressed(0, 56) or IsControlJustPressed(0, 56)) then
			playBoundEmote("f9")
		elseif (IsDisabledControlPressed(0, 121) or IsControlPressed(0, 121)) and (IsDisabledControlJustPressed(0, 57) or IsControlJustPressed(0, 57)) then
			playBoundEmote("f10")
		elseif (IsDisabledControlPressed(0, 121) or IsControlPressed(0, 121)) and (IsDisabledControlJustPressed(0, 344) or IsControlJustPressed(0, 344)) then
			playBoundEmote("f11")
		end
	end
end)

local emote_cooldown = 10 * 1000
local emote_cooldown_active = false

function startEmoteCoolDownThread()
	if not emote_cooldown_active then
		emote_cooldown_active = true
		Citizen.CreateThread(function()
			Citizen.Wait(emote_cooldown)
			emote_cooldown_active = false
		end)
	end
end

function playBoundEmote(key)
	if emote_cooldown_active then
		tvRP.notify("You can not use another emote so soon.")
	else
		if customEmoteBinds[key] ~= nil and not tvRP.isHandcuffed() and not tvRP.getActionLock() and not tvRP.isInComa() then
			startEmoteCoolDownThread()
			tvRP.playAnim(customEmoteBinds[key][1], customEmoteBinds[key][2], customEmoteBinds[key][3])
		end
	end
	Citizen.Wait(1000)
end

function tvRP.syncEmoteBinding(emoteBinding)
	customEmoteBinds = emoteBinding
end

RegisterNetEvent('vRP:setemote')
AddEventHandler('vRP:setemote', function(selectedKey, emote)
	if emote ~= nil then
		customEmoteBinds[selectedKey] = emote
		vRPserver.saveEmoteBinds({customEmoteBinds})
	else
		tvRP.notify("No emote found")
	end
end)

local takingNotesActive = false
local ad = "missheistdockssetup1clipboard@base"
local notesPrimaryProp = nil
local notesSecondaryProp = nil
local note_prop_name = 'prop_notepad_01'
local note_secondaryprop_name = 'prop_pencil_01'

function tvRP.takeNotes()
	local player = GetPlayerPed(-1)

	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
		loadAnimDict( ad )
		if ( IsEntityPlayingAnim( player, ad, "base", 3 ) ) or takingNotesActive then
			tvRP.takeNotesEnd(player)
		else
			local x,y,z = table.unpack(GetEntityCoords(player))
			notesPrimaryProp = CreateObject(GetHashKey(note_prop_name), x, y, z+0.2,  true,  true, true)
			notesSecondaryProp = CreateObject(GetHashKey(note_secondaryprop_name), x, y, z+0.2,  true,  true, true)
			AttachEntityToEntity(notesPrimaryProp, player, GetPedBoneIndex(player, 18905), 0.1, 0.02, 0.05, 10.0, 0.0, 0.0, true, true, false, true, 1, true) -- notepad
			AttachEntityToEntity(notesSecondaryProp, player, GetPedBoneIndex(player, 58866), 0.12, 0.0, 0.001, -150.0, 0.0, 0.0, true, true, false, true, 1, true) -- pencil
			TaskPlayAnim( player, ad, "base", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			takingNotesActive = true
			Citizen.CreateThread(function()
				while takingNotesActive do
					Citizen.Wait(1)
					if not IsEntityPlayingAnim( player, ad, "base", 3 ) then
						tvRP.takeNotesEnd(player)
					end
					SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263, true)
					DisableControlAction(0, 24, true) -- Attack
					DisableControlAction(0, 25, true) -- Aim
					DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
					DisableControlAction(0, 142, true) -- MeleeAttackAlternate
					DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
					DisableControlAction(0,263,true) -- disable melee
					DisableControlAction(0,264,true) -- disable melee
					DisableControlAction(0,140,true) -- disable melee
					DisableControlAction(0,141,true) -- disable melee
					DisableControlAction(0,143,true) -- disable melee
				end
			end)
		end
	end
end

function tvRP.takeNotesEnd(player)
	takingNotesActive = false
	TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
	Citizen.Wait (100)
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(notesPrimaryProp, 1, 1)
	DeleteObject(notesPrimaryProp)
	DetachEntity(notesSecondaryProp, 1, 1)
	DeleteObject(notesSecondaryProp)
end
