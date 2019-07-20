local vehicles = {}

local mod_protected = {
  "police",
  "police2",
  "police3",
  "policet",
  "policeb",
  "policeb2",
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
  "explorer2",
  "asstchief",
  "chiefpara",
  "raptor2",
  "polmav",
  "predator",
  "predator2",
  "seashark2"
}

function tvRP.isInProtectedVeh()
  local ped = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ped) then
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= nil and veh ~= 0 then
      local protected = false
      for _, emergencyCar in pairs(mod_protected) do
        if name == emergencyCar then
          protected = true
          break
        end
      end
      return true
    end
  end
  return false
end

local emergency_vehicles = {
  "police",
  "police2",
  "police3",
  "policet",
  "policeb",
  "policeb2",
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
  "fbi2",
  "asstchief",
  "chiefpara",
  "raptor2",
  "polmav",
  "predator",
  "predator2",
  "seashark2"
}

function tvRP.spawnGarageVehicle(vtype,name,options,vehDamage) -- vtype is the vehicle type (one vehicle per type allowed at the same time)
  local vehicle = vehicles[name]
  if vehicle and not IsVehicleDriveable(vehicle[3]) then -- precheck if vehicle is undriveable
    -- despawn vehicle
    SetVehicleHasBeenOwnedByPlayer(vehicle[3],false)
    SetEntityAsMissionEntity(vehicle[3], false, true)
    SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle[3]))
    DeleteVehicle(Citizen.PointerValueIntInitialized(vehicle[3]))
    vehicles[name] = nil
  end

  vehicle = vehicles[name]
  if vehicle == nil then
    -- load vehicle model
    local mhash = GetHashKey(name)
    local vehicleID = math.random()

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
      local carModel = GetEntityModel(veh)
      local carName = string.lower(GetDisplayNameFromVehicleModel(carModel))
      vRPserver.registerVehicleID({plateNum,carName,vehicleID})
      DecorSetFloat(veh,"VehicleID",vehicleID)
      SetVehicleOnGroundProperly(veh)
      SetEntityInvincible(veh,false)
      SetVehicleNumberPlateText(veh, plateNum)
      SetVehicleHasBeenOwnedByPlayer(veh,true)
      SetEntityAsMissionEntity(veh, true, true)

      local nid = VehToNet(veh)
      SetNetworkIdCanMigrate(nid,true)
      NetworkRegisterEntityAsNetworked(nid)
      SetNetworkIdExistsOnAllMachines(veh,true)
      NetworkRequestControlOfEntity(veh)

      SetPedIntoVehicle(GetPlayerPed(-1),veh,-1) -- put player inside

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

      SetVehicleWindowTint(veh, options.windows)

      if name == "cvpi" then
        if tvRP.getCopLevel() > 3 then
          SetVehicleLivery(veh, 3)
        else
          local rnd = math.random(1,2)
          SetVehicleLivery(veh, rnd)
        end
      elseif name == "tahoe" then
        SetVehicleExtra(veh,1,0)
        SetVehicleExtra(veh,2,0)
        SetVehicleExtra(veh,3,0)
        SetVehicleExtra(veh,4,0)
        SetVehicleExtra(veh,5,0)
        SetVehicleExtra(veh,6,1)
        if tvRP.getCopLevel() > 3 then
          SetVehicleLivery(veh, 5)
        else
          local rnd = math.random(1,3)
          SetVehicleLivery(veh, rnd)
        end
      elseif name == "fbicharger" then
        SetVehicleExtra(veh,7,1)
      elseif name == "uccvpi" then
        SetVehicleExtra(veh,1,0)
        SetVehicleExtra(veh,7,0)
        SetVehicleExtra(veh,8,0)
        SetVehicleExtra(veh,11,1)
        SetVehicleExtra(veh,12,1)
      elseif name == "charger" then
        if tvRP.getCopLevel() > 3 then
          SetVehicleLivery(veh, 4)
        else
          local rnd = math.random(1,2)
          SetVehicleLivery(veh, rnd)
        end
        SetVehicleExtra(veh,1,0)
        SetVehicleExtra(veh,2,0)
        SetVehicleExtra(veh,3,1)
        SetVehicleExtra(veh,4,0)
        SetVehicleExtra(veh,8,1)
        SetVehicleExtra(veh,11,0)
        SetVehicleWindowTint(veh,4)
      elseif name == "explorer" then
        if tvRP.getCopLevel() > 3 then
          SetVehicleLivery(veh, 3)
        else
          local rnd = math.random(1,2)
          SetVehicleLivery(veh, rnd)
        end
        SetVehicleExtra(veh,3,0)
        SetVehicleExtra(veh,5,0)
      elseif name == "explorer2" then
        SetVehicleExtra(veh,3,0)
      elseif name == "fpis" then
        if tvRP.getCopLevel() > 3 then
          SetVehicleLivery(veh, 4)
        else
          local rnd = math.random(1,2)
          SetVehicleLivery(veh, rnd)
        end
        SetVehicleExtra(veh,2,1)
        SetVehicleExtra(veh,5,0)
        SetVehicleExtra(veh,7,0)
      elseif name == "asstchief" then
        local rankT = tvRP.getEmergencyLevel()
        if rankT > 4 then
          SetVehicleLivery(veh, 0)
          SetVehicleExtra(veh,4,1)
        elseif rankT > 3 then
          local rnd = math.random(1,2)
          SetVehicleLivery(veh, rnd)
          SetVehicleExtra(veh,4,0)
        else
          SetVehicleLivery(veh, 3)
          SetVehicleExtra(veh,4,0)
        end
        SetVehicleExtra(veh,1,1)
        SetVehicleExtra(veh,2,1)
        SetVehicleExtra(veh,3,1)
        SetVehicleExtra(veh,8,1)
        SetVehicleExtra(veh,11,1)
        SetVehicleWindowTint(veh,4)
      elseif name == "chiefpara" then
        local rankT = tvRP.getEmergencyLevel()
        if rankT > 4 then
          SetVehicleLivery(veh, 0)
        elseif rankT > 2 then
          local rnd = math.random(1,2)
          SetVehicleLivery(veh, rnd)
        else
          SetVehicleLivery(veh, 3)
        end
        SetVehicleExtra(veh,3,1)
        SetVehicleExtra(veh,5,1)
      elseif name == "ambulance" then
        local rnd = math.random(0,3)
        SetVehicleLivery(veh, rnd)
      elseif name == "firesuv" then
        local rankT = tvRP.getEmergencyLevel()
        if rankT > 4 then
          SetVehicleLivery(veh, 5)
        else
          local rnd = math.random(1,3)
          SetVehicleLivery(veh, rnd)
        end
        SetVehicleExtra(veh,1,0)
        SetVehicleExtra(veh,4,1)
      elseif name == "raptor2" then
        SetVehicleExtra(veh,1,0)
        SetVehicleExtra(veh,2,1)
        SetVehicleExtra(veh,3,0)
        SetVehicleExtra(veh,4,0)
      elseif(mhash == GetHashKey("polmav")) then
        if(tvRP.isCop()) then
          SetVehicleLivery(veh, 2)
        elseif(tvRP.isMedic()) then
          SetVehicleLivery(veh, 1)
        end
      else
        SetVehicleLivery(veh, 0)
      end

      --SetVehicleNumberPlateText(veh, options.plate)
      SetVehicleNumberPlateTextIndex(veh, options.platetype)
      SetVehicleDirtLevel(veh, 0)
      SetVehicleEngineOn(veh, true, true)

      if options.mods then
        options.mods = json.decode(options.mods)
        if type(options.mods) == "table" then
          for k,v in pairs(options.mods) do
            if k == "18" or k == "22" then --support toggle mods like headlights/turbo
              ToggleVehicleMod(veh, tonumber(k), tonumber(v.mod))
            elseif k == "23" then -- custom tires
              SetVehicleMod(veh,tonumber(k),tonumber(v.mod),true)
            elseif k == "20" then  -- tire smoke
              ToggleVehicleMod(veh,20,true)
              SetVehicleTyreSmokeColor(veh, tonumber(options.smokecolor1),tonumber(options.smokecolor2),tonumber(options.smokecolor3))
            else
              SetVehicleMod(veh,tonumber(k),tonumber(v.mod),false)
            end
          end
        end
      end

      -- Set Rims
      SetVehicleWheelType(veh, tonumber(options.wheels))

      if tonumber(options.neon) == 0 then
        --SetVehicleNeonLightsColour(veh,255,255,255)
        SetVehicleNeonLightEnabled(veh,0,false)
        SetVehicleNeonLightEnabled(veh,1,false)
        SetVehicleNeonLightEnabled(veh,2,false)
        SetVehicleNeonLightEnabled(veh,3,false)
      else
        SetVehicleNeonLightsColour(veh,tonumber(options.neoncolor1),tonumber(options.neoncolor2),tonumber(options.neoncolor3))
        SetVehicleNeonLightEnabled(veh,0,true)
        SetVehicleNeonLightEnabled(veh,1,true)
        SetVehicleNeonLightEnabled(veh,2,true)
        SetVehicleNeonLightEnabled(veh,3,true)
      end

      vehicles[name] = {vtype,name,veh} -- set current vehicule

  		local blip = AddBlipForEntity(veh)
  		SetBlipSprite(blip, 225)

      SetModelAsNoLongerNeeded(mhash)

      for _, emergencyCar in pairs(emergency_vehicles) do
        if name == emergencyCar then
          SetVehRadioStation(veh, "OFF")
        end
      end
      if vehDamage ~= nil then
        Citizen.Trace(vehDamage.engineDamage.." "..vehDamage.bodyDamage.." "..vehDamage.fuelDamage)
        SetVehicleEngineHealth(veh,vehDamage.engineDamage + 0.0001)
        SetVehicleBodyHealth(veh,vehDamage.bodyDamage + 0.0001)
        SetVehiclePetrolTankHealth(veh,vehDamage.fuelDamage + 0.0001)
      end
    end
    local registration = tvRP.getRegistrationNumber()
    local vehicle_out = tvRP.searchForVeh(GetPlayerPed(-1),10,registration,name)
    if  vehicle_out then
      Citizen.Trace("Vehicle spawned")
      vRPserver.setVehicleOutStatusPlate({registration,name,1,0})
    else
      Citizen.Trace("Vehicle not spawned")
    end
  else
    tvRP.notify("You can only have one "..name.." vehicle out.")
  end
