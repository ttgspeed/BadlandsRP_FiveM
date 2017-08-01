RegisterServerEvent('chatCommandEntered')
RegisterServerEvent('chatMessageEntered')

local players = {}

AddEventHandler('chatMessageEntered', function(name, color, message)
    if not name or not color or not message or #color ~= 3 then
        return
    end

    TriggerEvent('chatMessage', source, name, message)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, name, color, message)
    end

    print(name .. ': ' .. message)
end)

-- player join messages
AddEventHandler('playerActivated', function()
    TriggerClientEvent('chatMessage', -1, '', { 0, 0, 0 }, '^2* ' .. GetPlayerName(source) .. ' joined.')
end)

AddEventHandler('playerDropped', function(reason)
    TriggerClientEvent('chatMessage', -1, '', { 0, 0, 0 }, '^2* ' .. GetPlayerName(source) ..' left (' .. reason .. ')')
end)

-- say command handler
AddEventHandler('rconCommand', function(commandName, args)
    if commandName == "say" then
        local msg = table.concat(args, ' ')

        TriggerClientEvent('chatMessage', -1, 'console', { 0, 0x99, 255 }, msg)
        RconPrint('console: ' .. msg .. "\n")

        CancelEvent()
    end
end)

-- tell command handler
AddEventHandler('rconCommand', function(commandName, args)
    if commandName == "tell" then
        local target = table.remove(args, 1)
        local msg = table.concat(args, ' ')

        TriggerClientEvent('chatMessage', tonumber(target), 'console', { 0, 0x99, 255 }, msg)
        RconPrint('console: ' .. msg .. "\n")

        CancelEvent()
    end
end)

AddEventHandler('chatMessage', function(source, name, message)
    if string.sub(message,1,string.len("/"))=="/" then
        local commandEnd = string.find(message,"%s")
        local msg = string.sub(message,commandEnd+1)
        local cmd = string.sub(message,2,commandEnd-1)
        cmd = string.lower(cmd)
        if cmd == "ooc" or cmd == "g" then
            TriggerClientEvent('chatMessage', -1, "^1[^0OOC", {100, 100, 100}, "^4 " .. GetPlayerName(source) .. ": ^0" .. msg .. "^1]")
        elseif cmd == "tweet" then
            TriggerClientEvent('chatMessage', -1, "^5Twitter", {100, 100, 100}, "^4 @" .. GetPlayerName(source) .. ": ^0" .. msg)
        elseif cmd == "help" or cmd == "h" then
            TriggerClientEvent('sendPlayerMesage',-1, source, name, "^1Common controls: ^0M = Open menu ^1|| ^0X = Toggle hands up/down ^1|| ^0~ = Toggle your voice volume ^1|| ^0L = Toggle car door locks ^1|| ^0/ooc = For out of character chat")
        else
            TriggerClientEvent('sendPlayerMesage',-1, source, name, "Invalid command")
        end
    else
        TriggerClientEvent("sendProximityMessage", -1, source, name, message)
    end
    CancelEvent()
end)
