
-- this module describe the shop system (experimental, a lot can happen and not being handled)

local lang = vRP.lang
local Log = module("lib/Log")
local cfg = module("cfg/business_shops")

-- api

local components = {}

-- SLOTS

-- used (or not) slots
local uslots = {}
-- for k,v in pairs(cfg.slot_types) do
-- 	uslots[k] = {}
-- 	for l,w in pairs(v) do
-- 		uslots[k][l] = {used=false}
-- 	end
-- end

-- builds

local function is_empty(table)
	for k,v in pairs(table) do
		return false
	end

	return true
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

-- leave slot
local function leave_slot(user_id,player,stype,sid) -- called when a player leave a slot
	print(user_id.." leave business slot "..stype.." "..sid)
	if uslots[stype] == nil or uslots[stype][sid] == nil then
		return
	end
	local slot = uslots[stype][sid]
	local shop = cfg.stores[slot.store_name]

	-- record if inside a shop slot
	local tmp = vRP.getUserTmpTable(user_id)
	if tmp then
		tmp.home_stype = nil
		tmp.home_sid = nil
	end

	-- teleport to shop entry point (outside)
	vRPclient.teleport(player, shop.entry_point) -- already an array of params (x,y,z)

	-- uncount player
	slot.players[user_id] = nil

	-- destroy loaded components and special entry component
	for k,v in pairs(cfg.slot_types[stype][sid]) do
		local name,x,y,z = table.unpack(v)

		if name == "entry" then
			-- remove marker/area
			local nid = "vRP:shop:slot"..stype..sid
			vRPclient.removeNamedMarker(player,{nid})
			vRP.removeArea(player,nid)
		else
			local component = components[v[1]]
			if component then
				-- ondestroy(owner_id, slot_type, slot_id, cid, config, x, y, z, player)
				component[2](slot.owner_id, stype, sid, k, v._config or {}, x, y, z, player)
			end
		end
	end

	if is_empty(slot.players) then -- free the slot
		print("free slot "..stype.." "..sid)
		freeSlot(stype,sid)
	end
end

-- enter slot
local function enter_slot(user_id,player,stype,sid) -- called when a player enter a slot
	print(user_id.." enter slot "..stype.." "..sid)
	local slot = uslots[stype][sid]
	local shop = cfg.stores[slot.store_name]

	-- record inside a shop slot
	local tmp = vRP.getUserTmpTable(user_id)
	if tmp then
		tmp.home_stype = stype
		tmp.home_sid = sid
	end

	-- count
	slot.players[user_id] = player

	-- build the slot entry menu
	local menu = {name=slot.store_name,css={top="75px",header_color="rgba(0,255,125,0.75)"}}
	menu[lang.business.slot.leave.title()] = {function(player,choice) -- add leave choice
		leave_slot(user_id,player,stype,sid)
	end}

	vRP.getUserOffice(user_id, function(address)
		if address ~= nil and user_id == slot.owner_id then
			menu[lang.business.slot.ejectall.title()] = {function(player,choice) -- add eject all choice
				-- copy players before calling leave for each (iteration while removing)
				local copy = {}
				for k,v in pairs(slot.players) do
					copy[k] = v
				end

				for k,v in pairs(copy) do
					leave_slot(k,v,stype,sid)
				end
			end,lang.business.slot.ejectall.description()}
		end

		-- build the slot entry menu marker/area

		local function entry_enter(player,area)
			vRP.openMenu(player,menu)
		end

		local function entry_leave(player,area)
			vRP.closeMenu(player)
		end

		-- build components and special entry component
		for k,v in pairs(cfg.slot_types[stype][sid]) do
			local name,x,y,z = table.unpack(v)

			if name == "entry" then
				-- teleport to the slot entry point
				vRPclient.teleport(player, {x,y,z}) -- already an array of params (x,y,z)

				local nid = "vRP:shop:slot"..stype..sid
				vRPclient.setNamedMarker(player,{nid,x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})
				vRP.setArea(player,nid,x,y,z,1,1.5,entry_enter,entry_leave)
			else -- load regular component
				local component = components[v[1]]
				if component then
					-- oncreate(owner_id, slot_type, slot_id, cid, config, x, y, z, player)
					component[1](slot.owner_id, stype, sid, k, v._config or {}, x, y, z, player)
				end
			end
		end
	end)
end

