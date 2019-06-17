
-- this module describe the home system (experimental, a lot can happen and not being handled)
local Log = module("lib/Log")
local lang = vRP.lang
--local cfg = module("cfg/homes")

-- api

local components = {}
local active_tents = {}

-- cbreturn user address (home and number) or nil
function vRP.getUserTent(user_id, cbr)
	local task = Task(cbr)
	MySQL.Async.fetchAll('SELECT data FROM vrp_user_tents WHERE user_id = @user_id', {user_id = user_id}, function(rows)
		task({rows[1]})
	end)
end

-- set user address
function vRP.addUserTent(user_id,data)
	last_accessed = os.time()
	MySQL.Async.execute('INSERT INTO vrp_user_tents(user_id,data,last_accessed) VALUES(@user_id,@data,@last_accessed)', {user_id = user_id, data = data, last_accessed = last_accessed}, function(rowsChanged) end)
end

-- set user address
function vRP.setUserTent(user_id,data)
	MySQL.Async.execute('REPLACE INTO vrp_user_tents(user_id,data,last_accessed) VALUES(@user_id,@data,@last_accessed)', {user_id = user_id, data = data, last_accessed = last_accessed}, function(rowsChanged) end)
end

-- remove user address
function vRP.removeUserTent(user_id)
	MySQL.Async.execute('DELETE FROM vrp_user_tents WHERE user_id = @user_id', {user_id = user_id}, function(rowsChanged) end)
end

