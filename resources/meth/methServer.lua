local Proxy = require("resources/vrp/lib/Proxy")
local Tunnel = require("resources/vrp/lib/Tunnel")
local cfg = require("resources/meth/config")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","methServer")
methClient = Tunnel.getInterface("methClient","methServer")

meth = {}
Tunnel.bindInterface("methServer",meth)

activeMethLabs = {}

--player enters a meth lab, adds meth lab if one doesn't exist, joins existing one if it does
function meth.enterMethLab(vehicleId,vehicleModel,vehiceName)
	if activeMethLabs[vehicleId] == nil then
		vRP.getUserId({source},function(user_id)
			addMethLab(vehicleId,vehiceName,user_id)
		end)
	end
	activeMethLabs[vehicleId].players[source] = true
	print("Adding player to meth lab")
end

--player leaves a meth lab
function meth.exitMethLab(vehicleId)
	if activeMethLabs[vehicleId] ~= nil then
		activeMethLabs[vehicleId].players[source] = nil
	end
	if #(activeMethLabs[vehicleId].players) == 0 then
		removeMethLab(vehicleId)
	end
	print("Removing player from meth lab")
end

--adds a meth lab
function addMethLab(vehicleId,name,user_id)
	local methLab = {}
	methLab.players = {}
	methLab.chestname = "u"..user_id.."veh_"..string.lower(name)
	methLab.running = false
	
	--get chest data
	vRP.getSData({"chest:"..methLab.chestname},function(items)
		methLab.items = json.decode(items) or {}
	end)
	activeMethLabs[vehicleId] = methLab
	addSmoke(vehicleId)
	print("Meth lab added.")
end 

--removes a meth lab
function removeMethLab(vehicleId)
	activeMethLabs[vehicleId] = nil
	methClient.removeSmoke(-1,{vehicleId})
	print("Meth lab removed")
end

function addSmoke(vehicleId)
	methClient.addSmoke(-1,{vehicleId})
end

--processes a tick of the meth lab, removes reagent and adds products
function methLabTick(lab)
	for k,v in pairs(lab.players) do
		--check if vehicle has meth ingredients
		local reagents_ok = true
        for reagent,amount in pairs(cfg.methIngredients) do
          reagents_ok = reagents_ok and (lab.items[reagent].amount >= amount)
        end
		
		if not reagents_ok then
			vRPclient.notify(k,{"You are missing ingredients"})
			break
		end
		
		--take ingredients from car
		for reagent,amount in pairs(cfg.methIngredients) do
			lab.items[reagent].amount = lab.items[reagent].amount - amount
			if lab.items[reagent].amount == 0 then 
				lab.items[reagent] = nil
			end
        end
		
		--add products
		for product,amount in pairs(cfg.methProducts) do
			if lab.items[product] ~= nil then 
				lab.items[product].amount = lab.items[product].amount + amount
			else
				lab.items[product] = {}
				lab.items[product].amount = 1
			end
		end
		vRP.setSData({"chest:"..lab.chestname, json.encode(lab.items)})		
	end
end

function loop()
	for k,v in pairs(activeMethLabs) do
		print("Processing tick for " .. v.chestname)
		methLabTick(v)
	end
	SetTimeout(10000,loop)
end

loop()