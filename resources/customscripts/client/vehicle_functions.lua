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
		local distanceArena = #(vector3(playerloc.x, playerloc.y, playerloc.z)-vector3(2796.9389648438, -3798.2019042969, 137.76863098145))
		if bypass_zones[GetNameOfZone(playerloc.x, playerloc.y, playerloc.z)] or (distanceArena <= 435.9753) then
			bypassed_zone = true
		else
			bypassed_zone = false
		end
		if vehicle ~= nil and (GetVehicleClass(vehicle) == 13) then
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
local offroad_bikes = {
	["788045382"] = true, --Sanchez
	["1753414259"] = true, --Enduro
	["86520421"] = true, --BF400
	["390201602"] = true, --Cliffhanger
	["741090084"] = true, -- Gargoyle
	["-1523428744"] = true, -- Manchez
}

--TODO TRACTION REVIEW PER BIKE
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
		local pedVeh = GetVehiclePedIsIn(playerPed,false)
		if GetPedInVehicleSeat(pedVeh, -1) == playerPed and (IsPedOnAnyBike(playerPed) and not offroad_bikes[tostring(GetEntityModel(pedVeh))]) and not bypassed_zone then

			if not inVeh then
				inVeh = true
				SetVehicleHandlingFloat(pedVeh,"CHandlingData","fTractionLossMult", baseTraction)
			end
			currentTraction = GetVehicleHandlingFloat(pedVeh,"CHandlingData","fTractionLossMult")

			local pos = GetEntityCoords(playerPed)
			local onRoad = IsPointOnRoad(pos.x,pos.y,pos.z,pedVeh)
			if onRoad then
				if offRoadTime > 0 then
					SetVehicleHandlingFloat(pedVeh,"CHandlingData","fTractionLossMult0", baseTraction)
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
local speedDelta = 0.2235196
local limiterEnabled = false
local cruiseSpeed = 0

Citizen.CreateThread(function()
	local resetSpeedOnEnter = true
	while true do
		Citizen.Wait(0)
		local playerPed = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(playerPed,false)
		if vehicle ~= nil and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			DisableControlAction(0, 84, true) -- INPUT_VEH_PREV_RADIO_TRACK (decrease)
			DisableControlAction(0, 83, true) -- INPUT_VEH_NEXT_RADIO_TRACK (increase)
			-- This should only happen on vehicle first entry to disable any old values
			if resetSpeedOnEnter then
				maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
				SetEntityMaxSpeed(vehicle, maxSpeed)
				resetSpeedOnEnter = false
				limiterEnabled = false
			end
			-- Disable speed limiter
			if IsControlJustReleased(0,246) and IsControlPressed(0,131) then
				maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
				SetEntityMaxSpeed(vehicle, maxSpeed)
				TriggerEvent("mt:showHelpNotification","Speed limiter disabled")
				limiterEnabled = false
			-- Enable speed limiter
			elseif IsControlJustReleased(0,246) then
				cruiseSpeed = GetEntitySpeed(vehicle)
				updateSpeed(vehicle, cruiseSpeed)
				limiterEnabled = true
			elseif IsDisabledControlPressed(0,84) and limiterEnabled then
				cruiseSpeed = cruiseSpeed - speedDelta
				if cruiseSpeed > 0 then
					updateSpeed(vehicle, cruiseSpeed)
				end
			elseif IsDisabledControlPressed(0,83) and limiterEnabled then
				cruiseSpeed = cruiseSpeed + speedDelta
				if cruiseSpeed > 0 then
					updateSpeed(vehicle, cruiseSpeed)
				end
			end
		else
			resetSpeedOnEnter = true
		end
	end
end)

function updateSpeed(veh, speed)
	SetEntityMaxSpeed(veh, speed)
	if useMph then
		cruise = math.floor(speed * 2.23694 + 0.5)
		TriggerEvent("mt:showHelpNotification","Speed limiter set to "..cruise.." mph. ~INPUT_VEH_SUB_ASCEND~ + ~INPUT_MP_TEXT_CHAT_TEAM~ to disable. ~INPUT_VEH_PREV_RADIO_TRACK~/~INPUT_VEH_NEXT_RADIO_TRACK~ to change speed.")
	else
		cruise = math.floor(speed * 3.6 + 0.5)
		TriggerEvent("mt:showHelpNotification","Speed limiter set to "..cruise.." kph. ~INPUT_VEH_SUB_ASCEND~ + ~INPUT_MP_TEXT_CHAT_TEAM~ to disable. ~INPUT_VEH_PREV_RADIO_TRACK~/~INPUT_VEH_NEXT_RADIO_TRACK~ to change speed.")
	end
end

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

-- Also helmet stuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		SetPedHelmet(GetPlayerPed(-1), false)
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
