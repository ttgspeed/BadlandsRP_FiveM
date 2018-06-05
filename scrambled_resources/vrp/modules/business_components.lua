
-- define some basic home components
local lang = vRP.lang
local sanitizes = module("cfg/sanitizes")
local cfg = module("cfg/business")
-- CHEST

local function chest_create(owner_id, stype, sid, cid, config, x, y, z, player)
	local chest_enter = function(player,area)
		local user_id = vRP.getUserId(player)
		vRP.getUserSpouse(user_id,function(suser_id)
			if user_id ~= nil and (user_id == owner_id or suser_id == owner_id) then
				vRP.openChest(player, "u"..owner_id.."business", config.weight or 200,nil,nil,nil)
			end
		end)
	end


	local chest_leave = function(player,area)
		vRP.closeMenu(player)
	end

	local nid = "vRP:business:slot"..stype..sid..":chest"
	vRPclient.setNamedMarker(player,{nid,x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})
	vRP.setArea(player,nid,x,y,z,1,1.5,chest_enter,chest_leave)
end

local function chest_destroy(owner_id, stype, sid, cid, config, x, y, z, player)
	local nid = "vRP:business:slot"..stype..sid..":chest"
	vRPclient.removeNamedMarker(player,{nid})
	vRP.removeArea(player,nid)
end

vRP.defOfficeComponent("chest", chest_create, chest_destroy)

-- WARDROBE

local function wardrobe_create(owner_id, stype, sid, cid, config, x, y, z, player)
	local wardrobe_enter = nil
	wardrobe_enter = function(player,area)
		local user_id = vRP.getUserId(player)
		vRP.getUserSpouse(user_id,function(suser_id)
			if user_id ~= nil and (user_id == owner_id or suser_id == owner_id) then
				-- notify player if wearing a uniform
				local data = vRP.getUserDataTable(user_id)
				if data.cloakroom_idle ~= nil then
					vRPclient.notify(player,{lang.common.wearing_uniform()})
				end

				-- build menu
				local menu = {name=lang.business.wardrobe.title(),css={top = "75px", header_color="rgba(0,255,125,0.75)"}}

				-- load sets
				vRP.getUData(user_id, "vRP:home:wardrobe", function(data)
					local sets = json.decode(data)
					if sets == nil then
						sets = {}
					end

					-- save
					menu[lang.business.wardrobe.save.title()] = {function(player, choice)
						vRP.prompt(player, lang.business.wardrobe.save.prompt(), "", function(player, setname)
							setname = sanitizeString(setname, sanitizes.text[1], sanitizes.text[2])
							if string.len(setname) > 0 then
								-- save custom
								vRPclient.getCustomization(player,{},function(custom)
									sets[setname] = custom
									-- save to db
									vRP.setUData(user_id,"vRP:home:wardrobe",json.encode(sets))

									-- actualize menu
									wardrobe_enter(player, area)
								end)
							else
								vRPclient.notify(player,{lang.common.invalid_value()})
							end
						end)
					end}

					local choose_set = function(player,choice)
						local custom = sets[choice]
						if custom ~= nil then
							vRPclient.setCustomization(player,{custom,true})
							TriggerEvent('c7136b53-2019-4350-8c6b-3dbbab4d4e52', player)
						end
					end

					-- sets
					for k,v in pairs(sets) do
						menu[k] = {choose_set}
					end

					-- open the menu
					vRP.openMenu(player,menu)
				end)
			end
		end)
	end

	local wardrobe_leave = function(player,area)
		vRP.closeMenu(player)
	end

	local nid = "vRP:home:slot"..stype..sid..":wardrobe"
	vRPclient.setNamedMarker(player,{nid,x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})
	vRP.setArea(player,nid,x,y,z,1,1.5,wardrobe_enter,wardrobe_leave)
end

local function wardrobe_destroy(owner_id, stype, sid, cid, config, x, y, z, player)
	local nid = "vRP:home:slot"..stype..sid..":wardrobe"
	vRPclient.removeNamedMarker(player,{nid})
	vRP.removeArea(player,nid)
end

vRP.defOfficeComponent("wardrobe", wardrobe_create, wardrobe_destroy)

-- GAMETABLE

