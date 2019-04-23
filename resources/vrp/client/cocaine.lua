--[[
	-- Filename: cocaine.lua
	-- Author: speed
	-- Description: Serves as a method to allow processing cocaine
	--              Lob equipment must be maintained to produce quality cocaine
	--              0 errors = pure cocaine, 1 error = poor quality cocaine
	--              2+ errors = no cocaine
	--              Heat: 10,000-50,000
	--              Acid: 2pH-7pH
]]--
local taskInProgress = false
local labPowerEnabled = true

local units = {
	["heat"] = 0,
	["coca_paste"] = 0,
	["final_product"] = 0,
	["inv_acid"] = 0,
	["tank_acid"] = 7,
	["processing_on"] = 0,
}

local final_product = {
	["pure"] = 0,
	["poor"] = 0
}

local function taskAnimation()
	Citizen.CreateThread(function()
		taskInProgress = true
		local animation = {true,{{"mp_common","givetake2_a",1}},false}
		tvRP.playAnim(animation[1],animation[2],animation[3])
		tvRP.setActionLock(true)
		Citizen.Wait(2000)
		tvRP.stopAnim(animation[1])
		tvRP.setActionLock(false)
		taskInProgress = false
	end)
end

local function addUnit(unit,increment)
	if not taskInProgress then
		if unit == "tank_acid" then
			if units["inv_acid"] > 0 and units["tank_acid"] > increment then
				taskAnimation()
				units["inv_acid"] = units["inv_acid"] - increment
				units["tank_acid"] = units["tank_acid"] - increment
			end
		elseif units[unit] < increment*5 then
			if unit == "coca_paste" then
				vRPserver.hasCocaPaste({}, function(ok)
					if ok then
						taskAnimation()
						units["coca_paste"] = units["coca_paste"]+1
					else
						tvRP.notify("You do not have any Coca Paste.")
					end
				end)
			else
				taskAnimation()
				units[unit] = units[unit]+increment
			end
		end
	end
end

local function takeFinalProduct()
	if units["final_product"] > 0 then
		taskAnimation()
		vRPserver.giveCocaine({"cocaine_pure",final_product["pure"]})
		vRPserver.giveCocaine({"cocaine_poor",final_product["poor"]})
		final_product["pure"] = 0
		final_product["poor"] = 0
	end
end

local function mixCement()
	if not taskInProgress then
		vRPserver.hasCocaPasteIngredients({}, function(ok)
			if ok then
				taskAnimation()
				vRPserver.mixCocaPasteIngredients({})
			else
				tvRP.notify("You do not have the ingredients to make Coca Paste")
			end
		end)
	end
end

local function cleanLab()
	taskAnimation()
	vRPserver.broadcastCleanLab({}, function(ok)
		tvRP.notify("You have cleaned the lab.")
	end)
end

function tvRP.setCocaineLabPowerStatus(status)
	labPowerEnabled = status
	if not status then
		units["processing_on"] = 0
	end
end

function tvRP.cleanCocaineLab()
	final_product = {
		["pure"] = 0,
		["poor"] = 0
	}

	units = {
		["heat"] = 0,
		["coca_paste"] = 0,
		["final_product"] = 0,
		["inv_acid"] = 0,
		["tank_acid"] = 7,
		["processing_on"] = 0,
	}
end

local function toggleLabPower()
	taskAnimation()
	if labPowerEnabled == true then
		vRPserver.broadcastCocaineLabPowerStatus({false})
	else
		vRPserver.broadcastCocaineLabPowerStatus({true})
	end
end

local function toggleProcessing()
	taskAnimation()
	if units["processing_on"] == 0 then
		vRPserver.setPlayersProcessing({1})
		units["processing_on"] = 1
	else
		vRPserver.setPlayersProcessing({-1})
		units["processing_on"] = 0
	end
end

local function produceCocaine()
	local errors = 0
	if units["coca_paste"] == 0 then
		tvRP.notify("The machine does not have any Coca Paste to process.")
		return
	elseif units["tank_acid"] < 2 then
		tvRP.notify("The solution is too acidic.")
		errors = errors + 1
	elseif units["tank_acid"] > 7 then
		tvRP.notify("The solution is too basic.")
		errors = errors + 1
	elseif units["heat"] > 50000 then
		tvRP.notify("The solution is too hot.")
		errors = errors + 1
	elseif units["heat"] < 10000 then
		tvRP.notify("The solution is too cold.")
		errors = errors + 1
	end

	units["coca_paste"] = units["coca_paste"] - 1
	if errors == 0 then
		tvRP.notify("Produced pure cocaine")
		final_product["pure"] = final_product["pure"] + 1
	elseif errors == 1 then
		tvRP.notify("Produced poor cocaine")
		final_product["poor"] = final_product["poor"] + 1
	else
		tvRP.notify("The Cocaine was ruined.")
	end
