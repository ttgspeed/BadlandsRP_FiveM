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

AddEventHandler('chatMessage', function(source, name, message)
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

RegisterServerEvent('7a77fe34-c192-46ae-a1c9-9c8009ab88f1');
AddEventHandler('7a77fe34-c192-46ae-a1c9-9c8009ab88f1', function(x, y, z, scale)
	TriggerClientEvent('9fc5bf40-427f-4968-9557-cb68b98197aa', -1, x, y, z, scale)
	--print(x.." "..y.." "..z)
end);

RegisterServerEvent('bcdac172-cfb8-49de-bba8-daf0204e45e5');
AddEventHandler('bcdac172-cfb8-49de-bba8-daf0204e45e5', function(x, y, z)
	TriggerClientEvent('cd74d37e-4cd1-4014-9828-07bee772bd6e', -1, x, y, z)
end);

RegisterServerEvent('dc6fafcc-96ee-487b-b5a6-1b963e91eb69');
AddEventHandler('dc6fafcc-96ee-487b-b5a6-1b963e91eb69', function(message)
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
			TriggerClientEvent('a1b13523-7453-44c8-b39d-204131adcab1', selected_player_id)
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
