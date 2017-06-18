
local vehicles = {}

function tvRP.spawnGarageVehicle(vtype,name,options) -- vtype is the vehicle type (one vehicle per type allowed at the same time)

  local vehicle = vehicles[name]
  if vehicle and not IsVehicleDriveable(vehicle[3]) then -- precheck if vehicle is undriveable
    -- despawn vehicle
    SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle[3]))
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle[3]))
    vehicles[name] = nil
  end

  vehicle = vehicles[name]
  if vehicle == nil then
    -- load vehicle model
    local mhash = GetHashKey(name)

    local i = 0
    while not HasModelLoaded(mhash) and i < 10000 do
      RequestModel(mhash)
      Citizen.Wait(10)
      i = i+1
    end

    -- spawn car
    if HasModelLoaded(mhash) then
      local x,y,z = tvRP.getPosition()
      local veh = CreateVehicle(mhash, x,y,z+0.5, 0.0, true, false)
      spawnedVehicle = NetworkGetNetworkIdFromEntity(veh);
      SetVehicleOnGroundProperly(veh)
      SetEntityInvincible(veh,false)
      SetPedIntoVehicle(GetPlayerPed(-1),veh,-1) -- put player inside
      SetVehicleNumberPlateText(veh, "P "..tvRP.getRegistrationNumber())
      Citizen.InvokeNative(0xAD738C3085FE7E11, nveh, true, true) -- set as mission entity

      SetVehicleModKit(veh, 0)
      if name ~= "police" and name ~= "police2" and name ~= "police3" and name ~= "police4" and name ~= "policet" and name ~= "policeb" and name ~= "ambulance" and name ~= "firetruk" and name ~= "taxi" then
        SetVehicleModColor_1(veh, 0, 0, 0)
        SetVehicleModColor_2(veh, 0, 0, 0)
        SetVehicleColours(veh, tonumber(options.main_colour), tonumber(options.secondary_colour))
        SetVehicleExtraColours(veh, tonumber(options.ecolor), tonumber(options.ecolorextra))
      end
      --SetVehicleNumberPlateText(veh, options.plate)
      SetVehicleWindowTint(veh, options.windows)
      SetVehicleNumberPlateTextIndex(veh, options.platetype)
      SetVehicleDirtLevel(veh, 0)
      SetVehicleEngineOn(veh, true, true)

      if options.mods then
        options.mods = json.decode(options.mods)
        if type(options.mods) == "table" then
          for k,v in pairs(options.mods) do
            --support toggle mods like headlights/turbo
            if k == "18" or k == "22" then
              ToggleVehicleMod(veh, tonumber(k), tonumber(v.mod))
            elseif k == "23" then
              SetVehicleMod(veh,tonumber(k),tonumber(v.mod),true)
              SetVehicleWheelType(veh, tonumber(options.wheels))
            else
              SetVehicleMod(veh,tonumber(k),tonumber(v.mod),true)
            end
          end
        end
      end

      vehicles[name] = {vtype,name,veh} -- set current vehicule

  		local blip = AddBlipForEntity(veh)
  		SetBlipSprite(blip, 225)

      SetModelAsNoLongerNeeded(mhash)
    end
  else
    tvRP.notify("You can only have one "..name.." vehicle out.")
  end
end

function tvRP.despawnGarageVehicle(vtype,max_range)
  for types,vehicle in pairs(vehicles) do
		local x,y,z = table.unpack(GetEntityCoords(vehicle[3],true))
		local px,py,pz = tvRP.getPosition()

		if GetDistanceBetweenCoords(x,y,z,px,py,pz,true) < max_range then -- check distance with the vehicule
		  -- remove vehicle
      SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle[3]))
		  Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle[3]))
		  vehicles[types] = nil
		  tvRP.notify("Your vehicle has been stored in the garage.")
		  break
		else
		  tvRP.notify("Too far away from the vehicle.")
		end
	  end
end

-- (experimental) this function return the nearest vehicle
-- (don't work with all vehicles, but aim to)
function tvRP.getNearestVehicle(radius)
  local x,y,z = tvRP.getPosition()
  local ped = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ped) then
    return GetVehiclePedIsIn(ped, true)
  else
    -- flags used:
    --- 8192: boat
    --- 4096: helicos
    --- 4,2,1: cars (with police)

    local veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 8192+4096+4+2+1)  -- boats, helicos
    if not IsEntityAVehicle(veh) then veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 4+2+1) end -- cars
    return veh
  end
end

-- try to get a vehicle at a specific position (using raycast)
function tvRP.getVehicleAtPosition(x,y,z)
  x = x+0.0001
  y = y+0.0001
  z = z+0.0001

  local ray = CastRayPointToPoint(x,y,z,x,y,z+4,10,GetPlayerPed(-1),0)
  local a, b, c, d, ent = GetRaycastResult(ray)
  return ent
end

-- return ok,vtype,name
function tvRP.getNearestOwnedVehicle(radius)
  local px,py,pz = tvRP.getPosition()
  for k,v in pairs(vehicles) do
    local x,y,z = table.unpack(GetEntityCoords(v[3],true))
    local dist = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
    if dist <= radius+0.0001 then return true,v[1],v[2] end
  end

  return false,"",""
end

