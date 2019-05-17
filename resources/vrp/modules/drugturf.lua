-----------------
--- Variables ---
-----------------
local cfg = module("cfg/drugturf")

local occupiedTurfs = {}
local currentTick = 0

------------------------
--- Server functions ---
------------------------

function tvRP.claimTurf(turf)
  if occupiedTurfs[turf] ~= nil then return false end
  occupiedTurfs[turf] = {["player"] = source, ["entered"] = currentTick, ["reputation"] = 0}
  print("Player entered turf")
  return true
end

function tvRP.exitTurf(turf)
  if occupiedTurfs[turf] == nil or occupiedTurfs[turf]["player"] ~= source then return false end
  occupiedTurfs[turf] = nil
  print("Player exited turf")
  return true
end

function tvRP.sellNpcDrug()
  local user_id = vRP.getUserId(source)
  for drug,drugInfo in pairs(cfg.drugs) do
    if vRP.getInventoryItemAmount(user_id,drug) > 0 then
      if vRP.tryGetInventoryItem(user_id,drug,1) then
        vRP.giveMoney(user_id,200) --TODO
        return true, drug
      end
    end
  end
  return false
end

--------------------------
--- Internal Functions ---
--------------------------

function turfTick()
  for turf,data in pairs(occupiedTurfs) do
    if data["player"] ~= nil then
      occupiedTurfs[turf]["reputation"] = data["reputation"] + 1
    else
      occupiedTurfs[turf] = nil
    end
  end

  SetTimeout(30000,turfTick)
end
