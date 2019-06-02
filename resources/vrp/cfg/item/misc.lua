local Log = module("lib/Log")

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

local nocrack_choice = {}
nocrack_choice["Unpack"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if vRP.tryGetInventoryItem(user_id,"nocrack",1,true) then
		vRP.giveInventoryItem(user_id,"cement",100,true)
		vRP.closeMenu(player)
	end
end}

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

local lottery_choices = {}
lottery_choices["Check Ticket"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	local dkey = GetConvar('blrp_watermark','us1.blrp.life')
	dkey = "vRP:"..dkey..":lottery"
	if user_id ~= nil then
		if vRP.tryGetInventoryItem(user_id,"lotto_ticket",1) then
			vRP.getSData(dkey, function(value)
				value = math.floor(tonumber(value))
				local winning_number = math.random(1,1000)
				if(winning_number == 777) then
					Log.write(user_id,"Won "..dkey.." lottery for $"..value,Log.log_type.action)
					vRPclient.notify(player,{"Congratulations! You won the jackpot of $"..string.format("%.2f", value)})
					TriggerClientEvent('chat:addMessage', -1, {
							template = '<div class="chat-bubble" style="background-color: rgba(0, 230, 184, 0.6);"><i class="fas fa-newspaper"></i> {0}</div>',
							args = { "A lucky winner has claimed the lottery jackpot of ^2$" .. string.format("%.2f", value) }
					})
					vRP.giveBankMoney(user_id,value)
					vRP.setSData(dkey,tostring(10000))
				else
					value = value + 500
					vRPclient.notify(player,{"Sorry, you are not a winner of the $"..string.format("%.2f", value).." jackpot. Better luck next time!"})
					vRP.setSData(dkey,tostring(value))
				end
			end)
		end
	end
end}

local lockpick_choices = {}
lockpick_choices["Use"] = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		if vRP.tryGetInventoryItem(user_id,"lockpick",1) then
			vRPclient.break_carlock(player,{})
		end
	end
end}

