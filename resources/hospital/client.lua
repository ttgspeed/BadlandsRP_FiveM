vRP = Proxy.getInterface("vRP")

-- Settings
local healtime = 0 --seconds
local healed = 0
local needassist = 0
local wasRestrained = false
local initialPosX = 0
local initialPosY = 0
local initialPosZ = 0

-- NUI Variables

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
  SetTextFont(0)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x - width/2, y - height/2 + 0.005)
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if healtime > 0 then
      drawTxt(0.85, 1.35, 1.0,1.0,0.4, "~w~You're being rescuscitated. Give the doctors ~y~" .. healtime .. "~w~ seconds.", 255, 255, 255, 255)
      if healtime == 5 then
        DoScreenFadeOut(5000)
      end
    else
      if healed == 0 and needassist == 1 then
        TriggerEvent("hospital:Revived")
      end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    if healtime > 0 then
      healtime = healtime-1
    end
  end
end)

RegisterNetEvent('hospital:PutInBed')
AddEventHandler('hospital:PutInBed', function()
  local ped = GetPlayerPed(-1)
  initialPosX, initialPosY, initialPosZ = table.unpack(GetEntityCoords(ped,true))
  wasRestrained = vRP.isHandcuffed({})
  if wasRestrained then
    vRP.setHandcuffed({false})
  end
  vRP.teleport({347.84378051758,-595.49896240234,28.0001})
  vRP.playAnim({false,{{"mp_bedmid", "f_sleep_l_loop_bighouse", 1 }},true})
  SetEntityCollision(ped, false, false)
  FreezeEntityPosition(ped, true)
  SetEntityHeading(ped, 238.21)
  healtime = 30
  healed = 0
  needassist = 1
end)

RegisterNetEvent('hospital:Revived')
AddEventHandler('hospital:Revived', function()
  local ped = GetPlayerPed(-1)
  SetEntityCollision(ped, true, true)
  FreezeEntityPosition(ped, false)
  ClearPedTasks(GetPlayerPed(-1))
  if wasRestrained then
    vRP.setHandcuffed({true})
  end
  ClearPedTasks(GetPlayerPed(-1))
  SetEntityCoords(ped, initialPosX, initialPosY, initialPosZ)
  SetEntityHeading(ped, 238.21)
  vRP.varyHealth({100}) -- heal 100 full health
  vRP.isRevived({})
  healtime = 0
  healed = 1
  needassist = 0
  wasRestrained = false
  initialPosX = 0
  initialPosY = 0
  initialPosZ = 0
  DoScreenFadeIn(5000)
end)
