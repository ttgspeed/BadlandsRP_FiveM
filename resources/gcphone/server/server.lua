local Tunnel = module("vrp", "panopticon/sv_pano_tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Log = module("vrp", "lib/Log")

vRPts = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_phone")
TSclient = Tunnel.getInterface("vrp_phone","vrp_phone")
Tunnel.bindInterface("vrp_phone",vRPts)
Tunnel.initiateProxy()

--====================================================================================
-- #Author: Jonathan D @Gannon
-- #Version 2.0
--====================================================================================

math.randomseed(os.time())

--- Pour les numero du style XXX-XXXX
function getPhoneRandomNumber()
    local numBase0 = math.random(100,999)
    local numBase1 = math.random(0,9999)
    local num = string.format("%03d-%04d", numBase0, numBase1 )
	return num
end

--- Exemple pour les numero du style 06XXXXXXXX
-- function getPhoneRandomNumber()
--     return '0' .. math.random(600000000,699999999)
-- end

--====================================================================================
--  Utils
--====================================================================================
function getNumberPhone(user_id)
    local result = MySQL.Sync.fetchAll("SELECT phone FROM vrp_user_identities WHERE user_id = @user_id", {
        ['@user_id'] = user_id
    })
    if result[1] ~= nil then
        return result[1].phone
    end
    return nil
end
function getIdentifierByPhoneNumber(phone_number)
  vRP.getUserByPhone({phone_number, function(dest_id)
    if dest_id ~= nil then
      return dest_id
    end
    return nil
  end})
end

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end


function getOrGeneratePhoneNumber (sourcePlayer, identifier, cb)
    local sourcePlayer = sourcePlayer
    local identifier = identifier
    local myPhoneNumber = getNumberPhone(identifier)
    if myPhoneNumber == '0' or myPhoneNumber == nil then
        repeat
            myPhoneNumber = getPhoneRandomNumber()
            local id = getIdentifierByPhoneNumber(myPhoneNumber)
        until id == nil
        MySQL.Async.insert("UPDATE users SET phone_number = @myPhoneNumber WHERE identifier = @identifier", {
            ['@myPhoneNumber'] = myPhoneNumber,
            ['@identifier'] = identifier
        }, function ()
            cb(myPhoneNumber)
        end)
    else
        cb(myPhoneNumber)
    end
end
--====================================================================================
--  Contacts
--====================================================================================
function getContacts(user_id)
    local result = MySQL.Sync.fetchAll("SELECT * FROM phone_users_contacts WHERE phone_users_contacts.user_id = @user_id", {
        ['@user_id'] = user_id
    })
    return result
end
function addContact(source, number, display)
    local sourcePlayer = tonumber(source)
    local user_id = vRP.getUserId({source})
    MySQL.Async.insert("INSERT INTO phone_users_contacts (`user_id`, `number`,`display`) VALUES(@user_id, @number, @display)", {
        ['@user_id'] = user_id,
        ['@number'] = number,
        ['@display'] = display,
    },function()
        notifyContactChange(sourcePlayer)
    end)
end
function updateContact(source, id, number, display)
    local sourcePlayer = tonumber(source)
    MySQL.Async.insert("UPDATE phone_users_contacts SET number = @number, display = @display WHERE id = @id", {
        ['@number'] = number,
        ['@display'] = display,
        ['@id'] = id,
    },function()
        notifyContactChange(sourcePlayer)
    end)
end
function deleteContact(source, id)
    local sourcePlayer = tonumber(source)
    local user_id = vRP.getUserId({source})
    MySQL.Sync.execute("DELETE FROM phone_users_contacts WHERE `user_id` = @user_id AND `id` = @id", {
        ['@user_id'] = user_id,
        ['@id'] = id,
    })
    notifyContactChange(sourcePlayer)
end
function deleteAllContact(source)
  local user_id = vRP.getUserId({source})
  MySQL.Sync.execute("DELETE FROM phone_users_contacts WHERE `user_id` = @user_id", {
      ['@user_id'] = user_id
  })
end
function notifyContactChange(source)
    local sourcePlayer = tonumber(source)
    if sourcePlayer ~= nil then
        local user_id = vRP.getUserId({source})
        TriggerClientEvent("gcPhone:contactList", sourcePlayer, getContacts(user_id))
    end
end

RegisterServerEvent('gcPhone:addContact')
AddEventHandler('gcPhone:addContact', function(display, phoneNumber)
    local sourcePlayer = tonumber(source)
    addContact(sourcePlayer, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:updateContact')
AddEventHandler('gcPhone:updateContact', function(id, display, phoneNumber)
    local sourcePlayer = tonumber(source)
    updateContact(sourcePlayer, id, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:deleteContact')
AddEventHandler('gcPhone:deleteContact', function(id)
    local sourcePlayer = tonumber(source)
    deleteContact(sourcePlayer, id)
end)

--====================================================================================
--  Messages
--====================================================================================
function getMessages(user_id)
    local result = MySQL.Sync.fetchAll("SELECT phone_messages.* FROM phone_messages LEFT JOIN vrp_user_identities ON vrp_user_identities.user_id = @user_id WHERE phone_messages.receiver = vrp_user_identities.phone", {
         ['@user_id'] = user_id
    })
    return result
    --return MySQLQueryTimeStamp("SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number", {['@identifier'] = identifier})
end

RegisterServerEvent('gcPhone:_internalAddMessage')
AddEventHandler('gcPhone:_internalAddMessage', function(transmitter, receiver, message, owner, cb)
    cb(_internalAddMessage(transmitter, receiver, message, owner))
end)

function _internalAddMessage(transmitter, receiver, message, owner)
    local Query = "INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner);"
    local Query2 = 'SELECT * from phone_messages WHERE `id` = (SELECT LAST_INSERT_ID());'
	local Parameters = {
        ['@transmitter'] = transmitter,
        ['@receiver'] = receiver,
        ['@message'] = message,
        ['@isRead'] = owner,
        ['@owner'] = owner
    }
	return MySQL.Sync.fetchAll(Query .. Query2, Parameters)[1]
end

function addMessage(source, phone_number, message)
    local sourcePlayer = tonumber(source)
    local user_id = vRP.getUserId({source})
    vRP.getUserByPhone({phone_number, function(dest_id)
      if dest_id ~= nil then
        local myPhone = getNumberPhone(user_id)
        local tomess = _internalAddMessage(myPhone, phone_number, message, 0)
        local dest_source = vRP.getUserSource({dest_id})
        if tonumber(dest_source) ~= nil then
            TriggerClientEvent("gcPhone:receiveMessage", tonumber(dest_source), tomess)
        end
        local memess = _internalAddMessage(phone_number, myPhone, message, 1)
        TriggerClientEvent("gcPhone:receiveMessage", sourcePlayer, memess)
        Log.write(user_id,"Sent SMS message: "..message..". To: "..dest_id,Log.log_type.phone)
      end
    end})
end

function addMessage_Anonymous(source_number, phone_number, message)
  vRP.getUserByPhone({phone_number, function(dest_id)
    if dest_id ~= nil then
      local myPhone = source_number
      local tomess = _internalAddMessage(myPhone, phone_number, message, 0)
      local dest_source = vRP.getUserSource({dest_id})
      if dest_source ~= nil then
          TriggerClientEvent("gcPhone:receiveMessage", tonumber(dest_source), tomess)
      end
    end
  end})
end

function setReadMessageNumber(user_id, num)
    local mePhoneNumber = getNumberPhone(user_id)
    MySQL.Sync.execute("UPDATE phone_messages SET phone_messages.isRead = 1 WHERE phone_messages.receiver = @receiver AND phone_messages.transmitter = @transmitter", {
        ['@receiver'] = mePhoneNumber,
        ['@transmitter'] = num
    })
end

function deleteMessage(msgId)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `id` = @id", {
        ['@id'] = msgId
    })
end

function deleteAllMessageFromPhoneNumber(source, phone_number)
    local source = source
    local user_id = vRP.getUserId({source})
    local mePhoneNumber = getNumberPhone(user_id)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number", {['@mePhoneNumber'] = mePhoneNumber,['@phone_number'] = phone_number})
end

function deleteAllMessage(source)
  local user_id = vRP.getUserId({source})
  local mePhoneNumber = getNumberPhone(user_id)
  MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber", {
      ['@mePhoneNumber'] = mePhoneNumber
  })
end

RegisterServerEvent('gcPhone:sendMessage')
AddEventHandler('gcPhone:sendMessage', function(phoneNumber, message)
    local sourcePlayer = tonumber(source)
    addMessage(sourcePlayer, phoneNumber, message)
end)

RegisterServerEvent('gcPhone:sendMessage_Anonymous')
AddEventHandler('gcPhone:sendMessage_Anonymous', function(source_number, phoneNumber, message)
    addMessage_Anonymous(source_number, phoneNumber, message)
end)

RegisterServerEvent('gcPhone:deleteMessage')
AddEventHandler('gcPhone:deleteMessage', function(msgId)
    deleteMessage(msgId)
end)

RegisterServerEvent('gcPhone:deleteMessageNumber')
AddEventHandler('gcPhone:deleteMessageNumber', function(number)
    local sourcePlayer = tonumber(source)
    deleteAllMessageFromPhoneNumber(sourcePlayer, number)
    -- TriggerClientEvent("gcphone:allMessage", sourcePlayer, getMessages(identifier))
end)

RegisterServerEvent('gcPhone:deleteAllMessage')
AddEventHandler('gcPhone:deleteAllMessage', function()
    local sourcePlayer = tonumber(source)
    deleteAllMessage(source)
end)

RegisterServerEvent('gcPhone:setReadMessageNumber')
AddEventHandler('gcPhone:setReadMessageNumber', function(num)
    local user_id = vRP.getUserId({source})
    setReadMessageNumber(user_id, num)
end)

RegisterServerEvent('gcPhone:deleteALL')
AddEventHandler('gcPhone:deleteALL', function()
    local sourcePlayer = tonumber(source)
    local user_id = vRP.getUserId({source})
    deleteAllMessage(source)
    deleteAllContact(source)
    appelsDeleteAllHistorique(source)
    TriggerClientEvent("gcPhone:contactList", sourcePlayer, {})
    TriggerClientEvent("gcPhone:allMessage", sourcePlayer, {})
    TriggerClientEvent("appelsDeleteAllHistorique", sourcePlayer, {})
end)

--====================================================================================
--  Gestion des appels
--====================================================================================
local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10

function getHistoriqueCall (num)
    local result = MySQL.Sync.fetchAll("SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 120", {
        ['@num'] = num
    })
    return result
end

function sendHistoriqueCall (src, num)
    local histo = getHistoriqueCall(num)
    TriggerClientEvent('gcPhone:historiqueCall', src, histo)
end

function saveAppels (appelInfo)
    MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
        ['@owner'] = appelInfo.transmitter_num,
        ['@num'] = appelInfo.receiver_num,
        ['@incoming'] = 1,
        ['@accepts'] = appelInfo.is_accepts
    }, function()
        notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
    end)
    if appelInfo.is_valid == true then
        local num = appelInfo.transmitter_num
        if appelInfo.hidden == true then
            mun = "###-####"
        end
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.receiver_num,
            ['@num'] = num,
            ['@incoming'] = 0,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            if appelInfo.receiver_src ~= nil then
                notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
            end
        end)
    end
