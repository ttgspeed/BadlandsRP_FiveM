-----------------
---   Notes   ---
-----------------
--activeTurfs table:
---- "player" tracks the player currently in the turf, nil if no player
---- "reputation" tracks the current reputation of the turf.
-------- The turf gains reputation for every "tick" that someone is active in the turf.
-------- The idea is to create incentive for players to A) stay in the same turf B) contest existing turfs.
-------- Cops should also pay attention to which turfs have high drug activity and focus patrol on them
-------- This is an attempt to increase the risk/reward

-----------------
--- Variables ---
-----------------
local cfg = module("cfg/drugturf")

local drugTurf = {}   --Table holds all local drugTurf functions

local activeTurfs = {}
local currentTick = 0

------------------------
--- Server functions ---
------------------------

function tvRP.claimTurf(turf)

  --if the turf has yet to be created, create it
  if activeTurfs[turf] == nil then
    activeTurfs[turf] = {["player"] = source, ["entered"] = currentTick, ["reputation"] = 0.0}
    vRPclient.setProgressBar(source,{"turf:"..turf,"center","",255,1,1,0})
    vRPclient.setProgressBarValue(source,{"turf:"..turf,math.floor((activeTurfs[turf]["reputation"]/cfg.maxReputation)*100)})
    vRPclient.setProgressBarText(source,{"turf:"..turf,"Turf Reputation: "..tostring(math.floor((activeTurfs[turf]["reputation"]/cfg.maxReputation)*100)).."%"})
    print("Player entered turf")
    return true
  end

  --Someone else is already in this turf
  if activeTurfs[turf]["player"] ~= nil then return false end

  activeTurfs[turf]["player"] = source
  vRPclient.setProgressBar(source,{"turf:"..turf,"center","",255,1,1,0})
  vRPclient.setProgressBarValue(source,{"turf:"..turf,math.ceil((activeTurfs[turf]["reputation"]/cfg.maxReputation)*100)})
  vRPclient.setProgressBarText(source,{"turf:"..turf,"Turf reputation: "..tostring(activeTurfs[turf]["reputation"]/cfg.maxReputation).."%"})
  print("Player entered turf")
  return true
end

function tvRP.exitTurf(turf)
  if activeTurfs[turf] == nil or activeTurfs[turf]["player"] ~= source then return false end
  activeTurfs[turf] = nil
  vRPclient.removeProgressBar(source,{"turf:"..turf})
  print("Player exited turf")
  return true
end

function tvRP.sellNpcDrug()
  local user_id = vRP.getUserId(source)

  --make sure player is actually a turf owner
  local occupiedTurf = nil
  for turf,data in pairs(activeTurfs) do
    if data["player"] == source then
      occupiedTurf = turf
    end
  end
  if occupiedTurf == nil then return false end

  for drug,drugInfo in pairs(cfg.drugs) do
    if vRP.getInventoryItemAmount(user_id,drug) > 0 then
      local number = math.random(1,4)
      local payout = math.ceil(drugInfo["lowPrice"] + (drugInfo["lowPrice"]^(activeTurfs[occupiedTurf]["reputation"]/(cfg.maxReputation/cfg.maxIncreasePercent))))  -- base + base^(rep/70)  86% increase after an hour, exponentially
      if vRP.tryGetInventoryItem(user_id,drug,number) then
        vRP.giveMoney(user_id,payout*number)
        vRPclient.notify(source,{"Sold "..tostring(number).."  "..drugInfo["name"].." for $"..tostring(payout*number)})
        activeTurfs[occupiedTurf]["reputation"] = activeTurfs[occupiedTurf]["reputation"] + cfg.reputationPerTick
        return true, drug
      elseif (number - 1) > 0 and vRP.tryGetInventoryItem(user_id,drug,number - 1) then
        vRP.giveMoney(user_id,payout*(number-1))
        vRPclient.notify(source,{"Sold "..tostring(number-1).."  "..drugInfo["name"].." for $"..tostring(payout*(number-1))})
        activeTurfs[occupiedTurf]["reputation"] = activeTurfs[occupiedTurf]["reputation"] + cfg.reputationPerTick
        return true, drug
      elseif (number - 2) > 0 and vRP.tryGetInventoryItem(user_id,drug,number - 2) then
        vRP.giveMoney(user_id,payout*(number-2))
        vRPclient.notify(source,{"Sold "..tostring(number-2).."  "..drugInfo["name"].." for $"..tostring(payout*(number-2))})
        activeTurfs[occupiedTurf]["reputation"] = activeTurfs[occupiedTurf]["reputation"] + cfg.reputationPerTick
        return true, drug
      elseif (number - 3) > 0 and vRP.tryGetInventoryItem(user_id,drug,number - 3) then
        vRP.giveMoney(user_id,payout*(number-3))
        vRPclient.notify(source,{"Sold "..tostring(number-3).."  "..drugInfo["name"].." for $"..tostring(payout*(number-3))})
        activeTurfs[occupiedTurf]["reputation"] = activeTurfs[occupiedTurf]["reputation"] + cfg.reputationPerTick
        return true, drug
      end
    end
  end
  return false
end

--------------------------
--- Internal Functions ---
--------------------------

--ticks every 30s
function drugTurf.turfTick()
  for turf,data in pairs(activeTurfs) do
    print("Turf tick for "..turf.."...Reputation: "..tostring(data["reputation"]))
    if data["reputation"] < cfg.maxReputation then
      if data["player"] == nil then
        activeTurfs[turf]["reputation"] = data["reputation"] - cfg.reputationDecayPerTick --decay reputation
      end
    else
      activeTurfs[turf]["reputation"] = 60
    end

    if data["player"] ~= nil then
      vRPclient.setProgressBarValue(data["player"],{"turf:"..turf,math.floor((activeTurfs[turf]["reputation"]/cfg.maxReputation)*100)})
      vRPclient.setProgressBarText(data["player"],{"turf:"..turf,"Turf Reputation: "..tostring(math.floor((activeTurfs[turf]["reputation"]/cfg.maxReputation)*100)).."%"})
    end

  end

  SetTimeout(60000/cfg.reputationTickRate,drugTurf.turfTick)
end

drugTurf.turfTick()  --start the turf tick
