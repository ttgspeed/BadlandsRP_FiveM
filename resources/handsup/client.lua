local handup_state = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(1, 323) then --Start holding X
			if not IsEntityDead(GetPlayerPed(-1)) then
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
				SetEnableHandcuffs(lPed, false)
				handup_state = false
			else
				TaskPlayAnim(lPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
				SetEnableHandcuffs(lPed, true)
				handup_state = true
			end
		end)
	end
end)