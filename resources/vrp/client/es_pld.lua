function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

local directions = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N', }

local ranks = {
	{rank = 1, tag = "~b~Mod"},
	{rank = 3, tag = "~r~Admin"},
	{rank = 5, tag = "~r~Head-Admin"},
	{rank = 7, tag = "~y~Dev"}
}

local maxPlayers = 32
local showTags = true
local showUI = true

RegisterNetEvent('camera:hideUI')
AddEventHandler('camera:hideUI', function(toggle)
	if toggle ~= nil then
		showUI = toggle
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		local pos = GetEntityCoords(GetPlayerPed(-1))
		local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())

		if showUI then
			for k,v in pairs(directions)do
				direction = GetEntityHeading(GetPlayerPed(-1))
				if(math.abs(direction - k) < 22.5)then
					direction = v
					drawTxt(0.675, 1.39, 1.0,1.0,0.4, "~w~" .. tostring(direction), 255, 255, 255, 255)
					break;
				end
			end

			if(GetStreetNameFromHashKey(var1))then
				if(tostring(GetStreetNameFromHashKey(var1)))then
					if(var2 ~= 0)then
						drawTxt(0.675, 1.42, 1.0,1.0,0.4, "~b~" .. tostring(GetStreetNameFromHashKey(var1)) .. "~w~ / ~b~" .. tostring(GetStreetNameFromHashKey(var2)) .. "~w~", 255, 255, 255, 255)
					else
					  	drawTxt(0.675, 1.42, 1.0,1.0,0.4, "~b~" .. tostring(GetStreetNameFromHashKey(var1)), 255, 255, 255, 255)
					end
				end

				if(GetNameOfZone(pos.x, pos.y, pos.z) and zones[GetNameOfZone(pos.x, pos.y, pos.z)])then
					drawTxt(0.675, 1.45, 1.0,1.0,0.4, "~y~" .. zones[GetNameOfZone(pos.x, pos.y, pos.z)] .. "~w~", 255, 255, 255, 255)
				end
			end
		end

		if showTags then
			local posme = GetEntityCoords(GetPlayerPed(-1), false)

			for i = 0,maxPlayers do
				if(NetworkIsPlayerActive(i) and GetPlayerPed(i) ~= GetPlayerPed(-1))then
					if(HasEntityClearLosToEntity(GetPlayerPed(-1), GetPlayerPed(i), 17) and IsEntityVisible(GetPlayerPed(i)))then
						local pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(i), 0, 0, 1.4)

						if(Vdist(pos.x, pos.y, pos.z, posme.x, posme.y, posme.z) < 10.0)then
							local x,y,z = World3dToScreen2d(pos.x, pos.y, pos.z)
							local user_id = tvRP.getUserId(GetPlayerServerId(i))
							if not user_id then
								user_id = "unk"
							end
							SetTextFont(11)
							SetTextScale(0.0, 0.40)
							SetTextColour(255, 255, 255, 255);
							SetTextDropShadow(5, 0, 78, 255, 255);
							SetTextEdge(0, 0, 0, 0, 0);
							SetTextEntry("STRING");
							SetTextCentre(1)
							local user_id = tvRP.getUserId(GetPlayerServerId(i))
							if not user_id then
								user_id = "unk"
							end
							if NetworkIsPlayerTalking(i) then
								AddTextComponentString("~b~"..user_id)
							else
								AddTextComponentString(user_id)
							end
							DrawText(y, z)
						end
					end
				end
			end

			local t = 0
			for i = 0,maxPlayers do
				if(GetPlayerName(i))then
					if(NetworkIsPlayerTalking(i))then
						t = t + 1

						if(t == 1)then
								drawTxt(0.515, 0.95, 1.0,1.0,0.4, "~y~Talking", 255, 255, 255, 255)
						end
						local user_id = tvRP.getUserId(GetPlayerServerId(i))
						if not user_id then
							user_id = "unk"
						end
						if GetPlayerPed(i) == GetPlayerPed(-1) then
							if string.lower(tvRP.isWhispering()) == "normal" then
								drawTxt(0.520, 0.95 + (t * 0.023), 1.0,1.0,0.4, "~b~You: ~w~"..user_id, 255, 255, 255, 255)
							else
								drawTxt(0.520, 0.95 + (t * 0.023), 1.0,1.0,0.4, "~b~You: ~w~"..user_id.." ~b~("..tvRP.isWhispering()..")", 255, 255, 255, 255)
							end
						else
							drawTxt(0.520, 0.95 + (t * 0.023), 1.0,1.0,0.4, ""..user_id, 255, 255, 255, 255)
						end
					end
				end
			end
		end

		if(IsPedInAnyVehicle(GetPlayerPed(-1), false))then
			local speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 2.236936
			if(speed > 60)then
				drawTxt(0.675, 1.36, 1.0,1.0,0.4, "~r~" .. math.ceil(speed) .. "~b~ mph", 255, 255, 255, 255)
			else
				drawTxt(0.675, 1.36, 1.0,1.0,0.4, "~w~" .. math.ceil(speed) .. "~b~ mph", 255, 255, 255, 255)
			end
		end

		--[=====[
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
			local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			if DoesEntityExist(vehicle) and not IsEntityDead(vehicle) then
				if not HasStreamedTextureDictLoaded("speedo") then
					RequestStreamedTextureDict("speedo", true) -- unload it
					while not HasStreamedTextureDictLoaded("speedo") do
						Wait(0)
					end
				else
					-- everything is ok
					local degree = 0
					local step = 2.05833
					if GetEntitySpeed(vehicle) > 0 then degree=(GetEntitySpeed(vehicle)*2.236936)*step end
					DrawSprite("speedo", "speedom_003", 0.898,0.752,0.16,0.245, 0.0, 255, 255, 255, 255)
					if degree > 247 then degree=247 end
					DrawSprite("speedo", "needle_003", 0.898,0.755,0.116,0.15,43.00001+degree, 255, 255, 255, 200)
					if IsControlPressed(1, 216) then DrawSprite("speedo", "brakeson_001", 0.83,0.815,0.02,0.025, 0.0, 255, 255, 255, 255)
					else DrawSprite("speedo", "brakeson_002", 0.83,0.815,0.02,0.025, 0.0, 255, 255, 255, 255) end
				end
			end
		end
		--]=====]
	end
