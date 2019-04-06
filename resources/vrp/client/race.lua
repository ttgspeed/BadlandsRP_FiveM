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
        print("New coord gen")
      end
      masterTimeout = masterTimeout - 1
    end
    if masterTimeout < 1 then
      print("Timed out")
    end
    if raceCoord ~= nil then
      vRPserver.promptNearbyRace({GetPlayerPed(-1), pos.x, pos.y, pos.z, raceCoord.x, raceCoord.y, raceCoord.z})
      --SetNewWaypoint(raceCoord.x,raceCoord.y)
    end
    active_host = false
  end
end)

function tvRP.startRace(rCoordx,rCoordy)
  print("Waypoint should be set")
  SetNewWaypoint(rCoordx,rCoordy)
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
