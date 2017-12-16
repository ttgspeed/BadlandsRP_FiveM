Time = {}
Time.h = 12
Time.m = 0
local freezeTime = false


RegisterServerEvent('requestSync')
AddEventHandler('requestSync', function()
    TriggerClientEvent('updateTime', -1, Time.h, Time.m, freezeTime)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
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
        Citizen.Wait(5000)
        TriggerClientEvent('updateTime', -1, Time.h, Time.m, freezeTime)
    end
end)
