local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","golf") -- server -> client tunnel

RegisterServerEvent('bdd2e3d7-6c40-4428-a26a-0396215f635f')
AddEventHandler('bdd2e3d7-6c40-4428-a26a-0396215f635f', function(price)
	local src = source
	local user_id = vRP.getUserId({src})
	if(vRP.tryPayment({user_id,price})) then
		TriggerClientEvent('c3639cc6-073a-4d02-8aec-d6fd1ad95e5f', src)
	end
end)
