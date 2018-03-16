local cfg = module("cfg/player_state")
local lang = vRP.lang

-- client -> server events
AddEventHandler("vRP:player_state", function(user_id, source, first_spawn)
  Debug.pbegin("playerSpawned_player_state")
  local player = source
  local data = vRP.getUserDataTable(user_id)
  local tmpdata = vRP.getUserTmpTable(user_id)

  if first_spawn then -- first spawn
    -- cascade load customization then weapons
    if data.customization == nil then
      data.customization = cfg.default_customization
    end

    if data.position == nil and cfg.spawn_enabled then
      local x = cfg.spawn_position[1]
      local y = cfg.spawn_position[2]
      local z = cfg.spawn_position[3]
      data.position = {x=x,y=y,z=z}
    end

    if data.position ~= nil then -- teleport to saved pos
      vRPclient.teleport(source,{data.position.x,data.position.y,data.position.z})
    end

    if data.customization ~= nil then
      vRPclient.setCustomization(source,{data.customization, false},function() -- delayed weapons/health, because model respawn
        if data.weapons ~= nil then -- load saved weapons
          vRPclient.giveWeapons(source,{data.weapons,true})

          if data.health ~= nil then -- set health
            vRPclient.setHealth(source,{data.health})
            vRP.getIsAlive(user_id, function(state)
              SetTimeout(5000, function() -- check coma, kill if in coma
                if state == 0 then
                  vRPclient.setHealth(player,{0})
                  vRP.getUData(user_id, "vRP:last_death", function(last_death)
                    if (os.time() - parseInt(last_death)) > cfg.skipForceRespawn then
                      vRPclient.killComa(player,{})
                    end
                  end)
                end
              end)
            end)
          end
        end
      end)
    else
      if data.weapons ~= nil then -- load saved weapons
        vRPclient.giveWeapons(source,{data.weapons,true})
      end

      if data.health ~= nil then
        vRPclient.setHealth(source,{data.health})
      end
    end

    -- notify last login
    SetTimeout(15000,function()vRPclient.notify(player,{lang.common.welcome({tmpdata.last_login})})end)
  else -- not first spawn (player died), don't load weapons, empty wallet, empty inventory
    vRP.setHunger(user_id,100)
    vRP.setThirst(user_id,100)
    vRP.clearInventory(user_id)

    if cfg.clear_phone_directory_on_death then
      data.phone_directory = {} -- clear phone directory after death
    end

    if cfg.lose_aptitudes_on_death then
      data.gaptitudes = {} -- clear aptitudes after death
    end

    vRP.setMoney(user_id,0)

    -- disable handcuff
    vRPclient.setHandcuffed(player,{false})

    if cfg.spawn_enabled then -- respawn
      local location = math.random( #cfg.respawn_positions )
      local x = cfg.respawn_positions[location][1]
      local y = cfg.respawn_positions[location][2]
      local z = cfg.respawn_positions[location][3]
      data.position = {x=x,y=y,z=z}
      vRPclient.teleport(source,{x,y,z})
    end

    -- load character customization
    if data.customization ~= nil then
      vRPclient.setCustomization(source,{data.customization, false})
    end
  end
  Debug.pend()
end)

-- death, clear position and weapons
AddEventHandler("vRP:playerDied",function()
  print("player die")
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    local data = vRP.getUserDataTable(user_id)
    if data ~= nil then
      data.position = nil
      data.weapons = nil
    end
  end
end)

-- updates

function tvRP.updatePos(x,y,z)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    local data = vRP.getUserDataTable(user_id)
    local tmp = vRP.getUserTmpTable(user_id)
    if data ~= nil and (tmp == nil or tmp.home_stype == nil) then -- don't save position if inside home slot
      data.position = {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
    end
  end
end

function tvRP.updateWeapons(weapons)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    local data = vRP.getUserDataTable(user_id)
    if data ~= nil then
      data.weapons = weapons
    end
  end
end

function tvRP.updateCustomization(customization)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    local data = vRP.getUserDataTable(user_id)
    if data ~= nil then
      data.customization = customization
    end
  end
end

function tvRP.updateHealth(health)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    local data = vRP.getUserDataTable(user_id)
    if data ~= nil then
      data.health = health
    end
  end
end

function tvRP.setLastDeath()
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    vRP.setUData(user_id, "vRP:last_death", os.time())
  end
end

function tvRP.updateStoredWeapons(player, weapons)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and weapons ~= nil then
    vRP.setUData(user_id, "vRP:stored_weapons", weapons)
  end
end

function tvRP.getStoredWeapons(player)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRP.request(player, "Retrieve weapons from storage (will replace current weapons)?", 15, function(player,ok)
      if ok then
        vRP.getUData(user_id, "vRP:stored_weapons", function(weapons)
          if weapons ~= nil then
            local decoded_weapons = json.decode(weapons)
            local count = 0
            if decoded_weapons ~= nil then
              for k,v in pairs(decoded_weapons) do
                count = count + 1
              end
              if count > 0 then
                vRPclient.notify(player,{"Weapons stored in locker"})
                vRPclient.giveWeapons(player,{decoded_weapons,true})
                vRP.setUData(user_id, "vRP:stored_weapons", json.encode({}))
              else
                vRPclient.notify(player,{"No weapons in locker"})
              end
            end
          end
        end)
      end
    end)
  end
end

function tvRP.storeWeapons(player)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRP.request(player, "Store currently equiped weapons (will replace any items in storage)?", 15, function(player,ok)
      if ok then
        vRPclient.getWeapons(player,{},function(weapons)
          local count = 0
          for k,v in pairs(weapons) do
            count = count + 1
          end
          local encoded_weapons = json.encode(weapons)
          if count > 0 then
            vRPclient.notify(player,{"Weapons Stored"})
            tvRP.updateStoredWeapons(player,encoded_weapons)
            -- clear all weapons
            vRPclient.giveWeapons(player,{{},true})
          else
            vRPclient.notify(player,{"You have no weapons to store"})
          end
        end)
      end
    end)
  end
end

local locker_menus = {}
local menu = {
  name="Locker",
  css={top = "75px", header_color="rgba(255,125,0,0.75)"}
}
locker_menus["locker"] = menu

menu["Store Weapons"] = {function(player,choice)
  tvRP.storeWeapons(player)
end, "Store Currently equiped weapons"}

menu["Retrieve Weapons"] = {function(player,choice)
  tvRP.getStoredWeapons(player)
end, "Retrieve stored weapons"}

local function build_client_lockers(source)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    for k,v in pairs(cfg.lockers) do
      local location,x,y,z = table.unpack(v)

      -- enter
      local locker_enter = function(player,area)
        local user_id = vRP.getUserId(source)
        if user_id ~= nil and vRP.hasPermission(user_id,"police.store_weapons") then
          local menu = locker_menus["locker"]
          if menu then
            vRP.openMenu(player,menu)
          end
        end
      end

      -- leave
      local locker_leave = function(player,area)
          vRP.closeMenu(player)
      end

      vRPclient.addMarker(source,{x,y,z-0.97,0.7,0.7,0.5,0,255,125,125,150,23})

      vRP.setArea(source,"vRP:locker"..k,x,y,z,1,1.5,locker_enter,locker_leave)

    end
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
  if first_spawn then
    -- We dont use vRP garages
    build_client_lockers(source)
  end
end)

function tvRP.tackle(player)
  if player ~= nil then
    vRPclient.tackleragdoll(player,{})
  end
end
