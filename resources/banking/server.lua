local Proxy = require("resources/vrp/lib/Proxy")
local Tunnel = require("resources/vRP/lib/Tunnel")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","banking") -- server -> client tunnel
local lang = vRP.lang

local function bankBalance(player)
	vRP.getUserId({player},function(user_id)
		vRP.getBankMoney({user_id},function(amount)
			TriggerClientEvent('banking:updateBalance',player, amount)
		end)
	end)
end

local function play_atm_enter(player)
  vRPclient.playAnim(player,{false,{{"amb@prop_human_atm@male@enter","enter"},{"amb@prop_human_atm@male@idle_a","idle_a"}},false})
end

local function play_atm_exit(player)
  vRPclient.playAnim(player,{false,{{"amb@prop_human_atm@male@exit","exit"}},false})
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.abs(math.floor(num * mult + 0.5) / mult)
end

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
	play_atm_exit(source)
	amount = tonumber(amount)
	if amount > 0 then
		vRP.getUserId({source},function(user_id)
			if user_id ~= nil then
				vRP.tryDeposit({user_id,amount},function(valid)
					if valid then
					  vRPclient.notify(source,{lang.atm.deposit.deposited({amount})})
					else
					  vRPclient.notify(source,{lang.money.not_enough()})
					end
				end)
			end
		end)
	else
		vRPclient.notify(source,{lang.common.invalid_value()})
	end
	bankBalance(source)
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
	play_atm_exit(source)
	amount = tonumber(amount)
	if amount > 0 then
		vRP.getUserId({source},function(user_id)
			if user_id ~= nil then
				vRP.tryWithdraw({user_id,amount},function(valid)
					if valid then
					  vRPclient.notify(source,{lang.atm.withdraw.withdrawn({amount})})
					else
					  vRPclient.notify(source,{lang.atm.withdraw.not_enough()})
					end
				end)
			end
		end)
	else
		vRPclient.notify(source,{lang.common.invalid_value()})
	end
	bankBalance(source)
end)

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(fromPlayer, toPlayer, amount)
	--needs to be implemented
	vRPclient.notify(source,{"Wire transfer is not yet implemented. Come back later."})
end)

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
		vRP.getBankMoney({user_id},function(amount)
			TriggerClientEvent('banking:updateBalance',source, amount)
		end)
	end
end)