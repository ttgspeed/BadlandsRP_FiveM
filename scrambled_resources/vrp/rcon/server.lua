RconLog({ msgType = 'serverStart', hostname = 'lovely', maxplayers = 32 })

RegisterServerEvent('1a1284bb-a5b6-44c3-a99c-eaa52484be7f')

local names = {}

AddEventHandler('1a1284bb-a5b6-44c3-a99c-eaa52484be7f', function()
    RconLog({ msgType = 'playerActivated', netID = source, name = GetPlayerName(source), guid = GetPlayerIdentifiers(source)[1], ip = GetPlayerEP(source) })

    names[source] = { name = GetPlayerName(source), id = source }

    TriggerClientEvent('a6dc9dc9-2fda-4eba-aa4c-b0b0ceeb2cac', GetHostId())
end)

RegisterServerEvent('dc7718f9-6488-4ef1-bbee-e77d22ab0b1c')

AddEventHandler('dc7718f9-6488-4ef1-bbee-e77d22ab0b1c', function(res)
    if source ~= tonumber(GetHostId()) then
        print('bad guy')
        return
    end

    for id, data in pairs(res) do
        if data then
            if data.name then
                if not names[id] then
                    names[id] = data
                end

                if names[id].name ~= data.name or names[id].id ~= data.id then
                    names[id] = data

                    RconLog({ msgType = 'playerRenamed', netID = id, name = data.name })
                end
            end
        else
            names[id] = nil
        end
    end
end)

AddEventHandler('playerDropped', function()
    RconLog({ msgType = 'playerDropped', netID = source, name = GetPlayerName(source) })

    names[source] = nil
end)

AddEventHandler('chatMessage', function(netID, name, message)
    RconLog({ msgType = 'chatMessage', netID = netID, name = name, message = message, guid = GetPlayerIdentifiers(netID)[1] })
end)

AddEventHandler('rconCommand', function(commandName, args)
    if commandName == 'status' then
        for netid, data in pairs(names) do
            local guid = GetPlayerIdentifiers(netid)

            if guid and guid[1] and data then
                local ping = GetPlayerPing(netid)
                local vrpID = vRP.getUserId(netid) or 'unk'
                RconPrint('Netid: '.. netid .. ' |vRP-ID: '.. vrpID ..' |'.. guid[1] .. ' |Name: ' .. data.name .. ' |IP: ' .. GetPlayerEP(netid) .. ' |Ping: ' .. ping .. "\n")
            end
        end

        CancelEvent()
    elseif commandName == 'statusjson' then
        local playerInfoList = {}
        for netid, data in pairs(names) do
            local guid = GetPlayerIdentifiers(netid)

            if guid and guid[1] and data then
                local ping = GetPlayerPing(netid)
                local vrpID = vRP.getUserId(netid) or 'unk'
                local playerInfo = {
                  netid = netid,
                  vrpid = vrpID,
                  guid = guid[1],
                  name = data.name,
                  ip = GetPlayerEP(netid),
                  ping = ping
                }
                playerInfoList[#playerInfoList+1]=playerInfo
            end
        end
        RconPrint(json.encode(playerInfoList))
        CancelEvent()
    elseif commandName:lower() == 'clientkick' then
        local playerId = table.remove(args, 1)
        local msg = table.concat(args, ' ')

        DropPlayer(playerId, msg)

        CancelEvent()
    elseif commandName:lower() == 'banclient' then
        local playerId = table.remove(args, 1)
        local bannedBy = table.remove(args, 1)
        local msg = table.concat(args, ' ')
        playerId = parseInt(playerId)
        if playerId > 0 then
            local source = vRP.getUserSource(playerId)
            if source ~= nil then
                vRP.ban(source,msg,bannedBy)
            end
        end
        CancelEvent()
    end
end)
