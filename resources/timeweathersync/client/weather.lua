vRPtimeweather = {}
Tunnel.bindInterface("timeweathersync",vRPtimeweather)
Proxy.addInterface("timeweathersync",vRPtimeweather)

-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.
-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.
-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.
-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.
-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.
-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.

local isUnderMapArea = false

function vRPtimeweather.setIsUnderMapArea(toggle)
	isUnderMapArea = toggle
	if isUnderMapArea then
		changeWeatherType("CLEAR", true)
	else
		TriggerServerEvent('smartweather:syncWeather')
	end
end

-- Change Weather Type
function changeWeatherType(weatherType, instant)
	ClearWeatherTypePersist() -- Ensure no persistant weather
	if instant ~= nil and instant then
		SetWeatherTypeOverTime(weatherType,0.01)
	else
		SetWeatherTypeOverTime(weatherType, 60.00)
	end
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
RegisterNetEvent('smartweather:updateWeather')
AddEventHandler('smartweather:updateWeather', function(data)
	if not isUnderMapArea then
		changeWeatherType(data["weatherString"], false)
		updateWind(data["windEnabled"],data["windHeading"])
	end
end)
