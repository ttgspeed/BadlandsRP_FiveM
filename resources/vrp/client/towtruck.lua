-- Created by Asser90 - modified by Deziel0495 and IllusiveTea - further modified by Vespura --
--https://forum.fivem.net/t/release-fx-towtruck-script-v1-2/10590
--https://github.com/Deziel0495/TowScript

-- These vehicles will be registered as "allowed/valid" tow trucks.
-- Change the x, y and z offset values for the towed vehicles to be attached to the towtruck.
-- x = left/right, y = forwards/backwards, z = up/down
local allowedTowModels = {
    ['flatbed'] = {x = 0.0, y = -0.85, z = 0.95}, -- default GTA V flatbed
    --['flatbed2'] = {x = 0.0, y = 0.0, z = 0.68}, -- addon flatbed2 (provided with the script)
    --['flatbed3'] = {x = 0.0, y = -1.2, z = 1.30}, -- addon flatbed3 (also provided with the script)
}

local paintColors = {
	{name = "Black", colorindex = 0},
  {name = "Carbon Black", colorindex = 147},
	{name = "Graphite", colorindex = 1},
  {name = "Anthracite Black", colorindex = 11},
	{name = "Black Steel", colorindex = 2},
  {name = "Dark Steel", colorindex = 3},
	{name = "Silver", colorindex = 4},
  {name = "Bluish Silver", colorindex = 5},
	{name = "Rolled Steel", colorindex = 6},
  {name = "Shadow Silver", colorindex = 7},
	{name = "Stone Silver", colorindex = 8},
  {name = "Midnight Silver", colorindex = 9},
	{name = "Cast Iron Silver", colorindex = 10},
  {name = "Red", colorindex = 27},
	{name = "Torino Red", colorindex = 28},
  {name = "Formula Red", colorindex = 29},
	{name = "Lava Red", colorindex = 150},
  {name = "Blaze Red", colorindex = 30},
	{name = "Grace Red", colorindex = 31},
  {name = "Garnet Red", colorindex = 32},
	{name = "Sunset Red", colorindex = 33},
  {name = "Cabernet Red", colorindex = 34},
	{name = "Wine Red", colorindex = 143},
  {name = "Candy Red", colorindex = 35},
	{name = "Hot Pink", colorindex = 135},
  {name = "Pfsiter Pink", colorindex = 137},
	{name = "Salmon Pink", colorindex = 136},
  {name = "Sunrise Orange", colorindex = 36},
	{name = "Orange", colorindex = 38},
  {name = "Bright Orange", colorindex = 138},
	{name = "Gold", colorindex = 99},
  {name = "Bronze", colorindex = 90},
	{name = "Yellow", colorindex = 88},
  {name = "Race Yellow", colorindex = 89},
	{name = "Dew Yellow", colorindex = 91},
  {name = "Dark Green", colorindex = 49},
	{name = "Racing Green", colorindex = 50},
  {name = "Sea Green", colorindex = 51},
	{name = "Olive Green", colorindex = 52},
  {name = "Bright Green", colorindex = 53},
	{name = "Gasoline Green", colorindex = 54},
  {name = "Lime Green", colorindex = 92},
	{name = "Midnight Blue", colorindex = 141},
	{name = "Galaxy Blue", colorindex = 61},
  {name = "Dark Blue", colorindex = 62},
	{name = "Saxon Blue", colorindex = 63},
  {name = "Blue", colorindex = 64},
	{name = "Mariner Blue", colorindex = 65},
  {name = "Harbor Blue", colorindex = 66},
	{name = "Diamond Blue", colorindex = 67},
  {name = "Surf Blue", colorindex = 68},
	{name = "Nautical Blue", colorindex = 69},
  {name = "Racing Blue", colorindex = 73},
	{name = "Ultra Blue", colorindex = 70},
  {name = "Light Blue", colorindex = 74},
	{name = "Chocolate Brown", colorindex = 96},
  {name = "Bison Brown", colorindex = 101},
	{name = "Creeen Brown", colorindex = 95},
  {name = "Feltzer Brown", colorindex = 94},
	{name = "Maple Brown", colorindex = 97},
  {name = "Beechwood Brown", colorindex = 103},
	{name = "Sienna Brown", colorindex = 104},
  {name = "Saddle Brown", colorindex = 98},
	{name = "Moss Brown", colorindex = 100},
  {name = "Woodbeech Brown", colorindex = 102},
	{name = "Straw Brown", colorindex = 99},
  {name = "Sandy Brown", colorindex = 105},
	{name = "Bleached Brown", colorindex = 106},
  {name = "Schafter Purple", colorindex = 71},
	{name = "Spinnaker Purple", colorindex = 72},
  {name = "Midnight Purple", colorindex = 142},
	{name = "Bright Purple", colorindex = 145},
  {name = "Cream", colorindex = 107},
	{name = "Ice White", colorindex = 111},
  {name = "Frost White", colorindex = 112},
	{name = "Brushed Steel",colorindex = 117},
	{name = "Brushed Black Steel",colorindex = 118},
	{name = "Brushed Aluminum",colorindex = 119},
	{name = "Pure Gold",colorindex = 158},
	{name = "Brushed Gold",colorindex = 159},
	{name = "Black", colorindex = 12},
	{name = "Gray", colorindex = 13},
	{name = "Light Gray", colorindex = 14},
	{name = "Ice White", colorindex = 131},
	{name = "Blue", colorindex = 83},
	{name = "Dark Blue", colorindex = 82},
	{name = "Midnight Blue", colorindex = 84},
	{name = "Midnight Purple", colorindex = 149},
	{name = "Schafter Purple", colorindex = 148},
	{name = "Red", colorindex = 39},
	{name = "Dark Red", colorindex = 40},
	{name = "Orange", colorindex = 41},
	{name = "Yellow", colorindex = 42},
	{name = "Lime Green", colorindex = 55},
	{name = "Green", colorindex = 128},
	{name = "Frost Green", colorindex = 151},
	{name = "Foliage Green", colorindex = 155},
	{name = "Olive Drab", colorindex = 152},
	{name = "Dark Earth", colorindex = 153},
	{name = "Desert Tan", colorindex = 154},
  {name = "Chrome", colorindex = 120}
}


