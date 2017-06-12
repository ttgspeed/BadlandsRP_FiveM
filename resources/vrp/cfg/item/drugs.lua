
local items = {}

local function play_drink(player)
  local seq = {
    {"mp_player_intdrink","intro_bottle",1},
    {"mp_player_intdrink","loop_bottle",1},
    {"mp_player_intdrink","outro_bottle",1}
  }

  vRPclient.playAnim(player,{true,seq,false})
end

local function smoke(player)
	local seq = {
		{"amb@world_human_smoking@male@male_a@enter","enter",1},		
		{"amb@world_human_smoking@male@male_a@base","base",5},
		{"amb@world_human_smoking@male@male_a@exit","exit",1},		
	}
	
	vRPclient.attachProp(player,{'prop_cs_ciggy_01',28422,0,0,0,0,0,0})
	vRPclient.playAnim(player,{true,seq,false})
	SetTimeout(60*1000,function()
		vRPclient.deleteProp(player,{'prop_cs_ciggy_01'})
	end)
end

local function smoke_weed(player)
	local seq = {
		--{"amb@world_human_smoking@male@male_a@enter","enter",1},
		{"timetable@gardener@smoking_joint", "smoke_idle", 1},
		{"timetable@gardener@smoking_joint", "idle_cough", 1},
		--{"amb@world_human_smoking@male@male_a@exit","exit",1},
	}
	vRPclient.attachProp(player,{'prop_cs_ciggy_01',28422,0,0,0,0,0,0})
	vRPclient.playAnim(player,{true,seq,false})
	SetTimeout(60*1000,function()
		vRPclient.deleteProp(player,{'prop_cs_ciggy_01'})
	end)
end

local function smoke_meth(player)
	local seq = {
		{"timetable@ron@ig_4_smoking_meth", "chefiscookingup", 1},
		{"timetable@ron@ig_4_smoking_meth", "onemorehit", 1},
		{"timetable@ron@ig_4_smoking_meth", "base", 1},
	}
	
	vRPclient.attachProp(player,{'prop_cs_meth_pipe',28422,0,0,0,0,0,0})
	vRPclient.playAnim(player,{true,seq,false})
	SetTimeout(60*1000,function()
		vRPclient.deleteProp(player,{'prop_cs_meth_pipe'})
	end)
end

local pills_choices = {}
pills_choices["Take"] = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    if vRP.tryGetInventoryItem(user_id,"pills",1) then
      vRPclient.varyHealth(player,{25})
      vRPclient.notify(player,{"Taking pills."})
      play_drink(player)
      vRP.closeMenu(player)
    end
  end
end}

local cig_choices = {}
cig_choices["Smoke"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then 
		if vRP.tryGetInventoryItem(user_id,"cigarette",1) then
			vRPclient.notify(player,{"Smoking cigarette."})
			smoke(player)
			vRP.closeMenu(player)
		end
	end
end} 

local weed_choices = {}
weed_choices["Smoke"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then 
		if vRP.tryGetInventoryItem(user_id,"weed",1) then
			vRPclient.notify(player,{"Smoking weed."})
			smoke_weed(player)
			vRP.closeMenu(player)
		end
	end
end} 

local meth_choices = {}
meth_choices["Smoke"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then 
		if vRP.tryGetInventoryItem(user_id,"meth",1) then
			vRPclient.notify(player,{"Smoking meth."})
			smoke_meth(player)
			vRP.closeMenu(player)
		end
	end
end} 

items["pills"] = {"Pills","A simple healing medication.",pills_choices,0.1}
items["cigarette"] = {"Cigarette","A small cylinder of finely cut tobacco leaves rolled in thin paper for smoking.",cig_choices,0.1}
items["weed"] = {"Weed", "", weed_choices, 0.5}
items["meth"] = {"Meth", "", meth_choices, 0.5}

return items
