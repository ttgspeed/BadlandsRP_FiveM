-- build the client-side interface
license_client = {}
Tunnel.bindInterface("playerLicenses",license_client)
-- get the server-side access
license_server = Tunnel.getInterface("playerLicenses","playerLicenses")

local vehicles = {}

local mod_protected = {
  "police",
  "police2",
  "police3",
  "policet",
  "policeb",
  "sheriff",
  "sheriff2",
  "ambulance",
  "firetruk",
  "firesuv",
  "cvpi",
  "charger",
  "fpis",
  "tahoe",
  "explorer",
  "explorer2"
}

local emergency_vehicles = {
  "police",
  "police2",
  "police3",
  "policet",
  "policeb",
  "sheriff",
  "sheriff2",
  "ambulance",
  "firetruk",
  "firesuv",
  "cvpi",
  "uccvpi",
  "charger",
  "fpis",
  "tahoe",
  "explorer",
  "explorer2",
  "fbicharger",
  "fbitahoe",
  "fbi2"
}

function tvRP.spawnGarageVehicle(vtype,name,options) -- vtype is the vehicle type (one vehicle per type allowed at the same time)

  local vehicle = vehicles[name]
  if vehicle and not IsVehicleDriveable(vehicle[3]) then -- precheck if vehicle is undriveable
    -- despawn vehicle
    SetVehicleHasBeenOwnedByPlayer(vehicle[3],false)
    Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle[3], false, true) -- set not as mission entity
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
      local plateNum = tvRP.getRegistrationNumber()
      SetVehicleOnGroundProperly(veh)
      SetEntityInvincible(veh,false)
      SetPedIntoVehicle(GetPlayerPed(-1),veh,-1) -- put player inside
      SetVehicleNumberPlateText(veh, plateNum)
      Citizen.InvokeNative(0xAD738C3085FE7E11, veh, true, true) -- set as mission entity
      SetVehicleHasBeenOwnedByPlayer(veh,true)
      SetEntityAsMissionEntity(veh, true, true)

      local nid = NetworkGetNetworkIdFromEntity(veh)
      SetNetworkIdCanMigrate(nid,false)
      --TriggerServerEvent("ls:registerVehicle",plateNum,nid)

      SetVehicleModKit(veh, 0)

      local protected = false
      for _, emergencyCar in pairs(mod_protected) do
        if name == emergencyCar then
          protected = true
        end
      end
      if not protected then
        SetVehicleModColor_1(veh, 0, 0, 0)
        SetVehicleModColor_2(veh, 0, 0, 0)
        SetVehicleColours(veh, tonumber(options.main_colour), tonumber(options.secondary_colour))
        SetVehicleExtraColours(veh, tonumber(options.ecolor), tonumber(options.ecolorextra))
      end
      if name == "fbicharger" then
        SetVehicleExtra(veh,7,0)
      elseif name == "uccvpi" then
        SetVehicleExtra(veh,1,0)
        SetVehicleExtra(veh,7,0)
        SetVehicleExtra(veh,8,0)
        SetVehicleExtra(veh,11,1)
        SetVehicleExtra(veh,12,1)
      elseif name == "charger" then
        SetVehicleExtra(veh,2,0)
        SetVehicleExtra(veh,5,0)
        SetVehicleExtra(veh,7,1)
        SetVehicleExtra(veh,12,0)
      elseif name == "explorer" then
        SetVehicleExtra(veh,3,0)
        SetVehicleExtra(veh,5,0)
      elseif name == "explorer2" then
        SetVehicleExtra(veh,3,0)
      elseif name == "fpis" then
        SetVehicleExtra(veh,2,1)
        SetVehicleExtra(veh,5,0)
        SetVehicleExtra(veh,7,0)
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
              SetVehicleMod(veh,tonumber(k),tonumber(v.mod),false)
              SetVehicleWheelType(veh, tonumber(options.wheels))
            else
              SetVehicleMod(veh,tonumber(k),tonumber(v.mod),true)
            end
          end
        end
      end
      SetVehicleTyreSmokeColor(veh, tonumber(options.smokecolor1),tonumber(options.smokecolor2),tonumber(options.smokecolor3))
      vehicles[name] = {vtype,name,veh} -- set current vehicule

  		local blip = AddBlipForEntity(veh)
  		SetBlipSprite(blip, 225)

      SetModelAsNoLongerNeeded(mhash)
    end
  else
    tvRP.notify("You can only have one "..name.." vehicle out.")
  end
