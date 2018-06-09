-- build the client-side interface
license_client = {}
Tunnel.bindInterface("playerLicenses",license_client)
-- get the server-side access
license_server = Tunnel.getInterface("playerLicenses","playerLicenses")

------------------ animals ------------------
local animals = {
	{"Deer",-664053099,"deer", 250},
	--{"Boar",-832573324,"boar", 1000},
	{"Rabbit",-541762431,"rabbit", 200},
	{"Mountain Lion",307287994,"mlion", 300},
}

local harvest_types = {
	"meat",
	"hide"
}

------------------ hunting grounds ------------------
local huntingGrounds = {
	{-1369.8907470704,4380.1606445312,41.132358551026}
	--{-1653.9948730468,4604.001,46.22822189331}
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
local houseBlip = nil
local houseBlipRouteActive = false
local huntingGround = {}
local missionRunning = false
local entityModel = 0
local entityName = ""
local entityType = ""
local entityHarvest = ""
local harvestRemaining = 0
local harvestTotal = 0
local missionReward = 0
local pedindex = {}
local blipindex = {}

function PopulatePedIndex()
  local handle, ped = FindFirstPed()
  local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
  repeat
    if not IsEntityDead(ped) then
    	pedindex[ped] = true
    end
    finished, ped = FindNextPed(handle) -- first param returns true while entities are found
  until not finished
  EndFindPed(handle)
end

function highlightGrounds()
	groundsBlip = AddBlipForRadius(huntingGround[1],huntingGround[2],huntingGround[3],525.0)
	SetBlipSprite(groundsBlip,9)
	SetBlipColour(groundsBlip,3)
	SetBlipAlpha(groundsBlip,80)
end

function beginHunting()
	local animal = animals[math.random(#animals)]
	harvestTotal = math.random(10,20)
	harvestRemaining = harvestTotal
	huntingGround = huntingGrounds[math.random(#huntingGrounds)]
	entityHarvest = harvest_types[math.random(#harvest_types)]
	entityName = animal[1]
	entityModel = animal[2]
	entityType = animal[3]
	missionReward = animal[4] * harvestTotal
	missionRunning = true

	TriggerServerEvent('hunting:start',entityName,entityHarvest,harvestRemaining)
	local label = harvestRemaining.." "..entityName.." "..entityHarvest
	TriggerEvent("banking:updateJob", label)
	GiveWeaponToPed(GetPlayerPed(-1), 0x05FC3C11, 300, false, true)
	highlightGrounds()
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if missionRunning and harvestRemaining > 0 then
			PopulatePedIndex()
		end
	end
end)

function disableSniper()
  local ped = GetPlayerPed(-1)
  if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
    local _, hash = GetCurrentPedWeapon(ped, true)
    if hash == 100416529 then
      HideHudComponentThisFrame(14) --hide reticle
			DisablePlayerFiring(ped, true) -- Disable weapon firing
    end
  end
end

function disableFriendlyFire()
	local ped = GetPlayerPed(-1)
	local _, hash = GetCurrentPedWeapon(ped, true)
	if hash == 100416529 then
		if IsControlPressed(0, 68) then
			local aiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
			if aiming then
				if GetPedType(entity) == 2 then
					HideHudComponentThisFrame(14) --hide reticle
					DisablePlayerFiring(ped, true) -- Disable weapon firing
				end
			end
		else
			DisablePlayerFiring(ped, true) -- Disable weapon firing
		end
	end
end

function showRoute(show)
	if show and not houseBlipRouteActive then
		SetBlipRoute(houseBlip, true)
		houseBlipRouteActive = true
	elseif not show then
		SetBlipRoute(houseBlip, false)
		houseBlipRouteActive = false
	end
end

-- Master Function
Citizen.CreateThread(function()
	houseBlip = AddBlipForCoord(huntingHouse[1],huntingHouse[2],huntingHouse[3])
	SetBlipSprite(houseBlip,141)
	SetBlipScale(houseBlip, 0.8)
	SetBlipAsShortRange(houseBlip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Hunting")
	EndTextCommandSetBlipName(houseBlip)

	while true do
		Citizen.Wait(0)
		local playerPed = GetPlayerPed(-1)
		local coords = GetEntityCoords(playerPed, nil)
		local entityCoords = {}

		disableFriendlyFire()
		if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z,huntingGround[1], huntingGround[2], huntingGround[3], false) > 525 or harvestRemaining == 0) then
			disableSniper()
			if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z,huntingGround[1], huntingGround[2], huntingGround[3], false) > 1000 and missionRunning) then
				RemoveBlip(groundsBlip)
				for entity, blip in pairs(blipindex) do
					RemoveBlip(blip)
				end
				pedindex = {}
				blipindex = {}
				harvestRemaining = 0
				TriggerServerEvent('hunting:end',"",0,0)
				TriggerEvent("banking:updateJob", "Unemployed")
				RemoveWeaponFromPed(GetPlayerPed(-1),0x05FC3C11)
				Citizen.Wait(2000)
				missionRunning = false
				showRoute(false)
			end
		end

		if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, huntingHouse[1],huntingHouse[2],huntingHouse[3], false) < 3 and missionRunning == false and IsPedInAnyVehicle(playerPed, true)==false) then
			drawText("Press ~g~E~s~ to begin a hunting assignment")
			if(IsControlJustReleased(1, Keys["E"])) then
				license_server.getPlayerLicense_client({"firearmlicense"}, function(firearmlicense)
					if(firearmlicense == 1) then
						beginHunting()
					else
						local msg = "You must have a firearm license to go hunting."
						TriggerEvent("pNotify:SendNotification", {text = msg , type = "alert", timeout = math.random(1000, 10000)})
					end
				end)
			end
		end

		if missionRunning then
			if harvestRemaining <= 0 then
				--blip and entity tracking cleanup
				RemoveBlip(groundsBlip)
				for entity, blip in pairs(blipindex) do
					RemoveBlip(blip)
				end
				pedindex = {}
				blipindex = {}
				--prompt the player to turn in their goods
				showRoute(true)
				if (GetDistanceBetweenCoords( coords.x, coords.y, coords.z, huntingHouse[1],huntingHouse[2],huntingHouse[3], false ) < 3 and IsPedInAnyVehicle(playerPed, true)==false) then
					drawText("Press ~g~E~s~ to turn in your "..entityType.." "..entityHarvest)
					if(IsControlJustReleased(1, Keys["E"])) then
						local harvest = entityType.."_"..entityHarvest
						TriggerServerEvent('hunting:end',harvest,harvestTotal,missionReward)
						TriggerEvent("banking:updateJob", "Unemployed")
						RemoveWeaponFromPed(GetPlayerPed(-1),0x05FC3C11)
						Citizen.Wait(2000)
						missionRunning = false
						showRoute(false)
					end
				end
			elseif (GetDistanceBetweenCoords( coords.x, coords.y, coords.z,huntingGround[1], huntingGround[2], huntingGround[3], false ) < 525) then
				for entity, alive in pairs(pedindex) do
					local entityHealth = GetEntityHealth(entity)
					entityCoords = GetEntityCoords(entity)
					-- // 0x93C8B64DEB84728C 0x84ADF9EB
					-- // GetPedSourceOfDeath
					-- Entity GET_PED_SOURCE_OF_DEATH(Ped ped);
					-- Returns the Entity (Ped, Vehicle, or ?Object?) that killed the 'ped'
					if (entityHealth == 0 and GetEntityModel(entity) == entityModel and alive == true) then
						if not blipindex[entity] then
							local blip = AddBlipForEntity(entity)
							SetBlipColour(blip,3)
							blipindex[entity] = blip
						end
						if (GetDistanceBetweenCoords( coords.x, coords.y, coords.z,entityCoords.x, entityCoords.y, entityCoords.z, false ) < 3 and IsPedInAnyVehicle(playerPed, true)==false) then
							drawText("Press ~g~ E ~s~ to harvest your kill")
							if(IsControlJustReleased(1, Keys["E"])) then
								RemoveBlip(blipindex[entity])
								pedindex[entity] = false

								local harvest = entityType.."_"..entityHarvest
								local harvest_amount = math.random(1,math.ceil(harvestTotal/4))
								if(harvest_amount > harvestRemaining) then
									harvest_amount = harvestRemaining
								end

								harvestRemaining = harvestRemaining - harvest_amount
								TriggerServerEvent('hunting:harvest',harvest,harvest_amount)
								TriggerServerEvent('hunting:start',entityName,entityHarvest,harvestRemaining)
								local label = harvestRemaining.." "..entityName.." "..entityHarvest
								TriggerEvent("banking:updateJob", label)

								if (harvestRemaining == 0) then
									local msg = "You have finished the hunt. Return to the hunting board to claim your reward."
									TriggerEvent("pNotify:SendNotification", {text = msg , type = "alert", timeout = math.random(1000, 10000)})
								end
							end
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
