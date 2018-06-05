Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NetworkIsSessionStarted() then
			TriggerServerEvent('3f500ff3-80b4-409f-ab44-174db5da4411')
			return
		end
	end
end)
