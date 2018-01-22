local lang = vRP.lang
local Log = module("lib/Log")

local function ch_towtruck(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
	vRPclient.getIsCurrentlyTowing(player,{},function(towing)
		if not towing then
			vRPclient.getNearestOwnedVehiclePlate(player,{5},function(ok,vtype,name,plate)
				if ok and name ~= "flatbed" then
					vRP.getUserByRegistration(plate, function(nuser_id)
						if nuser_id ~= nil then
							local nplayer = vRP.getUserSource(user_id)
							if nplayer ~= nil then
								vRP.request(player,"Ok to tow?",15,function(nplayer,ok)
									if ok then
										vRPclient.vc_TowTruck(player,{})
									end
								end)
							end
						end
					end)
				end
			end)
		else
			vRPclient.vc_TowTruck(player,{})
		end
	end)
  end
end

vRP.registerMenuBuilder("main", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id ~= nil then
	local choices = {}
	if vRP.hasPermission(user_id, "towtruck.tow") then
	  choices["Tow Vehicle"] = {ch_towtruck, "Load/Unload vehicle on flatbed",99}
	end

	add(choices)
  end
end)