local allowTowingBoats = false -- Set to true if you want to be able to tow boats.
local allowTowingPlanes = false -- Set to true if you want to be able to tow planes.
local allowTowingHelicopters = false -- Set to true if you want to be able to tow helicopters.
local allowTowingTrains = false -- Set to true if you want to be able to tow trains.
local allowTowingTrailers = false -- Disables trailers. NOTE: THIS ALSO DISABLES: AIRTUG, TOWTRUCK, SADLER, ANY OTHER VEHICLE THAT IS IN THE UTILITY CLASS.

local currentlyTowedVehicle = nil

local currentTowTruck = nil
local isTowDriver = false

function tvRP.setTowDriver(toggle)
  if toggle then
    isTowDriver = true
    Citizen.CreateThread(function()
			while isTowDriver do
				Citizen.Wait(0)
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1))  then
          currentVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
          if tvRP.isVehicleATowTruck(currentVeh) then
            currentTowTruck = currentVeh
          end
        end
      end
    end)
  else
    isTowDriver = false
    currentTowTruck = nil
  end
end

function tvRP.getIsCurrentlyTowing()
    if currentlyTowedVehicle ~= nil then
        return true
    end
    return false
end

function isTargetVehicleATrailer(modelHash)
    if GetVehicleClassFromName(modelHash) == 11 then
        return true
    else
        return false
    end
end

local xoff = 0.0
local yoff = 0.0
local zoff = 0.0

function tvRP.isVehicleATowTruck(vehicle)
    local isValid = false
    for model,posOffset in pairs(allowedTowModels) do
        if IsVehicleModel(vehicle, model) then
            xoff = posOffset.x
            yoff = posOffset.y
            zoff = posOffset.z
            isValid = true
            break
        end
    end
    return isValid
