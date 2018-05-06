-- Script Created by Giant Cheese Wedge (AKA Blü)
-- Script Modified and fixed by Hoopsure

local crouched = false
local proned = false
local hashFemaleMPSkin = GetHashKey("mp_f_freemode_01")
crouchKey = 26
proneKey = 36

Citizen.CreateThread( function()
	while true do
		Citizen.Wait( 1 )
		local ped = GetPlayerPed( -1 )
		if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
			ProneMovement()
			DisableControlAction( 0, proneKey, true )
			if ( not IsPauseMenuActive() ) then
				if ( (IsDisabledControlJustPressed(0, proneKey) and IsControlPressed(0,131)) and not crouched and not IsPedInAnyVehicle(ped, true) and not IsPedFalling(ped) and not IsPedDiving(ped) and not IsPedInCover(ped, false) and not IsPedInParachuteFreeFall(ped) and (GetPedParachuteState(ped) == 0 or GetPedParachuteState(ped) == -1) ) and not tvRP.isHandcuffed() and not tvRP.getActionLock() then
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
					if proned then
						ClearPedTasksImmediately(ped)
						proned = false
						coord = GetEntityCoords(ped)
						SetEntityCoords(ped,coord.x,coord.y,coord.z)
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
							ResetPedMovementClipset( ped )
							ResetPedStrafeClipset(ped)
							SetPedMovementClipset( ped,animName, 0.5)
							crouched = false
						elseif ( not crouched and not proned ) then
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
		if proned then
			DisablePlayerFiring(ped, true)
			SetPlayerSprint(ped, false)
			DisableControlAction(0, 23, true)
			DisableControlAction(0, 22, true)
			DisableControlAction(0, 21, true)
		end
	end
end)

function SetProned()
	ped = PlayerPedId()
	ClearPedTasksImmediately(ped)
	TaskPlayAnimAdvanced(ped, "move_crawl", "onfront_fwd", GetEntityCoords(ped), 0.0, 0.0, GetEntityHeading(ped), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
end


function ProneMovement()
	if proned then
		ped = PlayerPedId()
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
