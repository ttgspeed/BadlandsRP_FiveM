local active_races = {}
local timeout = 10

function tvRP.promptNearbyRace(sourcePosx,sourcePosy,sourcePosz,raceCoordx,raceCoordy,raceCoordz,betAmount)
  local raceID = os.time()
  if active_races[raceID] == nil then
    active_races[raceID] = {}
    active_races[raceID]["currentPos"] = 1
    active_races[raceID]["betPool"] = 0
    for k,v in pairs(vRP.rusers) do
      local player = vRP.getUserSource(k)
      vRP.requestRaceRange(player, "Join Race. Wager is set to $"..betAmount.."?", 10, sourcePosx,sourcePosy,sourcePosz, 15, function(player,ok)
        if ok then
          local user_id = vRP.getUserId(player)
          if betAmount == 0 or vRP.tryPayment(user_id,betAmount) then
            active_races[raceID][player] = true
            active_races[raceID]["betPool"] = active_races[raceID]["betPool"] + betAmount
            if active_races[raceID][player] ~= nil then
              vRPclient.notify(player, {"You have entered the race. It will be starting soon."})
              vRPclient.startRace(player, {raceID,raceCoordx,raceCoordy,raceCoordz})
            end
          else
            vRPclient.notify(player, {"You don't have enough cash on hand"})
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
        vRPclient.signalStart(k, {})
      end
    end
  end)
end

function tvRP.raceComplete(raceID)
  local currentPos = active_races[raceID]["currentPos"]
  if currentPos == 1 then
    local betPool = active_races[raceID]["betPool"]
    active_races[raceID]["betPool"] = 0
    if betPool > 0 then
      local user_id = vRP.getUserId(source)
      vRP.giveMoney(user_id,betPool)
      vRPclient.notify(source, {"You won $"..betPool})
    end
  else
    vRPclient.notify(source, {"Race Position: "..currentPos})
  end
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
