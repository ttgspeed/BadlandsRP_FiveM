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
						vRPclient.notify(player,{"Vehicle has not been tagged for towing."})
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
	if plate ~= nil and vehName ~= nil then
		if #approvedTowList > 0 then
			for i=1,#approvedTowList do
				if approvedTowList[i].registration == string.lower(plate) and approvedTowList[i].name == string.lower(vehName) then
					return true, i
				end
			end
		end
	end
	return false, 0
end

function tvRP.addToTowList(plate,vehName,x,y,z)
	if plate ~= nil and vehName ~= nil and x ~= nil and y ~= nil and z ~= nil then
		local found, tableKey = vRP.isInTowList(plate,vehName)
		if not found then
			table.insert(approvedTowList,{registration = string.lower(plate), name = string.lower(vehName), startX = x, startY = y, startZ = z})
		end
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

function vRP.towPayout(tableKey,endX,endY,endZ,allowPay)
	local payout = 0
	if tableKey ~= nil and endX ~= nil and endY ~= nil and endZ ~= nil then
		local dx,dy,dz = endX-approvedTowList[tableKey].startX,endY-approvedTowList[tableKey].startY,endZ-approvedTowList[tableKey].startZ
		payout = math.ceil(math.sqrt(dx*dx+dy*dy+dz*dz))
		return payout
	end
	return 0
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
