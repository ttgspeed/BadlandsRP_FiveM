local lang = vRP.lang
local cfg = module("cfg/inventory")
local Log = module("lib/Log")

-- this module define the player inventory (lost after respawn, as wallet)

vRP.items = {}

-- define an inventory item (call this at server start) (parametric or plain text data)
-- idname: unique item name
-- name: display name or genfunction
-- description: item description (html) or genfunction
-- choices: menudata choices (see gui api) only as genfunction or nil
-- weight: weight or genfunction
--
-- genfunction are functions returning a correct value as: function(args) return value end
-- where args is a list of {base_idname,arg,arg,arg,...}
function vRP.defInventoryItem(idname,name,description,choices,weight)
  if weight == nil then
    weight = 0
  end

  local item = {name=name,description=description,choices=choices,weight=weight}
  vRP.items[idname] = item

  -- build give action
  item.ch_give = function(player,choice)
  end

  -- build trash action
  item.ch_trash = function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
      -- prompt number
      vRP.prompt(player,lang.inventory.trash.prompt({vRP.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
        local amount = parseInt(amount)
        if vRP.tryGetInventoryItem(user_id,idname,amount,false) then
          vRPclient.notify(player,{lang.inventory.trash.done({vRP.getItemName(idname),amount})})
          vRPclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
        else
          vRPclient.notify(player,{lang.common.invalid_value()})
        end
      end)
    end
  end
end

-- give action
function ch_give(idname, player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    -- get nearest player
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
          -- prompt number
          vRP.prompt(player,lang.inventory.give.prompt({vRP.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
            local amount = parseInt(amount)
            -- weight check
            local new_weight = vRP.getInventoryWeight(nuser_id)+vRP.getItemWeight(idname)*amount
            if new_weight <= vRP.getInventoryMaxWeight(nuser_id) then
              if vRP.tryGetInventoryItem(user_id,idname,amount,true) then
                vRP.giveInventoryItem(nuser_id,idname,amount,true)

                vRPclient.playAnim(player,{true,{{"mp_common","givetake1_a",1}},false})
                vRPclient.playAnim(nplayer,{true,{{"mp_common","givetake2_a",1}},false})
                Log.write(user_id,"Gave "..amount.." "..vRP.getItemName(idname).." to "..nuser_id,Log.log_type.action)
              else
                vRPclient.notify(player,{lang.common.invalid_value()})
              end
            else
              vRPclient.notify(player,{lang.inventory.full()})
            end
          end)
        else
          vRPclient.notify(player,{lang.common.no_player_near()})
        end
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end

-- trash action
function ch_trash(idname, player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getTransformerLock(player, {},function(locked)
      if not locked then
        -- prompt number
        vRP.prompt(player,lang.inventory.trash.prompt({vRP.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
          local amount = parseInt(amount)
          if vRP.tryGetInventoryItem(user_id,idname,amount,false) then
            vRPclient.notify(player,{lang.inventory.trash.done({vRP.getItemName(idname),amount})})
            vRPclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
            Log.write(user_id,"Trashed "..amount.." "..vRP.getItemName(idname),Log.log_type.action)
          else
            vRPclient.notify(player,{lang.common.invalid_value()})
          end
        end)
      else
        vRPclient.notify(player,{"You cannot trashing items while performing a task"})
      end
    end)
  end
end

function vRP.computeItemName(item,args)
  if type(item.name) == "string" then return item.name
  else return item.name(args) end
end

function vRP.computeItemDescription(item,args)
  if type(item.description) == "string" then return item.description
  else return item.description(args) end
end

function vRP.computeItemChoices(item,args)
  if item.choices ~= nil then
    return item.choices(args)
  else
    return {}
  end
end

function vRP.computeItemWeight(item,args)
  if type(item.weight) == "number" then return item.weight
  else return item.weight(args) end
end


function vRP.parseItem(idname)
  return splitString(idname,"|")
end

-- return name, description, weight
function vRP.getItemDefinition(idname)
  local args = vRP.parseItem(idname)
  local item = vRP.items[args[1]]
  if item ~= nil then
    return vRP.computeItemName(item,args), vRP.computeItemDescription(item,args), vRP.computeItemWeight(item,args)
  end

  return nil,nil,nil
end

function vRP.getItemName(idname)
  local args = vRP.parseItem(idname)
  local item = vRP.items[args[1]]
  if item ~= nil then return vRP.computeItemName(item,args) end
  return args[1]
end

function vRP.getItemDescription(idname)
  local args = vRP.parseItem(idname)
  local item = vRP.items[args[1]]
  if item ~= nil then return vRP.computeItemDescription(item,args) end
  return ""
end

function vRP.getItemChoices(idname)
  local args = vRP.parseItem(idname)
  local item = vRP.items[args[1]]
  local choices = {}
  if item ~= nil then
    -- compute choices
    local cchoices = vRP.computeItemChoices(item,args)
    if cchoices then -- copy computed choices
      for k,v in pairs(cchoices) do
        choices[k] = v
      end
    end

    -- add give/trash choices
    choices[lang.inventory.give.title()] = {function(player,choice) ch_give(idname, player, choice) end, lang.inventory.give.description()}
    choices[lang.inventory.trash.title()] = {function(player, choice) ch_trash(idname, player, choice) end, lang.inventory.trash.description()}
  end

  return choices
end

function vRP.getItemWeight(idname)
  local args = vRP.parseItem(idname)
  local item = vRP.items[args[1]]
  if item ~= nil then return vRP.computeItemWeight(item,args) end
  return 0
end

-- compute weight of a list of items (in inventory/chest format)
function vRP.computeItemsWeight(items)
  local weight = 0

  for k,v in pairs(items) do
    local iweight = vRP.getItemWeight(k)
    weight = weight+iweight*v.amount
  end

  return weight
end

-- add item to a connected user inventory
function vRP.giveInventoryItem(user_id,idname,amount,notify)
  if notify == nil then notify = true end -- notify by default

  local data = vRP.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry then -- add to entry
      entry.amount = entry.amount+amount
    else -- new entry
      data.inventory[idname] = {amount=amount}
    end

    -- notify
    if notify then
      local player = vRP.getUserSource(user_id)
      if player ~= nil then
        vRPclient.notify(player,{lang.inventory.give.received({vRP.getItemName(idname),amount})})
      end
    end
  end
end

-- try to get item from a connected user inventory
function vRP.tryGetInventoryItem(user_id,idname,amount,notify)
  if notify == nil then notify = true end -- notify by default

  local data = vRP.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry and entry.amount >= amount then -- add to entry
      entry.amount = entry.amount-amount

      -- remove entry if <= 0
      if entry.amount <= 0 then
        data.inventory[idname] = nil
      end

      -- notify
      if notify then
        local player = vRP.getUserSource(user_id)
        if player ~= nil then
          vRPclient.notify(player,{lang.inventory.give.given({vRP.getItemName(idname),amount})})
        end
      end

      return true
    else
      -- notify
      if notify then
        local player = vRP.getUserSource(user_id)
        if player ~= nil then
          local entry_amount = 0
          if entry then entry_amount = entry.amount end
          vRPclient.notify(player,{lang.inventory.missing({vRP.getItemName(idname),amount-entry_amount})})
        end
      end
    end
  end

  return false
end

-- get user inventory amount of item
function vRP.getInventoryItemAmount(user_id,idname)
  local data = vRP.getUserDataTable(user_id)
  if data and data.inventory then
    local entry = data.inventory[idname]
    if entry then
      return entry.amount
    end
  end

  return 0
end

-- return user inventory total weight
function vRP.getInventoryWeight(user_id)
  local data = vRP.getUserDataTable(user_id)
  if data and data.inventory then
    return vRP.computeItemsWeight(data.inventory)
  end

  return 0
end

-- return maximum weight of the user inventory
function vRP.getInventoryMaxWeight(user_id)
  return math.floor(vRP.expToLevel(vRP.getExp(user_id, "physical", "strength")))*cfg.inventory_weight_per_strength
end

-- clear connected user inventory
function vRP.clearInventory(user_id)
  local data = vRP.getUserDataTable(user_id)
  if data then
    data.inventory = {}
  end
end

-- INVENTORY MENU

-- open player inventory
function vRP.openInventory(source)
  local user_id = vRP.getUserId(source)

  if user_id ~= nil then
    local data = vRP.getUserDataTable(user_id)
    if data then
      -- build inventory menu
      local menudata = {name=lang.inventory.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}
      -- add inventory info
      local weight = vRP.getInventoryWeight(user_id)
      local max_weight = vRP.getInventoryMaxWeight(user_id)
      local hue = math.floor(math.max(125*(1-weight/max_weight), 0))
      menudata["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f",weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f",weight),max_weight})}
      local kitems = {}

      -- choose callback, nested menu, create the item menu
      local choose = function(player,choice)
        if string.sub(choice,1,1) ~= "@" then -- ignore info choices
        local choices = vRP.getItemChoices(kitems[choice])
          -- build item menu
          local submenudata = {name=choice,css={top="75px",header_color="rgba(0,125,255,0.75)"}}

          -- add computed choices
          for k,v in pairs(choices) do
            submenudata[k] = v
          end

          -- nest menu
          submenudata.onclose = function()
            vRP.openInventory(source) -- reopen inventory when submenu closed
          end

          -- open menu
          vRP.openMenu(source,submenudata)
        end
      end

      -- add each item to the menu
      for k,v in pairs(data.inventory) do
        local name,description,weight = vRP.getItemDefinition(k)
        if name ~= nil then
          kitems[name] = k -- reference item by display name
          menudata[name] = {choose,lang.inventory.iteminfo({v.amount,description,string.format("%.2f",weight)})}
        end
      end

      -- open menu
      vRP.openMenu(source,menudata)
    end
  end
end

-- init inventory
AddEventHandler("vRP:playerJoin", function(user_id,source,name,last_login)
  local data = vRP.getUserDataTable(user_id)
  if data.inventory == nil then
    data.inventory = {}
  end
end)


-- add open inventory to main menu
local choices = {}
choices[lang.inventory.title()] = {function(player, choice) vRP.openInventory(player) end, lang.inventory.description(),4}

vRP.registerMenuBuilder("main", function(add, data)
  add(choices)
end)

-- CHEST SYSTEM

local chests = {}

function tvRP.create_death_chest(owner_id, x, y, z, player)

  --create create the chest containing the player's inventory
  owner_id = vRP.getUserId(owner_id)
  local data = vRP.getUserDataTable(owner_id)
  local chestname = "u"..owner_id.."death"
  if data and data.inventory then
    -- initialize the chest and set the inventory
    local chest = {max_weight = 500}
    chests[chestname] = chest
    vRP.setSData("chest:"..chestname, json.encode(data.inventory))
    --nil it out, openChest will handle it from here
    chests[chestname] = nil
    --remove player inventory, it's all in the chest now...
    vRP.clearInventory(owner_id)
  end

  for _,player in pairs(GetPlayers()) do
    local chest_enter = function(player,area)
      local user_id = vRP.getUserId(player)
      vRP.openChest(player, "u"..owner_id.."death", 200,nil,nil,nil)
    end

    local chest_leave = function(player,area)
      vRP.closeMenu(player)
    end

    local nid = "vRP:death:slot"..owner_id..":chest"

    vRPclient.setNamedMarker(player,{nid,x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})
    vRP.setArea(player,nid,x,y,z,1,1.5,chest_enter,chest_leave)

    SetTimeout(30000,function() --delete chest after x timeout
      vRP.destroy_death_chest(owner_id, x, y, z, player)
      vRP.setSData("chest:"..chestname, json.encode({}))
    end)
	end
end

function vRP.destroy_death_chest(owner_id, x, y, z, player)
  local nid = "vRP:death:slot"..owner_id..":chest"
  vRPclient.removeNamedMarker(player,{nid})
  vRP.removeArea(player,nid)
end

-- build a menu from a list of items and bind a callback(idname)
local function build_itemlist_menu(name, items, cb)
  local menu = {name=name, css={top="75px",header_color="rgba(0,255,125,0.75)"}}

  local kitems = {}

  -- choice callback
  local choose = function(player,choice)
    local idname = kitems[choice]
    if idname then
      cb(idname)
    end
  end

  -- add each item to the menu
  for k,v in pairs(items) do
    local name,description,weight = vRP.getItemDefinition(k)
    if name ~= nil then
      kitems[name] = k -- reference item by display name
      menu[name] = {choose,lang.inventory.iteminfo({v.amount,description,string.format("%.2f", weight)})}
    end
  end

  return menu
end

-- open a chest by name
-- cb_close(): called when the chest is closed (optional)
-- cb_in(idname, amount): called when an item is added (optional)
-- cb_out(idname, amount): called when an item is taken (optional)
function vRP.openChest(source, name, max_weight, cb_close, cb_in, cb_out)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    vRPclient.isPedInCar(source,{},function(inveh)
      if not inveh then
        local data = vRP.getUserDataTable(user_id)
        if data.inventory ~= nil then
          local chestname = "chest:"..name

          --check if user has access to chest
          if chests[name] ~= nil then
            if chests[name].access ~= source then
              vRPclient.notify(source,{lang.inventory.chest.already_opened()})
              return
            end
          end
          local close_count = 0 -- used to know when the chest is closed (unlocked)

					-- load chest
          local chest = {max_weight = max_weight}
          chest.access = source
          chests[name] = chest
          vRP.getSData("chest:"..name, function(cdata)
            chest.items = json.decode(cdata) or {} -- load items

            -- open menu
            local menu = {name=lang.inventory.chest.title(), css={top="75px",header_color="rgba(0,255,125,0.75)"}}
            -- take
            local cb_take = function(idname)
              vRPclient.isPedInCar(source,{},function(inveh)
                if not inveh then
                  local citem = chest.items[idname]
                  vRP.prompt(source, lang.inventory.chest.take.prompt({citem.amount}), "", function(player, amount)
                    amount = parseInt(amount)
                    if amount >= 0 and amount <= citem.amount then
                      -- take item

                      -- weight check
                      local new_weight = vRP.getInventoryWeight(user_id)+vRP.getItemWeight(idname)*amount
                      if new_weight <= vRP.getInventoryMaxWeight(user_id) then
                        vRP.giveInventoryItem(user_id, idname, amount, true)
                        Log.write(user_id,"Took "..amount.." "..vRP.getItemName(idname).." from "..chestname,Log.log_type.action)
                        citem.amount = citem.amount-amount

                        if citem.amount <= 0 then
                          chest.items[idname] = nil -- remove item entry
                        end

                        if cb_out then cb_out(idname,amount) end

                        -- actualize by closing
                        vRP.closeMenu(player)
                      else
                        vRPclient.notify(source,{lang.inventory.full()})
                      end
                    else
                      vRPclient.notify(source,{lang.common.invalid_value()})
                    end
                  end)
                else
                  vRP.closeMenu(source)
                end
              end)
            end

            local ch_take = function(player, choice)
              vRPclient.isPedInCar(player,{},function(inveh)
                if not inveh then
                  local submenu = build_itemlist_menu(lang.inventory.chest.take.title(), chest.items, cb_take)
                  -- add weight info
                  local weight = vRP.computeItemsWeight(chest.items)
                  local hue = math.floor(math.max(125*(1-weight/max_weight), 0))
                  submenu["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f",weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f",weight),max_weight})}

                  submenu.onclose = function()
                    close_count = close_count-1
                    vRP.openMenu(player, menu)
                  end
                  close_count = close_count+1
                  vRP.openMenu(player, submenu)
                else
                  vRP.closeMenu(player)
                end
              end)
            end


            -- put
            local cb_put = function(idname)
              vRPclient.isPedInCar(source,{},function(inveh)
                if not inveh then
                  vRP.prompt(source, lang.inventory.chest.put.prompt({vRP.getInventoryItemAmount(user_id, idname)}), "", function(player, amount)
                    amount = parseInt(amount)

                    -- weight check
                    local new_weight = vRP.computeItemsWeight(chest.items)+vRP.getItemWeight(idname)*amount
                    if new_weight <= max_weight then
                      if amount >= 0 and vRP.tryGetInventoryItem(user_id, idname, amount, true) then
                        Log.write(user_id,"Put "..amount.." "..vRP.getItemName(idname).." in "..chestname,Log.log_type.action)
                        local citem = chest.items[idname]

                        if citem ~= nil then
                          citem.amount = citem.amount+amount
                        else -- create item entry
                          chest.items[idname] = {amount=amount}
                        end

                        -- callback
                        if cb_in then cb_in(idname,amount) end

                        -- actualize by closing
                        vRP.closeMenu(player)
                      end
                    else
                      vRPclient.notify(source,{lang.inventory.chest.full()})
                    end
                  end)
                else
                  vRP.closeMenu(source)
                end
              end)
            end

            local ch_put = function(player, choice)
              vRPclient.isPedInCar(player,{},function(inveh)
                if not inveh then
                  local submenu = build_itemlist_menu(lang.inventory.chest.put.title(), data.inventory, cb_put)
                  -- add weight info
                  local weight = vRP.computeItemsWeight(data.inventory)
                  local hue = math.floor(math.max(125*(1-weight/max_weight), 0))
                  submenu["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f",weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f",weight),max_weight})}

                  submenu.onclose = function()
                    close_count = close_count-1
                    vRP.openMenu(player, menu)
                  end
                  close_count = close_count+1
                  vRP.openMenu(player, submenu)
                else
                  vRP.closeMenu(player)
                end
              end)
            end


						-- choices
						menu[lang.inventory.chest.take.title()] = {ch_take}
						menu[lang.inventory.chest.put.title()] = {ch_put}

						menu.onclose = function()
							if close_count == 0 then -- close chest
								-- save chest items
								vRP.setSData("chest:"..name, json.encode(chest.items))
								chests[name] = nil
								if cb_close then cb_close() end -- close callback
							end
						end

						-- open menu
						vRP.openMenu(source, menu)
					end)
        end
      else
        vRPclient.notify(source,{"You cannot access the trunk from inside the vehicle."})
      end
    end)
  end
end

function vRP.setChestOpen(name)
  chests[name] = {access = nil}
end

function vRP.setChestClosed(name)
  chests[name] = nil
end

function vRP.isChestOpen(name)
  return chests[name] ~= nil
end
