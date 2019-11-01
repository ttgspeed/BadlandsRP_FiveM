local Log = module("lib/Log")

RegisterServerEvent("anticheat:kick")
AddEventHandler("anticheat:kick", function(reason)
	local user_id = vRP.getUserId(source)
	if user_id == nil then
		user_id = "Not loaded in vRP"
	end
	Log.write(user_id,"-- ANTI-CHEAT LOG -- ("..user_id.." - "..(GetPlayerEP(source) or '0.0.0.0').." - "..(vRP.getSourceIdKey(source) or 'missing identifier')..") "..(GetPlayerName(source) or 'missing name').." -- "..reason, Log.log_type.anticheat)
	vRP.kick(source, "[Dropped] Invalid data provided to server. Please reconnect. If this issue persists, please contact staff for assistance.")
end)

RegisterServerEvent("anticheat:ban")
AddEventHandler("anticheat:ban", function(reason)
	local user_id = vRP.getUserId(source)
	if user_id == nil then
		user_id = "Not loaded in vRP"
	end
	Log.write(user_id,"-- ANTI-CHEAT LOG -- ("..user_id.." - "..(GetPlayerEP(source) or '0.0.0.0').." - "..(vRP.getSourceIdKey(source) or 'missing identifier')..") "..(GetPlayerName(source) or 'missing name').." -- "..reason, Log.log_type.anticheat)
	vRP.ban(source, user_id.." Scripting perm (serpickle)", 0)
	--DropPlayer(source, user_id.." Scripting perm (serpickle)")
end)

RegisterServerEvent("anticheat:log")
AddEventHandler("anticheat:log", function(reason)
	local user_id = vRP.getUserId(source)
	if user_id == nil then
		user_id = "Not loaded in vRP"
	end
	Log.write(user_id,"-- ANTI-CHEAT LOG -- ("..user_id.." - "..(GetPlayerEP(source) or '0.0.0.0').." - "..(vRP.getSourceIdKey(source) or 'missing identifier')..") "..(GetPlayerName(source) or 'missing name').." -- "..reason, Log.log_type.anticheat)
end)


AddEventHandler('explosionEvent', function(source, ev)
	if(ev.cameraShake ~= 0.0 and ev.damageScale ~= 0.0) then
		local reason = "Spawned an explosion (Type: "..tostring(ev.explosionType).." | Audible: "..tostring(ev.isAudible).." | Invisible: "..tostring(ev.isInvisible).." | Shake: "..tostring(ev.cameraShake).." | Damage: "..tostring(ev.damageScale)..")"
		local user_id = vRP.getUserId(source)
		if user_id == nil then
			user_id = "Not loaded in vRP"
		end
		Log.write(user_id,"-- ANTI-CHEAT LOG -- ("..user_id.." - "..(GetPlayerEP(source) or '0.0.0.0').." - "..(vRP.getSourceIdKey(source) or 'missing identifier')..") "..(GetPlayerName(source) or 'missing name').." -- "..reason, Log.log_type.anticheat)
	end
end)
