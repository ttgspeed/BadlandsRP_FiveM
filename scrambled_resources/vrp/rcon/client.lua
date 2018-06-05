RegisterNetEvent('a6dc9dc9-2fda-4eba-aa4c-b0b0ceeb2cac')

AddEventHandler('a6dc9dc9-2fda-4eba-aa4c-b0b0ceeb2cac', function()
    local names = {}

    for i = 0, cfg.max_players do
        if NetworkIsPlayerActive(i) then
            names[GetPlayerServerId(i)] = { id = i, name = GetPlayerName(i) }
        end
    end

    TriggerServerEvent('dc7718f9-6488-4ef1-bbee-e77d22ab0b1c', names)
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('1a1284bb-a5b6-44c3-a99c-eaa52484be7f')

			return
		end
	end
end)
