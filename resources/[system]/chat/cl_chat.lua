local chatInputActive = false
local chatInputActivating = false
local tweet_timeout_remaining = 0
local tweet_cooldown = 30 -- in seconds
local vrpUserID = 0
local vrpName = nil
local oocMuted = false

RegisterNetEvent('chatMessage')
RegisterNetEvent('oocChatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:clear')

-- internal events
RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('_chat:messageEntered')

RegisterNetEvent('chat:playerInfo')
AddEventHandler('chat:playerInfo', function(id, name)
    vrpUserID = id
    vrpName = name
end)

--deprecated, use chat:addMessage
AddEventHandler('chatMessage', function(author, color, text)
  local args = { text }
  if author ~= "" then
    table.insert(args, 1, author)
  end
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
      color = color,
      multiline = true,
      args = args
    }
  })
end)

AddEventHandler('oocChatMessage', function(author, color, text)
  if not oocMuted then
    local args = { text }
    if author ~= "" then
      table.insert(args, 1, author)
    end
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = {
        color = color,
        multiline = true,
        args = args
      }
    })
  end
end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)
  print(msg)

  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
      color = { 0, 0, 0 },
      multiline = true,
      args = { msg }
    }
  })
end)

AddEventHandler('chat:addMessage', function(message)
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = message
  })
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
  SendNUIMessage({
    type = 'ON_SUGGESTION_ADD',
    suggestion = {
      name = name,
      help = help,
      params = params or nil
    }
  })
end)

AddEventHandler('chat:removeSuggestion', function(name)
  SendNUIMessage({
    type = 'ON_SUGGESTION_REMOVE',
    name = name
  })
end)

AddEventHandler('chat:addTemplate', function(id, html)
  SendNUIMessage({
    type = 'ON_TEMPLATE_ADD',
    template = {
      id = id,
      html = html
    }
  })
end)

AddEventHandler('chat:clear', function(name)
  SendNUIMessage({
    type = 'ON_CLEAR'
  })
end)

RegisterNUICallback('chatResult', function(data, cb)
  chatInputActive = false
  SetNuiFocus(false)

  if not data.canceled then
    local id = PlayerId()

    --deprecated
    local r, g, b = 0, 0x99, 255

    --[[
    if data.message:sub(1, 1) == '/' then
      ExecuteCommand(data.message:sub(2))
    else
      TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message)
    end
    ]]--

    if(string.sub(data.message,1,1) == "/") then
        local args = stringsplit(data.message)
        local cmd = args[1]
        local msg = stringsplit(data.message, "/"..cmd)
        local cmd = string.lower(cmd)
        if cmd == "/tweet" and (msg ~= nil and msg ~= "") then
          if tweet_timeout_remaining < 1 then
            tweet_timeout_remaining = tweet_cooldown
            TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message, vrpName, vrpUserID)
          else
            TriggerEvent('chatMessage', vrpName.."("..vrpUserID..")", {255, 255, 0}, "You tweeted recently and must wait "..tweet_cooldown.." seconds to send another.")
          end
        elseif cmd == "/muteooc" then
          if oocMuted then
            oocMuted = false
            TriggerEvent('chatMessage', vrpName.."("..vrpUserID..")", {255, 255, 0}, "OOC chat unmuted. /muteooc to disable OOC chat.")
          else
            oocMuted = true
            TriggerEvent('chatMessage', vrpName.."("..vrpUserID..")", {255, 255, 0}, "OOC chat muted. /muteooc to enable OOC chat.")
          end
        else
          if cmd == "/ooc" and oocMuted then
            TriggerEvent('chatMessage', vrpName.."("..vrpUserID..")", {255, 255, 0}, "OOC chat muted. /muteooc to enable OOC chat.")
          else
            TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message, vrpName, vrpUserID)
          end
        end
    else
        TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message, vrpName, vrpUserID)
    end
  end

  cb('ok')
end)

RegisterNUICallback('loaded', function(data, cb)
  TriggerServerEvent('chat:init');

  cb('ok')
end)

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, name, message, textColor)
    local monid = PlayerId()
    local sonid = GetPlayerFromServerId(id)
    if sonid == monid then
        TriggerEvent('chatMessage', name, textColor, message)
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(monid)), GetEntityCoords(GetPlayerPed(sonid)), true) < 35 then
        TriggerEvent('chatMessage', name, textColor, message)
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
  SetNuiFocus(false)

  while true do
    Wait(0)

    if not chatInputActive then
      if IsControlPressed(0, 245) --[[ INPUT_MP_TEXT_CHAT_ALL ]] then
        chatInputActive = true
        chatInputActivating = true

        SendNUIMessage({
          type = 'ON_OPEN'
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
