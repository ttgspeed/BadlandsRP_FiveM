function tvRP.hasAnyDrugs()
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	if vRP.getInventoryItemAmount(user_id,"meth") > 0 then
		return true, "meth"
	elseif vRP.getInventoryItemAmount(user_id,"weed2") > 0 then
		return true, "weed2"
	elseif vRP.getInventoryItemAmount(user_id,"weed") > 0 then
		return true, "weed"
	end
	return false, nil
end

function tvRP.itemCheck()
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	if vRP.tryGetInventoryItem(user_id,"meth",1,false) then
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

drugs = {
	["meth"] = {lowPrice = 130, highPrice = 180, name = "Meth baggie", weight = 0.5},
	["weed"] = {lowPrice = 100, highPrice = 130, name = "Kifflom Kuff joint", weight = 0.5}, -- kifflom kush
	["weed2"] = {lowPrice = 120, highPrice = 160, name = "Serpickle Berry joint", weight = 0.5}, -- serpickle berry
}

function tvRP.giveReward(drug)
	if drug ~= nil then
		local user_id = vRP.getUserId(source)
		local player = vRP.getUserSource(user_id)
		local reward = math.random(drugs[drug].lowPrice,drugs[drug].highPrice)
		local sellAmount = 1
		local random = math.random(1,5)
		if random == 3 then
			if vRP.getInventoryItemAmount(user_id,drug) >= 2 then
				sellAmount = 2
			end
		end
		if user_id ~= nil and player ~= nil then
			if vRP.tryGetInventoryItem(user_id,drug,1,false) then
				vRP.giveMoney(user_id,reward*sellAmount)
				vRPclient.notify(source,{"Received $"..(reward*sellAmount).." for selling "..sellAmount.." "..drugs[drug].name})
			end
		end
	end
end
