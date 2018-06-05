local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_taxiJob")

RegisterServerEvent('633d5179-6707-42cd-9972-54d00439522e') -- calls the event from client file
AddEventHandler('633d5179-6707-42cd-9972-54d00439522e', function(amount) -- handles the event
    local user_id = vRP.getUserId({source})
	  local player = vRP.getUserSource({user_id})
    vRP.giveMoney({user_id,amount})
    vRPclient.notify(player,{"You've received $"..amount.." for completing your task."})
end)