-- -- cbreturn user_id or nil
-- function vRP.getUserByAddress(home,number,cbr)
-- 	local task = Task(cbr)
-- 	MySQL.Async.fetchAll('SELECT user_id FROM vrp_user_tents WHERE home = @home AND number = @number', {home = home, number = number}, function(rows)
-- 		if #rows > 0 then
-- 			task({rows[1].user_id})
-- 		else
-- 			task()
-- 		end
-- 	end)
-- end
--
-- -- define home component
-- -- name: unique component id
-- -- oncreate(owner_id, slot_type, slot_id, cid, config, x, y, z, player)
-- -- ondestroy(owner_id, slot_type, slot_id, cid, config, x, y, z, player)
-- function vRP.defHomeComponent(name, oncreate, ondestroy)
-- 	components[name] = {oncreate,ondestroy}
-- end
--
-- -- SLOTS
--
-- -- used (or not) slots
-- local uslots = {}
-- for k,v in pairs(cfg.slot_types) do
-- 	uslots[k] = {}
-- 	for l,w in pairs(v) do
-- 		uslots[k][l] = {used=false}
-- 	end
-- end
--
-- -- return slot id or nil if no slot available
-- local function allocateSlot(stype)
-- 	local slots = cfg.slot_types[stype]
-- 	if slots then
-- 		local _uslots = uslots[stype]
-- 		-- search the first unused slot
-- 		for k,v in pairs(slots) do
-- 			if _uslots[k] and not _uslots[k].used then
-- 				_uslots[k].used = true -- set as used
-- 				return k  -- return slot id
-- 			end
-- 		end
-- 	end
--
-- 	return nil
-- end
--
-- -- free a slot
-- local function freeSlot(stype, id)
-- 	local slots = cfg.slot_types[stype]
-- 	if slots then
-- 		uslots[stype][id] = {used = false} -- reset as unused
-- 	end
-- end
--
-- -- get in use address slot (not very optimized yet)
-- -- return slot_type, slot_id or nil,nil
-- local function getAddressSlot(home_name,number)
-- 	for k,v in pairs(uslots) do
-- 		for l,w in pairs(v) do
-- 			if w.home_name == home_name and tostring(w.home_number) == tostring(number) then
-- 				return k,l
-- 			end
-- 		end
-- 	end
--
-- 	return nil,nil
-- end
--
-- -- builds
--
-- local function is_empty(table)
-- 	for k,v in pairs(table) do
-- 		return false
-- 	end
--
-- 	return true
-- end
--
-- -- leave slot
-- local function leave_slot(user_id,player,stype,sid) -- called when a player leave a slot
-- 	print(user_id.." leave home slot "..stype.." "..sid)
-- 	if uslots[stype] == nil or uslots[stype][sid] == nil then
-- 		return
-- 	end
-- 	local slot = uslots[stype][sid]
-- 	local home = cfg.homes[slot.home_name]
--
-- 	-- record if inside a home slot
-- 	local tmp = vRP.getUserTmpTable(user_id)
-- 	if tmp then
-- 		tmp.home_stype = nil
-- 		tmp.home_sid = nil
-- 	end
--
-- 	-- teleport to home entry point (outside)
-- 	vRPclient.teleport(player, home.entry_point) -- already an array of params (x,y,z)
--
-- 	-- uncount player
-- 	slot.players[user_id] = nil
--
-- 	-- destroy loaded components and special entry component
-- 	for k,v in pairs(cfg.slot_types[stype][sid]) do
-- 		local name,x,y,z = table.unpack(v)
--
-- 		if name == "entry" then
-- 			-- remove marker/area
-- 			local nid = "vRP:home:slot"..stype..sid
-- 			vRPclient.removeNamedMarker(player,{nid})
-- 			vRP.removeArea(player,nid)
-- 		else
-- 			local component = components[v[1]]
-- 			if component then
-- 				-- ondestroy(owner_id, slot_type, slot_id, cid, config, x, y, z, player)
-- 				component[2](slot.owner_id, stype, sid, k, v._config or {}, x, y, z, player)
-- 			end
-- 		end
-- 	end
--
-- 	if is_empty(slot.players) then -- free the slot
-- 		print("free slot "..stype.." "..sid)
-- 		freeSlot(stype,sid)
-- 	end
-- end
--
-- -- enter slot
-- local function enter_slot(user_id,player,stype,sid) -- called when a player enter a slot
-- 	print(user_id.." enter slot "..stype.." "..sid)
-- 	local slot = uslots[stype][sid]
-- 	local home = cfg.homes[slot.home_name]
--
-- 	-- record inside a home slot
-- 	local tmp = vRP.getUserTmpTable(user_id)
-- 	if tmp then
-- 		tmp.home_stype = stype
-- 		tmp.home_sid = sid
-- 	end
--
-- 	-- count
-- 	slot.players[user_id] = player
--
-- 	-- build the slot entry menu
-- 	local menu = {name=slot.home_name,css={top="75px",header_color="rgba(0,255,125,0.75)"}}
-- 	menu[lang.home.slot.leave.title()] = {function(player,choice) -- add leave choice
-- 		leave_slot(user_id,player,stype,sid)
-- 	end}
--
-- 	vRP.getUserAddress(user_id, function(address)
-- 		-- check if owner
-- 		if address ~= nil and address.home == slot.home_name and tostring(address.number) == slot.home_number then
-- 			menu[lang.home.slot.ejectall.title()] = {function(player,choice) -- add eject all choice
-- 				-- copy players before calling leave for each (iteration while removing)
-- 				local copy = {}
-- 				for k,v in pairs(slot.players) do
-- 					copy[k] = v
-- 				end
--
-- 				for k,v in pairs(copy) do
-- 					leave_slot(k,v,stype,sid)
-- 				end
-- 			end,lang.home.slot.ejectall.description()}
-- 		end
--
-- 		-- build the slot entry menu marker/area
--
-- 		local function entry_enter(player,area)
-- 			vRP.openMenu(player,menu)
-- 		end
--
-- 		local function entry_leave(player,area)
-- 			vRP.closeMenu(player)
-- 		end
--
-- 		-- build components and special entry component
-- 		for k,v in pairs(cfg.slot_types[stype][sid]) do
-- 			local name,x,y,z = table.unpack(v)
--
-- 			if name == "entry" then
-- 				-- teleport to the slot entry point
-- 				vRPclient.teleport(player, {x,y,z}) -- already an array of params (x,y,z)
--
-- 				local nid = "vRP:home:slot"..stype..sid
-- 				vRPclient.setNamedMarker(player,{nid,x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})
-- 				vRP.setArea(player,nid,x,y,z,1,1.5,entry_enter,entry_leave)
-- 			else -- load regular component
-- 				local component = components[v[1]]
-- 				if component then
-- 					-- oncreate(owner_id, slot_type, slot_id, cid, config, x, y, z, player)
-- 					component[1](slot.owner_id, stype, sid, k, v._config or {}, x, y, z, player)
-- 				end
-- 			end
-- 		end
-- 	end)
-- end

