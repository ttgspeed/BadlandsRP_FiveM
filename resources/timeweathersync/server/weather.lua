secondsToWait = 1800              -- Seconds to wait between changing weather. 60 seconds to fully switch types
currentWeatherString = "XMAS"   -- Starting Weather Type.
local SmartWeatherEnabled = true -- Should this script be enabled?
local adminOnlyPlugin = true     -- Should chat commands be limited to the `admins` list?
-- Add STEAM ids here in below format to allow these people to toggle and change the weather
local admins = {
	"steam:11000010198b032", --Serpico
    "steam:11000010268849f", --speed
    "license:9dab3e051388782b38e3032a6c8b29f3945fb32c", --Serpico
    "license:1b979f4a93a0e21fd39c8f7d20d892a11ec5feb7", --speed

    -- Temp access
    "steam:11000010264f83b", --Tiller
    "steam:1100001014f881e", --Bob Lee
		"steam:11000010a2cf14a", -- Daniel Morningstart
}


-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.
-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.
-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.
-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.
-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.
-- DO NOT TOUCH BELOW UNLESS YOU KNOW WHAT YOU ARE DOING. CONTACT TheStonedTurtle IF ANYTHING IS BROKEN.


-- Removed Neutral from possible weather options, had issue with it sometimes turning the sky green.
-- Removed XMAS from possible weather option as it blankets entire map with snow.
weatherTree = {
	--["EXTRASUNNY"] = {"CLEAR","SMOG","XMAS"},
	--["SMOG"] = {"CLEAR","CLEARING","OVERCAST","CLOUDS","EXTRASUNNY","XMAS"},
	["CLEAR"] = {"XMAS"},
	--["CLOUDS"] = {"CLEAR","SMOG","CLEARING","OVERCAST","XMAS"},
	--["FOGGY"] = {"CLEAR","CLOUDS","SMOG","OVERCAST"},
	--["OVERCAST"] = {"CLEAR","CLOUDS","SMOG","RAIN","CLEARING"},
	--["RAIN"] = {"CLEARING","OVERCAST"},
	--["THUNDER"] = {"RAIN","CLEARING"},
	--["CLEARING"] = {"CLEAR","CLOUDS","OVERCAST","SMOG","RAIN","XMAS"},
	--["THUNDER"] = {"CLOUDS","EXTRASUNNY","CLEARING","SMOG","OVERCAST","CLEAR","CLOUDS"},
	--["BLIZZARD"] = {"SNOW","SNOWLIGHT","THUNDER"},
	["XMAS"] = {"XMAS"},
	--["HALLOWEEN"] = {"HALLOWEEN","RAIN","CLEARING"},
}


windWeathers = {
	["OVERCAST"] = true,
	["RAIN"] = true,
	["HALLOWEEN"] = true,
	--["THUNDER"] = true,
	--["BLIZZARD"] = true,
	["XMAS"] = true,
	--["SNOW"] = true,
	["CLOUDS"] = true
}
local resetFlag = false


