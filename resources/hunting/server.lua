local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_taxiJob")

RegisterServerEvent('taxiJob:success') -- calls the event from client file
AddEventHandler('taxiJob:success', function(amount) -- handles the event
    local user_id = vRP.getUserId({source})
	  local player = vRP.getUserSource({user_id})
    vRP.giveMoney({user_id,amount})
    vRPclient.notify(player,{"You've received $"..amount.." for completing your task."})
end)

-- player spawn
RegisterServerEvent('hunting:start') -- calls the event from client file
AddEventHandler("hunting:start", function(animal)
  --vRP.addUserGroup(user_id,"user")
  --vRP.addUserGroup(user_id,"citizen")
  vRPclient.setJobLabel(source,{'Hunting '..animal})
end)
