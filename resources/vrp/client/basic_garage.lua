
local vehicles = {}

function tvRP.spawnGarageVehicle(vtype,name,options) -- vtype is the vehicle type (one vehicle per type allowed at the same time)

  local vehicle = vehicles[vtype]
  if vehicle and not IsVehicleDriveable(vehicle[3]) then -- precheck if vehicle is undriveable
    -- despawn vehicle
    SetEntityAsMissionEntity(vehicle[3],true,true)
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle[3]))
    vehicles[vtype] = nil
  end

  vehicle = vehicles[vtype]
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
      SetEntityAsMissionEntity(veh,false,false)

      SetVehicleModKit(veh, 0)
      if name ~= "police" and name ~= "police2" and name ~= "police3" and name ~= "police4" and name ~= "policet" and name ~= "policeb" and name ~= "ambulance" and name ~= "firetruk" then
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

      options.mods = json.decode(options.mods)

      if options.mods and type(options.mods) == "table" then
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

      vehicles[vtype] = {vtype,name,veh} -- set current vehicule

  		local blip = AddBlipForEntity(veh)
  		SetBlipSprite(blip, 225)

      SetModelAsNoLongerNeeded(mhash)
    end
  else
    tvRP.notify("You can only have one "..vtype.." vehicule out.")
  end
end

function tvRP.despawnGarageVehicle(vtype,max_range)
  local vehicle = vehicles[vtype]
  if vehicle then
    local x,y,z = table.unpack(GetEntityCoords(vehicle[3],true))
    local px,py,pz = tvRP.getPosition()

    if GetDistanceBetweenCoords(x,y,z,px,py,pz,true) < max_range then -- check distance with the vehicule
      -- remove vehicle
      SetEntityAsMissionEntity(vehicle[3],true,true)
      Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle[3]))
      vehicles[vtype] = nil
      tvRP.notify("Vehicle stored.")
    else
      tvRP.notify("Too far away from the vehicle.")
    end
  end
end

-- (deprecated) this function return the nearest vehicle
-- (don't work with lot of vehicles, police, etc...)
function tvRP.getNearestVehicle(radius)
  local x,y,z = tvRP.getPosition()
  local ped = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ped) then
    return GetVehiclePedIsIn(ped, true)
  else
    return GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 70)
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
function tvRP.getOwnedVehiclePosition(vtype)
  local vehicle = vehicles[vtype]
  local x,y,z = 0,0,0

  if vehicle then
    x,y,z = table.unpack(GetEntityCoords(vehicle[3],true))
  end

  return x,y,z
end

function tvRP.getOwnedVehicleId(vtype)
  local vehicle = vehicles[vtype]
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
function tvRP.vc_openDoor(vtype, door_index)
  local vehicle = vehicles[vtype]
  if vehicle then
    SetVehicleDoorOpen(vehicle[3],door_index,0,false)
  end
end

function tvRP.vc_closeDoor(vtype, door_index)
  local vehicle = vehicles[vtype]
  if vehicle then
    SetVehicleDoorShut(vehicle[3],door_index)
  end
end

function tvRP.vc_detachTrailer(vtype)
  local vehicle = vehicles[vtype]
  if vehicle then
    DetachVehicleFromTrailer(vehicle[3])
  end
end
