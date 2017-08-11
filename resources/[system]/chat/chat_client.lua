local chatInputActive = false
local chatInputActivating = false
local vrpUserID = 0
local vrpName = nil
local tweet_timeout_remaining = 0

RegisterNetEvent('chat:playerInfo')
AddEventHandler('chat:playerInfo', function(id, name)
    vrpUserID = id
    vrpName = name
end)

RegisterNetEvent('chatMessage')

AddEventHandler('chatMessage', function(name, color, message)
    SendNUIMessage({
        name = name,
        color = color,
        message = message
    })
end)

RegisterNUICallback('chatResult', function(data, cb)
    chatInputActive = false

    SetNuiFocus(false)

    if data.message and string.len(data.message) > 0 then
        local id = PlayerId()

        --local r, g, b = GetPlayerRgbColour(id, _i, _i, _i)
        local r, g, b = 0, 0x99, 255

        if string.sub(data.message,1,string.len("/"))=="/" then
            local commandEnd = string.find(data.message,"%s")
            if commandEnd then
                local msg = string.sub(data.message,commandEnd+1)
                local cmd = string.sub(data.message,2,commandEnd-1)
                cmd = string.lower(cmd)
                if cmd == "tweet" then
                    if tweet_timeout_remaining < 1 then
                        tweet_timeout_remaining = 120
                        TriggerServerEvent('chatMessageEntered', GetPlayerName(id), { r, g, b }, data.message, vrpName, vrpUserID)
                    else
                        TriggerEvent('chatMessage', GetPlayerName(id), {255, 255, 0}, "You tweeted recently and must wait 2 minutes to send another.")
                    end
                else
                    TriggerServerEvent('chatMessageEntered', GetPlayerName(id), { r, g, b }, data.message, vrpName, vrpUserID)
                end
            end
        else
            TriggerServerEvent('chatMessageEntered', GetPlayerName(id), { r, g, b }, data.message, vrpName, vrpUserID)
        end
    end

    cb('ok')
end)

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, name, message)
    local monid = PlayerId()
    local sonid = GetPlayerFromServerId(id)
    if sonid == monid then
        TriggerEvent('chatMessage', name, {0, 255, 0}, message)
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(monid)), GetEntityCoords(GetPlayerPed(sonid)), true) < 50 then
        TriggerEvent('chatMessage', name, {0, 255, 0}, message)
    end
end)

RegisterNetEvent('sendPlayerMesage')
AddEventHandler('sendPlayerMesage', function(id, name, message)
    local monid = PlayerId()
    local sonid = GetPlayerFromServerId(id)
    if sonid == monid then
        TriggerEvent('chatMessage', name, {255, 255, 0}, message)
    end
end)

Citizen.CreateThread(function()
    SetTextChatEnabled(false)

    while true do
        Wait(0)

        if not chatInputActive then
            if IsControlPressed(0, 245) --[[ INPUT_MP_TEXT_CHAT_ALL ]] then
                chatInputActive = true
                chatInputActivating = true

                SendNUIMessage({
                    meta = 'openChatBox'
                })
            end
        end

        if chatInputActivating then
            if not IsControlPressed(0, 245) then
                SetNuiFocus(true)

                chatInputActivating = false
            end
        end
    end
end)



Citizen.CreateThread(function() -- coma decrease thread
    while true do
        Citizen.Wait(1000)
        if tweet_timeout_remaining > 0 then
            tweet_timeout_remaining = tweet_timeout_remaining-1
        end
    end
end)
