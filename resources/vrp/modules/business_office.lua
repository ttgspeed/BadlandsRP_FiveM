
-- this module describe the home system (experimental, a lot can happen and not being handled)

local lang = vRP.lang
local Log = module("lib/Log")
local cfg = module("cfg/business_offices")

-- api

local components = {}

-- cbreturn user address (home and number) or nil
function vRP.getUserOffice(user_id, cbr)
	local task = Task(cbr)
	MySQL.Async.fetchAll('SELECT user_id FROM vrp_user_business WHERE user_id = @user_id', {user_id = user_id}, function(rows)
		task({rows[1]})
	end)
end

-- set user address
function vRP.setUserOffice(user_id)
	local name = user_id.." business"
	MySQL.Async.execute('REPLACE INTO vrp_user_business(user_id,name,description,capital,laundered,reset_timestamp) VALUES(@user_id,@name,"",0,0,0)', {user_id = user_id, name = name}, function(rowsChanged) end)
end

-- remove user address
function vRP.removeUserOffice(user_id)
	MySQL.Async.execute('DELETE FROM vrp_user_business WHERE user_id = @user_id', {user_id = user_id}, function(rowsChanged) end)
	MySQL.Async.execute('UPDATE vrp_user_identities SET business = 0 WHERE business = @user_id', {user_id = user_id}, function(rowsChanged) end)
end

-- cbreturn user_id or nil
function vRP.getUserByOffice(home,number,cbr)
	local task = Task(cbr)
	MySQL.Async.fetchAll('SELECT user_id FROM vrp_user_business WHERE user_id = @number', {number = number}, function(rows)
		if #rows > 0 then
			task({rows[1].user_id})
		else
			task()
		end
	end)
end

-- find a free address number to buy
-- cbreturn number or nil if no numbers availables
function vRP.findFreeNumber2(home,max,cbr)
	local task = Task(cbr)

	local i = 1
	local function search()
		vRP.getUserByOffice(home,i,function(user_id)
			if user_id == nil then -- found
				task({i})
			else -- not found
				i = i+1
				if i <= max then -- continue search
					search()
				else -- global not found
					task()
				end
			end
		end)
	end

	search()
end

-- define home component
-- name: unique component id
-- oncreate(owner_id, slot_type, slot_id, cid, config, x, y, z, player)
-- ondestroy(owner_id, slot_type, slot_id, cid, config, x, y, z, player)
function vRP.defOfficeComponent(name, oncreate, ondestroy)
	components[name] = {oncreate,ondestroy}
end

-- SLOTS

-- used (or not) slots
local uslots = {}
for k,v in pairs(cfg.slot_types) do
	uslots[k] = {}
	for l,w in pairs(v) do
		uslots[k][l] = {used=false}
	end
end

-- return slot id or nil if no slot available
local function allocateSlot(stype)
	local slots = cfg.slot_types[stype]
	if slots then
		local _uslots = uslots[stype]
		-- search the first unused slot
		for k,v in pairs(slots) do
			if _uslots[k] and not _uslots[k].used then
				_uslots[k].used = true -- set as used
				return k  -- return slot id
			end
		end
	end

	return nil
end

-- free a slot
local function freeSlot(stype, id)
	local slots = cfg.slot_types[stype]
	if slots then
		uslots[stype][id] = {used = false} -- reset as unused
	end
end

-- get in use address slot (not very optimized yet)
-- return slot_type, slot_id or nil,nil
local function getAddressSlot(home_name,number)
	for k,v in pairs(uslots) do
		for l,w in pairs(v) do
			if w.home_name == home_name and tostring(w.home_number) == tostring(number) then
				return k,l
			end
		end
	end

	return nil,nil
end

-- builds

local function is_empty(table)
	for k,v in pairs(table) do
		return false
	end

	return true
end

-- leave slot
local function leave_slot(user_id,player,stype,sid) -- called when a player leave a slot
	print(user_id.." leave business slot "..stype.." "..sid)
	if uslots[stype] == nil or uslots[stype][sid] == nil then
		return
	end
	local slot = uslots[stype][sid]
	local home = cfg.homes[slot.home_name]

	-- record if inside a home slot
	local tmp = vRP.getUserTmpTable(user_id)
	if tmp then
		tmp.home_stype = nil
		tmp.home_sid = nil
	end

	-- teleport to home entry point (outside)
	vRPclient.teleport(player, home.entry_point) -- already an array of params (x,y,z)

	-- uncount player
	slot.players[user_id] = nil

	-- destroy loaded components and special entry component
	for k,v in pairs(cfg.slot_types[stype][sid]) do
		local name,x,y,z = table.unpack(v)

		if name == "entry" then
			-- remove marker/area
			local nid = "vRP:home:slot"..stype..sid
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
	local home = cfg.homes[slot.home_name]

	-- record inside a home slot
	local tmp = vRP.getUserTmpTable(user_id)
	if tmp then
		tmp.home_stype = stype
		tmp.home_sid = sid
	end

	-- count
	slot.players[user_id] = player

	-- build the slot entry menu
	local menu = {name=slot.home_name,css={top="75px",header_color="rgba(0,255,125,0.75)"}}
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

				local nid = "vRP:home:slot"..stype..sid
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

