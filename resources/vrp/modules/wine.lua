--[[
	-- Filename: wine.lua
	-- Author: speed
	-- Description: Serves as a method to allow processing wine
	--              Factory equipment must be maintained to produce quality wine
	--              0-1 errors = wine, 2+ errors = poor quality wine
]]--

local Log = module("lib/Log")

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
	[6] = 0, --grapes
	[7] = 0, --yeast
	[8] = 0, --wine
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
	--print("refreshing status for "..source)
	for k,v in pairs(units) do
		--print("sending refresh "..k.." "..v)
		vRPclient.setWineTaskStatus(source,{k,v})
	end
end

function tvRP.broadcastWineTaskStatus(task,status)
	--print("sending "..task.." "..status)
	units[task] = status
	vRPclient.setWineTaskStatus(-1,{task,status})
end

function tvRP.collectWine()
	local user_id = vRP.getUserId(source)
	vRP.giveInventoryItem(user_id,"bitter_wine",units_final["bitter_wine"])
	vRP.giveInventoryItem(user_id,"wine",units_final["wine"])
	tvRP.broadcastWineTaskStatus(8,0)
	units_final["bitter_wine"] = 0
	units_final["wine"] = 0
end

local function breakPart()
	local task = math.random(1,5)
	if units[task] == 0 then
		tvRP.broadcastWineTaskStatus(task, 1)
	end
end

local function produceWine()
	if units[6] > 0 and units[7] > 0 then
		local errors = 0
		for i=1,5 do
			if units[i] == 1 then
				errors = errors + 1
			end
		end

		if errors > 1 then
			units_final['bitter_wine'] = units_final['bitter_wine'] + 1
		else
			units_final['wine'] = units_final['wine'] + 1
		end

		tvRP.broadcastWineTaskStatus(6, units[6]-1)
		tvRP.broadcastWineTaskStatus(7, units[7]-1)
		tvRP.broadcastWineTaskStatus(8, units[8]+1)
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
		local sleep = math.random(30000,45000)
		Citizen.Wait(sleep)
		breakPart()
	end
end)
