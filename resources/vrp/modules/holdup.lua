local cfg_police = module("cfg/police")
local cfg_business = module("cfg/business_shops")
local Log = module("lib/Log")
local stores = cfg_business.stores

local robery_inprogress = false
local lastrobbed = 0

local robbers = {}

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('es_holdup:toofar')
AddEventHandler('es_holdup:toofar', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_holdup:toofarlocal', source)
		--stores[robb].lastrobbed = os.time()
		lastrobbed = os.time()
		robbers[source] = nil
		TriggerClientEvent('chat:addMessage', -1, {
				template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 0, 0.6);"><i class="fas fa-newspaper"></i> {0}</div>',
				args = { "Robbery was cancelled at: ^2" .. stores[robb].name }
		})
		robery_inprogress = false
		local user_id = vRP.getUserId(source)
		Log.write(user_id,"Cancelled a store robbery at "..stores[robb].name.." (too far)",Log.log_type.action)
	end
end)

RegisterServerEvent('es_holdup:cancel')
AddEventHandler('es_holdup:cancel', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_holdup:toofarlocal', source)
		--stores[robb].lastrobbed = os.time()
		lastrobbed = os.time()
		robbers[source] = nil
		TriggerClientEvent('chat:addMessage', -1, {
				template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 0, 0.6);"><i class="fas fa-newspaper"></i> {0}</div>',
				args = { "Robbery was cancelled at: ^2" .. stores[robb].name }
		})
		robery_inprogress = false
		local user_id = vRP.getUserId(source)
		Log.write(user_id,"Cancelled a store robbery at "..stores[robb].name.." (dead/restrained/no kit)",Log.log_type.action)
	end
end)

RegisterServerEvent('es_holdup:rob')
AddEventHandler('es_holdup:rob', function(player, robb)
	if stores[robb] then
		local store = stores[robb]
		if robery_inprogress then
			TriggerClientEvent('chat:addMessage', player, {
					template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 0, 0.6);"><i class="fas fa-newspaper"></i> {0}</div>',
					args = { "Another robbery is in progress." }
			})
			return
		end

		--if (os.time() - store.lastrobbed) < cfg.store_robbery_cooldown and store.lastrobbed ~= 0 then
		if (os.time() - lastrobbed) < cfg_police.store_robbery_cooldown and lastrobbed ~= 0 then
			TriggerClientEvent('chat:addMessage', player, {
					template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 0, 0.6);"><i class="fas fa-newspaper"></i> {0}</div>',
					args = { "A robbery has occured recently. Try again later." }
			})
			return
		end
		TriggerClientEvent('chat:addMessage', -1, {
				template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 0, 0.6);"><i class="fas fa-newspaper"></i> {0}</div>',
				args = { "Robbery in progress at ^2" .. store.name }
		})
		TriggerClientEvent('chat:addMessage', player, {
				template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 0, 0.6);"><i class="fas fa-newspaper"></i> {0}</div>',
				args = { "You started a robbery at: ^2" .. store.name .. "^0, do not get too far away from this point!" }
		})
		TriggerClientEvent('chat:addMessage', player, {
				template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 0, 0.6);"><i class="fas fa-newspaper"></i> {0}</div>',
				args = { "The Alarm has been triggered!" }
		})
		TriggerClientEvent('chat:addMessage', player, {
				template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 0, 0.6);"><i class="fas fa-newspaper"></i> {0}</div>',
				args = { "Hold the fort for ^1"..store.timetorob.." ^0minutes and the money is yours!" }
		})
		TriggerClientEvent('es_holdup:currentlyrobbing', player, robb, store)
		--stores[robb].lastrobbed = os.time()
		lastrobbed = os.time()
		robbers[player] = robb
		robery_inprogress = true
		local savedSource = player
		local user_id = vRP.getUserId(player)
		local reward = 0
		Log.write(user_id,"Started a store robbery at "..store.name,Log.log_type.action)
		SetTimeout(store.timetorob*60000, function()
			if(robbers[savedSource])then
				reward = store.reward
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

				TriggerClientEvent('es_holdup:robberycomplete', savedSource, reward)
				user_id = vRP.getUserId(savedSource)
				vRP.giveMoney(user_id,reward)
				--stores[robb].lastrobbed = os.time()
				lastrobbed = os.time()
				TriggerClientEvent('chat:addMessage', -1, {
						template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 0, 0.6);"><i class="fas fa-newspaper"></i> {0}</div>',
						args = { "Robbery is over at: ^2" .. store.name }
				})
				robery_inprogress = false
				Log.write(user_id,"Completed a store robbery at "..store.name..". Received $"..reward,Log.log_type.action)
			end
		end)
	end
end)
