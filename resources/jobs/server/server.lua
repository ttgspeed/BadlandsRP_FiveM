local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Log = module("vrp", "lib/Log")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","jobs")
vRPjs = {}
Tunnel.bindInterface("jobs",vRPjs)
Proxy.addInterface("jobs",vRPjs)

function vRPjs.taxiJobSuccess(amount)
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
  	  local player = vRP.getUserSource({user_id})
      vRP.giveMoney({user_id,amount})
      vRPclient.notify(player,{"You've received $"..amount.." for completing your task."})
      Log.write(user_id,"Recieved $"..amount.." for completing taxi mission.",Log.log_type.action)
    end
end

function vRPjs.emsJobSuccess(amount)
    local user_id = vRP.getUserId({source})
	  local player = vRP.getUserSource({user_id})
    vRP.giveMoney({user_id,amount})
    vRPclient.notify(player,{"You've received $"..amount.." for completing your task."})
    Log.write(user_id,"Recieved $"..amount.." for completing ems mission.",Log.log_type.action)
end

function vRPjs.truckerJobSuccess(amount)
    local user_id = vRP.getUserId({source})
	  local player = vRP.getUserSource({user_id})

		if(amount > 10000) then
			amount = 10000
		end

    vRP.giveMoney({user_id,amount})
    vRPclient.notify(player,{"You've received $"..amount.." for completing your delivery."})
    Log.write(user_id,"Recieved $"..amount.." for completing trucker mission.",Log.log_type.action)
end
