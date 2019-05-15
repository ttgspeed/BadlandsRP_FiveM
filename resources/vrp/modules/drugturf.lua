-----------------
--- Variables ---
-----------------

local cfg = module("cfg/drugturf")


------------------------
--- Server functions ---
------------------------

function tvRP.sellNpcDrug()
  local user_id = vRP.getUserId(source)
  for drug,drugInfo in pairs(cfg.drugs) do
    if vRP.getInventoryItemAmount(user_id,drug) > 0 then
      if vRP.tryGetInventoryItem(user_id,drug,1) then
        vRP.giveMoney(user_id,200) --TODO
        return true
      end
    end
  end
  return false
end




--------------------------
--- Internal Functions ---
--------------------------
