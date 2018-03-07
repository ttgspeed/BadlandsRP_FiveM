function tvRP.giveFarmingReward(reward,ammount)
	local user_id = vRP.getUserId(source)
	if reward ~= nil and user_id ~= nil and ammount ~= nil then
		vRP.giveInventoryItem(user_id,reward,ammount,true)
	end
end
