function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local clocked_in = false
local vein_timer = 90
local loot_table = {
	[1] = {"Raw Aluminum","raw_aluminum",2},
	[2] = {"Raw Steel","raw_steel",4},
	[3] = {"Raw Platinum","raw_platinum",8},
}

local function roll_loot()
	local value = math.random(1,10)
	local total_loot = {}

	if value > 2 then
		for k,v in pairs(loot_table) do
			total_loot[k] = {
				['loot_string'] = v[1],
				['loot_item'] = v[2],
				['loot_count'] = math.floor(value/v[3])
			}
		end
	end

	return total_loot
end

local scavenger_sites = {
	{
		['name'] = "Mining Site",
		['x'] = -594.58135986328,
		['y'] = 2089.478515625,
		['z'] = 131.84527282714,
		blip=true,
		loot_areas = {
			{['x'] = -605.13012695312, ['y'] = 2115.6708984375, ['z'] = 127.28966522216, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -552.43225097656, ['y'] = 1995.8129882812, ['z'] = 127.10150146484, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -540.62609863282, ['y'] = 1965.0186767578, ['z'] = 126.82664489746, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -533.7875366211, ['y'] = 1979.8892822266, ['z'] = 126.997756958, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -509.71374511718, ['y'] = 1980.3602294922, ['z'] = 126.1997756958, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -477.1254272461, ['y'] = 1989.7651367188, ['z'] = 123.87867736816, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -452.07864379882, ['y'] = 2005.8422851562, ['z'] = 123.63162994384, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -450.20111083984, ['y'] = 2020.974975586, ['z'] = 123.56898498536, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -451.4468383789, ['y'] = 2054.2749023438, ['z'] = 122.25784301758, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -426.63525390625, ['y'] = 2065.3767089844, ['z'] = 120.36037445068, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -466.69152832032, ['y'] = 2063.2673339844, ['z'] = 120.91313934326, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -471.36987304688, ['y'] = 2077.7106933594, ['z'] = 120.32657623292, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -537.90631103516, ['y'] = 1949.3520507812, ['z'] = 126.122756958, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -537.22216796875, ['y'] = 1917.0107421875, ['z'] = 123.88764190674, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -530.18939208984, ['y'] = 1902.0969238282, ['z'] = 122.99338531494, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -501.52639770508, ['y'] = 1894.6420898438, ['z'] = 121.00284576416, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -486.4859008789, ['y'] = 1893.2423095704, ['z'] = 120.08085632324, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -558.9560546875, ['y'] = 1891.026977539, ['z'] = 123.13256072998, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
			{['x'] = -610.58508300782, ['y'] = 2111.640625, ['z'] = 126.6174545288, ['loot'] = roll_loot(), ['mined'] = false, ['collected'] = false, ['prospected'] = false, ['vein_timer'] = vein_timer},
		}
	}
}

local function miningBlips(type, x, y, z, name)
	local blip = AddBlipForCoord(x, y, z)
	SetBlipSprite(blip, type)
	SetBlipScale(blip, 1.0)
	SetBlipColour(blip,47)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)
end

