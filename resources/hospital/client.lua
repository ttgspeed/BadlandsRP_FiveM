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


 --------------------------------USEABLE BEDS-----------------------------------------------
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local InAction = false
local activeBedLoc = {}

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    for i=1, #Config.BedList do
      local bedID   = Config.BedList[i]
      local playerPos = GetEntityCoords(PlayerPedId())
      local distance = #(vector3(playerPos.x, playerPos.y, playerPos.z) - vector3(bedID.objCoords.x, bedID.objCoords.y, bedID.objCoords.z))
      if distance < Config.MaxDistance and InAction == false then
        vRP.drawText3Ds({bedID.text, bedID.objCoords.x, bedID.objCoords.y, bedID.objCoords.z + 1})
        if IsControlJustReleased(0, Keys['E']) then
          HospitalServer.initiateHealByFee({bedID.objCoords.x, bedID.objCoords.y, bedID.objCoords.z, bedID.heading})
          --[[
          local userId = vRP.getMyVrpId({})
          print(userId)
          vRPserver.tryDebitedPayment({userId,500}, function(ok)
            print("Got here")
            if ok then
              vRP.notify({"You paid $500 for medical services"})
              activeBedLoc = {x = bedID.objCoords.x, y = bedID.objCoords.y, z = bedID.objCoords.z}
              vRPhospital.bedActive(bedID.objCoords.x, bedID.objCoords.y, bedID.objCoords.z, bedID.heading, bedID)
            else
              vRP.notify({"You don't have enough money for medical services"})
            end
          end)
          ]]--
          break
        end
      end
    end
  end
end)

function vRPhospital.togglePatientBed()
  if not InAction then
    for i=1, #Config.BedList do
      local bedID   = Config.BedList[i]
      local distance = #(vector3(playerPos.x, playerPos.y, playerPos.z) - vector3(bedID.objCoords.x, bedID.objCoords.y, bedID.objCoords.z))
      if distance < Config.MaxDistance and InAction == false then
        activeBedLoc = {x = bedID.objCoords.x, y = bedID.objCoords.y, z = bedID.objCoords.z}
        vRPhospital.bedActive(bedID.objCoords.x, bedID.objCoords.y, bedID.objCoords.z, bedID.heading, bedID)
        break
      end
    end
  else
    ClearPedTasks(GetPlayerPed(-1))
    FreezeEntityPosition(GetPlayerPed(-1), false)
    SetEntityCoords(GetPlayerPed(-1), activeBedLoc.x + 1.0, activeBedLoc.y, activeBedLoc.z)
    InAction = false
  end
end

function vRPhospital.bedActive(x, y, z, heading)
  activeBedLoc = {x = x, y = y, z = z}
  SetEntityCoords(GetPlayerPed(-1), x, y, z + 0.3)
  RequestAnimDict('anim@gangops@morgue@table@')
  while not HasAnimDictLoaded('anim@gangops@morgue@table@') do
    Citizen.Wait(0)
  end
  TaskPlayAnim(GetPlayerPed(-1), 'anim@gangops@morgue@table@' , 'ko_front' ,8.0, -8.0, -1, 1, 0, false, false, false )
  SetEntityHeading(GetPlayerPed(-1), heading + 180.0)
  InAction = true
  Citizen.CreateThread(function()
    local timeSpent = 0
    local newHealth = 200
    while InAction do
      Citizen.Wait(1000)
      currentHealth = GetEntityHealth(GetPlayerPed(-1))
      newHealth = currentHealth + 2
      print("Current health = "..currentHealth.." newHealth = "..newHealth)
      if newHealth > 200 then
        newHealth = 200
      end
      SetEntityHealth(GetPlayerPed(-1),newHealth)
      if newHealth > 199 and vRP.isInComa({}) then
        HospitalServer.logHospitalRevive({"Pillbox"})
        vRP.isRevived({})
      end
    end
    vRPserver.updateHealth({newHealth})
  end)
  Citizen.CreateThread(function()
    while InAction do
      Citizen.Wait(0)
      if InAction == true then
        headsUp('Press ~INPUT_VEH_DUCK~ to get back up')
        if IsControlJustReleased(0, Keys['X']) then
          ClearPedTasks(GetPlayerPed(-1))
          FreezeEntityPosition(GetPlayerPed(-1), false)
          SetEntityCoords(GetPlayerPed(-1), x + 1.0, y, z)
          InAction = false
        end
      end
    end
  end)
end

function headsUp(text)
  SetTextComponentFormat('STRING')
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
