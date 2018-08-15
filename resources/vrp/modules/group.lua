
-- this module describe the group/permission system

-- group functions are used on connected players only
-- multiple groups can be set to the same player, but the gtype config option can be used to set some groups as unique

-- api

local cfg = module("cfg/groups")
local emergency = module("cfg/emergency")
local police = module("cfg/police")
local Log = module("lib/Log")
local groups = cfg.groups
local users = cfg.users
local selectors = cfg.selectors

-- get groups keys of a connected user
function vRP.getUserGroups(user_id)
  local data = vRP.getUserDataTable(user_id)
  if data then
    if data.groups == nil then
      data.groups = {} -- init groups
    end

    return data.groups
  else
    return {}
  end
end

-- add a group to a connected user
function vRP.addUserGroup(user_id,group)
  if not vRP.hasGroup(user_id,group) then
    local user_groups = vRP.getUserGroups(user_id)
    local ngroup = groups[group]
    if ngroup then
      if ngroup._config and ngroup._config.gtype ~= nil then
        -- copy group list to prevent iteration while removing
        local _user_groups = {}
        for k,v in pairs(user_groups) do
          _user_groups[k] = v
        end

        for k,v in pairs(_user_groups) do -- remove all groups with the same gtype
          local kgroup = groups[k]
          if kgroup and kgroup._config and ngroup._config and kgroup._config.gtype == ngroup._config.gtype then
            vRP.removeUserGroup(user_id,k)
          end
        end
      end

      -- add group
      user_groups[group] = true
      local player = vRP.getUserSource(user_id)
      if ngroup._config and ngroup._config.onjoin and player ~= nil then
        ngroup._config.onjoin(player) -- call join callback
      end

      -- trigger join event
      local gtype = nil
      if ngroup._config then
        gtype = ngroup._config.gtype
      end
      TriggerEvent("vRP:playerJoinGroup", user_id, group, gtype)
      Log.write(user_id,"Added to group: "..group,Log.log_type.action)
    end
  end
end

-- get user group by type
-- return group name or an empty string
function vRP.getUserGroupByType(user_id,gtype)
  local user_groups = vRP.getUserGroups(user_id)
  for k,v in pairs(user_groups) do
    local kgroup = groups[k]
    if kgroup then
      if kgroup._config and kgroup._config.gtype and kgroup._config.gtype == gtype then
        return k
      end
    end
  end

  return ""
end

-- return list of connected users by group
function vRP.getUsersByGroup(group)
  local users = {}

  for k,v in pairs(vRP.rusers) do
    if vRP.hasGroup(tonumber(k),group) then table.insert(users, tonumber(k)) end
  end

  return users
end

-- return list of connected users by permission
function vRP.getUsersByPermission(perm)
  local users = {}

  for k,v in pairs(vRP.rusers) do
    if vRP.hasPermission(tonumber(k),perm) then table.insert(users, tonumber(k)) end
  end

  return users
end

function vRP.getUserCountByPermission(perm)
  local count = 0

  for k,v in pairs(vRP.rusers) do
    if vRP.hasPermission(tonumber(k),perm) then
      count = count + 1
    end
  end

  return count
end

-- remove a group from a connected user
function vRP.removeUserGroup(user_id,group)
  local user_groups = vRP.getUserGroups(user_id)
  local groupdef = groups[group]
  local source = vRP.getUserSource(user_id)
  if groupdef and groupdef._config and groupdef._config.onleave then
    if source ~= nil then
      groupdef._config.onleave(source) -- call leave callback
    end
  end

  -- trigger leave event
  local gtype = nil
  if groupdef._config then
    gtype = groupdef._config.gtype
  end
  TriggerEvent("vRP:playerLeaveGroup", user_id, group, gtype)

  user_groups[group] = nil -- remove reference
  if group == "police" then
    vRP.removeInformer(source)
  end
  Log.write(user_id,"Removed from group: "..group,Log.log_type.action)
end

-- check if the user has a specific group
function vRP.hasGroup(user_id,group)
  local user_groups = vRP.getUserGroups(user_id)
  return (user_groups[group] ~= nil)
end

-- check if the user has a specific permission
function vRP.hasPermission(user_id, perm)
  local user_groups = vRP.getUserGroups(user_id)

  local fchar = string.sub(perm,1,1)

  if fchar == "@" then -- special aptitude permission
    local _perm = string.sub(perm,2,string.len(perm))
    local parts = splitString(_perm,".")
    if #parts == 3 then -- decompose group.aptitude.operator
      local group = parts[1]
      local aptitude = parts[2]
      local op = parts[3]

      local alvl = math.floor(vRP.expToLevel(vRP.getExp(user_id,group,aptitude)))

      local fop = string.sub(op,1,1)
      if fop == "<" then  -- less (group.aptitude.<x)
        local lvl = parseInt(string.sub(op,2,string.len(op)))
        if alvl < lvl then return true end
      elseif fop == ">" then -- greater (group.aptitude.>x)
        local lvl = parseInt(string.sub(op,2,string.len(op)))
        if alvl > lvl then return true end
      else -- equal (group.aptitude.x)
        local lvl = parseInt(string.sub(op,1,string.len(op)))
        if alvl == lvl then return true end
      end
    end
  elseif fchar == "#" then -- special item permission
    local _perm = string.sub(perm,2,string.len(perm))
    local parts = splitString(_perm,".")
    if #parts == 2 then -- decompose item.operator
      local item = parts[1]
      local op = parts[2]

      local amount = vRP.getInventoryItemAmount(user_id, item)

      local fop = string.sub(op,1,1)
      if fop == "<" then  -- less (item.<x)
        local n = parseInt(string.sub(op,2,string.len(op)))
        if amount < n then return true end
      elseif fop == ">" then -- greater (item.>x)
        local n = parseInt(string.sub(op,2,string.len(op)))
        if amount > n then return true end
      else -- equal (item.x)
        local n = parseInt(string.sub(op,1,string.len(op)))
        if amount == n then return true end
      end
    end
  else -- regular plain permission
    -- precheck negative permission
    local nperm = "-"..perm
    for k,v in pairs(user_groups) do
      if v then -- prevent issues with deleted entry
        local group = groups[k]
        if group then
          for l,w in pairs(group) do -- for each group permission
            if l ~= "_config" and w == nperm then return false end
          end
        end
      end
    end

    -- check if the permission exists
    for k,v in pairs(user_groups) do
      if v then -- prevent issues with deleted entry
        local group = groups[k]
        if group then
          for l,w in pairs(group) do -- for each group permission
            if l ~= "_config" and w == perm then return true end
          end
        end
      end
    end
  end

  return false