end

function tvRP.recoverVehicleOwnership(vtype,name,veh)
  if vtype ~= nil and name ~= nil and veh ~= nil then
    vehicles[name] = {vtype,name,veh}
    local blip = AddBlipForEntity(veh)
    SetBlipSprite(blip, 225)
  end
end

function tvRP.fixeNearestVehicle(radius)
  local veh = tvRP.getNearestVehicle(radius)
  if IsEntityAVehicle(veh) then
    SetVehicleFixed(veh)
  end
end

function tvRP.replaceNearestVehicle(radius)
  local veh = tvRP.getNearestVehicle(radius)
  if IsEntityAVehicle(veh) then
    SetVehicleOnGroundProperly(veh)
  end
end

function tvRP.despawnGarageVehicle(vtype,max_range)
  for types,vehicle in pairs(vehicles) do
    local x,y,z = table.unpack(GetEntityCoords(vehicle[3],true))
    local px,py,pz = tvRP.getPosition()

    if GetDistanceBetweenCoords(x,y,z,px,py,pz,true) < max_range then -- check distance with the vehicule
      -- remove vehicle
      SetVehicleHasBeenOwnedByPlayer(vehicle[3],false)
      Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle[3], false, true) -- set not as mission entity
      SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle[3]))
      Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle[3]))
      SetVehicleHasBeenOwnedByPlayer(vehicle[3],false)
      Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle[3], false, true) -- set not as mission entity
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

function tvRP.fixeNearestVehicle(radius)
  local veh = tvRP.getNearestVehicle(radius)
  if IsEntityAVehicle(veh) then
    SetVehicleFixed(veh)
  end
end

function tvRP.replaceNearestVehicle(radius)
  local veh = tvRP.getNearestVehicle(radius)
  if IsEntityAVehicle(veh) then
    SetVehicleOnGroundProperly(veh)
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

  local targetVehicle,distance = tvRP.getTargetVehicle()

  if distance ~= nil and distance <= radius+0.0001 and targetVehicle ~= 0 or vehicle ~= 0 then
    if vehicle ~= 0 then
      plate = GetVehicleNumberPlateText(vehicle)
    else
      vehicle = targetVehicle
      plate = GetVehicleNumberPlateText(vehicle)
    end

    args = tvRP.stringsplit(plate)
    plate = args[1]
    registration = tvRP.getRegistrationNumber()

    if registration == plate then
      carModel = GetEntityModel(vehicle)
      carName = GetDisplayNameFromVehicleModel(carModel)
      tvRP.recoverVehicleOwnership("default",string.lower(carName),vehicle)
      return true,"default",string.lower(carName)
    end
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

-- return ok, vehicule network id
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
    SetTimeout(2000, function()
        if tvRP.isHandcuffed() then
          if tvRP.getAllowMovement() then
            tvRP.playAnim(false,{{"mp_arresting","idle",1}},true)
          else
            tvRP.playAnim(true,{{"mp_arresting","idle",1}},true)
          end
        end
    end)
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
    Citizen.InvokeNative(0x2497C4717C8B881E,vehicle[3],not running,true,true) --SET_VEHICLE_ENGINE_ON
    Citizen.InvokeNative(0x8ABA6AF54B942B95,vehicle[3],running) --SET_VEHICLE_UNDRIVEABLE
  end
end

function tvRP.vc_toggleLock(name)
  local vehicle = vehicles[name]
  if vehicle then
    local veh = vehicle[3]
    local locked = GetVehicleDoorLockStatus(veh) >= 2
    if locked then -- unlock
      if (GetVehicleClass(veh) == 14) then
        SetBoatAnchor(veh, false)
      end

      SetVehicleDoorsLockedForAllPlayers(veh, false)
      SetVehicleDoorsLocked(veh,1)
      tvRP.notify("Vehicle unlocked.")
    else -- lock
      if (GetVehicleClass(veh) == 14) then
        SetBoatAnchor(veh, true)
      end

      SetVehicleDoorsLocked(veh,2)
      SetVehicleDoorsLockedForAllPlayers(veh, true)
      tvRP.notify("Vehicle locked.")
    end
  end
end

