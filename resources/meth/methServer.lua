-----------------
--- Variables ---
-----------------

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

------------------------
--- Server functions ---
------------------------

--inform the server that a player has entered a meth lab
function meth.enterMethLab(vehicleId,vehicleModel,vehiceName)
	print("Adding player to meth lab: " .. vehicleId)
	if activeMethLabs[vehicleId] ~= nil then
		activeMethLabs[vehicleId].players[source] = true
		vRPclient.setProgressBar(source,{"MethLab:"..activeMethLabs[vehicleId].chestname,"center","Cooking meth ...",255,1,1,0})
	end
end

--inform the server that a player has left a meth lab
function meth.exitMethLab(vehicleId)
	if activeMethLabs[vehicleId] ~= nil then
		vRPclient.removeProgressBar(source,{"MethLab:"..activeMethLabs[vehicleId].chestname})
		activeMethLabs[vehicleId].players[source] = nil
	end
	print("Removing player from meth lab: " .. vehicleId)
	-- if #(activeMethLabs[vehicleId].players) == 0 then
		-- removeMethLab(vehicleId)
	-- end
	
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

--syncs meth lab position
function meth.syncPosition(vehicleId,x,y,z)
	activeMethLabs[vehicleId].location = {x=x,y=y,z=z}
	print("Lab position synced: " .. x .. " " .. y .. " " .. z)
end

function meth.getLabPosition(vehicleId)
	if activeMethLabs[vehicleId] ~= nil then 
		return activeMethLabs[vehiceId].location
	else
		return {}
	end
end

--get the location of a random meth lab
--nil if no meth labs are active
--empty table {} if meth lab exists but hasn't started cooking
function meth.getRandomLabPosition()
	if next(activeMethLabs) == nil then return nil end
	local keyset = {}
	for k in pairs(activeMethLabs) do
		table.insert(keyset, k)
	end
	-- Initialize the pseudo random number generator
	math.randomseed( os.time() )
	math.random(); math.random(); math.random()
	-- done. :-)
	local lab = activeMethLabs[keyset[math.random(#keyset+1)]]
	return lab.location
end

--adds a vehicle as a meth lab
--called from the use of the meth_kit item
function meth.addMethLab(vehicleId,name,user_id)
	if activeMethLabs[vehiceId] ~= nil then return end
	
	--check if name is a meth lab
	if not isCarMethLab(name) then return end
	
	local methLab = {}
	methLab.players = {}
	methLab.location = {}
	methLab.chestname = "u"..user_id.."veh_"..string.lower(name)
	
	--get chest data
	vRP.getSData({"chest:"..methLab.chestname},function(items)
		methLab.items = json.decode(items) or {}
	end)
	activeMethLabs[vehicleId] = methLab
	methClient.addMethLab(-1,{vehicleId})
	print("Meth lab added: " .. vehicleId .. " " .. methLab.chestname)
end 

--------------------------
--- Internal Functions ---
--------------------------

--removes a meth lab 
--TODO: figure out when this needs to be called, currently once a meth lab is added it is there forever
function removeMethLab(vehicleId)
	activeMethLabs[vehicleId] = nil
	methClient.removeMethLab(-1,{vehicleId})
	print("Meth lab removed: " .. vehicleId)
end

--check if a given car is a meth lab
function isCarMethLab(carModel)
	for i,v in ipairs(cfg.methLabs) do
		if carModel == v then return true end
	end
	return false
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

-- Loop the ticking of the meth lab
function loop()
	for k,v in pairs(activeMethLabs) do
		print("Processing tick for " .. v.chestname)
		methLabTick(v)
	end
	SetTimeout(10000,loop)
end

loop()

-- JIP
AddEventHandler('playerConnecting', function(playerName, setKickReason)
    for k,v in pairs(activeMethLabs) do 
		methClient.addMethLab(source,{k})
	end
end)