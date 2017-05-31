local handup_state = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 323) then --Start holding X
			TriggerEvent("Handsup", source)
			--TaskHandsUp(GetPlayerPed(-1), 1000, -1, -1, true) -- Perform animation.
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