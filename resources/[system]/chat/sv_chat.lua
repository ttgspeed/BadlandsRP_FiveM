RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:broadcast')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

function sendToDiscord(name, message)
    local discordUrl = GetConvar('discord_url_string')
    if discordUrl ~= nil and discordUrl ~= "" then
        PerformHttpRequest(discordUrl, function(err, text, headers) end, 'POST', json.encode({username = name, content = message}), { ['Content-Type'] = 'application/json' })
    end
end

AddEventHandler('_chat:broadcast', function(author, color, message)
    if not message or not author then
        return
    end

    TriggerClientEvent('chatMessage', -1, author, color, message)
end)

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
    --TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^2* ' .. GetPlayerName(source) ..' left (' .. reason .. ')')
end)

RegisterCommand('say', function(source, args, rawCommand)
    TriggerClientEvent('chatMessage', -1, (source == 0) and 'console' or GetPlayerName(source), { 255, 255, 255 }, rawCommand:sub(5))
end)

AddEventHandler('chatMessage', function(source, name, message, rp_name, user_id)
    if user_id ~= nil then
        -- Check if bannable word is in message
        find_me = "nigger"
        start,finish = string.find(string.gsub(string.lower(message),"(.*)"," %1 "), "[^%a]"..find_me.."[^%a]")
        -- If we have  end, then word is found
        if finish then
            TriggerEvent('vRP:banPlayer', source, user_id..' Racism perm (serpickle)','0')
            --DropPlayer(source,"Kick: Racism warning, innapropriate chat use.")
            CancelEvent()
        end
        -- Check if bannable word is in message
        find_me = "niggers"
        start,finish = string.find(string.gsub(string.lower(message),"(.*)"," %1 "), "[^%a]"..find_me.."[^%a]")
        -- If we have  end, then word is found
        if finish then
            TriggerEvent('vRP:banPlayer', source, user_id..' Racism perm (serpickle)','0')
            --DropPlayer(source,"Kick: Racism warning, innapropriate chat use.")
            CancelEvent()
        end
        -- Check if kickable word is in message
        find_me = "nigga"
        start,finish = string.find(string.gsub(string.lower(message),"(.*)"," %1 "), "[^%a]"..find_me.."[^%a]")
        -- If we have  end, then word is found
        if finish then
            DropPlayer(source,"Kick: Racism warning, innapropriate chat use.")
            CancelEvent()
        end
        find_me = "niggas"
        start,finish = string.find(string.gsub(string.lower(message),"(.*)"," %1 "), "[^%a]"..find_me.."[^%a]")
        -- If we have  end, then word is found
        if finish then
            DropPlayer(source,"Kick: Racism warning, innapropriate chat use.")
            CancelEvent()
        end
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
                TriggerClientEvent('oocChatMessage', -1, {
                    template = '<div class="chat-bubble" style="background-color: rgba(150, 150, 150, 0.6);"><i class="fas fa-comment"></i> <b><i>[OOC]</i> {0}:</b> {1}</div>',
                    args = { rp_name.." ("..user_id..")", msg }
                })
                sendToDiscord(name.." ("..rp_name.." - "..user_id..")", "**OOC**: "..msg)
						elseif cmd == "/ad" and (msg ~= nil and msg ~= "") then
                TriggerClientEvent('chat:addMessage', -1, {
                    template = '<div class="chat-bubble" style="background-color: rgba(255, 204, 102, 0.6);"><i class="fas fa-audio-description"></i> <b> {0}:</b> {1}</div>',
                    args = { rp_name.." ("..user_id..")", msg }
                })
								sendToDiscord(name.." ("..rp_name.." - "..user_id..")", "**Advertisement**: "..msg)
						elseif cmd == "/lsfd" and (msg ~= nil and msg ~= "") then
                TriggerClientEvent('chat:addMessage', -1, {
                    template = '<div class="chat-bubble" style="background-color: rgba(204, 0, 0, 0.6);"><i class="fas fa-heartbeat"></i> <b> {0}:</b> {1}</div>',
                    args = { rp_name.." ("..user_id..")", msg }
                })
								sendToDiscord(name.." ("..rp_name.." - "..user_id..")", "**LSFD**: "..msg)
						elseif cmd == "/lspd" and (msg ~= nil and msg ~= "") then
                TriggerClientEvent('chat:addMessage', -1, {
                    template = '<div class="chat-bubble" style="background-color: rgba(0, 82, 204, 0.6);"><i class="fas fa-balance-scale"></i> <b> {0}:</b> {1}</div>',
                    args = { rp_name.." ("..user_id..")", msg }
                })
								sendToDiscord(name.." ("..rp_name.." - "..user_id..")", "**LSPD**: "..msg)
            elseif cmd == "/me" and (msg ~= nil and msg ~= "") then
                TriggerClientEvent('sendProximityMessage', -1, source, {
                    template = '<div class="chat-bubble" style="background-color: rgba(38, 38, 38, 0.6);"><i class="fas fa-user"></i> <b> {0}:</b> <i>{1}</i></div>',
                    args = { rp_name.." ("..user_id..")", msg }
                })
                sendToDiscord(name.." ("..rp_name.." - "..user_id..")", "**ME**: "..msg)
			      elseif cmd == "/spawn" and (msg ~= nil and msg ~= "") then
                TriggerEvent('vrp:adminSpawnVehicle', source, msg)
            elseif cmd == "/help" or cmd == "/h" then
                TriggerClientEvent('sendPlayerMesage', -1, source, {
                    template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-question-circle"></i> {0}</div>',
                    args = { "^1Common controls: ^0M = Open menu ^1|| ^0X = Toggle hands up/down ^1|| ^0~ = Toggle your voice volume ^1|| ^0U = Toggle car door locks ^1|| ^0G = Toggle engine on/off ^1|| ^0/ooc = For out of character chat" }
                })
            elseif cmd == "/bars" or cmd == "/race" or cmd == "/racequit" or cmd == "/wanted" or cmd == "/dispatch" or cmd == "/setemote" or cmd == "/glasses" or cmd == "/mask" or cmd == "/removemask" or cmd == "/headgear" or cmd == "/cam" or cmd == "/mic" or cmd == "/bmic" or cmd == "/atm" or cmd == "/helmet" or cmd == "/carlivery" or cmd == "/carmod" or cmd == "/cardoor" or cmd == "/muteooc" or cmd == "/mutead" or cmd == "/taxifare" or cmd == "/walk" or cmd == "/setweather" or cmd == "/em" or cmd == "/emote" then
            else
              TriggerClientEvent('sendPlayerMesage', -1, source, {
                  template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-exclamation-circle"></i> {0}</div>',
                  args = { "Invalid command" }
              })
            end
        else
            TriggerClientEvent('sendProximityMessage', -1, source, {
                template = '<div class="chat-bubble" style="background-color: rgba(0, 153, 77, 0.6);"><i class="fas fa-comment"></i> <b> {0}:</b> {1}</div>',
                args = { rp_name.." ("..user_id..")", message }
            })
            sendToDiscord(name.." ("..rp_name.." - "..user_id..")", "**LOCAL**: "..message)
        end
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