--[[
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if IsControlJustPressed(1, 303) then -- U pressed
      if not IsEntityDead(GetPlayerPed(-1)) and not tvRP.isHandcuffed() then
        local ok,vtype,name = tvRP.getNearestOwnedVehicle(5)
        if ok then
          tvRP.vc_toggleLock(name)
        end
      end
    end
  end
end)
]]--

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)

    vehicle = GetVehiclePedIsIn(player, false)

    if IsControlJustPressed(1, 303) then -- U pressed
      if not IsEntityDead(GetPlayerPed(-1)) and not tvRP.isHandcuffed() then
        local targetVehicle,distance = tvRP.getTargetVehicle()

        if distance ~= nil and distance <= 5 and targetVehicle ~= 0 or vehicle ~= 0 then
          if vehicle ~= 0 then
            plate = GetVehicleNumberPlateText(vehicle)
          else
            vehicle = targetVehicle
            plate = GetVehicleNumberPlateText(vehicle)
          end

          args = tvRP.stringsplit(plate)
          plate = args[1]
          registration = tvRP.getRegistrationNumber()

          if registration == plate then
            tvRP.newLockToggle(vehicle)
          end
        end
      end
    end
  end
end)

function tvRP.newLockToggle(vehicle)
  if vehicle ~= nil then
    local locked = GetVehicleDoorLockStatus(vehicle) >= 2
    if locked then -- unlock
      if (GetVehicleClass(vehicle) == 14) then
        SetBoatAnchor(vehicle, false)
      end
      SetVehicleDoorsLockedForAllPlayers(vehicle, false)
      SetVehicleDoorsLocked(vehicle,1)
      SetVehicleDoorsLockedForPlayer(vehicle,PlayerId(),false)
      tvRP.notify("Vehicle unlocked.")
    else -- lock
      if (GetVehicleClass(vehicle) == 14) then
        SetBoatAnchor(vehicle, true)
      end
      SetVehicleDoorsLocked(vehicle,2)
      SetVehicleDoorsLockedForPlayer(vehicle,PlayerId(),true)
      SetVehicleDoorsLockedForAllPlayers(vehicle, true)
      tvRP.notify("Vehicle locked.")
    end
  end
end

function tvRP.getTargetVehicle()
  player = GetPlayerPed(-1)
  px, py, pz = table.unpack(GetEntityCoords(player, true))
  coordA = GetEntityCoords(player, true)
  local targetVehicle = 0
  local distance = 999

  for i = 1, 32 do
    coordB = GetOffsetFromEntityInWorldCoords(player, 0.0, (6.281)/i, 0.0)
    targetVehicle = tvRP.GetVehicleInDirection(coordA, coordB)
    if targetVehicle ~= nil and targetVehicle ~= 0 then
      vx, vy, vz = table.unpack(GetEntityCoords(targetVehicle, false))
        if GetDistanceBetweenCoords(px, py, pz, vx, vy, vz, false) then
          distance = GetDistanceBetweenCoords(px, py, pz, vx, vy, vz, false)
          break
        end
    end
  end

  return targetVehicle,distance
end

-- CONFIG --
-- Only active for non medics
emsVehiclesBlacklist = {
  "ambulance",
  "firesuv",
  "firetruk"
}

airVehicles = {
  "buzzard2",
  "frogger",
  "maverick",
  "supervolito",
  "swift",
  "volatus",
  "cuban800",
  "dodo",
  "duster",
  "luxor",
  "mammatus",
  "nimbus",
  "shamal",
  "velum2",
}

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
  "rhino",
  --Helicopter
  "valkyrie",
  "valkyrie2",
  "savage",
  "annihilator",
  "buzzard",
  "cargobob",
  "cargobob2",
  "cargobob3",
  "cargobob4",
  "supervolito2",
  "swift2",
  "skylift",
  "polmav",
  "lazer",
  "titan",
  "frogger2",
  -- Armored DLC vehicles
  "Guardian",
  "Insurgent",
  "Insurgent2",
  "Kuruma2",
  -- Does not spawn and not used (more for shitter scripters)
  "PoliceOld1",
  "PoliceOld2",
  "Marshall",
  "Monster",
  "Technical",
  "Technical2",
  -- Gunrunning vehicles (dont naturally spawn)
  "Halftrack",
  "Trailersmall2",
  "APC",
  "Hauler2",
  "Phantom3",
  "Opressor",
  "Tampa3",
  "Dune3",
  "Insurgent3",
  "Nightshark",
  "Technical3",
  "Ardent",
  "Cheetah2",
  "Torero",
  "Vagner",
  "XA21",
  "Caddy3",
  "TrailerLarge",
  "TrailerS4",
  -- Flip type vehicle
  "Phantom2",
  "Dune4",
  "Dune5"
}

