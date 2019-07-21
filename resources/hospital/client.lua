vRP = Proxy.getInterface("vRP")
vRPhospital = {}
Tunnel.bindInterface("hospital",vRPhospital)
Proxy.addInterface("hospital",vRPhospital)
vRPserver = Tunnel.getInterface("vRP","vRP")
HospitalServer = Tunnel.getInterface("hospital","hospital")

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

local docped = {
  {type = 4, hash = 0xD47303AC, x = 278.3314819336, y = -1339.6945800782, z = 23.537815093994, a = 3374176},
}

Citizen.CreateThread(function()

  RequestModel(GetHashKey("s_m_m_doctor_01"))
  while not HasModelLoaded(GetHashKey("s_m_m_doctor_01")) do
    Wait(1)
  end

  RequestAnimDict("anim@amb@business@coc@coc_packing@")
  while not HasAnimDictLoaded("anim@amb@business@coc@coc_packing@") do
    Wait(1)
  end

  -- Spawn the Driving Ped
  for _, item in pairs(docped) do
    dmvmainped = CreatePed(item.type, item.hash, item.x, item.y, item.z, item.a, false, true)
    SetEntityHeading(dmvmainped, -36.73971939087)
    FreezeEntityPosition(dmvmainped, true)
    SetEntityInvincible(dmvmainped, true)
    SetBlockingOfNonTemporaryEvents(dmvmainped, true)
    TaskPlayAnim(dmvmainped, "anim@amb@business@coc@coc_packing@", "idle_v3_pressoperator", 8.0, 0.0, - 1, 1, 0, 0, 0, 0)
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

function vRPhospital.PutInMorgue(x, y, z, rot)
	Citizen.CreateThread(function()
		local ped = GetPlayerPed(-1)
		Citizen.Trace("PutInMorgue"..x..y..z)
		initialPosX, initialPosY, initialPosZ = table.unpack({308.48944091796,-594.73645019532,43.291820526124})
		wasRestrained = false
		vRP.setHandcuffed({false})

		DoScreenFadeOut(1000)
		Citizen.Wait(1000)

		SetEntityCollision(ped, false, false)
		FreezeEntityPosition(ped, true)
		vRP.teleport({x, y, z})
		vRP.playAnim({false,{{"mp_bedmid", "f_sleep_l_loop_bighouse", 1 }},true})

		-- play sound
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'ambulance', 0.1)
		Citizen.Wait(5000)
		DoScreenFadeIn(5000)
		Citizen.Trace("heading"..rot)
		SetEntityHeading(ped, rot)
		healtime = cfg.healdefault
		healed = 0
		needassist = 1
	end)
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