end

function tvRP.recoverVehicleOwnership(vtype,name,veh)
  if vtype ~= nil and name ~= nil and veh ~= nil then
    vehicles[name] = {vtype,name,veh}
  end
end

function tvRP.despawnGarageVehicle(vtype,max_range)
  local vehicle = tvRP.getVehicleAtRaycast(max_range)
  Citizen.Trace("Vehicle "..vehicle)
  if IsEntityAVehicle(vehicle) then
    plate = GetVehicleNumberPlateText(vehicle)
    args = tvRP.stringsplit(plate)
    if args ~= nil then
      plate = args[1]
      carModel = GetEntityModel(vehicle)
      carName = GetDisplayNameFromVehicleModel(carModel)
      registration = tvRP.getRegistrationNumber()
      if registration == plate then
        tvRP.saveVehicleDamage(vehicle)
        SetVehicleHasBeenOwnedByPlayer(vehicle,false)
        Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle, false, true) -- set not as mission entity
        SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle))
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
        SetVehicleHasBeenOwnedByPlayer(vehicle,false)
        Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle, false, true) -- set not as mission entity
        tvRP.notify("Attempting to store vehicle.")
        vRPserver.setVehicleOutStatusPlate({registration,string.lower(carName),0,0})
        -- check if the vehicle failed to impound. This happens if another player is nearby
        Citizen.Wait(1000)
        local vehicle_out = tvRP.searchForVeh(GetPlayerPed(-1),10,registration,carName)
        if not vehicle_out then
          vehicles[carName] = nil
          tvRP.notify("Your vehicle has been stored in the garage.")
        else
          vRPserver.setVehicleOutStatusPlate({registration,string.lower(carName),1,0})
        end
      end
    else
      tvRP.notify("No vehicle found to store.")
    end
  else
    tvRP.notify("No vehicle found to store.")
  end
