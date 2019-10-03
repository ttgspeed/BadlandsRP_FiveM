function GetClosestPed(radius)
    local closestPed = 0

    for ped in EnumeratePeds() do
        local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped), true)
        if distanceCheck <= radius+.000001 and ped ~= GetPlayerPed(-1) then
            closestPed = ped
            break
        end
    end

    return closestPed
end

function GetClosestPlayer(radius)
  local closestPed = 0

  for ped in EnumeratePeds() do
    local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped), true)
    if distanceCheck <= radius+.000001 and ped ~= GetPlayerPed(-1) then
      local closePedID = GetPlayerByEntityID(ped)
      if closePedID ~= nil and NetworkIsPlayerActive(closePedID) then
        closestPed = GetPlayerServerId(closePedID)
        break
      end
    end
  end
  return closestPed
end

function GetClosestPlayers(radius)
  local closestPeds = {}

  for ped in EnumeratePeds() do
    local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped), true)
    if distanceCheck <= radius+.000001 and ped ~= GetPlayerPed(-1) then
      local closePedID = GetPlayerByEntityID(ped)
      if closePedID ~= nil and NetworkIsPlayerActive(closePedID) then
        local closestPed = GetPlayerServerId(closePedID)
        table.insert(closestPeds, closestPed)
      end
    end
  end
  return closestPeds
end

function GetClosestVehicle(radius)
    local closestVeh = 0

    for veh in EnumerateVehicles() do
        local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(veh), true)
        if distanceCheck <= radius+.000001 then
            closestVeh = veh
            break
        end
    end

    return closestVeh
end

function TargetVehicleInProximity(radius,vplate,vname)
  local closestVeh = 0

  for veh in EnumerateVehicles() do
    local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(veh), true)
    if distanceCheck <= radius+.000001 then
      local carModel = GetEntityModel(veh)
      local carName = GetDisplayNameFromVehicleModel(carModel)
      local plate = GetVehicleNumberPlateText(veh)
      local args = tvRP.stringsplit(plate)
      closestVeh = veh
      if args ~= nil then
        plate = args[1]
        if vplate == plate and string.lower(vname) == string.lower(carName) then
          return true
        end
      end
    end
    end
  return false
end

function GetClosestParkedVehicles(radius, maxQty)
	local closestVehicles = {}
	local count = 0
	for veh in EnumerateVehicles() do
		local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(veh), true)
		local popType = GetEntityPopulationType(veh)
		if distanceCheck <= radius+.000001 and popType == 2 then
			count = count + 1
			table.insert(closestVehicles, veh)
		end
		if count == maxQty then
			break
		end
	end
	return closestVehicles
end

local entityEnumerator = {
  __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
      disposeFunc(iter)
      return
    end

    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)

    local next = true
    repeat
      coroutine.yield(id)
      next, id = moveFunc(iter)
    until not next

    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

function EnumerateObjects()
  return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
  return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
  return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function GetPlayerByEntityID(id)
  for _, i in ipairs(GetActivePlayers()) do
    if(GetPlayerPed(i) == id) then return i end
  end
	return nil
end
