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


items["guitar1"] = {"Guitar(Green)","",guitar1_choices,1.0}
items["guitar2"] = {"Guitar(White)","",guitar2_choices,1.0}
items["guitar3"] = {"Guitar(Gibson)","",guitar3_choices,1.0}
items["guitar4"] = {"Guitar(Acoustic)","",guitar4_choices,1.0}

return items