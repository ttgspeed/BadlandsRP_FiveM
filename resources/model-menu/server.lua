RegisterServerEvent("mm:timer")
AddEventHandler("mm:timer", function()
    SetTimeout(10500, function()
    	TriggerClientEvent("mm:timerend", source)
    end)
end)

RegisterServerEvent("mm:timer2")
AddEventHandler("mm:timer2", function()
    SetTimeout(10500, function()
    	TriggerClientEvent("mm:timerend2", source)
    end)
end)
