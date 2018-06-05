local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_truckerJob")

RegisterServerEvent('a1dc3462-d40c-419c-bc67-97953231014b') -- calls the event from client file
AddEventHandler('a1dc3462-d40c-419c-bc67-97953231014b', function(amount) -- handles the event
    local user_id = vRP.getUserId({source})
	  local player = vRP.getUserSource({user_id})
    vRP.giveMoney({user_id,amount})
    vRPclient.notify(player,{"You've received $"..amount.." for completing your delivery."})
end)
