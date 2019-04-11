local active_host = false

RegisterNetEvent('vRP:initiateRace')
AddEventHandler('vRP:initiateRace', function()
  print("I go here")
  if not active_host then
    active_host = true
    local point_found = false
    local x, y, z = getRandomCoord()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local raceCoord = nil
    local masterTimeout = 1000
    while not point_found and masterTimeout > 0 do
      Citizen.Wait(1)
      print("Searching")
      _bool, raceCoord = GetClosestVehicleNode(x, y, z, 0, 100.0, 2.5)
      if _bool then
        if raceCoord ~= nil then
          point_found = true
          print("Found shit")
        else
          print("Found shit but bad coord")
        end
      else
        x, y, z = getRandomCoord()
      end
      masterTimeout = masterTimeout - 1
    end
    if masterTimeout < 1 then
    end
    if raceCoord ~= nil then
      print("Race prompt")
      vRPserver.promptNearbyRace({pos.x, pos.y, pos.z, raceCoord.x, raceCoord.y, raceCoord.z})
    end
    active_host = false
  end
end)

RegisterNetEvent('vRP:quitRace')
AddEventHandler('vRP:quitRace', function()
  if inRace then
    inRace = false
  end
end)

local inRace = false

function tvRP.startRace(raceID,rCoordx,rCoordy,rCoordz)
  if not inRace then
    inRace = true
    SetNewWaypoint(rCoordx,rCoordy)
    Citizen.CreateThread(function()
    	while inRace do
    		Citizen.Wait(0)
        if IsEntityAtCoord(GetPlayerPed(-1), rCoordx, rCoordy, rCoordz, 7.001, 7.001, 15.001, 0, 1, 0) then
          vRPserver.raceComplete({GetPlayerPed(-1), raceID})
          inRace = false
          print("got to race end thread")
        end
        if not IsWaypointActive() and inRace then
          SetNewWaypoint(rCoordx,rCoordy)
        end
      end
      print("thread killed")
    end)
  end
end

function getRandomCoord()
  local x = math.random(-3512, 4150)+0.0001
  local y = math.random(-3480, 7284)+0.0001
  local z = 40.00001
  return x, y, z
end

--[[
bottom left
-3512.86, -3480.56
bottom right
4150.7, -3480.56
top right
4150.7, 7284.78
top left
-3512.86, 7284.78
]]--
