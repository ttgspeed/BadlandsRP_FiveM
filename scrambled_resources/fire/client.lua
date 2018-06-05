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
-- Client: start fire function
------------------------------------------------------------

function Fire.alert(x, y, z)
	local var1, var2 = GetStreetNameAtCoord(x, y, z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
	local current_zone = zones[GetNameOfZone(x, y, z)]
	if GetStreetNameFromHashKey(var1) then
		local street1 = tostring(GetStreetNameFromHashKey(var1))
		if GetStreetNameFromHashKey(var2) and tostring(GetStreetNameFromHashKey(var2)) ~= "" then
			local street2 = tostring(GetStreetNameFromHashKey(var2))
			TriggerServerEvent('dc6fafcc-96ee-487b-b5a6-1b963e91eb69', "A fire has been spotted near "..street1.." and "..street2.." in "..current_zone.."!")
		else
			TriggerServerEvent('dc6fafcc-96ee-487b-b5a6-1b963e91eb69', "A fire has been spotted near "..street1.." in "..current_zone.."!")
		end
	end
end

function Fire.build(x, y, z)
	local scale = math.random(1,2)
	local firecount = math.random(4,8)
	Fire.alert(x, y, z)
	for i=1,firecount do
		local delta_x = math.random(100,400)
		local delta_y = math.random(100,400)
		delta_x = x + ((delta_x/100)*(math.random(1,2)*2)-3)
		delta_y = y + ((delta_y/100)*(math.random(1,2)*2)-3)
		local _, delta_z = GetGroundZFor_3dCoord(delta_x, delta_y, z + 300.000001);
		if delta_z == 0 then delta_z = z end
		TriggerServerEvent('7a77fe34-c192-46ae-a1c9-9c8009ab88f1', delta_x, delta_y, delta_z, scale)
	end
end

function Fire.create(posX, posY, posZ, scale)
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
	StartParticleFxLoopedAtCoord("ent_amb_smoke_foundry", posX, posY, posZ+2.0, 0.0,0.0,0.0,1.0, false, false, false)
	local fireHandle = StartScriptFire(posX, posY, posZ + 0.25, 0, false);
	Fire.flames[#Fire.flames + 1] = {fire = fireHandle, ptfx = fxHandle, pos = {x = posX, y = posY, z = posZ + 0.25}};

	--local ped = GetPlayerPed(-1)
	--SetEntityCoords(ped, posX, posY, posZ + 0.25, 1, 0, 0, 1)
end
RegisterNetEvent('9fc5bf40-427f-4968-9557-cb68b98197aa');
AddEventHandler('9fc5bf40-427f-4968-9557-cb68b98197aa', Fire.create);

function Fire.prepare()
	PopulatePedIndex()
	if(#pedindex > 0) then
		local rped = pedindex[math.random(#pedindex)]
		local rpedPos = GetEntityCoords(rped, nil)
		Fire.build(rpedPos.x, rpedPos.y, rpedPos.z)
	else
		Fire.build(-525.19885253906,-1210.2631835938,18.184833526612)
	end
end
RegisterNetEvent('a1b13523-7453-44c8-b39d-204131adcab1');
AddEventHandler('a1b13523-7453-44c8-b39d-204131adcab1', Fire.prepare);


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
RegisterNetEvent('48cf8f8a-0f1f-4a4d-acc6-650e1977db7c');
AddEventHandler('48cf8f8a-0f1f-4a4d-acc6-650e1977db7c', Fire.stop);


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
		Wait(100);
		fireExtinguisher()
	end
end)

function fireExtinguisher()
	local ped = GetPlayerPed(-1)
	local pedPos = GetEntityCoords(ped, nil)
	local _, hash = GetCurrentPedWeapon(ped, true)
	if hash == 101631238 then
		if IsControlPressed(0, 69) then
			TriggerServerEvent('bcdac172-cfb8-49de-bba8-daf0204e45e5', pedPos.x, pedPos.y, pedPos.z)
		end
	end
end

function Fire.clientStopInRange(x, y, z)
	StopFireInRange(x, y, z, 15.0);
end
RegisterNetEvent('cd74d37e-4cd1-4014-9828-07bee772bd6e');
AddEventHandler('cd74d37e-4cd1-4014-9828-07bee772bd6e', Fire.clientStopInRange);

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
