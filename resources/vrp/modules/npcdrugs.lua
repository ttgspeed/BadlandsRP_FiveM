local Log = module("lib/Log")
local cfg = module("cfg/npcdrugs")
drugs = cfg.drugs

function tvRP.hasAnyDrugs()
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local canSell = vRP.hasPermission(user_id, "citizen.gather")
	if canSell then
		if vRP.getInventoryItemAmount(user_id,"cocaine_poor") > 0 then
			return true, "cocaine_poor"
		elseif vRP.getInventoryItemAmount(user_id,"meth") > 0 then
			return true, "meth"
		elseif vRP.getInventoryItemAmount(user_id,"weed2") > 0 then
			return true, "weed2"
		elseif vRP.getInventoryItemAmount(user_id,"weed") > 0 then
			return true, "weed"
		end
	end
	return false, nil
end

function tvRP.itemCheck()
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	if vRP.tryGetInventoryItem(user_id,"cocaine_poor",1,false) then
	vRPclient.cancelDrug(player,{"cocaine_poor"})
	elseif vRP.tryGetInventoryItem(user_id,"meth",1,false) then
		vRPclient.cancelDrug(player,{"meth"})
	elseif vRP.tryGetInventoryItem(user_id,"weed2",1,false) then
		vRPclient.cancelDrug(player,{"weed2"})
	elseif vRP.tryGetInventoryItem(user_id,"weed",1,false) then
		vRPclient.cancelDrug(player,{"weed"})
	else
		vRPclient.done(player,{})
		vRPclient.cancelDrug(player,{nil})
	end
end

function tvRP.giveReward(drug, drugHandicap)
	if drug ~= nil then
		local user_id = vRP.getUserId(source)
		local player = vRP.getUserSource(user_id)
		local reward = math.random(drugs[drug].lowPrice,drugs[drug].highPrice)
		if drugHandicap then
			reward = parseInt(reward * 0.65)
		end
		local sellAmount = 1
		local random = math.random(1,12)
		if random == 1 or random == 2 or random == 3 or random == 4 then
			if vRP.getInventoryItemAmount(user_id,drug) >= 2 then
				sellAmount = 2
			end
		elseif random == 5 or random == 6 or random == 7 then
			if vRP.getInventoryItemAmount(user_id,drug) >= 3 then
				sellAmount = 3
			elseif vRP.getInventoryItemAmount(user_id,drug) >= 2 then
				sellAmount = 2
			end
		elseif random == 8 or random == 9 then
			if vRP.getInventoryItemAmount(user_id,drug) >= 4 then
				sellAmount = 4
			elseif vRP.getInventoryItemAmount(user_id,drug) >= 3 then
				sellAmount = 3
			elseif vRP.getInventoryItemAmount(user_id,drug) >= 2 then
				sellAmount = 2
			end
		--[[
		elseif random == 10 then
			if vRP.getInventoryItemAmount(user_id,drug) >= 5 then
				sellAmount = 5
			elseif vRP.getInventoryItemAmount(user_id,drug) >= 4 then
				sellAmount = 4
			elseif vRP.getInventoryItemAmount(user_id,drug) >= 3 then
				sellAmount = 3
			elseif vRP.getInventoryItemAmount(user_id,drug) >= 2 then
				sellAmount = 2
			end
		]]--
		end
		if user_id ~= nil and player ~= nil then
			if vRP.tryGetInventoryItem(user_id,drug,sellAmount,false) then
				vRP.giveMoney(user_id,reward*sellAmount)
				vRPclient.notify(source,{"Received $"..(reward*sellAmount).." for selling "..sellAmount.." "..drugs[drug].name})
				Log.write(user_id, "Sold "..sellAmount.." qty of "..drug.." to NPC for $"..(reward*sellAmount), Log.log_type.action)
			end
		end
	end
end
