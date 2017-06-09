-- VOIP script by Asser90

local voip_state = false

local voip = {}
voip['default'] = {name = 'default', setting = 15.0}
voip['local'] = {name = 'local', setting = 10.0}
voip['whisper'] = {name = 'whisper', setting = 2.0}
voip['yell'] = {name = 'yell', setting = 25.0}

AddEventHandler('onClientMapStart', function()
	NetworkSetTalkerProximity(voip['default'].setting)
end)

RegisterNetEvent('pv:voip')
AddEventHandler('pv:voip', function()

	if voip_state then
		distanceName = voip['default'].name
		distanceSetting = voip['default'].setting
		voip_state = false
	else
		distanceName = voip['whisper'].name
		distanceSetting = voip['whisper'].setting
		voip_state = true
	end

	--NotificationMessage("Your VOIP is now ~b~" .. distanceName ..".")
	tvRP.notify("Your VOIP is now ~b~" .. distanceName ..".")
	NetworkSetTalkerProximity(distanceSetting)

end)

function NotificationMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(1, 243) then --Start holding X
			TriggerEvent("pv:voip", source)
		end
	end
end)