-- access a home by address
-- cbreturn true on success
function vRP.accessOffice(user_id, home, number, cbr)
	local task = Task(cbr)

	local _home = cfg.homes[home]
	local stype,slotid = getAddressSlot(home,number) -- get current address slot
	local player = vRP.getUserSource(user_id)

	vRP.getUserByOffice(home,number, function(owner_id)
		if _home ~= nil and player ~= nil then
			if stype == nil then -- allocate a new slot
				stype = _home.slot
				slotid = allocateSlot(_home.slot)

				if slotid ~= nil then -- allocated, set slot home infos
					local slot = uslots[stype][slotid]
					slot.home_name = home
					slot.home_number = number
					slot.owner_id = owner_id
					slot.players = {} -- map user_id => player
				end
			end

			if slotid ~= nil then -- slot available
				enter_slot(user_id,player,stype,slotid)
				task({true})
			end
		end
	end)
end

-- build the home entry menu
local function build_entry_menu(user_id, home_name)
	local home = cfg.homes[home_name]
	local menu = {name=home_name,css={top="75px",header_color="rgba(0,255,125,0.75)"}}

	-- intercom, used to enter in a home
	menu[lang.business.intercom.title()] = {function(player,choice)
		vRP.prompt(player, lang.business.intercom.prompt(), "", function(player,number)
			number = parseInt(number)
			vRP.getUserByOffice(home_name,number,function(huser_id)
				vRP.getPlayerBusiness(user_id,function(suser_id)
					if huser_id ~= nil then
						if huser_id == user_id or huser_id == suser_id then -- identify owner (direct home access)
							vRP.accessOffice(user_id, home_name, number, function(ok)
								if not ok then
									vRPclient.notify(player,{lang.business.intercom.not_available()})
								end
							end)
						else -- try to access home by asking owner
							local hplayer = vRP.getUserSource(huser_id)
							local splayer = vRP.getUserSource(suser_id)
							if hplayer ~= nil or splayer ~= nil then
								if hplayer == nil then
									hplayer = splayer
								end
								vRP.prompt(player,lang.business.intercom.prompt_who(),"",function(player,who)
									vRPclient.notify(player,{lang.business.intercom.asked()})
									-- request owner to open the door
									vRP.request(hplayer, lang.business.intercom.request({who}), 30, function(hplayer,ok)
										if ok then
											vRP.accessOffice(user_id, home_name, number, function(ok) end)
										else
											vRPclient.notify(player,{lang.business.intercom.refused()})
										end
									end)
								end)
							else
								vRPclient.notify(player,{lang.business.intercom.refused()})
							end
						end
					else
						vRPclient.notify(player,{lang.common.not_found()})
					end
				end)
			end)
		end)
	end,lang.business.intercom.description()}

	menu[lang.business.buy.title()] = {function(player,choice)
		vRP.getUserOffice(user_id, function(address)
			if address == nil then -- check if not already have a home
				vRP.request(player, "Buy Property", 15, function(player,ok)
					if ok then
						vRP.findFreeNumber(home_name, home.max, function(number)
							if number ~= nil then
								if vRP.tryDebitedPayment(user_id, home.buy_price) then
									-- bought, set address
									Log.write(user_id, "Purchased a business for $"..home.buy_price,Log.log_type.business)
									vRP.setUserOffice(user_id, home_name, number)
									vRP.setPlayerBusiness(user_id,user_id)
									vRPclient.notify(player,{lang.business.buy.bought()})
								else
									vRPclient.notify(player,{lang.money.not_enough()})
								end
							else
								vRPclient.notify(player,{lang.business.buy.full()})
							end
						end)
					end
				end)
			else
				vRPclient.notify(player,{lang.business.buy.have_home()})
			end
		end)
	end, lang.business.buy.description({home.buy_price})}

	menu[lang.business.sell.title()] = {function(player,choice)
		vRP.getUserOffice(user_id, function(address)
			if address ~= nil then -- check if already have a home
				vRP.request(player, "Sell Property", 15, function(player,ok)
					if ok then
						-- sold, give sell price, remove address
						Log.write(user_id, "Sold a business for $"..home.sell_price,Log.log_type.business)
						vRP.giveMoney(user_id, home.sell_price)
						vRP.removeUserOffice(user_id)
						vRPclient.notify(player,{lang.business.sell.sold()})
					end
				end)
			else
				vRPclient.notify(player,{lang.business.sell.no_home()})
			end
		end)
	end, lang.business.sell.description({home.sell_price})}

	return menu
end

-- build homes entry points
local function build_client_homes(source)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		for k,v in pairs(cfg.homes) do
			local x,y,z = table.unpack(v.entry_point)

			local function entry_enter(player,area)
				local user_id = vRP.getUserId(player)
				if user_id ~= nil and vRP.hasPermissions(user_id,v.permissions or {}) then
					vRP.openMenu(source,build_entry_menu(user_id, k))
				end
			end

			local function entry_leave(player,area)
				vRP.closeMenu(player)
			end

			vRPclient.addBlip(source,{x,y,z,v.blipid,v.blipcolor,k})
			vRPclient.addMarker(source,{x,y,z-0.97,0.7,0.7,0.5,0,255,125,125,150,23})

			vRP.setArea(source,"vRP:home"..k,x,y,z,1,1.5,entry_enter,entry_leave)
		end
	end
end

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
	if first_spawn then -- first spawn, build homes
		build_client_homes(source)
	else -- death, leave home if inside one
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
