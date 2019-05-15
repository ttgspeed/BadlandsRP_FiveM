-----------------
--- Variables ---
-----------------

tacoLabs = {
  "taco",
}
local Keys = {
  ["E"] = 38,
  ["Z"] = 20,
  ["F"] = 23
}
local smokes = {}    --tracks all the smoke particle effect currently playing

activetacoLabs = {}
local currenttacoLab = nil    -- nil unless player is cooking taco
local cookingtaco = false
local inBackofTruck = false
local ped = nil
local vehicle = nil

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
function tvRP.addSmoke(vehicleId,x,y,z)
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
function tvRP.removeSmoke(vehicleId)
  if smokes[vehicleId] ~= nil then
    RemoveParticleFx(table.remove(smokes[vehicleId]))
  end
end

--------------------------
--- Internal Functions ---
--------------------------

function DisplayHelpText(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

--check if a given vehicle is a taco lab
function isvehicletacoLab(vehicleModel)
  for i,v in ipairs(tacoLabs) do
    if vehicleModel == GetHashKey(v) then return true end
  end
  return false
end

--returns the vehicle name
function getvehicleName(vehicleModel)
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
    ped = GetPlayerPed(-1)
    vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle then
      if vehicle ~= 0 and GetEntitySpeed(vehicle) < 1 then
        local vehicleModel = GetEntityModel(vehicle)
        if isvehicletacoLab(vehicleModel) then
          startOptions()
        end
      end
    end
  end
end)

--gives player the option to start the taco lab
function startOptions()
  local vehicleId = NetworkGetNetworkIdFromEntity(vehicle)
  local istacoLab = false

  --double check this is an active taco truck
  for k,v in pairs(activetacoLabs) do
    if k == vehicleId then istacoLab = true end
  end

  if not istacoLab then return end

  while true do
    Citizen.Wait(10)

    --break loop if you're not still in the vehicle, not in the back or if the vehicle moves
    if (GetVehiclePedIsIn(ped, false) ~= vehicle and not inBackofTruck) or GetEntitySpeed(vehicle) > 1 then break end

    if not cookingtaco and not inBackofTruck then
      DisplayHelpText("Press ~g~E~s~ to start cooking or ~g~Z~s~ to switch to the back")
    elseif cookingtaco and not inBackofTruck then
      DisplayHelpText("Press ~g~Z~s~ to switch to the back")
    elseif not cookingtaco and inBackofTruck then
      DisplayHelpText("Press ~g~E~s~ to start cooking")
    end

    if not cookingtaco and IsControlJustReleased(1, Keys['E']) then
      local vehicleModel = GetEntityModel(vehicle)
      local vehicleName = getvehicleName(vehicleModel)
      currenttacoLab = vehicleId
      vRPserver.entertacoLab({vehicleId,vehicleModel,vehicleName})
      local x,y,z = table.unpack(GetEntityCoords(vehicle,true))
      vRPserver.syncSmoke({vehicleId,true,x,y,z})
      vRPserver.syncPosition({vehicleId,x,y,z})
      Citizen.CreateThread(function() startCooking() end)
    end
    if not inBackofTruck and IsControlJustReleased(1, Keys['Z']) then
      vRPserver.enterBackOfTruck({vehicleId},function(ok)
        if ok then Citizen.CreateThread(function() switchToBack() end) end
      end)
    end
  end
end

function startCooking()

  cookingtaco = true
  while cookingtaco do
    Citizen.Wait(10)
    if (GetVehiclePedIsIn(ped, false) ~= vehicle and not inBackofTruck) or GetEntitySpeed(vehicle) > 1 then cookingtaco = false end
    if IsControlJustReleased(1, Keys['E']) then
      Citizen.Wait(500)
      cookingtaco = false
    end
  end
  vRPserver.exittacoLab({currenttacoLab})
  vRPserver.syncSmoke({currenttacoLab,false})
  currenttacoLab = nil
end