end

RegisterNetEvent('tow')
AddEventHandler('tow', function()

	local playerped = PlayerPedId()
	local vehicle = currentTowTruck
  if vehicle == nil then
    vehicle = GetVehiclePedIsIn(playerped, true)
  end

	local isVehicleTow = tvRP.isVehicleATowTruck(vehicle)

	if isVehicleTow then

		local targetVehicle = GetClosestVehicle(5)

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)
				isVehicleTow = tvRP.isVehicleATowTruck(vehicle)
				local roll = GetEntityRoll(GetVehiclePedIsIn(PlayerPedId(), true))
				if currentlyTowedVehicle ~= nil and IsEntityUpsidedown(GetVehiclePedIsIn(PlayerPedId(), true)) and isVehicleTow or roll > 70.0 or roll < -70.0 then
					DetachEntity(currentlyTowedVehicle, false, false)
					currentlyTowedVehicle = nil
          tvRP.notify("Tow Service: Looks like the cables holding on the vehicle have broke!")
				end
			end
		end)

		if currentlyTowedVehicle == nil then
			if targetVehicle ~= nil then
        local targetVehicleLocation = GetEntityCoords(targetVehicle, true)
        local towTruckVehicleLocation = GetEntityCoords(vehicle, true)
        local distanceBetweenVehicles = #(vector3(targetVehicleLocation.x,targetVehicleLocation.y,targetVehicleLocation.z)-vector3(towTruckVehicleLocation.x,towTruckVehicleLocation.y,towTruckVehicleLocation.z))
        --print(tostring(distanceBetweenVehicles)) -- debug only
        if distanceBetweenVehicles > 15.0 then
            tvRP.notify("Tow Service: Your cables can't reach this far, move you truck closer to the vehicle.")
        else
            local targetModelHash = GetEntityModel(targetVehicle)
            -- Check to make sure the target vehicle is allowed to be towed (see settings at lines 8-12)
            if not ((not allowTowingBoats and IsThisModelABoat(targetModelHash)) or (not allowTowingHelicopters and IsThisModelAHeli(targetModelHash)) or (not allowTowingPlanes and IsThisModelAPlane(targetModelHash)) or (not allowTowingTrains and IsThisModelATrain(targetModelHash)) or (not allowTowingTrailers and isTargetVehicleATrailer(targetModelHash))) then
                if not IsPedInAnyVehicle(playerped, true) then
                    if vehicle ~= targetVehicle and IsVehicleStopped(vehicle) then
                        exports['mythic_scripts']:Progress({
                            name = "tow_vehicle_action",
                            duration = 5000,
                            label = "Loading Vehicle",
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = false,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            animation = {
                                task= "PROP_HUMAN_BUM_BIN",
                            },
                        }, function(status)
                            if not status then
                              if not IsEntityAMissionEntity(targetVehicle) then
                                SetEntityAsMissionEntity(targetVehicle, true, true)
                              end
                              AttachEntityToEntity(targetVehicle, vehicle, GetEntityBoneIndexByName(vehicle, 'bodyshell'), 0.0 + xoff, -1.5 + yoff, 0.0 + zoff, 0, 0, 0, 1, 1, 0, 0, 0, 1)
                              currentlyTowedVehicle = targetVehicle
                              tvRP.notify("Tow Service: Vehicle has been loaded onto the flatbed.")
                            end
                        end)
                    else
                        tvRP.notify("Tow Service: There is currently no vehicle on the flatbed.")
                    end
                else
                    tvRP.notify("Tow Service: You need to be outside of your vehicle to load or unload vehicles.")
                end
            else
                tvRP.notify("Tow Service: Your towtruck is not equipped to tow this vehicle.")
            end
        end
      else
          tvRP.notify("Tow Service: No towable vehicle detected.")
			end
		elseif IsVehicleStopped(vehicle) then
      exports['mythic_scripts']:Progress({
          name = "tow_vehicle_action",
          duration = 5000,
          label = "Unloading Vehicle",
          useWhileDead = false,
          canCancel = true,
          controlDisables = {
              disableMovement = false,
              disableCarMovement = false,
              disableMouse = false,
              disableCombat = true,
          },
          animation = {
              task= "PROP_HUMAN_BUM_BIN",
          },
      }, function(status)
          if not status then
            DetachEntity(currentlyTowedVehicle, false, false)
            local vehiclesCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -12.0, 0.0)
      			SetEntityCoords(currentlyTowedVehicle, vehiclesCoords["x"], vehiclesCoords["y"], vehiclesCoords["z"], 1, 0, 0, 1)
      			SetVehicleOnGroundProperly(currentlyTowedVehicle)
      			currentlyTowedVehicle = nil
      			tvRP.notify("Tow Service: Vehicle has been unloaded from the flatbed.")
          end
      end)
		end
  else
    tvRP.notify("Tow Service: Your vehicle is not registered as an official Tow Service tow truck.")
  end
