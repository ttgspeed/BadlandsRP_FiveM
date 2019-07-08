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

RegisterServerEvent('es_raid:toofar')
AddEventHandler('es_raid:toofar', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_raid:toofarlocal', source)
		--stores[robb].lastrobbed = os.time()
		lastrobbed = os.time()
		robbers[source] = nil
		TriggerClientEvent('chat:addMessage', -1, {
				template = '<div class="chat-bubble" style="background-color: rgba(0, 82, 204, 0.6);"><i class="fas fa-balance-scale"></i> {0}</div>',
				args = { "Police Raid was cancelled at: ^2" .. stores[robb].name }
		})
		robery_inprogress = false
		local user_id = vRP.getUserId(source)
		Log.write(user_id,"Cancelled a raid at "..stores[robb].name.." (too far)",Log.log_type.action)
	end
end)

RegisterServerEvent('es_raid:cancel')
AddEventHandler('es_raid:cancel', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_raid:toofarlocal', source)
		--stores[robb].lastrobbed = os.time()
		lastrobbed = os.time()
		robbers[source] = nil
		TriggerClientEvent('chat:addMessage', -1, {
				template = '<div class="chat-bubble" style="background-color: rgba(0, 82, 204, 0.6);"><i class="fas fa-balance-scale"></i> {0}</div>',
				args = { "Police Raid was cancelled at: ^2" .. stores[robb].name }
		})
		robery_inprogress = false
		local user_id = vRP.getUserId(source)
		Log.write(user_id,"Cancelled a raid at "..stores[robb].name.." (dead/restrained)",Log.log_type.action)
	end
end)

RegisterServerEvent('es_raid:rob')
AddEventHandler('es_raid:rob', function(player, robb)
	if stores[robb] then
		local store = stores[robb]
		if robery_inprogress then
			TriggerClientEvent('chat:addMessage', player, {
					template = '<div class="chat-bubble" style="background-color: rgba(0, 82, 204, 0.6);"><i class="fas fa-balance-scale"></i> {0}</div>',
					args = { "Another raid is in progress." }
			})
			return
		end

		if (os.time() - lastrobbed) < cfg_police.store_robbery_cooldown and lastrobbed ~= 0 then
			TriggerClientEvent('chat:addMessage', player, {
					template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 0, 0.6);"><i class="fas fa-newspaper"></i> {0}</div>',
					args = { "A raid has occured recently. Try again later." }
			})
			return
		end

		TriggerClientEvent('chat:addMessage', -1, {
				template = '<div class="chat-bubble" style="background-color: rgba(0, 82, 204, 0.6);"><i class="fas fa-balance-scale"></i> {0}</div>',
				args = { "Police Raid in progress at ^2" .. store.name }
		})
		TriggerClientEvent('chat:addMessage', player, {
				template = '<div class="chat-bubble" style="background-color: rgba(0, 82, 204, 0.6);"><i class="fas fa-balance-scale"></i> {0}</div>',
				args = { "You started a Police Raid at: ^2" .. store.name .. "^0, do not get too far away from this point!" }
		})
		TriggerClientEvent('chat:addMessage', player, {
				template = '<div class="chat-bubble" style="background-color: rgba(0, 82, 204, 0.6);"><i class="fas fa-balance-scale"></i> {0}</div>',
				args = { "Hold the fort for ^1"..store.timetorob.." ^0minutes to close the business!" }
		})
		TriggerClientEvent('es_raid:currentlyrobbing', player, robb, store)
		--stores[robb].lastrobbed = os.time()
		lastrobbed = os.time()
		robbers[player] = robb
		robery_inprogress = true
		local savedSource = player
		local user_id = vRP.getUserId(player)
		local reward = 0
		Log.write(user_id,"Started a police raid at "..store.name,Log.log_type.action)
		SetTimeout(store.timetorob*60000, function()
			if(robbers[savedSource])then
				vRP.request(savedSource, "Raid complete. Do you wish to close the business at this time?", 1000, function(player,ok)
					if ok then
						if store.business > 0 then
							store.business = -1
							store.recipes = {}
							vRP.setShopTransformer("cfg:"..robb,stores[robb])
						end

						TriggerClientEvent('es_raid:robberycomplete', player, reward)
						user_id = vRP.getUserId(player)
						--stores[robb].lastrobbed = os.time()
						lastrobbed = os.time()
						TriggerClientEvent('chat:addMessage', -1, {
								template = '<div class="chat-bubble" style="background-color: rgba(0, 82, 204, 0.6);"><i class="fas fa-balance-scale"></i> {0}</div>',
								args = { "Police have shut down ^2" .. store.name .."^0 due to illegal activity!"}
						})
						robery_inprogress = false
						Log.write(user_id,"Completed a police raid at "..store.name,Log.log_type.action)
					end
        end)
			end
		end)
	end
end)
