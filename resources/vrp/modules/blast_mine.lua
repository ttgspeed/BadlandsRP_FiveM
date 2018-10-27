local Log = module("lib/Log")
local lang = vRP.lang

function tvRP.checkDynamite()
	local task = TUNNEL_DELAYED()
	local user_id = vRP.getUserId(source)
	local index = index
	if vRP.tryGetInventoryItem(user_id,"dynamite",1,false) then
		task({true})
	else
		task({false})
	end
end

function tvRP.checkPospectingKit()
	local task = TUNNEL_DELAYED()
	local user_id = vRP.getUserId(source)
	local index = index
	local kit_ok = (vRP.getInventoryItemAmount(user_id,"prospecting_kit") >= 1)
	if kit_ok then
		task({true})
	else
		task({false})
	end
end

function tvRP.giveMetals(item,quantity)
	local user_id = vRP.getUserId(source)

	local inventory_ok = true
	local new_weight = vRP.getInventoryWeight(user_id)+vRP.getItemWeight(item)*quantity
	if new_weight > vRP.getInventoryMaxWeight(user_id) then
		inventory_ok = false
		vRPclient.notify(source, {lang.inventory.full()})
	end

	if quantity > 10 then
		Log.write(user_id, "Attempted to collect "..quantity.." "..item,Log.log_type.anticheat)
		vRP.ban(user_id, user_id.." Scripting perm (serpickle)", 0)
	end

	if inventory_ok then
		Log.write(user_id, "Collected "..quantity.." "..item,Log.log_type.action)
		vRP.giveInventoryItem(user_id,item,quantity,true)
	end
end
