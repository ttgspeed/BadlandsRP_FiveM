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

--check if a given car is a taco lab
function isCartacoLab(carModel)
  for i,v in ipairs(tacoLabs) do
    if carModel == GetHashKey(v) then return true end
  end
  return false
end

--returns the car name
function getCarName(carModel)
  for i,v in ipairs(tacoLabs) do
    if carModel == GetHashKey(v) then return v end
  end
  return nil
end

--------------------------
--- Main client thread ---
--------------------------

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    local ped = GetPlayerPed(-1)
    local car = GetVehiclePedIsIn(ped, false)

    if car then
      if car ~= 0 and GetEntitySpeed(car) < 1 then
        local carModel = GetEntityModel(car)
        if isCartacoLab(carModel) then
          startOptions()
        end
      end
    end
  end
end)

--gives player the option to start the taco lab
function startOptions()
  while true do
    Citizen.Wait(10)
    local ped = GetPlayerPed(-1)
    local car = GetVehiclePedIsIn(ped, false)
    local vehicleId = NetworkGetNetworkIdFromEntity(car)
    istacoLab = false
    for k,v in pairs(activetacoLabs) do
      if k == vehicleId then istacoLab = true end
    end
    if car == 0 or GetEntitySpeed(car) > 1 or not istacoLab then break end
    DisplayHelpText("Press ~g~E~s~ to start cooking or ~g~Z~s~ to switch to the back")
    if IsControlJustReleased(1, Keys['E']) then
      local carModel = GetEntityModel(car)
      local carName = getCarName(carModel)
      currenttacoLab = vehicleId
      vRPserver.entertacoLab({vehicleId,carModel,carName})
      local x,y,z = table.unpack(GetEntityCoords(car,true))
      vRPserver.syncSmoke({vehicleId,true,x,y,z})
      vRPserver.syncPosition({vehicleId,x,y,z})
      startCooking()
      break
    end
    if IsControlJustReleased(1, Keys['Z']) then
      switchToBack()
      break
    end
  end
end

function startCooking()
  cookingtaco = true
  while cookingtaco do
    Citizen.Wait(10)
    local ped = GetPlayerPed(-1)
    local car = GetVehiclePedIsIn(ped, false)
    if car == 0 or GetEntitySpeed(car) > 1 then cookingtaco = false end
  end
  vRPserver.exittacoLab({currenttacoLab})
  vRPserver.syncSmoke({currenttacoLab,false})
  currenttacoLab = nil
end

function switchToBack()
  local ped = GetPlayerPed(-1)
  local vehicle = GetVehiclePedIsIn(ped, false)
  local vehiclePos = GetEntityCoords(car)
  SetEntityCoords(ped, vehiclePos.x, vehiclePos.y, vehiclePos.z, true, true, true)
  AttachEntityToEntity(ped, vehicle, GetEntityBoneIndexByName(vehicle, 'chassis'), 0.0, -0.9, 0.4, 0.0, 0.0,-90.0 , false, false, false, true, 2, true)
  SetVehicleDoorOpen(vehicle, 5, false, false)
  inBackofTruck = true
  while inBackofTruck do
    Citizen.Wait(10)
    if IsControlJustReleased(1, Keys['F']) then
      exitTruck(vehicle)
      break
    end
  end
end

function exitTruck(vehicle)
  local ped = GetPlayerPed(-1)
  local vehiclePos = GetEntityCoords(vehicle)
  SetEntityCoords(ped, vehiclePos.x - 0.5, vehiclePos.y, vehiclePos.z, true, true, true)
end
