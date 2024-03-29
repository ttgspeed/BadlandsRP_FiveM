local items = {}

local smoking_props = {
	"prop_cs_ciggy_01",
	"prop_sh_joint_01",
	"prop_cs_meth_pipe"
}

local function play_drink(player)
  local seq = {
    {"mp_player_intdrink","intro_bottle",1},
    {"mp_player_intdrink","loop_bottle",5},
    {"mp_player_intdrink","outro_bottle",1}
  }

  vRPclient.playAnim(player,{true,seq,false})
	vRPclient.setActionLock(player,{true})
	SetTimeout(5000,function()
		vRPclient.setActionLock(player,{false})
	end)
end

local function smoke_cig(player)
	local seq = {
		{"amb@world_human_smoking@male@male_a@enter","enter",1},
		{"amb@world_human_smoking@male@male_a@base","base",5},
		{"amb@world_human_smoking@male@male_a@exit","exit",1},
	}
	vRPclient.attachProp(player,{'prop_cs_ciggy_01',28422,0,0,0,0,0,0})
	vRPclient.playAnim(player,{true,seq,false})
	vRPclient.setActionLock(player,{true})
	SetTimeout(10000,function()
		vRPclient.setActionLock(player,{false})
	end)
	SetTimeout(60*1000,function()
		vRPclient.deleteProp(player,{'prop_cs_ciggy_01'})
	end)
	local count = 50
	local function reduceHunger()
		if count >= 0 then
			count = count - 1
			local user_id = vRP.getUserId(player)
			if user_id ~= nil then
				vRP.varyHunger(user_id, -1)
			end
			SetTimeout(1200,reduceHunger)
		end
	end
	reduceHunger()
end

local function eat_pod(player)
	local seq = {
		{"mp_player_inteat@burger", "mp_player_int_eat_burger_enter",1},
		{"mp_player_inteat@burger", "mp_player_int_eat_burger",1},
		{"mp_player_inteat@burger", "mp_player_int_eat_burger_fp",1},
		{"mp_player_inteat@burger", "mp_player_int_eat_exit_burger",1}
	}

	vRPclient.playAnim(player,{true,seq,false})
	local timeout = math.random(60,120)
	SetTimeout(timeout*1000,function()
		local die = math.random(1,2)
		if die == 1 then
			vRPclient.varyHealth(player,{-125})
		end
	end)

	local count = 50
	local function reduceHunger()
		if count >= 0 then
			count = count - 1
			local user_id = vRP.getUserId(player)
			if user_id ~= nil then
				vRP.varyHunger(user_id, -1)
			end
			SetTimeout(1200,reduceHunger)
		end
	end
	reduceHunger()
end

local function eat_cookie(player)
	local seq = {
		{"mp_player_inteat@burger", "mp_player_int_eat_burger_enter",1},
		{"mp_player_inteat@burger", "mp_player_int_eat_burger",1},
		{"mp_player_inteat@burger", "mp_player_int_eat_burger_fp",1},
		{"mp_player_inteat@burger", "mp_player_int_eat_exit_burger",1}
	}

	vRPclient.playAnim(player,{true,seq,false})
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRP.varyHunger(user_id,-25)
	end
	local timeout = math.random(60,120)
	local count = 75

	local function reduceThirst()
		if count >= 0 then
			count = count - 1
			local user_id = vRP.getUserId(player)
			if user_id ~= nil then
				vRP.varyThirst(user_id, -1)
			end
			SetTimeout(1200,reduceThirst)
		end
	end

	SetTimeout(timeout*1000,function()
		local shit = math.random(1,2)
		if shit == 1 then
			TriggerClientEvent("CustomScripts:pooInit", player)
			reduceThirst()
		end
	end)
end

local function snort_coke(player)
	local seq = {
		{"missfbi3_party","snort_coke_b_male3",1},
	}
	vRPclient.playAnim(player,{true,seq,false})
	vRPclient.setActionLock(player,{true})
	vRPclient.forceWalk(player,{true})
	SetTimeout(10000,function()
		vRPclient.setActionLock(player,{false})
		vRPclient.forceWalk(player,{false})
		vRPclient.setArmour(player,{25})
	end)
end

local function smoke_weed(player)
	local seq = {
		{"amb@world_human_smoking@male@male_a@enter","enter",1},
		--{"timetable@gardener@smoking_joint", "smoke_idle", 1}, --doesn't work with prop
		{"amb@world_human_smoking@male@male_a@base","base",1},
		{"timetable@gardener@smoking_joint", "idle_cough", 1},
		{"amb@world_human_smoking@male@male_a@base","base",1},
		{"timetable@gardener@smoking_joint", "idle_cough", 1},
		{"amb@world_human_smoking@male@male_a@base","base",1},
		{"amb@world_human_smoking@male@male_a@exit","exit",1},
		{"timetable@gardener@smoking_joint", "idle_cough", 1},
	}
	vRPclient.attachProp(player,{'prop_sh_joint_01',28422,0,0,0,0,0,0})
	vRPclient.playAnim(player,{true,seq,false})
	vRPclient.setActionLock(player,{true})
	vRPclient.playScreenEffect(player, {"DMT_flight", 60})
	SetTimeout(10000,function()
		vRPclient.setActionLock(player,{false})
	end)
	SetTimeout(60*1000,function()
		vRPclient.deleteProp(player,{'prop_sh_joint_01'})
		--missfbi3_party snort_coke_b_male3 1
	end)
	vRPclient.varyHealthOverTime(player,{50,60})
