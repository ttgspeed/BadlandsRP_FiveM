
local items = {}

local function start_fishing(player)
	local seq = {
		{'amb@world_human_stand_fishing@base','base',4},
		{'amb@world_human_stand_fishing@idle_a','idle_c',1}
	}
	vRPclient.getCurrentProps(player,{},function(props)
		if props["prop_fishing_rod_01"] ~= nil then
			vRPclient.notify(player,{"You are already fishing."})
			return
		end
	end)
	vRPclient.isInWater(player,{},function(truth)
		if truth then
			vRPclient.notify(player,{"Fishing"})
			vRPclient.attachProp(player,{'prop_fishing_rod_01',60309,0,0,0,0,0,0})
			vRPclient.playAnim(player,{false,seq,false})
			SetTimeout(24000,function()
				vRPclient.getDistanceFrom(player,{2558.50512695313,6155.3330078125,161.854034423828},function(distance)
					local caught
					if distance < 100 then
						caught = "high_quality_fish"
					else
						local keyset = {}
						for k,v in pairs(items) do
							table.insert(keyset,k)
						end
						caught = keyset[math.random(2,#keyset + 1)]
					end
					user_id = vRP.getUserId(player)
					vRP.giveInventoryItem(user_id,caught,1)
					vRPclient.notify(player,{"Caught " .. items[caught][1]})
					vRPclient.deleteProp(player,{'prop_fishing_rod_01'})
				end)
			end)
		else
			vRPclient.notify(player,{"You must be standing in water to fish."})
		end
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

--{name,description,choices,weight}
items["fishing_rod"] = {"Fishing Rod","A simple fishing rod.",choices,2.0}
items["high_quality_fish"] = {"High Quality Fish","The best fish money can buy.",{},1.0}
items["regular_fish"] = {"Fish","Regular quality fish.",{},1.0}
items["low_quality_fish"] = {"Low Quality Fish","Low quality fish. Eating this is not reccomended.",{},1.0}

return items
