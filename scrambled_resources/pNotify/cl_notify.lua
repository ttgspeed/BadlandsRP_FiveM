--[[
Complete List of Options:
        type
        layout
        theme
        text
        timeout
        progressBar
        closeWith
        animation = {
            open
            close
        }
        sounds = {
            volume
            conditions
            sources
        }
        docTitle = {
            conditions
        }
        modal
        id
        force
        queue
        killer
        container
        buttons

More details below or visit the creators website http://ned.im/noty/options.html

Layouts:
    top
    topLeft
    topCenter
    topRight
    center
    centerLeft
    centerRight
    bottom
    bottomLeft
    bottomCenter
    bottomRight

Types:
    alert
    success
    error
    warning
    info

Themes: -- You can create more themes inside html/themes.css, use the gta theme as a template.
    gta
    mint
    relax
    metroui

Animations:
    open:
        noty_effects_open
        gta_effects_open
    close:
        noty_effects_close
        gta_effects_close

closeWith: -- array, You will probably never use this.
    click
    button

sounds:
    volume: 0.0 - 1.0
    conditions: -- array
        docVisible
        docHidden
    sources: -- array of sound files

modal:
    true
    false

force:
    true
    false

queue: -- default is global, you can make it what ever you want though.
    global

killer: -- will close all visible notification and show only this one
    true
    false

visit the creators website http://ned.im/noty/options.html for more information
--]]

function SetQueueMax(queue, max)
    local tmp = {
        queue = tostring(queue),
        max = tonumber(max)
    }

    SendNUIMessage({maxNotifications = tmp})
end

function SendNotification(options)
    local options = {
        type = options.type or "info",
        title = options.title or "Notification",
        text = options.text or "Empty Notification",
        timeout = options.timeout or 5000,
        buttons = options.button or false
    }

    SendNUIMessage({options = options})
end

RegisterNetEvent('1ce2a1c6-8967-482f-8442-30132c012b8c')
AddEventHandler('1ce2a1c6-8967-482f-8442-30132c012b8c', function(options)
    SendNotification(options)
end)

-- Citizen.CreateThread(function()
--   while true do
--     TriggerEvent('1ce2a1c6-8967-482f-8442-30132c012b8c', {title = "test", text = "hello world" , type = "info", timeout = 5000})
--     Citizen.Wait(2000)
--   end
-- end)

RegisterNetEvent('8eca5275-ba08-4673-90b2-fbc870748d81')
AddEventHandler('8eca5275-ba08-4673-90b2-fbc870748d81', function(queue, max)
    SetQueueMax(queue, max)
end)
