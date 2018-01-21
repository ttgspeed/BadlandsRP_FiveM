local lang = vRP.lang
local Log = module("lib/Log")

local function ch_towtruck(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
   vRPclient.vc_TowTruck(player,{})
  end
end

vRP.registerMenuBuilder("main", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id ~= nil then
    local choices = {}
    if vRP.hasPermission(user_id, "towtruck.tow") then
      choices["Tow Vehicle"] = {ch_towtruck, "Load/Unload vehicle on flatbed",99}
    end

    add(choices)
  end
end)
