vRP = Proxy.getInterface("vRP")
vRPhospital = {}
Tunnel.bindInterface("hospital",vRPhospital)
Proxy.addInterface("hospital",vRPhospital)

local cfg = {}

cfg.healdefault = 30 -- adjustable to how long revive takes
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

function vRPhospital.inHospitalBed()
  if healtime > 0 then
    return true
  end
  return false
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
        Revived()
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

function vRPhospital.PutInBed(x, y, z, rot)
  local ped = GetPlayerPed(-1)
  Citizen.Trace("PutInBed"..x..y..z)
  initialPosX, initialPosY, initialPosZ = table.unpack(GetEntityCoords(ped,true))
  wasRestrained = vRP.isHandcuffed({})
  if wasRestrained then
    vRP.setHandcuffed({false})
  end
  vRP.teleport({x, y, z})
  vRP.playAnim({false,{{"mp_bedmid", "f_sleep_l_loop_bighouse", 1 }},true})
  SetEntityCollision(ped, false, false)
  FreezeEntityPosition(ped, true)
  Citizen.Trace("heading"..rot)
  SetEntityHeading(ped, rot)
  healtime = cfg.healdefault
  healed = 0
  needassist = 1
end

function Revived()
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
end
