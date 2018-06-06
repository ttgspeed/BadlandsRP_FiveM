local Keys = {["E"] = 38,["ENTER"] = 18}
local scuba = false
local scubaTimer = 0
local emergencyCalled = false
local inWater = false

loot_tables = {
	[1] = { --loot_low
		{"old_boot",0},
		{"gold_ingot",30},
		{"sapphire",65},
		{"ruby",80},
		{"diamond",90}
	},
	[2] = { --loot_standard
		{"old_boot",0},
		{"sapphire",20},
		{"ruby",40},
		{"gold_coin",65},
		{"diamond",80},
		{"common_artifact",90}
	},
	[3] = { --loot_high
		{"old_boot",0},
		{"ruby",10},
		{"gold_coin",20},
		{"diamond",40},
		{"lockpick", 65},
		{"common_artifact",80},
		{"rare_artifact",95}
	}
}

local scavenger_sites = {
	{
		['name'] = "Zancudo Wreck",
		['x'] = -3247.0710449218,
		['y'] = 3669.3110351562,
		['z'] = -29.526594161988,
		blip=true,
		loot_areas = {
			{['x'] = -3215.3659667968, ['y'] = 3675.7878417968, ['z'] = -35.200984954834, ['loot'] = 100},
			{['x'] = -3232.5180664062, ['y'] = 3672.1611328125, ['z'] = -39.711307525634, ['loot'] = 100},
			{['x'] = -3289.5715332032, ['y'] = 3680.3266601562, ['z'] = -77.79379272461, ['loot'] = 100},
			{['x'] = -3277.412109375, ['y'] = 3690.6215820312, ['z'] = -86.751510620118, ['loot'] = 100},
			{['x'] = -3248.3337402344, ['y'] = 3670.4443359375, ['z'] = -33.208415985108, ['loot'] = 100},
			{['x'] = -3223.7502441406, ['y'] = 3665.8706054688, ['z'] = -25.03459739685, ['loot'] = 100},
			{['x'] = -3254.0036621094, ['y'] = 3664.3708496094, ['z'] = -36.467102050782, ['loot'] = 100},
			{['x'] = -3261.1240234375, ['y'] = 3659.7255859375, ['z'] = -25.957704544068, ['loot'] = 100}
		},
		loot_table = loot_tables[2]
	},
	{
		['name'] = "Container Wreck",
		['x'] = 3183.4418945312,
		['y'] = -361.28912353516,
		['z'] = -11.00293636322,
		blip=true,
		loot_areas = {
			{['x'] = 3207.2609863282, ['y'] = -391.32626342774, ['z'] = -38.413219451904, ['loot'] = 100},
			{['x'] = 3193.6428222656, ['y'] = -382.86154174804, ['z'] = -30.221769332886, ['loot'] = 100},
			{['x'] = 3195.8195800782, ['y'] = -397.16723632812, ['z'] = -28.610401153564, ['loot'] = 100},
			{['x'] = 3167.650390625, ['y'] = -293.7328491211, ['z'] = -10.319995880126, ['loot'] = 100},
			{['x'] = 3156.6223144532, ['y'] = -267.15985107422, ['z'] = -28.306385040284, ['loot'] = 100},
			{['x'] = 3137.8610839844, ['y'] = -258.17071533204, ['z'] = -25.308557510376, ['loot'] = 100},
			{['x'] = 3163.482421875, ['y'] = -254.67645263672, ['z'] = -27.6222782135, ['loot'] = 100},
			{['x'] = 3172.6198730468, ['y'] = -290.78652954102, ['z'] = -13.870177268982, ['loot'] = 100},
			{['x'] = 3165.7338867188, ['y'] = -318.2375793457, ['z'] = -10.5552444458, ['loot'] = 100},
			{['x'] = 3195.4091796875, ['y'] = -377.40832519532, ['z'] = -33.975723266602, ['loot'] = 100},
			{['x'] = 3209.1076660156, ['y'] = -415.45278930664, ['z'] = -32.152660369874, ['loot'] = 100},
			{['x'] = 3219.2026367188, ['y'] = -404.5541381836, ['z'] = -46.944004058838, ['loot'] = 100},
			{['x'] = 3200.0476074218, ['y'] = -366.86737060546, ['z'] = -33.725151062012, ['loot'] = 100},
			{['x'] = 3169.0236816406, ['y'] = -343.11904907226, ['z'] = -29.81350326538, ['loot'] = 100},
			{['x'] = 3173.4265136718, ['y'] = -320.17956542968, ['z'] = -28.761131286622, ['loot'] = 100},
			{['x'] = 3129.7512207032, ['y'] = -340.76181030274, ['z'] = -24.133726119996, ['loot'] = 100},
		},
		loot_table = loot_tables[2]
	},
	{
		['name'] = "Steam Boat Wreck",
		['x'] = 2677.6032714844,
		['y'] = -1408.2863769532,
		['z'] = -21.013612747192,
		blip=true,
		loot_areas = {
			{['x'] = 2691.2463378906, ['y'] = -1385.3845214844, ['z'] = -21.829778671264, ['loot'] = 100},
			{['x'] = 2670.353515625, ['y'] = -1380.0208740234, ['z'] = -21.986042022706, ['loot'] = 100},
			{['x'] = 2646.2468261718, ['y'] = -1386.1373291016, ['z'] = -19.171964645386, ['loot'] = 100},
			{['x'] = 2643.92578125, ['y'] = -1402.7541503906, ['z'] = -19.711267471314, ['loot'] = 100},
			{['x'] = 2654.1127929688, ['y'] = -1421.2440185546, ['z'] = -23.166038513184, ['loot'] = 100},
			{['x'] = 2684.8908691406, ['y'] = -1398.2955322266, ['z'] = -14.716472625732, ['loot'] = 100}
		},
		loot_table = loot_tables[2]
	},
	{
		['name'] = "Duster Wreck",
		['x'] = 3270.4384765625,
		['y'] = 6412.0546875,
		['z'] = -45.419631958008,
		blip=true,
		loot_areas = {
			{['x'] = 3244.8005371094, ['y'] = 6413.2387695312, ['z'] = -44.566799163818, ['loot'] = 100},
			{['x'] = 3263.458984375, ['y'] = 6408.3994140625, ['z'] = -48.511054992676, ['loot'] = 100},
			{['x'] = 3274.7927246094, ['y'] = 6412.6059570312, ['z'] = -50.244007110596, ['loot'] = 100},
			{['x'] = 3265.4609375, ['y'] = 6412.7524414062, ['z'] = -46.54955291748, ['loot'] = 100}
		},
		loot_table = loot_tables[2]
	},
	{
		['name'] = "Chianski Passage Military Wreck",
		['x'] = 4234.525390625,
		['y'] = 3595.55859375,
		['z'] = -41.943134307862,
		blip=true,
		loot_areas = {
			{['x'] = 4164.7241210938, ['y'] = 3664.7744140625, ['z'] = -39.021915435792, ['loot'] = 100},
			{['x'] = 4203.1420898438, ['y'] = 3641.3303222656, ['z'] = -43.068531036376, ['loot'] = 100},
			{['x'] = 4234.6240234375, ['y'] = 3596.2114257812, ['z'] = -47.248600006104, ['loot'] = 100},
			{['x'] = 4147.1108398438, ['y'] = 3575.8283691406, ['z'] = -42.313167572022, ['loot'] = 100},
			{['x'] = 4184.5522460938, ['y'] = 3572.0109863282, ['z'] = -55.011142730712, ['loot'] = 100},
			{['x'] = 4171.4228515625, ['y'] = 3527.6315917968, ['z'] = -48.243412017822, ['loot'] = 100},
			{['x'] = 4130.2514648438, ['y'] = 3528.6352539062, ['z'] = -27.923803329468, ['loot'] = 100},
			{['x'] = 4140.0947265625, ['y'] = 3585.1284179688, ['z'] = -43.58293914795, ['loot'] = 100}
		},
		loot_table = loot_tables[2]
	},
	{
		['name'] = "Procopio Passenger Plane Wreck",
		['x'] = -909.99615478516,
		['y'] = 6644.2412109375,
		['z'] = -32.975040435792,
		blip=true,
		loot_areas = {
			{['x'] = -913.67834472656, ['y'] = 6677.6127929688, ['z'] = -36.37589263916, ['loot'] = 100},
			{['x'] = -910.60614013672, ['y'] = 6668.61328125, ['z'] = -31.289211273194, ['loot'] = 100},
			{['x'] = -917.73400878906, ['y'] = 6622.4047851562, ['z'] = -31.435899734498, ['loot'] = 100},
			{['x'] = -936.55151367188, ['y'] = 6635.1494140625, ['z'] = -33.768325805664, ['loot'] = 100},
			{['x'] = -945.23559570312, ['y'] = 6689.2475585938, ['z'] = -39.868793487548, ['loot'] = 100},
			{['x'] = -986.93634033204, ['y'] = 6694.5971679688, ['z'] = -40.458282470704, ['loot'] = 100},
		},
		loot_table = loot_tables[2]
	},
}

