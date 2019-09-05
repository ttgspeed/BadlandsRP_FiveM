local cfg = module('hospital',"mythic/cfg/config")


local hospitalCheckinLoc = cfg.hospitalCheckin
local pillboxTeleports = cfg.pillboxTeleports
local bedTypes = cfg.bedTypes
local bedOccupying = nil
local bedOccupyingData = nil

local cam = nil

local inBedDict = "savecouch@"
local inBedAnim = "t_sleep_loop_couch"
local getOutDict = 'switch@franklin@bed'
local getOutAnim = 'sleep_getup_rubeyes'


function vRPhospital.isInHospitalBed()
  if bedOccupying == nil then
    return false
  end
  return true
end

RegisterNetEvent('mythic_hospital:client:togglePatientBed')
AddEventHandler('mythic_hospital:client:togglePatientBed', function()
  if bedOccupyingData == nil then
    TriggerServerEvent('mythic_hospital:server:RPRequestBed', GetEntityCoords(PlayerPedId()))
  else
    TriggerEvent('mythic_hospital:client:FinishServices')
  end
end)

function PrintHelpText(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function LeaveBed()
  RequestAnimDict(getOutDict)
  while not HasAnimDictLoaded(getOutDict) do
    Citizen.Wait(0)
  end

  --RenderScriptCams(0, true, 200, true, true)
  --DestroyCam(cam, false)
  --FreezeEntityPosition(PlayerPedId(), false)
  DetachEntity(GetPlayerPed(-1), true, true)
  SetEntityHeading(PlayerPedId(), bedOccupyingData.h - 90)
  TaskPlayAnim(PlayerPedId(), getOutDict , getOutAnim ,8.0, -8.0, -1, 0, 0, false, false, false )
  Citizen.Wait(5000)
  ClearPedTasks(PlayerPedId())
  --FreezeEntityPosition(PlayerPedId(), false)
  TriggerServerEvent('mythic_hospital:server:LeaveBed', bedOccupying)

  bedOccupying = nil
  bedOccupyingData = nil
end

RegisterNetEvent('mythic_hospital:client:RPCheckPos')
AddEventHandler('mythic_hospital:client:RPCheckPos', function()
    TriggerServerEvent('mythic_hospital:server:RPRequestBed', GetEntityCoords(PlayerPedId()))
end)

RegisterNetEvent('mythic_hospital:client:RPSendToBed')
AddEventHandler('mythic_hospital:client:RPSendToBed', function(id, data)
  bedOccupying = id
  bedOccupyingData = data

  SetEntityCoords(PlayerPedId(), data.x, data.y, data.z - 0.5)

  RequestAnimDict(inBedDict)
  while not HasAnimDictLoaded(inBedDict) do
    Citizen.Wait(0)
  end

  TaskPlayAnim(PlayerPedId(), inBedDict , inBedAnim ,8.0, -8.0, -1, 1, 0, false, false, false )
  SetEntityHeading(PlayerPedId(), data.h + 180)

  --cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
  --SetCamActive(cam, true)
  --RenderScriptCams(true, false, 1, true, true)
  --AttachCamToPedBone(cam, PlayerPedId(), 31085, 0, 0, 1.0 , true)
  --SetCamFov(cam, 90.0)
  --SetCamRot(cam, -90.0, 0.0, GetEntityHeading(PlayerPedId()) + 180, true)


  Citizen.CreateThread(function()
    while bedOccupyingData ~= nil do
      Citizen.Wait(1)
      PrintHelpText('Press ~INPUT_CONTEXT~ to get up')
      if IsControlJustReleased(0, 38) then
        if not vRP.isInComa({}) then
          LeaveBed()
        end
      end
    end
  end)
end)

RegisterNetEvent('mythic_hospital:client:SendToBed')
AddEventHandler('mythic_hospital:client:SendToBed', function(id, data)
  bedOccupying = id
  bedOccupyingData = data
  local pedCoords = GetEntityCoords(GetPlayerPed(-1))
  local closestBed = nil
  vertOffset = 0.9
  for k,v in pairs(bedTypes) do
    closestBed = GetClosestObjectOfType(data.x, data.y, data.z, 1.0, GetHashKey(v), false)
    if closestBed ~= 0 then
      if v == "v_med_emptybed" then
        vertOffset = 0.7
      end
      break
    end
  end
  if closestBed ~= 0 then
    AttachEntityToEntity(GetPlayerPed(-1), closestBed, GetPlayerPed(-1), 0, 0, vertOffset, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)
    --SetEntityCoords(PlayerPedId(), data.x, data.y, data.z - 0.3)
    RequestAnimDict(inBedDict)
    while not HasAnimDictLoaded(inBedDict) do
      Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), inBedDict , inBedAnim ,8.0, -8.0, -1, 1, 0, false, false, false )
    --SetEntityHeading(PlayerPedId(), data.h + 180)
    --FreezeEntityPosition(PlayerPedId(), true)
    --cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    --SetCamActive(cam, true)
    --RenderScriptCams(true, false, 1, true, true)
    --AttachCamToPedBone(cam, PlayerPedId(), 31085, 0, 0, 1.0 , true)
    --SetCamFov(cam, 90.0)
    --SetCamRot(cam, -90.0, 0.0, GetEntityHeading(PlayerPedId()) + 180, true)
    Citizen.CreateThread(function()
      while bedOccupyingData ~= nil do
        Citizen.Wait(0)
        headsUp('Press ~INPUT_CONTEXT~ to get back up')
        if IsControlJustReleased(0, 38) then
          if not vRP.isInComa({}) then
            TriggerEvent('mythic_hospital:client:FinishServices')
          end
        end
      end
    end)
    Citizen.CreateThread(function ()
      Citizen.Wait(5)
      local player = PlayerPedId()

      exports['mythic_scripts']:DoHudText('inform', 'Doctors Are Treating You')
      while bedOccupyingData ~= nil do
        Citizen.Wait(1000)
        currentHealth = GetEntityHealth(GetPlayerPed(-1))
        newHealth = currentHealth + 2
        if newHealth > 200 then
          newHealth = 200
        end
        SetEntityHealth(GetPlayerPed(-1),newHealth)
        if newHealth > 199 and vRP.isInComa({}) then
          -- TODO log revive event
          vRP.isRevived({})
        end
      end
      vRPserver.updateHealth({GetEntityHealth(GetPlayerPed(-1))})
    end)
  end
