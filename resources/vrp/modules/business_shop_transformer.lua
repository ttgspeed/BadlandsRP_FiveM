
-- this module define a generic system to transform (generate, process, convert) items and money to other items or money in a specific area
-- each transformer can take things to generate other things, using a unit of work
-- units are generated periodically at a specific rate
-- reagents => products (reagents can be nothing, as for an harvest transformer)

local cfg = module("cfg/business_shops")
local lang = vRP.lang

-- api

local transformers = {}

local function tr_remove_player(tr,player) -- remove player from transforming
	local recipe = tr.players[player] or ""
	tr.players[player] = nil -- dereference player
	vRPclient.removeProgressBar(player,{"vRP:tr:"..tr.name})
	vRP.closeMenu(player)
	vRPclient.setTransformerLock(player,{false})
	-- onstop
	if tr.itemtr.onstop then tr.itemtr.onstop(player,recipe) end
end

local function tr_add_player(tr,player,recipe) -- add player to transforming
	tr.players[player] = recipe -- reference player as using transformer
	vRP.closeMenu(player)
	vRPclient.setProgressBar(player,{"vRP:tr:"..tr.name,"center",recipe.."...",255,125,24,0})
	vRPclient.setTransformerLock(player,{true})
	-- onstart
	if tr.itemtr.onstart then tr.itemtr.onstart(player,recipe) end
end

local function tr_tick(tr) -- do transformer tick
	for k,v in pairs(tr.players) do
		local user_id = vRP.getUserId(tonumber(k))
		if v and user_id ~= nil then -- for each player transforming
			local recipe = tr.itemtr.recipes[v]

			--Progress bar showing shop inventory
			vRPclient.setProgressBarValue(k,{"vRP:tr:"..tr.name,100})
			if recipe.units > 0 then -- display units left
				vRPclient.setProgressBarText(k,{"vRP:tr:"..tr.name,v.."... "..recipe.units})
			else
				vRPclient.setProgressBarText(k,{"vRP:tr:"..tr.name,"Out of Stock"})
			end

			-- FIXME This needs to be optimized to not query the db every tick
			vRP.getPlayerBusiness(user_id,function(business_id)
				if recipe.units > 0 and recipe then -- check units
					-- check money
					local money_ok = (vRP.getMoney(user_id) >= recipe.in_money)
					local dirty_money_ok = (vRP.getInventoryItemAmount(user_id,"dirty_money") >= recipe.in_money)
					if business_id == tr.itemtr.business then
						dirty_money_ok = false
					end

					if not money_ok and not dirty_money_ok then
						vRPclient.notify(tonumber(k),{lang.money.not_enough()})
						tr_remove_player(tr,k)
					end

					-- weight check
					local out_witems = {}
					for k,v in pairs(recipe.products) do
						out_witems[k] = {amount=v}
					end
					local in_witems = {}
					local new_weight = vRP.getInventoryWeight(user_id)+vRP.computeItemsWeight(out_witems)-vRP.computeItemsWeight(in_witems)

					local inventory_ok = true
					if new_weight > vRP.getInventoryMaxWeight(user_id) then
						inventory_ok = false
						vRPclient.notify(tonumber(k), {lang.inventory.full()})
						tr_remove_player(tr,k)
					end

					if (dirty_money_ok or money_ok) and inventory_ok then -- do transformation
						recipe.units = recipe.units-1 -- sub work unit

						vRPclient.playAnim(k,{true,{{"missfbi_s4mop","plant_bomb_b",1}},false})

						if recipe.in_money > 0 then
							if dirty_money_ok then
								vRP.tryGetInventoryItem(user_id,"dirty_money",recipe.in_money,true)
							else
								vRP.tryPayment(user_id,recipe.in_money)
							end
							 tr.itemtr.safe_money = tr.itemtr.safe_money+recipe.in_money
						end

						-- produce products
						for l,w in pairs(recipe.products) do
							vRP.giveInventoryItem(user_id,l,w,true)
						end

						-- onstep
						if tr.itemtr.onstep then tr.itemtr.onstep(tonumber(k),v) end
					end
				end
			end)
		end
		if user_id == nil then
			tr_remove_player(tr,k)
		end
	end