end

function notifyNewAppelsHisto (src, num)
    sendHistoriqueCall(src, num)
end

RegisterServerEvent('gcPhone:getHistoriqueCall')
AddEventHandler('gcPhone:getHistoriqueCall', function()
    local sourcePlayer = tonumber(source)
    sendHistoriqueCall(sourcePlayer, num)
end)


RegisterServerEvent('gcPhone:internal_startCall')
AddEventHandler('gcPhone:internal_startCall', function(source, phone_number, rtcOffer, extraData)
    if FixePhone[phone_number] ~= nil then
        onCallFixePhone(source, phone_number, rtcOffer, extraData)
        return
    end

    local rtcOffer = rtcOffer
    if phone_number == nil then
        print('BAD CALL NUMBER IS NIL')
        return
    end

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end

    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    local source_id = vRP.getUserId({source})
    local srcPhone = getNumberPhone(source_id)
    vRP.getUserByPhone({phone_number, function(dest_id)
      local srcTo = vRP.getUserSource({dest_id})
      local is_valid = srcTo ~= nil and srcTo ~= source
      AppelsEnCours[indexCall] = {
          id = indexCall,
          transmitter_src = sourcePlayer,
          transmitter_num = srcPhone,
          receiver_src = nil,
          receiver_num = phone_number,
          is_valid = srcTo ~= nil,
          is_accepts = false,
          hidden = hidden,
          rtcOffer = rtcOffer,
          extraData = extraData
      }


      if is_valid == true then
          if srcTo ~= nill then
              AppelsEnCours[indexCall].receiver_src = srcTo
              TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
              TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
              TriggerClientEvent('gcPhone:waitingCall', srcTo, AppelsEnCours[indexCall], false)
          else
              TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
              TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
          end
      else
          TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
          TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
      end
      Log.write(source_id,"Called: "..(dest_id or "Unk ID or Invalid Number"),Log.log_type.phone)
    end})

end)