function roll_loot(loot_table)
	local roll = math.random(0,100)
	local currentmax = -1
	local loot = nil

	for k,v in pairs(loot_table) do
		if(roll > v[2] and v[2] > currentmax) then
			currentmax = v[2]
			loot = v[1]
		end
	end

	return loot
end

function tvRP.start_scuba()
	scuba = true
	scubaTimer = 900
	tvRP.notify("You have 15 minutes of air remaining")
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for _,site in ipairs(scavenger_sites) do
			for k,v in ipairs(site.loot_areas) do
				if(v.loot < 100) then
					v.loot = v.loot + 0.5
				end
			end
		end
		if(scuba and scubaTimer > 0) then
			if(tvRP.isInWater()) then
				if not inWater then
					tvRP.attachProp('p_s_scuba_tank_s',24818,-0.290001,-0.240001,0,180.000001,90.000001,0,true)
					tvRP.attachProp('p_d_scuba_mask_s',31086,0,0,0,180.000001,90.000001,0,true)
					inWater = true
				end
				scubaTimer = scubaTimer - 1
				if(scubaTimer < 10 or scubaTimer == 30 or (scubaTimer <= 180 and math.fmod(scubaTimer,60) == 0)) then
					local hScubaTimer = ""
					if (math.fmod(scubaTimer,60) == 0) then
						hScubaTimer = math.floor((scubaTimer/60)).." minutes"
					else
						hScubaTimer = scubaTimer.." seconds"
					end
					tvRP.notify("You have "..hScubaTimer.." of air remaining")
				end
			else
				if inWater then
					tvRP.deleteProp('p_s_scuba_tank_s')
					tvRP.deleteProp('p_d_scuba_mask_s')
					inWater = false
				end
			end
		else
			if(scuba) then
				scuba = false
				tvRP.deleteProp('p_s_scuba_tank_s')
				tvRP.deleteProp('p_d_scuba_mask_s')
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		for _,site in ipairs(scavenger_sites) do
			site.loot_table = loot_tables[math.random(1,#loot_tables)]
		end
		Citizen.Wait(18000000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local pos = GetEntityCoords(ped, nil)
		if tvRP.isPedInCar() then
			SetPedDiesInWater(ped, true)
		else
			SetPedDiesInWater(ped, not scuba)
		end

		-- if not emergencyCalled and not scuba then
		-- 	DisplayHelpText("~w~Press ~g~E~w~ to scuba")
		-- 	if (IsControlJustReleased(1, Keys['E'])) then
		-- 		tvRP.start_scuba()
		-- 		emergencyCalled = true
		-- 		SetTimeout(5 * 1000, function()
		-- 			emergencyCalled = false
		-- 		end)
		-- 	end
		-- end

		if scuba then
			for _,site in ipairs(scavenger_sites) do
				if(Vdist(pos.x, pos.y, pos.z, site.x, site.y, site.z) < 100.0) then
					--
					for k,v in ipairs(site.loot_areas) do
						DrawMarker(2, v.x, v.y, v.z, 0, 0, 0, 180.001, 0, 0, 0.2001, 0.2001, 0.2001, 255, 165, 0, 165, 0, 0, 0, 0)

						if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 2.0) then
							if(not IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
								DisplayHelpText("Press ~INPUT_CONTEXT~ to search for treasure")

								if(IsControlJustReleased(1, 51)) then
									local loot = math.floor(v.loot)
									tvRP.notify("Searching for treasure...")
									Citizen.Wait(math.random(5000,10000))

									pos = GetEntityCoords(ped, nil)
									if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 4.0) then --allow for some drift, but not too much
										if (math.random(0, loot) > 30) then
											local loot_item = roll_loot(site.loot_table)
											vRPserver.give_loot({loot_item})
											v.loot = loot - 30
										else
											tvRP.notify("You didn't find anything of value.")
										end
									else
										tvRP.notify("You drifted too far from the digsite, and found nothing")
									end
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
	for k,v in ipairs(scavenger_sites) do
		if v.blip then
			TriggerEvent('scuba:createBlip', 161, v.x, v.y, v.z, v.name)
		end
	end
end)

RegisterNetEvent("scuba:createBlip")
AddEventHandler("scuba:createBlip", function(type, x, y, z, name)
	local blip = AddBlipForCoord(x, y, z)
	SetBlipSprite(blip, type)
	SetBlipScale(blip, 0.4)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)
end)