end

local function bind_tr_area(player,tr) -- add tr area to client
	vRPclient.addMarker(player,{tr.itemtr.shop_pos[1],tr.itemtr.shop_pos[2],tr.itemtr.shop_pos[3]-0.97,0.7,0.7,0.5,0,255,125,125,150,23})
	vRP.setArea(player,"vRP:tr:"..tr.name,tr.itemtr.shop_pos[1],tr.itemtr.shop_pos[2],tr.itemtr.shop_pos[3],1,1.5,tr.enter,tr.leave)
end

local function unbind_tr_area(player,tr) -- remove tr area from client
	vRP.removeArea(player,"vRP:tr:"..tr.name)
end

-- add an item transformer
-- name: transformer id name
-- itemtr: item transformer definition table
--- name
--- max_units
--- units_per_minute
--- x,y,z,radius,height (area properties)
--- r,g,b (color)
--- action
--- description
--- in_money
--- products: items as idname => amount
function vRP.setShopTransformer(name,itemtr)
	print(name)
	print(json.encode(itemtr))
	vRP.removeShopTransformer(name) -- remove pre-existing transformer
	local tr = {itemtr=itemtr}
	tr.name = name
	transformers[name] = tr

	-- init transformer
	tr.players = {}

	-- build menu
	tr.menu = {name=itemtr.name,css={top="75px",header_color="rgba(255,125,24,0.75)"}}

	-- build recipes
	for action,recipe in pairs(tr.itemtr.recipes) do
		local info = "<br /><br />"
		if recipe.in_money > 0 then info = info.."$"..recipe.in_money end
		info = info.."<br /><span style=\"color: rgb(0,255,125)\">=></span>"
		for k,v in pairs(recipe.products) do
			local item = vRP.items[k]
			if item then
				info = info.."<br />"..v.." "..item.name
			end
		end
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

	-- build area
	tr.enter = function(player,area)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil and vRP.hasPermissions(user_id,itemtr.permissions or {}) then
			vRPclient.isPedInCar(player, {}, function(inVeh)
				if not inVeh then
					vRP.openMenu(player, tr.menu) -- open menu
				end
			end)
		end
	end

	tr.leave = function(player,area)
		tr_remove_player(tr, player)
	end

	-- bind tr area to all already spawned players
	for k,v in pairs(vRP.rusers) do
		local source = vRP.getUserSource(k)
		if source ~= nil then
			bind_tr_area(source,tr)
		end
	end
end

-- remove an item transformer
function vRP.removeShopTransformer(name)
	local tr = transformers[name]
	if tr then
		-- copy players (to remove while iterating)
		local players = {}
		for k,v in pairs(tr.players) do
			players[k] = v
		end

		for k,v in pairs(players) do -- remove players from transforming
			tr_remove_player(tr,k)
		end

		-- remove tr area from all already spawned players
		for k,v in pairs(vRP.rusers) do
			local source = vRP.getUserSource(k)
			if source ~= nil then
				unbind_tr_area(source,tr)
			end
		end

		transformers[name] = nil
	end
end

-- task: transformers ticks (every 3 seconds)
local function transformers_tick()
	SetTimeout(0,function() -- error death protection for transformers_tick()
		for k,tr in pairs(transformers) do
			tr_tick(tr)
		end
	end)

	SetTimeout(3000,transformers_tick)
end
transformers_tick()

-- add transformers areas on player first spawn
AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
	if first_spawn then
		for k,tr in pairs(transformers) do
			bind_tr_area(source,tr)
		end
	end
end)

-- STATIC TRANSFORMERS

SetTimeout(5000,function()
	-- delayed to wait items loading
	-- load item transformers from config file
	for k,v in pairs(cfg.stores) do
		vRP.setShopTransformer("cfg:"..k,v)
	end
end)
