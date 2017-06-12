local Proxy = require("resources/vrp/lib/Proxy")
vRP = Proxy.getInterface("vRP")

local bankHeistInProgress = false
local heistParticipants = {}
local heistTimer = 300
local heistCooldown = false

--client events

RegisterServerEvent('heist:joinHeist')
AddEventHandler('heist:joinHeist',
	function()
		heistParticipants[source] = true
		TriggerClientEvent('heist:setWantedLevel',source)
		if not bankHeistInProgress then 
			bankHeistStarted()
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

RegisterServerEvent('heist:bankHeistCompleted')
AddEventHandler('heist:bankHeistCompleted',function()
	vRP.getUserId({source},function(user_id)
		if user_id ~= nil then 
			vRP.giveInventoryItem({user_id,"dirty_money",50000})
		end
		heistParticipants[source] = nil
		if next(heistParticipants) == nil then --last heist member has exited
			bankHeistInProgress = false
			TriggerClientEvent('heist:setStatus',-1,bankHeistInProgress)
			setCooldown()
		end
	end)
end)

--server functions

function bankHeistStarted()
	bankHeistInProgress = true
	TriggerClientEvent('heist:setStatus',-1,bankHeistInProgress)
	for k,v in pairs(heistParticipants) do 
		TriggerClientEvent('heist:stage1',k,heistTimer)
		heistStage1()
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
	setTimeout(60000,function()
		resetHeist()
	end)
end

function resetHeist()
	bankHeistInProgress = false
	heistParticipants = {}
	heistTimer = 300
	heistCooldown = false
end