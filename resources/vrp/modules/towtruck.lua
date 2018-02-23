local lang = vRP.lang
local Log = module("lib/Log")

local approvedTowList = {}

local function ch_towtruck(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
	vRPclient.getIsCurrentlyTowing(player,{},function(towing)
		if not towing then
			vRPclient.getNearestOwnedVehiclePlate(player,{5},function(ok,vtype,vehName,plate)
				if ok and vehName ~= "flatbed" then
					local found, tableKey = vRP.isInTowList(plate,vehName)
					if not found then
						vRP.getUserByRegistration(plate, function(nuser_id)
							if nuser_id ~= nil then
								local nplayer = vRP.getUserSource(nuser_id)
								if nplayer ~= nil then
									vRP.getUserIdentity(user_id, function(identity)
	            						if identity then
	            							local name = identity.name
	              							local firstname = identity.firstname
											vRP.request(nplayer,firstname.." "..name.." is requesting permission to tow your vehicle. Do you allow?",15,function(player,ok)
												if ok then
													vRP.addToTowList(plate,vehName)
													vRPclient.vc_TowTruck(player,{})
													vRPclient.notify(nplayer,{"Your vehicle is being towed."})
												else
													vRPclient.notify(player,{"Your request to tow the vehicle has been declined. Reminder to not spam requests."})
												end
											end)
											Log.write(user_id, "Requesting tow permission from user id: "..nuser_id, Log.log_type.action)
										end
									end)
								end
							end
						end)
					else
						vRPclient.vc_TowTruck(player,{})
					end
				end
			end)
		else
			vRPclient.vc_TowTruck(player,{})
		end
	end)
  end
end

function vRP.isInTowList(plate,vehName)
	if #approvedTowList > 0 then
		for i=1,#approvedTowList do
			if approvedTowList[i].registration == string.lower(plate) and approvedTowList[i].name == string.lower(vehName) then
				return true, i
			end
		end
	end
	return false, 0
end

function tvRP.addToTowList(plate,vehName)
	if plate ~= nil and vehName ~= nil then
		table.insert(approvedTowList,{registration = string.lower(plate), name = string.lower(vehName)})
	end
end

function vRP.removeFromTowList(plate,vehName)
	if plate ~= nil and vehName ~= nil then
		local found, tableKey = vRP.isInTowList(plate,vehName)
		if found then
			table.remove(approvedTowList, tableKey)
		end
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
