-- Created by Asser90 - modified by Deziel0495 and IllusiveTea - further modified by Vespura --
--https://forum.fivem.net/t/release-fx-towtruck-script-v1-2/10590
--https://github.com/Deziel0495/TowScript

-- These vehicles will be registered as "allowed/valid" tow trucks.
-- Change the x, y and z offset values for the towed vehicles to be attached to the towtruck.
-- x = left/right, y = forwards/backwards, z = up/down
local allowedTowModels = {
    ['flatbed'] = {x = 0.0, y = -0.85, z = 0.95}, -- default GTA V flatbed
    --['flatbed2'] = {x = 0.0, y = 0.0, z = 0.68}, -- addon flatbed2 (provided with the script)
    --['flatbed3'] = {x = 0.0, y = -1.2, z = 1.30}, -- addon flatbed3 (also provided with the script)
}


local allowTowingBoats = false -- Set to true if you want to be able to tow boats.
local allowTowingPlanes = false -- Set to true if you want to be able to tow planes.
local allowTowingHelicopters = false -- Set to true if you want to be able to tow helicopters.
local allowTowingTrains = false -- Set to true if you want to be able to tow trains.
local allowTowingTrailers = false -- Disables trailers. NOTE: THIS ALSO DISABLES: AIRTUG, TOWTRUCK, SADLER, ANY OTHER VEHICLE THAT IS IN THE UTILITY CLASS.

local currentlyTowedVehicle = nil

local currentTowTruck = nil
local isTowDriver = false

function tvRP.setTowDriver(toggle)
  if toggle then
    isTowDriver = true
    Citizen.CreateThread(function()
			while isTowDriver do
				Citizen.Wait(0)
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1))  then
          currentVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
          if tvRP.isVehicleATowTruck(currentVeh) then
            currentTowTruck = currentVeh
          end
        end
      end
    end)
  else
    isTowDriver = false
    currentTowTruck = nil
  end
end

function tvRP.getIsCurrentlyTowing()
    if currentlyTowedVehicle ~= nil then
        return true
    end
    return false
end

function isTargetVehicleATrailer(modelHash)
    if GetVehicleClassFromName(modelHash) == 11 then
        return true
    else
        return false
    end
end

local xoff = 0.0
local yoff = 0.0
local zoff = 0.0

function tvRP.isVehicleATowTruck(vehicle)
    local isValid = false
    for model,posOffset in pairs(allowedTowModels) do
        if IsVehicleModel(vehicle, model) then
            xoff = posOffset.x
            yoff = posOffset.y
            zoff = posOffset.z
            isValid = true
            break
        end
    end
    return isValid
end

RegisterNetEvent('tow')
AddEventHandler('tow', function()

	local playerped = PlayerPedId()
	local vehicle = currentTowTruck
  if vehicle == nil then
    vehicle = GetVehiclePedIsIn(playerped, true)
  end

	local isVehicleTow = tvRP.isVehicleATowTruck(vehicle)

	if isVehicleTow then

		local targetVehicle = GetClosestVehicle(5)

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)
				isVehicleTow = tvRP.isVehicleATowTruck(vehicle)
				local roll = GetEntityRoll(GetVehiclePedIsIn(PlayerPedId(), true))
				if currentlyTowedVehicle ~= nil and IsEntityUpsidedown(GetVehiclePedIsIn(PlayerPedId(), true)) and isVehicleTow or roll > 70.0 or roll < -70.0 then
					DetachEntity(currentlyTowedVehicle, false, false)
					currentlyTowedVehicle = nil
          tvRP.notify("Tow Service: Looks like the cables holding on the vehicle have broke!")
				end
			end
		end)

		if currentlyTowedVehicle == nil then
			if targetVehicle ~= nil then
        local targetVehicleLocation = GetEntityCoords(targetVehicle, true)
        local towTruckVehicleLocation = GetEntityCoords(vehicle, true)
        local distanceBetweenVehicles = #(vector3(targetVehicleLocation.x,targetVehicleLocation.y,targetVehicleLocation.z)-vector3(towTruckVehicleLocation.x,towTruckVehicleLocation.y,towTruckVehicleLocation.z))
        --print(tostring(distanceBetweenVehicles)) -- debug only
        if distanceBetweenVehicles > 15.0 then
            tvRP.notify("Tow Service: Your cables can't reach this far, move you truck closer to the vehicle.")
        else
            local targetModelHash = GetEntityModel(targetVehicle)
            -- Check to make sure the target vehicle is allowed to be towed (see settings at lines 8-12)
            if not ((not allowTowingBoats and IsThisModelABoat(targetModelHash)) or (not allowTowingHelicopters and IsThisModelAHeli(targetModelHash)) or (not allowTowingPlanes and IsThisModelAPlane(targetModelHash)) or (not allowTowingTrains and IsThisModelATrain(targetModelHash)) or (not allowTowingTrailers and isTargetVehicleATrailer(targetModelHash))) then
                if not IsPedInAnyVehicle(playerped, true) then
                    if vehicle ~= targetVehicle and IsVehicleStopped(vehicle) then
                        exports['mythic_scripts']:Progress({
                            name = "tow_vehicle_action",
                            duration = 5000,
                            label = "Loading Vehicle",
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = false,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            animation = {
                                task= "PROP_HUMAN_BUM_BIN",
                            },
                        }, function(status)
                            if not status then
                              if not IsEntityAMissionEntity(targetVehicle) then
                                SetEntityAsMissionEntity(targetVehicle, true, true)
                              end
                              AttachEntityToEntity(targetVehicle, vehicle, GetEntityBoneIndexByName(vehicle, 'bodyshell'), 0.0 + xoff, -1.5 + yoff, 0.0 + zoff, 0, 0, 0, 1, 1, 0, 0, 0, 1)
                              currentlyTowedVehicle = targetVehicle
                              tvRP.notify("Tow Service: Vehicle has been loaded onto the flatbed.")
                            end
                        end)
                    else
                        tvRP.notify("Tow Service: There is currently no vehicle on the flatbed.")
                    end
                else
                    tvRP.notify("Tow Service: You need to be outside of your vehicle to load or unload vehicles.")
                end
            else
                tvRP.notify("Tow Service: Your towtruck is not equipped to tow this vehicle.")
            end
        end
      else
          tvRP.notify("Tow Service: No towable vehicle detected.")
			end
		elseif IsVehicleStopped(vehicle) then
      exports['mythic_scripts']:Progress({
          name = "tow_vehicle_action",
          duration = 5000,
          label = "Unloading Vehicle",
          useWhileDead = false,
          canCancel = true,
          controlDisables = {
              disableMovement = false,
              disableCarMovement = false,
              disableMouse = false,
              disableCombat = true,
          },
          animation = {
              task= "PROP_HUMAN_BUM_BIN",
          },
      }, function(status)
          if not status then
            DetachEntity(currentlyTowedVehicle, false, false)
            local vehiclesCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -12.0, 0.0)
      			SetEntityCoords(currentlyTowedVehicle, vehiclesCoords["x"], vehiclesCoords["y"], vehiclesCoords["z"], 1, 0, 0, 1)
      			SetVehicleOnGroundProperly(currentlyTowedVehicle)
      			currentlyTowedVehicle = nil
      			tvRP.notify("Tow Service: Vehicle has been unloaded from the flatbed.")
          end
      end)
		end
  else
    tvRP.notify("Tow Service: Your vehicle is not registered as an official Tow Service tow truck.")
  end
end)

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
	DrawNotification(false, false)
end
