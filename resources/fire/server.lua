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
local quiet = false

AddEventHandler("chatMessage", function(source, name, message)
	local args = stringsplit(message, " ");
	if (args[1] == "/fire") then
		CancelEvent()
		if (args[2] == "quiet") then
			startFire(true)
		elseif (args[2] == "loud") then
			startFire(false)
		end
	end
end);

RegisterServerEvent("fire:deploy");
AddEventHandler("fire:deploy", function(x, y, z, scale)
	TriggerClientEvent("Fire:create", -1, x, y, z, scale)
	--print(x.." "..y.." "..z)
end);

RegisterServerEvent("fire:serverStopInRange");
AddEventHandler("fire:serverStopInRange", function(x, y, z)
	TriggerClientEvent("Fire:clientStopInRange", -1, x, y, z)
end);

RegisterServerEvent("fire:alert");
AddEventHandler("fire:alert", function(message)
	if not quiet then
		TriggerClientEvent('chatMessage', -1, "^3EMERGENCY", {100, 100, 100}, message)
	end
end);

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1800000)
		startFire(false)
	end
end)

function startFire(suppressAlert)
	Citizen.CreateThread(function()
		quiet = suppressAlert
		local playerct = 1
		local playerlist = {}
		local players = GetPlayers()

		if (#players) > 0 then
			for _,player in pairs(players) do
	      playerlist[playerct] = {_,player}
				playerct = playerct + 1
	    end

			local selected_player = playerlist[math.random(1,#playerlist)]
			local selected_player_id = selected_player[2]
			--print("starting new fire on "..selected_player_id.." - "..GetPlayerName(selected_player_id))
			TriggerClientEvent("Fire:prepare", selected_player_id)
		end
		Citizen.Wait(5000)
		quiet = false
	end)
end


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
