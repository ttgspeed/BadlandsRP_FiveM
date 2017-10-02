
local items = {}

local function start_fishing(ped)
	local player = ped
	local seq = {
		{'amb@world_human_stand_fishing@base','base',4},
		{'amb@world_human_stand_fishing@idle_a','idle_c',1}
	}
	vRPclient.isInWater(player,{},function(truth)
		if truth then
			local user_id = vRP.getUserId(player)
			if (vRP.getInventoryWeight(user_id)+1) <= vRP.getInventoryMaxWeight(user_id) then
				vRPclient.notify(player,{"Fishing"})
				vRPclient.attachProp(player,{'prop_fishing_rod_01',60309,0,0,0,0,0,0})
				vRPclient.playAnim(player,{false,seq,false})
				SetTimeout(24000,function()
					vRPclient.getDistanceFrom(player,{2558.50512695313,6155.3330078125,161.854034423828},function(distance)
						local caught = "regular_fish"
						if distance < 100 then
							caught = "high_quality_fish"
						else
							local keyset = {}
							for k,v in pairs(items) do
								if k ~= "fishing_rod" then
									table.insert(keyset,k)
								end
							end
							
							-- Initialize the pseudo random number generator
							math.randomseed( os.time() )
							math.random(); math.random(); math.random()
							-- done. :-)
							
							local rng = math.random()
							if rng < .1 then
								caught = "high_quality_fish"
							elseif rng < .45 then
								caught = "regular_fish"
							else
								caught = "low_quality_fish"
							end
						end
						
						vRPclient.deleteProp(player,{'prop_fishing_rod_01'})
						vRP.giveInventoryItem(user_id,caught,1)
						vRPclient.notify(player,{"Caught " .. items[caught][1]})
					end)
				end)
			else
				vRPclient.notify(player,{"Inventory full."})
			end
		else
			vRPclient.notify(player,{"You must be standing in water to fish."})
		end
	end)
end

local choices = {}
choices["Fish"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRPclient.getCurrentProps(player,{},function(props)
			if props["prop_fishing_rod_01"] ~= nil then
				vRPclient.notify(player,{"You are already fishing."})
				return
			end
			start_fishing(player)
			vRP.closeMenu(player)
		end)
	end
end}

--{name,description,choices,weight}
items["fishing_rod"] = {"Fishing Rod","A simple fishing rod.",function(args) return choices end,2.0}
items["high_quality_fish"] = {"High Quality Fish","The best fish money can buy.",nil,1.0}
items["regular_fish"] = {"Fish","Regular quality fish.",nil,1.0}
items["low_quality_fish"] = {"Low Quality Fish","Low quality fish. Eating this is not reccomended.",nil,1.0}

return items
