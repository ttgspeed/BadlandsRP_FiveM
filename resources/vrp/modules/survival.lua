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
    vRPclient.setHungerBarValue(source,{data.hunger})
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
    vRPclient.setThirstBarValue(source,{data.thirst})
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
    vRPclient.setHungerBarValue(source,{data.hunger})
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
    vRPclient.setThirstBarValue(source,{data.thirst})
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
  MySQL.Async.fetchAll('SELECT isAlive FROM vrp_user_identities WHERE user_id = @user_id', {user_id = user_id}, function(rows)
    if #rows > 0 then
      task({rows[1].isAlive})
    else
      task()
    end
  end)
end

function tvRP.setAliveState(state)
  local user_id = vRP.getUserId(source)
  if state ~= nil and user_id ~= nil then
    MySQL.Async.execute('UPDATE vrp_user_identities set isAlive = @state where user_id = @user_id',{state = state, user_id = user_id}, function(rowsChanged) end)
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

local treatment_menus = {}
local menu = {
  name="LSFD Treatment Center",
  css={top = "75px", header_color="rgba(255,125,0,0.75)"}
}
treatment_menus["treatment"] = menu

menu["Get Treatment"] = {function(player,choice)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    vRPclient.isInComa(player,{}, function(in_coma)
      if not in_coma then
        if vRP.tryFullPayment(user_id,cfg.treatment_fee) then
          vRPclient.provideTreatment(player,{})
          Log.write(user_id,"Paid $"..cfg.treatment_fee.." for medical treament at hospital.",Log.log_type.action)
        else
          vRPclient.notify(player,{"You cannot afford medical care."})
        end
      end
    end)
    vRP.closeMenu(player)
  end
end, "Get medical treatment for $"..cfg.treatment_fee}

menu["Send For Treatment"] = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    if vRP.hasPermission(user_id,"emergency.support") then
      vRPclient.getNearestPlayer(player,{5},function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
          vRPclient.getMedicCount(player,{},function(medicCount)
            if vRP.hasPermission(user_id,"emergency.revive") or (medicCount ~= nil and (medicCount < 1 or vRP.hasPermission(nuser_id,"emergency.support"))) then
              vRPclient.stopEscort(nplayer,{})
              vRPclient.isInComa(nplayer,{}, function(in_coma)
                if in_coma then
                  vRPhs.PutInBedServer({player, nplayer})
                  vRP.giveBankMoney(user_id,cfg.reviveReward) -- pay reviver for their services
                  vRPclient.notify(player,{"Received $"..cfg.reviveReward.." for your services."})
                  Log.write(user_id,"Revived "..nuser_id.." at a hospital",Log.log_type.action)
                else
                  vRPclient.notify(player,{"No one needs treatment"})
                end
              end)
            else
              vRPclient.notify(player,{"The hospital is not accepting walk-ins, please call EMS for assistance."})
            end
          end)
        else
          vRPclient.notify(player, {"No one needs treatment near you"})
        end
      end)
    else
      vRPclient.notify(player,{"Hospital staff don't seem to recognize you."})
    end
    vRP.closeMenu(player)
  else
    vRPclient.notify(player,{"Invalid user."})
  end
end, "The patient will be sent for treatment and returned here."}

local function build_client_treatmentCenters(source)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    for k,v in pairs(cfg.treatment_centers) do
      local part,x,y,z = table.unpack(v)

      local treatment_center_enter = function(player,area)
        local user_id = vRP.getUserId(source)
        if user_id ~= nil then
          local menu = treatment_menus["treatment"]
          if menu then
              vRP.openMenu(player,menu)
          end
        end
      end

      -- leave
        local treatment_center_leave = function(player,area)
            vRP.closeMenu(player)
        end

      vRPclient.addMarker(source,{x,y,z-0.97,0.7,0.7,0.5,0,255,125,125,150,23})

      vRP.setArea(source,"vRP:treament_center"..k,x,y,z,1,1.5,treatment_center_enter,treatment_center_leave)
    end
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
  if first_spawn then
    build_client_treatmentCenters(source)
  end
end)