-- build the shop entry menu
local function build_entry_menu(user_id, store_name)
	local shop = cfg.stores[store_name]
	local menu = {name=shop.name,css={top="75px",header_color="rgba(0,255,125,0.75)"}}

	menu["Rent Shop"] = {function(player,choice)
		vRP.getPlayerBusiness(user_id, function(business_id)
			if business_id > 0 then -- check if not already have a shop
				vRP.request(player, "Are you sure you want to rent this property?", 15, function(player,ok)
					if ok then
						vRP.withdrawBusiness(business_id,shop.rent,function(rowsChanged)
							if rowsChanged > 0 then
								-- bought, set address
								Log.write(user_id, "Rented "..shop.name.." for $"..shop.rent,Log.log_type.business)
								vRP.logBusinessAction(business_id,user_id,user_id.." rented "..shop.name.." for $"..shop.rent)
								vRPclient.notify(player,{"Your business has rented the shop. Be sure to keep it stocked!"})
							else
								vRPclient.notify(player,{"Your business does not have the funds to cover this purchase."})
							end
						end)
					end
				end)
			else
				vRPclient.notify(player,"You must be employed by a business to rent a shop!")
			end
		end)
	end, "Rent this shop for $"..shop.rent}

	menu["Safe Withdraw"] = {function(player,choice)
		vRP.getPlayerBusiness(user_id,function(business_id)
			if business_id ~= nil and business_id > 0 then -- check if already have a shop
				vRP.request(player, "Sell Property", 15, function(player,ok)
					if ok then
						-- sold, give sell price, remove address
						Log.write(user_id, "Sold a business for $"..shop.sell_price,Log.log_type.business)
						vRP.giveMoney(user_id, shop.sell_price)
						vRP.removeUserOffice(user_id)
						vRPclient.notify(player,{lang.business.sell.sold()})
					end
				end)
			else
				vRPclient.notify(player,"You must be employed by a business to rent a shop!")
			end
		end)
	end, lang.business.sell.description({shop.sell_price})}

	local cb_add_inventory = function(idname)
		local name,description,weight = vRP.getItemDefinition(idname)
		local player = source
		vRP.prompt(player, "Add how many "..name.." to stock?", "", function(player, p_input)
			if parseInt(p_input) > 0 then
				p_input = parseInt(p_input)
				vRP.request(player, "Are you sure you want to stock "..p_input.." "..name, 30, function(hplayer,ok)
					if ok then
						if vRP.tryGetInventoryItem(user_id, idname, p_input, true) then
							--Log.write(user_id,"Put "..amount.." "..vRP.getItemName(idname).." in "..chestname,Log.log_type.action)
							cfg.stores[store_name].recipes[name].units = cfg.stores[store_name].recipes[name].units + p_input
							vRP.setShopTransformer("cfg:"..store_name,cfg.stores[store_name])
							-- actualize by closing
							vRP.openMenu(player,menu)
						end
					end
				end)
			else
				vRPclient.notify(player,{lang.common.invalid_value()})
			end
		end)
	end

	local cb_create_listing = function(idname)
		local name,description,weight = vRP.getItemDefinition(idname)
		local player = source
		vRP.prompt(player, "Item Price", "", function(player, p_input)
			if parseInt(p_input) > 0 then
				p_input = parseInt(p_input)
				vRP.request(player, "Are you sure you want to offer "..name.." for $"..p_input, 30, function(hplayer,ok)
					if ok then
						cfg.stores[store_name].recipes[name] = {
							description="Purchase "..name,
							units=0,
							in_money=p_input,
							out_money=0,
							reagents={},
							products={
								[idname] = 1
							}
						}
						vRP.setShopTransformer("cfg:"..store_name,cfg.stores[store_name])
					end
				end)
			else
				vRPclient.notify(player,{lang.common.invalid_value()})
			end
		end)
	end

	menu["Create Listing"] = {function(player,choice)
		local data = vRP.getUserDataTable(user_id)
		local submenu = build_itemlist_menu(lang.inventory.chest.put.title(), data.inventory, cb_create_listing)
		submenu.onclose = function()
			vRP.closeMenu(player)
		end
		vRP.openMenu(player, submenu)
	end, "List an item in your store"}

	menu["Add Inventory"] = {function(player,choice)
		local data = vRP.getUserDataTable(user_id)
		local submenu = build_itemlist_menu(lang.inventory.chest.put.title(), data.inventory, cb_add_inventory)
		submenu.onclose = function()
			vRP.closeMenu(player)
		end
		vRP.openMenu(player, submenu)
	end, "Add items to your store's inventory"}

	return menu
end

-- build homes entry points
local function build_client_shops(source)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		for k,v in pairs(cfg.stores) do
			local x,y,z = table.unpack(v.safe_pos)
			local x2,y2,z2 = table.unpack(v.shop_pos)

			local function entry_enter(player,area)
				local user_id = vRP.getUserId(player)
				if user_id ~= nil and vRP.hasPermissions(user_id,v.permissions or {}) then
					vRP.openMenu(source,build_entry_menu(user_id, k))
				end
			end

			local function entry_leave(player,area)
				vRP.closeMenu(player)
			end

			vRPclient.addBlip(source,{x2,y2,z2,v.blipid,v.blipcolor,k})
			vRPclient.addMarker(source,{x,y,z-0.97,0.7,0.7,0.5,0,255,125,125,150,23})

			vRP.setArea(source,"vRP:shop"..k,x,y,z,1,1.5,entry_enter,entry_leave)
		end
	end
end

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
	if first_spawn then -- first spawn, build homes
		build_client_shops(source)
	else -- death, leave shop if inside one
		-- leave slot if inside one
		local tmp = vRP.getUserTmpTable(user_id)
		if tmp and tmp.home_stype then
			leave_slot(user_id, source, tmp.home_stype, tmp.home_sid)
		end
	end
end)

AddEventHandler("vRP:playerLeave",function(user_id, player)
	-- leave slot if inside one
	local tmp = vRP.getUserTmpTable(user_id)
	if tmp and tmp.home_stype then
		leave_slot(user_id, player, tmp.home_stype, tmp.home_sid)
	end
end)
