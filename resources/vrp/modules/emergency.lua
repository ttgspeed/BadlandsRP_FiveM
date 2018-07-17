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

local choice_revive = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
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
                    vRPclient.varyHealth(nplayer,{100}) -- heal 100 full health
                    vRPclient.isRevived(nplayer,{})
                    vRP.giveBankMoney(user_id,cfg.reviveReward) -- pay reviver for their services
                    vRPclient.notify(player,{"Received $"..cfg.reviveReward.." for your services."})
                    vRPclient.setActionLock(player,{false})
                    Log.write(user_id,"Revived "..nuser_id,Log.log_type.action)
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
end,lang.emergency.menu.revive.description(),1}

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
end, lang.police.menu.escort.description(),2}

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
	        			vRPclient.stabilizeVictim(nplayer,{})
	        			vRPclient.getBleedoutTime(nplayer,{}, function(time)
	        				if (time/60) > 1 then
								timeString = (math.ceil(time/60)).." minutes"
							else
								timeString = time.." seconds"
							end
	        				vRPclient.notify(player,{"You have stabilized the patient. They will bleed out in "..timeString.."."})
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
end, "Performing CPR will stabalize the patient.",3}

-- add choices to the menu
vRP.registerMenuBuilder("main", function(add, data)
  local player = data.player

  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    local choices = {}

    if vRP.hasPermission(user_id,"emergency.revive") then
      	-- build police menu
      	choices["EMS"] = {function(player,choice)
        	vRP.buildMenu("ems", {player = player}, function(menu)
          		menu.name = "EMS Menu"
          		menu.css = {top="75px",header_color="rgba(0,125,255,0.75)"}

          		if vRP.hasPermission(user_id,"emergency.revive") then
	  				menu[lang.emergency.menu.revive.title()] = choice_revive
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
