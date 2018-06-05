local banks = {
	["fleeca"] = {
		position = { x = 147.04908752441, y = -1044.9448242188, z = 29.36802482605 },
		reward = 50000,
		nameofbank = "Fleeca Bank",
		lastrobbed = 0
	},
	["fleeca2"] = {
		position = { x = -2957.6674804688, y = 481.45776367188, z = 15.697026252747 },
		reward = 20000,
		nameofbank = "Fleeca Bank (Highway)",
		lastrobbed = 0
	},
	["blainecounty"] = {
		position = { x = -107.06505584717, y = 6474.8012695313, z = 31.62670135498 },
		reward = 20000,
		nameofbank = "Blaine County Savings",
		lastrobbed = 0
	}
}

local robbers = {}

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('e4530be0-0f13-4174-aeb0-8a68252eab44')
AddEventHandler('e4530be0-0f13-4174-aeb0-8a68252eab44', function(robb)
	if(robbers[source])then
		TriggerClientEvent('4ad70126-462d-4a21-8ba7-00eea4100ae3', source)
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery was cancelled at: ^2" .. banks[robb].nameofbank)
	end
end)

RegisterServerEvent('e687bd0d-46b5-48f2-8bd8-5c7f31deb2ae')
AddEventHandler('e687bd0d-46b5-48f2-8bd8-5c7f31deb2ae', function(robb)
	if banks[robb] then
		local bank = banks[robb]

		if (os.time() - bank.lastrobbed) < 600 and bank.lastrobbed ~= 0 then
			TriggerClientEvent('chatMessage', source, 'ROBBERY', {255, 0, 0}, "This has already been robbed recently. Please wait another: ^2" .. (1200 - (os.time() - bank.lastrobbed)) .. "^0 seconds.")
			return
		end
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery in progress at ^2" .. bank.nameofbank)
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "You started a robbery at: ^2" .. bank.nameofbank .. "^0, do not get too far away from this point!")
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "The Alarm has been triggered!")
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Hold the fort for ^15 ^0minutes and the money is yours!")
		TriggerClientEvent('ea4229ab-923a-4da0-b525-53298d777395', source, robb)
		banks[robb].lastrobbed = os.time()
		robbers[source] = robb
		local savedSource = source
		SetTimeout(300000, function()
			if(robbers[savedSource])then
				TriggerClientEvent('2f9eb93b-a404-44d4-b72d-80282ae3788e', savedSource, job)
				user_id = vRP.getUserId(source)
				vRP.giveMoney(user_id,bank.reward)
				TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery is over at: ^2" .. bank.nameofbank)
			end
		end)
	end
end)
