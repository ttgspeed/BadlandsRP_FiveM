local cfg = module("cfg/survival")
local Log = module("lib/Log")
local lang = vRP.lang

-- api

function vRP.getHunger(user_id)
  local data = vRP.getUserDataTable(user_id)
  if data then
    return data.hunger
  end

  return 0
end

function vRP.getThirst(user_id)
  local data = vRP.getUserDataTable(user_id)
  if data then
    return data.thirst
  end

  return 0
end

function vRP.setHunger(user_id,value)
  local data = vRP.getUserDataTable(user_id)
  if data then
    data.hunger = value
    if data.hunger < 0 then data.hunger = 0
    elseif data.hunger > 100 then data.hunger = 100
    end

    -- update bar
    local source = vRP.getUserSource(user_id)
    TriggerClientEvent('banking:updateHunger',source,parseInt(data.hunger))
  end
end

function vRP.setThirst(user_id,value)
  local data = vRP.getUserDataTable(user_id)
  if data then
    data.thirst = value
    if data.thirst < 0 then data.thirst = 0
    elseif data.thirst > 100 then data.thirst = 100
    end

    -- update bar
    local source = vRP.getUserSource(user_id)
    TriggerClientEvent('banking:updateThirst',source,parseInt(data.thirst))
  end
end

function vRP.varyHunger(user_id, variation)
  local data = vRP.getUserDataTable(user_id)
  if data then
    local was_starving = data.hunger <= 0
    data.hunger = data.hunger - variation
    local is_starving = data.hunger <= 0

    -- apply overflow as damage
    local overflow = -data.hunger
    if overflow > 0 then
      vRPclient.varyHealth(vRP.getUserSource(user_id),{-overflow*cfg.overflow_damage_factor})
    end

    if data.hunger < 0 then data.hunger = 0
    elseif data.hunger > 100 then data.hunger = 100
    end

    -- set progress bar data
    local source = vRP.getUserSource(user_id)
    TriggerClientEvent('banking:updateHunger',source,parseInt(data.hunger))
    if is_starving then
      vRPclient.notify(source,{"Your are hungry, eat soon!"})
    end
  end
end

function vRP.varyThirst(user_id, variation)
  local data = vRP.getUserDataTable(user_id)
  if data then
    local was_thirsty = data.thirst <= 0
    data.thirst = data.thirst - variation
    local is_thirsty = data.thirst <= 0

    -- apply overflow as damage
    local overflow = -data.thirst
    if overflow > 0 then
      vRPclient.varyHealth(vRP.getUserSource(user_id),{-overflow*cfg.overflow_damage_factor})
    end

    if data.thirst < 0 then data.thirst = 0
    elseif data.thirst > 100 then data.thirst = 100
    end

    -- set progress bar data
    local source = vRP.getUserSource(user_id)
    TriggerClientEvent('banking:updateThirst',source,parseInt(data.thirst))
    if is_thirsty then
      vRPclient.notify(source,{"Your are thirsty, drink soon!"})
    end
  end
end

-- tunnel api (expose some functions to clients)

function tvRP.varyHunger(variation)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    vRP.varyHunger(user_id,variation)
  end
end

function tvRP.varyThirst(variation)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    vRP.varyThirst(user_id,variation)
  end
end

function vRP.getIsAlive(user_id, cbr)
  local task = Task(cbr,{false})
  if user_id ~= nil then
    exports['GHMattiMySQL']:QueryResultAsync('SELECT isAlive FROM vrp_user_identities WHERE user_id = @user_id', {["@user_id"] = user_id}, function(rows)
      if #rows > 0 then
        task({rows[1].isAlive})
      else
        task()
      end
    end)
  else
    task()
  end
end

function tvRP.setAliveState(state)
  local user_id = vRP.getUserId(source)
  if state ~= nil and user_id ~= nil then
    exports['GHMattiMySQL']:QueryAsync('UPDATE vrp_user_identities set isAlive = @state where user_id = @user_id',{["@state"] = state, ["@user_id"] = user_id}, function(rowsChanged) end)
  end
end

-- tasks

-- hunger/thirst increase
function task_update()
  for k,v in pairs(vRP.users) do
    vRP.varyHunger(v,cfg.hunger_per_minute)
    vRP.varyThirst(v,cfg.thirst_per_minute)
  end

  SetTimeout(60000,task_update)
end
--task_update()

-- handlers

-- init values
AddEventHandler("vRP:playerJoin",function(user_id,source,name,last_login)
  local data = vRP.getUserDataTable(user_id)
  if data.hunger == nil then
    data.hunger = 100
    data.thirst = 100
  end
end)

-- add survival progress bars on spawn
AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  local data = vRP.getUserDataTable(user_id)

  -- disable police
  vRPclient.setPolice(source,{cfg.police})
  -- set friendly fire
  vRPclient.setFriendlyFire(source,{cfg.pvp})

  if data ~= nil then
    vRP.setHunger(user_id, data.hunger)
    vRP.setThirst(user_id, data.thirst)
  end

  if first_spawn then
    -- if player has jail time remaining, send them back
    vRP.getUData(user_id, "vRP:prison_time", function(prison_time)
      if prison_time ~= nil then
        if parseInt(prison_time) > 0 then
          vRPclient.prison(source,{prison_time})
        end
      end
    end)
  end
end)

function tvRP.stopEscortRemote(radius)
  vRPclient.getNearestPlayer(source,{radius},function(nplayer)
    if nplayer ~= nil then
      vRPclient.stopEscort(nplayer,{})
    end
  end)
end

function tvRP.logDeathEventBySelf(x,y,z)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    Log.write(user_id,"Died by their own action or NPC action. Position x: "..x.." y: "..y.." z: "..z,Log.log_type.death)
  end
end

function tvRP.logDeathEventByPlayer(x,y,z,kx,ky,kz,killertype,killerweapon,killerinvehicle,killervehicleseat,killervehiclename,killer_vRPid)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil and killer_vRPid ~= nil then
    Log.write(user_id,"Killed by "..killer_vRPid.." using weaponhash "..killerweapon..". Victim position = "..x..","..y..","..z..". Killer Position = "..kx..","..ky..","..kz..". Killertype = "..killertype..", killerinvehicle = "..killerinvehicle..", killervehicleseat = "..killervehicleseat..", killervehiclename = "..killervehiclename,Log.log_type.death)
  end
end