-- CODE --

local restrictedNotified = false
pilotlicense = false
driverschool = false

function tvRP.set_driverschool(completed)
   driverschool = completed
end
function tvRP.set_pilotlicense(completed)
   pilotlicense = completed
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)

    playerPed = GetPlayerPed(-1)
    if playerPed then
      local veh = GetVehiclePedIsIn(playerPed, false)
      if veh then
        checkCar(veh, playerPed)
      end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    license_server.getPlayerLicense_client({"pilotlicense"}, function(has_license)
      if(has_license == 1) then
        pilotlicense = true
      else
        pilotlicense = false
      end
    end)

    license_server.getPlayerLicense_client({"driverschool"}, function(has_license)
      if(has_license == 1) then
        driverschool = true
      else
        driverschool = false
      end
    end)

    Citizen.Wait(60000)
  end
end)

function checkCar(car,ped)
  if car ~= 0 then
    carModel = GetEntityModel(car)
    carName = GetDisplayNameFromVehicleModel(carModel)

    if (isCarBlacklisted(carModel) or not driverschool) and carName ~= "DILETTAN" then
      if GetPedInVehicleSeat(car, -1) == ped then
        SetVehicleEngineOn(car, false, true)
        if not restrictedNotified then
          if not driverschool then
            tvRP.notify("You're not sure how to drive this vehicle. You should attend driving school.")
          else
            tvRP.notify("The security system in this vehicle has disabled the engine")
          end

          restrictedNotified = true
          SetTimeout(10000, function()
            restrictedNotified = false
          end)
        end
      end
    end
  end
end

function isCarBlacklisted(model)
  if not driverschool then
    return true
  end
  for _, blacklistedCar in pairs(carblacklist) do
    if model == GetHashKey(blacklistedCar) then
      return true
    end
  end
  for _, blacklistedAircraft in pairs(airVehicles) do
    if model == GetHashKey(blacklistedAircraft) and not pilotlicense then
      return true
    end
  end
  if not tvRP.isMedic() and not tvRP.isCop() then
    for _, blacklistedEMSCar in pairs(emsVehiclesBlacklist) do
      if model == GetHashKey(blacklistedEMSCar) then
        return true
      end
    end
  end
  return false
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local player = GetPlayerPed(-1)
    local veh = GetVehiclePedIsTryingToEnter(PlayerPedId(player))
    if veh ~= nil then
      if DoesEntityExist(veh) and not IsEntityAMissionEntity(veh) then
        local veh_hash = GetEntityModel(veh)
        local protected = false
        local lock = GetVehicleDoorLockStatus(veh)
        local player_owned = false
        for _, emergencyCar in pairs(emergency_vehicles) do
          if veh_hash == GetHashKey(emergencyCar) then
            protected = true
            player_owned,vtype,name = tvRP.getNearestOwnedVehicle(4)
          end
        end
        for _, airVehicle in pairs(airVehicles) do
          if veh_hash == GetHashKey(airVehicle) then
            protected = true
            player_owned,vtype,name = tvRP.getNearestOwnedVehicle(4)
          end
        end

        if lock ~= 0 or (protected and not player_owned) then
            SetVehicleDoorsLocked(veh, 2)
        end

        local pedd = GetPedInVehicleSeat(veh, -1)

        if pedd then
          if tvRP.isCop() then
            SetPedCanBeDraggedOut(pedd, true)
          else
            SetPedCanBeDraggedOut(pedd, false)
          end
        end
      end
    end
  end
end)

local locpicking_inProgress = false

function tvRP.break_carlock()
  local nveh = tvRP.getNearestVehicle(3)
  local nveh_hash = GetEntityModel(nveh)
  local protected = false
  for _, emergencyCar in pairs(emergency_vehicles) do
    if nveh_hash == GetHashKey(emergencyCar) then
      protected = true
    end
  end
  for _, airVehicle in pairs(airVehicles) do
    if nveh_hash == GetHashKey(airVehicle) then
      protected = true
    end
  end
  if nveh ~= 0 and not IsEntityAMissionEntity(nveh) and not protected then -- only lockpick npc cars
    tvRP.notify("Picking door lock.")
    SetTimeout(cfg.lockpick_time * 1000, function()
      locpicking_inProgress = false
    end)
    locpicking_inProgress = true
    lockpickingThread(nveh)
  else
    tvRP.notify("This vehicle cannot be lockpicked.")
  end
