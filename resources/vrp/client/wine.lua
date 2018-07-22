--[[
	-- Filename: wine.lua
	-- Author: speed
	-- Description: Serves as a method to allow processing wine
	--              Factory equipment must be maintained to produce quality wine
	--              0-1 errors = wine, 2+ errors = poor quality wine
]]--

local clockedIn = false
local tasks = {}

local function addUnit(index,unit)
	vRPserver.addUnit({index,unit,1}, function(ok)
		if ok then
			local emote = tasks[index].animation
			tvRP.playAnim(emote[1],emote[2],emote[3])
		else
			tvRP.notify("You do not have any "..unit)
		end
	end)
end

local function repairPart(index,unit)
	Citizen.CreateThread(function()
		local emote = tasks[index].animation
		tvRP.playAnim(emote[1],emote[2],emote[3])
		Citizen.Wait(5000)
		tvRP.stopAnim(emote[1])
		vRPserver.broadcastWineTaskStatus({index, 0}, function(ok) end)
	end)
end

local function collectWine(index,unit)
	local emote = tasks[index].animation
	tvRP.playAnim(emote[1],emote[2],emote[3])
	vRPserver.collectWine({}, function(ok) end)
end

local function clockIn()
	clockedIn = not clockedIn
end

tasks = {
	[1] = {
		pos = {911.60400390625,-1897.1875,41.997455596924},
		description = "Unblock Hopper",
		action = repairPart,
		animation = {false, {task="WORLD_HUMAN_GARDENER_PLANT"}, false},
		unit = "hopper",
		status = 0
	},
	[2] = {
		pos = {829.88348388672,-2020.1450195312,42.4179763793},
		description = "Replace Cooling Filter",
		action = repairPart,
		animation = {false, {task="CODE_HUMAN_MEDIC_TEND_TO_DEAD"}, false},
		unit = "cooling",
		status = 0
	},
	[3] = {
		pos = {862.73162841796,-1885.1861572266,37.089542388916},
		description = "Repair Piping",
		action = repairPart,
		animation = {false, {task="WORLD_HUMAN_WELDING"}, false},
		unit = "piping",
		status = 0
	},
	[4] = {
		pos = {906.72839355468,-1825.511352539,35.324966430664},
		description = "Refuel Generator",
		action = repairPart,
		animation = {true,{{"weapon@w_sp_jerrycan","fire",5}},false},
		unit = "generator",
		status = 0
	},
	[5] = {
		pos = {866.01599121094,-1967.923461914,30.205972671508},
		description = "Replace Fuse",
		action = repairPart,
		animation = {false, {task="CODE_HUMAN_MEDIC_TEND_TO_DEAD"}, false},
		unit = "fuse",
		status = 0
	},
	[6] = {
		pos = {917.12518310546,-1975.7413330078,44.234119415284},
		description = "Add Grapes",
		action = addUnit,
		animation = {true,{{"pickup_object","pickup_low",1}},false},
		unit = "grapes",
		status = 0
	},
	[7] = {
		pos = {905.28369140625,-1971.6408691406,43.749282836914},
		description = "Add Yeast",
		action = addUnit,
		animation = {true,{{"pickup_object","pickup_low",1}},false},
		unit = "yeast",
		status = 0
	},
	[8] = {
		pos = {911.15447998046,-1902.639038086,31.62049484253},
		description = "Collect Wine",
		action = collectWine,
		animation = {true,{{"pickup_object","pickup_low",1}},false},
		unit = "wine",
		status = 0
	},
}

