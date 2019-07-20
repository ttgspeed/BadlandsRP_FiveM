local cfg_police = module("cfg/police")
local cfg_business = module("cfg/business_shops")
local Log = module("lib/Log")
local stores = cfg_business.stores

local last_store_robbed = 0
local last_store_raided = 0

local cbs = {
    ['tent'] = vRP.resolveTentRobbery,
    ['store_robbery'] = vRP.resolveStoreRobbery,
    ['store_raid'] = vRP.resolveStoreRaid
}
--
-- GENERIC HANDLER
--
function tvRP.resolveRobbery(success,cb,cbargs)
    --TODO figure out why calling cbs[cb]() fails past the first index.
    --     Works fine for tent, but not store_robbery for some reason
    if cb == "tent" then
        vRP.resolveTentRobbery(source,success,cbargs)
    elseif cb == "store_robbery" then
        vRP.resolveStoreRobbery(source,success,cbargs)
    elseif cb == "store_raid" then
        vRP.resolveStoreRaid(source,success,cbargs)
    end
end

--
-- STORE ROBBERIES
--
function vRP.startStoreRobbery(player, rob)
  if stores[rob] then
    local store = stores[rob]

    if (os.time() - last_store_robbed) > cfg_police.store_robbery_cooldown then
        local user_id = vRP.getUserId(player)

        local x,y,z = table.unpack(store.safe_pos)
        tvRP.sendServiceAlert(nil, "Police",x,y,z,"SecuroServ Security Alert: Access exception occured at "..store.name)

        vRPclient.startRobbery(player,{store.timetorob*60,store.safe_pos,"store_robbery",rob})
        Log.write(user_id,"Started a store robbery at "..store.name,Log.log_type.action)
    else
        vRPclient.notify(player,{"Your fingers slip off the lock. You're unable to break it right now."})
    end
  end
end

function vRP.resolveStoreRobbery(source,success,rob)
    local user_id = vRP.getUserId(source)
    local player = vRP.getUserSource(user_id)
    local store = stores[rob]
    last_store_robbed = os.time()

    if success then
        local reward = store.reward

        local copCount = 0
        for _ in pairs(vRP.getUsersByPermission("police.service")) do copCount = copCount + 1 end
        if copCount < cfg_police.cops_required_for_robbery then
            reward = math.floor(store.reward*0.1)
        end

        if store.business > 0 then
            store.safe_money = store.safe_money - reward

            if store.safe_money < 0 then
                store.safe_money = 0
            end
        end

        vRP.giveMoney(user_id,reward)
        vRPclient.notify(player,{"You have broken the lock and received $"..reward})
        Log.write(user_id,"Completed a store robbery at "..store.name..". Received $"..reward,Log.log_type.action)
    else
        vRPclient.notify(player,{"You failed to break the lock"})
        Log.write(user_id,"Failed a store robbery at "..store.name,Log.log_type.action)
    end

    local x,y,z = table.unpack(store.safe_pos)
    tvRP.sendServiceAlert(nil, "Police",x,y,z,"SecuroServ Security Alert: Access exception resolved at "..store.name)
end

function vRP.startStoreRaid(player, raid)
  if stores[raid] then
    local store = stores[raid]

    if (os.time() - last_store_raided) > cfg_police.store_robbery_cooldown then
        local user_id = vRP.getUserId(player)

        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-bubble" style="background-color: rgba(0, 82, 204, 0.6);"><i class="fas fa-balance-scale"></i> {0}</div>',
            args = { "Police Raid in progress at ^2" .. store.name }
        })

        vRPclient.startRobbery(player,{store.timetorob*60,store.safe_pos,"store_raid",raid})
        Log.write(user_id,"Started a store raid at "..store.name,Log.log_type.action)
    else
        vRPclient.notify(player,{"The department recently performed a raid. You don't have the budget for another one."})
    end
  end
end

function vRP.resolveStoreRaid(source,success,raid)
    local user_id = vRP.getUserId(source)
    local player = vRP.getUserSource(user_id)
    local store = stores[raid]
    last_store_raided = os.time()

    if success then
        vRP.request(player, "Raid complete. Do you wish to close the business at this time?", 1000, function(player,ok)
            if ok then
                if store.business > 0 then
                    store.business = -1
                    store.recipes = {}
                    vRP.setShopTransformer("cfg:"..raid,store)
                end

                last_store_raided = os.time()
                TriggerClientEvent('chat:addMessage', -1, {
                        template = '<div class="chat-bubble" style="background-color: rgba(0, 82, 204, 0.6);"><i class="fas fa-balance-scale"></i> {0}</div>',
                        args = { "Police have shut down ^2" .. store.name .."^0 due to illegal activity!"}
                })
                Log.write(user_id,"Completed a police raid at "..store.name,Log.log_type.action)
            end
        end)

        Log.write(user_id,"Completed a store raid at "..store.name,Log.log_type.action)
    else
        vRPclient.notify(player,{"You failed to break the lock"})
        Log.write(user_id,"Failed a store raid at "..store.name,Log.log_type.action)
    end
end
