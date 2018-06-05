Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(300000) -- Every X ms you'll get paid (300000 = 5 min)
		if not tvRP.isInComa() and not tvRP.isInPrison() and not tvRP.isJailed() then
			TriggerServerEvent('06c955ea-60c5-474b-afc7-ae4826974137')
		end
	end
end)
