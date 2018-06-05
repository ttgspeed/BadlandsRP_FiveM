---------------------------------------------------------------
-- Selfie/Camera mode -- START
---------------------------------------------------------------
-- Source https://forum.fivem.net/t/release-cellphone-camera/43599

phone = false
phoneId = 0
handcuffed = false

RegisterNetEvent('c1068f26-5ece-431b-8f3e-17a2432d4c87')
AddEventHandler('c1068f26-5ece-431b-8f3e-17a2432d4c87', function(flag)
  handcuffed = flag
end)

local function chatMessage(msg)
  TriggerEvent('chatMessage', '', {0, 0, 0}, msg)
end

phones = {
  [0] = "Michael's",
  [1] = "Trevor's",
  [2] = "Franklin's",
  [4] = "Prologue"
}

RegisterNetEvent('4f1fa80b-54d7-4978-9647-16e0839cafe4')
AddEventHandler('4f1fa80b-54d7-4978-9647-16e0839cafe4', function(message)
  local id = tonumber(string.sub(message, 7, 8))

  if id == 0 or id == 1 or id == 2 or id == 4 then
    ChangePhone(id)
  else
    chatMessage("^1/phone [ID]")
    chatMessage("^10 - Michael's phone")
    chatMessage("^11 - Trevor's phone")
    chatMessage("^12 - Franklin's phone")
    chatMessage("^14 - Prologue phone")
  end
end)

function ChangePhone(flag)
  if flag == 0 or flag == 1 or flag == 2 or flag == 4 then
    phoneId = flag
    chatMessage("^2Changed phone to "..phones[flag].." phone")
  end
end

frontCam = false

function CellFrontCamActivate(activate)
  return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

TakePhoto = N_0xa67c35c56eb1bd9d
WasPhotoTaken = N_0x0d6ca79eeebd8ca3
SavePhoto = N_0x3dec726c25a11bac
ClearPhoto = N_0xd801cc02177fa3f1

Citizen.CreateThread(function()
  DestroyMobilePhone()
  while true do
    Citizen.Wait(0)
    local ped = GetPlayerPed(-1)

    if IsControlJustPressed(0, 170) and phone == true then -- SELFIE MODE
      frontCam = not frontCam
      CellFrontCamActivate(frontCam)
    end

    if IsControlJustPressed(0, 170) then -- OPEN PHONE
      CreateMobilePhone(phoneId)
      CellCamActivate(true, true)
      phone = true
      DisplayRadar(false)
      TriggerEvent('e7db8035-879c-4a27-a13d-cb703b5a581a',false)
    end

    if IsControlJustPressed(0, 177) and phone == true then -- CLOSE PHONE
      DestroyMobilePhone()
      phone = false
      DisplayRadar(true)
      TriggerEvent('e7db8035-879c-4a27-a13d-cb703b5a581a',true)
      CellCamActivate(false, false)
      if firstTime == true then
        firstTime = false
        Citizen.Wait(2500)
        displayDoneMission = true
      end
    end

    if phone == true then
      if handcuffed == true then
        DestroyMobilePhone()
        phone = false
        TriggerEvent('e7db8035-879c-4a27-a13d-cb703b5a581a',true)
        CellCamActivate(false, false)
        if firstTime == true then
          firstTime = false
          Citizen.Wait(2500)
          displayDoneMission = true
        end
      else
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(8)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(19)
      end
    end

    -- If hold F while getting out of vehicle, door will stay open
    -- https://github.com/ToastinYou/KeepMyDoorOpen
    if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
      Citizen.Wait(150)
      if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
        local veh = GetVehiclePedIsIn(ped, false)
        TaskLeaveVehicle(ped, veh, 256)
      end
    end
  end
end)
---------------------------------------------------------------
-- Selfie/Camera mode -- END
---------------------------------------------------------------
