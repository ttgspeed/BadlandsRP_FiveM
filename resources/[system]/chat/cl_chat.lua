local chatInputActive = false
local chatInputActivating = false
local tweet_timeout_remaining = 0
local tweet_cooldown = 30 -- in seconds
local vrpUserID = 0
local vrpName = nil
local oocMuted = false
local twitterMuted = false
local twitterOccDisabled = false
local handcuffed = false
local inComa = false
local inJail = false
local inPrison = false

RegisterNetEvent('chatMessage')
RegisterNetEvent('oocChatMessage')
RegisterNetEvent('twitterChatMessage')
RegisterNetEvent('emergencyChatMessage')
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

AddEventHandler('oocChatMessage', function(message)
  if not oocMuted then
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = message
    })
  end
end)

AddEventHandler('twitterChatMessage', function(message)
  if not twitterMuted then
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = message
    })
  end
end)

AddEventHandler('emergencyChatMessage', function(author, color, text)
  local args = { text }
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = message
  })
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
        if cmd == "/tweet" or cmd == "/ad" then
          if twitterMuted then
            TriggerEvent('chat:addMessage', {
                template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-exclamation-circle"></i> {0}</div>',
                args = { "Twitter muted. /mutetwitter to enable Twitter chat." }
            })
          else
            if not twitterOccDisabled then
              if (msg ~= nil and msg ~= "") then
                if tweet_timeout_remaining < 1 then
                  tweet_timeout_remaining = tweet_cooldown
                  TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message, vrpName, vrpUserID)
                else
                  TriggerEvent('chat:addMessage', {
                      template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-exclamation-circle"></i> {0}</div>',
                      args = { "You tweeted recently and must wait "..tweet_cooldown.." seconds to send another." }
                  })
                end
              end
            else
              TriggerEvent('chat:addMessage', {
                  template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-exclamation-circle"></i> {0}</div>',
                  args = { "Twitter is disabled while dead/restrained/jailed." }
              })
            end
          end
				elseif cmd == "/lspd" then
					TriggerEvent('vRP:emergencyChatMessage', "lspd", GetPlayerName(id), { r, g, b }, data.message, vrpName, vrpUserID)
				elseif cmd == "/lsfd" then
					TriggerEvent('vRP:emergencyChatMessage', "lsfd", GetPlayerName(id), { r, g, b }, data.message, vrpName, vrpUserID)
        elseif cmd == "/muteooc" then
          if oocMuted then
            oocMuted = false
            TriggerEvent('chat:addMessage', {
                template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-exclamation-circle"></i> {0}</div>',
                args = { "OOC chat unmuted. /muteooc to disable OOC chat." }
            })
          else
            oocMuted = true
            TriggerEvent('chat:addMessage', {
                template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-exclamation-circle"></i> {0}</div>',
                args = { "OOC chat muted. /muteooc to enable OOC chat." }
            })
          end
        elseif cmd == "/mutetwitter" then
          if twitterMuted then
            twitterMuted = false
            TriggerEvent('chat:addMessage', {
                template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-exclamation-circle"></i> {0}</div>',
                args = { "Twitter chat unmuted. /mutetwitter to disable Twitter chat." }
            })
          else
            twitterMuted = true
            TriggerEvent('chat:addMessage', {
                template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-exclamation-circle"></i> {0}</div>',
                args = { "Twitter chat muted. /mutetwitter to enable Twitter chat." }
            })
          end
        else
          if cmd == "/ooc" then
            if oocMuted then
              TriggerEvent('chat:addMessage', {
                  template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-exclamation-circle"></i> {0}</div>',
                  args = { "OOC chat muted. /muteooc to enable OOC chat." }
              })
            else
              if not twitterOccDisabled then
                TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message, vrpName, vrpUserID)
              else
                TriggerEvent('chat:addMessage', {
                    template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-exclamation-circle"></i> {0}</div>',
                    args = { "OOC is disabled while dead/restrained/jailed." }
                })
              end
            end
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

RegisterNetEvent('chat:setHandcuffState')
AddEventHandler('chat:setHandcuffState', function(toggle)
  if toggle ~= nil then
    handcuffed = toggle
  end
end)

RegisterNetEvent('chat:setComaState')
AddEventHandler('chat:setComaState', function(toggle)
  if toggle ~= nil then
    inComa = toggle
  end
end)

RegisterNetEvent('chat:setJailState')
AddEventHandler('chat:setJailState', function(toggle)
  if toggle ~= nil then
    inJail = toggle
  end
end)

RegisterNetEvent('chat:setPrisonState')
AddEventHandler('chat:setPrisonState', function(toggle)
  if toggle ~= nil then
    inPrison = toggle
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if handcuffed or inComa or inJail or inPrison then
      twitterOccDisabled = true
    else
      twitterOccDisabled = false
    end
  end
end)

RegisterNUICallback('loaded', function(data, cb)
  TriggerServerEvent('chat:init');

  cb('ok')
end)

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, message)
    local monid = PlayerId()
    local sonid = GetPlayerFromServerId(id)
    if sonid == monid then
      --TriggerEvent('chat:addMessage', message)
      TriggerEvent('3dme:triggerDisplay', message.args[2], id)
    elseif Vdist(GetEntityCoords(GetPlayerPed(monid)), GetEntityCoords(GetPlayerPed(sonid))) < 6 then
      --TriggerEvent('chat:addMessage', message)
      TriggerEvent('3dme:triggerDisplay', message.args[2], id)
    end
end)

