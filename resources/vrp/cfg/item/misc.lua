local items = {}
local guitars = {
	"prop_el_guitar_02",
	"prop_el_guitar_01",
	"prop_el_guitar_03",
	"prop_acc_guitar_01"
}

local function play_guitar(player,guitar)
  local seq = {
    {"amb@world_human_musician@guitar@male@base", "base", 1}
  }
  vRPclient.getCurrentProps(player,{},function(props)
	for k,v in pairs(guitars) do
		if props[v] ~= nil then
			vRPclient.notify(player,{"Already playing a guitar."})
			return
		end
	end
	vRPclient.notify(player,{"Playing guitar"})
	vRPclient.playAnim(player,{true,seq,true})
	vRPclient.attachProp(player,{guitar,60309,0,0,0,0,0,0})
	vRP.closeMenu(player)
  end)
end

local function stop_playing(player, guitar)
	vRPclient.getCurrentProps(player,{},function(props)
		if props[guitar] ~= nil then
			vRPclient.stopAnim(player,{false})
			vRPclient.deleteProp(player,{guitar})
			vRP.closeMenu(player)
		end
	end)
end

local guitar1_choices = {}
local guitar2_choices = {}
local guitar3_choices = {}
local guitar4_choices = {}
guitar1_choices["Play"] = {function(player,choice) play_guitar(player,"prop_el_guitar_02") end}
guitar2_choices["Play"] = {function(player,choice) play_guitar(player,"prop_el_guitar_01") end}
guitar3_choices["Play"] = {function(player,choice) play_guitar(player,"prop_el_guitar_03") end}
guitar4_choices["Play"] = {function(player,choice) play_guitar(player,"prop_acc_guitar_01") end}
guitar1_choices["Stop"] = {function(player,choice) stop_playing(player, "prop_el_guitar_02") end}
guitar2_choices["Stop"] = {function(player,choice) stop_playing(player, "prop_el_guitar_01") end}
guitar3_choices["Stop"] = {function(player,choice) stop_playing(player, "prop_el_guitar_03") end}
guitar4_choices["Stop"] = {function(player,choice) stop_playing(player, "prop_acc_guitar_01") end}

local lockpick_choices = {}
lockpick_choices["Use"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		if vRP.tryGetInventoryItem(user_id,"lockpick",1) then
			vRPclient.break_carlock(player,{})
		end
	end
end}

local spikestrip_choices = {}
spikestrip_choices["Use"] = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        if vRP.tryGetInventoryItem(user_id,"spikestrip",1) then
            TriggerClientEvent('c_setSpike', player)
        end
    end
end}

local scuba_choices = {}
scuba_choices["Wear"] = {
	function(player,choice)
		vRPclient.isPedInCar(player,{},function(inVeh)
			if inVeh then
				vRPclient.notify(player,{"You cannot equip scuba gear while in a vehicle"})
			else
				local user_id = vRP.getUserId(player)
				if user_id ~= nil then
					if vRP.tryGetInventoryItem(user_id,"scuba_kit",1,false) then
						vRPclient.start_scuba(player,{})
					end
				end
			end
			vRP.closeMenu(player)
		end)
	end
}

local diamond_ring_choices = {}
diamond_ring_choices["Propose"] = {
	function(player,choice)
		vRPclient.getNearestPlayer(player,{10},function(nplayer)
			local user_id = vRP.getUserId(player)
	    local nuser_id = vRP.getUserId(nplayer)
	    if nuser_id ~= nil then
				vRP.getUserSpouse(user_id, function(spouse_1)
					if spouse_1 == 0 then
						vRP.getUserSpouse(nuser_id, function(spouse_2)
							if spouse_2 == 0 then
								vRP.closeMenu(player)
								vRPclient.notify(player,{"Proposing..."})
								vRP.request(nplayer,"Will you marry this person?",15,function(nplayer,ok)
									if ok then
										vRP.tryGetInventoryItem(user_id,"diamond_ring",1,true)
										vRP.giveInventoryItem(nuser_id,"diamond_ring2",1,true)
										vRP.setUserSpouse(user_id, nuser_id)
										vRP.setUserSpouse(nuser_id, user_id)
										vRPclient.notify(player,{"Congratulations! You're now married!"})
										vRPclient.notify(nplayer,{"Congratulations! You're now married!"})
									else
										vRPclient.notify(player,{vRP.lang.common.request_refused()})
									end
								end)
							else
								vRPclient.notify(player,{"This person is already married."}) --other player has spouse
							end
						end)
					else
						vRPclient.notify(player,{"You're already married, you filthy cheater."}) --player has spouse
					end
				end)
	    else
	      vRPclient.notify(player,{vRP.lang.common.no_player_near()})
	    end
	  end)
	end
}

items["guitar1"] = {"Guitar(Green)","",function(args) return guitar1_choices end,1.0}
items["guitar2"] = {"Guitar(White)","",function(args) return guitar2_choices end,1.0}
items["guitar3"] = {"Guitar(Gibson)","",function(args) return guitar3_choices end,1.0}
items["guitar4"] = {"Guitar(Acoustic)","",function(args) return guitar4_choices end,1.0}
items["lockpick"] = {"Lockpick", "Handy tool to break into locked cars.",function(args) return lockpick_choices end, 0.2}
items["spikestrip"] = {"Spike Strip", "Fuck yo tires",function(args) return spikestrip_choices end, 3.0}
items["scuba_kit"] = {"Scuba Kit", "Prevents a watery death to the best of its ability", function(args) return scuba_choices end, 3.0}
items["diamond_ring"] = {"Diamond Ring", "Try not to mess this up", function(args) return diamond_ring_choices end, 0.1}

return items