local function gametable_create(owner_id, stype, sid, cid, config, x, y, z, player)
	local gametable_enter = function(player,area)
		local user_id = vRP.getUserId(player)
		--if user_id ~= nil and user_id == owner_id then
		-- build menu
		local menu = {name=lang.business.gametable.title(),css={top = "75px", header_color="rgba(0,255,125,0.75)"}}

		-- launch bet
		menu[lang.business.gametable.bet.title()] = {function(player, choice)
			vRP.prompt(player, lang.business.gametable.bet.prompt(), "", function(player, amount)
				amount = parseInt(amount)
				if amount > 0 then
					if vRP.tryPayment(user_id,amount) then
						vRPclient.notify(player,{lang.business.gametable.bet.started()})
						-- init bet total and players (add by default the bet launcher)
						local bet_total = amount
						local bet_players = {}
						local bet_opened = true
						table.insert(bet_players, player)

						local close_bet = function()
							if bet_opened then
								bet_opened = false
								-- select winner
								local wplayer = bet_players[math.random(1,#bet_players)]
								local wuser_id = vRP.getUserId(wplayer)
								if wuser_id ~= nil then
									vRP.giveMoney(wuser_id, bet_total)
									vRPclient.notify(wplayer,{lang.money.received({bet_total})})
									vRPclient.playAnim(wplayer,{true,{{"mp_player_introck","mp_player_int_rock",1}},false})
								end
							end
						end

						-- send bet request to all nearest players
						vRPclient.getNearestPlayers(player,{7},function(players)
							local pcount = 0
							for k,v in pairs(players) do
								pcount = pcount+1
								local nplayer = parseInt(k)
								local nuser_id = vRP.getUserId(nplayer)
								if nuser_id ~= nil then -- request
									vRP.request(nplayer,lang.business.gametable.bet.request({amount}), 30, function(nplayer, ok)
										if ok and bet_opened then
											if vRP.tryPayment(nuser_id,amount) then -- register player bet
												bet_total = bet_total+amount
												table.insert(bet_players, nplayer)
												vRPclient.notify(nplayer,{lang.money.paid({amount})})
											else
												vRPclient.notify(nplayer,{lang.money.not_enough()})
											end
										end

										pcount = pcount-1
										if pcount == 0 then -- autoclose bet, everyone is ok
											close_bet()
										end
									end)
								end
							end

							-- bet timeout
							SetTimeout(32000, close_bet)
						end)
					else
						vRPclient.notify(player,{lang.money.not_enough()})
					end
				else
					vRPclient.notify(player,{lang.common.invalid_value()})
				end
			end)
		end,lang.business.gametable.bet.description()}

		-- open the menu
		vRP.openMenu(player,menu)
		--end
	end

	local gametable_leave = function(player,area)
		vRP.closeMenu(player)
	end

	local nid = "vRP:home:slot"..stype..sid..":gametable"
	vRPclient.setNamedMarker(player,{nid,x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})
	vRP.setArea(player,nid,x,y,z,1,1.5,gametable_enter,gametable_leave)
end

local function gametable_destroy(owner_id, stype, sid, cid, config, x, y, z, player)
	local nid = "vRP:home:slot"..stype..sid..":gametable"
	vRPclient.removeNamedMarker(player,{nid})
	vRP.removeArea(player,nid)
end

vRP.defOfficeComponent("gametable", gametable_create, gametable_destroy)

-- ITEM TRANSFORMERS

-- item transformers are global to all players, so we need a counter to know when to create/destroy them
local itemtrs = {}

local function itemtr_create(owner_id, stype, sid, cid, config, x, y, z, player)
	local nid = "home:slot"..stype..sid..":itemtr"..cid
	if itemtrs[nid] == nil then
		itemtrs[nid] = 1

		-- simple copy
		local itemtr = {}
		for k,v in pairs(config) do
			itemtr[k] = v
		end

		itemtr.x = x
		itemtr.y = y
		itemtr.z = z

		vRP.setItemTransformer(nid, itemtr)
	else
		itemtrs[nid] = itemtrs[nid]+1
	end
end

local function itemtr_destroy(owner_id, stype, sid, cid, config, x, y, z, player)
	local nid = "home:slot"..stype..sid..":itemtr"..cid
	if itemtrs[nid] ~= nil then
		itemtrs[nid] = itemtrs[nid]-1
		if itemtrs[nid] == 0 then
			itemtrs[nid] = nil
			vRP.removeItemTransformer(nid)
		end
	end
end

vRP.defOfficeComponent("itemtr", itemtr_create, itemtr_destroy)

local function business_log_menu(player,owner_id)
	local player = player
	local user_id = vRP.getUserId(player)
	vRP.getBusinessLogs(owner_id, function(logs)
		local menu = {name="Transaction Logs",css={top = "75px", header_color="rgba(0,255,125,0.75)"}}
		--log list
		local list_index = 0
		for k,v in pairs(logs) do
			menu[os.date('%Y-%m-%d %H:%M:%S', v.time)] = {function(player, choice)
			end,v.action,list_index}
			list_index = list_index + 1
		end
		vRP.openMenu(player,menu)
	end)
end

local function business_finance_menu(player,owner_id)
	local user_id = vRP.getUserId(player)
	local menu = {name=lang.business.management.title(),css={top = "75px", header_color="rgba(0,255,125,0.75)"}}
	vRP.getBusinessFinances(owner_id, function(finances)
		vRP.getBusinessLogs(owner_id, function(logs)
			local balance_info = "Capital: $"..finances.capital
			menu["Balances"] = {function(player, choice)
			end,balance_info,1}

			menu["Deposit"] = {function(player, choice)
				vRP.prompt(player, lang.business.management.hire.hireprompt(), "", function(player, p_input)
					p_input = parseInt(sanitizeString(p_input, sanitizes.text[1], sanitizes.text[2]))
					if p_input > 0 then
						if vRP.tryFullPayment(user_id,p_input) then
							vRPclient.notify(player,{"Deposited "..p_input.." into your business account."})
							vRP.depositBusiness(owner_id,p_input,function(balance) end)
						else
							vRPclient.notify(player,{"You can not deposit that much money."})
						end
					else
						vRPclient.notify(player,{lang.common.invalid_value()})
					end
				end)
			end,"Deposit money into your business account",2}

			menu["Withdraw"] = {function(player, choice)
				vRP.prompt(player, lang.business.management.hire.hireprompt(), "", function(player, p_input)
					p_input = parseInt(sanitizeString(p_input, sanitizes.text[1], sanitizes.text[2]))
					if p_input > 0 then
						vRP.withdrawBusiness(owner_id,p_input,function(rowsChanged)
							if rowsChanged > 0 then
								vRPclient.notify(player,{"Withdrew "..p_input.." from your business account."})
								vRP.giveMoney(user_id, p_input)
							else
								vRPclient.notify(player,{"Could not withdraw that much money."})
							end
						end)
					else
						vRPclient.notify(player,{lang.common.invalid_value()})
					end
				end)
			end,"Withdraw money from your business account",3}

			menu["Transaction Log"] = {function(player, choice)
				business_log_menu(player,owner_id)
			end,"Browse the transaction logs for your business.",4}

			vRP.openMenu(player,menu)
		end)
	end)
end

local function business_pc_create(owner_id, stype, sid, cid, config, x, y, z, player)
	local wardrobe_enter = nil
	wardrobe_enter = function(player,area)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil and (user_id == owner_id) then
			-- build menu
			local menu = {name=lang.business.management.title(),css={top = "75px", header_color="rgba(0,255,125,0.75)"}}

			vRP.getBusinessEmployees(owner_id, function(employees)
				-- hire
				menu[lang.business.management.hire.title()] = {function(player, choice)
					vRP.prompt(player, lang.business.management.hire.hireprompt(), "", function(player, p_input)
						p_input = sanitizeString(p_input, sanitizes.text[1], sanitizes.text[2])
						if parseInt(p_input) > 0 then
							local hplayer = vRP.getUserSource(p_input)
							print("hiring "..p_input)
							vRP.request(hplayer, lang.business.management.hire.prompt({owner_id}), 30, function(hplayer,ok)
								if ok then
									vRP.setPlayerBusiness(p_input,owner_id)
								else
									vRPclient.notify(player,{lang.business.intercom.refused()})
								end
							end)
						else
							vRPclient.notify(player,{lang.common.invalid_value()})
						end
					end)
				end,"Hire an employee",1}

				-- fire
				menu[lang.business.management.fire.title()] = {function(player, choice)
					vRP.prompt(player, lang.business.management.fire.fireprompt(), "", function(player, p_input)
						p_input = sanitizeString(p_input, sanitizes.text[1], sanitizes.text[2])
						if parseInt(p_input) > 0 then
							vRP.request(player, lang.business.management.fire.prompt({p_input}), 30, function(hplayer,ok)
								if ok then
									print("firing "..p_input)
									vRP.setPlayerBusiness(p_input,0)
								else
									vRPclient.notify(player,{lang.business.intercom.refused()})
								end
							end)
						else
							vRPclient.notify(player,{lang.common.invalid_value()})
						end
					end)
				end,"Fire an employee",2}

				--employee list
				local employee_list = ""
				for k,v in pairs(employees) do
					employee_list = employee_list.."<em>Employee: </em>"..v.user_id.."<br />"
				end
				employee_list = lang.business.management.list.info({employee_list})
				menu[lang.business.management.list.title()] = {nil,employee_list,3}

				--company finances
				-- hire
				menu["Finances"] = {function(player, choice)
					business_finance_menu(player,owner_id)
				end,"Check your financial sheets",1}

				-- open the menu
				vRP.openMenu(player,menu)
			end)
		end
	end

	local wardrobe_leave = function(player,area)
		vRP.closeMenu(player)
	end

	local nid = "vRP:home:slot"..stype..sid..":business_pc"
	vRPclient.setNamedMarker(player,{nid,x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})
	vRP.setArea(player,nid,x,y,z,1,1.5,wardrobe_enter,wardrobe_leave)
end

local function business_pc_destroy(owner_id, stype, sid, cid, config, x, y, z, player)
	local nid = "vRP:home:slot"..stype..sid..":business_pc"
	vRPclient.removeNamedMarker(player,{nid})
	vRP.removeArea(player,nid)
end

vRP.defOfficeComponent("business_pc", business_pc_create, business_pc_destroy)


--business inventory management

local function deliver_illegal_goods(player, item, item_info, owner_id)
	local dz = cfg.dropzones[math.random(0,#cfg.dropzones)]
	local user_id = vRP.getUserId(player)
	local items = {
		[item_info.item_hash] = {["amount"] = item_info.amount}
	}
	--tvRP.create_temp_chest(user_id, dz.coords[1], dz.coords[2], dz.coords[3], items, 600000)
	vRPclient.dropItemsAtCoords(player,{items,600000,dz.coords})
	vRPclient.setGPS(player,{dz.coords[1],dz.coords[2]})
	vRPclient.notify(player,{"Your purchase of "..item.." has been dropped near "..dz.title})
end

local function deliver_legal_goods(player, item, item_info, owner_id)
	local player = player
	local chestname = "u"..owner_id.."business"
	vRP.remotePutChest(player, chestname, 250, function(idname,amount,success)
		if success then
			vRPclient.notify(player,{"Delivered "..item.." to your business chest."})
		else
			vRPclient.notify(player,{"Your business chest is too full"})
			vRP.depositBusiness(owner_id,item_info.price,function(balance) end)
		end
	end, item_info.item_hash, 100)
end

local function inventory_mgr_create(owner_id, stype, sid, cid, config, x, y, z, player)
	local wardrobe_enter = nil
	wardrobe_enter = function(player,area)
		local user_id = vRP.getUserId(player)
		local player = player
		if user_id ~= nil and (user_id == owner_id) then
			-- build menu
			local menu = {name=lang.business.management.title(),css={top = "75px", header_color="rgba(0,255,125,0.75)"}}

			vRP.getBusinessEmployees(owner_id, function(employees)
				for k,v in pairs(cfg.itempacks) do
					menu[k] = {function(player, choice)
						vRP.request(player, "Buy "..k.." for $"..v.price.."?", 15, function(player,ok)
							if ok then
								vRP.withdrawBusiness(owner_id,v.price,function(rowsChanged)
									if rowsChanged > 0 then
										if v.illegal then
											deliver_illegal_goods(player, k, v, owner_id)
										else
											deliver_legal_goods(player, k, v, owner_id)
										end
										vRP.logBusinessAction(owner_id,user_id,user_id.." purchased "..v.amount.." "..k.." for $"..v.price)
									else
										vRPclient.notify(player,{"Could not complete your order"})
									end
								end)
							end
						end)
						print(json.encode(v))
					end,v.description,1}
				end

				-- open the menu
				vRP.openMenu(player,menu)
			end)
		end
	end

	local wardrobe_leave = function(player,area)
		vRP.closeMenu(player)
	end

	local nid = "vRP:home:slot"..stype..sid..":inventory_mgr"
	vRPclient.setNamedMarker(player,{nid,x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})
	vRP.setArea(player,nid,x,y,z,1,1.5,wardrobe_enter,wardrobe_leave)
end

local function inventory_mgr_destroy(owner_id, stype, sid, cid, config, x, y, z, player)
	local nid = "vRP:home:slot"..stype..sid..":inventory_mgr"
	vRPclient.removeNamedMarker(player,{nid})
	vRP.removeArea(player,nid)
end

vRP.defOfficeComponent("inventory_mgr", inventory_mgr_create, inventory_mgr_destroy)
