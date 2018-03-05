local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_drugNPC")

RegisterServerEvent('vRP_drugNPC:item')
AddEventHandler('vRP_drugNPC:item', function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if vRP.tryGetInventoryItem({user_id,"meth",1,false}) then
		TriggerClientEvent('cancel', player,"meth")
	elseif vRP.tryGetInventoryItem({user_id,"weed",1,false}) then
		TriggerClientEvent('cancel', player,"weed")
	else
		TriggerClientEvent('done', player)
		TriggerClientEvent('cancel', player, nil)
	end
end)

drugs = {
	["meth"] = {lowPrice = 200, highPrice = 250},
	["weed"] = {lowPrice = 100, highPrice = 150},
}

RegisterServerEvent('vRP_drugNPC:money')
AddEventHandler('vRP_drugNPC:money', function(drug)
	if drug ~= nil then
		local user_id = vRP.getUserId({source})
		local player = vRP.getUserSource({user_id})
		local reward = math.random(drugs[drug].lowPrice,drugs[drug].highPrice)
		vRP.giveMoney({user_id,reward})
		TriggerClientEvent("pNotify:SendNotification", source, {text = "Received $"..reward.." for selling "..drug , type = "success", layout = "centerLeft", queue = "global", theme = "gta", timeout = 5000})
	end
end)

