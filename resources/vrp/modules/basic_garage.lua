local Tunnel = module("lib/Tunnel")
local Log = module("lib/Log")
-- a basic garage implementation

-- build the server-side interface
playerGarage = {} -- you can add function to playerGarage later in other server scripts
ownedVehicles = {}
Tunnel.bindInterface("playerGarage",playerGarage)
clientaccess = Tunnel.getInterface("playerGarage","playerGarage") -- the second argument is a unique id for this tunnel access, the current resource name is a good choice

-- vehicle db
--[[
MySQL.createCommand("vRP/vehicles_table", [[
CREATE TABLE IF NOT EXISTS vrp_user_vehicles(
  user_id INTEGER,
  vehicle VARCHAR(255),
  CONSTRAINT pk_user_vehicles PRIMARY KEY(user_id,vehicle),
  CONSTRAINT fk_user_vehicles_users FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE
);
]]--)

--[[
MySQL.createCommand("vRP/add_vehicle","INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle) VALUES(@user_id,@vehicle)")
MySQL.createCommand("vRP/remove_vehicle","DELETE FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("vRP/get_vehicles","SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id")
MySQL.createCommand("vRP/get_garage","SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id")
MySQL.createCommand("vRP/get_vehicle","SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("vRP/update_vehicle","UPDATE vrp_user_vehicles SET mods = @mods, colour = @colour, scolour = @scolour, ecolor = @ecolor, ecolorextra = @ecolorextra, wheels = @wheels, platetype = @platetype, windows = @windows WHERE user_id = @user_id AND vehicle = @vehicle")
]]--
-- init
--MySQL.execute("vRP/vehicles_table")

-- load config

local cfg = module("cfg/garages")
local cfg_inventory = module("cfg/inventory")
local vehicle_groups = cfg.garage_types
local lang = vRP.lang

local garages = cfg.garages

-- garage menus

local garage_menus = {}

for group,vehicles in pairs(vehicle_groups) do
  local veh_type = vehicles._config.vtype or "default"

  local menu = {
    name=lang.garage.title({group}),
    css={top = "75px", header_color="rgba(255,125,0,0.75)"}
  }
  garage_menus[group] = menu

  menu[lang.garage.owned.title()] = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
      -- init tmpdata for rents
      local tmpdata = vRP.getUserTmpTable(user_id)
      if tmpdata.rent_vehicles == nil then
        tmpdata.rent_vehicles = {}
      end


      -- build nested menu
      local kitems = {}
      local koptions = {}
      local submenu = {name=lang.garage.title({lang.garage.owned.title()}), css={top="75px",header_color="rgba(255,125,0,0.75)"}}
      submenu.onclose = function()
        vRP.openMenu(player,menu)
      end

      local choose = function(player, choice)
        local vname = kitems[choice]
        local voptions = koptions[choice]
        if vname then
          -- spawn vehicle
          local vehicle = vehicles[vname]
          if vehicle then
            vRP.closeMenu(player)
            vRPclient.spawnGarageVehicle(player,{veh_type,vname,voptions})
          end
        end
      end

      -- get player owned vehicles
      MySQL.Async.fetchAll('SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id', {user_id = user_id}, function(pvehicles)
      --MySQL.query("vRP/get_vehicles", {user_id = user_id}, function(pvehicles, affected)
        -- add rents to whitelist
        for k,v in pairs(tmpdata.rent_vehicles) do
          if v then -- check true, prevent future neolua issues
            table.insert(pvehicles,{vehicle = k})
          end
        end

        for k,v in pairs(pvehicles) do
          local vehicle = vehicles[v.vehicle]
          if vehicle then
            submenu[vehicle[1]] = {choose,vehicle[3]}
            kitems[vehicle[1]] = v.vehicle
          end
        end

        vRP.openMenu(player,submenu)
      end)
    end
  end,lang.garage.owned.description()}

  menu[lang.garage.buy.title()] = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then

      -- build nested menu
      local kitems = {}
      local submenu = {name=lang.garage.title({lang.garage.buy.title()}), css={top="75px",header_color="rgba(255,125,0,0.75)"}}
      submenu.onclose = function()
        vRP.openMenu(player,menu)
      end

      local choose = function(player, choice)
        local vname = kitems[choice]
        if vname then
          -- buy vehicle
          local vehicle = vehicles[vname]
          if vehicle and vRP.tryPayment(user_id,vehicle[2]) then
            MySQL.Async.execute('INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle) VALUES(@user_id,@vehicle)', {user_id = user_id, vehicle = vname}, function(rowsChanged)
                print(rowsChanged)
            end)
            --MySQL.execute("vRP/add_vehicle", {user_id = user_id, vehicle = vname})

            vRPclient.notify(player,{lang.money.paid({vehicle[2]})})
            vRP.closeMenu(player)
          else
            vRPclient.notify(player,{lang.money.not_enough()})
          end
        end
      end

      -- get player owned vehicles (indexed by vehicle type name in lower case)
      MySQL.Async.fetchAll('SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id', {user_id = user_id}, function(pvehicles)
      --MySQL.query("vRP/get_vehicles", {user_id = user_id}, function(_pvehicles, affected)
        local pvehicles = {}
        for k,v in pairs(_pvehicles) do
          pvehicles[string.lower(v.vehicle)] = true
        end

        -- for each existing vehicle in the garage group
        for k,v in pairs(vehicles) do
          if k ~= "_config" and pvehicles[string.lower(k)] == nil then -- not already owned
            submenu[v[1]] = {choose,lang.garage.buy.info({v[2],v[3]})}
            kitems[v[1]] = k
          end
        end

        vRP.openMenu(player,submenu)
      end)
    end
  end,lang.garage.buy.description()}

  menu[lang.garage.sell.title()] = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then

      -- build nested menu
      local kitems = {}
      local submenu = {name=lang.garage.title({lang.garage.sell.title()}), css={top="75px",header_color="rgba(255,125,0,0.75)"}}
      submenu.onclose = function()
        vRP.openMenu(player,menu)
      end

      local choose = function(player, choice)
        local vname = kitems[choice]
        if vname then
          -- sell vehicle
          local vehicle = vehicles[vname]
          if vehicle then
            local price = math.ceil(vehicle[2]*cfg.sell_factor)
            MySQL.Async.fetchAll('SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle', {user_id = user_id, vehicle = vname}, function(rows)
            --MySQL.query("vRP/get_vehicle", {user_id = user_id, vehicle = vname}, function(rows, affected)
              if #rows > 0 then -- has vehicle
                vRP.giveMoney(user_id,price)
                MySQL.Async.execute('DELETE FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle', {user_id = user_id, vehicle = vname}, function(rowsChanged)
                    print(rowsChanged)
                end)
                --MySQL.execute("vRP/remove_vehicle", {user_id = user_id, vehicle = vname})

                vRPclient.notify(player,{lang.money.received({price})})
                vRP.closeMenu(player)
              else
                vRPclient.notify(player,{lang.common.not_found()})
              end
            end)
          end
        end
      end

      -- get player owned vehicles (indexed by vehicle type name in lower case)
      MySQL.Async.fetchAll('SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id', {user_id = user_id}, function(_pvehicles)
      --MySQL.query("vRP/get_vehicles", {user_id = user_id}, function(_pvehicles, affected)
        local pvehicles = {}
        for k,v in pairs(_pvehicles) do
          pvehicles[string.lower(v.vehicle)] = true
        end

        -- for each existing vehicle in the garage group
        for k,v in pairs(pvehicles) do
          local vehicle = vehicles[k]
          if vehicle then -- not already owned
            local price = math.ceil(vehicle[2]*cfg.sell_factor)
            submenu[vehicle[1]] = {choose,lang.garage.buy.info({price,vehicle[3]})}
            kitems[vehicle[1]] = k
          end
        end

        vRP.openMenu(player,submenu)
      end)
    end
  end,lang.garage.sell.description()}

  menu[lang.garage.rent.title()] = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
      -- init tmpdata for rents
      local tmpdata = vRP.getUserTmpTable(user_id)
      if tmpdata.rent_vehicles == nil then
        tmpdata.rent_vehicles = {}
      end

      -- build nested menu
      local kitems = {}
      local submenu = {name=lang.garage.title({lang.garage.rent.title()}), css={top="75px",header_color="rgba(255,125,0,0.75)"}}
      submenu.onclose = function()
        vRP.openMenu(player,menu)
      end

      local choose = function(player, choice)
        local vname = kitems[choice]
        if vname then
          -- rent vehicle
          local vehicle = vehicles[vname]
          if vehicle then
            local price = math.ceil(vehicle[2]*cfg.rent_factor)
            if vRP.tryPayment(user_id,price) then
              -- add vehicle to rent tmp data
              tmpdata.rent_vehicles[vname] = true

              vRPclient.notify(player,{lang.money.paid({price})})
              vRP.closeMenu(player)
            else
              vRPclient.notify(player,{lang.money.not_enough()})
            end
          end
        end
      end

      -- get player owned vehicles (indexed by vehicle type name in lower case)
      MySQL.Async.fetchAll('SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id', {user_id = user_id}, function(_pvehicles)
      --MySQL.query("vRP/get_vehicles", {user_id = user_id}, function(_pvehicles, affected)
        local pvehicles = {}
        for k,v in pairs(_pvehicles) do
          pvehicles[string.lower(v.vehicle)] = true
        end

        -- add rents to blacklist
        for k,v in pairs(tmpdata.rent_vehicles) do
          pvehicles[string.lower(k)] = true
        end

        -- for each existing vehicle in the garage group
        for k,v in pairs(vehicles) do
          if k ~= "_config" and pvehicles[string.lower(k)] == nil then -- not already owned
            local price = math.ceil(v[2]*cfg.rent_factor)
            submenu[v[1]] = {choose,lang.garage.buy.info({price,v[3]})}
            kitems[v[1]] = k
          end
        end

        vRP.openMenu(player,submenu)
      end)
    end
  end,lang.garage.rent.description()}

  menu[lang.garage.store.title()] = {function(player,choice)
    vRPclient.despawnGarageVehicle(player,{veh_type,15})
  end, lang.garage.store.description()}
end

local function build_client_garages(source)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    for k,v in pairs(garages) do
      local gtype,x,y,z = table.unpack(v)

      local group = vehicle_groups[gtype]
      if group then
        local gcfg = group._config

        -- enter
        local garage_enter = function(player,area)
          local user_id = vRP.getUserId(source)
          if user_id ~= nil and (gcfg.permission == nil or vRP.hasPermission(user_id,gcfg.permission)) then
            local menu = garage_menus[gtype]
            if menu then
              vRP.openMenu(player,menu)
            end
          end
        end

        -- leave
        local garage_leave = function(player,area)
          vRP.closeMenu(player)
        end

        if gcfg.blipid ~= 0 then
        vRPclient.addBlip(source,{x,y,z,gcfg.blipid,gcfg.blipcolor,lang.garage.title({gtype})})
        end
        vRPclient.addMarker(source,{x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})

        vRP.setArea(source,"vRP:garage"..k,x,y,z,1,1.5,garage_enter,garage_leave)
      end
    end
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
  if first_spawn then
    -- We dont use vRP garages
    --build_client_garages(source)
  end
end)

-- VEHICLE MENU

-- define vehicle actions
-- action => {cb(user_id,player,veh_group,veh_name),desc}
local veh_actions = {}

-- open trunk
veh_actions[lang.vehicle.trunk.title()] = {function(user_id,player,vtype,name)
  local chestname = "u"..user_id.."veh_"..string.lower(name)
  local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight

  -- open chest
  vRPclient.vc_openDoor(player, {name,5})
  vRP.openChest(player, chestname, max_weight, function()
    vRPclient.vc_closeDoor(player, {name,5})
  end)
end, lang.vehicle.trunk.description()}

-- detach trailer
veh_actions[lang.vehicle.detach_trailer.title()] = {function(user_id,player,vtype,name)
  vRPclient.vc_detachTrailer(player, {name})
end, lang.vehicle.detach_trailer.description()}

-- detach towtruck
veh_actions[lang.vehicle.detach_towtruck.title()] = {function(user_id,player,vtype,name)
  vRPclient.vc_detachTowTruck(player, {name})
end, lang.vehicle.detach_towtruck.description()}

-- detach cargobob
veh_actions[lang.vehicle.detach_cargobob.title()] = {function(user_id,player,vtype,name)
  vRPclient.vc_detachCargobob(player, {name})
end, lang.vehicle.detach_cargobob.description()}

-- lock/unlock
veh_actions[lang.vehicle.lock.title()] = {function(user_id,player,vtype,name)
  vRPclient.vc_toggleLock(player, {name})
end, lang.vehicle.lock.description()}

-- engine on/off
veh_actions[lang.vehicle.engine.title()] = {function(user_id,player,vtype,name)
  vRPclient.vc_toggleEngine(player, {name})
end, lang.vehicle.engine.description()}

local function ch_vehicle(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    -- check vehicle
    vRPclient.getNearestOwnedVehicle(player,{7},function(ok,vtype,name)
      if ok then
        -- build vehicle menu
        local menu = {name=lang.vehicle.title(), css={top="75px",header_color="rgba(255,125,0,0.75)"}}

        for k,v in pairs(veh_actions) do
          menu[k] = {function(player,choice) v[1](user_id,player,vtype,name) end, v[2]}
        end

        vRP.openMenu(player,menu)
      else
        vRPclient.notify(player,{lang.vehicle.no_owned_near()})
      end
    end)
  end
end

-- ask trunk (open other user car chest)
local function ch_asktrunk(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.notify(player,{lang.vehicle.asktrunk.asked()})
      vRP.request(nplayer,lang.vehicle.asktrunk.request(),15,function(nplayer,ok)
        if ok then -- request accepted, open trunk
          vRPclient.getNearestOwnedVehicle(nplayer,{7},function(ok,vtype,name)
            if ok then
              local chestname = "u"..nuser_id.."veh_"..string.lower(name)
              local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight

              -- open chest
              local cb_out = function(idname,amount)
                vRPclient.notify(nplayer,{lang.inventory.give.given({vRP.getItemName(idname),amount})})
              end

              local cb_in = function(idname,amount)
                vRPclient.notify(nplayer,{lang.inventory.give.received({vRP.getItemName(idname),amount})})
              end

              vRPclient.vc_openDoor(nplayer, {name,5})
              vRP.openChest(player, chestname, max_weight, function()
                vRPclient.vc_closeDoor(nplayer, {name,5})
              end,cb_in,cb_out)
            else
              vRPclient.notify(player,{lang.vehicle.no_owned_near()})
              vRPclient.notify(nplayer,{lang.vehicle.no_owned_near()})
            end
          end)
        else
          vRPclient.notify(player,{lang.common.request_refused()})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end

-- repair nearest vehicle
local function ch_repair(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    -- anim and repair
    if vRP.tryGetInventoryItem(user_id,"carrepairkit",1,true) then
      vRPclient.playAnim(player,{false,{task="WORLD_HUMAN_WELDING"},false})
      SetTimeout(30000, function()
        vRPclient.fixeNearestVehicle(player,{7})
        vRPclient.stopAnim(player,{false})
      end)
    else
      vRPclient.notify(player,{lang.inventory.missing({vRP.getItemName("carrepairkit"),1})})
    end
  end
end

-- replace nearest vehicle
local function ch_replace(player,choice)
  vRPclient.replaceNearestVehicle(player,{7})
end

vRP.registerMenuBuilder("main", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id ~= nil then
    -- add vehicle entry
    local choices = {}
    choices[lang.vehicle.title()] = {ch_vehicle}

    -- add ask trunk
    choices[lang.vehicle.asktrunk.title()] = {ch_asktrunk}

    -- add repair functions
    if vRP.hasPermission(user_id, "vehicle.repair") then
      choices[lang.vehicle.repair.title()] = {ch_repair, lang.vehicle.repair.description()}
    end

    if vRP.hasPermission(user_id, "vehicle.replace") then
      choices[lang.vehicle.replace.title()] = {ch_replace, lang.vehicle.replace.description()}
    end

    add(choices)
  end
end)

RegisterServerEvent('updateVehicle')
AddEventHandler('updateVehicle', function(vehicle,mods,vCol,vColExtra,eCol,eColExtra,wheeltype,neoncolor,plateindex,windowtint)
  local player = vRP.getUserId(source)
	local vmods = json.encode(mods)
	setDynamicMulti(player, vehicle, {
    ["mods"] = vmods,
		["colour"] = vCol,
		["scolour"] = vColExtra,
		["ecolor"] = eCol,
		["ecolorextra"] = eColExtra,
		["wheels"] = wheeltype,
		["neon"] = neoncolor,
		["platetype"] = plateindex,
		["windows"] = windowtint,
	})
end)

RegisterServerEvent('vrp:purchaseVehicle')
AddEventHandler('vrp:purchaseVehicle', function(garage, vehicle)
  local player = vRP.getUserId(source)
  if garage == "police" then
    if vRP.hasPermission(player,"police.vehicle") then
      -- Rank 6 +
      if (string.lower(vehicle) == "fbicharger") and not (vRP.hasPermission(player,"police.rank6") or vRP.hasPermission(player,"police.rank7")) then
        vRPclient.notify(source,{"You do not meet the rank requirement."})
        return false
      -- Rank 5 +
      elseif (string.lower(vehicle) == "explorer2") and not (vRP.hasPermission(player,"police.rank5") or vRP.hasPermission(player,"police.rank6") or vRP.hasPermission(player,"police.rank7")) then
        vRPclient.notify(source,{"You do not meet the rank requirement."})
        return false
      -- Rank 4 +
      elseif (string.lower(vehicle) == "fpis" or string.lower(vehicle) == "fbitahoe") and not (vRP.hasPermission(player,"police.rank4") or vRP.hasPermission(player,"police.rank5") or vRP.hasPermission(player,"police.rank6") or vRP.hasPermission(player,"police.rank7")) then
        vRPclient.notify(source,{"You do not meet the rank requirement."})
        return false
      -- Rank 3 +
      elseif (string.lower(vehicle) == "uccvpi" or string.lower(vehicle) == "policeb") and not (vRP.hasPermission(player,"police.rank3") or vRP.hasPermission(player,"police.rank4") or vRP.hasPermission(player,"police.rank5") or vRP.hasPermission(player,"police.rank6") or vRP.hasPermission(player,"police.rank7")) then
        vRPclient.notify(source,{"You do not meet the rank requirement."})
        return false
      -- Rank 2 +
      elseif (string.lower(vehicle) == "charger" or string.lower(vehicle) == "tahoe" or string.lower(vehicle) == "explorer") and not (vRP.hasPermission(player,"police.rank2") or vRP.hasPermission(player,"police.rank3") or vRP.hasPermission(player,"police.rank4") or vRP.hasPermission(player,"police.rank5") or vRP.hasPermission(player,"police.rank6") or vRP.hasPermission(player,"police.rank7")) then
        vRPclient.notify(source,{"You do not meet the rank requirement."})
        return false
      end
    else
      vRPclient.notify(source,{"You are not signed in as a police officer."})
      return false
    end
  end
  if garage == "emergency"  then
    if vRP.hasPermission(player,"emergency.vehicle") then
      if (string.lower(vehicle) == "firesuv") and not (vRP.hasPermission(player,"ems.rank2") or vRP.hasPermission(player,"ems.rank3") or vRP.hasPermission(player,"ems.rank4") or vRP.hasPermission(player,"ems.rank5")) then
        vRPclient.notify(source,{"You do not meet the rank requirement."})
        return false
      end
    else
      vRPclient.notify(source,{"You are not signed in as emergency personel."})
      return false
    end
  end
  purchaseVehicle(source, garage, vehicle)
  return true
end)

RegisterServerEvent('vrp:storeVehicle')
AddEventHandler('vrp:storeVehicle', function()
  vRPclient.despawnGarageVehicle(source,{"default",15})
end)

function getVehicleOptions(v)
  return { main_colour = v.colour, secondary_colour = v.scolour, ecolor = v.ecolor, ecolorextra = v.ecolorextra, plate = v.plate, wheels = v.wheels, windows = v.windows, platetype = v.platetype, exhausts = v.exhausts, grills = v.grills, spoiler = v.spoiler, mods = v.mods }
end

function purchaseVehicle(player, garage, vname)
  local user_id = vRP.getUserId(player)
  if vname then
    -- buy vehicle
    local veh_type = vehicle_groups[garage]._config.vtype or "default"
    local vehicle = vehicle_groups[garage][vname]
    local playerVehicle = playerGarage.getPlayerVehicle(user_id, vname)
    if playerVehicle then
      vRPclient.spawnGarageVehicle(player,{veh_type,vname,getVehicleOptions(playerVehicle)})
      vRPclient.notify(player,{"You have retrieved your vehicle from the garage!"})
    elseif vehicle and vRP.tryFullPayment(user_id,vehicle[2]) then
      MySQL.Async.execute('INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle) VALUES(@user_id,@vehicle)', {user_id = user_id, vehicle = vname}, function(rowsChanged)
          print(rowsChanged)
      end)
      --MySQL.query("vRP/add_vehicle", {user_id = user_id, vehicle = vname})

      vRPclient.notify(player,{lang.money.paid({vehicle[2]})})
      vRPclient.spawnGarageVehicle(player,{veh_type,vname,{}})
      Log.write(user_id, "Purchased "..vname.." for "..vehicle[2], Log.log_type.purchase)
    else
      vRPclient.notify(player,{lang.money.not_enough()})
    end
  end
end

function setDynamicMulti(source, vehicle, options)
  MySQL.Async.execute('UPDATE vrp_user_vehicles SET mods = @mods, colour = @colour, scolour = @scolour, ecolor = @ecolor, ecolorextra = @ecolorextra, wheels = @wheels, platetype = @platetype, windows = @windows WHERE user_id = @user_id AND vehicle = @vehicle', {mods = options.mods, colour = options.colour, scolour = options.scolour, ecolor = options.ecolor, ecolorextra = options.ecolorextra, wheels = options.wheels, platetype = options.platetype, windows = options.windows, user_id = source, vehicle = vehicle}, function(rowsChanged)
    print(rowsChanged)
  end)
  --MySQL.query("vRP/update_vehicle", {mods = options.mods, colour = options.colour, scolour = options.scolour, ecolor = options.ecolor, ecolorextra = options.ecolorextra, wheels = options.wheels, platetype = options.platetype, windows = options.windows, user_id = source, vehicle = vehicle})
end

function playerGarage.getVehicleGarage(vehicle)
  for group,vehicles in pairs(vehicle_groups) do
    if(vehicle_groups[group][vehicle]) then
      return group
    end
  end

  return ""
end

function playerGarage.getPlayerVehicles(message)
  local user_id = vRP.getUserId(source)
  local _pvehicles = {}
  fs = source
  MySQL.Async.fetchAll('SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id', {}, function(_pvehicles)
  --MySQL.query("vRP/get_garage", {user_id = user_id}, function(_pvehicles, affected)
    ownedVehicles[user_id] = _pvehicles
    TriggerClientEvent('es_carshop:recievePlayerVehicles',fs, _pvehicles)
  end)
end

function playerGarage.getPlayerVehicle(user_id, vehicle)
  for k,v in pairs(ownedVehicles[user_id]) do
    if v.vehicle == vehicle then
      return v
    end
  end

  return nil
end

RegisterServerEvent("frfuel:fuelAdded")
AddEventHandler("frfuel:fuelAdded", function()
    -- do nothing for now.
end)