end

function tvRP.saveVehicleDamage(vehicle)
  if vehicle ~= nil then
    local carModel = GetEntityModel(vehicle)
    local carName = GetDisplayNameFromVehicleModel(carModel)
    local engineDamage = GetVehicleEngineHealth(vehicle) or 1000
    local bodyDamage = GetVehicleBodyHealth(vehicle) or 1000
    local fuelDamage = GetVehiclePetrolTankHealth(vehicle) or 1000
    if engineDamage < 25 then
      engineDamage = 25
    end
    if bodyDamage < 25 then
      bodyDamage = 25
    end
    if fuelDamage < 25 then
      fuelDamage = 25
    end
    Citizen.Trace("Name = "..carName.." Model = "..carModel.." engineDamage = "..engineDamage.." bodyDamage = "..bodyDamage.." fuelDamage ="..fuelDamage)
    vRPserver.saveVehicleDamage({engineDamage,bodyDamage,fuelDamage,carName})
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

function tvRP.getVehicleAtRaycast(radius)
  local player = GetPlayerPed(-1)
  local pos = GetEntityCoords(player)
  local entityWorld = GetOffsetFromEntityInWorldCoords(player, 0.0, radius+0.00001, 0.0)

  local rayHandle = StartShapeTestCapsule( pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, radius+0.00001, 10, player, 7 )
  local a, b, c, d, vehicleHandle = GetShapeTestResult(rayHandle)

  return vehicleHandle
end