Citizen.CreateThread(function()
	vRPserver.refreshWineTaskStatus({}, function(ok) end)
	while true do
		Citizen.Wait(0)
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
		if Vdist(x,y,z,832.51293945312,-1923.1110839844,30.314670562744) <= 2 then
			tvRP.DrawText3d(832.51293945312,-1923.1110839844,30.314670562744,"Clock In/Out",0.35,255,255,255)
			DisplayHelpText("Press ~INPUT_CONTEXT~ to Clock In/Out")
			if IsControlJustReleased(1, 51) then
				clockIn()
			end
		end
		if clockedIn then
			if Vdist(x,y,z,879.28826904296,-1915.8924560546,30.655570983886) < 200 then
				for k,task in pairs(tasks) do
					if task.unit == "yeast" or task.unit == "grapes" or task.unit == "wine" then
						if task.status > 0 then
							tvRP.DrawText3d(task.pos[1],task.pos[2],task.pos[3],task.description.." ("..task.status..")",0.35,0,255,0)
						else
							tvRP.DrawText3d(task.pos[1],task.pos[2],task.pos[3],task.description.." ("..task.status..")",0.35,255,0,0)
						end
					else
						if task.status == 0 then
							tvRP.DrawText3d(task.pos[1],task.pos[2],task.pos[3],task.description,0.35,0,255,0)
						else
							tvRP.DrawText3d(task.pos[1],task.pos[2],task.pos[3],task.description,0.35,255,0,0)
						end
					end
					local distance = Vdist(x,y,z,task.pos[1],task.pos[2],task.pos[3])
					if distance <= 2 and (k > 5 or task.status == 1) then
						DisplayHelpText("Press ~INPUT_CONTEXT~ to "..task.description)

						if IsControlJustReleased(1, 51) then
							task.action(k,task.unit)
						end
					end
				end
			else
				clockedIn = false
				tvRP.notify("You have been clocked out due to leaving the factory grounds.")
			end
		end
	end
end)

function tvRP.setWineTaskStatus(task,status)
	--print("receivied "..task.." "..status)
	tasks[task].status = status
end

local grape_sites = {
	{
		['x'] = -1814.4682617188,
		['y'] = 2187.1625976562,
		['area'] = 60,
		loot_areas = {
		}
	}
}

local function populateVineyard()
	for k,v in ipairs(grape_sites) do
		for i=1,100 do
			local randomX = v.x + math.random(v.area*-1,v.area)
			local randomY = v.y + math.random(v.area*-1,v.area)
			b,randomZ = GetGroundZFor_3dCoord(randomX, randomY, 99999.0, 1)
			v.loot_areas[i] = {['x'] = randomX, ['y'] = randomY, ['z'] = randomZ, ['harvested'] = false}
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local pos = GetEntityCoords(ped, nil)
		for _,site in ipairs(grape_sites) do
			for k,v in ipairs(site.loot_areas) do
				if not v.harvested then
					DrawMarker(2, v.x, v.y, v.z+0.5, 0, 0, 0, 180.001, 0, 0, 0.2001, 0.2001, 0.2001, 255, 0, 0, 165, 0, 0, 0, 0)

					if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 2.0) then
						if(not IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
							DisplayHelpText("Press ~INPUT_CONTEXT~ to search for grapes")

							if(IsControlJustReleased(1, 51)) then
								tvRP.playAnim(false, {task="WORLD_HUMAN_GARDENER_PLANT"}, false)
								Citizen.Wait(math.random(3000,6000))
								tvRP.stopAnim(false)

								pos = GetEntityCoords(ped, nil)
								if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 4.0) then --allow for some drift, but not too much
									if (math.random(0, 9) > 2) then
										vRPserver.giveGrapes({1}, function(ok) end)
									else
										tvRP.notify("You didn't find anything of value.")
									end
									site.loot_areas[k].harvested = true
								else
									tvRP.notify("You moved too far from the vine.")
								end
							end
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	populateVineyard()
	while true do
		Citizen.Wait(600000)
		local ped = GetPlayerPed(-1)
		local pos = GetEntityCoords(ped, nil)
		if(Vdist(pos.x, pos.y, pos.z, -1814.4682617188, 2187.1625976562, 99.39575958252) < 200) then
			populateVineyard()
		end
	end
end)
