Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(300000) -- Every X ms you'll get paid (300000 = 5 min)
		if not tvRP.isInComa() then
			TriggerServerEvent('vRP:salary')
		end
	end
end)