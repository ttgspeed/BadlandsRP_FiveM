local Proxy = require("resources/vrp/lib/Proxy")
local Tunnel = require("resources/vrp/lib/Tunnel")
local cfg = require("resources/meth/config")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","methServer")
methClient = Tunnel.getInterface("methClient","methServer")

meth = {}
Proxy.addInterface("meth",meth)
Tunnel.bindInterface("methServer",meth)

activeMethLabs = {}

--player enters a meth lab, adds meth lab if one doesn't exist, joins existing one if it does
function meth.enterMethLab(vehicleId,vehicleModel,vehiceName)
	print("Adding player to meth lab: " .. vehicleId)
	if activeMethLabs[vehicleId] == nil then
		vRP.getUserId({source},function(user_id)
			-- addMethLab(vehicleId,vehiceName,user_id)
		end)
	end
	activeMethLabs[vehicleId].players[source] = true
	vRPclient.setProgressBar(source,{"MethLab:"..activeMethLabs[vehicleId].chestname,"center","Cooking meth ...",255,1,1,0})
end

--player leaves a meth lab
function meth.exitMethLab(vehicleId)
	if activeMethLabs[vehicleId] ~= nil then
		vRPclient.removeProgressBar(source,{"MethLab:"..activeMethLabs[vehicleId].chestname})
		activeMethLabs[vehicleId].players[source] = nil
	end
	print("Removing player from meth lab: " .. vehicleId)
	if #(activeMethLabs[vehicleId].players) == 0 then
		removeMethLab(vehicleId)
	end
	
end

-- sync smoke to all clients
function meth.syncSmoke(vehicleId,on,x,y,z)
	SetTimeout(1000,function()
		if on then 
			methClient.addSmoke(-1,{vehicleId,x,y,z})
		else
			methClient.removeSmoke(-1,{vehicleId})
		end
	end)
end

--adds a meth lab
function meth.addMethLab(vehicleId,name,user_id)
	if activeMethLabs[vehiceId] ~= nil then return end
	local methLab = {}
	methLab.players = {}
	methLab.chestname = "u"..user_id.."veh_"..string.lower(name)
	
	--get chest data
	vRP.getSData({"chest:"..methLab.chestname},function(items)
		methLab.items = json.decode(items) or {}
	end)
	activeMethLabs[vehicleId] = methLab
	methClient.addMethLab(-1,{vehicleId})
	print("Meth lab added: " .. vehicleId .. " " .. methLab.chestname)
end 

--removes a meth lab
function removeMethLab(vehicleId)
	activeMethLabs[vehicleId] = nil
	methClient.removeMethLab(-1,{vehicleId})
	print("Meth lab removed: " .. vehicleId)
end

--processes a tick of the meth lab, removes reagent and adds products
function methLabTick(lab)
	for k,v in pairs(lab.players) do
		vRP.getSData({"chest:"..lab.chestname},function(items)
			lab.items = json.decode(items) or {}
		end)
		
		--check if vehicle has meth ingredients
		local reagents_ok = true
        for reagent,amount in pairs(cfg.methIngredients) do
		  if lab.items[reagent] == nil then
			reagents_ok = false
			break
		  end
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
	
	-- display transformation state to all transforming players
	for k,v in pairs(lab.players) do
		local reagentAmount = 1000
        for reagent,amount in pairs(cfg.methIngredients) do
			local currAmount = 0
			if lab.items[reagent] == nil then 
				currAmount = 0 
			else 
				currAmount = lab.items[reagent].amount 
			end
			if reagentAmount == nil then reagentAmount = currAmount end
			if currAmount < reagentAmount then reagentAmount = currAmount end
        end
		
		local productAmount = 0
		for product,amount in pairs(cfg.methProducts) do
			local currAmount = 1000
			if lab.items[product] == nil then
				currAmount = 0 
			else 
				currAmount = lab.items[product].amount
			end
			if productAmount == nil then productAmount = currAmount end
			if currAmount > productAmount then productAmount = currAmount end
		end
		
		vRPclient.setProgressBarValue(k,{"MethLab:"..lab.chestname,math.floor((productAmount/(reagentAmount+productAmount))*100.0)})
		vRPclient.setProgressBarText(k,{"MethLab:"..lab.chestname,"Cooking meth... "..reagentAmount.."-->"..productAmount})
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