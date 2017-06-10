
local items = {}

local function start_fishing(player)
	local seq = {
		{'amb@world_human_stand_fishing@base','base',4},
		{'amb@world_human_stand_fishing@idle_a','idle_c',1}
	}
	vRPclient.notify(player,{"~g~ Fishing"})
	vRPclient.attachProp(player,{'prop_fishing_rod_01',60309,0,0,0,0,0,0})
	vRPclient.playAnim(player,{false,seq,false})
  --2558.50512695313,6155.3330078125,161.854034423828
	SetTimeout(25000,function()
		vRPclient.notify(player,{"~g~ Caught Fish"})
		vRPclient.deleteProp(player,{'prop_fishing_rod_01'})
	end)
end

local choices = {}
choices["Fish"] = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
	  start_fishing(player)
	  vRP.closeMenu(player)
  end
end}

items["fishing_rod"] = {"Fishing Rod","A simple fishing rod.",choices,0.1}

return items
