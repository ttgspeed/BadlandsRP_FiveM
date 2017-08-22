steamkey = '310C2377815B5BD4238B4DCF07F7DA80' --Steam API Key
minimumAge = 1209600 --Two weeks (seconds)

AddEventHandler("playerConnecting",function(name,setMessage)
	local ids = GetPlayerIdentifiers(source)

	if ids ~= nil and #ids > 0 then
		local colonPos = string.find(ids[1],":")
    local steamid64 = string.sub(ids[1],colonPos+1)
    steamid64 = tonumber(steamid64,16)..""

		if(steamid64 ~= nil) then
			local url = 'https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key='..steamkey..'&steamids='..steamid64
			PerformHttpRequest(url, function(err, response, headers)
			    if response then
						local data = json.decode(response)
			      local timecreated = tonumber(data.response.players[1].timecreated)
						if((os.time() - timecreated) < minimumAge) then
							print('too young')
						else
							print('old enough')
						end
			    end
			end, 'GET', json.encode({}), { ["Content-Type"] = 'application/json' })
		end
	end
end)
