Time = {}
Time.h = 12
Time.m = 0
local freezeTime = false


RegisterServerEvent('017cca6b-d475-4e18-8619-be01eeb30591')
AddEventHandler('017cca6b-d475-4e18-8619-be01eeb30591', function()
    TriggerClientEvent('fff94bff-7e1c-4b4d-b6fa-c6b0e6f9dfa8', -1, Time.h, Time.m, freezeTime)
end)

Citizen.CreateThread(function()
    local osTime = os.date("*t")
    if osTime ~= nil then
        Time.h = osTime.hour+1
    end
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
        TriggerClientEvent('fff94bff-7e1c-4b4d-b6fa-c6b0e6f9dfa8', -1, Time.h, Time.m, freezeTime)
    end
end)
