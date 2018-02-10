function tvRP.give_loot(item)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    vRP.giveInventoryItem(user_id,item,1,true)
  end
end