RegisterServerEvent('gcPhone:startCall')
AddEventHandler('gcPhone:startCall', function(phone_number, rtcOffer, extraData)
    TriggerEvent('gcPhone:internal_startCall',source, phone_number, rtcOffer, extraData)
end)

RegisterServerEvent('gcPhone:candidates')
AddEventHandler('gcPhone:candidates', function (callId, candidates)
    print('send cadidate', callId, candidates)
    if AppelsEnCours[callId] ~= nil then
        local source = source
        local to = AppelsEnCours[callId].transmitter_src
        if source == to then
            to = AppelsEnCours[callId].receiver_src
        end
        print('TO', to)
        TriggerClientEvent('gcPhone:candidates', to, candidates)
    end
end)


RegisterServerEvent('gcPhone:acceptCall')
AddEventHandler('gcPhone:acceptCall', function(infoCall, rtcAnswer)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onAcceptFixePhone(source, infoCall, rtcAnswer)
            return
        end
        AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src
        if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
            AppelsEnCours[id].is_accepts = true
            AppelsEnCours[id].rtcAnswer = rtcAnswer
            TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
            TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
            saveAppels(AppelsEnCours[id])
        end
    end
end)

RegisterServerEvent('gcPhone:rejectCall')
AddEventHandler('gcPhone:rejectCall', function (infoCall)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onRejectFixePhone(source, infoCall)
            return
        end
        if AppelsEnCours[id].transmitter_src ~= nil then
            TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)
        end
        if AppelsEnCours[id].receiver_src ~= nil then
            TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].receiver_src)
        end

        if AppelsEnCours[id].is_accepts == false then
            saveAppels(AppelsEnCours[id])
        end
        TriggerEvent('gcPhone:removeCall', AppelsEnCours)
        AppelsEnCours[id] = nil
    end
