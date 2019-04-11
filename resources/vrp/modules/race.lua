local active_races = {}
local timeout = 10

function tvRP.promptNearbyRace(sourcePosx,sourcePosy,sourcePosz,raceCoordx,raceCoordy,raceCoordz)
  print("Got in prompt function")
  local raceID = os.time()
  if active_races[raceID] == nil then
    active_races[raceID] = {}
    active_races[raceID]["currentPos"] = 1
    for k,v in pairs(vRP.rusers) do
      print("I got inside the loop")
      local player = vRP.getUserSource(k)
      vRP.requestCoordRange(player, "Join Race?", 10, sourcePosx,sourcePosy,sourcePosz, 15, function(player,ok)
        if ok then
          active_races[raceID][player] = true
          if active_races[raceID][player] ~= nil then
            print("Entered Race")
            vRPclient.notify(player, {"You have entered the race. It will be starting soon."})
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
  local rCoordz = raceCoordz
  SetTimeout(15000, function()
    print("timer ended, race should have started")
    for k,v in pairs(active_races[raceID]) do
      if v then
        vRPclient.startRace(k, {raceID,rCoordx,rCoordy,rCoordz})
      end
    end
  end)
end

function tvRP.raceComplete(player, raceID)
  print("Server player finished")
  local currentPos = active_races[raceID]["currentPos"]
  vRPclient.notify(source, {"Race Position: "..currentPos})
  print("Pos = "..currentPos)
  active_races[raceID]["currentPos"] = (currentPos + 1)
end

function raceCleanup()
  for k,v in pairs (active_races) do
    if (os.time() - k) > 600 then -- if races are older than 10 min, delete them
      print('race cleaned up')
      active_races[k] = nil
    end
  end
  SetTimeout(60000 * 15, raceCleanup)
end

SetTimeout(60000 * 15, raceCleanup)

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
