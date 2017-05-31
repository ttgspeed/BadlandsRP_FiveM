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
		if IsPedInAnyVehicle(ped, false) then
			local vehicle = GetVehiclePedIsUsing(ped)
			local damage = GetVehicleEngineHealth(vehicle)
			Citizen.Trace("Debug: Vehicle engine health: " .. damage .. "\n")
			if damage < 750 then
				SetVehicleUndriveable(vehicle, true)
				ShowNotification("~g~Vehicle is totaled.")
			elseif damage < 850 then 
				SetVehicleEngineTorqueMultiplier(vehicle,.25) 
				ShowNotification("~g~Vehicle is damaged.")
			end
		end
		
		local pos = GetEntityCoords(ped)
		local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
		local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
				
		if vehicleHandle ~= 0 and IsEntityAVehicle(vehicleHandle) and not IsPedInAnyVehicle(ped) then
			local damage = GetVehicleEngineHealth(vehicleHandle)
			if damage < 750 then 
				DisplayHelpText("Press ~g~E~s~ to repair vehicle")
				if IsControlJustReleased(1, Keys['E']) then 
					TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)
					Citizen.Wait(15000)
					ClearPedTasks(ped)
					SetVehicleFixed(vehicleHandle)
					--SetVehicleEngineHealth(vehicleHandle,849) --why the fuck doesnt this work
					SetVehicleUndriveable(vehicleHandle, false)
				end
			end
		end
	end
end)