local Log = module("lib/Log")
local cfg = module("cfg/npcdrugs")
drugs = cfg.drugs

function tvRP.giveFarmingReward(reward,ammount)
	local source = source
	local user_id = vRP.getUserId(source)
	if reward ~= nil and user_id ~= nil and ammount ~= nil then
		local freeSpace = (vRP.getInventoryMaxWeight(user_id))-(vRP.getInventoryWeight(user_id))
		if freeSpace >= 0.5 then
			local dif = freeSpace - (0.5*ammount)
			if dif >= 0 then
				vRP.giveInventoryItem(user_id,reward,ammount,false)
				Log.write(user_id, "Received "..ammount.." "..reward.." from farming", Log.log_type.action)
			else
				ammount = parseInt(freeSpace)
				vRP.giveInventoryItem(user_id,reward,ammount,false)
				Log.write(user_id, "Received "..ammount.." "..reward.." from farming", Log.log_type.action)
			end
			if reward == "marijuana" then
				msg = "Not bad, "..ammount.." Kifflom Kush buds received"
			elseif reward == "marijuana2" then
				msg = "Perfect harvest! You got "..ammount.." Serpickle Berry buds"
			elseif reward == "cannabis_seed" then
				msg = "Let's try this again, you recovered a seed"
			end
			vRPclient.notify(source,{msg})
		else
			vRPclient.notify(source,{"Inventory full"})
		end
	end
end