end

local function smoke_meth(player)
	local seq = {
		{"timetable@ron@ig_4_smoking_meth", "chefiscookingup", 1},
		{"timetable@ron@ig_4_smoking_meth", "onemorehit", 1},
		{"timetable@ron@ig_4_smoking_meth", "base", 1},
	}

	vRPclient.attachProp(player,{'prop_cs_meth_pipe',28422,0,0,0,0,0,0})
	vRPclient.playAnim(player,{true,seq,false})
	vRPclient.setActionLock(player,{true})
	vRPclient.forceWalk(player,{true})
	SetTimeout(10000,function()
		vRPclient.setActionLock(player,{false})
		vRPclient.forceWalk(player,{false})
		vRPclient.increaseRunSpeed(player)
	end)
	SetTimeout(60*1000,function()
		vRPclient.deleteProp(player,{'prop_cs_meth_pipe'})
	end)
end

-- CONSUMABLE ITEMS (ADDICTION)

local pills_choices = {}
pills_choices["Consume"] = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    if vRP.tryGetInventoryItem(user_id,"pills",1) then
      vRPclient.varyHealthOverTime(player,{60,120})
      vRPclient.notify(player,{"Taking pills."})
      play_drink(player)
			vRP.addAddiction(player, "pills")
      vRP.closeMenu(player)
    end
  end
end}

local weed_choices = {}
weed_choices["Smoke"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRPclient.getCurrentProps(player,{},function(props)
			for k,v in pairs(smoking_props) do
				if props[v] ~= nil then
					vRPclient.notify(player,{"You are already smoking."})
					return
				end
			end
			if vRP.tryGetInventoryItem(user_id,"weed",1) then
				vRPclient.notify(player,{"Smoking weed."})
				smoke_weed(player)
				vRP.addAddiction(player, "weed")
				vRP.closeMenu(player)
			end
		end)
	end
end,"",1}

local weed_choices2 = {}
weed_choices2["Smoke"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRPclient.getCurrentProps(player,{},function(props)
			for k,v in pairs(smoking_props) do
				if props[v] ~= nil then
					vRPclient.notify(player,{"You are already smoking."})
					return
				end
			end
			if vRP.tryGetInventoryItem(user_id,"weed2",1) then
				vRPclient.notify(player,{"Smoking weed."})
				smoke_weed(player)
				vRP.addAddiction(player, "weed")
				vRP.closeMenu(player)
			end
		end)
	end
end,"",1}

local cocaine_choices = {}
cocaine_choices["Consume"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		if vRP.tryGetInventoryItem(user_id,"cocaine_pure",1) then
			vRPclient.notify(player,{"Snorting Cocaine."})
			vRP.addAddiction(player, "cocaine")
			snort_coke(player)
			vRP.closeMenu(player)
		end
	end
end,"",1}

local cocaine_choices2 = {}
cocaine_choices2["Consume"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		if vRP.tryGetInventoryItem(user_id,"cocaine_poor",1) then
			vRPclient.notify(player,{"Snorting Crack Cocaine."})
			snort_coke(player)
			vRP.addAddiction(player, "cocaine")
			vRP.closeMenu(player)
		end
	end
end,"",1}

local meth_choices = {}
meth_choices["Smoke"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRPclient.getCurrentProps(player,{},function(props)
			for k,v in pairs(smoking_props) do
				if props[v] ~= nil then
					vRPclient.notify(player,{"You are already smoking."})
					return
				end
			end
			if vRP.tryGetInventoryItem(user_id,"meth",1) then
				vRPclient.notify(player,{"Smoking meth."})
				smoke_meth(player)
				vRP.addAddiction(player, "meth")
				vRP.closeMenu(player)
			end
		end)
	end
end,"",1}

-- REGULAR ITEMS

local cig_choices = {}
cig_choices["Smoke"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRPclient.getCurrentProps(player,{},function(props)
			for k,v in pairs(smoking_props) do
				if props[v] ~= nil then
					vRPclient.notify(player,{"You are already smoking."})
					return
				end
			end
			if vRP.tryGetInventoryItem(user_id,"cigarette",1) then
				vRPclient.notify(player,{"Smoking cigarette."})
				smoke_cig(player)
				vRP.closeMenu(player)
			elseif vRP.tryGetInventoryItem(user_id,"cigar",1) then
				vRPclient.notify(player,{"Smoking cigar."})
				smoke_cig(player)
				vRP.closeMenu(player)
			end
		end)
	end
end,"",1}

