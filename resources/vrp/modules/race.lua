local active_races = {}
local timeout = 10

function tvRP.promptNearbyRace(raceID,sourcePosx,sourcePosy,sourcePosz,raceCoordx,raceCoordy,raceCoordz)
  print(raceID)
  if active_races[raceID] == nil then
    active_races[raceID] = {}
    for k,v in pairs(vRP.rusers) do
      local player = vRP.getUserSource(k)
      vRP.requestCoordRange(player, "Join Race?", 1000, sourcePosx,sourcePosy,sourcePosz, 15, function(player,ok)
        if ok then
          active_races[raceID][player] = true
          if active_races[raceID][player] ~= nil then
            print("Entered Race")
          else
            print("No entry to race")
          end
        end
      end)
    end
    vRP.raceCountDown(raceID, raceCoordx,raceCoordy,raceCoordz)
  end
end

function vRP.raceCountDown(raceID, raceCoordx,raceCoordy,raceCoordz)
  print("Count down the race")
  local rCoordx = raceCoordx
  local rCoordy = raceCoordy
  SetTimeout(1500, function()
    print("timer ended, race should have started")
    for k,v in pairs(active_races[raceID]) do
      if v then
        vRPclient.startRace(k, {rCoordx,rCoordy})
      end
    end
  end)
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
