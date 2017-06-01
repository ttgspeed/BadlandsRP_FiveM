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
AddEventHandler('heist:payout',
	function()
		TriggerEvent('es:getPlayerFromId', source, function(user)
			-- Adding money to the user
			local user_id = user.identifier
			user:addMoney(50000)
		end)
	end
)