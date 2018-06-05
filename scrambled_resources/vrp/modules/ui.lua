-- DEFAULT --
function vRP.checkHunger()
  local user_id = vRP.getUserId(source)
  return vRP.getHunger(user_id)
end

function vRP.checkThirst()
  local user_id = vRP.getUserId(source)
  return vRP.getThirst(user_id)
end
