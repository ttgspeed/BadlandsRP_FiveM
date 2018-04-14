local cfg = module("cfg/police")
local Log = module("lib/Log")
local stores = {
	["paleto_twentyfourseven"] = {
		position = { x = 1734.82250976563, y = 6420.0400390625, z = 35.0372276306152 },
		reward = 10000,
		nameofstore = "Twenty Four Seven. (Paleto Bay)",
		lastrobbed = 0,
		timetorob = 8
	},
	["grapeseed_twentyfoursever"] = {
		position = { x = 1706.8193359375, y = 4920.0903320313, z = 42.063671112061 },
		reward = 8000,
		nameofstore = "Twenty Four Seven. (Grapeseed)",
		lastrobbed = 0,
		timetorob = 6
	},
	["sandyshores_twentyfoursever"] = {
		position = { x = 1959.357421875, y = 3748.55346679688, z = 32.3437461853027 },
		reward = 7000,
		nameofstore = "Twenty Four Seven. (Sandy Shores)",
		lastrobbed = 0,
		timetorob = 6
	},
	["bar_one"] = {
		position = { x = 1982.78100585938, y = 3052.92529296875, z = 47.2150535583496 },
		reward = 7000,
		nameofstore = "Yellow Jack. (Sandy Shores)",
		lastrobbed = 0,
		timetorob = 5
	},
	["routesixtyeight_twentyfoursever"] = {
		position = { x = 546.11102294922, y = 2663.4409179688, z = 42.156536102295 },
		reward = 8000,
		nameofstore = "Twenty Four Seven. (Route 68)",
		lastrobbed = 0,
		timetorob = 5,
	},
	["chumash_twentyfoursever"] = {
		position = { x = -3249.4548339844, y = 1004.3596191406, z = 12.830714225769 },
		reward = 7000,
		nameofstore = "Twenty Four Seven. (Chumash)",
		lastrobbed = 0,
		timetorob = 5,
	},
	["littleseoul_twentyfourseven"] = {
		position = { x = -709.17022705078, y = -904.21722412109, z = 19.215591430664 },
		reward = 5000,
		nameofstore = "Twenty Four Seven. (Little Seoul)",
		lastrobbed = 0,
		timetorob = 5
	},
	["mirrorpark_twentyfourseven"] = {
		position = { x = 1160.5590820313, y = -314.16375732422, z = 69.205055236816 },
		reward = 5000,
		nameofstore = "Twenty Four Seven. (Mirror Park)",
		lastrobbed = 0,
		timetorob = 5
	},
}

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
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery was cancelled at: ^2" .. stores[robb].nameofstore)
		robery_inprogress = false
		local user_id = vRP.getUserId(source)
		Log.write(user_id,"Cancelled a store robbery at "..stores[robb].nameofstore.." (too far)",Log.log_type.action)
	end
end)

RegisterServerEvent('es_holdup:cancel')
AddEventHandler('es_holdup:cancel', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_holdup:toofarlocal', source)
		--stores[robb].lastrobbed = os.time()
		lastrobbed = os.time()
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery was cancelled at: ^2" .. stores[robb].nameofstore)
		robery_inprogress = false
		local user_id = vRP.getUserId(source)
		Log.write(user_id,"Cancelled a store robbery at "..stores[robb].nameofstore.." (dead/restrained)",Log.log_type.action)
	end
end)

RegisterServerEvent('es_holdup:rob')
AddEventHandler('es_holdup:rob', function(robb)
	if stores[robb] then
		local store = stores[robb]
		local copCount = 0
  		for _ in pairs(vRP.getUsersByPermission("police.service")) do copCount = copCount + 1 end
		if copCount < cfg.cops_required_for_robbery then
			TriggerClientEvent('chatMessage', source, 'ROBBERY', {255, 0, 0}, "Not enough cops on duty.")
			return
		end
		if robery_inprogress then
			TriggerClientEvent('chatMessage', source, 'ROBBERY', {255, 0, 0}, "Another robbery is in progress.")
			return
		end

		--if (os.time() - store.lastrobbed) < cfg.store_robbery_cooldown and store.lastrobbed ~= 0 then
		if (os.time() - lastrobbed) < cfg.store_robbery_cooldown and lastrobbed ~= 0 then
			TriggerClientEvent('chatMessage', source, 'ROBBERY', {255, 0, 0}, "A robbery has occured recently. Try again later.")
			return
		end
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery in progress at ^2" .. store.nameofstore)
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "You started a robbery at: ^2" .. store.nameofstore .. "^0, do not get too far away from this point!")
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "The Alarm has been triggered!")
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Hold the fort for ^1"..store.timetorob.." ^0minutes and the money is yours!")
		TriggerClientEvent('es_holdup:currentlyrobbing', source, robb)
		--stores[robb].lastrobbed = os.time()
		lastrobbed = os.time()
		robbers[source] = robb
		robery_inprogress = true
		local savedSource = source
		local user_id = vRP.getUserId(source)
		Log.write(user_id,"Started a store robbery at "..store.nameofstore,Log.log_type.action)
		SetTimeout(store.timetorob*60000, function()
			if(robbers[savedSource])then
				TriggerClientEvent('es_holdup:robberycomplete', savedSource, job)
				user_id = vRP.getUserId(savedSource)
				vRP.giveMoney(user_id,store.reward)
				--stores[robb].lastrobbed = os.time()
				lastrobbed = os.time()
				TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery is over at: ^2" .. store.nameofstore)
				robery_inprogress = false
				Log.write(user_id,"Completed a store robbery at "..store.nameofstore..". Received $"..store.reward,Log.log_type.action)
			end
		end)
	end
end)
