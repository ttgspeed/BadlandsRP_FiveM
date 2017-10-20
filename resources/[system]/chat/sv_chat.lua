RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

function sendToDiscord(name, message)
    local discordUrl = GetConvar('discord_url_string')
    if discordUrl ~= nil and discordUrl ~= "" then
        PerformHttpRequest(discordUrl, function(err, text, headers) end, 'POST', json.encode({username = name, content = message}), { ['Content-Type'] = 'application/json' })
    end
end


AddEventHandler('_chat:messageEntered', function(author, color, message, rp_name, user_id)
    if not message or not author then
        return
    end

    if user_id ~= nil then
        TriggerEvent('chatMessage', source, author, message, rp_name, user_id)

        if not WasEventCanceled() then
            TriggerClientEvent('chatMessage', -1, author,  { 255, 255, 255 }, message)
        end

        print("-- CHAT LOG -- ("..user_id.." - "..rp_name..") "..author .. ': ' .. message)
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
    --TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^2* ' .. GetPlayerName(source) .. ' joined.')
end)

AddEventHandler('playerDropped', function(reason)
    TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^2* ' .. GetPlayerName(source) ..' left (' .. reason .. ')')
end)

RegisterCommand('say', function(source, args, rawCommand)
    TriggerClientEvent('chatMessage', -1, (source == 0) and 'console' or GetPlayerName(source), { 255, 255, 255 }, rawCommand:sub(5))
end)

AddEventHandler('chatMessage', function(source, name, message, rp_name, user_id)
    if(string.sub(message,1,1) == "/") then
        local args = stringsplit(message)
        local cmd = args[1]
        local msg = ""
        local cmdEnd = string.find(message,"%s")
        if cmdEnd ~= nil then
            msg = string.sub(message,cmdEnd+1)
        end
        --local msg = stringsplit(message, "/"..cmd)
        local cmd = string.lower(cmd)
        if (cmd == "/ooc" or cmd == "/g") and (msg ~= nil and msg ~= "") then
            TriggerClientEvent('chatMessage', -1, "^1[^0OOC", {100, 100, 100}, "^4 " .. rp_name.. " ^4(^0"..user_id.."^4): ^0" .. msg .. "^1]")
            sendToDiscord(name.." ("..rp_name.." - "..user_id..")", "**OOC**: "..msg)
        elseif cmd == "/tweet" and (msg ~= nil and msg ~= "") then
            TriggerClientEvent('chatMessage', -1, "^5Twitter", {100, 100, 100}, "^4 @" ..rp_name.. " ^4(^0"..user_id.."^4): ^0" .. msg)
            sendToDiscord(name.." ("..rp_name.." - "..user_id..")", "**TWEET**: "..msg)
        elseif cmd == "/me" and (msg ~= nil and msg ~= "") then
            TriggerClientEvent("sendProximityMessage", -1, source, "^="..rp_name.." ("..user_id..")", "^9 ^="..msg, { 128, 128, 128 })
            sendToDiscord(name.." ("..rp_name.." - "..user_id..")", "**ME**: "..msg)
        elseif cmd == "/help" or cmd == "/h" then
            TriggerClientEvent('sendPlayerMesage',source, source, rp_name.."("..user_id..")", "^1Common controls: ^0M = Open menu ^1|| ^0X = Toggle hands up/down ^1|| ^0~ = Toggle your voice volume ^1|| ^0U = Toggle car door locks ^1|| ^0/ooc = For out of character chat")
        else
            TriggerClientEvent('sendPlayerMesage',source, source, rp_name.."("..user_id..")", "Invalid command")
        end
    else
        TriggerClientEvent("sendProximityMessage", -1, source, rp_name.."("..user_id..")", message, {0, 255, 0})
        sendToDiscord(name.." ("..rp_name.." - "..user_id..")", "**LOCAL**: "..message)
    end
    CancelEvent()
end)

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
