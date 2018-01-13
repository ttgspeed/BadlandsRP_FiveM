------------------------------------------------------------
------------------------------------------------------------
---- Author: Lucas Decker, Dylan Thuillier              ----
----                                                    ----
---- Email: lucas.d.200501@gmail.com,                   ----
----        itokoyamato@hotmail.fr                      ----
----                                                    ----
---- Resource: Fire Command System                      ----
----                                                    ----
---- File: client.lua                                   ----
------------------------------------------------------------
------------------------------------------------------------

------------------------------------------------------------
-- Global variables
------------------------------------------------------------
local Keys = {["E"] = 38,["ENTER"] = 18}
local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

local extinguishingTime = 0
local pedindex = {}

Fire = setmetatable({}, Fire);
Fire.__index = Fire;

Fire.preview = false;
Fire.flames = {};


------------------------------------------------------------
-- Client: preview function
------------------------------------------------------------

function Fire.preview(x, y, z, distance, area, density, scale, toggle)
	Citizen.CreateThread(function()
		Fire.preview = false;
		Wait(100);
		Fire.preview = toggle;
		while Fire.preview do
			Wait(5);
			local heading = GetEntityHeading(GetPlayerPed(-1));
			local localPos = GetEntityCoords(GetPlayerPed(-1));
			local x = x + math.cos(math.rad(heading+90)) * distance;
			local y = y + math.sin(math.rad(heading+90)) * distance;
			local z = z;

			-- Display a circle for the area
			local angle = 0;
			while angle < 360 do
				local circle_x = x + math.cos(math.rad(angle)) * area/2;
				local circle_y = y + math.sin(math.rad(angle)) * area/2;
				local circle_x_next = x + math.cos(math.rad(angle + 1)) * area/2;
				local circle_y_next = y + math.sin(math.rad(angle + 1)) * area/2;
				local _, circle_z = GetGroundZFor_3dCoord(circle_x, circle_y, z + 5.0);
				local _, circle_z_next = GetGroundZFor_3dCoord(circle_x_next, circle_y_next, z);
				DrawLine(circle_x, circle_y, circle_z + 0.05, circle_x_next, circle_y_next, circle_z_next + 0.05, 0, 0, 255, 255);
				angle = angle + 1;
			end

			-- Display crosses at fire locations
			local area_x = x - area/2;
			local area_y = y - area/2;
			local area_x_max = x + area/2;
			local area_y_max = y + area/2;
			local step = math.ceil(area / density);
			while area_x <= area_x_max do
				area_y = y - area/2;
				while area_y <= area_y_max do
					if (GetDistanceBetweenCoords(x, y, z, area_x, area_y, 0, false) < area/2) then
						local _, area_z = GetGroundZFor_3dCoord(area_x, area_y, z + 5.0);
						DrawLine(area_x - 0.25, area_y - 0.25, area_z + 0.05, area_x + 0.25, area_y + 0.25, area_z + 0.05, 255, 0, 0, 255);
						DrawLine(area_x - 0.25, area_y + 0.25, area_z + 0.05, area_x + 0.25, area_y - 0.25, area_z + 0.05, 255, 0, 0, 255);
					end
					area_y = area_y + step;
				end
				area_x = area_x + step;
			end
		end
	end)
end
RegisterNetEvent("Fire:preview");
AddEventHandler("Fire:preview", Fire.preview);


------------------------------------------------------------
-- Client: start fire function
------------------------------------------------------------

