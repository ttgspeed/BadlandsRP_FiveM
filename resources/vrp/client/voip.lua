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

RegisterNetEvent('pv:voip')
AddEventHandler('pv:voip', function()

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
		voip_state = "Whispering"
	elseif yell then
		distanceName = voip['yell'].name
		distanceSetting = voip['yell'].setting
		normal = true
		whisper = false
		yell = false
		voip_state = "Yelling"
	end

	tvRP.notify("Your voice volume is now " .. distanceName ..".")
	NetworkSetTalkerProximity(distanceSetting)

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(1, 243) then --Start holding X
			TriggerEvent("pv:voip", source)
		end
	end
end)

function tvRP.isWhispering()
	return voip_state
end