function tvRP.getNearestEmergencyVehicle(radius)
  local vehicle = nil
  if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
    vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
  else
    vehicle = tvRP.getVehicleAtRaycast(radius)
  end

  if vehicle ~= nil then
    vehicleClass = GetVehicleClass(vehicle)
    if vehicleClass ==  18 then
      return true,"default",string.lower(vehicleClass)
    end
  end

  return false,"",""
end

function tvRP.applySpeedBomb()
	local mechanic = mechanic
	local ped = GetPlayerPed(-1)
	if not IsPedInAnyVehicle(ped, false) then
		local vehicle = tvRP.getVehicleAtRaycast(2)
		if vehicle ~= nil and vehicle ~= 0 and IsEntityAVehicle(vehicle) then
			Citizen.CreateThread(function()
				local pos = GetEntityCoords(GetPlayerPed(-1))
				tvRP.playAnim(false, {task="CODE_HUMAN_MEDIC_TEND_TO_DEAD"}, false)
				tvRP.setActionLock(true)
				Citizen.Wait(1000)
				vRPserver.broadcastSpatializedSound({0,"HACKING_CLICK",pos.x, pos.y, pos.z,10})
				Citizen.Wait(200)
				vRPserver.broadcastSpatializedSound({0,"HACKING_CLICK",pos.x, pos.y, pos.z,10})
				Citizen.Wait(400)
				vRPserver.broadcastSpatializedSound({0,"HACKING_CLICK_BAD",pos.x, pos.y, pos.z,10})
				Citizen.Wait(1200)
				vRPserver.broadcastSpatializedSound({0,"HACKING_CLICK",pos.x, pos.y, pos.z,10})
				Citizen.Wait(200)
				vRPserver.broadcastSpatializedSound({0,"HACKING_MOVE_CURSOR",pos.x, pos.y, pos.z,10})
				Citizen.Wait(400)
				vRPserver.broadcastSpatializedSound({0,"HACKING_CLICK_GOOD",pos.x, pos.y, pos.z,10})
				Citizen.Wait(1200)
				Citizen.Wait(200)
				vRPserver.broadcastSpatializedSound({0,"HACKING_CLICK",pos.x, pos.y, pos.z,10})
				Citizen.Wait(400)
				vRPserver.broadcastSpatializedSound({0,"HACKING_CLICK_GOOD",pos.x, pos.y, pos.z,10})
				Citizen.Wait(1200)
				vRPserver.broadcastSpatializedSound({"DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS","Hack_Success",pos.x, pos.y, pos.z,10})
				tvRP.stopAnim(false)
				tvRP.setActionLock(false)
				DecorSetInt(vehicle, "SpeedBomb", 1)
				tvRP.notify("SpeedBomb applied to vehicle!")
			end)
			return true
		else
			tvRP.notify("There are no vehicles nearby.")
		end
	else
		tvRP.notify("You must be outside of the vehicle.")
	end
	return false
end

-- return ok,vtype,name
function tvRP.getNearestOwnedVehicle(radius)
  local vehicle = nil
  if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
    vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
  else
    vehicle = tvRP.getVehicleAtRaycast(radius)
  end

  if vehicle ~= nil then
    plate = GetVehicleNumberPlateText(vehicle)
    args = tvRP.stringsplit(plate)
    if args ~= nil then
      plate = args[1]
      registration = tvRP.getRegistrationNumber()

      if registration == plate then
        carModel = GetEntityModel(vehicle)
        carName = GetDisplayNameFromVehicleModel(carModel)
        tvRP.recoverVehicleOwnership("default",string.lower(carName),vehicle)
        return true,"default",string.lower(carName)
      end
    end
  end

  return false,"",""
end

function tvRP.getNearestOwnedVehiclePlate(radius)
  local vehicle = nil
  if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
    vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
  else
    vehicle = tvRP.getVehicleAtRaycast(radius)
  end

  if vehicle ~= nil then
    plate = GetVehicleNumberPlateText(vehicle)
    args = tvRP.stringsplit(plate)
    if args ~= nil then
      plate = args[1]
      carModel = GetEntityModel(vehicle)
      carName = GetDisplayNameFromVehicleModel(carModel)
      return true,"default",string.lower(carName),plate
    end
  end

  return false,"",""
end

function tvRP.getNearestOwnedVehicleID(radius)
  local vehicle = nil
  if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
    vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
  else
    vehicle = tvRP.getVehicleAtRaycast(radius)
  end

  if vehicle ~= nil then
    plate = GetVehicleNumberPlateText(vehicle)

    args = tvRP.stringsplit(plate)
    if args ~= nil then
      plate = args[1]
      carModel = GetEntityModel(vehicle)
      carName = GetDisplayNameFromVehicleModel(carModel)
      local decor = DecorGetFloat(vehicle, "VehicleID")
      return true,"default",string.lower(carName),plate,decor
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
  local vehicle = tvRP.getVehicleAtRaycast(5)
  if vehicle then
    SetVehicleDoorOpen(vehicle,door_index,0,false)
  end
