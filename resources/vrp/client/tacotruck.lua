-----------------
--- Variables ---
-----------------

local tacoTruck = {}  --Holds local functions for this script

local tacoLabs = {
  "taco",
}
local Keys = {
  ["E"] = 38,
  ["Z"] = 20,
  ["F"] = 23
}
local smokes = {}    --tracks all the smoke particle effect currently playing

local activetacoLabs = {}
local currenttacoLab = nil    -- nil unless player is cooking taco
local cookingtaco = false
local inBackofTruck = false
local playerPed = nil
local selectedPed = nil
local vehicle = nil
local vehiclePos = nil
local pedsSoldTacos = {}

------------------------
--- Client Functions ---
------------------------

--tells the client that a vehicle is a taco lab
function tvRP.addtacoLab(vehicleId)
  activetacoLabs[vehicleId] = true
end

--tells the client that a vehicle is no longer a taco lab
function tvRP.removetacoLab(vehicleId)
  activetacoLabs[vehicleId] = nil
end

--adds smoke to a taco lab at a given position
function tvRP.addTacoSmoke(vehicleId,x,y,z)
  if smokes[vehicleId] == nil then smokes[vehicleId] = {} end
  if not HasNamedPtfxAssetLoaded("core") then
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded("core") do
      Wait(1)
    end
  end
  SetPtfxAssetNextCall("core")
  local part = StartParticleFxLoopedAtCoord("ent_amb_smoke_factory_white", x, y, z+2, 0.0,0.0,0.0,1.0, false, false, false)
  table.insert(smokes[vehicleId],part)
end

--removes the smoke from a taco lab
function tvRP.removeTacoSmoke(vehicleId)
  if smokes[vehicleId] ~= nil then
    RemoveParticleFx(table.remove(smokes[vehicleId]))
  end
end

--------------------------
--- Internal Functions ---
--------------------------

function tacoTruck.DisplayHelpText(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

--check if a given vehicle is a taco lab
function tacoTruck.isVehicleTacoLab(vehicleModel)
  for i,v in ipairs(tacoLabs) do
    if vehicleModel == GetHashKey(v) then return true end
  end
  return false
end

--returns the vehicle name
function tacoTruck.getVehicleName(vehicleModel)
  for i,v in ipairs(tacoLabs) do
    if vehicleModel == GetHashKey(v) then return v end
  end
  return nil
end

--------------------------
--- Main client thread ---
--------------------------

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    playerPed = GetPlayerPed(-1)
    vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle then
      if vehicle ~= 0 and GetEntitySpeed(vehicle) < 1 then
        local vehicleModel = GetEntityModel(vehicle)
        if tacoTruck.isVehicleTacoLab(vehicleModel) then
          tacoTruck.startOptions()
        end
      end
    end
  end
end)

--gives player the option to start the taco lab
function tacoTruck.startOptions()
  local vehicleId = NetworkGetNetworkIdFromEntity(vehicle)
  local istacoLab = false

  --double check this is an active taco truck
  for k,v in pairs(activetacoLabs) do
    if k == vehicleId then istacoLab = true end
  end

  if not istacoLab then return end

  while true do
    Citizen.Wait(0)

    --break loop if you're not still in the vehicle, not in the back or if the vehicle moves
    if (GetVehiclePedIsIn(playerPed, false) ~= vehicle and not inBackofTruck) or GetEntitySpeed(vehicle) > 1 then break end

    if not cookingtaco and not inBackofTruck then
      tacoTruck.DisplayHelpText("Press ~g~E~s~ to start cooking or ~g~Z~s~ to switch to the back")
    elseif cookingtaco and not inBackofTruck then
      tacoTruck.DisplayHelpText("Press ~g~Z~s~ to switch to the back")
    elseif not cookingtaco and inBackofTruck then
      tacoTruck.DisplayHelpText("Press ~g~E~s~ to start cooking")
    end

    if not cookingtaco and IsControlJustReleased(1, Keys['E']) then
      local vehicleModel = GetEntityModel(vehicle)
      local vehicleName = tacoTruck.getVehicleName(vehicleModel)
      currenttacoLab = vehicleId
      cookingtaco = true
      vRPserver.entertacoLab({vehicleId,vehicleModel,vehicleName})
      local x,y,z = table.unpack(GetEntityCoords(vehicle,true))
      vRPserver.syncTacoSmoke({vehicleId,true,x,y,z})
      vRPserver.syncTacoTruckPosition({vehicleId,x,y,z})
      tacoTruck.startCooking()
    end
    if not inBackofTruck and IsControlJustReleased(1, Keys['Z']) then
      inBackofTruck = true
      vRPserver.enterBackOfTruck({vehicleId},function(ok)
        if ok then tacoTruck.switchToBack() end
      end)
    end
  end
end

function tacoTruck.startCooking()
  Citizen.CreateThread(function()
    while cookingtaco do
      Citizen.Wait(10)
      if (GetVehiclePedIsIn(playerPed, false) ~= vehicle and not inBackofTruck) or GetEntitySpeed(vehicle) > 1 then cookingtaco = false end
      if IsControlJustReleased(1, Keys['E']) then
        Citizen.Wait(500)
        cookingtaco = false
      end
    end
    vRPserver.exittacoLab({currenttacoLab})
    vRPserver.syncTacoSmoke({currenttacoLab,false})
    currenttacoLab = nil
  end)
