AddEventHandler('onClientMapStart', function()
	NetworkSetTalkerProximity(0.0)
end)

RegisterNetEvent('setInitialVoice')
AddEventHandler('setInitialVoice', function()
	Citizen.Trace("Initial Voice Setting")
	NetworkSetTalkerProximity(0.0)
end)
