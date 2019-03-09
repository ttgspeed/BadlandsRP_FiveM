vRP = Proxy.getInterface("vRP")

-- NUI Variables
local DispatchOpen = false
local system = "dispatch"

-- Open Gui and Focus NUI
function openGui()
  SendNUIMessage({openDispatch = true})
  DispatchOpen = true
  SetNuiFocus(true, true)
  print("opengui")
end

-- Close Gui and disable NUI
function closeGui()
  SendNUIMessage({openDispatch = false})
  DispatchOpen = false
  SetNuiFocus(false, false)
  print("closegui")
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5000)
    if DispatchOpen == true then
      if system == "dispatch" then
        TriggerServerEvent("loadcalls", true)
      else
        TriggerServerEvent("loadcallsWanted", true)
      end
      print("call loadcalls")
    end
  end
end)

function round(num, numDecimalPlaces)
  local mult = 5^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

-- Disable controls while GUI open
Citizen.CreateThread(function()
  while true do
    if DispatchOpen then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisableControlAction(0, 24, active) -- Attack
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
    end
    Citizen.Wait(0)
  end
end)


-- NUI Callback Methods
RegisterNetEvent('LoadDispatchCalls')
AddEventHandler('LoadDispatchCalls', function(calldata, reload, system)
  if system == nil then
    system = "dispatch"
  end
  print("LoadDispatchCalls")
  SendNUIMessage({data = calldata})
  if reload == false then
    TriggerEvent('toggleDispatch')
  end
end)

RegisterNUICallback('respond', function(data, cb)
  if(data.class == "resolve") then
    TriggerServerEvent('resolvecall', data.resolveid)
  elseif (data.class == "gps") then
    TriggerServerEvent('gpstocall', data.resolveid)
  else
    TriggerServerEvent('respondtocall', data.resolveid)
  end
  TriggerServerEvent("loadcalls", true)
  cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNetEvent('LoadCalls')
AddEventHandler('LoadCalls', function(reload, faction, type)
  if type == nil then
    system = "dispatch"
  else
    system = type
  end
  print("LoadCalls")
  SendNUIMessage({faction = faction})
  if system == "dispatch" then
    TriggerServerEvent("loadcalls", reload)
  else
    TriggerServerEvent("loadcallsWanted", reload)
  end
end)

RegisterNetEvent('toggleDispatch')
AddEventHandler('toggleDispatch', function()
    if DispatchOpen then
      closeGui()
      DispatchOpen = false
    else
      openGui()
      DispatchOpen = true
    end
end)
