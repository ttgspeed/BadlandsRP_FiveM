local Tunnel = module("lib/Tunnel")
local Log = module("lib/Log")
-- a basic garage implementation

-- build the server-side interface
playerGarage = {} -- you can add function to playerGarage later in other server scripts
ownedVehicles = {}
ownedVehicles_shared = {}
Tunnel.bindInterface("playerGarage",playerGarage)
clientaccess = Tunnel.getInterface("playerGarage","playerGarage") -- the second argument is a unique id for this tunnel access, the current resource name is a good choice

-- load config

local cfg = module("cfg/garages")
local cfgImpound = module("cfg/impound")
local cfg_inventory = module("cfg/inventory")
local vehicle_groups = cfg.garage_types
local lang = vRP.lang

local garages = cfg.garages

-- garage menus

local garage_menus = {}

for group,vehicles in pairs(vehicle_groups) do
  local veh_type = "default"

  local menu = {
    name="Los Santos Impound",
    css={top = "75px", header_color="rgba(255,125,0,0.75)"}
  }
  garage_menus[group] = menu

  menu["Impound Lot"] = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
      -- build nested menu
      local kitems = {}
      local submenu = {name="Impound Lot", css={top="75px",header_color="rgba(255,125,0,0.75)"}}
      submenu.onclose = function()
        vRP.openMenu(player,menu)
      end

      local choose = function(player, choice)
        local vname = kitems[choice]
        if vname then
          -- spawn vehicle
          local vehicle = vehicles[vname]
          if vehicle then
            local impound_fee = math.floor(vehicle[2]*cfgImpound.impound_rate)
            if impound_fee < cfgImpound.impound_fee_min then
              impound_fee = cfgImpound.impound_fee_min
            elseif impound_fee > cfgImpound.impound_fee_max then
              impound_fee = cfgImpound.impound_fee_max
            end
            local user_id = vRP.getUserId(player)
            local playerVehicle = playerGarage.getPlayerVehicle(user_id, vname)
            if vRP.tryFullPayment(user_id,impound_fee) then
              vRPclient.spawnGarageVehicle(player,{"default",vname,getVehicleOptions(playerVehicle),getVehicleDamage(playerVehicle)})
              vRPclient.notify(player,{"You have paid an impound fee of $"..impound_fee.." to retrieve your vehicle from the impound."})
              tvRP.setVehicleOutStatus(player,vname,1,0)
              vRP.closeMenu(player)
              Log.write(user_id, "Payed $"..impound_fee.." to retrieve "..vname.." from the impound", Log.log_type.garage)
            else
              vRPclient.notify(player,{"You do not have enough money to pay the impound fee for this vehicle!"})
            end
          end
        end
      end

      -- get player owned vehicles
      MySQL.Async.fetchAll('SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id AND in_impound = 1', {user_id = user_id}, function(pvehicles)
        for k,v in pairs(pvehicles) do
          local vehicle = vehicles[v.vehicle]
          if vehicle then
            local impound_fee = math.floor(vehicle[2]*cfgImpound.impound_rate)
            if impound_fee < cfgImpound.impound_fee_min then
              impound_fee = cfgImpound.impound_fee_min
            elseif impound_fee > cfgImpound.impound_fee_max then
              impound_fee = cfgImpound.impound_fee_max
            end
            submenu[vehicle[1]] = {choose,"Impound Fee: $"..impound_fee}
            kitems[vehicle[1]] = v.vehicle
          end
        end
        MySQL.Async.fetchAll('SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id', {user_id = user_id}, function(_pvehicles)
          ownedVehicles_shared[user_id] = _pvehicles
          vRP.openMenu(player,submenu)
        end)
      end)
    end
  end,"Towed/Impounded Vehicles here"}

  menu["Vehicle Recovery"] = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
      -- build nested menu
      local kitems = {}
      local koptions = {}
      local submenu = {name="Vehicle Recovery", css={top="75px",header_color="rgba(255,125,0,0.75)"}}
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
            local recovery_fee = math.floor(vehicle[2]*cfgImpound.recovery_rate)
            if recovery_fee < cfgImpound.recovery_fee_min then
              recovery_fee = cfgImpound.recovery_fee_min
            elseif recovery_fee > cfgImpound.recovery_fee_max then
              recovery_fee = cfgImpound.recovery_fee_max
            end
            local user_id = vRP.getUserId(player)
            local playerVehicle = playerGarage.getPlayerVehicle(user_id, vname)
            if vRP.tryFullPayment(user_id,recovery_fee) then
              vRPclient.spawnGarageVehicle(player,{"default",vname,getVehicleOptions(playerVehicle),getVehicleDamage(playerVehicle)})
              vRPclient.notify(player,{"You have paid a recovery fee of $"..recovery_fee.." to recover your vehicle."})
              tvRP.setVehicleOutStatus(player,vname,1,0)
              vRP.closeMenu(player)
              Log.write(user_id, "Payed $"..recovery_fee.." to recover "..vname.." from the map", Log.log_type.garage)
            else
              vRPclient.notify(player,{"You do not have enough money to pay the recovery fee for this vehicle!"})
            end
          end
        end
      end

      -- get player owned vehicles that are out, but not impounded
      MySQL.Async.fetchAll('SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id AND out_status = 1 AND in_impound = 0', {user_id = user_id}, function(pvehicles)
        for k,v in pairs(pvehicles) do
          local vehicle = vehicles[v.vehicle]
          if vehicle then
            local recovery_fee = math.floor(vehicle[2]*cfgImpound.recovery_rate)
            if recovery_fee < cfgImpound.recovery_fee_min then
              recovery_fee = cfgImpound.recovery_fee_min
            elseif recovery_fee > cfgImpound.recovery_fee_max then
              recovery_fee = cfgImpound.recovery_fee_max
            end
            submenu[vehicle[1]] = {choose,"Recovery Fee: $"..recovery_fee}
            kitems[vehicle[1]] = v.vehicle
          end
        end

        vRP.openMenu(player,submenu)
      end)
    end
  end,"Can't find your vehicle, recover it here"}
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
        vRPclient.addBlip(source,{x,y,z,gcfg.blipid,gcfg.blipcolor,"Impound Lot"})
        end
        vRPclient.addMarker(source,{x,y,z-0.97,1.5,1.5,0.0,0,255,125,125,150,23})

        vRP.setArea(source,"vRP:impound"..k,x,y,z,1,1.5,garage_enter,garage_leave)
      end
    end
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
  if first_spawn then
    -- We dont use vRP garages
    build_client_garages(source)
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
end, lang.vehicle.trunk.description(), 6}

