function tvRP.impoundVehicleAtYard()
	local radius = 5
	local player = GetPlayerPed(-1)
	local vehicle = GetClosestVehicle(radius)
	local distance = nil
	if vehicle ~= 0 and vehicle ~= nil then
		px, py, pz = table.unpack(GetEntityCoords(player, true))
		vx, vy, vz = table.unpack(GetEntityCoords(vehicle, false))
		coordA = GetEntityCoords(player, true)
		local plate = nil
		local carName = nil
		distance = #(vector3(px, py, pz)-vector3(vx, vy, vz))

		impounded = false
		if distance ~= nil and distance <= radius and vehicle ~= 0 then
			carModel = GetEntityModel(vehicle)
			carName = GetDisplayNameFromVehicleModel(carModel)
			plate = GetVehicleNumberPlateText(vehicle)
			args = tvRP.stringsplit(plate)
			plate = args[1]

			SetEntityAsMissionEntity(vehicle,true,true)
			SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle))
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
		end
		-- check if the vehicle failed to impound. This happens if another player is nearby
		local vehicle_out = tvRP.searchForVeh(player,10,plate,carName)
		if plate ~= nil and carName ~= nil and not vehicle_out then
			tvRP.notify("Vehicle Impounded.")
			impounded = true
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
			return true, carName, plate, x, y, z
		end
		if not impounded then
			tvRP.notify("No Vehicle Nearby.")
		end
		return false, "", "", "","",""
	else
		tvRP.notify("No vehicle to impound.")
		return false, "", "", "","",""
	end
end

function tvRP.tagNearestVehicleForTow(radius)
	vehicle = GetClosestVehicle(radius)
	plate = GetVehicleNumberPlateText(vehicle)
	if plate ~= nil and vehicle ~= nil then
		args = tvRP.stringsplit(plate)
		if args ~= nil then
			plate = args[1]
			carModel = GetEntityModel(vehicle)
			carName = GetDisplayNameFromVehicleModel(carModel)
			if tvRP.getRegistrationNumber() == plate or tvRP.isCop() then
				tvRP.notify("Vehicle tagged for towing")
				SetVehicleDoorsLocked(vehicle,2)
				SetVehicleDoorsLockedForAllPlayers(vehicle, true)
				player = GetPlayerPed(-1)
				coord = GetEntityCoords(player, true)
				vRPserver.addToTowList({plate,carName,coord.x,coord.y,coord.z})
				vRPserver.sendServiceAlert({GetPlayerServerId(PlayerId()),"Tow Truck",coord.x,coord.y,coord.z,"Vehicle marked for towing. Please bring to impound lot."})
				SetEntityAsMissionEntity(vehicle,true,true)
			else
				tvRP.notify("You cannot tag someone else's vehicle for towing")
			end
		else
			tvRP.notify("No vehicle found")
		end
	else
		tvRP.notify("No vehicle found")
	end
end