end

function tvRP.vc_closeDoor(name, door_index)
  local vehicle = tvRP.getVehicleAtRaycast(5)
  if vehicle then
    SetVehicleDoorShut(vehicle,door_index)
  end
end

function tvRP.vc_detachTrailer(name)
  local vehicle = vehicles[name]
  if vehicle then
    DetachVehicleFromTrailer(vehicle[3])
  end
end

function tvRP.vc_TowTruck()
  TriggerEvent("tow")
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

function tvRP.vc_toggleLock(name)
  local vehicle = vehicles[name]
  if vehicle then
    local veh = vehicle[3]
    local locked = GetVehicleDoorLockStatus(veh) >= 2
    if locked then -- unlock
      SetBoatAnchor(veh, false)

      SetVehicleDoorsLockedForAllPlayers(veh, false)
      SetVehicleDoorsLocked(veh,1)
      tvRP.notify("Vehicle unlocked.")
    else -- lock
      SetBoatAnchor(veh, true)

      SetVehicleDoorsLocked(veh,2)
      SetVehicleDoorsLockedForAllPlayers(veh, true)
      tvRP.notify("Vehicle locked.")
    end
  end
end

-- Thread to monitor Vehcile lock/unlock keypress
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if IsControlJustPressed(1, 303) then -- U pressed
      vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
      if not IsEntityDead(GetPlayerPed(-1)) and not tvRP.isHandcuffed() then
        local vehicle = nil
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
          vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        else
          vehicle = tvRP.getVehicleAtRaycast(5)
        end
        local plate = GetVehicleNumberPlateText(vehicle)
        local carModel = GetEntityModel(vehicle)
        local carName = GetDisplayNameFromVehicleModel(carModel)
        if plate ~= nil then
          args = tvRP.stringsplit(plate)
          if args ~= nil then
            plate = args[1]
            registration = tvRP.getRegistrationNumber()

            if registration == plate or tvRP.hasKey(carName, plate) then
              tvRP.newLockToggle(vehicle)
            end
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
      SetBoatAnchor(vehicle, false)
      SetVehicleDoorsLockedForAllPlayers(vehicle, false)
      SetVehicleDoorsLocked(vehicle,1)
      SetVehicleDoorsLockedForPlayer(vehicle,PlayerId(),false)
      lockToggleAnim()
      tvRP.notify("Vehicle unlocked.")
      TriggerEvent('InteractSound_CL:PlayOnOne', 'unlock', 0.3)
    else -- lock
      SetBoatAnchor(vehicle, true)
      SetVehicleDoorsLocked(vehicle,2)
      SetVehicleDoorsLockedForPlayer(vehicle,PlayerId(),true)
      SetVehicleDoorsLockedForAllPlayers(vehicle, true)
      lockToggleAnim()
      tvRP.notify("Vehicle locked.")
      TriggerEvent('InteractSound_CL:PlayOnOne', 'lock', 0.3)
    end
  end
end

-- Lock animations for vehicles
function lockToggleAnim()
  if not tvRP.isHandcuffed() and not tvRP.isInComa() then
    tvRP.playAnim(true, {{"anim@mp_player_intmenu@key_fob@", "fob_click", 1}}, false)
    Citizen.Wait(500)
  end
end

-- Only active for non medics
emsVehiclesBlacklist = {
  "ambulance",
  "firesuv",
  "firetruk",
  "asstchief",
  "chiefpara",
  "raptor2",
  "police",
  "police2",
  "police3",
  "policet",
  "policeb",
  "policeb2",
  "sheriff",
  "sheriff2",
  "police4",
  "riot",
  "riot2",
  "pbus",
  "lguard",
  "pranger",
  "fbi",
  "fbi2",
  "polmav",
  "predator",
  "predator2",
  "seashark2",
  "cvpi",
  "uccvpi",
  "charger",
  "fpis",
  "tahoe",
  "explorer",
  "explorer2",
  "fbicharger",
  "fbitahoe",
  "xmastahoe",
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
  "polmav",
}

-- Blacklisted vehicle models
carblacklist = {
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
  "lazer",
  "titan",
  "frogger2",
  --Jet
  "Hydra",
  "Titan",

  -- Other --
  'towtruck',
  'towtruck2',
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

-- Check the vehicle player is driving
-- Check for licenses and blacklists
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    playerPed = GetPlayerPed(-1)
    if playerPed then
      local veh = GetVehiclePedIsIn(playerPed, false)
      if veh then
        checkCar(veh, playerPed)
      end
    end
  end
end)