end)

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
	DrawNotification(false, false)
end

local activeTowJob = false
local lastTowTime = GetGameTimer() -- in ms
local zoneCoord = nil
local zoneBlip = nil
local parkedCarBlip = nil
local parkedTarget = nil
local activeTowZoneThread = false
local activeTowCarThread = false

function tvRP.RequestTowJob()
  if not DoesEntityExist(parkedTarget) and not activeTowZoneThread then
    local x, y, z = getRandomCoord()
    local masterTimeout = 1000
    zoneCoord = nil
    local point_found = false
    while not point_found and masterTimeout > 0 do
      Citizen.Wait(1)
      _bool, zoneCoord = GetClosestVehicleNode(x, y, z, 0, 100.0, 2.5)
      if _bool then
        if zoneCoord ~= nil then
          point_found = true
        end
      else
        x, y, z = getRandomCoord()
      end
      masterTimeout = masterTimeout - 1
    end
    if zoneCoord ~= nil then
      local ground
      local groundFound = false
      local groundCheckHeights = {-50.0, 0.0, 50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0}
      for i,height in ipairs(groundCheckHeights) do
        RequestCollisionAtCoord(zoneCoord.x, zoneCoord.y, height)
        Wait(0)
        ground,z = GetGroundZFor_3dCoord(zoneCoord.x, zoneCoord.y,height)
        if(ground) then
          groundFound = true
          break;
        end
      end
      if z ~= 0.0 then
        createTowZoneBlip(zoneCoord.x, zoneCoord.y, z)
        goToTowZoneThread(zoneCoord.x, zoneCoord.y, z)
      else
        tvRP.notify("Dispatch is backed up. Try again.")
      end
    end
  else
    tvRP.notify("You already have an active dispatch")
  end
end

function createTowZoneBlip(x,y,z)
  local x, y, z = x, y, z
  if zoneBlip ~= nil and DoesBlipExist(zoneBlip) then
    RemoveBlip(zoneBlip)
  end
  if parkedCarBlip ~= nil and DoesBlipExist(parkedCarBlip) then
    RemoveBlip(parkedCarBlip)
  end
  SetNewWaypoint(x, y)
  zoneBlip = AddBlipForRadius(x, y, z, 20.0)
  SetBlipAlpha(zoneBlip, 80)
	SetBlipSprite(zoneBlip, 9)
  SetBlipColour(zoneBlip, 2)
  tvRP.notify("Proceed to the indicated area on your map")
end

function goToTowZoneThread(x,y,z)
  local x, y, z = x, y, z
  if not activeTowZoneThread and not activeTowCarThread then
    activeTowZoneThread = true
    Citizen.CreateThread(function()
      while activeTowZoneThread do
        Citizen.Wait(0)
        local pedPos = GetEntityCoords(GetPlayerPed(-1))
        local distance = #(vector3(pedPos.x, pedPos.y, pedPos.z)-vector3(x,y,z))
        if distance < 20 then
          activeTowZoneThread = false
          goToTowCarThread(x,y,z)
        end
      end
    end)
  end
