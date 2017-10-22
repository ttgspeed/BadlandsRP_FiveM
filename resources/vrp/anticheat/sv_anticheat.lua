local Log = module("lib/Log")

RegisterServerEvent("anticheat:kick")
AddEventHandler("anticheat:kick", function(reason)
	local user_id = vRP.getUserId(source)
	if user_id == nil then
		user_id = "Not loaded in vRP"
	end
	Log.write(user_id,"-- ANTI-CHEAT LOG -- ("..user_id.." - "..GetPlayerEP(source).." - "..vRP.getSourceIdKey(source)..") "..GetPlayerName(source).." -- "..reason, Log.log_type.anticheat)
	--DropPlayer(source, reason)
end)


RegisterServerEvent("anticheat:ban")
AddEventHandler("anticheat:ban", function(reason, details)
	local user_id = vRP.getUserId(source)
	if user_id == nil then
		user_id = "Not loaded in vRP"
	end
	Log.write(user_id,"-- ANTI-CHEAT LOG -- ("..user_id.." - "..GetPlayerEP(source).." - "..vRP.getSourceIdKey(source)..") "..GetPlayerName(source).." -- "..details, Log.log_type.anticheat)
	--vRP.ban(source, reason, 0)
	-- ban above does a drop, but incase not load in vrp kept, drop here too
	--DropPlayer(source, reason)
end)
