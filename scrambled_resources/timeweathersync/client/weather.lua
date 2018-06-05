-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.
-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.
-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.
-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.
-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.
-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.

-- Change Weather Type
function changeWeatherType(weatherType)
	ClearWeatherTypePersist() -- Ensure no persistant weather
	--SetOverrideWeather(type)
	SetWeatherTypeOverTime(weatherType, 60.00)
	if weatherType == 'XMAS' then
		SetForceVehicleTrails(true)
        SetForcePedFootstepsTracks(true)
	else
		SetForceVehicleTrails(false)
        SetForcePedFootstepsTracks(false)
	end
end


-- Update players wind
function updateWind(toggle,heading)
	if(toggle) then
		SetWind(1.0)
		SetWindSpeed(11.99);
		SetWindDirection(heading)
	else
		SetWind(0.0)
		SetWindSpeed(0.0);
	end
end



-- Sync weather with server settings.
RegisterNetEvent('5447709f-ac68-4cab-8365-aed98e153be4')
AddEventHandler('5447709f-ac68-4cab-8365-aed98e153be4', function(data)
	changeWeatherType(data["weatherString"])
	updateWind(data["windEnabled"],data["windHeading"])
end)


-- Sync on player connect
AddEventHandler('onClientMapStart', function()
	Citizen.Trace("Running V1.3 of SmartWeather created by TheStonedTurtle")
	TriggerServerEvent('69f6b495-73cf-4523-a167-61b137022966')
	Citizen.Trace("Synced Weather with server settings :)")
end)