-- Update license status based on server info.
Citizen.CreateThread(function()
  Citizen.Wait(10000)
  while true do
    vRPserver.getPlayerLicense_client({"pilotlicense"}, function(has_license)
      if has_license ~= nil then
        if(has_license == 1) then
          pilotlicense = true
        else
          pilotlicense = false
        end
      end
    end)

    vRPserver.getPlayerLicense_client({"driverschool"}, function(has_license)
      if has_license ~= nil then
        if(has_license == 1) then
          driverschool = true
        else
          driverschool = false
        end
      end
    end)
    Citizen.Wait(60000)
  end
end)

function checkCar(car,ped)
  if car ~= 0 then
    carModel = GetEntityModel(car)
    carName = GetDisplayNameFromVehicleModel(carModel)
    local vehicleClass = GetVehicleClass(car)
    if vehicleClass ~= 13 then --exempt all bicycles
      if not driverschool and carName ~= "DILETTANTE" then
        if GetPedInVehicleSeat(car, -1) == ped then
          SetVehicleForwardSpeed(car,0.0)
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
      elseif carName == "Kart3" then
        TriggerEvent("izone:isPlayerInZone", "gokart2", function(cb)
          if cb ~= nil and not cb then
            tvRP.notify("Bye bye go kart")
            SetVehicleHasBeenOwnedByPlayer(car,false)
            SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(car))
            Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(car))
            SetVehicleHasBeenOwnedByPlayer(car,false)
            Citizen.InvokeNative(0xAD738C3085FE7E11, car, false, true) -- set not as mission entity
          end
        end)
      end
    end
  end
end

function tvRP.isCarBlacklisted(model, class)
  if not driverschool and class ~= 13 then
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
  if not tvRP.isMedic() and not tvRP.isCop() and not tvRP.isAdmin() then
    for _, blacklistedEMSCar in pairs(emsVehiclesBlacklist) do
      if model == GetHashKey(blacklistedEMSCar) then
        return true
      end
    end
  end
  return false
end

-- Blowup a player when a speed bomb event occurs
-- TODO refactor into vRP function for later uses
local function detonatePlayer(broadcast)
	local playerPed = GetPlayerPed(-1)
	local pos = GetEntityCoords(GetPlayerPed(-1))
	AddOwnedExplosion(playerPed, pos.x, pos.y, pos.z, 0, 1.0, true, false, 1.0)
	if broadcast then
		local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
		if GetStreetNameFromHashKey(var1) then
			local street1 = tostring(GetStreetNameFromHashKey(var1))
			if GetStreetNameFromHashKey(var2) and tostring(GetStreetNameFromHashKey(var2)) ~= "" then
				local street2 = tostring(GetStreetNameFromHashKey(var2))
				TriggerServerEvent('_chat:broadcast', "^3EMERGENCY", {100, 100, 100}, "A terrorist attack has occured near "..street1.." and "..street2.."!")
				TriggerServerEvent('terrorismInProgressPos', pos.x, pos.y, pos.z, "Terrorist attack reported near "..street1.." and "..street2)
			else
				TriggerServerEvent('terrorismInProgressPos', pos.x, pos.y, pos.z, "Terrorist attack reported near "..street1)
				TriggerServerEvent('_chat:broadcast', "^3EMERGENCY", {100, 100, 100}, "A terrorist attack has occured near "..street1.."!")
			end
		end
	end
end

-- thread to monitor speedbomb event
Citizen.CreateThread(function()
	local timeout = 1000
	local bombarmed = false
  while true do
    Citizen.Wait(timeout)
		local playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		if IsPedInAnyVehicle(playerPed, false) then
			local veh = GetVehiclePedIsIn(playerPed, false)
			if (GetPedInVehicleSeat(veh, -1) == playerPed) then
				local speed = math.ceil(GetEntitySpeed(veh) * 2.236936)
				local speedbomb_status = DecorGetInt(veh, "SpeedBomb")
				if speedbomb_status ~= nil and speedbomb_status > 0 then
					timeout = 0
					if speedbomb_status == 1 then
						if speed > 50 then
							vRPserver.broadcastSpatializedSound({"DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS","Hack_Success",pos.x, pos.y, pos.z,10})
							tvRP.notify("SpeedBomb Activated. Stay above 50mph!")
							DecorSetInt(veh, "SpeedBomb", 2)
							bombarmed = true
						end
					elseif speedbomb_status == 2 then
						tvRP.missionText("A Speed Bomb is active on this vehicle!")
						if speed < 50 then
							DecorSetInt(veh, "SpeedBomb", 3)
							bombarmed = false
							detonatePlayer(true)
						end
					else
						timeout = 1000
					end
				end
			end
		elseif bombarmed then
			bombarmed = false
			detonatePlayer(true)
		end
  end
end)

