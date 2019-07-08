local Tunnel = module("vrp", "panopticon/sv_pano_tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","golf") -- server -> client tunnel
Tunnel.initiateProxy()

RegisterServerEvent('tryPayment')
AddEventHandler('tryPayment', function(price)
	local src = source
	local user_id = vRP.getUserId({src})
	if(vRP.tryPayment({user_id,price})) then
		TriggerClientEvent("beginGolf", src)
	end
end)
