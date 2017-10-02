local cfg = module("cfg/police")
local stores = {
	["paleto_twentyfourseven"] = {
		position = { x = 1734.82250976563, y = 6420.0400390625, z = 35.0372276306152 },
		reward = 5200,
		nameofstore = "Twenty Four Seven. (Paleto Bay)",
		lastrobbed = 0,
		timetorob = 7
	},
	["sandyshores_twentyfoursever"] = {
		position = { x = 1959.357421875, y = 3748.55346679688, z = 32.3437461853027 },
		reward = 5000,
		nameofstore = "Twenty Four Seven. (Sandy Shores)",
		lastrobbed = 0,
		timetorob = 5
	},
	["bar_one"] = {
		position = { x = 1982.78100585938, y = 3052.92529296875, z = 47.2150535583496 },
		reward = 4000,
		nameofstore = "Yellow Jack. (Sandy Shores)",
		lastrobbed = 0,
		timetorob = 5
	},
	["littleseoul_twentyfourseven"] = {
		position = { x = -709.17022705078, y = -904.21722412109, z = 19.215591430664 },
		reward = 3600,
		nameofstore = "Twenty Four Seven. (Little Seoul)",
		lastrobbed = 0,
		timetorob = 3
	}
}

local robery_inprogress = false

local robbers = {}

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('es_holdup:toofar')
AddEventHandler('es_holdup:toofar', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_holdup:toofarlocal', source)
		stores[robb].lastrobbed = os.time()
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery was cancelled at: ^2" .. stores[robb].nameofstore)
		robery_inprogress = false
	end
end)

RegisterServerEvent('es_holdup:cancel')
AddEventHandler('es_holdup:cancel', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_holdup:toofarlocal', source)
		stores[robb].lastrobbed = os.time()
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery was cancelled at: ^2" .. stores[robb].nameofstore)
		robery_inprogress = false
	end
end)

RegisterServerEvent('es_holdup:rob')
AddEventHandler('es_holdup:rob', function(robb)
	if stores[robb] then
		local store = stores[robb]
		local copCount = 0
  		for _ in pairs(vRP.getUsersByPermission("police.service")) do copCount = copCount + 1 end
		if copCount < cfg.cops_required_for_robbery then
			TriggerClientEvent('chatMessage', source, 'ROBBERY', {255, 0, 0}, "Not enough cops online.")
			return
		end
		if robery_inprogress then
			TriggerClientEvent('chatMessage', source, 'ROBBERY', {255, 0, 0}, "Another robbery is in progress.")
			return
		end

		if (os.time() - store.lastrobbed) < cfg.store_robbery_cooldown and store.lastrobbed ~= 0 then
			TriggerClientEvent('chatMessage', source, 'ROBBERY', {255, 0, 0}, "This has already been robbed recently.")
			return
		end
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery in progress at ^2" .. store.nameofstore)
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "You started a robbery at: ^2" .. store.nameofstore .. "^0, do not get too far away from this point!")
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "The Alarm has been triggered!")
		TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "Hold the fort for ^1"..store.timetorob.." ^0minutes and the money is yours!")
		TriggerClientEvent('es_holdup:currentlyrobbing', source, robb)
		stores[robb].lastrobbed = os.time()
		robbers[source] = robb
		robery_inprogress = true
		local savedSource = source
		SetTimeout(store.timetorob*60000, function()
			if(robbers[savedSource])then
				TriggerClientEvent('es_holdup:robberycomplete', savedSource, job)
				user_id = vRP.getUserId(savedSource)
				vRP.giveMoney(user_id,store.reward)
				stores[robb].lastrobbed = os.time()
				TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery is over at: ^2" .. store.nameofstore)
				robery_inprogress = false
			end
		end)
	end
end)
