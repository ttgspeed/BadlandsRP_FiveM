--Playerlist created by Arturs
local plist = false
function ShowPlayerList()
	if plist == false then
		local players
		players = '<tr class= "titles"><th class="name">Name</th><th class="id">ID</th></tr>'
        ptable = GetPlayers()
		for _, i in ipairs(ptable) do
			players = players..' <tr class="player"><th class="name">'..GetPlayerName(i)..'</th>'..' <th class="id">'..GetPlayerServerId(i)..'</th></tr>'
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

    for i = 0, 512 do
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
	end
end)
