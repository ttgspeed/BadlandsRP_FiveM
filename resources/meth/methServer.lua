local Proxy = require("resources/vrp/lib/Proxy")
local Tunnel = require("resources/vrp/lib/Tunnel")
local cfg = require("resources/meth/config")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","methServer")

meth = {}
Tunnel.bindInterface("methServer",meth)

local activeMethLabs = {}

--player enters a meth lab, adds meth lab if one doesn't exist, joins existing one if it does
function meth.enterMethLab(vehicleId,vehicleModel,vehiceName)
	if activeMethLabs[vehicleId] == nil then
		vRP.getUserId({source},function(user_id)
			addMethLab(vehicleId,vehiceName,user_id)
		end)
	else
		activeMethLabs[vehicleId].players[source] = true
	end
end

--adds a meth lab
function addMethLab(vehicleId,name,user_id)
	local methLab = {}
	methLab.players = {}
	methLab.chestname = "u"..user_id.."veh_"..string.lower(name)
	
	--get chest data
	vRP.getSData({"chest:"..methLab.chestname},function(items)
		methLab.items = json.decode(items) or {}
	end)
	activeMethLabs[vehicleId] = methLab
	print("Meth lab added.")
end 

--removes a meth lab
function removeMethLab(vehicleId)
	activeMethLabs[vehicleId] = nil
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
	SetTimeout(3000,loop)
end

loop()