Time = {}
Time.h = 12
Time.m = 0
local freezeTime = false


RegisterServerEvent('requestSync')
AddEventHandler('requestSync', function()
    TriggerClientEvent('updateTime', -1, Time.h, Time.m, freezeTime)
end)

-- Set server time (hour)
RegisterServerEvent("smartweather:setTime")
AddEventHandler("smartweather:setTime",function(from, time)
	Time.h = time
	TriggerClientEvent('updateTime', -1, Time.h, Time.m, freezeTime)
  TriggerClientEvent('sendPlayerMesage', -1, from, {
      template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-question-circle"></i> {0}</div>',
      args = { "SmartWeather - Time set to hour "..time}
  })
end)

Citizen.CreateThread(function()
    local osTime = os.date("*t")
    if osTime ~= nil then
        Time.h = osTime.hour+1
    end
    while true do
        Citizen.Wait(4000)
        if not freezeTime then
            Time.m = Time.m + 1
            if Time.m > 59 then
                Time.m = 0
                Time.h = Time.h + 1
                if Time.h > 23 then
                    Time.h = 0
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(8000)
        TriggerClientEvent('updateTime', -1, Time.h, Time.m, freezeTime)
    end
end)
