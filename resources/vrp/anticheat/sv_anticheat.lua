RegisterServerEvent("anticheat:kick")
AddEventHandler("anticheat:kick", function(reason)
	local user_id = vRP.getUserId(source)
	if user_id == nil then
		user_id = "Not loaded in vRP"
	end
	print("-- ANTI-CHEAT LOG -- ("..user_id.." - "..GetPlayerEP(source).." - "..vRP.getSourceIdKey(source)..") "..GetPlayerName(source).." -- "..reason)
	DropPlayer(source, reason)
end)


RegisterServerEvent("anticheat:ban")
AddEventHandler("anticheat:ban", function(reason, details)
	local user_id = vRP.getUserId(source)
	if user_id == nil then
		user_id = "Not loaded in vRP"
	end
	print("-- ANTI-CHEAT LOG -- ("..user_id.." - "..GetPlayerEP(source).." - "..vRP.getSourceIdKey(source)..") "..GetPlayerName(source).." -- "..details)
	vRP.ban(source, reason, 0)
	-- ban above does a drop, but incase not load in vrp kept, drop here too
	DropPlayer(source, reason)
end)
