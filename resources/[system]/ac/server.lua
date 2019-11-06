steamkey = '310C2377815B5BD4238B4DCF07F7DA80' --Steam API Key
minimumAge = 1209600 --Two weeks (seconds)
slist = {}

AddEventHandler("playerConnecting",function(name,setMessage)
	Citizen.CreateThread(function()
		local ids = GetPlayerIdentifiers(source)

		if ids ~= nil and #ids > 0 then
			local colonPos = string.find(ids[1],":")
			local steamid64 = string.sub(ids[1],colonPos+1)
			steamid64 = tonumber(steamid64,16)..""
			if(steamid64 ~= nil) then
				slist[steamid64] = source
				local ageUrl = 'https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key='..steamkey..'&steamids='..steamid64 --because PerformHttpRequest doesn't pass data correctly
				local bansUrl = 'https://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?key='..steamkey..'&steamids='..steamid64 --because PerformHttpRequest doesn't pass data correctly
				PerformHttpRequest(bansUrl, function(err, response, headers)
						if response then
							local data = json.decode(response)
							local vacBanned = data.players[1].VACBanned
							if(vacBanned) then
								--intentionally vague message to prevent them from figuring out why they're blocked
								print("Rejecting "..data.players[1].SteamId.." due to VAC ban.")
								DropPlayer(slist[tonumber(data.players[1].SteamId)], 'You are ineligible to join this server. Appeal at server.com.')
								CancelEvent()
							end
						end
				end, 'GET', json.encode({}), { ["Content-Type"] = 'application/json' })
				PerformHttpRequest(ageUrl, function(err, response, headers)
						if response then
							local data = json.decode(response)
							local timecreated = tonumber(data.response.players[1].timecreated)
							if((os.time() - timecreated) < minimumAge) then
								--intentionally vague message to prevent them from figuring out why they're blocked
								print("Rejecting "..data.response.players[1].steamid.." due to account age.")
								DropPlayer(slist[(data.response.players[1].steamid)], 'You are ineligible to join this server. Appeal at server.com.')
								CancelEvent()
							end
						end
				end, 'GET', json.encode({}), { ["Content-Type"] = 'application/json' })
			else
				--might be able to remove this, vrp has a similar check
				DropPlayer(source, '[server] Unable to obtain Steam session')
				CancelEvent()
			end
		else
			--might be able to remove this, vrp has a similar check
			DropPlayer(source, '[server] Unable to obtain Steam session')
			CancelEvent()
		end
	end)
end)
