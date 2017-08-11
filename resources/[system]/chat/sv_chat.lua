local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then
        return
    end

    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        TriggerEvent('chatMessage', source, author, message, user_id)

        if not WasEventCanceled() then
            TriggerClientEvent('chatMessage', -1, author,  { 255, 255, 255 }, message)
        end

        print("-- CHAT LOG -- ("..user_id..") "..author .. ': ' .. message)
    else
        CancelEvent()
    end
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, '/' .. command)
    end

    CancelEvent()
end)

-- player join messages
AddEventHandler('playerConnecting', function()
    TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^2* ' .. GetPlayerName(source) .. ' joined.')
end)

AddEventHandler('playerDropped', function(reason)
    TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^2* ' .. GetPlayerName(source) ..' left (' .. reason .. ')')
end)

RegisterCommand('say', function(source, args, rawCommand)
    TriggerClientEvent('chatMessage', -1, (source == 0) and 'console' or GetPlayerName(source), { 255, 255, 255 }, rawCommand:sub(5))
end)

AddEventHandler('chatMessage', function(source, name, message, user_id)
    if string.sub(message,1,string.len("/"))=="/" then
        local commandEnd = string.find(message,"%s")
        local msg = string.sub(message,commandEnd+1)
        local cmd = string.sub(message,2,commandEnd-1)
        cmd = string.lower(cmd)
        if cmd == "ooc" or cmd == "g" then
            TriggerClientEvent('chatMessage', -1, "^1[^0OOC", {100, 100, 100}, "^4 " .. name.. " ^4(^0"..user_id.."^4): ^0" .. msg .. "^1]")
        elseif cmd == "tweet" then
            TriggerClientEvent('chatMessage', -1, "^5Twitter", {100, 100, 100}, "^4 @" ..name.. " ^4(^0"..user_id.."^4): ^0" .. msg)
        elseif cmd == "help" or cmd == "h" then
            TriggerClientEvent('sendPlayerMesage',-1, source, name.."("..user_id..")", "^1Common controls: ^0M = Open menu ^1|| ^0X = Toggle hands up/down ^1|| ^0~ = Toggle your voice volume ^1|| ^0L = Toggle car door locks ^1|| ^0/ooc = For out of character chat")
        else
            TriggerClientEvent('sendPlayerMesage',-1, source, name.."("..user_id..")", "Invalid command")
        end
    else
        TriggerClientEvent("sendProximityMessage", -1, source, name.."("..user_id..")", message)
    end
    CancelEvent()
end)
