-----------------
--- Variables ---
-----------------

local meth = {}  --Holds local functions for this script

local methLabs = {
  "camper",
  "journey"
}
local Keys = {
  ["E"] = 38
}
local smokes = {}    --tracks all the smoke particle effect currently playing

local activeMethLabs = {}
local currentMethLab = nil    -- nil unless player is cooking meth
local cookingMeth = false

------------------------
--- Client Functions ---
------------------------

--tells the client that a vehicle is a meth lab
function tvRP.addMethLab(vehicleId)
  activeMethLabs[vehicleId] = true
end

--tells the client that a vehicle is no longer a meth lab
function tvRP.removeMethLab(vehicleId)
  activeMethLabs[vehicleId] = nil
end

--adds smoke to a meth lab at a given position
function tvRP.addMethSmoke(vehicleId,x,y,z)
  if smokes[vehicleId] == nil then smokes[vehicleId] = {} end
  if not HasNamedPtfxAssetLoaded("core") then
    RequestNamedPtfxAsset("core")
    while not HasNamedPtfxAssetLoaded("core") do
      Wait(1)
    end
  end
  SetPtfxAssetNextCall("core")
  local part = StartParticleFxLoopedAtCoord("ent_amb_smoke_foundry", x, y, z+2, 0.0,0.0,0.0,1.0, false, false, false)
  table.insert(smokes[vehicleId],part)
end

--removes the smoke from a meth lab
function tvRP.removeMethSmoke(vehicleId)
  if smokes[vehicleId] ~= nil then
    RemoveParticleFx(table.remove(smokes[vehicleId]))
  end
end

--------------------------
--- Internal Functions ---
--------------------------

function meth.DisplayHelpText(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

--check if a given car is a meth lab
function meth.isCarMethLab(carModel)
  for i,v in ipairs(methLabs) do
    if carModel == GetHashKey(v) then return true end
  end
  return false
end

--returns the car name
function meth.getCarName(carModel)
  for i,v in ipairs(methLabs) do
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
        if meth.isCarMethLab(carModel) then
          meth.startOptions()
        end
      end
    end
  end
end)

--gives player the option to start the meth lab
function meth.startOptions()
  while true do
    Citizen.Wait(1)
    local ped = GetPlayerPed(-1)
    local car = GetVehiclePedIsIn(ped, false)
    local vehicleId = NetworkGetNetworkIdFromEntity(car)
    local isMethLab = false
    for k,v in pairs(activeMethLabs) do
      if k == vehicleId then isMethLab = true end
    end
    if car == 0 or GetEntitySpeed(car) > 1 or not isMethLab then break end
    meth.DisplayHelpText("Press ~g~E~s~ to start cooking")
    if IsControlJustReleased(1, Keys['E']) then
      local carModel = GetEntityModel(car)
      local carName = meth.getCarName(carModel)
      currentMethLab = vehicleId
      vRPserver.enterMethLab({vehicleId,carModel,carName})
      local x,y,z = table.unpack(GetEntityCoords(car,true))
      vRPserver.syncMethSmoke({vehicleId,true,x,y,z})
      vRPserver.syncMethLabPosition({vehicleId,x,y,z})
      meth.startCooking()
      break
    end
  end
end

function meth.startCooking()
  print("Started cooking meth")
  cookingMeth = true
  while cookingMeth do
    Citizen.Wait(10)
    local ped = GetPlayerPed(-1)
    local car = GetVehiclePedIsIn(ped, false)
    if car == nil or car == 0 or GetEntitySpeed(car) > 1 then cookingMeth = false end
  end
  vRPserver.exitMethLab({currentMethLab})
  vRPserver.syncMethSmoke({currentMethLab,false})
  currentMethLab = nil
end