local binocular_choices = {}
binocular_choices["Use"] = {function(player,choice)
	vRP.closeMenu(player)
	TriggerClientEvent('binoculars:Activate',player)
	Citizen.Wait(500)
	vRP.closeMenu(player)
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

local speedbomb_choices = {}
speedbomb_choices["Apply"] = {
	function(player,choice)
		local user_id = vRP.getUserId(player)
	  if user_id ~= nil then
      vRPclient.getActionLock(player, {},function(locked)
        if not locked then
					vRPclient.applySpeedBomb(player, {},function(applied)
						if applied then
							vRP.tryGetInventoryItem(user_id,"speedbomb",1,false)
							Log.write(user_id,"Applied speedbomb to vehicle",Log.log_type.action)
						end
					end)
        end
      end)
	  end
		vRP.closeMenu(player)
	end
}

local heely_choices = {}
heely_choices["Equip"] = {
	function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
			if vRP.tryGetInventoryItem(user_id,"heelys",1,false) then
				vRPclient.notify(player,{"This pair is broken. Try buying a new pair."})
			end
		end
		vRP.closeMenu(player)
	end
}

local key_chain_choices = {}
key_chain_choices["View Shared Keys"] = {
	function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
			if vRP.getInventoryItemAmount(user_id,"key_chain") > 0 then
				vRPclient.getKeys(player, {}, function(keys)
					if keys and keys ~= {} then
						local content = "<table><tr><th>Vehicle Name</th><th>Registration</th></tr>"
						for k,v in pairs(keys) do
							content = content.."<tr><td>"..string.upper(v.name).."</td><td>"..string.upper(v.plate).."</td></tr>"
						end
						content = content.."</table>"
						vRPclient.setDiv(player,{"shared_keys",".div_shared_keys{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
						-- request to hide div
						vRP.request(player, "Put key chain away", 30, function(player,ok)
							vRPclient.removeDiv(player,{"shared_keys"})
						end)
					else
						vRPclient.notify(player, {"You have no shared keys on your key chain."})
					end
				end)
			end
		end
		vRP.closeMenu(player)
	end
}

local weapon_disable_choices = {}
weapon_disable_choices["Use"] = {
	function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
			nplayer = player
			vRPclient.getNearestSerrenderedPlayer(player,{5},function(nplayer)
				if nplayer ~= nil then
					local nuser_id = vRP.getUserId(nplayer)
	        if nuser_id ~= nil then
						if vRP.getInventoryItemAmount(user_id,"weapon_disable_kit") > 0 then
							vRPclient.playAnim(player,{true,{{"missheistfbisetup1","unlock_enter_janitor",1}},false})
							vRPclient.notify(player,{"Attempting to disable the persons items"})
							vRPclient.notify(nplayer,{"Someone is attempting to disable your items"})
							SetTimeout(10000, function()
								nplayer_two = player
								vRPclient.getNearestSerrenderedPlayer(player,{5},function(nplayer_two)
									if (nplayer == nplayer_two) and vRP.tryGetInventoryItem(user_id,"weapon_disable_kit",1,false) then
										vRPclient.setFiringPinState(nplayer,{false})
										vRPclient.notify(nplayer,{"Your items have been disabled. You will need to repair your items at a gunstore. This includes your phone."})
										vRPclient.notify(player,{"You have disabled the persons items"})
										Log.write(user_id,"Used weapon disable kit on player ID "..nuser_id,Log.log_type.action)
									else
										vRPclient.notify(player,{"Action cancelled"})
									end
								end)
							end)
						end
					end
				end
			end)
		end
		vRP.closeMenu(player)
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

local weaponkit_choice = {}
weaponkit_choice["Teardown Weapon"] = {
	function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
			if vRP.getInventoryItemAmount(user_id,"weapon_kit") > 0 then
				vRPclient.getCurrentWeapon(player,{},function(weapon, ammo)
					if weapon ~= nil then
						if ammo == nil then
							ammo = 0
						end
						local seizedItems = "wbody|"..weapon.." Qty: 1"
						vRPclient.removeWeapon(player,{weapon})
						vRP.giveInventoryItem(user_id, "wbody|"..weapon, 1, true)
						vRPclient.notify(player,{"You have dismantled "..weapon})
						Log.write(user_id, "Dismantled weapon "..weapon.." with ammo count "..ammo, Log.log_type.action)
					else
						vRPclient.notify(player,{"You have no weapons in your hands to teardown"})
					end
				end)
			end
		end
		vRP.closeMenu(player)
	end
,"Take apart weapon",1}
weaponkit_choice["Remove Ammo"] = {
	function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
			if vRP.getInventoryItemAmount(user_id,"weapon_kit") > 0 then
				vRPclient.getCurrentWeapon(player,{},function(weapon, ammo)
					if weapon ~= nil then
						if ammo == nil then
							ammo = 0
						end
						vRP.prompt(player,"How many bullets to remove","",function(player,removeQty)
							removeQty = tonumber(removeQty)
							if removeQty > 0 and removeQty <= ammo then
								vRPclient.removeAmmo(player,{weapon,removeQty})
								vRP.giveInventoryItem(user_id, "wammo|"..weapon, removeQty, true)
								local seizedItems = "wammo|"..weapon.." Qty: "..removeQty
								vRPclient.notify(player,{"You have removed "..removeQty.." bullets from your weapon"})
								Log.write(user_id, "Removed "..removeQty.." from weapon "..weapon, Log.log_type.action)
							end
						end)
					else
						vRPclient.notify(player,{"You have no weapons in your hands to remove bullets"})
					end
				end)
			end
		end
		vRP.closeMenu(player)
	end
,"Take out ammo from weapon",2}

items["guitar1"] = {"Guitar(Green)","",function(args) return guitar1_choices end,1.0}
items["guitar2"] = {"Guitar(White)","",function(args) return guitar2_choices end,1.0}
items["guitar3"] = {"Guitar(Gibson)","",function(args) return guitar3_choices end,1.0}
items["guitar4"] = {"Guitar(Acoustic)","",function(args) return guitar4_choices end,1.0}
items["lockpick"] = {"Lockpick", "Handy tool to break into locked cars.",function(args) return lockpick_choices end, 0.2}
items["binoculars"] = {"Binoculars", "Make far things close.",function(args) return binocular_choices end, 3.0}
items["spikestrip"] = {"Spike Strip", "Fuck yo tires",function(args) return spikestrip_choices end, 3.0}
items["scuba_kit"] = {"Scuba Kit", "Prevents a watery death to the best of its ability", function(args) return scuba_choices end, 3.0}
items["diamond_ring"] = {"Diamond Ring", "Try not to mess this up", function(args) return diamond_ring_choices end, 0.1}
items["heelys"] = {"Heelys", "Personal transportation in the heel of your shoe (used)", function(args) return heely_choices end, 20.0}
items["speedbomb"] = {"Speed Bomb", "Guaranteed to blow someone's mind.", function(args) return speedbomb_choices end, 20.0}
items["weapon_disable_kit"] = {"Items Disablement Kit", "Use a kit to disable a persons items (weapons and phone).", function(args) return weapon_disable_choices end, 2.0}
items["key_chain"] = {"Key Chain", "Hold the keys given to you. Don't lose it.", function(args) return key_chain_choices end, 0.1}
items["lotto_ticket"] = {"Lottery Ticket", "Test your luck!", function(args) return lottery_choices end, 0.0}
items["nocrack"] = {"NoCrack Cement Mix", "Crack resistant cement mix", function(args) return nocrack_choice end, 50.0}
items["weapon_kit"] = {"Weapon Teardown Kit", "Allows you to teardown weapons", function(args) return weaponkit_choice end, 0.1}

return items
