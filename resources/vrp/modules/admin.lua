local htmlEntities = module("lib/htmlEntities")
local Tools = module("lib/Tools")

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
            content = content.."<br />["..k.."] => "..GetPlayerName(source)
            if identity then
              content = content.." "..htmlEntities.encode(identity.firstname).." "..htmlEntities.encode(identity.name).." "..identity.registration
            end
          end

          -- check end
          count = count-1
          if count == 0 then
            player_lists[player] = true
            vRPclient.setDiv(player,{"user_list",".div_user_list{ margin: auto; padding: 8px; width: 500px; margin-top: 80px; background: black; color: white; font-weight: bold; ", content})
          end
        end)
      end
    end
  end
end

local function ch_whitelist(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.whitelist") then
    vRP.prompt(player,"User id to whitelist: ","",function(player,id)
      id = parseInt(id)
      vRP.setWhitelisted(id,true)
      vRPclient.notify(player,{"whitelisted user "..id})
    end)
  end
end

local function ch_unwhitelist(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.unwhitelist") then
    vRP.prompt(player,"User id to un-whitelist: ","",function(player,id)
      id = parseInt(id)
      vRP.setWhitelisted(id,false)
      vRPclient.notify(player,{"un-whitelisted user "..id})
    end)
  end
end

local function ch_addgroup(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.group.add") then
    vRP.prompt(player,"User id: ","",function(player,id)
      id = parseInt(id)
      vRP.prompt(player,"Group to add: ","",function(player,group)
        vRP.addUserGroup(id,group)
        vRPclient.notify(player,{group.." added to user "..id})
      end)
    end)
  end
end

local function ch_removegroup(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.group.remove") then
    vRP.prompt(player,"User id: ","",function(player,id)
      id = parseInt(id)
      vRP.prompt(player,"Group to remove: ","",function(player,group)
        vRP.removeUserGroup(id,group)
        vRPclient.notify(player,{group.." removed from user "..id})
      end)
    end)
  end
end

local function ch_kick(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.kick") then
    vRP.prompt(player,"User id to kick: ","",function(player,id)
      id = parseInt(id)
      vRP.prompt(player,"Reason: ","",function(player,reason)
        local source = vRP.getUserSource(id)
        if source ~= nil then
          vRP.kick(source,reason)
          vRPclient.notify(player,{"kicked user "..id})
        end
      end)
    end)
  end
end

local function ch_ban(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.ban") then
    vRP.prompt(player,"User id to ban: ","",function(player,id)
      id = parseInt(id)
      vRP.prompt(player,"Reason: ","",function(player,reason)
        local source = vRP.getUserSource(id)
        if source ~= nil then
          vRP.ban(source,reason,user_id)
          vRPclient.notify(player,{"banned user "..id})
        end
      end)
    end)
  end
end

local function ch_unban(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.unban") then
    vRP.prompt(player,"User id to unban: ","",function(player,id)
      id = parseInt(id)
      vRP.setBanned(id,false,"",0)
      vRPclient.notify(player,{"un-banned user "..id})
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
  vRP.prompt(player,"User id:","",function(player,user_id)
    local tplayer = vRP.getUserSource(parseInt(user_id))
    if tplayer ~= nil then
      vRPclient.getPosition(tplayer,{},function(x,y,z)
        vRPclient.teleport(player,{x,y,z})
      end)
    end
  end)
end

local function ch_tptocoords(player,choice)
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
  end)
end

local function ch_tptowaypoint(player,choice)
  vRPclient.teleportWaypoint(player,{})
end

local function ch_givemoney(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRP.prompt(player,"Amount:","",function(player,amount)
      amount = parseInt(amount)
      vRP.giveMoney(user_id, amount)
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

local function ch_godmode(player, choice)
  vRPclient.toggleGodMode(player, {})
end

local function ch_noclip(player, choice)
  vRPclient.toggleNoclip(player, {})
end

local function ch_copWhitelist(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.copWhitelist") then
    vRP.prompt(player,"User id to whitelist: ","",function(player,id)
      id = parseInt(id)
      vRP.setCopWhitelisted(id,true)
      vRPclient.notify(player,{"Cop whitelisted user "..id})
    end)
  end
end

local function ch_copUnwhitelist(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.copUnwhitelist") then
    vRP.prompt(player,"User id to un-whitelist: ","",function(player,id)
      id = parseInt(id)
      vRP.setCopWhitelisted(id,false)
      vRPclient.notify(player,{"Cop un-whitelisted user "..id})
    end)
  end
end

local function ch_emergencyWhitelist(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.emergencyWhitelist") then
    vRP.prompt(player,"User id to whitelist: ","",function(player,id)
      id = parseInt(id)
      vRP.setEmergencyWhitelisted(id,true)
      vRPclient.notify(player,{"Emergency whitelisted user "..id})
    end)
  end
end

local function ch_emergencyUnwhitelist(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.emergencyUnwhitelist") then
    vRP.prompt(player,"User id to un-whitelist: ","",function(player,id)
      id = parseInt(id)
      vRP.setEmergencyWhitelisted(id,false)
      vRPclient.notify(player,{"Emergency un-whitelisted user "..id})
    end)
  end
end

vRP.registerMenuBuilder("main", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id ~= nil then
    local choices = {}

    -- build admin menu
    choices["Admin"] = {function(player,choice)
      vRP.buildMenu("admin", {player = player}, function(menu)
        menu.name = "Admin"
        menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
        menu.onclose = function(player) vRP.openMainMenu(player) end -- nest menu

        if vRP.hasPermission(user_id,"player.list") then
          menu["@User list"] = {ch_list,"Show/hide user list."}
        end
        if vRP.hasPermission(user_id,"player.whitelist") then
          menu["@Whitelist user"] = {ch_whitelist}
        end
        if vRP.hasPermission(user_id,"player.group.add") then
          menu["@Add group"] = {ch_addgroup}
        end
        if vRP.hasPermission(user_id,"player.group.remove") then
          menu["@Remove group"] = {ch_removegroup}
        end
        if vRP.hasPermission(user_id,"player.unwhitelist") then
          menu["@Un-whitelist user"] = {ch_unwhitelist}
        end
        if vRP.hasPermission(user_id,"player.kick") then
          menu["@Kick"] = {ch_kick}
        end
        if vRP.hasPermission(user_id,"player.ban") then
          menu["@Ban"] = {ch_ban}
        end
        if vRP.hasPermission(user_id,"player.unban") then
          menu["@Unban"] = {ch_unban}
        end
        if vRP.hasPermission(user_id,"player.noclip") then
          menu["@Noclip"] = {ch_noclip}
        end
        if vRP.hasPermission(user_id,"player.noclip") then
          menu["@GodMode"] = {ch_godmode}
        end
        if vRP.hasPermission(user_id,"player.custom_emote") then
          menu["@Custom emote"] = {ch_emote}
        end
        if vRP.hasPermission(user_id,"player.custom_sound") then
          menu["@Custom sound"] = {ch_sound}
        end
        if vRP.hasPermission(user_id,"player.coords") then
          menu["@Coords"] = {ch_coords}
        end
        if vRP.hasPermission(user_id,"player.tptome") then
          menu["@TpToMe"] = {ch_tptome}
        end
        if vRP.hasPermission(user_id,"player.tpto") then
          menu["@TpTo"] = {ch_tpto}
        end
        if vRP.hasPermission(user_id,"player.tptocoord") then
          menu["@TpToCoords"] = {ch_tptocoords}
        end
        if vRP.hasPermission(user_id,"player.tptowaypoint") then
          menu["@TpToWaypoint"] = {ch_tptowaypoint}
        end
        if vRP.hasPermission(user_id,"player.givemoney") then
          menu["@Give money"] = {ch_givemoney}
        end
        if vRP.hasPermission(user_id,"player.giveitem") then
          menu["@Give item"] = {ch_giveitem}
        end
        if vRP.hasPermission(user_id,"player.display_custom") then
          menu["@Display customization"] = {ch_display_custom}
        end
        if vRP.hasPermission(user_id,"player.copWhitelist") then
          menu["@Whitelist Cop"] = {ch_copWhitelist}
        end
        if vRP.hasPermission(user_id,"player.copUnwhitelist") then
          menu["@Un-whitelist Cop"] = {ch_copUnwhitelist}
        end
        if vRP.hasPermission(user_id,"player.emergencyWhitelist") then
          menu["@Whitelist Emergency"] = {ch_emergencyWhitelist}
        end
        if vRP.hasPermission(user_id,"player.emergencyUnwhitelist") then
          menu["@Un-whitelist Emergency"] = {ch_emergencyUnwhitelist}
        end

        vRP.openMenu(player,menu)
      end)
    end}

    add(choices)
  end
end)