tent_enter = function(player,area)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermissions(user_id,itemtr.permissions or {}) then
		-- build menu
		tr.menu = {name=itemtr.name,css={top="75px",header_color="rgba(255,125,24,0.75)"}}

		-- build recipes
		for action,recipe in pairs(tr.itemtr.recipes) do
			local info = "<br /><br />"
			if recipe.in_money > 0 then info = info.."$"..recipe.in_money.." each" end
			info = info.."<br /><span style=\"color: rgb(0,255,125)\">---</span>"
			info = info.."<br />"..recipe.units.." in stock"
			for k,v in pairs(recipe.aptitudes or {}) do
				local parts = splitString(k,".")
				if #parts == 2 then
					local def = vRP.getAptitudeDefinition(parts[1],parts[2])
					if def then
						info = info.."<br />[EXP] "..v.." "..vRP.getAptitudeGroupTitle(parts[1]).."/"..def[1]
					end
				end
			end

			tr.menu[action] = {function(player,choice) tr_add_player(tr,player,action) end, recipe.description..info}
		end

		if tablelength(tr.itemtr.recipes) == 0 then
			tr.menu["No stock"] = {function(player,choice) end, "This shop has nothing to sell."}
		end

		vRPclient.isPedInCar(player, {}, function(inVeh)
			if not inVeh then
				vRP.getPlayerBusiness(user_id,function(business_id)
					player_business_cache[user_id] = business_id
					vRP.openMenu(player, tr.menu) -- open menu
				end)
			end
		end)
	end

-- access a home by address
-- cbreturn true on success
function vRP.createTent(player)
	local user_id = vRP.getUserId(player)
	local player = player
	vRP.getUserTent(user_id, function(e_tent)
		if e_tent == nil then
			vRPclient.getForwardPosition(player,{},function(x,y,z)
				if z > 0 then
					if vRP.tryGetInventoryItem(user_id,"tent",1,false) then
						local tent = {
							["pos"] = {x,y,z},
							["inventory"] = {}
						}
						active_tents[user_id] = tent
						vRP.addUserTent(user_id,json.encode(tent))
						vRPclient.addTent(-1,{user_id,tent.pos})
						vRP.setArea(player,"vRP:tent:"..user_id,x,y,z,5,5,tent_enter,tent_leave)
					end
				else
					vRPclient.notify(player,{"Unable to place tent here. Please try again."})
				end
			end)
		else
			vRPclient.notify(player,{"You already have a tent"})
		end
	end)
end

