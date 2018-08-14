--[[
	-- Filename: wine.lua
	-- Author: speed
	-- Description: Serves as a method to allow processing wine
	--              Factory equipment must be maintained to produce quality wine
	--              0-1 errors = wine, 2+ errors = poor quality wine
]]--

local Log = module("lib/Log")
local lang = vRP.lang

local units_final = {
	["bitter_wine"] = 0,
	["wine"] = 0,
}

local units = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
	[6] = 0,
	[100] = 0, --grapes
	[101] = 0, --yeast
	[102] = 0, --wine
}

function tvRP.addUnit(index,unit,quantity)
	local task = TUNNEL_DELAYED()
	local user_id = vRP.getUserId(source)
	local index = index
	if vRP.tryGetInventoryItem(user_id,unit,quantity,false) then
		tvRP.broadcastWineTaskStatus(index, units[index]+quantity)
		task({true})
	else
		task({false})
	end
end

function tvRP.refreshWineTaskStatus()
	for k,v in pairs(units) do
		vRPclient.setWineTaskStatus(source,{k,v})
	end
end

function tvRP.broadcastWineTaskStatus(task,status)
	units[task] = status
	vRPclient.setWineTaskStatus(-1,{task,status})
end

function tvRP.collectWine()
	local user_id = vRP.getUserId(source)

	if units_final["bitter_wine"] > 0 then
		local new_weight = vRP.getInventoryWeight(user_id)+vRP.getItemWeight("bitter_wine")*units_final["bitter_wine"]
		if new_weight <= vRP.getInventoryMaxWeight(user_id) then
			Log.write(user_id, "Collected "..units_final["bitter_wine"].." bitter_wine",Log.log_type.business)
			vRP.giveInventoryItem(user_id,"bitter_wine",units_final["bitter_wine"])
			units_final["bitter_wine"] = 0
		else
			vRPclient.notify(source,{lang.inventory.full()})
		end
	end

	if units_final["wine"] > 0 then
		local new_weight = vRP.getInventoryWeight(user_id)+vRP.getItemWeight("wine")*units_final["wine"]
		if new_weight <= vRP.getInventoryMaxWeight(user_id) then
			Log.write(user_id, "Collected "..units_final["wine"].." wine",Log.log_type.business)
			vRP.giveInventoryItem(user_id,"wine",units_final["wine"])
			units_final["wine"] = 0
		else
			vRPclient.notify(source,{lang.inventory.full()})
		end
	end

	tvRP.broadcastWineTaskStatus(102,units_final["bitter_wine"]+units_final["wine"])
end

function tvRP.giveGrapes(quantity)
	local user_id = vRP.getUserId(source)
	vRP.giveInventoryItem(user_id,"grapes",quantity)
end


local function breakPart()
	local task = math.random(1,6)
	if units[task] == 0 then
		tvRP.broadcastWineTaskStatus(task, 1)
	end
end

local function produceWine()
	if units[100] > 0 and units[101] > 0 then
		local errors = 0
		for i=1,6 do
			if units[i] == 1 then
				errors = errors + 1
			end
		end

		if errors > 1 then
			units_final['bitter_wine'] = units_final['bitter_wine'] + 1
		else
			units_final['wine'] = units_final['wine'] + 1
		end

		tvRP.broadcastWineTaskStatus(100, units[100]-1)
		tvRP.broadcastWineTaskStatus(101, units[101]-1)
		tvRP.broadcastWineTaskStatus(102, units[102]+1)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30000)
		produceWine()
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = math.random(45000,60000)
		Citizen.Wait(sleep)
		breakPart()
	end
end)
