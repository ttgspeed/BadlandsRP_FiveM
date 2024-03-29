local htmlEntities = module("lib/htmlEntities")
local Tools = module("lib/Tools")
local lang = vRP.lang
local Log = module("lib/Log")
local phoneCfg = module("cfg/phone")
local announces = phoneCfg.announces
local sanitizes = module("cfg/sanitizes")

-- this module define some admin menu functions

local player_lists = {}

local function ch_list(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.list") then
		if player_lists[player] then -- hide
			player_lists[player] = nil
			vRPclient.removeDiv(player,{"user_list"})
		else -- show
			local content = ""
			local count = 0
			for k,v in pairs(vRP.rusers) do
				count = count+1
				local source = vRP.getUserSource(k)
				vRP.getUserIdentity(k, function(identity)
					if source ~= nil then
						--content = content.."<br />"..k.." => <span class=\"pseudo\">"..vRP.getPlayerName(source).."</span> <span class=\"endpoint\">"..vRP.getPlayerEndpoint(source).."</span>"
						-- Disabled version showing IP. Not sure we should display it in game
						content = content.."<br />"..k.." => <span class=\"pseudo\">"..vRP.getPlayerName(source).."</span> <span class=\"endpoint\"></span>"
						if identity then
							content = content.." <span class=\"name\">"..htmlEntities.encode(identity.firstname).." "..htmlEntities.encode(identity.name).."</span> <span class=\"reg\">"..identity.registration.."</span> <span class=\"phone\">"..identity.phone.."</span>"
						end
					end

					-- check end
					count = count-1
					if count == 0 then
						player_lists[player] = true
						local css = [[
							 .div_user_list{
								 margin: auto;
								 padding: 8px;
								 width: 650px;
								 margin-top: 80px;
								 background: black;
								 color: white;
								 font-weight: bold;
								 font-size: 1.1em;
							 }

							 .div_user_list .pseudo{
								 color: rgb(0,255,125);
							 }

							 .div_user_list .endpoint{
								 color: rgb(255,0,0);
							 }

							 .div_user_list .name{
								 color: #309eff;
							 }

							 .div_user_list .reg{
								 color: rgb(0,125,255);
							 }

							 .div_user_list .phone{
								 color: rgb(211, 0, 255);
							 }
						]]
						vRPclient.setDiv(player,{"user_list", css, content})
					end
				end)
			end
		end
	end
end

local function ch_groups(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.list") then
		if player_lists[player] then -- hide
			player_lists[player] = nil
			vRPclient.removeDiv(player,{"user_list"})
		else -- show
			local content = ""
			local count = 0
			for k,v in pairs(vRP.rusers) do
				count = count+1
				local source = vRP.getUserSource(k)
				local groups = vRP.getUserGroups(k)
				if source ~= nil then
					--content = content.."<br />"..k.." => <span class=\"pseudo\">"..vRP.getPlayerName(source).."</span> <span class=\"endpoint\">"..vRP.getPlayerEndpoint(source).."</span>"
					-- Disabled version showing IP. Not sure we should display it in game
					content = content.."<br />"..k.." => <span class=\"endpoint\"></span>"
					if groups then
						content = content.." <span class=\"name\">"..htmlEntities.encode(json.encode(groups)).."</span>"
					end
				end

				-- check end
				count = count-1
				if count == 0 then
					player_lists[player] = true
					local css = [[
						 .div_user_list{
							 margin: auto;
							 padding: 8px;
							 width: 650px;
							 margin-top: 80px;
							 background: black;
							 color: white;
							 font-weight: bold;
							 font-size: 1.1em;
						 }

						 .div_user_list .pseudo{
							 color: rgb(0,255,125);
						 }

						 .div_user_list .endpoint{
							 color: rgb(255,0,0);
						 }

						 .div_user_list .name{
							 color: #309eff;
						 }

						 .div_user_list .reg{
							 color: rgb(0,125,255);
						 }

						 .div_user_list .phone{
							 color: rgb(211, 0, 255);
						 }
					]]
					vRPclient.setDiv(player,{"user_list", css, content})
				end
			end
		end
	end
end

local function ch_whitelist(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.whitelist") then
		vRP.prompt(player,"User id to whitelist: ","",function(player,id)
			id = parseInt(id)
			if id > 0 then
				vRP.setWhitelisted(id,true)
				vRPclient.notify(player,{"whitelisted user "..id})
				Log.write(user_id,"Player ID "..id.." was added to server whitelist",Log.log_type.admin)
			end
		end)
	end
end

local function ch_unwhitelist(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.unwhitelist") then
		vRP.prompt(player,"User id to un-whitelist: ","",function(player,id)
			id = parseInt(id)
			if id > 0 then
				vRP.setWhitelisted(id,false)
				vRPclient.notify(player,{"un-whitelisted user "..id})
				Log.write(user_id,"Player ID "..id.." was removed from server whitelist",Log.log_type.admin)
			end
		end)
	end
end

local function ch_addgroup(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.group.add") then
		vRP.prompt(player,"User id: ","",function(player,id)
			id = parseInt(id)
			if id > 0 then
				vRP.prompt(player,"Group to add: ","",function(player,group)
					if group ~= nil and group ~= "" then
						vRP.addUserGroup(id,group)
						vRPclient.notify(player,{group.." added to user "..id})
						Log.write(user_id,"Player ID "..id.." was added to group "..group,Log.log_type.admin)
					end
				end)
			end
		end)
	end
end

local function ch_removegroup(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.group.remove") then
		vRP.prompt(player,"User id: ","",function(player,id)
			id = parseInt(id)
			if id > 0 then
				vRP.prompt(player,"Group to remove: ","",function(player,group)
					if group ~= nil and group ~= "" then
						vRP.removeUserGroup(id,group)
						vRPclient.notify(player,{group.." removed from user "..id})
						Log.write(user_id,"Player ID "..id.." was removed from group "..group,Log.log_type.admin)
					end
				end)
			end
		end)
	end
end

local function ch_kick(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.kick") then
		vRP.prompt(player,"User id to kick: ","",function(player,id)
			id = parseInt(id)
			if id > 0 then
				vRP.prompt(player,"Reason: ","",function(player,reason)
					local source = vRP.getUserSource(id)
					if source ~= nil then
						vRP.request(player,"Do you want to kick "..id,30,function(player,ok)
							if ok then
								vRP.kick(source,reason)
								vRPclient.notify(player,{"kicked user "..id})
								Log.write(user_id,"Player ID "..id.." was kicked from from the server for: "..reason,Log.log_type.admin)
							end
						end)
					end
				end)
			end
		end)
	end
end

local function ch_ban(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.ban") then
		vRP.prompt(player,"User id to ban: ","",function(player,id)
			id = parseInt(id)
			if id > 0 then
				vRP.prompt(player,"Reason: ","",function(player,reason)
					local source = vRP.getUserSource(id)
					if source ~= nil then
						vRP.request(player,"Do you want to ban "..id,30,function(player,ok)
							if ok then
								vRP.ban(source,reason,user_id)
								vRPclient.notify(player,{"banned user "..id})
								Log.write(user_id,"Player ID "..id.." was banned from from the server for: "..reason,Log.log_type.admin)
							end
						end)
					end
				end)
			end
		end)
	end
end

local function ch_unban(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.unban") then
		vRP.prompt(player,"User id to unban: ","",function(player,id)
			id = parseInt(id)
			if id > 0 then
				vRP.setBanned(id,false,"",0)
				vRPclient.notify(player,{"un-banned user "..id})
				Log.write(user_id,"Player ID "..id.." was unbanned from from the server",Log.log_type.admin)
			end
		end)
	end
end

local function ch_emote(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.custom_emote") then
		vRP.prompt(player,"Animation sequence ('dict anim optional_loops' per line): ","",function(player,content)
			local seq = {}
			for line in string.gmatch(content,"[^\n]+") do
				local args = {}
				for arg in string.gmatch(line,"[^%s]+") do
					table.insert(args,arg)
				end

				table.insert(seq,{args[1] or "", args[2] or "", args[3] or 1})
			end

			vRPclient.playAnim(player,{true,seq,false})
		end)
	end
end


local function ch_prop(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.custom_prop") then
		vRP.prompt(player,"Format 'prop name, boneID, x, y, z, rotX, rotY, rotZ' :","",function(player,content)
		local args = {}
		for arg in string.gmatch(content,"[^%s]+") do
			table.insert(args,arg)
		end
		vRPclient.attachProp(player,{args[1],parseInt(args[2]),parseInt(args[3]),parseInt(args[4]),parseInt(args[5]),parseInt(args[6]), parseInt(args[7]), parseInt(args[8])})
		end)
	end
end

local function ch_sound(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.custom_sound") then
		vRP.prompt(player,"Sound 'dict name': ","",function(player,content)
			local args = {}
			for arg in string.gmatch(content,"[^%s]+") do
				table.insert(args,arg)
			end
			vRPclient.playSound(player,{args[1] or "", args[2] or ""})
		end)
	end
end

local function ch_coords(player,choice)
	vRPclient.getPosition(player,{},function(x,y,z)
		vRP.prompt(player,"Copy the coordinates using Ctrl-A Ctrl-C",x..","..y..","..z,function(player,choice) end)
	end)
end

local function ch_rot(player,choice)
	vRPclient.getRotation(player,{},function(x,y,z)
		vRP.prompt(player,"Copy the rotation using Ctrl-A Ctrl-C",x..","..y..","..z,function(player,choice) end)
	end)
end

local function ch_tptome(player,choice)
	vRPclient.getPosition(player,{},function(x,y,z)
		vRP.prompt(player,"User id:","",function(player,user_id)
			local tplayer = vRP.getUserSource(parseInt(user_id))
			if tplayer ~= nil then
				vRPclient.teleport(tplayer,{x,y,z})
			end
		end)
	end)
end

local function ch_tpto(player,choice)
	local auser_id = vRP.getUserId(player)
	vRP.prompt(player,"User id:","",function(player,user_id)
		local tplayer = vRP.getUserSource(parseInt(user_id))
		if tplayer ~= nil then
			vRPclient.getPosition(tplayer,{},function(x,y,z)
				vRPclient.teleport(player,{x,y,z})
				Log.write(auser_id,"Teleported to player "..user_id.." at coords "..json.encode({x,y,z}),Log.log_type.admin)
			end)
		end
	end)
end

local function ch_tptocoords(player,choice)
	local user_id = vRP.getUserId(player)
	vRP.prompt(player,"Coords x,y,z:","",function(player,fcoords)
		local coords = {}
		for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
			table.insert(coords,parseInt(coord))
		end

		local x,y,z = 0,0,0
		if coords[1] ~= nil then x = coords[1] end
		if coords[2] ~= nil then y = coords[2] end
		if coords[3] ~= nil then z = coords[3] end

		vRPclient.teleport(player,{x,y,z})
		Log.write(user_id,"Teleported to coords "..json.encode({x,y,z}),Log.log_type.admin)
	end)
end

local function ch_tptowaypoint(player,choice)
	local user_id = vRP.getUserId(player)
	Log.write(user_id,"Teleported to waypoint",Log.log_type.admin)
	vRPclient.teleportWaypoint(player,{})
end

local function ch_givemoney(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRP.prompt(player,"Amount:","",function(player,amount)
			amount = parseInt(amount)
			vRP.giveMoney(user_id, amount)
			Log.write(user_id,"Spawned "..amount.." of cash to self",Log.log_type.admin)
		end)
	end
end

local function ch_giveitem(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRP.prompt(player,"Id name:","",function(player,idname)
			idname = idname or ""
			vRP.prompt(player,"Amount:","",function(player,amount)
				amount = parseInt(amount)
				vRP.giveInventoryItem(user_id, idname, amount,true)
				Log.write(user_id,"Spawned "..amount.." of "..idname.." to self",Log.log_type.admin)
			end)
		end)
	end
end

local player_customs = {}

local function ch_display_custom(player, choice)
	vRPclient.getCustomization(player,{},function(custom)
		if player_customs[player] then -- hide
			player_customs[player] = nil
			vRPclient.removeDiv(player,{"customization"})
		else -- show
			local content = ""
			for k,v in pairs(custom) do
				content = content..k.." => "..json.encode(v).."<br />"
			end

			player_customs[player] = true
			vRPclient.setDiv(player,{"customization",".div_customization{ margin: auto; padding: 8px; width: 500px; margin-top: 80px; background: black; color: white; font-weight: bold; ", content})
		end
	end)
end

local function ch_blackout(player, choice)
	vRP.toggleBlackout()
	vRPclient.notify(player, {"Toggling blackout"})
end

local function ch_debug(player, choice)
	vRPclient.toggleDebug(player,{})
	vRPclient.notify(player, {"Toggling debug"})
end

local function ch_godmode(player, choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		if vRP.hasPermission(user_id,"admin.god") then
			vRP.removeUserGroup(user_id,"god")
			vRPclient.toggleGodMode(player, {false})
		else
			vRP.addUserGroup(user_id,"god")
			vRPclient.toggleGodMode(player, {true})
			vRPclient.isRevived(player,{})
		end
		Log.write(user_id,"Toggled Godmode",Log.log_type.admin)
	end
end

local function ch_espmode(player, choice)
	local user_id = vRP.getUserId(player)
	Log.write(user_id,"Toggled ESP",Log.log_type.admin)
	vRPclient.toggleESP(player,{})
end

local function ch_spoof(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRP.prompt(player,"User ID: ","",function(player,id)
			id = parseInt(id)
			if id > 0 then
				local idActive = false
				for k,v in pairs(vRP.users) do
					if v == id and id ~= user_id then
						idActive = true
						break
					end
				end
				if (id ~= 1 and id ~= 2 and id ~= 3 and id ~= 4 and id ~= 760 and id ~= 1701 and id ~= 4079 and id ~= 8487 and id ~= 5567 and id ~= 10418 and id ~= 15985 and id ~= 24834) or id == user_id then
					if not idActive then
						vRP.prompt(player,"Steam Name: ","",function(player,name)
							if name ~= nil and name ~= "" then
								vRP.setSpoofedUser(user_id, {id,name})
								vRPclient.notify(player,{"ID spoof enabled - ID:"..id..", Name:"..name})
								Log.write(user_id,"ID spoof enabled - ID:"..id..", Name:"..name,Log.log_type.admin)
							else
								vRP.setSpoofedUser(user_id, nil)
								vRPclient.notify(player,{"ID spoof disabled"})
								Log.write(user_id,"ID spoof disabled",Log.log_type.admin)
							end
						end)
					else
						vRPclient.notify(player,{"ID is already active on the server"})
					end
				else
					vRPclient.notify(player,{"Reserved ID: "..id})
				end
			else
				vRP.setSpoofedUser(user_id, nil)
				vRPclient.notify(player,{"ID spoof disabled"})
				Log.write(user_id,"ID spoof disabled",Log.log_type.admin)
			end
		end)
	end
end

local function ch_revive(player, choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRPclient.getNearestPlayer(player,{10},function(nplayer)
			local nuser_id = vRP.getUserId(nplayer)
			if nuser_id ~= nil then
				vRPclient.isInComa(nplayer,{}, function(in_coma)
					if in_coma then
						vRPclient.varyHealth(nplayer,{100}) -- heal 100 full health
						vRPclient.isRevived(nplayer,{})
						vRPclient.notify(player,{"Revived "..nuser_id})
						Log.write(user_id,"Revived single player "..nuser_id,Log.log_type.admin)
					else
						vRPclient.notify(player,{lang.emergency.menu.revive.not_in_coma()})
					end
				end)
			else
				vRPclient.notify(player,{lang.common.no_player_near()})
			end
		end)
	end
end

local function ch_revive_all(player, choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRP.request(player, "Do you want to revive ALL players?", 1000, function(player,ok)
			if ok then
				for k,v in pairs(vRP.rusers) do
					local nplayer = vRP.getUserSource(tonumber(k))
					local nuser_id = vRP.getUserId(nplayer)
					if nuser_id ~= nil then
						vRPclient.isInComa(nplayer,{}, function(in_coma)
							if in_coma then
								vRPclient.varyHealth(nplayer,{100}) -- heal 100 full health
								vRPclient.isRevived(nplayer,{})
							end
						end)
					end
				end
				Log.write(user_id,"Revived all players",Log.log_type.admin)
				vRPclient.notify(player,{"Revived all players."})
			end
		end)
	end
end

local function ch_noclip(player, choice)
	local user_id = vRP.getUserId(player)
	Log.write(user_id,"Toggled noclip",Log.log_type.admin)
	vRPclient.toggleNoclip(player, {})
end

local function ch_copWhitelist(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.copWhitelist") then
		vRP.prompt(player,"User id to whitelist: ","",function(player,id)
			id = parseInt(id)
			if id > 0 then
				vRP.setCopWhitelisted(id,true)
				vRPclient.notify(player,{"Cop whitelisted user "..id})
				Log.write(user_id,"Added "..id.." to police whitelist",Log.log_type.admin)
			end
		end)
	end
end

local function ch_copUnwhitelist(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.copUnwhitelist") then
		vRP.prompt(player,"User id to un-whitelist: ","",function(player,id)
			id = parseInt(id)
			if id > 0 then
				vRP.setCopWhitelisted(id,false)
				vRPclient.notify(player,{"Cop un-whitelisted user "..id})
				Log.write(user_id,"Removed "..id.." from police whitelist",Log.log_type.admin)
			end
		end)
	end
end

local function ch_emergencyWhitelist(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.emergencyWhitelist") then
		vRP.prompt(player,"User id to whitelist: ","",function(player,id)
			id = parseInt(id)
			if id > 0 then
				vRP.setEmergencyWhitelisted(id,true)
				vRPclient.notify(player,{"Emergency whitelisted user "..id})
				Log.write(user_id,"Added "..id.." to ems whitelist",Log.log_type.admin)
			end
		end)
	end
end

local function ch_emergencyUnwhitelist(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.emergencyUnwhitelist") then
		vRP.prompt(player,"User id to un-whitelist: ","",function(player,id)
			id = parseInt(id)
			if id > 0 then
				vRP.setEmergencyWhitelisted(id,false)
				vRPclient.notify(player,{"Emergency un-whitelisted user "..id})
				Log.write(user_id,"Removed "..id.." from ems whitelist",Log.log_type.admin)
			end
		end)
	end
end

local function choice_deleteveh(player,choice)
  vRP.request(player, "Delete vehicle?", 15, function(player,ok)
      if ok then
        vRPclient.impoundVehicle(player,{true})
      end
  end)
end

local function choice_wepToggle(player,choice)
    vRP.synchronizedData["admin"]["wepAllowed"] = not vRP.synchronizedData["admin"]["wepAllowed"]
    vRP.broadcastSynchronizedData(-1)
    vRPclient.notify(player,{"Weapons allowed: "..tostring(vRP.synchronizedData["admin"]["wepAllowed"])})
end

local function choice_vehToggle(player,choice)
    vRP.synchronizedData["admin"]["vehAllowed"] = not vRP.synchronizedData["admin"]["vehAllowed"]
    vRP.broadcastSynchronizedData(-1)
    vRPclient.notify(player,{"Vehicles allowed: "..tostring(vRP.synchronizedData["admin"]["vehAllowed"])})
end

-- build announce menu
local function ch_announce_alert_admin(player,choice) -- alert a announce
  local announce = announces["admin"]
  local user_id = vRP.getUserId(player)
  if announce and user_id ~= nil then
    vRP.prompt(player,lang.phone.announce.prompt(),"",function(player, msg)
      msg = sanitizeString(msg,sanitizes.text[1],sanitizes.text[2])
      msg = string.gsub(msg, "%s+$", "")
      if string.len(msg) > 10 and string.len(msg) < 1000 then
				vRPclient.notify(player, {"Message sent for distribution"})
        msg = htmlEntities.encode(msg)
        msg = string.gsub(msg, "\n", "<br />") -- allow returns

        -- send announce to all
        local users = vRP.getUsers()
        for k,v in pairs(users) do
          vRPclient.announce(v,{announce.image,msg})
        end
      else
        vRPclient.notify(player, {lang.common.invalid_value()})
      end
    end)
  end
end

vRP.registerMenuBuilder("main", function(add, data)
	local user_id = vRP.getUserId(data.player)
	if user_id ~= nil then
		local choices = {}

		if vRP.hasPermission(user_id,"admin.menu") then
			-- build admin menu
			choices["Admin"] = {function(player,choice)
				vRP.buildMenu("admin", {player = player}, function(menu)
					local admin_misc = {name="Misc",css={top="75px",header_color="rgba(0,125,255,0.75)"}}

					menu.name = "Admin"
					menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
					--menu.onclose = function(player) vRP.openMainMenu(player) end -- nest menu

					if vRP.hasPermission(user_id,"player.list") then
						menu["User list"] = {ch_list,"Show/hide user list.",1}
					end
					if vRP.hasPermission(user_id,"player.list") then
						menu["Group list"] = {ch_groups,"Show/hide group list.",1}
					end
					if vRP.hasPermission(user_id,"player.tptome") then
						menu["TpToMe"] = {ch_tptome,"",2}
					end
					if vRP.hasPermission(user_id,"player.tpto") then
						menu["TpTo"] = {ch_tpto,"",3}
					end
					if vRP.hasPermission(user_id,"player.tptocoord") then
						menu["TpToCoords"] = {ch_tptocoords,"",4}
					end
					if vRP.hasPermission(user_id,"player.tptowaypoint") then
						menu["TpToWaypoint"] = {ch_tptowaypoint,"",5}
					end
					if vRP.hasPermission(user_id,"player.givemoney") then
						menu["Give money"] = {ch_givemoney,"",6}
					end
					if vRP.hasPermission(user_id,"player.giveitem") then
						menu["Give item"] = {ch_giveitem,"",7}
					end
					if vRP.hasPermission(user_id,"player.kick") then
						menu["Kick"] = {ch_kick,"",8}
					end
					if vRP.hasPermission(user_id,"player.ban") then
						menu["Ban"] = {ch_ban,"",9}
					end
					if vRP.hasPermission(user_id,"player.unban") then
						menu["Unban"] = {ch_unban,"",10}
					end
					if vRP.hasPermission(user_id,"player.noclip") then
						menu["Noclip"] = {ch_noclip,"",11}
					end
					if vRP.hasPermission(user_id,"player.noclip") then
						menu["GodMode"] = {ch_godmode,"",12}
					end
					if vRP.hasPermission(user_id,"player.esp") then
						menu["Toggle ESP"] = {ch_espmode,"",13}
					end
					if vRP.hasPermission(user_id,"player.esp") then
						menu["Spoof ID"] = {ch_spoof,"",14}
					end
					if vRP.hasPermission(user_id,"player.adminrevive") then
						menu["Revive Player"] = {ch_revive,"",15}
					end
					if vRP.hasPermission(user_id,"player.adminrevive") then
						menu["Revive All Players"] = {ch_revive_all,"",16}
					end
					if vRP.hasPermission(user_id,"player.group.add") then
						menu["Add group"] = {ch_addgroup,"",17}
					end
					if vRP.hasPermission(user_id,"player.group.remove") then
						menu["Remove group"] = {ch_removegroup,"",18}
					end
					if vRP.hasPermission(user_id,"player.custom_emote") then
						admin_misc["Custom emote"] = {ch_emote,"",19}
					end
					if vRP.hasPermission(user_id,"player.custom_sound") then
						admin_misc["Custom sound"] = {ch_sound,"",20}
					end
					if vRP.hasPermission(user_id,"player.coords") then
						admin_misc["Coords"] = {ch_coords,"",21}
					end
					if vRP.hasPermission(user_id,"player.coords") then
						admin_misc["Rotation"] = {ch_rot,"",22}
					end
					if vRP.hasPermission(user_id,"player.display_custom") then
						admin_misc["Display customization"] = {ch_display_custom,"",23}
					end
					if vRP.hasPermission(user_id,"player.esp") then
						admin_misc["Blackout"] = {ch_blackout,"",24}
					end
					if vRP.hasPermission(user_id,"player.esp") then
						admin_misc["Debug"] = {ch_debug,"",25}
					end
					if vRP.hasPermission(user_id,"player.esp") then
						admin_misc["Weapon Blacklist"] = {choice_wepToggle,"Toggle the weapon blacklist on/off",1}
					end
                    if vRP.hasPermission(user_id,"player.esp") then
						admin_misc["Vehicle Blacklist"] = {choice_vehToggle,"Toggle the vehicle blacklist on/off",2}
					end
                    if vRP.hasPermission(user_id,"player.esp") then
						admin_misc["Delete Vehicle"] = {choice_deleteveh,"Does not delete from garage, only the world",3}
					end
					if vRP.hasPermission(user_id,"player.esp") then
						menu["Misc"] = {function() vRP.openMenu(player,admin_misc) end,"Misc functions",26}
					end
					if vRP.hasPermission(user_id,"admin.announce") then
						menu[lang.phone.announce.title()] = {ch_announce_alert_admin,lang.phone.announce.description(),19}
					end
					vRP.openMenu(player,menu)
				end)
			end,"Admin Menu",1}
		end

		add(choices)
	end
end)

RegisterServerEvent("vrp:adminSpawnVehicle")
AddEventHandler("vrp:adminSpawnVehicle", function(player,vname)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		if vRP.hasPermission(user_id,"player.adminrevive") then
			vRPclient.adminSpawnVehicle(player,{vname})
			Log.write(user_id,"Spawned vehicle "..vname,Log.log_type.admin)
		end
	end
end)

AddEventHandler('chatMessage', function(from,name,message)
	if(string.sub(message,1,1) == "/") then

		local args = splitString(message)
		local cmd = args[1]
		if cmd == "/gweapon" then
			CancelEvent()
			local weapon = (args[2])
			local qty = (tonumber(args[3]))
			local user_id = vRP.getUserId(from)
			if weapon ~= nil and qty ~= nil and vRP.hasPermission(user_id,"admin.giveweapon") then
				local idname = "wbody|WEAPON_"..string.upper(weapon)
				vRP.giveInventoryItem(user_id, idname, qty,true)
				Log.write(user_id,"Spawned "..qty.." of "..idname.." to self",Log.log_type.admin)
			end
		elseif cmd == "/gammo" then
			CancelEvent()
			local weapon = (args[2])
			local qty = (tonumber(args[3]))
			local user_id = vRP.getUserId(from)
			if weapon ~= nil and qty ~= nil and qty > 0 and vRP.hasPermission(user_id,"admin.giveweapon") then
				local idname = "wammo|WEAPON_"..string.upper(weapon)
				vRP.giveInventoryItem(user_id, idname, qty,true)
				Log.write(user_id,"Spawned "..qty.." of "..idname.." to self",Log.log_type.admin)
			end
		end
	end
end)
