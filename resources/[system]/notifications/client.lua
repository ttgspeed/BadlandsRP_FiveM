RegisterNetEvent('notifications:1mWarning')
AddEventHandler('notifications:1mWarning', function()
  SetNuiFocus(true)
  SendNUIMessage({
      type = "enableui",
      enable = true
  })
  cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
    print("escape")
    SetNuiFocus(false)
    SendNUIMessage({
        type = "enableui",
        enable = false
    })
    cb('ok')
end)
