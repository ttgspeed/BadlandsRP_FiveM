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
-- Chat command handler
------------------------------------------------------------

local fires = {}

RegisterServerEvent("fire:initializeFire");
AddEventHandler("fire:initializeFire", function(x, y, z)
	local distance_from_player = 0
	local area = math.random(10,20)
	local density = 3
	local scale = math.random(1,2)
	TriggerClientEvent("Fire:start", -1, x, y, z, distance_from_player, area, density, scale)
end);

function newFire(posX, posY, posZ, scale)
	TriggerClientEvent("Fire:newFire", -1, posX, posY, posZ, scale);
end
RegisterServerEvent("Fire:newFire");
AddEventHandler("Fire:newFire", newFire);

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1800000)
		local playerct = 1
		local playerlist = {}
		local players = GetPlayers()

		if (#players) > 0 then
			for _,player in pairs(players) do
	      playerlist[playerct] = {_,player}
				playerct = playerct + 1
	    end

			local selected_player = playerlist[math.random(1,#playerlist)]
			local selected_player_id = selected_player[1]
			print("starting new fire on "..selected_player_id.." - "..GetPlayerName(selected_player[2]))
			TriggerClientEvent("Fire:prepare", selected_player_id)
		end
	end
end)


------------------------------------------------------------
-- Utils
------------------------------------------------------------

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
