
-- this module describe the home system (experimental, a lot can happen and not being handled)
local Log = module("lib/Log")
local lang = vRP.lang
--local cfg = module("cfg/homes")

-- api

local components = {}
local active_tents = {}
local tent_area_owners = {}
local last_lock_break = 0

-- cbreturn user address (home and number) or nil
function vRP.getUserTent(user_id, cbr)
    local task = Task(cbr)
    MySQL.Async.fetchAll('SELECT data FROM vrp_user_tents WHERE user_id = @user_id', {user_id = user_id}, function(rows)
    task({rows[1]})
    end)
end

-- set user address
function vRP.addUserTent(user_id,data)
    MySQL.Async.execute('INSERT INTO vrp_user_tents(user_id,data) VALUES(@user_id,@data)', {user_id = user_id, data = data}, function(rowsChanged) end)
end

-- remove user address
function vRP.removeUserTent(user_id)
    MySQL.Async.execute('DELETE FROM vrp_user_tents WHERE user_id = @user_id', {user_id = user_id}, function(rowsChanged) end)
end

local function tent_leave(player,area)
    vRP.closeMenu(player)
end

local function removeTentArea(tent_owner)
    for _,player in pairs(GetPlayers()) do
        vRP.removeArea(player,"vRP:tent:"..tent_owner)
        vRPclient.removeTent(player,{tent_owner})
    end
end

local function tent_enter(player,area)
    local user_id = vRP.getUserId(player)
    local tent_owner = tent_area_owners[area]
    if user_id ~= nil then
        vRPclient.isPedInCar(player, {}, function(inVeh)
            if not inVeh then
                local e_tent = active_tents[tent_owner]
                if e_tent ~= nil then
                    local chestname = "u"..tent_owner.."tent"
                    local max_weight = 150
                    local menu = {name="Tent",css={top="75px",header_color="rgba(255,125,24,0.75)"}}

                    menu["Lockbox"] = {function(player,choice)
                        if e_tent.lock_broken == true then
                            vRP.openChest(player, chestname, max_weight)
                        else
                            vRP.prompt(player,"Enter a lock combination (0000-9999)","",function(player,lock)
                                if e_tent.lock ~= nil and e_tent.lock == lock then
                                    vRP.openChest(player, chestname, max_weight)
                                end
                            end)
                        end
                    end, "Open the tent's lockbox",1}

                    if user_id ~= tent_owner and e_tent.lock_broken == false then
                        menu["Break lock"] = {function(player,choice)
                            if (os.time() - last_lock_break) > 900 then
                                last_lock_break = os.time()
                                if e_tent.alarm == true then
                                    local x,y,z = table.unpack(e_tent.pos)
                                    tvRP.sendServiceAlert(nil, "Police",x,y,z,"SecuroServ Security Alert: Intrustion Detected!")
                                    vRP.getUserIdentity(tent_owner, function(identity)
                                        local source_number = "521-1734"
                                        TriggerEvent('gcPhone:sendMessage_Anonymous', source_number, identity.phone,
                                            "SecuroServ Security Alert: Your intrusion detection system has been tripped! We've alerted the authorities!")
                                    end)
                                end
                                vRPclient.startTentRobbery(player,{tent_owner,e_tent.pos})
                            else
                                vRPclient.notify(player,{"Your fingers slip off the lock. You're unable to break it right now."})
                            end
                        end, "Break the lockbox's lock.",2}
                    elseif user_id == tent_owner and e_tent.lock_broken == true then
                        menu["Fix lock"] = {function(player,choice)
                            e_tent.lock_broken = false
                        end, "Fix the lockbox's lock.",2}
                    end

                    if user_id == tent_owner then
                        menu["Duffel bag"] = {function(player,choice)
                            vRP.openWardrobe(player)
                        end, "A bag of questionably clean clothes",3}

                        menu["Pack tent"] = {function(player,choice)
                            vRP.request(player, "Are you sure you want to pack up your tent? This will destroy anything inside.", 30, function(hplayer,ok)
                                if ok then
                                    local tent_model = "tent"
                                    if e_tent.alarm == true then
                                        tent_model = "tent2"
                                    end

                                    vRP.removeUserTent(user_id)
                                    vRP.giveInventoryItem(user_id,tent_model,1,true)
                                    vRP.setSData(chestname, json.encode({}))
                                    removeTentArea(tent_owner)
                                    vRP.closeMenu(player)
                                end
                            end)
                        end, "Break down your tent and return it to your inventory.",4}
                    end

                    vRP.openMenu(player,menu)
                end
            end
        end)
    end
end

local function createTentArea(tent_owner,tent_pos)
    for _,player in pairs(GetPlayers()) do
        local x,y,z = table.unpack(tent_pos)
        vRP.setArea(player,"vRP:tent:"..tent_owner,x,y,z,3,3,tent_enter,tent_leave)
        tent_area_owners["vRP:tent:"..tent_owner] = tent_owner
    end
end

-- access a home by address
-- cbreturn true on success
function vRP.createTent(player,alarm)
    local user_id = vRP.getUserId(player)
    local player = player
    local alarm = alarm or false
    vRP.getUserTent(user_id, function(e_tent)
        if e_tent == nil then
            vRPclient.isPlayerNearArea(player,{5},function(near_area)
                if not near_area then
                    vRP.prompt(player,"Enter a lock combination (0000-9999)","",function(player,lock)
                        if string.len(lock) == 4 then
                            lock_int = tonumber(lock)
                            if lock_int >= 0 and lock_int <= 9999 then
                                vRPclient.getForwardPosition(player,{},function(x,y,z)
                                    if z > 0 then
                                        local tent_model = "tent"
                                        if alarm == true then
                                            tent_model = "tent2"
                                        end
                                        if vRP.tryGetInventoryItem(user_id,tent_model,1,false) then
                                            local tent = {
                                                ["pos"] = {x,y,z},
                                                ["lock"] = lock,
                                                ["lock_broken"] = false,
                                                ["alarm"] = alarm
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
                            end
                        end
                    end)
                else
                    vRPclient.notify(player,{"Unable to place tent here."})
                end
            end)
        else
            vRPclient.notify(player,{"You already have a tent"})
        end
    end)
end

function tvRP.resolveTentRobbery(owner, success)
    local user_id = vRP.getUserId(source)
    local player = vRP.getUserSource(user_id)

    if success then
        vRPclient.notify(player,{"You have broken the lock. The lockbox is now unprotected."})
        active_tents[owner].lock_broken = true
    else
        vRPclient.notify(player,{"You failed to break the lock"})
    end
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
    --     active_tents[user_id] = nil
    --     vRPclient.removeTent(-1,{user_id})
    -- end
end)
