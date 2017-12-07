local activePolice = {}
local activeEMS = {}


function tvRP.addPlayerToActivePolive()
    local user_id = vRP.getUserId(source)
    activePolice[user_id] = source
    for k,v in pairs(activePolice) do
      vRPclient.addToActivePolive(source,{v})
    end
    vRPclient.addToActivePolive(-1,{source})
end

function tvRP.removePlayerToActivePolive()
    local user_id = vRP.getUserId(source)
    activePolice[user_id] = nil
    vRPclient.removeToActivePolive(-1,{source})
end

function tvRP.addPlayerToActiveEMS()
    local user_id = vRP.getUserId(source)
    activeEMS[user_id] = source
    for k,v in pairs(activeEMS) do
      vRPclient.addToActiveEMS(source,{v})
    end
    vRPclient.addToActiveEMS(-1,{source})
end

function tvRP.removePlayerToActiveEMS()
    local user_id = vRP.getUserId(source)
    activeEMS[user_id] = nil
    vRPclient.removeToActiveEMS(-1,{source})
end

AddEventHandler("playerDropped",function(reason)
  local user_id = vRP.getUserId(source)
  vRPclient.removeToActivePolive(-1,{source})
  vRPclient.removeToActiveEMS(-1,{source})
  if user_id ~= nil then
    activePolice[user_id] = nil
    activeEMS[user_id] = nil
  end
end)
