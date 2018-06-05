local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Lang = module("vrp", "lib/Lang")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_basic_mission")

local player_bets = {}
local player_balances = {}

RegisterServerEvent('casino:buyin')
AddEventHandler('casino:buyin', function()
	vRP.prompt({source,"Enter your buy in amount","1000",function(source,amount)
		local amount = parseInt(amount)
		local user_id = vRP.getUserId({source})
		if amount >= 1000 and amount <= 10000 then
			if vRP.tryPayment({user_id,amount}) then
				player_balances[user_id] = amount
				TriggerClientEvent('casino:buyin.cb',source, amount)
			else
				vRPclient.notify(source,{"You do not have enough cash."})
			end
		else
			vRPclient.notify(source,{"This table only accepts buy ins between $1,000-$10,000"})
		end
	end})
end)

RegisterServerEvent('casino:makeBet')
AddEventHandler('casino:makeBet', function(amount)
	local user_id = vRP.getUserId({source})
	if(amount <= player_balances[user_id]) then
		player_bets[user_id] = amount
		player_balances[user_id] = player_balances[user_id] - amount
		print(user_id.." bet: "..player_bets[user_id])
	else
		--anticheat logging
	end
end)

RegisterServerEvent('casino:resolveBet')
AddEventHandler('casino:resolveBet', function(amount)
	local user_id = vRP.getUserId({source})
	local winnings = math.floor(player_bets[user_id]*amount)
	player_balances[user_id] = player_balances[user_id] + winnings
	print(user_id.." bet: "..player_bets[user_id])
	print(user_id.." won: "..winnings)
	print(user_id.." balance: "..player_balances[user_id])
	player_bets[user_id] = 0
end)

RegisterServerEvent('casino:cashOut')
AddEventHandler('casino:cashOut', function()
	local user_id = vRP.getUserId({source})
	print(user_id)
	print(player_balances[user_id])
	vRP.giveMoney({user_id, player_balances[user_id]})
	print("Cashing out "..user_id.." with "..player_balances[user_id])
	player_balances[user_id] = 0
end)
