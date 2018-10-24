local bypass_zones = {
	['RTRAK'] = "Redwood Lights Track",
}
local skate_parks = {
	"skate1",
	"skate2",
	"skate3",
	"skate4",
	"skate5",
	"skate6",
}
local playerloc
local bypassed_zone = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		playerloc = GetEntityCoords(GetPlayerPed(-1), 0)
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1),false)
		if bypass_zones[GetNameOfZone(playerloc.x, playerloc.y, playerloc.z)] then
			bypassed_zone = true
		else
			bypassed_zone = false
		end
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) and (GetVehicleClass(vehicle) == 13) then
			TriggerEvent("izone:isPlayerInZoneList", skate_parks, function(cb,zone)
				if cb ~= nil and cb then
					if zone == "skate4" and playerloc.z > 38.0001 then
						bypassed_zone = false
					else
						bypassed_zone = true
					end
				end
			end)
		end
	end
end)
------------------------------------------------------------------------------------------
-- Modify the vehicle traction value when not on a named road. Applies after specified time
-- resets when back on a road
------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local offRoadTime = 0
	local startingTraction = 1.0
	local baseTraction = 1.0
	local inVeh = false
	local pedVeh = nil
	local triggerValue = 100
	while true do
		Citizen.Wait(0)
		local playerPed = GetPlayerPed(-1)
		if GetPedInVehicleSeat(GetVehiclePedIsIn(playerPed, false), -1) == playerPed and IsPedOnAnyBike(playerPed) and not bypassed_zone then
			pedVeh = GetVehiclePedIsIn(playerPed,false)
			if not inVeh then
				inVeh = true
				SetVehicleHandlingFloat(pedVeh,"CHandlingData","fTractionLossMult", baseTraction)
			end
			currentTraction = GetVehicleHandlingFloat(pedVeh,"CHandlingData","fTractionLossMult")

			local pos = GetEntityCoords(playerPed)
			local onRoad = IsPointOnRoad(pos.x,pos.y,pos.z,pedVeh)
			if onRoad then
				if offRoadTime > 0 then
					SetVehicleHandlingFloat(pedVeh,"CHandlingData","fTractionLossMult", baseTraction)
				end
				offRoadTime = 0
			else
				if offRoadTime < triggerValue then
					offRoadTime = offRoadTime + 1
				else
					if offRoadTime == triggerValue then
						SetVehicleHandlingFloat(pedVeh, "CHandlingData","fTractionLossMult", 2.5)
						offRoadTime = triggerValue + 1
					end
				end
			end
		else
			if inVeh then
				if pedVeh ~= nil then
					SetVehicleHandlingFloat(pedVeh,"CHandlingData","fTractionLossMult", baseTraction)
				end
				offRoadTime = 0
				inVeh = false
			end
		end
	end
end)

-------------------------------------------------------------------------------
-- Disable air control on vehicles. Also prevent rollover correction.
-------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1)) and not bypassed_zone then
			if not IsVehicleOnAllWheels(GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
				DisableControlAction(0, 59, true)
				DisableControlAction(0, 60, true)
				DisableControlAction(0, 61, true)
				DisableControlAction(0, 62, true)
				DisableControlAction(0, 63, true)
				DisableControlAction(0, 64, true)
			end
		end
	end
end)

-------------------------------------------------------------------------------
-- Title: Speed limiter.
-- Author: Serpico
-- Description: This script will restict the speed of the vehicle when
--              INPUT_MP_TEXT_CHAT_TEAM is pressed. To disable, press
--              INPUT_VEH_SUB_ASCEND + INPUT_MP_TEXT_CHAT_TEAM
-------------------------------------------------------------------------------
local useMph = true -- if false, it will display speed in kph