end

function tvRP.killTowZoneThread()
  activeTowZoneThread = false
  if zoneBlip ~= nil and DoesBlipExist(zoneBlip) then
    RemoveBlip(zoneBlip)
  end
end

function goToTowCarThread(x,y,z)
  local x, y, z = x, y, z
  tvRP.notify("Hang tight while dispatch sends you the vehicle details and location.")
  Citizen.Wait("3000")
  local closestParkedVehicles = GetClosestParkedVehicles(150, 20)
  if closestParkedVehicles ~= nil and #closestParkedVehicles > 0 then
    local randomNumber = math.random(1,#closestParkedVehicles)
    local closestVehicle = closestParkedVehicles[randomNumber]
    if closestVehicle ~= nil then
      if zoneBlip ~= nil and DoesBlipExist(zoneBlip) then
        RemoveBlip(zoneBlip)
      end
      if parkedCarBlip ~= nil and DoesBlipExist(parkedCarBlip) then
        RemoveBlip(parkedCarBlip)
      end

      SetVehicleHasBeenOwnedByPlayer(closestVehicle,true)
      SetEntityAsMissionEntity(closestVehicle, true, true)

      local nid = VehToNet(closestVehicle)
      SetNetworkIdCanMigrate(nid,true)
      NetworkRegisterEntityAsNetworked(nid)
      SetNetworkIdExistsOnAllMachines(closestVehicle,true)
      NetworkRequestControlOfEntity(closestVehicle)

      local plate = GetVehicleNumberPlateText(closestVehicle)
      local args = tvRP.stringsplit(plate)
      if args ~= nil then
        plate = args[1]
        local carModel = GetEntityModel(closestVehicle)
        local carName = GetDisplayNameFromVehicleModel(carModel)

        local colour1, colour2 = GetVehicleColours(closestVehicle)
        local colour1Text = "Unknown"
        local colour2Text = "Unknown"
        for k,v in pairs(paintColors) do
          if v.colorindex == colour1 then
            colour1Text = v.name
          end
          if v.colorindex == colour2 then
            colour2Text = v.name
          end
        end
        tvRP.notify("The vehicle is a "..carName.." with "..colour1Text.." paint and "..colour2Text.." trim. Plate number is "..plate)
        local parkedCarBlip = AddBlipForEntity(closestVehicle)
        SetBlipSprite(parkedCarBlip, 326)
        SetBlipColour(parkedCarBlip, 2)
        SetBlipScale(parkedCarBlip, 0.8)
        SetBlipAsShortRange(parkedCarBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Tow Target")
        EndTextCommandSetBlipName(parkedCarBlip)
        parkedTarget = closestVehicle
        local parkedVehPos = GetEntityCoords(closestVehicle)
        vRPserver.addToTowList({plate,carName,parkedVehPos.x,parkedVehPos.y,parkedVehPos.z})
        if not activeTowZoneThread and not activeTowCarThread then
          activeTowCarThread = true
          Citizen.CreateThread(function()
            while activeTowCarThread do
              Citizen.Wait(0)
              local pedPos = GetEntityCoords(GetPlayerPed(-1))
              local distance = #(vector3(pedPos.x, pedPos.y, pedPos.z)-vector3(parkedVehPos.x,parkedVehPos.y,parkedVehPos.z))
              if distance < 5 then
                activeTowCarThread = false
                tvRP.notify("Take this to the impound yard...biatch")
              end
            end
          end)
        end
      end
    else
      tvRP.notify("You got here too late. A competing firm got the job.")
    end
  else
    tvRP.notify("You got here too late. A competing firm got the job.")
  end
end

function tvRP.killTowCarThread()
  activeTowCarThread = false
  if parkedCarBlip ~= nil and DoesBlipExist(parkedCarBlip) then
    RemoveBlip(parkedCarBlip)
  end
end
