local active_races = {}
local timeout = 10

function tvRP.promptNearbyRace(sourcePosx,sourcePosy,sourcePosz,raceCoordx,raceCoordy,raceCoordz)
  local raceID = os.time()
  if active_races[raceID] == nil then
    active_races[raceID] = {}
    active_races[raceID]["currentPos"] = 1
    for k,v in pairs(vRP.rusers) do
      local player = vRP.getUserSource(k)
      vRP.requestCoordRange(player, "Join Race?", 10, sourcePosx,sourcePosy,sourcePosz, 15, function(player,ok)
        if ok then
          active_races[raceID][player] = true
          if active_races[raceID][player] ~= nil then
            vRPclient.notify(player, {"You have entered the race. It will be starting soon."})
          end
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
end

function tvRP.raceComplete(player, raceID)
  local currentPos = active_races[raceID]["currentPos"]
  vRPclient.notify(source, {"Race Position: "..currentPos})
  active_races[raceID]["currentPos"] = (currentPos + 1)
end

function raceCleanup()
  for k,v in pairs (active_races) do
    if (os.time() - k) > 600 then -- if races are older than 10 min, delete them
      active_races[k] = nil
    end
  end
  SetTimeout(60000 * 15, raceCleanup)
end

SetTimeout(60000 * 15, raceCleanup)
