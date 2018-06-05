-- VOIP script by Asser90

--local voip_state = false
local voip_state = "Normal"
local normal = false
local whisper = true
local yell = false

local voip = {}
voip['default'] = {name = 'default', setting = 20.0}
voip['local'] = {name = 'local', setting = 10.0}
voip['whisper'] = {name = 'whisper', setting = 5.0}
voip['yell'] = {name = 'yell', setting = 35.0}

AddEventHandler('onClientMapStart', function()
	NetworkSetTalkerProximity(voip['default'].setting)
end)

RegisterNetEvent('162bcd03-2975-476a-aa2a-cddf9a80aad8')
AddEventHandler('162bcd03-2975-476a-aa2a-cddf9a80aad8', function()
	Citizen.Trace("Initial Voice Setting")
	NetworkSetTalkerProximity(voip['default'].setting)
end)

RegisterNetEvent('ba8fe12d-acc7-44e4-9c7d-03a5416c82fc')
AddEventHandler('ba8fe12d-acc7-44e4-9c7d-03a5416c82fc', function()

	--[[
	if voip_state then
		distanceName = voip['default'].name
		distanceSetting = voip['default'].setting
		voip_state = false
	else
		distanceName = voip['whisper'].name
		distanceSetting = voip['whisper'].setting
		voip_state = true
	end
	]]--

	if normal then
		distanceName = voip['default'].name
		distanceSetting = voip['default'].setting
		normal = false
		whisper = true
		yell = false
		voip_state = "Normal"
	elseif whisper then
		distanceName = voip['whisper'].name
		distanceSetting = voip['whisper'].setting
		normal = false
		whisper = false
		yell = true
		voip_state = "Whisper"
	elseif yell then
		distanceName = voip['yell'].name
		distanceSetting = voip['yell'].setting
		normal = true
		whisper = false
		yell = false
		voip_state = "Yell"
	end
	tvRP.setVoiceProximityLbl(voip_state or "Normal")

	NetworkSetTalkerProximity(distanceSetting)

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(1, 243) then --Start holding X
			TriggerEvent('ba8fe12d-acc7-44e4-9c7d-03a5416c82fc', source)
		end
	end
end)

function tvRP.isWhispering()
	return voip_state
end