end

-- check if the user has a specific list of permissions (all of them)
function vRP.hasPermissions(user_id, perms)
  for k,v in pairs(perms) do
    if not vRP.hasPermission(user_id, v) then
      return false
    end
  end

  return true
end


-- GROUP SELECTORS

local function ch_select(player,choice)
  local user_id = vRP.getUserId(player)
  local group = groups[choice]
  local ok = true
  if user_id ~= nil then
  	if choice == "police" and police.whitelist then
      vRP.isCopWhitelisted(user_id, function(whitelisted)
        if whitelisted then
          vRP.getCopLevel(user_id, function(rank)
            vRP.addUserGroup(user_id, choice)
            if rank > 0 then
              vRP.addUserGroup(user_id, "police_rank"..rank)
              vRP.addInformer(player)
              vRPclient.setCopLevel(player,{rank})
            end
            vRP.closeMenu(player)
          end)
    		else
          ok = false
    			vRPclient.notify(player,{"You are not a whitelisted Police Officer."})
        end
      end)
      vRPclient.setEmergencyLevel(player,{0})
    elseif choice == "emergency" and emergency.whitelist then
      vRP.isEmergencyWhitelisted(user_id, function(whitelisted)
        if whitelisted then
          vRP.getMedicLevel(user_id, function(rank)
            vRP.addUserGroup(user_id, choice)
            if rank > 0 then
              vRP.addUserGroup(user_id, "ems_rank"..rank)
              vRPclient.setEmergencyLevel(player,{rank})
            end
            vRP.closeMenu(player)
          end)
    		else
          ok = false
    			vRPclient.notify(player,{"You are not whitelisted for EMS."})
        end
      end)
      vRPclient.setCopLevel(player,{0})
  	else
  		vRP.addUserGroup(user_id, choice)
      vRPclient.setCopLevel(player,{0})
      vRPclient.setEmergencyLevel(player,{0})
      vRP.removeInformer(player)
  		vRP.closeMenu(player)
  	end
    if group._config.name ~= nil and ok then
      vRPclient.setJobLabel(player,{group._config.name})
    end
  end
end

-- build menus
local selector_menus = {}
for k,v in pairs(selectors) do
  local menu = {name=k, css={top="75px",header_color="rgba(255,154,24,0.75)"}}
  for l,w in pairs(v) do
    if l ~= "_config" then
      menu[w] = {ch_select}
    end
  end

  selector_menus[k] = menu
end

local function build_client_selectors(source)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    for k,v in pairs(selectors) do
      local gcfg = v._config
      local menu = selector_menus[k]

      if gcfg and menu then
        local x = gcfg.x
        local y = gcfg.y
        local z = gcfg.z

        local function selector_enter()
          local user_id = vRP.getUserId(source)
          if user_id ~= nil and vRP.hasPermissions(user_id,gcfg.permissions or {}) then
            vRP.openMenu(source,menu)
          end
        end

        local function selector_leave()
          vRP.closeMenu(source)
        end

        vRPclient.addBlip(source,{x,y,z,gcfg.blipid,gcfg.blipcolor,k})
        vRPclient.addMarker(source,{x,y,z-0.97,0.7,0.7,0.5,255,154,24,125,150,23})

        vRP.setArea(source,"vRP:gselector:"..k,x,y,z,1,1.5,selector_enter,selector_leave)
      end
    end
  end
end

-- events

-- player spawn
AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)

  local user_groups = vRP.getUserGroups(user_id)
  -- first spawn
  if first_spawn then
    -- add selectors
    build_client_selectors(source)

    -- add default group user
    vRP.addUserGroup(user_id,"user")
    vRP.addUserGroup(user_id,"citizen")
    vRPclient.setJobLabel(source,{'Unemployed'})

    for k,v in pairs(user_groups) do
      local group = groups[k]
      if group and group._config and group._config.clearFirstSpawn then
        vRP.removeUserGroup(user_id,group)
      end
    end
  end

  -- call group onspawn callback at spawn
  for k,v in pairs(user_groups) do
    local group = groups[k]
    if group and group._config and group._config.onspawn then
      group._config.onspawn(source)
    end
  end
end)
