local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_drugNPC")

RegisterServerEvent('vRP_drugNPC:item')
AddEventHandler('vRP_drugNPC:item', function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if not vRP.tryGetInventoryItem({user_id,"weed",1,notify}) then
		TriggerClientEvent('done', player)
		TriggerClientEvent('cancel', player)
	else
		TriggerClientEvent('cancel', player)
	end
end)

RegisterServerEvent('vRP_drugNPC:money')
AddEventHandler('vRP_drugNPC:money', function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	local reward = math.random(150,300)
	vRP.giveMoney({user_id,reward})
end)

RegisterServerEvent('vRP_drugNPC:police_alert')
AddEventHandler('vRP_drugNPC:police_alert', function(x,y,z)
	vRP.sendServiceAlert({nil, "police",x,y,z,"Someone is offering me drugs."})
end)
