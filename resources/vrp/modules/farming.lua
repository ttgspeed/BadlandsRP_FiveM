function tvRP.giveFarmingReward(reward,ammount)
	local source = source
	local user_id = vRP.getUserId(source)
	if reward ~= nil and user_id ~= nil and ammount ~= nil then
		if (vRP.getInventoryWeight(user_id)+1) <= vRP.getInventoryMaxWeight(user_id) then
			vRP.giveInventoryItem(user_id,reward,ammount,false)
		else
			vRP.giveInventoryItem(user_id,"cannabis_seed",1,false)
			vRPclient.notify(source,{"Inventory full. Cannabis seed returned."})
		end
	end
end
