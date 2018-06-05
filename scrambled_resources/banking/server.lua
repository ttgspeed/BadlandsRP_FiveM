local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","banking") -- server -> client tunnel
local lang = vRP.lang

local function bankBalance(player)
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		local amount = vRP.getBankMoney({user_id})
		TriggerClientEvent('cef14c1a-ee85-4873-9437-5f062c94d38c',player, amount)
	end
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

function parseInt(v)
--  return cast(int,tonumber(v))
  local n = tonumber(v)
  if n == nil then
    return 0
  else
    return math.floor(n)
  end
end

RegisterServerEvent('069d6dd5-7a37-4996-bf8d-60d3cd5aa863')
AddEventHandler('069d6dd5-7a37-4996-bf8d-60d3cd5aa863', function(amount)
	play_atm_exit(source)
	amount = parseInt(amount)
	if amount > 0 then
		local user_id = vRP.getUserId({source})
		if user_id ~= nil then
			local valid = vRP.tryDeposit({user_id,amount})
			if valid then
			  vRPclient.notify(source,{"$" .. amount .. " deposited."})
			else
			  vRPclient.notify(source,{"~r~You don't have enough money in your bank account."})
			end
		end
	else
		vRPclient.notify(source,{"Please enter a valid amount."})
	end
	bankBalance(source)
end)

RegisterServerEvent('7461da52-aaea-423c-923b-09da29880b99')
AddEventHandler('7461da52-aaea-423c-923b-09da29880b99', function(amount)
	play_atm_exit(source)
	amount = parseInt(amount)
	if amount > 0 then
		local user_id = vRP.getUserId({source})
		if user_id ~= nil then
			local valid = vRP.tryWithdraw({user_id,amount})
			if valid then
				vRPclient.notify(source,{"$" .. amount .. " withdrawn."})
			else
				vRPclient.notify(source,{"~r~You don't have enough money in your bank account."})
			end
		end
	else
		vRPclient.notify(source,{"Invalid value"})
	end
	bankBalance(source)
end)

RegisterServerEvent('69a1f1b4-6d89-45f8-a85c-1a43356841f6')
AddEventHandler('69a1f1b4-6d89-45f8-a85c-1a43356841f6', function(fromPlayer, toPlayer, amount)
	--[[
	targetPlayer = GetPlayerFromServerId(toPlayer)
	vRP.getUserId({source},function(user_id)
		--take money from source user
		vRP.tryPayment({user_id,amount},function(valid)
			if valid then
				--give money to target
				vRP.getUserId({targetPlayer},function(targetID)
					vRP.giveBankMoney({targetID,amount})
				end)
				vRPclient.notify(targetPlayer,{"You have been wired $" .. amount .. " from player:" .. fromPlayer})
				vRPclient.notify(source,{"Wired $" .. amount .. " to player:" .. toPlayer})
			else
				vRPclient.notify(source,{"You do not have enough money."})
			end
		end)
	end)
	]]--
	vRPclient.notify(source,{"Wire transfer is not yet implemented. Come back later."})
end)

AddEventHandler('bb28a4b4-e680-4f5e-9c58-9d0ef716da70',function(user_id,source,first_spawn)
	if first_spawn then
		local bankamount = vRP.getBankMoney({user_id})
		TriggerClientEvent('cef14c1a-ee85-4873-9437-5f062c94d38c',source, bankamount)
		local cashamount = vRP.getMoney({user_id})
		TriggerClientEvent('37059c50-9b00-4e5c-b7f7-3d8bd8ee1e76',source, cashamount)
	end
end)