--[[
-- detach trailer
veh_actions[lang.vehicle.detach_trailer.title()] = {function(user_id,player,vtype,name)
  vRPclient.vc_detachTrailer(player, {name})
end, lang.vehicle.detach_trailer.description()}

-- detach cargobob
veh_actions[lang.vehicle.detach_cargobob.title()] = {function(user_id,player,vtype,name)
  vRPclient.vc_detachCargobob(player, {name})
end, lang.vehicle.detach_cargobob.description()}
]]--
-- lock/unlock

veh_actions[lang.vehicle.lock.title()] = {function(user_id,player,vtype,name)
  vRPclient.vc_toggleLock(player, {name})
end, lang.vehicle.lock.description(), 1}

-- engine on/off
veh_actions[lang.vehicle.engine.title()] = {function(user_id,player,vtype,name)
  vRPcustom.toggleEngine(player, {})
end, lang.vehicle.engine.description(), 2}

-- Roll Windows
veh_actions["Roll Windows"] = {function(user_id,player,vtype,name)
  vRPclient.rollWindows(player, {})
end, "", 3}

veh_actions["Explode"] = {function(user_id,player,vtype,name)
  vRPclient.explodeCurrentVehicle(player, {name})
end, "", 4}

veh_actions["Give Keys"] = {function(user_id,player,vtype,name)
  vRPclient.getNearestPlayer(player,{3},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      if vRP.getInventoryItemAmount(nuser_id,"key_chain") > 0 then
        vRPclient.getNearestOwnedVehiclePlate(player,{5},function(ok,vtype,name,plate)
          if ok then
            vRP.getUserIdentity(user_id, function(identity)
              if plate == identity.registration then
                vRPclient.giveKey(nplayer,{name, plate})
                vRPclient.notify(player,{"You gave keys."})
                Log.write(user_id, "Gave keys for a "..name..", plate "..plate.." to vRP ID "..nuser_id, Log.log_type.action)
              end
            end)
          end
        end)
      else
        vRPclient.notify(player,{"The person you are trying to give keys to does not have a keychain. They are lost without one."})
      end
    else
      vRPclient.notify(player,{"Did not find anyone."})
    end
  end)
end, "Give out a set of keys. Can't get them back.", 5}

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
    vRPclient.isPedInCar(player,{},function(inVeh)
      if not inVeh then
        vRPclient.getActionLock(player, {},function(locked)
          if not locked then
            vRPcustom.canRepairVehicle(player, {}, function(canRepair)
              if canRepair then
                if vRP.hasPermission(user_id, "mechanic.repair") then
                  vRPcustom.IsNearMechanicOrRepairTruck(player, {}, function(result)
                    if result then
                      vRPcustom.attemptRepairVehicle(player, {true})
                      Log.write(user_id, "Performed a full vehicle repair at no cost", Log.log_type.action)
                    else
                      if vRP.tryGetInventoryItem(user_id,"carrepairkit",1,true) then
                        vRPcustom.attemptRepairVehicle(player, {false})
                      else
                        vRPclient.notify(player,{lang.inventory.missing({vRP.getItemName("carrepairkit"),1})})
                      end
                    end
                  end)
                else
                  vRPcustom.IsNearMechanic(player, {}, function(result)
                    if result then
                      local fee = cfg.mechanicRepairCostBase
                      local mechanicCount = vRP.getUserCountByPermission("towtruck.tow") + 1
                      fee = fee * mechanicCount
                      vRP.request(player, "It will cost $"..fee.." to use this facilty. Do you want to proceed?", 15, function(player,ok)
                        if ok then
                          if vRP.tryDebitedPayment(user_id,fee) then
                            vRPclient.notify(player, {"You paid $"..fee.." to use the facility."})
                            vRPcustom.attemptRepairVehicle(player, {false})
                            Log.write(user_id, "Paid $"..fee.." for full vehicle repair at shop", Log.log_type.action)
                          else
                            vRPclient.notify(player, {"You don't have the required funds to use the facility. Cost is $"..fee})
                          end
                        end
                      end)
                    else
                      if vRP.tryGetInventoryItem(user_id,"carrepairkit",1,true) then
                        vRPcustom.attemptRepairVehicle(player, {false})
                      else
                        vRPclient.notify(player,{lang.inventory.missing({vRP.getItemName("carrepairkit"),1})})
                      end
                    end
                  end)
                end
              else
                vRPclient.notify(player, {"Repair attempt failed. Make sure you are looking at the engine."})
              end
            end)
          end
        end)
      end
    end)
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
    choices[lang.vehicle.title()] = {ch_vehicle,"Vehicle Menu",12}

    -- add ask trunk
    choices[lang.vehicle.asktrunk.title()] = {ch_asktrunk,"Ask to open the trunk to someone else's vehicle",11}

    -- add repair functions
    if vRP.hasPermission(user_id, "vehicle.repair") then
      choices[lang.vehicle.repair.title()] = {ch_repair, lang.vehicle.repair.description(),13}
    end

    if vRP.hasPermission(user_id, "vehicle.replace") then
      choices[lang.vehicle.replace.title()] = {ch_replace, lang.vehicle.replace.description(),14}
    end

    add(choices)
  end
