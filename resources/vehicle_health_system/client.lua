local Keys = {
	["E"] = 38
}

function GetVehHealthPercent(vehicle)
	local vehiclehealth = GetEntityHealth(vehicle) - 100
	local maxhealth = GetEntityMaxHealth(vehicle) - 100
	local percentage = (vehiclehealth / maxhealth) * 100
	return percentage
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsUsing(ped)
		local damage = GetVehHealthPercent(vehicle)
		if IsPedInAnyVehicle(ped, false) then
			SetPlayerVehicleDamageModifier(PlayerId(), 2) -- Seems to not work at the moment --
			if damage < 85 then
				SetVehicleUndriveable(vehicle, true)
				ShowNotification("~g~Vehicle is too damaged.")
			end
		end
		
		local pos = GetEntityCoords(ped)
		local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0)
		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
		local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
				
		if vehicleHandle ~= 0 and IsEntityAVehicle(vehicleHandle) and not IsPedInAnyVehicle(ped) then
			local damage = GetVehHealthPercent(vehicleHandle)
			if damage < 90 then 
				DisplayHelpText("Press ~g~E~s~ to repair vehicle")
				if IsControlJustReleased(1, Keys['E']) then 
					TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)
					Citizen.Wait(15000)
					ClearPedTasks(ped)
					SetVehicleFixed(vehicleHandle)
					SetVehicleUndriveable(vehicleHandle, false)
				end
			end
		end
	end
end)