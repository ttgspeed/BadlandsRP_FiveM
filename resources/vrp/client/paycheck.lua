Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(300000) -- Every X ms you'll get paid (300000 = 5 min)
		if not tvRP.isInComa() and not tvRP.isInPrison() and not tvRP.isJailed() then
			TriggerServerEvent('vRP:salary')
		end
	end
end)
