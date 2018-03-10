-- Use the following variable(s) to adjust the position.
-- adjust the x-axis (left/right)
x = 1.000
-- adjust the y-axis (top/bottom)
y = 1.000
-- If you do not see the HUD after restarting script you adjusted the x/y axis too far.

-- Use the following variable(s) to adjust the color(s) of each element.
-- Use the following variables to adjust the color of the border around direction.
border_r = 255
border_g = 255
border_b = 255
border_a = 100

-- Use the following variables to adjust the color of the direction user is facing.
dir_r = 255
dir_g = 255
dir_b = 255
dir_a = 255

-- Use the following variables to adjust the color of the street user is currently on.
curr_street_r = 240
curr_street_g = 200
curr_street_b = 80
curr_street_a = 255

-- Use the following variables to adjust the color of the street around the player. (this will also change the town the user is in)
str_around_r = 255
str_around_g = 255
str_around_b = 255
str_around_a = 255

-- Use the following variables to adjust the color of the city the player is in (without there being a street around them)
town_r = 255
town_g = 255
town_b = 255
town_a = 255

local bankBalance = 0
local cashBalance = 0
local hunger = 0
local thirst = 0
local job = ""
local espEnabled = false

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
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

function drawTxt2(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(6)
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

local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['golf'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

local directions = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N', }

local showTags = true
local showUI = true
local setVoiceProximity = "Normal"

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
		local current_zone = zones[GetNameOfZone(pos.x, pos.y, pos.z)]
		for k,v in pairs(directions)do
			direction = GetEntityHeading(GetPlayerPed(-1))
			if(math.abs(direction - k) < 22.5)then
				direction = v
				break;
			end
		end

		if showUI then
			if(GetStreetNameFromHashKey(var1) and GetNameOfZone(pos.x, pos.y, pos.z))then
				if(current_zone and tostring(GetStreetNameFromHashKey(var1)))then
					drawTxt2(0.675, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
					if tostring(GetStreetNameFromHashKey(var2)) == "" then
						drawTxt2(0.707, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
					else
						drawTxt2(0.707, y+0.45, 1.0,1.0,0.45, tostring(GetStreetNameFromHashKey(var2)) .. ", " .. current_zone, str_around_r, str_around_g, str_around_b, str_around_a)
					end
					drawTxt2(0.707, y+0.42, 1.0,1.0,0.55, tostring(GetStreetNameFromHashKey(var1)), curr_street_r, curr_street_g, curr_street_b, curr_street_a)
				end
			end

			local output = ""
			if NetworkIsPlayerTalking(NetworkGetPlayerIndexFromPed(GetPlayerPed(-1))) then
				output = "~r~Voice: " .. setVoiceProximity
			else
				output = "~w~Voice: " .. setVoiceProximity
			end
			if tvRP.isAdmin() then
				if tvRP.getGodModeState() then
					output = output .. "~w~ | ~r~GODMODE ENABLED"
				end
				if espEnabled then
					output = output .. "~w~ | ~r~ESP ENABLED"
				end
			end

			drawTxt2(0.675, 1.39, 1.0,1.0,0.4, output, curr_street_r, curr_street_g, curr_street_b, curr_street_a)
      drawTxt2(0.675, 1.36, 1.0,1.0,0.4, "~w~Hunger: "..hunger, curr_street_r, curr_street_g, curr_street_b, curr_street_a)
      drawTxt2(0.675, 1.33, 1.0,1.0,0.4, "~w~Thirst: "..thirst, curr_street_r, curr_street_g, curr_street_b, curr_street_a)
      if(job ~= "Unemployed") then
        drawTxt2(0.675, 1.30, 1.0,1.0,0.4, job, curr_street_r, curr_street_g, curr_street_b, curr_street_a)
      end
		end

		if showTags then
			local posme = GetEntityCoords(GetPlayerPed(-1), false)

			for i = 0,cfg.max_players do
				if(NetworkIsPlayerActive(i) and GetPlayerPed(i) ~= GetPlayerPed(-1))then
					if (HasEntityClearLosToEntity(GetPlayerPed(-1), GetPlayerPed(i), 17) and IsEntityVisible(GetPlayerPed(i))) or espEnabled then
						local pos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(i), 0, 0, 1.4)
						local distance = Vdist(pos.x, pos.y, pos.z, posme.x, posme.y, posme.z)
						if(distance < 15.0) or espEnabled then
							local x,y,z = World3dToScreen2d(pos.x, pos.y, pos.z)
							local user_id = tvRP.getUserId(GetPlayerServerId(i))
							if not user_id then
								user_id = "unk"
							end
							SetTextFont(11)
							if distance < 5 then
								SetTextScale(0.0, 0.34)
							elseif distance < 7.0 then
								SetTextScale(0.0, 0.32)
							elseif distance < 9.0 then
								SetTextScale(0.0, 0.30)
							elseif distance < 11.0 then
								SetTextScale(0.0, 0.28)
							elseif distance < 13.0 then
								SetTextScale(0.0, 0.26)
							elseif distance < 15.0 then
								SetTextScale(0.0, 0.24)
							else
								SetTextScale(0.0, 0.20)
							end
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
			for i = 0,cfg.max_players do
				if(GetPlayerName(i))then
					if(NetworkIsPlayerTalking(i))then
						t = t + 1

						if(t == 1)then
								drawTxt2(0.515, 0.95, 1.0,1.0,0.4, "~y~Talking", curr_street_r, curr_street_g, curr_street_b, curr_street_a)
						end
						local user_id = tvRP.getUserId(GetPlayerServerId(i))
						if not user_id then
							user_id = "unk"
						end
						if GetPlayerPed(i) == GetPlayerPed(-1) then
							drawTxt2(0.520, 0.95 + (t * 0.023), 1.0,1.0,0.4, "~w~You: "..user_id, curr_street_r, curr_street_g, curr_street_b, curr_street_a)
						else
							drawTxt2(0.520, 0.95 + (t * 0.023), 1.0,1.0,0.4, "~w~"..user_id, curr_street_r, curr_street_g, curr_street_b, curr_street_a)
						end
					end
				end
			end
		end
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

	for i = 0, cfg.max_players do
		if NetworkIsPlayerActive(i) then
			table.insert(players, i)
		end
	end

	return players
end

function tvRP.setVoiceProximityLbl(voip_state)
	setVoiceProximity = voip_state
end

function tvRP.toggleESP()
	espEnabled = not espEnabled
	if espEnabled then
		tvRP.notify("ESP Enabled")
	else
		tvRP.notify("ESP Disabled")
	end
end

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)
		--Displays playerlist when player hold X
		if IsControlJustPressed(1, 167) or IsDisabledControlJustPressed(1,167) then --Start holding
			ShowPlayerList()
		elseif IsControlJustReleased(1, 167) or IsDisabledControlJustReleased(1,167) then --Stop holding
			ShowPlayerList()
		end
		if IsControlJustPressed(1, 168) or IsDisabledControlJustPressed(1,168) then
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

-- Send NUI message to update bank balance
RegisterNetEvent('banking:updateBalance')
AddEventHandler('banking:updateBalance', function(balance)
	bankBalance = balance
end)

-- Send NUI message to update cash balance
RegisterNetEvent('banking:updateCashBalance')
AddEventHandler('banking:updateCashBalance', function(balance)
  cashBalance = balance
end)

RegisterNetEvent('banking:updateJob')
AddEventHandler('banking:updateJob', function(nameJob)
  job = nameJob
end)

RegisterNetEvent('banking:updateThirst')
AddEventHandler('banking:updateThirst', function(drink)
  thirst = drink
end)

RegisterNetEvent('banking:updateHunger')
AddEventHandler('banking:updateHunger', function(food)
  hunger = food
end)
