iZone = {}
Tunnel.bindInterface("iZone",iZone)
Proxy.addInterface("iZone",iZone)
vRP = Proxy.getInterface("vRP")
vRPserver = Tunnel.getInterface("vRP","iZone")


local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

inUse = false
allZone = {}
debugg = false
local commands_enabled = false

RegisterNetEvent("izone:notification")
AddEventHandler("izone:notification", function(msg, state)
	if state then
		message = "~g~"..msg
	else
		message = "~r~"..msg
	end
	SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end)



RegisterNetEvent("izone:okforpoint")
AddEventHandler("izone:okforpoint", function()
	inUse = true
end)

RegisterNetEvent("izone:askforname")
AddEventHandler("izone:askforname", function()
	local editing = true
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	while editing do
		Wait(0)
		if UpdateOnscreenKeyboard() == 2 then
			editing = false
			TriggerEvent("izone:notification","Zone/Point non sauvegardé", false)
		end
		if UpdateOnscreenKeyboard() == 1 then
			editing = false
			resultat = GetOnscreenKeyboardResult()
			TriggerEvent("izone:notification", "Zone/Point enregistré", true)
		end
	end
	local nameZone = tostring(resultat)
	TriggerServerEvent("izone:savedb", nameZone)
end)

RegisterNetEvent("izone:transfertzones")
AddEventHandler("izone:transfertzones", function(allZones)
	allZone = allZones
end)

Citizen.CreateThread(function()
	--TriggerServerEvent('testtest')
	while commands_enabled do
		Wait(0)
		if IsControlJustReleased(1, Keys["L"]) and inUse then
			local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			TriggerEvent("izone:notification", "Point ajouté ".. "x = "..tostring(math.ceil(x)) .. " y = " .. tostring(math.ceil(y)) .. " z = " .. tostring(math.ceil(z)), true)
			TriggerServerEvent("izone:addpoint", tostring(x), tostring(y), tostring(z))
			Wait(1000)
		elseif IsControlJustReleased(1, Keys["E"]) and debugg == true then
			local cb = iZone.isPlayerInAnyZone()
			Citizen.Trace(tostring(cb))
			if cb ~= nil then
				missionText(cb, 10000)
			else
				missionText("Nil", 10000)
			end
		end

	end

end)

RegisterNetEvent("izone:isPlayerInZone")
AddEventHandler("izone:isPlayerInZone", function(zone, cb)
	found = FindZone(zone)
	if not found then
		cb(nil)
	else
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), true)
		local x1, y1, z1 = table.unpack(plyCoords)
		if IsEntityAtCoord(GetPlayerPed(-1), tonumber(allZone[found].gravityCenter.x), tonumber(allZone[found].gravityCenter.y), tonumber(allZone[found].longestDistance), tonumber(allZone[found].longestDistance), tonumber(allZone[found].longestDistance), 0, 1, 0) then
		--if GetDistanceBetweenCoords(x1, y1, z1, tonumber(allZone[found].gravityCenter.x), tonumber(allZone[found].gravityCenter.y), 1.01, false) < tonumber(allZone[found].longestDistance) then
			local n = windPnPoly(allZone[found].coords, plyCoords)
			if n ~= 0 then
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end
end)

RegisterNetEvent("izone:isPlayerInZoneList")
AddEventHandler("izone:isPlayerInZoneList", function(zoneList, cb)
	local insideZone = false
	for k,zone in pairs(zoneList) do
		found = FindZone(zone)
		if not found then
			insideZone = false
		else
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), true)
			local x1, y1, z1 = table.unpack(plyCoords)
			if IsEntityAtCoord(GetPlayerPed(-1), tonumber(allZone[found].gravityCenter.x), tonumber(allZone[found].gravityCenter.y), tonumber(allZone[found].longestDistance), tonumber(allZone[found].longestDistance), tonumber(allZone[found].longestDistance), 0, 1, 0) then
			--if GetDistanceBetweenCoords(x1, y1, z1, tonumber(allZone[found].gravityCenter.x), tonumber(allZone[found].gravityCenter.y), 1.01, false) < tonumber(allZone[found].longestDistance) then
				local n = windPnPoly(allZone[found].coords, plyCoords)
				if n ~= 0 then
					insideZone = true
				else
					insideZone = false
				end
			else
				insideZone = false
			end
		end
		if insideZone then
			cb(true)
			break
		end
	end
	if not insideZone then
		cb(false)
	end
end)

RegisterNetEvent("izone:isPointInZone")
AddEventHandler("izone:isPointInZone", function(xr, yr, zone, cb)
	found = FindZone(zone)
	if not found then
		cb(nil)
	else
		local flag = { x = xr, y = yr}
		if GetDistanceBetweenCoords(xr, yr, 1.01, tonumber(allZone[found].gravityCenter.x), tonumber(allZone[found].gravityCenter.y), 1.01, false) < tonumber(allZone[found].longestDistance) then
			local n = windPnPoly(allZone[found].coords, flag)
			if n ~= 0 then
				cb(true)
			else
				cb(false)
			end
		end
	end
end)