end)

RegisterServerEvent('vrp:purchaseVehicle')
AddEventHandler('vrp:purchaseVehicle', function(garage, vehicle)
  local source = source
  local player = vRP.getUserId(source)
  if string.lower(vehicle) == "flatbed" then
    vRP.playerLicenses.getPlayerLicense(player, "towlicense", function(towlicense)
      if towlicense == 1 then
        if not vRP.hasPermission(player,"towtruck.tow") then
          vRPclient.notify(source, {"You are not signed in as a tow truck driver."})
          return false
        end
      else
        vRPclient.notify(source, {"You do not have a tow truck license."})
        return false
      end
      purchaseVehicle(source, garage, vehicle)
      return true
    end)
    return false
  end
  if garage == "emergencyair" then
    if vRP.hasPermission(player,"police.vehicle") or vRP.hasPermission(player,"emergency.vehicle") then
      -- Rank 6 +
      if (string.lower(vehicle) == "polmav") and not (vRP.hasPermission(player,"police.rank4") or vRP.hasPermission(player,"police.rank5") or vRP.hasPermission(player,"police.rank6") or vRP.hasPermission(player,"police.rank7")) and not (vRP.hasPermission(player,"ems.rank2") or vRP.hasPermission(player,"ems.rank3") or vRP.hasPermission(player,"ems.rank4") or vRP.hasPermission(player,"ems.rank5")) then
        vRPclient.notify(source,{"You do not meet the rank requirement."})
        return false
      end
    else
      vRPclient.notify(source,{"You are not signed in as a EMS or police officer."})
      return false
    end
  end

  if garage == "emergencyboats" then
    if (vRP.hasPermission(player,"police.vehicle") or vRP.hasPermission(player,"emergency.vehicle")) then
      if (string.lower(vehicle) == "predator" and not vRP.hasPermission(player,"police.vehicle")) then
        vRPclient.notify(source,{"You are not signed in as a police officer."})
        return false
      elseif (string.lower(vehicle) == "predator2") and not (vRP.hasPermission(player,"emergency.vehicle")) then
        vRPclient.notify(source,{"You do not meet the rank requirement."})
        return false
      end
    else
      vRPclient.notify(source,{"You are not signed in as a police officer."})
      return false
    end
  end

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
      elseif (string.lower(vehicle) == "fpis" or string.lower(vehicle) == "fbitahoe" or string.lower(vehicle) == "fbi2") and not (vRP.hasPermission(player,"police.rank4") or vRP.hasPermission(player,"police.rank5") or vRP.hasPermission(player,"police.rank6") or vRP.hasPermission(player,"police.rank7")) then
        vRPclient.notify(source,{"You do not meet the rank requirement."})
        return false
      -- Rank 3 +
      elseif (string.lower(vehicle) == "uccvpi" or string.lower(vehicle) == "policeb2" or string.lower(vehicle) == "explorer") and not (vRP.hasPermission(player,"police.rank3") or vRP.hasPermission(player,"police.rank4") or vRP.hasPermission(player,"police.rank5") or vRP.hasPermission(player,"police.rank6") or vRP.hasPermission(player,"police.rank7")) then
        vRPclient.notify(source,{"You do not meet the rank requirement."})
        return false
      -- Rank 2 +
      elseif (string.lower(vehicle) == "charger" or string.lower(vehicle) == "tahoe" or string.lower(vehicle) == "policeb") and not (vRP.hasPermission(player,"police.rank2") or vRP.hasPermission(player,"police.rank3") or vRP.hasPermission(player,"police.rank4") or vRP.hasPermission(player,"police.rank5") or vRP.hasPermission(player,"police.rank6") or vRP.hasPermission(player,"police.rank7")) then
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
      if (string.lower(vehicle) == "raptor2") and not (vRP.hasPermission(player,"ems.rank5")) then
        vRPclient.notify(source,{"You do not meet the rank requirement."})
        return false
      elseif (string.lower(vehicle) == "asstchief") and not (vRP.hasPermission(player,"ems.rank4") or vRP.hasPermission(player,"ems.rank5")) then
        vRPclient.notify(source,{"You do not meet the rank requirement."})
        return false
      elseif (string.lower(vehicle) == "chiefpara") and not (vRP.hasPermission(player,"ems.rank3") or vRP.hasPermission(player,"ems.rank4") or vRP.hasPermission(player,"ems.rank5")) then
        vRPclient.notify(source,{"You do not meet the rank requirement."})
        return false
      elseif (string.lower(vehicle) == "firesuv") and not (vRP.hasPermission(player,"ems.rank2") or vRP.hasPermission(player,"ems.rank3") or vRP.hasPermission(player,"ems.rank4") or vRP.hasPermission(player,"ems.rank5")) then
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

RegisterServerEvent('vrp:sellVehicle')
AddEventHandler('vrp:sellVehicle', function(garage, vehicle)
  sellVehicle(source, garage, vehicle)
  return true
end)

RegisterServerEvent('vrp:storeVehicle')
AddEventHandler('vrp:storeVehicle', function()
  vRPclient.despawnGarageVehicle(source,{"default",15})
end)

function getVehicleOptions(v)
  return { main_colour = v.colour, secondary_colour = v.scolour, ecolor = v.ecolor, ecolorextra = v.ecolorextra, plate = v.plate, wheels = v.wheels, windows = v.windows, platetype = v.platetype, exhausts = v.exhausts, grills = v.grills, spoiler = v.spoiler, mods = v.mods, smokecolor1 = v.smokecolor1, smokecolor2 = v.smokecolor2, smokecolor3 = v.smokecolor3, neoncolor1 = v.neoncolor1, neoncolor2 = v.neoncolor2, neoncolor3 = v.neoncolor3 }
end

function getVehicleDamage(v)
  return {engineDamage = v.engineDamage, bodyDamage = v.bodyDamage, fuelDamage = v.fuelDamage}
end

function purchaseVehicle(player, garage, vname)
  local user_id = vRP.getUserId(player)
  if vname then
    -- buy vehicle
    local veh_type = vehicle_groups[garage]._config.vtype or "default"
    local vehicle = vehicle_groups[garage][vname]

    local playerVehicle = nil
		if garage == "emergencyair" or garage == "emergencyboats" or garage == "emergency" or garage == "police" then
			playerVehicle = playerGarage.getPlayerVehicle(user_id, vname)
		else
			playerVehicle = playerGarage.getPlayerVehicleShared(user_id, vname)
		end

    if playerVehicle then
			vRP.getUserSpouse(user_id,function(suser_id)
				if garage == "emergencyair" or garage == "emergencyboats" or garage == "emergency" or garage == "police" then
					suser_id = 0
				end
	      MySQL.Async.fetchAll('SELECT user_id, out_status, in_impound FROM vrp_user_vehicles WHERE (user_id = @user_id or user_id = @suser_id) and vehicle = @vname LIMIT 1', {user_id = user_id, suser_id = suser_id, vname = vname}, function(rows)
	        if #rows > 0 then
	          if rows[1].out_status == 1 and (garage ~= "police" and garage ~= "emergency" and garage ~= "emergencyair" and garage ~= "emergencyboats") then
	            vRPclient.notify(player,{"This vehicle is not in your garage. You have previously pulled it out."})
	          elseif rows[1].in_impound == 1 and (garage ~= "police" and garage ~= "emergency" and garage ~= "emergencyair" and garage ~= "emergencyboats" and garage ~= "planes" and garage ~= "helicopters" and garage ~= "boats") then
	            vRPclient.notify(player,{"This vehicle is at the impound. You can retrieve it there."})
	          else
	            local garage_fee = math.floor(vehicle[2]*0.01)
	            if garage == "supercars" then
	              if (garage_fee > 5000) then
	                garage_fee = 5000
	              end
	            else
	              if (garage_fee > 1000) then
	                garage_fee = 1000
	              end
	            end
	            if garage_fee < 200 then
	              garage_fee = 200
	            end
	            if vRP.tryFullPayment(user_id,garage_fee) then
	              vRPclient.spawnGarageVehicle(player,{veh_type,vname,getVehicleOptions(playerVehicle),getVehicleDamage(playerVehicle)})
	              vRPclient.notify(player,{"You have paid a storage fee of $"..garage_fee.." to retrieve your vehicle from the garage."})
	              if garage ~= "police" and garage ~= "emergency" and garage ~= "emergencyair" and garage ~= "emergencyboats" then
	                tvRP.setVehicleOutStatus(rows[1].user_id,vname,1,0)
	              end
	            else
	              vRPclient.notify(player,{"You do not have enough money to pay the storage fee for this vehicle!"})
	            end
	          end
	        end
	      end)
			end)
    elseif vehicle then
      vRP.request(player, "Do you want to buy "..vehicle[1].." for $"..vehicle[2], 15, function(player,ok)
        if ok and vRP.tryFullPayment(user_id,vehicle[2]) then
          MySQL.Async.execute('INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle) VALUES(@user_id,@vehicle)', {user_id = user_id, vehicle = vname}, function(rowsChanged) end)
          if garage ~= "police" and garage ~= "emergency" then
            tvRP.setVehicleOutStatus(player,vname,1,0)
          end
          vRPclient.notify(player,{lang.money.paid({vehicle[2]})})
          vRPclient.spawnGarageVehicle(player,{veh_type,vname,{}})
          Log.write(user_id, "Purchased "..vname.." for "..vehicle[2], Log.log_type.purchase)
        end
      end)
    else
      vRPclient.notify(player,{lang.money.not_enough()})
    end
  end
end

function tvRP.setVehicleOutStatus(source,vname,status,impound)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil and vname ~= nil and status ~= nil then
    if impound == nil then
      impound = 0
    end
    MySQL.Async.execute('UPDATE vrp_user_vehicles SET out_status = @status, in_impound = @impound WHERE user_id = @user_id and vehicle = @vname', {user_id = user_id, vname = vname, status = status, impound = impound}, function(rowsChanged)
			if rowsChanged == 0 then
				vRP.getUserSpouse(user_id,function(suser_id)
					MySQL.Async.execute('UPDATE vrp_user_vehicles SET out_status = @status, in_impound = @impound WHERE user_id = @user_id and vehicle = @vname', {user_id = suser_id, vname = vname, status = status, impound = impound}, function(rowsChanged)  end)
				end)
			end
		end)
  end
end

function tvRP.setVehicleOutStatusPlate(plate,vname,status,impound)
  if plate ~= nil and vname ~= nil and status ~= nil then
    if impound == nil then
      impound = 0
    end
    MySQL.Async.execute('UPDATE vrp_user_vehicles SET out_status = @status, in_impound = @impound WHERE user_id = (SELECT user_id FROM gta5_gamemode_essential.vrp_user_identities WHERE registration = @plate) and vehicle = @vname', {plate = plate, vname = vname, status = status, impound = impound}, function(rowsChanged)
			if rowsChanged == 0 then
				MySQL.Async.execute('UPDATE vrp_user_vehicles SET out_status = @status, in_impound = @impound WHERE user_id = (SELECT spouse FROM gta5_gamemode_essential.vrp_user_identities WHERE registration = @plate) and vehicle = @vname', {plate = plate, vname = vname, status = status, impound = impound}, function(rowsChanged) end)
			end
		end)
  end
end

function tvRP.saveVehicleDamage(engineDamage,bodyDamage,fuelDamage,carName)
  local user_id = vRP.getUserId(source)
  MySQL.Async.execute('UPDATE vrp_user_vehicles SET engineDamage = @engineDamage, bodyDamage = @bodyDamage, fuelDamage = @fuelDamage WHERE user_id = @user_id AND vehicle = @vname', {engineDamage = engineDamage, bodyDamage = bodyDamage, fuelDamage = fuelDamage, user_id = user_id, vname = carName}, function(rowsChanged) end)
end

function sellVehicle(player, garage, vname)
  local user_id = vRP.getUserId(player)
  if vname then
    -- buy vehicle
    local veh_type = vehicle_groups[garage]._config.vtype or "default"
    local vehicle = vehicle_groups[garage][vname]
    local playerVehicle = playerGarage.getPlayerVehicle(user_id, vname)
    local sellprice = math.floor(vehicle[2]*cfg.sell_factor)
    if playerVehicle then
      vRP.request(player, "Do you want to sell your "..vehicle[1].." for $"..sellprice, 15, function(player,ok)
        if ok then
          MySQL.Async.execute('DELETE FROM vrp_user_vehicles WHERE user_id = @user AND vehicle = @vehicle', {user = user_id, vehicle = vname}, function(rowsChanged)
            if (rowsChanged > 0) then
              vRP.giveBankMoney(user_id,sellprice)
              vRPclient.notify(player,{lang.money.received({sellprice})})
              Log.write(user_id, "Sold "..vname.." for "..sellprice, Log.log_type.action)
              MySQL.Async.execute('DELETE FROM vrp_srv_data WHERE dkey = @dkey', {dkey = "chest:u"..user_id.."veh_"..vname}, function(rowsChanged) end)
            else
              Log.write(user_id, "Tried to sell vehicle they do not own, or already sold", Log.log_type.action)
            end
          end)
        end
      end)
    else
      Log.write(user_id, "Tried to sell vehicle they do not own ("..vname..")", Log.log_type.action)
    end
  end
end

function playerGarage.getVehicleGarage(vehicle)
  for group,vehicles in pairs(vehicle_groups) do
    if group ~= "impound" and (vehicle_groups[group][vehicle]) then
      return group
    end
  end

  return ""
end

function playerGarage.getPlayerVehicles(message)
  local user_id = vRP.getUserId(source)
  local _pvehicles = {}
  fs = source
  MySQL.Async.fetchAll('SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id', {user_id = user_id}, function(_pvehicles)
    ownedVehicles[user_id] = _pvehicles
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

function playerGarage.getPlayerVehiclesShared(message)
  local user_id = vRP.getUserId(source)
  local _pvehicles = {}
  fs = source
	playerGarage.getPlayerVehicles()
	vRP.getUserSpouse(user_id,function(suser_id)
	  MySQL.Async.fetchAll('SELECT * FROM vrp_user_vehicles WHERE (user_id = @user_id or user_id = @suser_id)', {user_id = user_id,suser_id = suser_id}, function(_pvehicles)
	    ownedVehicles_shared[user_id] = _pvehicles
	    TriggerClientEvent('es_carshop:recievePlayerVehicles',fs, _pvehicles)
	  end)
	end)
end

function playerGarage.getPlayerVehicleShared(user_id, vehicle)
  for k,v in pairs(ownedVehicles_shared[user_id]) do
    if v.vehicle == vehicle then
      return v
    end
  end

  return nil
end

RegisterServerEvent("vrp:rentGoKart")
AddEventHandler("vrp:rentGoKart", function(rentalFee)
  local player = source
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    if vRP.tryFullPayment(user_id,rentalFee) then
      vRPclient.rentOutGoKart(player,{})
    end
  end
end)

RegisterServerEvent("cs:clearTrunk")
AddEventHandler("cs:clearTrunk", function(plate,vehName)
  if plate ~= nil and vehName ~= nil then
    vRP.getUserByRegistration(plate, function(nuser_id)
      if nuser_id ~= nil then
        vRP.setSData("chest:u"..nuser_id.."veh_"..vehName, json.encode({}))
        Log.write(user_id, "Vehicle trunk cleared due to destruction. Trunk = chest:u"..nuser_id.."veh_"..vehName, Log.log_type.action)
      end
    end)
  end
end)