-- Check if player has access to enter vehicle. If no (ex. NPC parked vehicle)
-- door will be locked.
-- TODO see if this can be replaced with a event trigger instead of a loop
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

        if (lock ~= 0 and not DecorGetBool(veh,"lockpicked")) or (protected and not player_owned) then
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
  local nveh = tvRP.getVehicleAtRaycast(3)
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
      local nveh2 = tvRP.getVehicleAtRaycast(3)
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
      DecorSetBool(nveh,"lockpicked",true)
      StartVehicleAlarm(nveh) -- start car alarm
      SetTimeout(cfg.caralarm_timeout * 1000, function()
        SetVehicleAlarm(nveh,false)
      end)
    else
      tvRP.notify("Lockpicking Process Cancelled.")
    end
  end)
end

function tvRP.GetVehicleInDirection(coordFrom, coordTo)
  local rayHandle = StartShapeTestRay(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 2, GetPlayerPed(-1), 0)
  local a, b, c, d, vehicle = GetShapeTestResult(rayHandle)
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

------------------------------------------------------------------
-- Toggle engine if you own it
-- https://github.com/ToastinYou/LeaveEngineRunning
------------------------------------------------------------------
local engineVehicles = {}

function tvRP.toggleEngine()
  local veh
  local StateIndex
  for i, vehicle in ipairs(engineVehicles) do
    if vehicle[1] == GetVehiclePedIsIn(GetPlayerPed(-1), false) then
      veh = vehicle[1]
      StateIndex = i
    end
  end
  plate = GetVehicleNumberPlateText(veh)
  args = tvRP.stringsplit(plate)
  if args ~= nil then
    plate = args[1]
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
      if (GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)) then
        if tvRP.getRegistrationNumber() == plate or not IsEntityAMissionEntity(veh) then
          engineVehicles[StateIndex][2] = not GetIsVehicleEngineRunning(veh)
          local msg = nil
          if engineVehicles[StateIndex][2] then
            tvRP.notify("Engine turned ON!")
          else
            tvRP.notify("Engine turned OFF!")
          end
        else
          tvRP.notify("You don't have the keys to this vehicle.")
        end
      end
    end
  end
end

local vehicleExploded = false

function tvRP.explodeCurrentVehicle(name)
  local vehicle = vehicles[name]
  if vehicle then
    if vehicleExploded then
      vehicleExploded = false
      for i=0,7 do
        SetVehicleDoorShut(vehicle[3], i, false, false)
      end
    else
      vehicleExploded = true
      for i=0,7 do
        SetVehicleDoorOpen(vehicle[3], i, false, false)
      end
    end
  end
end

local goKartCooldown = false
local goKartTimeCooldown = 5 -- in minutes
local spawnedKartNetID = nil

function tvRP.rentOutGoKart()
  if spawnedKartNetID ~= nil then
    local vehicle = NetworkGetEntityFromNetworkId(spawnedKartNetID)
    if vehicle ~= nil then
      SetVehicleHasBeenOwnedByPlayer(vehicle,false)
      SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle))
      Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
      SetVehicleHasBeenOwnedByPlayer(vehicle,false)
      Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle, false, true) -- set not as mission entity
      Citizen.Wait(500)
    end
  end
  local mhash = GetHashKey("Kart3")

  local i = 0
  while not HasModelLoaded(mhash) and i < 10000 do
    RequestModel(mhash)
    Citizen.Wait(10)
    i = i+1
  end
  local plateNum = tvRP.getRegistrationNumber()
  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  local veh = CreateVehicle(mhash, x,y,z+0.5, 48.0, true, false)
  spawnedKartNetID = NetworkGetNetworkIdFromEntity(veh)
  SetNetworkIdCanMigrate(spawnedKartNetID,true)
  NetworkRegisterEntityAsNetworked(spawnedKartNetID)
  SetNetworkIdExistsOnAllMachines(spawnedKartNetID,true)
  NetworkRequestControlOfEntity(veh)
  SetVehicleNumberPlateText(veh, plateNum)
  SetVehicleEngineOn(veh, true, false, false)

  SetVehicleOnGroundProperly(veh)
  SetPedIntoVehicle(GetPlayerPed(-1),veh,-1) -- put player inside
  SetModelAsNoLongerNeeded(mhash)
  --Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(veh))
  goKartCooldown = true
  SetTimeout(goKartTimeCooldown * 60000, function()
    goKartCooldown = false
  end)
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value[1] == element then
      return true
    end
  end
  return false