end)

--Playerlist created by Arturs
local plist = false
function ShowPlayerList()
	if plist == false then
		local players
		players = '<tr class= "titles"><th class="name">Name</th><th class="id">ID</th></tr>'
		ptable = GetPlayers()
		for _, i in ipairs(ptable) do
			local id = tvRP.getUserId(GetPlayerServerId(i))
			if not id then
				id = "unk"
			end
			players = players..' <tr class="player"><th class="name">'..GetPlayerName(i)..'</th>'..' <th class="id">'..id..'</th></tr>'
		end
		players = players
		SendNUIMessage({
			meta = 'open',
			players = players
		})
		plist = true
	else
		SendNUIMessage({
			meta = 'close'
		})
		plist = false
	end
end

function GetPlayers()
	local players = {}

	for i = 0, maxPlayers do
		if NetworkIsPlayerActive(i) then
			table.insert(players, i)
		end
	end

	return players
end

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)
		--Displays playerlist when player hold X
		if IsControlJustPressed(1, 167) then --Start holding
			ShowPlayerList()
		elseif IsControlJustReleased(1, 167) then --Stop holding
			ShowPlayerList()
		end
		if IsControlJustPressed(1, 168) then
			if showTags then
				showTags = false
				tvRP.notify("Player ID HUD disabled")
			else
				showTags = true
				tvRP.notify("Player ID HUD enabled")
			end
		end
	end
end)
