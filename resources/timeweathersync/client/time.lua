Time = {}
Time.h = 12
Time.m = 0
local freezeTime = false

RegisterNetEvent('updateTime')
AddEventHandler('updateTime', function(hours, minutes, freeze)
    freezeTime = freeze
    Time.h = hours
    Time.m = minutes
end)

Citizen.CreateThread(function()
    while true do
        if not freezeTime then
            Citizen.Wait(2000)
            NetworkOverrideClockTime(Time.h, Time.m, 0)
            Time.m = Time.m + 1
            if Time.m > 59 then
                Time.m = 0
                Time.h = Time.h + 1
                if Time.h > 23 then
                    Time.h = 0
                end
            end
        else
            Citizen.Wait(0)
            NetworkOverrideClockTime(Time.h, Time.m, 0)
        end
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('requestSync')
end)