RegisterNetEvent("izone:tpToPointZone")
AddEventHandler("izone:tpToPointZone", function(zone, pointNumber)
	found = FindZone(zone)
	if not found then
		Citizen.Trace("No zone with that name")
	else
		if pointNumber <= #allZone[found].coords then
			local x = allZone[found].coords[pointNumber].x
			local y = allZone[found].coords[pointNumber].y
			local z = allZone[found].coords[pointNumber].z
			TeleportPlayerToCoords(x, y, z)
		else
			Citizen.Trace("Point out of range")
		end
	end

end)

RegisterNetEvent("izone:tpToZone")
AddEventHandler("izone:tpToZone", function(zone)
	found = FindZone(zone)
	if not found then
		Citizen.Trace("No zone with that name")
	else
		local x = allZone[found].coords[1].x
		local y = allZone[found].coords[1].y
		local z = allZone[found].coords[1].z
		TeleportPlayerToCoords(x, y, z)
	end
end)

function iZone.isPlayerInAnyZone()
	local arrayReturn = {}
	local plyCoords = GetEntityCoords(GetPlayerPed(-1))
	local x1, y1, z1 = table.unpack(plyCoords)

	for i=1, #allZone do
		if GetDistanceBetweenCoords(x1, y1, z1, tonumber(allZone[i].gravityCenter.x), tonumber(allZone[i].gravityCenter.y), 1.01, false) < tonumber(allZone[i].longestDistance) then
			local n = windPnPoly(allZone[i].coords, plyCoords)
			if n ~= 0 then
				table.insert(arrayReturn, allZone[i].name)
				Citizen.Trace("Area = "..allZone[i].name)
			end
		end
	end
	if #arrayReturn == 0 then
		return nil
	else
		return true
	end
end

RegisterNetEvent("izone:isPlayerInAnyZone")
AddEventHandler("izone:isPlayerInAnyZone", function(cb)
	local arrayReturn = {}
	local plyCoords = GetEntityCoords(GetPlayerPed(-1))
	local x1, y1, z1 = table.unpack(plyCoords)

	for i=1, #allZone do
		if GetDistanceBetweenCoords(x1, y1, z1, tonumber(allZone[i].gravityCenter.x), tonumber(allZone[i].gravityCenter.y), 1.01, false) < tonumber(allZone[i].longestDistance) then
			local n = windPnPoly(allZone[i].coords, plyCoords)
			if n ~= 0 then
				table.insert(arrayReturn, allZone[i].name)
				Citizen.Trace("Area = "..allZone[i].name)
			end
		end
	end
	if #arrayReturn == 0 then
		return nil
	else
		return true
	end
end)

function missionText(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end

RegisterNetEvent("izone:isPointInAnyZone")
AddEventHandler("izone:isPointInAnyZone", function(xr, yr, cb)
		local arrayReturn = {}
		local flag = { x = xr, y = yr}

		for i=1, #allZone do
			if GetDistanceBetweenCoords(xr, yr, 1.01, tonumber(allZone[i].gravityCenter.x), tonumber(allZone[i].gravityCenter.y), 1.01, false) < tonumber(allZone[i].longestDistance) then
				local n = windPnPoly(allZone[i].coords, flag)
				if n ~= 0 then
					table.insert(arrayReturn, allZone[i].name)

				end
			end
		end
		if #arrayReturn == 0 then
			cb(nil)
		else
			cb(arrayReturn)
		end
end)

function windPnPoly(tablePoints, flag)
	if tostring(type(flag)) == table then
		py = flag.y
		px = flag.x
	else
		px, py, pz = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	end
	wn = 0
	table.insert(tablePoints, tablePoints[1])
	for i=1, #tablePoints do
		if i == #tablePoints then
			break
		end
		if tonumber(tablePoints[i].y) <= py then
			if tonumber(tablePoints[i+1].y) > py then
				if IsLeft(tablePoints[i], tablePoints[i+1], flag) > 0 then
					wn = wn + 1
				end
			end
		else
			if tonumber(tablePoints[i+1].y) <= py then
				if IsLeft(tablePoints[i], tablePoints[i+1], flag) < 0 then
					wn = wn - 1
				end
			end
		end
	end
	return wn
end
function IsLeft(p1s, p2s, flag)
	p1 = p1s
	p2 = p2s
	if tostring(type(flag)) == "table" then
		p = flag
	else
		p = GetEntityCoords(GetPlayerPed(-1), true)
	end
	return ( ((p1.x - p.x) * (p2.y - p.y))
            - ((p2.x -  p.x) * (p1.y - p.y)) )
end

function FindZone(zone)
	for i = 1, #allZone do
		if allZone[i].name == zone then
			return i
		end
	end
	return false
end

function TeleportPlayerToCoords(x, y, z)
	local myPly = GetPlayerPed(-1)
	SetEntityCoords(myPly, tonumber(x), tonumber(y), tonumber(z), 1, 0, 0, 1)
end

RegisterNetEvent("izone:tptc")
AddEventHandler("izone:tptc", function(x, y, z)
	TeleportPlayerToCoords(x,y,z)
end)

RegisterNetEvent("izone:senddebug")
AddEventHandler("izone:senddebug", function(allZones)
	allZone = allZones
	Citizen.Trace(allZone[1].coords[1].x)
end)
