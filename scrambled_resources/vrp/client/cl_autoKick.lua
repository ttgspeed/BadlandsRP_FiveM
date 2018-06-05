--[[
Citizen.CreateThread(function()
	local id = GetPlayerServerId() -- get player ID
	Citizen.Wait(300*10000)
	while true do
        Citizen.Wait(10000) -- time to refresh script (10 000 for every 1 seconds)
		ptable = GetPlayers()
		playerNumber = 0
		for _, i in ipairs(ptable) do
			playerNumber = playerNumber + 1
		end
		local name = GetPlayerName(PlayerId())		-- get player name
		TriggerServerEvent('fec98dca-8900-466b-996a-7de72699eaf1', playerNumber, name, id)	-- Send infos of number players for client to server
	end
end)
]]-- Disabled was causing more issues than preventing

function GetPlayers() -- function to get players
    local players = {}

    for i = 0, cfg.max_players do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end