end)

RegisterServerEvent('gcPhone:appelsDeleteHistorique')
AddEventHandler('gcPhone:appelsDeleteHistorique', function (numero)
    local sourcePlayer = tonumber(source)
    local user_id = vRP.getUserId({source})
    local srcPhone = getNumberPhone(user_id)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num", {
        ['@owner'] = srcPhone,
        ['@num'] = numero
    })
end)

function appelsDeleteAllHistorique(source)
  local user_id = vRP.getUserId({source})
  local srcPhone = getNumberPhone(user_id)
  MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner", {
    ['@owner'] = srcPhone
  })
end

RegisterServerEvent('gcPhone:appelsDeleteAllHistorique')
AddEventHandler('gcPhone:appelsDeleteAllHistorique', function ()
    local sourcePlayer = tonumber(source)
    appelsDeleteAllHistorique(source)
end)

--====================================================================================
--  OnLoad
--====================================================================================
AddEventHandler('vRP:playerSpawn',function(user_id,source,first_spawn)
    local sourcePlayer = tonumber(source)
    local user_id = vRP.getUserId({source})
    local myPhoneNumber = getNumberPhone(user_id)
    TriggerClientEvent("gcPhone:myPhoneNumber", sourcePlayer, myPhoneNumber)
    TriggerClientEvent("gcPhone:contactList", sourcePlayer, getContacts(user_id))
    TriggerClientEvent("gcPhone:allMessage", sourcePlayer, getMessages(user_id))
end)

-- Just For reload
RegisterServerEvent('gcPhone:allUpdate')
AddEventHandler('gcPhone:allUpdate', function()
    local sourcePlayer = tonumber(source)
    local user_id = vRP.getUserId({source})
    local num = getNumberPhone(user_id)
    TriggerClientEvent("gcPhone:myPhoneNumber", sourcePlayer, num)
    TriggerClientEvent("gcPhone:contactList", sourcePlayer, getContacts(user_id))
    TriggerClientEvent("gcPhone:allMessage", sourcePlayer, getMessages(user_id))
    sendHistoriqueCall(sourcePlayer, num)
end)


AddEventHandler('onMySQLReady', function ()
    MySQL.Async.fetchAll("DELETE FROM phone_messages WHERE (DATEDIFF(CURRENT_DATE,time) > 10)")
end)
