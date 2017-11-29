------------------ animals ------------------
local animals = {
	{"Deer",-664053099},
	{"Boar",-832573324},
	{"Rabbit",-541762431},
	{"Mountain Lion",307287994},
}

------------------ hunting grounds ------------------
local huntingGrounds = {
	{-1653.9948730468,4604.001,46.22822189331}
}

------------ huntingHouse coords ------------
local huntingHouse = {-1494.1384277344,4971.412109375,63.86808013916} 	--x,y,z

----------------- keys ------------------
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

local groundsBlip = nil
local huntingGround = {}
local missionRunning = false
local entityType = 0
local entityHealth = 0

local pedindex = {}
local blipindex = {}
function PopulatePedIndex()
    local handle, ped = FindFirstPed()
    local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
    repeat
        if not IsEntityDead(ped) then
                pedindex[ped] = {}
        end
        finished, ped = FindNextPed(handle) -- first param returns true while entities are found
    until not finished
    EndFindPed(handle)
end

function highlightGrounds()
	groundsBlip = AddBlipForRadius(huntingGround[1],huntingGround[2],huntingGround[3],350.0)
	SetBlipSprite(groundsBlip,9)
	SetBlipColour(groundsBlip,3)
	SetBlipAlpha(groundsBlip,80)
end

function beginHunting()
	local animal = animals[math.random(#animals)]
	huntingGround = huntingGrounds[math.random(#huntingGrounds)]
	entityType = animal[2]
	missionRunning = true

	TriggerServerEvent('hunting:start',(animal[1]))
	GiveWeaponToPed(GetPlayerPed(-1), 0x05FC3C11, 10, false, true)
	highlightGrounds()
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if missionRunning then
			PopulatePedIndex()
			for k, v in pairs(pedindex) do
				if GetPedType(k) == 28 and GetEntityModel(k) == entityType then
					entityCoords = GetEntityCoords(k)
					if (GetDistanceBetweenCoords(entityCoords.x, entityCoords.y, entityCoords.z,huntingGround[1], huntingGround[2], huntingGround[3], false) < 300) then
						if not blipindex[k] then
							local blip = AddBlipForEntity(k)
							blipindex[k] = blip
						end
					end
				end
			end
		end
	end
end)

-- Master Function
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(huntingHouse[1],huntingHouse[2],huntingHouse[3])
	SetBlipSprite(blip,141)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Hunting")
	EndTextCommandSetBlipName(blip)

	while true do
		Citizen.Wait(0)
		local playerPed = GetPlayerPed(-1)
		local coords = GetEntityCoords( playerPed, nil )
		local entityCoords = {}

		if (GetDistanceBetweenCoords( coords.x, coords.y, coords.z, x, y, z, false ) < 5 and missionRunning == false and IsPedInAnyVehicle(playerPed, true)==false) then
			drawText("Press ~g~E~s~ to begin a hunting trip")
			if(IsControlPressed(1, Keys["E"])) then
				beginHunting()
			end
		end

		if missionRunning then
			if (GetDistanceBetweenCoords( coords.x, coords.y, coords.z,huntingGround[1], huntingGround[2], huntingGround[3], false ) < 300) then
				for entity, blip in pairs(blipindex) do
					entityHealth = GetEntityHealth(entity)
					entityCoords = GetEntityCoords(entity)
					if (entityHealth == 0) then
						SetBlipColour(blip,3)
					end
					if (GetDistanceBetweenCoords( coords.x, coords.y, coords.z,entityCoords.x, entityCoords.y, entityCoords.z, false ) < 3) then
						drawText("Press ~g~ E ~s~ to harvest your kill")
						if(IsControlPressed(1, Keys["E"])) then
							RemoveBlip(groundsBlip)
							RemoveBlip(blip)
							DeleteEntity(entity)
							missionRunning = false
						end
					end
				end
			end
		end
	end
end)

function drawText(message)
	SetTextComponentFormat("STRING")
	AddTextComponentString(message)
	DisplayHelpTextFromStringLabel(0, 0, 1, - 1)
end
