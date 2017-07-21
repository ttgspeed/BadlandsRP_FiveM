--local Proxy = load(LoadResourceFile("vrp", "lib/Proxy"), "lib/Proxy")()
--local Tunnel = load(LoadResourceFile("vrp", "lib/Tunnel"), "lib/Tunnel")()
local Proxy = load(LoadResourceFile("vrp", "lib/Proxy"), "lib/Proxy")()
local Tunnel = load(LoadResourceFile("vrp", "lib/Tunnel"), "lib/Tunnel")()
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","bankHeist")

local bankHeistInProgress = false
local heistParticipants = {}
local bagCarriers = {}
local heistTimer = 300
local heistCooldown = false
local cooldownTimer = 10*60

--client events

RegisterServerEvent('heist:joinHeist')
AddEventHandler('heist:joinHeist',
	function()
		if not heistCooldown then
			heistParticipants[source] = true
			TriggerClientEvent('heist:setWantedLevel',source)
			if not bankHeistInProgress then
				bankHeistStarted()
			else
				TriggerClientEvent('heist:stage1',source,heistTimer)
			end
		else
			vRPclient.notify(source,{"Bank heist is on cooldown."})
		end
	end
)

RegisterServerEvent('heist:playerDied')
AddEventHandler('heist:playerDied',function()
	heistParticipants[source] = nil
	if next(heistParticipants) == nil then --last heist member has exited
		bankHeistInProgress = false
		TriggerClientEvent('heist:setStatus',-1,bankHeistInProgress)
		setCooldown()
	end
end)

RegisterServerEvent('playerDropped')
AddEventHandler('playerDropped', function()
    heistParticipants[source] = nil
	if next(heistParticipants) == nil then --last heist member has exited
		bankHeistInProgress = false
		TriggerClientEvent('heist:setStatus',-1,bankHeistInProgress)
		setCooldown()
	end
end)

RegisterServerEvent('heist:getBag')
AddEventHandler('heist:getBag',function()
	bagCarriers[source] = true
end)

RegisterServerEvent('heist:bankHeistCompleted')
AddEventHandler('heist:bankHeistCompleted',function()
	vRP.getUserId({source},function(user_id)
		if user_id ~= nil and bagCarriers[source] ~= nil then
			vRP.giveMoney({user_id,30000})
			--vRP.giveInventoryItem({user_id,"dirty_money",50000}) -- Temp change to cash until business start up is lower priced
		end
		heistParticipants[source] = nil
		bagCarriers[source] = nil
		if next(heistParticipants) == nil then --last heist member has exited
			bankHeistInProgress = false
			TriggerClientEvent('heist:setStatus',-1,bankHeistInProgress)
			setCooldown()
		end
	end)
end)

--server functions

function bankHeistStarted()
	if not heistCooldown then
		bankHeistInProgress = true
		TriggerClientEvent('heist:setStatus',-1,bankHeistInProgress)
		for k,v in pairs(heistParticipants) do
			TriggerClientEvent('heist:stage1',k,heistTimer)
			heistStage1()
		end
	end
end

function heistStage1()
	if heistTimer <= 0 then
		heistStage2()
	else
		heistTimer = heistTimer - 1
		SetTimeout(1000,heistStage1)
	end
end

function heistStage2()
	for k,v in pairs(heistParticipants) do
		TriggerClientEvent('heist:stage2',k)
	end
end


function setCooldown()
	heistCooldown = true
	cooldownTimer = cooldownTimer - 1
	if cooldownTimer < 0 then
		resetHeist()
	else
		SetTimeout(1000,setCooldown)
	end
end

function resetHeist()
	bankHeistInProgress = false
	heistParticipants = {}
	bagCarriers = {}
	heistTimer = 300
	heistCooldown = false
	cooldownTimer = 10*60
end