end

function lockpickingThread(nveh)
  Citizen.CreateThread(function()
    local cancelled = false
    local xa,ya,za = tvRP.getPosition()
    while locpicking_inProgress do
      Citizen.Wait(3000)
      tvRP.playAnim(true,{{"mp_common_heist", "pick_door", 1}},false)
      local nveh2 = tvRP.getNearestVehicle(3)
      if nveh ~= nveh2 then
        locpicking_inProgress = false
        cancelled = true
      end
    end
    if not cancelled then
      SetVehicleDoorsLockedForAllPlayers(nveh, false)
      SetVehicleDoorsLocked(nveh,0)
      SetVehicleDoorsLockedForPlayer(nveh, PlayerId(), false)
      tvRP.notify("Door lock picked.")
      StartVehicleAlarm(nveh) -- start car alarm
      SetTimeout(cfg.caralarm_timeout * 1000, function()
        SetVehicleAlarm(nveh,false)
      end)
    else
      tvRP.notify("Lockpicking Process Cancelled.")
    end
  end)
end

-----------------
--CRUISE CONTROL
--source:https://forum.fivem.net/t/release-cfx-fx-cruisecontrol/38840 08-20-17
-----------------
local cruise = 0

AddEventHandler('pv:setCruiseSpeed', function()
  if cruise == 0 and IsPedInAnyVehicle(GetPlayerPed(-1), false) then
    if GetEntitySpeedVector(GetVehiclePedIsIn(GetPlayerPed(-1), false), true)['y'] > 0 then
      cruise = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
      --local cruiseKm = math.floor(cruise * 3.6 + 0.5)
      --local cruiseMph = math.floor(cruise * 2.23694 + 0.5)
      Citizen.CreateThread(function()
        while cruise > 0 and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) do
          local cruiseVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
          if IsVehicleOnAllWheels(cruiseVeh) and GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) > (cruise - 2.0) then
            SetVehicleForwardSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), cruise)
          else
            cruise = 0
            tvRP.notify("Cruise Control: Disabled")
            break
          end
          if IsControlPressed(1, 8) then
            cruise = 0
            tvRP.notify("Cruise Control: Disabled")
          end
          if IsControlPressed(1, 32) then
            cruise = 0
            TriggerEvent('pv:setNewSpeed')
          end
          if cruise > 44 then
            cruise = 0
            tvRP.notify("Cruise Control: Can not set higher")
            break
          end
          Wait(200)
        end
        cruise = 0
      end)
    else
      cruise = 0
      tvRP.notify("Cruise Control: Disabled")
    end
  else
    if cruise > 0 then
      tvRP.notify("Cruise Control: Disabled")
    end
    cruise = 0
  end
end)

AddEventHandler('pv:setNewSpeed', function()
  Citizen.CreateThread(function()
    while IsControlPressed(1, 32) do
      Wait(1)
    end
    TriggerEvent('pv:setCruiseSpeed')
  end)
end)

function NotificationMessage(message)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(message)
  DrawNotification(0,1)
end

function tvRP.GetVehicleInDirection(coordFrom, coordTo)
  local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
  local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
  return vehicle
end

local inDriveTest = false
RegisterNetEvent("vrp:driverteststatus")
AddEventHandler("vrp:driverteststatus", function(flag)
  inDriveTest = flag
end)

function tvRP.getDriveTestStatus()
  return inDriveTest
end


--Roll windows. Source https://forum.fivem.net/t/release-roll-windows/53660
local windowup = true

function tvRP.rollWindows()
  local playerPed = GetPlayerPed(-1)
  if IsPedInAnyVehicle(playerPed, false) then
    local playerCar = GetVehiclePedIsIn(playerPed, false)
    if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
      SetEntityAsMissionEntity(playerCar, true, true )

      if windowup then
        RollDownWindow(playerCar, 0)
        RollDownWindow(playerCar, 1)
        tvRP.notify("Windows down")
        windowup = false
      else
        RollUpWindow(playerCar, 0)
        RollUpWindow(playerCar, 1)
        tvRP.notify("Windows up")
        windowup = true
      end
    end
  end
end