function switchToBack()
  local vehiclePos = GetEntityCoords(vehicle)
  local vehicleId = NetworkGetNetworkIdFromEntity(vehicle)
  SetEntityCoords(ped, vehiclePos.x, vehiclePos.y, vehiclePos.z, true, true, true)
  AttachEntityToEntity(ped, vehicle, GetEntityBoneIndexByName(vehicle, 'chassis'), 0.0, -0.9, 0.4, 0.0, 0.0,-90.0 , false, false, false, true, 2, true)
  SetVehicleDoorOpen(vehicle, 5, false, false)

  inBackofTruck = true

  Citizen.CreateThread(function()
    Citizen.Wait(100)

    RequestAnimDict("mp_common")
    while (not HasAnimDictLoaded("mp_common")) do
      Citizen.Wait(0)
    end
    RequestAnimDict("missfbi_s4mop")
    while (not HasAnimDictLoaded("missfbi_s4mop")) do
      Citizen.Wait(0)
    end

    while inBackofTruck do
      local selectedPed = ped
      while selectedPed == ped or selectedPed == 0 or selectedPed == nil do
        selectedPed = GetRandomPedAtCoord(vehiclePos.x, vehiclePos.y,vehiclePos.z, 100.0, 100.0, 20.0, 26)
      end
      SetEntityAsMissionEntity(selectedPed)
      --TaskCower(selectedPed, 666666)
      local offsetCoords = GetOffsetFromEntityInWorldCoords(vehicle,2.5,0.0,0.0)
      --TaskGoStraightToCoord(selectedPed, offsetCoords.x, offsetCoords.y,offsetCoords.z, 1.0, -1, 0.0, -0.1)
      TaskFollowNavMeshToCoord(selectedPed, offsetCoords.x, offsetCoords.y, offsetCoords.z, 1.0, -1, 1.0, true, 0.0)

      local pedPos = GetEntityCoords(selectedPed)
      local distance = GetDistanceBetweenCoords(offsetCoords.x, offsetCoords.y,offsetCoords.z, pedPos.x,pedPos.y,pedPos.z)
      local good = true
      timeout = 0

      --PED incoming
      while distance > 1 do
        Citizen.Wait(100)
        pedPos = GetEntityCoords(selectedPed)
        distance = GetDistanceBetweenCoords(offsetCoords.x, offsetCoords.y,offsetCoords.z, pedPos.x,pedPos.y,pedPos.z)
        if not inBackofTruck or GetEntitySpeed(vehicle) > 1 then  --stop ped if you're no longer in back of truck or the vehicle moves
          ClearPedTasks(selectedPed)
          SetPedAsNoLongerNeeded(selectedPed)
          return
        end
        if timeout > 120 then
          ClearPedTasks(selectedPed)
          SetPedAsNoLongerNeeded(selectedPed)
          good = false
          break
        end
        timeout = timeout + 0.1 --timeout because peds are stupid and get stuck sometimes
      end

      if good then
        ClearPedTasks(selectedPed)
        --TaskLookAtCoord(selectedPed, vehiclePos.x, vehiclePos.y, vehiclePos.z, 100.0, 0, 0)
        TaskTurnPedToFaceEntity(selectedPed, ped, -1)
        Citizen.Wait(5000)

        vRPserver.sellNpcTaco({},function(sold)
          if sold then
            tvRP.playAnim(true, {{"mp_common","givetake2_a",1}}, false)
            TaskPlayAnim(selectedPed,"mp_common","givetake2_a",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            Citizen.Wait(1000)
            ClearPedTasks(selectedPed)
            SetPedAsNoLongerNeeded(selectedPed)
          else
            ClearPedTasks(selectedPed)
            SetPedAsNoLongerNeeded(selectedPed)
          end
        end)
      end
    end

  end)

  while inBackofTruck do
    Citizen.Wait(0)

    if IsControlJustReleased(1, Keys['F']) then
      SetEntityCoords(ped, vehiclePos.x - 2, vehiclePos.y, vehiclePos.z, true, true, true)
      inBackofTruck = false
      vRPserver.exitBackofTacoTruck({vehicleId})
      break
    end
    if not IsEntityAttachedToEntity(ped,vehicle) then
      inBackofTruck = false
      vRPserver.exitBackofTacoTruck({vehicleId})
      break
    end


  end
end