function getTableLength(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

function getTableKeys(T)
	local keys = {}
	for k,v in pairs(T) do
		table.insert(keys,k)
	end
	return keys
end

function stringsplit(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t,str)
    end
    return t
end

function isAdmin(identifier)
	local adminList = {}
	for _,v in pairs(admins) do
		adminList[v] = true
	end
	--identifier = string.lower(identifier)
	--identifier2 = string.upper(identifier)

	if(adminList[identifier] or adminList[identifier2])then
		return true
	else
		return false
	end
end

function getIdentifier( source, identifier )
    local ids = GetPlayerIdentifiers( source )

    for k, v in pairs( ids ) do
        if(string.find(v, identifier..":"))then
            return v
        end
    end

    return nil
end



currentWeatherData = {
	["weatherString"] = currentWeatherString,
	["windEnabled"] = false,
	["windHeading"] = 0
}

lastRainTime = 0
lastSnowTime = 0

function updateWeatherString()
	local newWeatherString
	local windEnabled = false
	local windHeading = 0
	-- Lua random requires an updated randomseed to ensure randomnees between same range values.
	math.randomseed(GetGameTimer())

	local count = getTableLength(weatherTree)
	local tableKeys = getTableKeys(weatherTree)

	if(currentWeatherData["weatherString"] == nil)then
		newWeatherString = tableKeys[math.random(1,count)]
	else
		local currentOptions = weatherTree[currentWeatherData["weatherString"]]
		newWeatherString = currentOptions[math.random(1,getTableLength(currentOptions))]
	end

	if newWeatherString == "RAIN" or newWeatherString == "THUNDER" or newWeatherString == "CLEARING" or newWeatherString == "OVERCAST" then
		if lastRainTime ~= 0 and ((os.time() - lastRainTime) < 60*60) then
			newWeatherString = "CLEAR"
		else
			lastRainTime = os.time()
		end
	end
	--[[
	if newWeatherString == "XMAS" then
		if lastSnowTime ~= 0 and ((os.time() - lastSnowTime) < 60*60) then
			newWeatherString = "CLEAR"
		else
			lastSnowTime = os.time()
		end
	end
	]]--
	-- 50/50 Chance to enabled wind at a random heading for the specified weathers.
	if(windWeathers[newWeatherString] and (math.random(0,1) == 1))then
		windEnabled = true
		windHeading = math.random(0,360)
	end

	currentWeatherData = {
		["weatherString"] = newWeatherString,
		["windEnabled"] = windEnabled,
		["windHeading"] = windHeading
	}

	print("Updating Weather to "..newWeatherString.." for all players.")
	TriggerClientEvent("smartweather:updateWeather", -1, currentWeatherData)
end

-- Sync Weather once player joins.
RegisterServerEvent("smartweather:syncWeather")
AddEventHandler("smartweather:syncWeather",function()
	print("Syncing weather for: "..GetPlayerName(source))
	TriggerClientEvent("smartweather:updateWeather", source, currentWeatherData)
end)

AddEventHandler("vRP:playerJoin",function(user_id, source, name, last_login)
	print("Syncing weather for: "..GetPlayerName(source))
	TriggerClientEvent("smartweather:updateWeather", source, currentWeatherData)
end)

-- Toggle if weather should auto change.
RegisterServerEvent("smartweather:toggleWeather")
AddEventHandler("smartweather:toggleWeather",function(from)
	local by = GetPlayerName(from) or ""
	local text = "^1disabled^7"

	SmartWeatherEnabled = not SmartWeatherEnabled
	if(SmartWeatherEnabled)then
		text = "^2enabled^7"
	end

	local message = "SmartWeather has been "..text.." by ^5"..by
	TriggerClientEvent("chatMessage", -1, "SmartWeather",{0,0,0},message)
end)

function handleAdminCheck(from)
	if( adminOnlyPlugin and (not (isAdmin(getIdentifier(from, "steam"))) and not (isAdmin(getIdentifier(from, "license"))))) then
		TriggerClientEvent('chatMessage', from, "SmartWeather", {200,0,0} , "You must be an admin to use this command.")
		return false
	end
	return true
end

-- Example of how to toggle weather. Added basic chat command.
AddEventHandler('chatMessage', function(from,name,message)
	if(string.sub(message,1,1) == "/") then

		local args = stringsplit(message)
		local cmd = args[1]

		if(cmd == "/toggleweather")then
			CancelEvent()
			if( not handleAdminCheck(from) )then
				return
			end

			TriggerEvent("smartweather:toggleWeather", from)
		end

		if(cmd == "/setweather")then
			CancelEvent()
			if( not handleAdminCheck(from) )then
				return
			end

			local wtype = string.upper(tostring(args[2]))
			if(wtype == nil)then
				TriggerClientEvent('chatMessage', from, "SmartWeather", {200,0,0} , "Usage: /setweather CLEAR")
				return
			end

			if(weatherTree[wtype] == nil)then
				TriggerClientEvent('chatMessage', from, "SmartWeather", {200,0,0} , "Invalid weather type, valid weather types below")
				TriggerClientEvent('chatMessage', from, "", {255,255,255} , table.concat(getTableKeys(weatherTree)," "))
				return
			end
			currentWeatherData["weatherString"] = wtype
			resetFlag = true
			TriggerClientEvent("smartweather:updateWeather", -1, currentWeatherData) -- Sync weather for all players
			--TriggerClientEvent("chatMessage", -1, "SmartWeather", {200,0,0}, name.." has updated the weather to: "..wtype) -- Ingame
		end

		if(cmd == "/settime")then
			CancelEvent()
			if( not handleAdminCheck(from) )then
				return
			end

			local time = tonumber(args[2])
			if(time == nil)then
				TriggerClientEvent('chatMessage', from, "SmartWeather", {200,0,0} , "Usage: /settime HOUR (0-23)")
				return
			end

			if time < 0 or time > 23 then
				TriggerClientEvent('chatMessage', from, "SmartWeather", {200,0,0} , "Usage: /settime 0-23")
				return
			end

			TriggerEvent("smartweather:setTime", from, time)
		end
	end

end)

function weatherCheck()
	for i=0,secondsToWait,1 do
		if(resetFlag)then
			resetFlag = false
			weatherCheck() -- Start the wait cycle again
			return
		else
			Wait(1000)
		end
	end

	if(SmartWeatherEnabled)then
		updateWeatherString()
	else
		print("SmartWeather is currently disabled")
	end

	weatherCheck() -- Start wait cycle again
end

CreateThread(function()
	weatherCheck()
end)
