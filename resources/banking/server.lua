local Tunnel = module("vrp", "panopticon/sv_pano_tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","banking") -- server -> client tunnel
Tunnel.initiateProxy()
local lang = vRP.lang

local commands_enabled = true

local function bankBalance(player)
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		local amount = vRP.getBankMoney({user_id})
		TriggerClientEvent('banking:updateBalance',player, amount)
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

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
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

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
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

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(fromPlayer, toPlayer, amount)
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

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
		local bankamount = vRP.getBankMoney({user_id})
		TriggerClientEvent('banking:updateBalance',source, bankamount)
		local cashamount = vRP.getMoney({user_id})
		TriggerClientEvent('banking:updateCashBalance',source, cashamount)
	end
end)

if commands_enabled then
  AddEventHandler('chatMessage', function(from,name,message)
    if(string.sub(message,1,1) == "/") then
      local args = splitString(message)
      local cmd = args[1]
      local source = from
      if cmd == "/atm" then
				CancelEvent()
				TriggerClientEvent("bank:checkForAtmObject",source)
      end
    end
  end)
end