end

local tasks = {
	[1] = {
		pos = {1004.168762207,-3197.1284179688,-38.497283935546},
		description = "Mix Cement/Coca",
		action = mixCement,
		unit = nil,
		unit_increment = nil
	},
	[2] = {
		pos = {1005.7363891602,-3200.8513183594,-38.21455001831},
		description = "Add Coca Paste",
		action = addUnit,
		unit = "coca_paste",
		unit_increment = 1
	},
	[3] = {
		pos = {1001.8896484375,-3200.1564941406,-38.461650848388},
		description = "Apply Heat",
		action = addUnit,
		unit = "heat",
		unit_increment = 10000
	},
	[4] = {
		pos = {1007.881652832,-3194.3879394532,-38.748378753662},
		description = "Collect Final Product",
		action = takeFinalProduct,
		unit = "final_product",
		unit_increment = 1
	},
	[5] = {
		pos = {1012.7533569336,-3197.41796875,-38.876686096192},
		description = "Reduce pH",
		action = addUnit,
		unit = "tank_acid",
		unit_increment = 1
	},
	[6] = {
		pos = {997.18872070312,-3198.0571777344,-38.809692382812},
		description = "Collect Acid",
		action = addUnit,
		unit = "inv_acid",
		unit_increment = 2
	},
	[7] = {
		pos = {1010.4819335938,-3199.3413085938,-38.006893157958},
		description = "Turn Processing On/Off",
		action = toggleProcessing,
		unit = "processing_on",
		unit_increment = 0
	},
	[8] = {
		pos = {-1134.2368164062,4960.1538085938,226.24388122558},
		description = "Turn Power On/Off",
		action = toggleLabPower,
		unit = "power",
		unit_increment = nil
	}
}

local tasks_cop = {
	[8] = {
		pos = {-1134.2368164062,4960.1538085938,226.24388122558},
		description = "Turn Power On/Off",
		action = toggleLabPower,
		unit = "power",
		unit_increment = nil
	},
	[100] = {
		pos = {1007.881652832,-3194.3879394532,-38.748378753662},
		description = "Clean Lab Equipment",
		action = cleanLab,
		unit = nil,
		unit_increment = nil
	}
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local t_tasks = tasks
		if(tvRP.isCop()) then
			t_tasks = tasks_cop
		end

		units["final_product"] = final_product["pure"] + final_product["poor"]
		-- Skill Check, reduce lab resources over time
		if units["tank_acid"] < 14 then
			units["tank_acid"] = units["tank_acid"] + 0.0004
		end
		if units["heat"] > 0 then
			units["heat"] = units["heat"] - 2
		end

		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
		if Vdist(x,y,z,1004.168762207,-3197.1284179688,-37.497283935546) < 20 or Vdist(x,y,z,-1134.2368164062,4960.1538085938,226.24388122558) <= 2 then
			for k,task in pairs(t_tasks) do
				local distance = Vdist(x,y,z,task.pos[1],task.pos[2],task.pos[3])
				if distance <= 2 then
					if not taskInProgress then
						DisplayHelpText("Press ~INPUT_CONTEXT~ to "..task.description)
					end
					if task.unit_increment == nil then
						if task.unit == "power" then
							if labPowerEnabled == true then
								tvRP.DrawText3d(task.pos[1],task.pos[2],task.pos[3],task.description,0.35,0,255,0)
							else
								tvRP.DrawText3d(task.pos[1],task.pos[2],task.pos[3],task.description,0.35,255,0,0)
							end
						else
							tvRP.DrawText3d(task.pos[1],task.pos[2],task.pos[3],task.description,0.35)
						end
					else
						tvRP.DrawText3d(task.pos[1],task.pos[2],task.pos[3],task.description.." ("..units[task.unit]..")",0.35)
					end
					if IsControlJustReleased(1, 51) then
						task.action(task.unit,task.unit_increment)
					end
				end
			end
		else
			if units["processing_on"] == 1 then
				vRPserver.setPlayersProcessing({-1})
				units["processing_on"] = 0
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30000)
		if units["processing_on"] == 1 then
			if labPowerEnabled == true then
				produceCocaine()
			else
				tvRP.notify("The lab's power has been disabled! Fix it!")
			end
		end
	end
end)