end

-----------------------------------------
-- Chat based car mod for LSFD and LSPD
-----------------------------------------
local approvedGarares = {
  { 454.4, -1017.6, 28.4}, -- mission row police
  { 1871.0380859375, 3692.90258789063, 33.5941047668457}, -- sandy shores police
  { -1119.01953125, -858.455627441406, 13.5303745269775}, -- vespuci
  { -470.90957641602, 6017.8525390625, 31.340526580811}, -- paleto police

  { 1699.84045410156, 3582.97412109375, 35.5014381408691}, -- sandy shores ems
  { -373.39953613281, 6129.71875, 31.478042602539}, -- paleto ems
  --{ 302.42324829102, -1440.243774414, 29.79786491394}, -- strawberry ems
  {331.12121582031,-552.54223632813,28.743782043457}, -- pillbox
  {-454.30502319336,-340.23458862305,34.363471984863}, -- mount zonah ems
}

RegisterNetEvent('vRP:CarExtra')
AddEventHandler('vRP:CarExtra', function(extra,toggle)
  if extra ~= nil and toggle ~= nil then
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
      local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
      if veh ~= nil and (GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)) then
        if tvRP.isCop() or tvRP.isMedic() then
          local nearApprovedGarage = false
          for k,v in ipairs(approvedGarares) do
            if IsEntityAtCoord(GetPlayerPed(-1), v[1], v[2], v[3], 10.0, 10.0, 5.0, 0, 1, 0) then
              nearApprovedGarage = true
            end
          end
          if nearApprovedGarage then
            carModel = GetEntityModel(veh)
            carName = string.lower(GetDisplayNameFromVehicleModel(carModel))
            if tvRP.isCop() then
              if (carName == "charger" or carName == "uccvpi" or carName == "explorer" or carName == "tahoe") and tvRP.getCopLevel() > 1 then
                validateAndSetExtra(veh,extra,toggle)
              elseif carName == "fpis" and tvRP.getCopLevel() > 2 then
                validateAndSetExtra(veh,extra,toggle)
              elseif (carName == "explorer2") and tvRP.getCopLevel() > 3 then
                validateAndSetExtra(veh,extra,toggle)
              elseif (carName == "fbicharger") and tvRP.getCopLevel() > 5 then
                validateAndSetExtra(veh,extra,toggle)
              else
                tvRP.notify("You are not of sufficient rank.")
              end
            elseif tvRP.isMedic() then
              if carName == "raptor2" and tvRP.getEmergencyLevel() > 4 then
                validateAndSetExtra(veh,extra,toggle)
              elseif carName == "asstchief" and tvRP.getEmergencyLevel() > 3 then
                validateAndSetExtra(veh,extra,toggle)
              elseif carName == "chiefpara" and tvRP.getEmergencyLevel() > 2 then
                validateAndSetExtra(veh,extra,toggle)
              elseif carName == "firesuv" and tvRP.getEmergencyLevel() > 1 then
                validateAndSetExtra(veh,extra,toggle)
              else
                tvRP.notify("You are not of sufficient rank.")
              end
            end
          else
            tvRP.notify("You are not near a LSPD/LSFD garage facility.")
          end
        end
      end
    end
  end
end)

function validateAndSetExtra(veh,extra,toggle)
  if DoesExtraExist(veh,extra) then
    SetVehicleExtra(veh,extra,toggle)
  else
    tvRP.notify("That is not a valid option")
    --[[
    extrasText = "Available extras: "
    firstSet = false
    for i=1,14 do
      if DoesExtraExist(veh,extra) then
        if not firstSet then
          extrasText = extrasText..i
          firstSet = true
        else
          extrasText = extrasText..", i"
        end
      end
    end
    tvRP.notify(extrasText)
    ]]--
  end
end

RegisterNetEvent('vRP:CarLivery')
AddEventHandler('vRP:CarLivery', function(value)
  if value ~= nil then
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
      local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
      if veh ~= nil and (GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)) then
        if tvRP.isAdmin() then
          SetVehicleLivery(veh,value)
        elseif tvRP.isCop() then
          carModel = GetEntityModel(veh)
          carName = string.lower(GetDisplayNameFromVehicleModel(carModel))
          if (carName == "charger" or carName == "tahoe" or carName == "fpis") and tvRP.getCopLevel() > 3 then
            SetVehicleLivery(veh,value)
          else
            tvRP.notify("You are not of sufficient rank and/or not available")
          end
        end
      end
    end
  end
end)
