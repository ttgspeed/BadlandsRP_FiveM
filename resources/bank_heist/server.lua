local Proxy = require("resources/vrp/lib/Proxy")
local Tunnel = require("resources/vRP/lib/Tunnel")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","banking") -- server -> client tunnel


local bankHeistInProgress = false

RegisterServerEvent('heist:bankHeistStarted')
AddEventHandler('heist:bankHeistStarted',
	function()
		if not bankHeistInProgress then
			bankHeistInProgress = true
			TriggerClientEvent('heist:setStatus',-1,bankHeistInProgress)
			TriggerClientEvent('heist:setWantedLevel',source)
			TriggerClientEvent('heist:stage1',source)
		end
	end
)

RegisterServerEvent('heist:bankHeistEnd')
AddEventHandler('heist:bankHeistEnd',
	function()
		if bankHeistInProgress then
			bankHeistInProgress = false;
			TriggerClientEvent('heist:setStatus',-1,bankHeistInProgress)
		end
	end
)

RegisterServerEvent('heist:getBags')
AddEventHandler('heist:getBags',
	function()
		TriggerClientEvent("player:addItem", source, 11, 1)
	end
)

--bank heist payout
RegisterServerEvent('heist:payout')
AddEventHandler('heist:payout',function()
	vRP.getUserId({source},function(user_id)
		if user_id ~= nil then
			vRP.giveMoney({source,50000})
		end
	end)
end)