RegisterNetEvent('sendPlayerMesage')
AddEventHandler('sendPlayerMesage', function(id, message)
    local monid = PlayerId()
    local sonid = GetPlayerFromServerId(id)
    if sonid == monid then
      TriggerEvent('chat:addMessage', message)
    end
end)

local meDisplayTime = 7000 -- Duration of the display of the text : 1000ms = 1sec
local slashMeOffsets = {}

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source)
    local mePed = GetPlayerFromServerId(source)
    local offset = 0.1
    if slashMeOffsets[mePed] == nil or slashMeOffsets[mePed] < 1 then
      slashMeOffsets[mePed] = 1
    end
    offset = offset + (slashMeOffsets[mePed]*0.10)
    Display(mePed, text, offset)
end)

function Display(mePlayer, text, offset)
    local displaying = true
    Citizen.CreateThread(function()
        Wait(meDisplayTime)
        displaying = false
    end)
    Citizen.CreateThread(function()
        slashMeOffsets[mePlayer] = slashMeOffsets[mePlayer] + 1
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = GetDistanceBetweenCoords(coordsMe['x'], coordsMe['y'], coordsMe['z'], coords['x'], coords['y'], coords['z'], true)
            if dist < 6 then
                DrawText3Ds(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset, text)
            end
        end
        slashMeOffsets[mePlayer] = slashMeOffsets[mePlayer] - 1
    end)
end

function DrawText3Ds(x,y,z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(pX, pY, pZ, x, y, z, 1)

    local scale = 0.4
    --local fov = (1/GetGameplayCamFov())*100
    --local scale = scale*fov

    if onScreen then
      SetTextScale(scale, scale)
      SetTextFont(4)
      SetTextProportional(1)
      SetTextEntry("STRING")
      SetTextCentre(1)
      SetTextColour(255, 255, 255, 215)
      AddTextComponentString(text)
      DrawText(_x, _y)

      local factor = (string.len(text)) / 370
      DrawRect(_x, _y + 0.0150, 0.030 + factor, 0.025, 41, 11, 41, 100)
    end
end

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

Citizen.CreateThread(function() -- coma decrease thread
  Citizen.Wait(10000)
  TriggerEvent('chat:addSuggestion', '/help', 'Basic information.')
  TriggerEvent('chat:addSuggestion', '/em', 'Perform the selected emote.',{{name = "emote", help = "Enter emote name"}})
  TriggerEvent('chat:addSuggestion', '/tweet', 'Send a public twitter message.',{{name = "msg", help = "Enter message to send"}})
  TriggerEvent('chat:addSuggestion', '/me', 'Personal action description.',{{name = "msg", help = "Enter self action message"}})
  TriggerEvent('chat:addSuggestion', '/muteooc', 'Toggle OOC chat visibility.')
  TriggerEvent('chat:addSuggestion', '/ooc', 'Send out of character message. Should be used rarely.',{{name = "msg", help = "Enter message to send"}})
  TriggerEvent('chat:addSuggestion', '/walk', 'Set your current style. `/walk clear` to reset.',{{name = "style", help = "Enter walk style"}})
  --TriggerEvent('chat:addSuggestion', '/taxidisplay', 'Toggle the taxi meter display (must be in a Taxi).')
  TriggerEvent('chat:addSuggestion', '/taxifare', 'Set the rates for your meter.',{{name = "action", help = "Enter the action"}})
  --TriggerEvent('chat:addSuggestion', '/taxihire', 'Toggle your meter on/off.')
  --TriggerEvent('chat:addSuggestion', '/taxireset', 'Reset your meter for a new rider.')
  TriggerEvent('chat:addSuggestion', '/atm', 'Use the nearest ATM if not prompted.')
  TriggerEvent('chat:addSuggestion', '/race', 'Start a race.',{{name = "Bet Amount", help = "Set bet amount for the race"},{name = "Use waypoint or random course", help = "0 = Use waypoint, 1 = Random course"}})
  TriggerEvent('chat:addSuggestion', '/racequit', 'Abandon current race.')
  TriggerEvent('chat:addSuggestion', '/mutetwitter', 'Toggle Twitter chat visibility.')
  TriggerEvent('chat:addSuggestion', '/cam', 'Toggle camera. Must be signed in News job.')
  TriggerEvent('chat:addSuggestion', '/bmic', 'Toggle boom mic. Must be signed in News job.')
  TriggerEvent('chat:addSuggestion', '/mic', 'Toggle hand mic. Must be signed in News job.')
  TriggerEvent('chat:addSuggestion', '/cardoor', 'Open/Close individual doors.',{{name = "action", help = "open or close"},{name = "door id", help = "Starts at 0"}})
  TriggerEvent('chat:addSuggestion', '/helmet', 'Toggle helmet/hat on/off.',{{name = "action", help = "0 = remove, 1 = put on (if available)"}})
  TriggerEvent('chat:addSuggestion', '/glasses', 'Toggle helmet on/off.',{{name = "action", help = "0 = remove, 1 = put on (if available)"}})
  TriggerEvent('chat:addSuggestion', '/mask', 'Toggle mask on/off.',{{name = "action", help = "0 = remove, 1 = put on (if available)"}})
  TriggerEvent('chat:addSuggestion', '/removemask', 'Remove the mask from the nearest person')
  TriggerEvent('chat:addSuggestion', '/setemote', 'Sets emote to keybind. To use emote once set (Insert + [keybind]).',{{name = "Key", help = "Select from (f1, f2, f3, f5, f6, f7, f9, f10, f11)"},{name = "Emote", help = "Use [/em list] for a available options"}})
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
