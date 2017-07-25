AddEventHandler('onClientMapStart', function()
  Citizen.CreateThread(function()
    local display = true
    local startTime = GetGameTimer()
    local delay = 60000 -- ms
    local keepOpenTime = 45000

    TriggerEvent('disclaimer:display', true)

    while display do
      Citizen.Wait(1)
      if (GetTimeDifference(GetGameTimer(), startTime) > delay) then
        display = false
        TriggerEvent('disclaimer:display', false)
        tvRP.setFriendlyFire(false)
      end
      if (GetTimeDifference(GetGameTimer(), startTime) > keepOpenTime) then
        ShowInfo('~y~Read carefully.~w~ Press ~INPUT_CONTEXT~ to close.', 0)
        if (IsControlJustPressed(1, 51)) then
          display = false
          TriggerEvent('disclaimer:display', false)
          tvRP.setFriendlyFire(false)
        end
      else
        ShowInfo('~y~Read carefully.~w~ This window can be closed after 45 seconds.', 0)
        tvRP.setFriendlyFire(true)
      end
    end
  end)
end)

RegisterNetEvent('disclaimer:display')
AddEventHandler('disclaimer:display', function(value)
  SendNUIMessage({
    type = "disclaimer",
    display = value
  })
end)

function ShowInfo(text, state)
  SetTextComponentFormat("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, state, 0, -1)
end
