local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Lang = module("vrp", "lib/Lang")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_basic_mission")

local player_bets = {}
local player_balances = {}

RegisterServerEvent('a9cccde6-2737-4c20-b000-c579a05f23c3')
AddEventHandler('a9cccde6-2737-4c20-b000-c579a05f23c3', function()
	vRP.prompt({source,"Enter your buy in amount","1000",function(source,amount)
		local amount = parseInt(amount)
		local user_id = vRP.getUserId({source})
		if amount >= 1000 and amount <= 10000 then
			if vRP.tryPayment({user_id,amount}) then
				player_balances[user_id] = amount
				TriggerClientEvent('de44d9e7-ecc5-4ce0-9fdb-e5351f2d3d04',source, amount)
			else
				vRPclient.notify(source,{"You do not have enough cash."})
			end
		else
			vRPclient.notify(source,{"This table only accepts buy ins between $1,000-$10,000"})
		end
	end})
end)

RegisterServerEvent('9dcb53ce-729c-4f77-b454-73f749b192cd')
AddEventHandler('9dcb53ce-729c-4f77-b454-73f749b192cd', function(amount)
	local user_id = vRP.getUserId({source})
	if(amount <= player_balances[user_id]) then
		player_bets[user_id] = amount
		player_balances[user_id] = player_balances[user_id] - amount
		print(user_id.." bet: "..player_bets[user_id])
	else
		--anticheat logging
	end
end)

RegisterServerEvent('5aedcdc0-f23d-4d3c-a4d7-87416d3c40b1')
AddEventHandler('5aedcdc0-f23d-4d3c-a4d7-87416d3c40b1', function(amount)
	local user_id = vRP.getUserId({source})
	local winnings = math.floor(player_bets[user_id]*amount)
	player_balances[user_id] = player_balances[user_id] + winnings
	print(user_id.." bet: "..player_bets[user_id])
	print(user_id.." won: "..winnings)
	print(user_id.." balance: "..player_balances[user_id])
	player_bets[user_id] = 0
end)

RegisterServerEvent('245c7305-7cd2-4383-97ce-83d3a4516dd3')
AddEventHandler('245c7305-7cd2-4383-97ce-83d3a4516dd3', function()
	local user_id = vRP.getUserId({source})
	print(user_id)
	print(player_balances[user_id])
	vRP.giveMoney({user_id, player_balances[user_id]})
	print("Cashing out "..user_id.." with "..player_balances[user_id])
	player_balances[user_id] = 0
end)