end

function tacoTruck.switchToBack()
  print("Switched to back")
  vehiclePos = GetEntityCoords(vehicle)
  local vehicleId = NetworkGetNetworkIdFromEntity(vehicle)
  SetEntityCoords(playerPed, vehiclePos.x, vehiclePos.y, vehiclePos.z, true, true, true)
  AttachEntityToEntity(playerPed, vehicle, GetEntityBoneIndexByName(vehicle, 'chassis'), 0.0, -0.9, 0.4, 0.0, 0.0,-90.0 , false, false, false, true, 2, true)
  SetVehicleDoorOpen(vehicle, 5, false, false)

  Citizen.CreateThread(function()
    Citizen.Wait(100)

    while inBackofTruck do
      tacoTruck.selectPed()
      local good = tacoTruck.waitForPed()

      if good then
        ClearPedTasks(selectedPed)
        TaskTurnPedToFaceEntity(selectedPed, playerPed, -1)
        Citizen.Wait(5000)
        tacoTruck.sellTaco()
        Citizen.Wait(5000)
      end
    end

  end)

  Citizen.CreateThread(function()
    while inBackofTruck do
      Citizen.Wait(1)

      if IsControlJustReleased(1, Keys['F']) then
        SetEntityCoords(playerPed, vehiclePos.x - 2, vehiclePos.y, vehiclePos.z, true, true, true)
        inBackofTruck = false
        vRPserver.exitBackofTacoTruck({vehicleId})
        break
      end
      if not IsEntityAttachedToEntity(playerPed,vehicle) then
        inBackofTruck = false
        vRPserver.exitBackofTacoTruck({vehicleId})
        break
      end
      if not IsVehicleDoorFullyOpen(vehicle, 5) then
        SetVehicleDoorOpen(vehicle, 5, false, false)
      end

    end
  end)
end

function tacoTruck.selectPed()
  print("Finding ped...")
  selectedPed = nil
  while selectedPed == nil or selectedPed == playerPed or selectedPed == 0 or pedsSoldTacos[selectedPed] do
    selectedPed = GetRandomPedAtCoord(vehiclePos.x, vehiclePos.y,vehiclePos.z, 100.0, 100.0, 20.0, 26)
    Citizen.Wait(10)
  end
  SetEntityAsMissionEntity(selectedPed)
  pedsSoldTacos[selectedPed] = true
  print("Ped found.")
end

function tacoTruck.waitForPed()
  print("Waiting for ped to arrive...")
  local offsetCoords = GetOffsetFromEntityInWorldCoords(vehicle,2.5,0.0,0.0)
  TaskFollowNavMeshToCoord(selectedPed, offsetCoords.x, offsetCoords.y, offsetCoords.z, 1.0, -1, 1.0, true, 0.0)

  local pedPos = GetEntityCoords(selectedPed)
  local distance = GetDistanceBetweenCoords(offsetCoords.x, offsetCoords.y,offsetCoords.z, pedPos.x,pedPos.y,pedPos.z)
  local good = true
  local timeout = 0

  --playerPed incoming
  while distance > 1 do
    Citizen.Wait(100)
    --SetVehicleDoorOpen(vehicle, 5, false, false)
    pedPos = GetEntityCoords(selectedPed)
    distance = GetDistanceBetweenCoords(offsetCoords.x, offsetCoords.y,offsetCoords.z, pedPos.x,pedPos.y,pedPos.z)
    if not inBackofTruck or GetEntitySpeed(vehicle) > 1 then  --stop playerPed if you're no longer in back of truck or the vehicle moves
      tacoTruck.clearPed(selectedPed)
      print("No longer in back of truck, or vehicle moved. Exiting thread.")
      return
    end
    if timeout > 120 then
      tacoTruck.clearPed(selectedPed)
      good = false
      break
    end
    timeout = timeout + 0.1 --timeout because peds are stupid and get stuck sometimes
  end

  print("Ped arrived, or timeout.")
  return good
end

function tacoTruck.sellTaco()
  vRPserver.sellNpcTaco({},function(sold)
    if sold then
      RequestAnimDict("mp_common")
      while (not HasAnimDictLoaded("mp_common")) do
        Citizen.Wait(1)
      end
      RequestAnimDict("missfbi_s4mop")
      while (not HasAnimDictLoaded("missfbi_s4mop")) do
        Citizen.Wait(1)
      end
      tvRP.playAnim(true, {{"mp_common","givetake2_a",1}}, false)
      TaskPlayAnim(selectedPed,"mp_common","givetake2_a",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
      Citizen.Wait(1000)
      tacoTruck.clearPed(selectedPed)
      print("Tacos sold.")
    else
      tacoTruck.clearPed(selectedPed)
      print("Tacos not sold")
    end
  end)
  Citizen.Wait(5000)  --Wait for callback to finish
end

function tacoTruck.clearPed(ped)
  ClearPedTasks(ped)
  SetPedAsNoLongerNeeded(ped)
  TaskWanderInArea(ped, vehiclePos.x, vehiclePos.y, vehiclePos.z, 100, 300, 1)
end