Citizen.CreateThread(function()
	local resetSpeedOnEnter = true
	while true do
		Citizen.Wait(0)
		local playerPed = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(playerPed,false)
		if GetPedInVehicleSeat(vehicle, -1) == playerPed and IsPedInAnyVehicle(playerPed, false) then
			-- This should only happen on vehicle first entry to disable any old values
			if resetSpeedOnEnter then
				maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
				SetEntityMaxSpeed(vehicle, maxSpeed)
				resetSpeedOnEnter = false
			end
			-- Disable speed limiter
			if IsControlJustReleased(0,246) and IsControlPressed(0,131) then
				maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
				SetEntityMaxSpeed(vehicle, maxSpeed)
				TriggerEvent("mt:showHelpNotification","Speed limiter disabled")
			-- Enable speed limiter
			elseif IsControlJustReleased(0,246) then
				cruise = GetEntitySpeed(vehicle)
				SetEntityMaxSpeed(vehicle, cruise)
				if useMph then
					cruise = math.floor(cruise * 2.23694 + 0.5)
					TriggerEvent("mt:showHelpNotification","Speed limiter set to "..cruise.." mph. ~INPUT_VEH_SUB_ASCEND~ + ~INPUT_MP_TEXT_CHAT_TEAM~ to disable.")
				else
					cruise = math.floor(cruise * 3.6 + 0.5)
					TriggerEvent("mt:showHelpNotification","Speed limiter set to "..cruise.." km/h. ~INPUT_VEH_SUB_ASCEND~ + ~INPUT_MP_TEXT_CHAT_TEAM~ to disable.")
				end
			end
		else
			resetSpeedOnEnter = true
		end
	end
end)

--------------------------------------------------------------------------------
-- Basic vehicle damage handling. If above a certian point, vehicle is disabled
-- Function will also check for vehicle destruction and clear trunk if it is.
--------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)

		if IsPedInAnyVehicle(ped, false) then
			local vehicle = GetVehiclePedIsUsing(ped)
			local damage = GetVehicleEngineHealth(vehicle)
			if damage <= -4000 and not DecorGetBool(vehicle, "DestroyedClear") then
				DecorSetBool(vehicle, "DestroyedClear", true)
				plate = GetVehicleNumberPlateText(vehicle)
			    args = stringsplit(plate)
			    plate = args[1]
			    carModel = GetEntityModel(vehicle)
			    carName = GetDisplayNameFromVehicleModel(carModel)
			    if plate ~= nil and carName ~= nil then
			    	TriggerServerEvent("cs:clearTrunk", plate, string.lower(carName))
			    end
			end
		else
			local lastVehicle = GetVehiclePedIsIn(ped, true)
			if lastVehicle ~= nil  then
				local damage2 = GetVehicleEngineHealth(lastVehicle)
				if damage2 <= -4000 and not DecorGetBool(lastVehicle, "DestroyedClear") then
					DecorSetBool(lastVehicle, "DestroyedClear", true)
					plate = GetVehicleNumberPlateText(lastVehicle)
				    args = stringsplit(plate)
				    plate = args[1]
				    carModel = GetEntityModel(lastVehicle)
				    carName = GetDisplayNameFromVehicleModel(carModel)
				    if plate ~= nil and carName ~= nil then
				    	TriggerServerEvent("cs:clearTrunk", plate, string.lower(carName))
				    end
				end
			end
		end
	end
end)

RegisterNetEvent('CustomScripts:ToggleDoor')
AddEventHandler('CustomScripts:ToggleDoor', function(action, param)
	local playerPed = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(playerPed,false)
	if GetPedInVehicleSeat(vehicle, -1) == playerPed and IsPedInAnyVehicle(playerPed, false) then
		if action == "open" then
			SetVehicleDoorOpen(vehicle, param, false, false)
		elseif action == "close" then
			SetVehicleDoorShut(vehicle, param, false, false)
		end
	end
end)

-- Prevent motorcycle kicking
-- Also helmet stuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(ped,false)
		if IsPedInAnyVehicle(ped, false) and (GetVehicleClass(vehicle) == 8 or GetVehicleClass(vehicle) == 9 or GetVehicleClass(vehicle) == 13) then
			if IsControlPressed(0, 73) or IsControlPressed(0, 105) then
				ClearPedTasks(ped)
			end
		end
		SetPedHelmet(ped, false)
	end
end)

function stringsplit(str, sep)
  if sep == nil then sep = "%s" end

  local t={}
  local i=1

  for str in string.gmatch(str, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end

  return t
end
