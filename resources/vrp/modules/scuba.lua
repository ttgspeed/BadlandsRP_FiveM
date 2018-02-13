local lang = vRP.lang

function tvRP.give_loot(item)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    loot = {}
    loot[item] = {amount=1}
  	local new_weight = vRP.getInventoryWeight(user_id)+vRP.computeItemsWeight(loot)
  	local inventory_ok = true
    if new_weight > vRP.getInventoryMaxWeight(user_id) then
      inventory_ok = false
      vRPclient.notify(source, {lang.inventory.full()})
    else
    	vRP.giveInventoryItem(user_id,item,1,true)
    end
  end
end