function Fire.start(x, y, z, distance, area, density, scale)
	local area_x = x - area/2;
	local area_y = y - area/2;
	local area_x_max = x + area/2;
	local area_y_max = y + area/2;
	local step = math.ceil(area / density);

	local var1, var2 = GetStreetNameAtCoord(x, y, z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
	local current_zone = zones[GetNameOfZone(x, y, z)]
	if GetStreetNameFromHashKey(var1) then
		local street1 = tostring(GetStreetNameFromHashKey(var1))
		if GetStreetNameFromHashKey(var2) and tostring(GetStreetNameFromHashKey(var2)) ~= "" then
			local street2 = tostring(GetStreetNameFromHashKey(var2))
			TriggerEvent('chatMessage', "^3EMERGENCY", {100, 100, 100}, "A fire has been spotted near "..street1.." and "..street2.." in "..current_zone.."!")
		else
			TriggerEvent('chatMessage', "^3EMERGENCY", {100, 100, 100}, "A fire has been spotted near "..street1.." in "..current_zone.."!")
		end
	end

	-- Loop through a square, with steps based on density
	while area_x <= area_x_max do
		area_y = y - area/2;
		while area_y <= area_y_max do
			-- Check the distance to the center to make it into a circle only
			if (GetDistanceBetweenCoords(x, y, z, area_x, area_y, 0, false) < area/2) then
				local _, area_z = GetGroundZFor_3dCoord(area_x, area_y, z + 30.0);
				Fire.newFire(area_x, area_y, area_z, scale);
			end
			area_y = area_y + step;
		end
		area_x = area_x + step;
	end
end
RegisterNetEvent("Fire:start");
AddEventHandler("Fire:start", Fire.start);

function Fire.newFire(posX, posY, posZ, scale)
	-- Load the fire particle
	if (not HasNamedPtfxAssetLoaded("core")) then
		RequestNamedPtfxAsset("core");
		local waitTime = 0;
		while not HasNamedPtfxAssetLoaded("core") do
			if (waitTime >= 1000) then
				RequestNamedPtfxAsset("core");
				waitTime = 0;
			end
			Wait(10);
			waitTime = waitTime + 10;
		end
	end
	UseParticleFxAssetNextCall("core");

	-- Make both a standard fire and a big fire particle on top of it
	local fxHandle = StartParticleFxLoopedAtCoord("ent_ray_ch2_farm_fire_dble", posX, posY, posZ + 0.25, 0.0, 0.0, 0.0, scale + 0.001, false, false, false, false);
	StartParticleFxLoopedAtCoord("ent_amb_smoke_foundry", posX, posY, posZ+2, 0.0,0.0,0.0,1.0, false, false, false)
	local fireHandle = StartScriptFire(posX, posY, posZ + 0.25, 0, false);
	Fire.flames[#Fire.flames + 1] = {fire = fireHandle, ptfx = fxHandle, pos = {x = posX, y = posY, z = posZ + 0.05}};

	-- local ped = GetPlayerPed(-1)
	-- SetEntityCoords(ped, posX, posY, posZ + 0.25, 1, 0, 0, 1)
end

function Fire.prepare()
	local ped = GetPlayerPed(-1)
	PopulatePedIndex()
	if(#pedindex > 0) then
		local rped = pedindex[math.random(#pedindex)]
		local rpedPos = GetEntityCoords(rped, nil)
		TriggerServerEvent("fire:initializeFire", rpedPos.x, rpedPos.y, rpedPos.z)
	else
		TriggerServerEvent("fire:initializeFire", -525.19885253906,-1210.2631835938,18.184833526612)
	end
end
RegisterNetEvent("Fire:prepare");
AddEventHandler("Fire:prepare", Fire.prepare);


------------------------------------------------------------
-- Client: stop all fires function
------------------------------------------------------------

function Fire.stop()
	for i, flame in pairs(Fire.flames) do
		if DoesParticleFxLoopedExist(flame.ptfx) then
			StopParticleFxLooped(flame.ptfx, 1);
			RemoveParticleFx(flame.ptfx, 1);
		end
		RemoveScriptFire(flame.fire);
		StopFireInRange(flame.pos.x, flame.pos.y, flame.pos.z, 20.0);
		table.remove(Fire.flames, i);
	end
end
RegisterNetEvent("Fire:stop");
AddEventHandler("Fire:stop", Fire.stop);


------------------------------------------------------------
-- Client: Handle fires
------------------------------------------------------------

function PopulatePedIndex()
  local handle, ped = FindFirstPed()
  local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
	local pedct = 1
	pedindex = {}
  repeat
    if not IsEntityDead(ped) and IsPedSittingInAnyVehicle(ped) then
			local playerped = GetPlayerPed(-1)
			local playerpedPos = GetEntityCoords(playerped, nil)
			local pedPos = GetEntityCoords(ped, nil)
			if GetDistanceBetweenCoords(GetEntityCoords(ped, nil), playerpedPos, true) > 35.0001 then
	    	pedindex[pedct] = ped
				pedct = ped+1
			end
    end
    finished, ped = FindNextPed(handle) -- first param returns true while entities are found
  until not finished
  EndFindPed(handle)
end

Citizen.CreateThread(function()
	while true do
		Wait(0);
		-- Loop through all the fires
		for i, flame in pairs(Fire.flames) do
			if DoesParticleFxLoopedExist(flame.ptfx) then
				-- If there are no more 'normal' fire next to the big fire particle, remove the particle
				if (GetNumberOfFiresInRange(flame.pos.x, flame.pos.y, flame.pos.z, 0.2) <= 1) then
					StopParticleFxLooped(flame.ptfx, 1);
					RemoveParticleFx(flame.ptfx, 1);
					RemoveScriptFire(flame.fire);
					table.remove(Fire.flames, i);
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(1);
		extinguishFire()
	end
end)

function extinguishFire()
	local ped = GetPlayerPed(-1)
	local pedPos = GetEntityCoords(ped, nil)
	local _, hash = GetCurrentPedWeapon(ped, true)
	if hash == 101631238 then
		if IsControlPressed(0, 69) then
			StopFireInRange(pedPos.x, pedPos.y, pedPos.z, 5.0);
		end
	end
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
