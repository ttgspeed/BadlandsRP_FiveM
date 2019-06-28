
-- this module describe the home system (experimental, a lot can happen and not being handled)
local Log = module("lib/Log")
local lang = vRP.lang
--local cfg = module("cfg/homes")

-- api

local components = {}
local active_tents = {}
local tent_area_owners = {}

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

local function tent_leave(player,area)
    vRP.closeMenu(player)
end

local function tent_enter(player,area)
	local user_id = vRP.getUserId(player)
    print(area)
    local tent_owner = tent_area_owners[area]
    print(tent_owner)
	if user_id ~= nil then
		vRPclient.isPedInCar(player, {}, function(inVeh)
			if not inVeh then
                vRP.getUserTent(user_id, function(e_tent)
            		if e_tent ~= nil then
                        local menu = {name="Tent",css={top="75px",header_color="rgba(255,125,24,0.75)"}}
        				menu["Tent"] = {function(player,choice)
                            print("tent owned by "..tent_owner)
                            vRP.prompt(player, lang.home.gametable.bet.prompt(), "", function(player, pin)
                				pin = parseInt(pin)
                				if pin > 0 then
                                    vRP.openChest(player, "u"..tent_owner.."tent", config.weight or 150,nil,nil,nil)
                                end
                            end)
                        end, "Do tent things"}
                        menu["Tent2"] = {function(player,choice) end, "Do tent things"}

                        vRP.openMenu(player,menu)
                    end
                end)
			end
		end)
	end
end

local function createTentArea(tent_owner,tent_pos)
    for _,player in pairs(GetPlayers()) do
        local x,y,z = table.unpack(tent_pos)
        vRP.setArea(player,"vRP:tent:"..tent_owner,x,y,z,2,2,tent_enter,tent_leave)
        tent_area_owners["vRP:tent:"..tent_owner] = tent_owner
    end
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
                        createTentArea(user_id,tent.pos)
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
--
AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
	if first_spawn then -- first spawn, build homes
		vRP.getUserTent(user_id, function(e_tent)
			if e_tent ~= nil then
				local e_tent = json.decode(e_tent.data)
                createTentArea(user_id,e_tent.pos)
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
