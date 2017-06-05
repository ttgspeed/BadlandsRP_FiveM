local htmlEntities = require("resources/vrp/lib/htmlEntities")
local Tools = require("resources/vrp/lib/Tools")

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
      for k,v in pairs(vRP.rusers) do
        local source = vRP.getUserSource(k)
        local identity = vRP.getUserIdentity(k)
        if source ~= nil then
          content = content.."<br />["..k.."] => "..GetPlayerName(source)
          if identity then
            content = content.." "..htmlEntities.encode(identity.firstname).." "..htmlEntities.encode(identity.name).." "..identity.registration
          end
        end
      end

      player_lists[player] = true
      vRPclient.setDiv(player,{"user_list",".div_user_list{ margin: auto; padding: 8px; width: 500px; margin-top: 80px; background: black; color: white; font-weight: bold; ", content})
    end
  end
end

local function ch_whitelist(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.whitelist") then
    vRP.prompt(player,"User id to whitelist: ","",function(player,id)
      id = tonumber(id)
      vRP.setWhitelisted(id,true)
      vRPclient.notify(player,{"whitelisted user "..id})
    end)
  end
end

local function ch_unwhitelist(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.unwhitelist") then
    vRP.prompt(player,"User id to un-whitelist: ","",function(player,id)
      id = tonumber(id)
      vRP.setWhitelisted(id,false)
      vRPclient.notify(player,{"un-whitelisted user "..id})
    end)
  end
end

local function ch_addgroup(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.group.add") then
    vRP.prompt(player,"User id: ","",function(player,id)
      id = tonumber(id)
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
      id = tonumber(id)
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
      id = tonumber(id)
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
      id = tonumber(id)
      vRP.prompt(player,"Reason: ","",function(player,reason)
        local source = vRP.getUserSource(id)
        if source ~= nil then
          vRP.ban(source,reason)
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
      id = tonumber(id)
      vRP.setBanned(id,false)
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

local function ch_coords(player,choice)
  vRPclient.getPosition(player,{},function(x,y,z)
    vRP.prompt(player,"Copy the coordinates using Ctrl-A Ctrl-C",x..","..y..","..z,function(player,choice) end)
  end)
end

local function ch_tptome(player,choice)
  vRPclient.getPosition(player,{},function(x,y,z)
    vRP.prompt(player,"User id:","",function(player,user_id) 
      local tplayer = vRP.getUserSource(tonumber(user_id))
      if tplayer ~= nil then
        vRPclient.teleport(tplayer,{x,y,z})
      end
    end)
  end)
end

local function ch_tpto(player,choice)
  vRP.prompt(player,"User id:","",function(player,user_id) 
    local tplayer = vRP.getUserSource(tonumber(user_id))
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
      table.insert(coords,tonumber(coord))
    end

    local x,y,z = 0,0,0
    if coords[1] ~= nil then x = coords[1] end
    if coords[2] ~= nil then y = coords[2] end
    if coords[3] ~= nil then z = coords[3] end

    vRPclient.teleport(player,{x,y,z})
  end)
end

local function ch_givemoney(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRP.prompt(player,"Amount:","",function(player,amount) 
      amount = tonumber(amount)
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
        amount = tonumber(amount)
        vRP.giveInventoryItem(user_id, idname, amount)
      end)
    end)
  end
end

local function ch_calladmin(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRP.prompt(player,"Describe your problem:","",function(player,desc) 
      desc = desc or ""

      local answered = false
      local players = {}
      for k,v in pairs(vRP.rusers) do
        local player = vRP.getUserSource(tonumber(k))
        -- check user
        if vRP.hasPermission(k,"admin.tickets") and player ~= nil then
          table.insert(players,player)
        end
      end

      -- send notify and alert to all listening players
      for k,v in pairs(players) do
        vRP.request(v,"Admin ticket (user_id = "..user_id..") take/TP to ?: "..htmlEntities.encode(desc), 60, function(v,ok)
          if ok then -- take the call
            if not answered then
              -- answer the call
              vRPclient.notify(player,{"An admin took your ticket."})
              vRPclient.getPosition(player, {}, function(x,y,z)
                vRPclient.teleport(v,{x,y,z})
              end)
              answered = true
            else
              vRPclient.notify(v,{"Ticket already taken."})
            end
          end
        end)
      end
    end)
  end
end

local function ch_noclip(player, choice)
  vRPclient.toggleNoclip(player, {})
end

AddEventHandler("vRP:buildMainMenu",function(player)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    local choices = {}

    -- build admin menu
    choices["Admin"] = {function(player,choice)

      local menu = {name="Admin",css={top="75px",header_color="rgba(200,0,0,0.75)"}}
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
      if vRP.hasPermission(user_id,"player.custom_emote") then
        menu["@Custom emote"] = {ch_emote}
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
      if vRP.hasPermission(user_id,"player.tpto") then
        menu["@TpToCoords"] = {ch_tptocoords}
      end
      if vRP.hasPermission(user_id,"player.givemoney") then
        menu["@Give money"] = {ch_givemoney}
      end
      if vRP.hasPermission(user_id,"player.giveitem") then
        menu["@Give item"] = {ch_giveitem}
      end
      if vRP.hasPermission(user_id,"player.calladmin") then
        menu["@Call admin"] = {ch_calladmin}
      end

      vRP.openMenu(player,menu)
    end}

    vRP.buildMainMenu(player,choices)
  end
end)
