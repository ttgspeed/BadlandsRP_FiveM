function tvRP.impoundVehicleAtYard()
	player = GetPlayerPed(-1)
	vehicle = GetVehiclePedIsIn(player, false)
	if vehicle == 0 or vehicle == nil then
		px, py, pz = table.unpack(GetEntityCoords(player, true))
		coordA = GetEntityCoords(player, true)
		local plate = nil
		local carName = nil

		for i = 1, cfg.max_players do
			coordB = GetOffsetFromEntityInWorldCoords(player, 0.0, (10.0)/i, 0.0)
			targetVehicle = tvRP.GetVehicleInDirection(coordA, coordB)
			if targetVehicle ~= nil and targetVehicle ~= 0 then
				vx, vy, vz = table.unpack(GetEntityCoords(targetVehicle, false))
				calcDistance = Vdist(px, py, pz, vx, vy, vz)
				if calcDistance then
					distance = calcDistance
					break
				end
			end
		end
		impounded = false
		if distance ~= nil and distance <= 5 and targetVehicle ~= 0 or vehicle ~= 0 then

			if vehicle == 0 then
				vehicle = targetVehicle
			end

			carModel = GetEntityModel(vehicle)
			carName = GetDisplayNameFromVehicleModel(carModel)
			plate = GetVehicleNumberPlateText(vehicle)
			args = tvRP.stringsplit(plate)
			plate = args[1]

			SetEntityAsMissionEntity(vehicle,true,true)
			SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle))
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
		else
			-- This is a backup to the impound. Mainly will be triggered for motorcyles and bikes
			vehicle = tvRP.getNearestVehicle(5)
			plate = GetVehicleNumberPlateText(vehicle)
			if plate ~= nil and vehicle ~= nil then
				args = tvRP.stringsplit(plate)
				plate = args[1]
				carModel = GetEntityModel(vehicle)
				carName = GetDisplayNameFromVehicleModel(carModel)

				SetEntityAsMissionEntity(vehicle,true,true)
				SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle))
				Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
			end
		end
		-- check if the vehicle failed to impound. This happens if another player is nearby
		local vehicle_out = tvRP.searchForVeh(player,10,plate,carName)
		if plate ~= nil and carName ~= nil and not vehicle_out then
			tvRP.notify("Vehicle Impounded.")
			impounded = true
			vRPserver.setVehicleOutStatusPlate({plate,string.lower(carName),0,1})
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
			return true, carName, plate, x, y, z
		end
		if not impounded then
			tvRP.notify("No Vehicle Nearby.")
		end
		return false, "", "", "","",""
	else
		tvRP.notify("Cannot impound while in a vehicle.")
		return false, "", "", "","",""
	end
end

function tvRP.tagNearestVehicleForTow(radius)
	vehicle = tvRP.getNearestVehicle(radius)
	plate = GetVehicleNumberPlateText(vehicle)
	if plate ~= nil and vehicle ~= nil then
		args = tvRP.stringsplit(plate)
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
end
