local restart_notice_displayed = false

RegisterNetEvent('ca555a3c-ba1e-4d45-9755-6c42a2085138')
AddEventHandler('ca555a3c-ba1e-4d45-9755-6c42a2085138', function()
  restart_notice_displayed = true
  Citizen.CreateThread(function()
    while restart_notice_displayed do
      Citizen.Wait(1)
      DisableControlAction(0,24,true) -- disable attack
      DisableControlAction(0,25,true) -- disable aim
      DisableControlAction(0,47,true) -- disable weapon
      DisableControlAction(0,58,true) -- disable weapon
      DisableControlAction(0,263,true) -- disable melee
      DisableControlAction(0,264,true) -- disable melee
      DisableControlAction(0,257,true) -- disable melee
      DisableControlAction(0,140,true) -- disable melee
      DisableControlAction(0,141,true) -- disable melee
      DisableControlAction(0,142,true) -- disable melee
      DisableControlAction(0,143,true) -- disable melee
      DisableControlAction(0,47,true) -- disable weapon
      DisableControlAction(0,58,true) -- disable weapon
      DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
    end
  end)
  SetNuiFocus(true)
  SendNUIMessage({
      type = "enableui",
      enable = true
  })
  cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
    restart_notice_displayed = false
    print("escape")
    SetNuiFocus(false)
    SendNUIMessage({
        type = "enableui",
        enable = false
    })
    cb('ok')
end)