-- local function tvRP.notify(text)
--   SetNotificationTextEntry("STRING")
--   AddTextComponentString(text)
--   tvRP.notify(false, false)
-- end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for _,site in ipairs(scavenger_sites) do
			for k,v in ipairs(site.loot_areas) do
				if(v.prospected and (not v.mined or v.collected)) then
					if v.vein_timer > 0 then
						v.vein_timer = v.vein_timer - 1
					else
						v.loot = roll_loot()
						v.prospected = false
						v.mined = false
						v.collected = false
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local pos = GetEntityCoords(ped, nil)

		for _,site in ipairs(scavenger_sites) do
			if(Vdist(pos.x, pos.y, pos.z, site.x, site.y, site.z) < 3.0) then
				DrawMarker(2, site.x, site.y, site.z, 0, 0, 0, 180.001, 0, 0, 0.2001, 0.2001, 0.2001, 255, 165, 0, 165, 0, 0, 0, 0)
				if clocked_in then
					DisplayHelpText("Press ~INPUT_CONTEXT~ to punch out of the blast mine.")
				else
					DisplayHelpText("Press ~INPUT_CONTEXT~ to punch in to the blast mine.")
				end

				if(IsControlJustReleased(1, 51)) then
					clocked_in = not clocked_in
				end
			end

			if (clocked_in and Vdist(pos.x, pos.y, pos.z, site.x, site.y, site.z) > 300.0) then
				clocked_in = false
				tvRP.notify("You're too far away from the mine. The supervisor has punched you out.")
			end

			if(clocked_in) then
				for k,v in ipairs(site.loot_areas) do
					DrawMarker(2, v.x, v.y, v.z, 0, 0, 0, 180.001, 0, 0, 0.2001, 0.2001, 0.2001, 142, 5, 255, 165, 0, 0, 0, 0)

					if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 2.0) then
						if(not IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
							if not v.mined and not v.prospected then
								DisplayHelpText("Press ~INPUT_DETONATE~ to prospect the vein, or ~INPUT_CONTEXT~ to place dynamite.")
							elseif not v.mined and v.prospected then
								DisplayHelpText("Press ~INPUT_CONTEXT~ to place dynamite.")
							elseif v.mined and not v.collected then
								DisplayHelpText("Press ~INPUT_CONTEXT~ to search the rubble.")
							end

							if(IsControlJustReleased(1, 47)) then
								if not v.mined and not v.prospected and not v.collected then
									vRPserver.checkPospectingKit({}, function(ok)
										if ok then
											tvRP.playAnim(false, {task="CODE_HUMAN_MEDIC_TEND_TO_DEAD"}, false)
											tvRP.setActionLock(true)
											Citizen.Wait(2500)
											tvRP.stopAnim(false)
											tvRP.setActionLock(false)

											if #v.loot == 0 then
												tvRP.notify("There is nothing of value in this vein.")
											else
												for x,y in pairs(v.loot) do
													if y.loot_count > 0 then
														local content_string = "contains "
														if y.loot_count > 1 then
															content_string = "is rich with "
														end
														tvRP.notify("This vein "..content_string..y.loot_string)
													end
												end
											end
											v.prospected = true
											v.vein_timer = vein_timer
										else
											tvRP.notify("You do not have the tools necessary to check this vein.")
										end
									end)
								end
							end

							if(IsControlJustReleased(1, 51)) then
								if v.mined then
									if v.collected then
										tvRP.notify("This vein has been mined recently. There's nothing valuable here!")
									else
										if #v.loot == 0 then
											tvRP.notify("You find only rocks in the blast debris.")
										else
											tvRP.playAnim(false, {task="CODE_HUMAN_MEDIC_TEND_TO_DEAD"}, false)
											tvRP.setActionLock(true)
											Citizen.Wait(2500)
											tvRP.stopAnim(false)
											tvRP.setActionLock(false)

											for x,y in pairs(v.loot) do
												if y.loot_count > 0 then
													--tvRP.notify("Collected "..y.loot_count .." ".. y.loot_item)
													vRPserver.giveMetals({y.loot_item, y.loot_count})
												end
											end
										end
										v.collected = true
									end
								else
									vRPserver.checkDynamite({}, function(ok)
										if ok then
											tvRP.playAnim(false, {task="CODE_HUMAN_MEDIC_TEND_TO_DEAD"}, false)
											tvRP.setActionLock(true)
											Citizen.Wait(5000)
											tvRP.stopAnim(false)
											tvRP.setActionLock(false)

											local loot = 100
											tvRP.notify("The dynamite has been lit. Get to safety!")
											Citizen.Wait(math.random(7000,10000))
											AddOwnedExplosion(ped, v.x, v.y, v.z, 0, 0.0651, true, false, 0.5)
											v.prospected = true
											v.mined = true
											v.vein_timer = vein_timer*2
										else
											tvRP.notify("You don't have any dynamite!")
										end
									end)
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
			miningBlips(436, v.x, v.y, v.z, v.name)
		end
	end
end)