-- return ok,x,y,z
function tvRP.getAnyOwnedVehiclePosition()
  for k,v in pairs(vehicles) do
    if IsEntityAVehicle(v[3]) then
      local x,y,z = table.unpack(GetEntityCoords(v[3],true))
      return true,x,y,z
    end
  end

  return false,0,0,0
end

-- return x,y,z
function tvRP.getOwnedVehiclePosition(name)
  local vehicle = vehicles[name]
  local x,y,z = 0,0,0

  if vehicle then
    x,y,z = table.unpack(GetEntityCoords(vehicle[3],true))
  end

  return x,y,z
end

function tvRP.getOwnedVehicleId(name)
  local vehicle = vehicles[name]
  if vehicle then
    return true, NetworkGetNetworkIdFromEntity(vehicle[3])
  else
    return false, 0
  end
end

-- eject the ped from the vehicle
function tvRP.ejectVehicle()
  local ped = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ped) then
    local veh = GetVehiclePedIsIn(ped,false)
    TaskLeaveVehicle(ped, veh, 4160)
  end
end

-- vehicle commands
function tvRP.vc_openDoor(name, door_index)
  local vehicle = vehicles[name]
  if vehicle then
    SetVehicleDoorOpen(vehicle[3],door_index,0,false)
  end
end

function tvRP.vc_closeDoor(name, door_index)
  local vehicle = vehicles[name]
  if vehicle then
    SetVehicleDoorShut(vehicle[3],door_index)
  end
end

function tvRP.vc_detachTrailer(name)
  local vehicle = vehicles[name]
  if vehicle then
    DetachVehicleFromTrailer(vehicle[3])
  end
end

function tvRP.vc_detachTowTruck(name)
  local vehicle = vehicles[name]
  if vehicle then
    local ent = GetEntityAttachedToTowTruck(vehicle[3])
    if IsEntityAVehicle(ent) then
      DetachVehicleFromTowTruck(vehicle[3],ent)
    end
  end
end

function tvRP.vc_detachCargobob(name)
  local vehicle = vehicles[name]
  if vehicle then
    local ent = GetVehicleAttachedToCargobob(vehicle[3])
    if IsEntityAVehicle(ent) then
      DetachVehicleFromCargobob(vehicle[3],ent)
    end
  end
end

function tvRP.vc_toggleEngine(name)
  local vehicle = vehicles[name]
  if vehicle then
    local running = Citizen.InvokeNative(0xAE31E7DF9B5B132E,vehicle[3]) -- GetIsVehicleEngineRunning
    SetVehicleEngineOn(vehicle[3],not running,true,true)
  end
end

function tvRP.vc_toggleLock(name)
  local vehicle = vehicles[name]
  if vehicle then
    local veh = vehicle[3]
    local locked = GetVehicleDoorLockStatus(veh) >= 2
    if locked then -- unlock
      SetVehicleDoorsLockedForAllPlayers(veh, false)
      SetVehicleDoorsLocked(veh,1)
      SetVehicleDoorsLockedForPlayer(veh, PlayerId(), false)
      tvRP.notify("Vehicle unlocked.")
    else -- lock
      SetVehicleDoorsLocked(veh,2)
      SetVehicleDoorsLockedForAllPlayers(veh, true)
      tvRP.notify("Vehicle locked.")
    end
  end
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if IsControlJustPressed(1, 182) then -- L pressed
      if not IsEntityDead(GetPlayerPed(-1)) and not tvRP.isHandcuffed() then
        local ok,vtype,name = tvRP.getNearestOwnedVehicle(5)
        if ok then
          tvRP.vc_toggleLock(name)
        end
      end
    end
  end
end)


-- CONFIG --

-- Blacklisted vehicle models
carblacklist = {
  "adder",
  "banshee2",
  "bullet",
  "cheetah",
  "entityxf",
  "sheava",
  "fmj",
  "infernus",
  "osiris",
  "le7b",
  "reaper",
  "sultanrs",
  "t20",
  "turismor",
  "tyrus",
  "vacca",
  "voltic",
  "prototipo",
  "zentorno",
  "bestiagts",
  "rhino",
  "valkyrie",
  "valkyrie2",
  "savage",
  "annihilator",
  "buzzard",
  "buzzard2",
  "cargobob",
  "cargobob2",
  "cargobob3",
  "lazer",
  "titan"
}

-- CODE --

local restrictedNotified = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)

    playerPed = GetPlayerPed(-1)
    if playerPed then
      local veh = GetVehiclePedIsIn(playerPed, false)
      if veh then
        checkCar(veh)
      end
    end
  end
end)

function checkCar(car,ped)
  if car then
    carModel = GetEntityModel(car)
    carName = GetDisplayNameFromVehicleModel(carModel)

    if isCarBlacklisted(carModel) then
      SetVehicleEngineOn(car, false, true)
      if not restrictedNotified then
        tvRP.notify("The security system in this vehicle has disabled the engine")
        restrictedNotified = true
        SetTimeout(10000, function()
          restrictedNotified = false
        end)
      end
    end
  end
end

function isCarBlacklisted(model)
  for _, blacklistedCar in pairs(carblacklist) do
    if model == GetHashKey(blacklistedCar) then
      return true
    end
  end

  return false
end
