local lang = vRP.lang
local Log = module("lib/Log")
local cfg = module("cfg/survival")

local revive_seq = {
	{"amb@medic@standing@kneel@enter","enter",1},
	{"amb@medic@standing@kneel@idle_a","idle_a",1},
	{"amb@medic@standing@kneel@exit","exit",1}
}

local cpr_seq = {
	{"mini@cpr@char_a@cpr_def","cpr_intro",1},
	{"missheistfbi3b_ig8_2","cpr_loop_paramedic",2},
}

local choice_field_treatment = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRPclient.getNearestPlayer(player,{5},function(nplayer)
			local nplayer = nplayer
			local nuser_id = vRP.getUserId(nplayer)
			if nuser_id ~= nil then
				vRPclient.isInComa(nplayer,{}, function(in_coma)
					if not in_coma then
						vRPclient.getHealth(nplayer,{}, function(health)
							if health < 200 then
								vRPclient.getActionLock(player, {},function(locked)
									if not locked then
										if vRP.tryGetInventoryItem(user_id,"medkit",1,true) then
											local random = math.random(1, 3)
											local seq = {}
											seq[1] = {{"timetable@gardener@smoking_joint","idle_cough",1}} -- cough
											seq[2] = {{"rcmfanatic1out_of_breath","p_zero_tired_01",1}} -- out of breath
											seq[3] = {{"re@construction","out_of_breath",1}} -- vomiting

											vRPclient.playAnim(nplayer,{false,seq[random],true})
											vRPclient.setActionLock(player,{true})
											vRPclient.setActionLock(nplayer,{true})
											vRPclient.attemptFieldTreatment(player,{random}, function(success)
												if success then
													vRPclient.varyHealth(nplayer,{20})
												else
													vRPclient.varyHealth(nplayer,{-25})
												end
												vRPclient.setActionLock(player,{false})
												vRPclient.setActionLock(nplayer,{false})
												vRPclient.stopAnim(nplayer,{false})
											end)
										else
											vRPclient.notify(player,{lang.inventory.missing({vRP.getItemName("medkit"),1})})
										end
									end
								end)
							else
								vRPclient.notify(player,{"The patient is not in need of treatment"})
							end
						end)
					else
						vRPclient.notify(player,{"This patient requires more serious medical attention"})
					end
				end)
			end
		end)
	end
end,"Treat minor wounds of the nearest player",6}

