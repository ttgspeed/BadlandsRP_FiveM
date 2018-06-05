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
commands_enabled = false

RegisterNetEvent('025bc185-470a-4842-b0f5-92c32fe10eea')
AddEventHandler('025bc185-470a-4842-b0f5-92c32fe10eea', function(msg, state)
	if state then
		message = "~g~"..msg
	else
		message = "~r~"..msg
	end
	SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end)



RegisterNetEvent('f2f4a044-4bd0-45ec-8610-f918ae544608')
AddEventHandler('f2f4a044-4bd0-45ec-8610-f918ae544608', function()
	inUse = true
end)

RegisterNetEvent('931c5d5b-980a-4194-9a42-a97229dad129')
AddEventHandler('931c5d5b-980a-4194-9a42-a97229dad129', function()
	local editing = true
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	while editing do
		Wait(0)
		if UpdateOnscreenKeyboard() == 2 then
			editing = false
			TriggerEvent('025bc185-470a-4842-b0f5-92c32fe10eea',"Zone/Point non sauvegardé", false)
		end
		if UpdateOnscreenKeyboard() == 1 then
			editing = false
			resultat = GetOnscreenKeyboardResult()
			TriggerEvent('025bc185-470a-4842-b0f5-92c32fe10eea', "Zone/Point enregistré", true)
		end
	end
	local nameZone = tostring(resultat)
	TriggerServerEvent('b35da151-d15b-4820-8677-abd087730d33', nameZone)
end)

RegisterNetEvent('e12bede2-9d1d-45f7-93a4-c6d472b5b724')
AddEventHandler('e12bede2-9d1d-45f7-93a4-c6d472b5b724', function(allZones)
	allZone = allZones
end)

Citizen.CreateThread(function()
	--TriggerServerEvent('testtest')
	while commands_enabled do
		Wait(0)
		if IsControlJustReleased(1, Keys["L"]) and inUse then
			local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			TriggerEvent('025bc185-470a-4842-b0f5-92c32fe10eea', "Point ajouté ".. "x = "..tostring(math.ceil(x)) .. " y = " .. tostring(math.ceil(y)) .. " z = " .. tostring(math.ceil(z)), true)
			TriggerServerEvent('1a15e6a3-0c29-4385-81ad-60dd72f58bae', tostring(x), tostring(y), tostring(z))
			Wait(1000)
		elseif IsControlJustReleased(1, Keys["E"]) and debugg == true then
			TriggerEvent('84cd670b-0c16-458b-a4f3-8fce34ad9263',function(cb)
				Citizen.Trace(tostring(cb))
				if cb ~= nil then
					missionText(cb, 10000)
				else
					missionText("Nil", 10000)
				end
			end)
		end

	end

end)

RegisterNetEvent('7ffd7df1-c757-4b01-a951-5c59762d7887')
AddEventHandler('7ffd7df1-c757-4b01-a951-5c59762d7887', function(zone, cb)
	found = FindZone(zone)
	if not found then
		cb(nil)
	else
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), true)
		local x1, y1, z1 = table.unpack(plyCoords)
		if GetDistanceBetweenCoords(x1, y1, z1, tonumber(allZone[found].gravityCenter.x), tonumber(allZone[found].gravityCenter.y), 1.01, false) < tonumber(allZone[found].longestDistance) then
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

RegisterNetEvent('b1e0a095-7bce-48d1-90f7-da7205860f5b')
AddEventHandler('b1e0a095-7bce-48d1-90f7-da7205860f5b', function(xr, yr, zone, cb)
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

RegisterNetEvent('c6fa5be2-b61f-4d0f-8c8f-de22f63b5e31')
AddEventHandler('c6fa5be2-b61f-4d0f-8c8f-de22f63b5e31', function(zone, pointNumber)
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

RegisterNetEvent('7e72dda7-ef5f-44e1-b65e-8a93da5dbf4e')
AddEventHandler('7e72dda7-ef5f-44e1-b65e-8a93da5dbf4e', function(zone)
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

RegisterNetEvent('84cd670b-0c16-458b-a4f3-8fce34ad9263')
AddEventHandler('84cd670b-0c16-458b-a4f3-8fce34ad9263', function(cb)
	local arrayReturn = {}
	local plyCoords = GetEntityCoords(GetPlayerPed(-1), true)
	local x1, y1, z1 = table.unpack(plyCoords)

	for i=1, #allZone do
		if GetDistanceBetweenCoords(x1, y1, z1, tonumber(allZone[i].gravityCenter.x), tonumber(allZone[i].gravityCenter.y), 1.01, false) < tonumber(allZone[i].longestDistance) then
			local n = windPnPoly(allZone[i].coords, plyCoords)
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

function missionText(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end

RegisterNetEvent('11b62b96-522c-413f-8e07-d15f09fdc2f9')
AddEventHandler('11b62b96-522c-413f-8e07-d15f09fdc2f9', function(xr, yr, cb)
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

RegisterNetEvent('74ed97fa-5566-4382-ac04-ea051da6f614')
AddEventHandler('74ed97fa-5566-4382-ac04-ea051da6f614', function(x, y, z)
	TeleportPlayerToCoords(x,y,z)
end)

RegisterNetEvent('e347cc0b-38e5-4b85-88d4-ac6c2c4f98c3')
AddEventHandler('e347cc0b-38e5-4b85-88d4-ac6c2c4f98c3', function(allZones)
	allZone = allZones
	Citizen.Trace(allZone[1].coords[1].x)
end)