local pod_choices = {}
pod_choices["Eat"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		if vRP.tryGetInventoryItem(user_id,"tidalpod",1) then
			vRPclient.notify(player,{"Eating Tidal Pod"})
			eat_pod(player)
			vRP.closeMenu(player)
		end
	end
end,"",1}

local cookie_choices = {}
cookie_choices["Eat"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		if vRP.tryGetInventoryItem(user_id,"cookie",1) then
			vRPclient.notify(player,{"Eating 'Cookie'"})
			eat_cookie(player)
			vRP.closeMenu(player)
		end
	end
end,"",1}

local cannibis_choices = {}
cannibis_choices["Plant"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	local player = vRP.getUserSource(user_id)
	if user_id ~= nil then
		vRPclient.isFarming(player,{},function(farming)
			if not farming then
				iZoneClient.isPlayerInAnyZone(player, {}, function(cb)
					if cb ~= nil then
						if vRP.tryGetInventoryItem(user_id,"cannabis_seed",1) then
							vRPclient.startWeedGrowth(player,{})
							vRP.closeMenu(player)
						end
					else
						vRPclient.notify(player,{"The soil is no good here"})
					end
				end)

			else
				vRPclient.notify(player,{"You are already cultivating a plant"})
			end
		end)
	end
end,"",1}

local meth_kit_choices = {}
meth_kit_choices["Set Up"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRPclient.getNearestOwnedVehicle(player,{3},function(ok,vtype,name)
			if ok then
				vRPclient.getOwnedVehicleId(player,{name},function(ok,vehicleId)
					if ok then
						if vRP.tryGetInventoryItem(user_id,"meth_kit",1) then
							tvRP.addMethLab(vehicleId,name,user_id)
						end
					end
				end)
			else
				vRPclient.notify(player,{"You must be in or near a suitable vehicle to use this."})
			end
		end)
	end
end,"",1}

local taco_kit_choices = {}
taco_kit_choices["Set Up"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRPclient.getNearestOwnedVehicle(player,{3},function(ok,vtype,name)
			if ok then
				vRPclient.getOwnedVehicleId(player,{name},function(ok,vehicleId)
					if ok then
						if vRP.tryGetInventoryItem(user_id,"taco_kit",1) then
							tvRP.addtacoLab(vehicleId,name,user_id)
						end
					end
				end)
			else
				vRPclient.notify(player,{"You must be in or near a suitable vehicle to use this."})
			end
		end)
	end
end,"",1}

items["pills"] = {"Pills","A simple healing medication.",function(args) return pills_choices end,0.1}
items["weed"] = {"Kifflom Kush Joint", "It's 'medicinal'",function(args) return weed_choices end, 0.5}
items["weed2"] = {"Serpickle Berry Joint", "It's 'medicinal'",function(args) return weed_choices2 end, 0.5}
items["meth"] = {"Meth", "",function(args) return meth_choices end, 0.5}
items["cocaine_pure"] = {"Pure Cocaine", "High quality cocaine made by a skilled chemist.",function(args) return cocaine_choices end,0.5}
items["cocaine_poor"] = {"Crack Cocaine", "Low quality cocaine made by some junkie in a rat infested lab.",function(args) return cocaine_choices2 end,0.5}

items["cigarette"] = {"Cigarette","A small cylinder of finely cut tobacco leaves rolled in thin paper for smoking.",function(args) return cig_choices end,0.1}
items["tidalpod"] = {"Tidal Pod","A delicious snack perfect for any occasion.",function(args) return pod_choices end,0.1}
items["cookie"] = {"Cookie","A tasty baked good. Nothing else.",function(args) return cookie_choices end,0.1}
items["cigar"] = {"Cigarro Florentina","Incorporates the tobacco leaf 'Belleza Florentina', which offers exceptional character and style.",function(args) return cig_choices end,0.1}

items["cannabis_seed"] = {"Cannabis Seed", "",function(args) return cannibis_choices end, 0.5}
items["meth_kit"] = {"Mobile Meth Lab Kit", "Converts your vehicle into a mobile meth lab. Must be used on a large camper type vehicle.",function(args) return meth_kit_choices end,5.0}
items["taco_kit"] = {"Mobile Taco Truck Kit", "Contains various tools and ingredients that you will need to run a food truck.",function(args) return taco_kit_choices end,5.0}

--cocaine
items["coca_leaves"] = {"Coca Leaves", "Coca is known throughout the world for its psychoactive alkaloid, cocaine.",function(args) end,0.2}
items["cement"] = {"Cement Powder", "Cement Powder is often used in the production of Cocaine. But surely that's not what you're doing.",function(args) end,0.5}
items["coca_paste"] = {"Coca Paste", "Can be processed into cocaine hydrochloride (street cocaine) for consumption.",function(args) end,0.5}

return items