-- -- build the home entry menu
-- local function build_entry_menu(user_id, home_name)
-- 	local home = cfg.homes[home_name]
-- 	local menu = {name=home_name,css={top="75px",header_color="rgba(0,255,125,0.75)"}}
--
-- 	-- intercom, used to enter in a home
-- 	menu[lang.home.intercom.title()] = {function(player,choice)
-- 		vRP.prompt(player, lang.home.intercom.prompt(), "", function(player,number)
-- 			number = parseInt(number)
-- 			vRP.getUserByAddress(home_name,number,function(huser_id)
-- 				vRP.getUserSpouse(huser_id,function(suser_id)
-- 					if huser_id ~= nil then
-- 						if huser_id == user_id or user_id == suser_id then -- identify owner (direct home access)
-- 							vRP.accessHome(user_id, home_name, number, function(ok)
-- 								if not ok then
-- 									vRPclient.notify(player,{lang.home.intercom.not_available()})
-- 								end
-- 							end)
-- 						else -- try to access home by asking owner
-- 							local hplayer = vRP.getUserSource(huser_id)
-- 							local splayer = vRP.getUserSource(suser_id)
-- 							if hplayer ~= nil or splayer ~= nil then
-- 								if hplayer == nil then
-- 									hplayer = splayer
-- 								end
-- 								vRP.prompt(player,lang.home.intercom.prompt_who(),"",function(player,who)
-- 									vRPclient.notify(player,{lang.home.intercom.asked()})
-- 									-- request owner to open the door
-- 									vRP.request(hplayer, lang.home.intercom.request({who}), 30, function(hplayer,ok)
-- 										if ok then
-- 											vRP.accessHome(user_id, home_name, number)
-- 										else
-- 											vRPclient.notify(player,{lang.home.intercom.refused()})
-- 										end
-- 									end)
-- 								end)
-- 							else
-- 								vRPclient.notify(player,{lang.home.intercom.refused()})
-- 							end
-- 						end
-- 					else
-- 						vRPclient.notify(player,{lang.common.not_found()})
-- 					end
-- 				end)
-- 			end)
-- 		end)
-- 	end,lang.home.intercom.description()}
--
-- 	menu[lang.home.buy.title()] = {function(player,choice)
-- 		vRP.getUserAddress(user_id, function(address)
-- 			if address == nil then -- check if not already have a home
-- 				vRP.request(player, "Buy Property", 15, function(player,ok)
-- 					if ok then
-- 						vRPclient.notify(player, {"The Realtor is looking for an available apartment. This can take some time."})
-- 						vRP.findFreeNumber(home_name, home.max, function(number)
-- 							if number ~= nil then
-- 								if vRP.tryDebitedPayment(user_id, home.buy_price) then
-- 									-- bought, set address
-- 									vRP.setUserAddress(user_id, home_name, number)
--
-- 									vRPclient.notify(player,{lang.home.buy.bought()})
-- 								else
-- 									vRPclient.notify(player,{lang.money.not_enough()})
-- 								end
-- 							else
-- 								vRPclient.notify(player,{lang.home.buy.full()})
-- 							end
-- 						end)
-- 					end
-- 				end)
-- 			else
-- 				vRPclient.notify(player,{lang.home.buy.have_home()})
-- 			end
-- 		end)
-- 	end, lang.home.buy.description({home.buy_price})}
--
-- 	menu[lang.home.sell.title()] = {function(player,choice)
-- 		vRP.getUserAddress(user_id, function(address)
-- 			if address ~= nil and address.home == home_name then -- check if already have a home
-- 				vRP.request(player, "Sell Property", 15, function(player,ok)
-- 					if ok then
-- 						-- sold, give sell price, remove address
-- 						vRP.giveMoney(user_id, home.sell_price)
-- 						vRP.removeUserAddress(user_id)
-- 						vRPclient.notify(player,{lang.home.sell.sold()})
-- 					end
-- 				end)
-- 			else
-- 				vRPclient.notify(player,{lang.home.sell.no_home()})
-- 			end
-- 		end)
-- 	end, lang.home.sell.description({home.sell_price})}
--
-- 	return menu
-- end
--
-- -- build homes entry points
-- local function build_client_homes(source)
-- 	local user_id = vRP.getUserId(source)
-- 	if user_id ~= nil then
-- 		for k,v in pairs(cfg.homes) do
-- 			local x,y,z = table.unpack(v.entry_point)
--
-- 			local function entry_enter(player,area)
-- 				local user_id = vRP.getUserId(player)
-- 				if user_id ~= nil and vRP.hasPermissions(user_id,v.permissions or {}) then
-- 					vRP.openMenu(source,build_entry_menu(user_id, k))
-- 				end
-- 			end
--
-- 			local function entry_leave(player,area)
-- 				vRP.closeMenu(player)
-- 			end
--
-- 			vRPclient.addBlip(source,{x,y,z,v.blipid,v.blipcolor,k})
-- 			vRPclient.addMarker(source,{x,y,z-0.97,0.7,0.7,0.5,0,255,125,125,150,23})
--
-- 			vRP.setArea(source,"vRP:home"..k,x,y,z,1,1.5,entry_enter,entry_leave)
-- 		end
-- 	end
-- end
--
AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
	if first_spawn then -- first spawn, build homes
		vRP.getUserTent(user_id, function(e_tent)
			if e_tent ~= nil then
				local e_tent = json.decode(e_tent.data)
				vRPclient.addTent(-1,{user_id,e_tent.pos})
				for k,v in pairs(active_tents) do
					if v ~= nil then
						vRPclient.addTent(player,{user_id,v.pos})
					end
				end
				--add to active tents after loop so it doesn't get added to the connecting client twice (even though client code can handle it)
				active_tents[user_id] = e_tent
			end
		end)
	end
end)

AddEventHandler("vRP:playerLeave",function(user_id, player)
	-- leave slot if inside one
	-- if active_tents[user_id] ~= nil then
	-- 	active_tents[user_id] = nil
	-- 	vRPclient.removeTent(-1,{user_id})
	-- end
end)
