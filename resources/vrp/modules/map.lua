
local client_areas = {}

-- free client areas when leaving
AddEventHandler("vRP:playerLeave",function(user_id,source)
  client_areas[vRP.getUserId(source)] = nil
end)

-- create/update a player area
function vRP.setArea(source,name,x,y,z,radius,height,cb_enter,cb_leave)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil and source ~= nil then
    local areas = client_areas[user_id] or {}
    client_areas[user_id] = areas

    areas[name] = {enter=cb_enter,leave=cb_leave}
    vRPclient.setArea(source,{name,x,y,z,radius,height})
  end
end

-- delete a player area
function vRP.removeArea(source,name)
  local user_id = vRP.getUserId(source)
    if user_id ~= nil and source ~= nil then
    -- delete remote area
    vRPclient.removeArea(source,{name})

    -- delete local area
    local areas = client_areas[user_id]
    if areas then
      areas[name] = nil
    end
  end
end

-- TUNNER SERVER API

function tvRP.enterArea(name)
  local areas = client_areas[vRP.getUserId(source)]
  if areas then
    local area = areas[name]
    if area and area.enter then -- trigger enter callback
      area.enter(source,name)
    end
  end
end

function tvRP.leaveArea(name)
  local areas = client_areas[vRP.getUserId(source)]

  if areas then
    local area = areas[name]
    if area and area.leave then -- trigger leave callback
      area.leave(source,name)
    end
  end
end


local cfg = module("cfg/blips_markers")

-- add additional static blips/markers
AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then
    for k,v in pairs(cfg.blips) do
      vRPclient.addBlip(source,{v[1],v[2],v[3],v[4],v[5],v[6]})
    end

    for k,v in pairs(cfg.markers) do
      vRPclient.addMarker(source,{v[1],v[2],v[3]-0.97,v[4],v[5],v[6],v[7],v[8],v[9],v[10],v[11],23})
    end
  end
end)