local choice_revive = {function(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRPclient.getNearestPlayer(player,{5},function(nplayer)
			local nplayer = nplayer
			local nuser_id = vRP.getUserId(nplayer)
			if nuser_id ~= nil then
				vRPclient.isInComa(nplayer,{}, function(in_coma)
					if in_coma then
						vRPclient.getActionLock(player, {},function(locked)
							if not locked then
								if vRP.tryGetInventoryItem(user_id,"medkit",1,true) then
									vRPclient.playAnim(player,{false,revive_seq,false}) -- anim
									vRPclient.setActionLock(player,{true})
									vRPclient.stopEscort(nplayer,{})
									SetTimeout(15000, function()
										vRPclient.getCanBeMedkitRevived(nplayer,{},function(isMedkitAllowed)
											if isMedkitAllowed == nil then
												isMedkitAllowed = true
											end
											if isMedkitAllowed then
												math.randomseed(os.time())
												local random = math.random(1, 6)
												if random == 3 then
													isMedkitAllowed = false
													vRPclient.setCanBeMedkitRevived(nplayer,{false})
												end
											end
											if isMedkitAllowed then
												vRPclient.varyHealth(nplayer,{100}) -- heal 100 full health
												vRPclient.isRevived(nplayer,{})
												vRP.giveBankMoney(user_id,cfg.reviveReward) -- pay reviver for their services
												vRPclient.notify(player,{"Received $"..cfg.reviveReward.." for your services."})
												Log.write(user_id,"Revived "..nuser_id,Log.log_type.action)
											else
												vRPclient.notify(player,{"This patient needs to be taken to a hospital. Medical kits will not work."})
												Log.write(user_id,"Revive failed (medkit failure) for "..nuser_id,Log.log_type.action)
											end
											vRPclient.setActionLock(player,{false})
										end)
									end)
								else
									vRPclient.notify(player,{lang.inventory.missing({vRP.getItemName("medkit"),1})})
								end
							end
						end)
					else
						vRPclient.notify(player,{lang.emergency.menu.revive.not_in_coma()})
					end
				end)
			else
				vRPclient.getActionLock(player, {},function(locked)
					if not locked then
						vRPclient.attempAiRevive(player,{})
					end
				end)
			end
		end)
	end
end,lang.emergency.menu.revive.description(),5}

local choice_escort = {function(player, choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRPclient.getNearestPlayer(player, {5}, function(nplayer)
				local nuser_id = vRP.getUserId(nplayer)
				if nuser_id ~= nil then
					vRPclient.isInComa(nplayer,{}, function(in_coma)
						if in_coma then
							vRPclient.toggleEscort(nplayer,{player})
						end
					end)
				else
					vRPclient.notify(player,{lang.common.no_player_near()})
				end
		end)
	end
end, lang.police.menu.escort.description(),1}

local choice_putinveh = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.isInComa(nplayer,{}, function(coma)  -- check handcuffed
        if coma then
          --vRPclient.stopEscort(nplayer,{})
          vRPclient.putInNearestVehicleAsPassengerEMS(nplayer, {10})
        else
          vRPclient.notify(player,{"Cannot get patient into vehicle"})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,"Put nearest patient in the vehicle",3}

local choice_getoutveh = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.isInComa(nplayer,{}, function(coma)  -- check handcuffed
        if coma then
          vRPclient.ejectVehicle(nplayer, {})
        else
          vRPclient.notify(player,{"Cannot get patient out of vehicle"})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.getoutveh.description(),4}

local choice_cpr = {function(player, choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRPclient.getNearestPlayer(player, {5}, function(nplayer)
				local nuser_id = vRP.getUserId(nplayer)
				if nuser_id ~= nil then
					vRPclient.getComaDetails(nplayer,{}, function(in_coma, beedout_time, stabilize_cooldown)
						if in_coma then
							if stabilize_cooldown < 1 then
								vRPclient.playAnim(player,{false,cpr_seq,false}) -- anim
								vRPclient.setActionLock(player,{true})
								vRPclient.stabilizeVictim(nplayer,{}) --We'll stabilize the victim before the animation timeout is over, but they don't need to know that
								SetTimeout(7500,function()
									vRPclient.setActionLock(player,{false})
									vRPclient.getBleedoutTime(nplayer,{}, function(time)
										if (time/60) > 1 then
											timeString = (math.ceil(time/60)).." minutes"
										else
											timeString = time.." seconds"
										end
											vRPclient.notify(player,{"You have stabilized the patient. They will bleed out in "..timeString.."."})
									end)
			          end)
							else
								if (beedout_time/60) > 1 then
									timeString = (math.ceil(beedout_time/60)).." minutes"
								else
									timeString = beedout_time.." seconds"
								end
									vRPclient.notify(player,{"The patient is already stabilized. They will bleedout in "..timeString.."."})
							end
						end
					end)
				else
					vRPclient.notify(player,{lang.common.no_player_near()})
				end
		end)
	end
end, "Performing CPR will stabilize the patient.",2}

local choice_missions = {function(player, choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRPjobs.toggleEMSmissions(player, {})
	end
end, "Start/Stop EMS Dispatch Missions",7}

local choice_dispatch = {function(player, choice)
	TriggerClientEvent('LoadCalls',player, false, "EMS/Fire", "dispatch")
end, "",8}

local choice_checkpulse = {function(player, choice)
	--vRPclient.getNearestPlayer(player, {5}, function(nplayer)
		nplayer = player
		if nplayer ~= nil then
			vRPclient.getPlayerPulse(nplayer,{}, function(pulse)
				if pulse ~= nil then
					vRPclient.notify(player, {"The persons pulse is "..pulse.." BPM"})
				end
			end)
		end
	--end)
end, "",9}

local choice_checklastinjury = {function(player, choice)
	--vRPclient.getNearestPlayer(player, {5}, function(nplayer)
		nplayer = player
		if nplayer ~= nil then
			vRPclient.getLastInjury(nplayer,{}, function(data)
				if data ~= nil then
					vRPclient.setDiv(player,{"lsfd_diag",".div_lsfd_diag{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",data})
					-- request to hide div
					vRP.request(player, "Close Diagnosis Report", 500, function(player,ok)
						vRPclient.removeDiv(player,{"lsfd_diag"})
					end)
				end
			end)
		end
	--end)
end, "",10}

local choice_clearDamage = {function(player, choice)
	--vRPclient.getNearestPlayer(player, {5}, function(nplayer)
		nplayer = player
		if nplayer ~= nil then
			vRPclient.clearBoneDamage(player, {})
		end
	--end)
end, "",11}

-- add choices to the menu
vRP.registerMenuBuilder("main", function(add, data)
	local player = data.player

	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		local choices = {}

		if vRP.hasPermission(user_id,"emergency.support") then
				-- build police menu
				choices["EMS"] = {function(player,choice)
					vRP.buildMenu("ems", {player = player}, function(menu)
						menu.name = "EMS Menu"
						menu.css = {top="75px",header_color="rgba(0,125,255,0.75)"}

						if vRP.hasPermission(user_id,"emergency.support") then
							if vRP.hasPermission(user_id,"emergency.revive") then
								menu[lang.emergency.menu.revive.title()] = choice_revive
								menu["Field Treatment"] = choice_field_treatment
								menu[lang.police.menu.putinveh.title()] = choice_putinveh
								menu[lang.police.menu.getoutveh.title()] = choice_getoutveh
								menu['LSFD Dispatch Job'] = choice_missions
								menu['Mobile Data Terminal'] = choice_dispatch
								menu['Check Pulse'] = choice_checkpulse
								menu['Last Injury'] = choice_checklastinjury
								menu['Clear Damage'] = choice_clearDamage
							end
							menu["Drag Unconscious"] = choice_escort
							menu["Perform CPR"] = choice_cpr
						end

							vRP.openMenu(player,menu)
					end)
				end,"EMS Menu",3}
		end

		add(choices)
	end
end)