end)

RegisterNetEvent('mythic_hospital:client:FinishServices')
AddEventHandler('mythic_hospital:client:FinishServices', function()
  TriggerEvent('mythic_hospital:client:RemoveBleed')
  TriggerEvent('mythic_hospital:client:ResetLimbs')
  exports['mythic_scripts']:DoHudText('inform', 'You\'ve Been Treated')
  LeaveBed()
end)

RegisterNetEvent('mythic_hospital:client:ForceLeaveBed')
AddEventHandler('mythic_hospital:client:ForceLeaveBed', function()
    LeaveBed()
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    local distance = 0
    local hospitalCheckin = nil
    local plyCoords = GetEntityCoords(PlayerPedId(-1))
    for k,v in pairs(hospitalCheckinLoc) do
      distance = #(vector3(v.x, v.y, v.z) - vector3(plyCoords.x,plyCoords.y,plyCoords.z))
      if distance < 10 then
        hospitalCheckin = v
        break
      end
    end
    --local plyCoords = GetEntityCoords(PlayerPedId(), 0)
    --local distance = #(vector3(hospitalCheckin.x, hospitalCheckin.y, hospitalCheckin.z) - plyCoords)
    if distance < 10 and hospitalCheckin ~= nil then
      DrawMarker(27, hospitalCheckin.x, hospitalCheckin.y, hospitalCheckin.z - 0.99, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 1.0, 1, 157, 0, 155, false, false, 2, false, false, false, false)

      if not IsPedInAnyVehicle(PlayerPedId(), true) then
        if distance < 1 then
          PrintHelpText('Press ~INPUT_CONTEXT~ ~s~to check in')
          if IsControlJustReleased(0, 54) then
            if not vRP.isInComa({}) then
              if (GetEntityHealth(PlayerPedId()) < 200) or (IsInjuredOrBleeding()) then
                exports['mythic_scripts']:Progress({
                  name = "hospital_action",
                  duration = 10500,
                  label = "Checking In",
                  useWhileDead = false,
                  canCancel = true,
                  controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                  },
                  animation = {
                    animDict = "missheistdockssetup1clipboard@base",
                    anim = "base",
                    flags = 49,
                  },
                  prop = {
                    model = "p_amb_clipboard_01",
                    bone = 18905,
                    coords = { x = 0.10, y = 0.02, z = 0.08 },
                    rotation = { x = -80.0, y = 0.0, z = 0.0 },
                  },
                  propTwo = {
                    model = "prop_pencil_01",
                    bone = 58866,
                    coords = { x = 0.12, y = 0.0, z = 0.001 },
                    rotation = { x = -150.0, y = 0.0, z = 0.0 },
                  },
                }, function(status)
                  if not status then
                    TriggerServerEvent('mythic_hospital:server:RequestBed', hospitalCheckin.location)
                  end
                end)
              else
                exports['mythic_scripts']:DoHudText('error', 'You do not need medical attention')
                end
              end
            end
          end
        end
      else
        Citizen.Wait(1000)
      end
    end
end)

function headsUp(text)
  SetTextComponentFormat('STRING')
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
