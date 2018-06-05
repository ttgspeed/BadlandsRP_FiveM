local Log = module("lib/Log")

RegisterServerEvent('29282765-6068-4a6f-ae7f-43eafabb916a')
AddEventHandler('29282765-6068-4a6f-ae7f-43eafabb916a', function(reason)
	local user_id = vRP.getUserId(source)
	if user_id == nil then
		user_id = "Not loaded in vRP"
	end
	Log.write(user_id,"-- ANTI-CHEAT LOG -- ("..user_id.." - "..(GetPlayerEP(source) or '0.0.0.0').." - "..(vRP.getSourceIdKey(source) or 'missing identifier')..") "..(GetPlayerName(source) or 'missing name').." -- "..reason, Log.log_type.anticheat)
	--DropPlayer(source, reason)
end)

RegisterServerEvent('9d8545b4-76af-4481-80ab-7ce5b5c923e4')
AddEventHandler('9d8545b4-76af-4481-80ab-7ce5b5c923e4', function(reason)
	local user_id = vRP.getUserId(source)
	if user_id == nil then
		user_id = "Not loaded in vRP"
	end
	Log.write(user_id,"-- ANTI-CHEAT LOG -- ("..user_id.." - "..(GetPlayerEP(source) or '0.0.0.0').." - "..(vRP.getSourceIdKey(source) or 'missing identifier')..") "..(GetPlayerName(source) or 'missing name').." -- "..reason, Log.log_type.anticheat)
	vRP.ban(source, user_id.." Scripting perm (serpickle)", 0)
	--DropPlayer(source, user_id.." Scripting perm (serpickle)")
end)

RegisterServerEvent('59148f0c-cf37-495e-815b-20ca333a183b')
AddEventHandler('59148f0c-cf37-495e-815b-20ca333a183b', function(reason)
	local user_id = vRP.getUserId(source)
	if user_id == nil then
		user_id = "Not loaded in vRP"
	end
	Log.write(user_id,"-- ANTI-CHEAT LOG -- ("..user_id.." - "..(GetPlayerEP(source) or '0.0.0.0').." - "..(vRP.getSourceIdKey(source) or 'missing identifier')..") "..(GetPlayerName(source) or 'missing name').." -- "..reason, Log.log_type.anticheat)
end)
