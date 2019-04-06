local active_races = {}
local timeout = 10

function tvRP.promptNearbyRace(sourcePosx,sourcePosy,sourcePosz,raceCoordx,raceCoordy,raceCoordz)
  raceID = os.time()
  if active_races[raceID] == nil then
    active_races[raceID]["currentPos"] = 1
    for k,v in pairs(vRP.rusers) do
      local player = vRP.getUserSource(k)
      vRP.requestCoordRange(player, "Join Race?", 10, sourcePosx,sourcePosy,sourcePosz, 15, function(player,ok)
        if ok then
          active_races[raceID][player] = true
        end
      end)
    end
    vRP.raceCountDown(raceID, raceCoordx,raceCoordy,raceCoordz)
  end
end

function vRP.raceCountDown(raceID, raceCoordx,raceCoordy,raceCoordz)
  local rCoordx = raceCoordx
  local rCoordy = raceCoordy
  local rCoordz = raceCoordz
  SetTimeout(15000, function()
    for k,v in pairs(active_races[raceID]) do
      if v then
        vRPclient.startRace(k, {raceID,rCoordx,rCoordy,rCoordz})
      end
    end
  end)
  SetTimeout()
end

function tvRP.raceComplete(player, raceID)
  print("Server player finished")
  local currentPos = active_races[raceID]["currentPos"]
  vRPclient.notify(source, {"Race Position: "..currentPos})
  print("Pos = "..currentPos)
  --active_races[raceID][player] = currentPos
  active_races[raceID]["currentPos"] = (currentPos + 1)
end

--[[
1 person start it

check if they already started one

if ok send race request to ALL players

player checks if in range

if in range get prompt to pariticate

server tracks participants

race starter generates coordinate

to generate the coordinate, we need to get max/min x and y for the map

then random pick a x and y from those ranges. Z should be able to be anything????

use GetClosestVehicleNode() then send that to the server

server countdown, then sent to clients

clients set gps and send result on arival

server track order
]]--
