--MySQL = module("vrp_mysql", "MySQL")

local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
local Lang = module("lib/Lang")
local Log = module("lib/Log")
Debug = module("lib/Debug")

local config = module("cfg/base")
local version = module("version")
Debug.active = config.debug

-- versioning
print("[vRP] launch version "..version)
--[[
PerformHttpRequest("https://raw.githubusercontent.com/ImagicTheCat/vRP/master/vrp/version.lua",function(err,text,headers)
  if err == 0 then
    text = string.gsub(text,"return ","")
    local r_version = tonumber(text)
    if version ~= r_version then
      print("[vRP] WARNING: A new version of vRP is available here https://github.com/ImagicTheCat/vRP, update to benefit from the last features and to fix exploits/bugs.")
    end
  else
    print("[vRP] unable to check the remote version")
  end
end, "GET", "")
--]]

vRP = {}
Proxy.addInterface("vRP",vRP)

tvRP = {}
Tunnel.bindInterface("vRP",tvRP) -- listening for client tunnel

-- load language
local dict = module("cfg/lang/"..config.lang) or {}
vRP.lang = Lang.new(dict)

-- init
vRPclient = Tunnel.getInterface("vRP","vRP") -- server -> client tunnel

vRP.users = {} -- will store logged users (id) by first identifier
vRP.rusers = {} -- store the opposite of users
vRP.user_tables = {} -- user data tables (logger storage, saved to database)
vRP.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
vRP.server_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
vRP.user_sources = {} -- user sources

-- identification system

--- sql.
function vRP.updateUserIdentifier(pname,ids)
  if pname ~= nil and ids ~= nil then
    local colonPos = string.find(ids,":")
    local steamid64 = string.sub(ids,colonPos+1)
    steamid64 = tonumber(steamid64,16)..""

    MySQL.Async.execute('UPDATE vrp_user_ids SET steam_name = @steam_name, steamid64 = @steamid64 WHERE identifier = @identifier', {steam_name = pname, steamid64 = steamid64, identifier = identifier}, function(rowsChanged) end)
  end
end

-- cbreturn user id or nil in case of error (if not found, will create it)
function vRP.getUserIdByIdentifiers(ids, cbr)
  local task = Task(cbr)

  if ids ~= nil and #ids then
    local i = 0

    -- search identifiers
    local function search()
      i = i+1
      if i <= #ids then
        if not config.ignore_ip_identifier or (string.find(ids[i], "ip:") == nil) then  -- ignore ip identifier
          MySQL.Async.fetchAll("SELECT user_id FROM vrp_user_ids WHERE identifier = @identifier",{identifier = ids[i]},function(rows)
            if #rows > 0 then  -- found
              task({rows[1].user_id})
            else -- not found
              search()
            end
          end)
        else
          search()
        end
      else -- no ids found, create user
        MySQL.Async.fetchAll('INSERT INTO vrp_users(whitelisted,banned,cop,emergency) VALUES(false,false,false,false); SELECT LAST_INSERT_ID() AS id', {}, function(rows)
          if #rows > 0 then
            local user_id = rows[1].id
            -- add identifiers
            for l,w in pairs(ids) do
              if not config.ignore_ip_identifier or (string.find(w, "ip:") == nil) then  -- ignore ip identifier
                MySQL.Async.execute('INSERT INTO vrp_user_ids(identifier,user_id) VALUES(@identifier,@user_id)', {user_id = user_id, identifier = w}, function(rowsChanged) end)
              end
            end

            task({user_id})
          else
            task()
          end
        end)
      end
    end

    search()
  else
    task()
  end
end

-- return identification string for the source (used for non vRP identifications, for rejected players)
function vRP.getSourceIdKey(source)
  local ids = GetPlayerIdentifiers(source)
  local idk = "idk_"
  for k,v in pairs(ids) do
    idk = idk..v
  end

  return idk
end

function vRP.getPlayerEndpoint(player)
  return GetPlayerEP(player) or "0.0.0.0"
end

function vRP.getPlayerName(player)
  return GetPlayerName(player) or "unknown"
end

--- sql
function vRP.isBanned(user_id, cbr)
  local task = Task(cbr, {false})

  MySQL.Async.fetchAll('SELECT banned, ban_reason FROM vrp_users WHERE id = @user_id', {user_id = user_id}, function(rows)
    if #rows > 0 then
      task({rows[1].banned,rows[1].ban_reason})
    else
      task()
    end
  end)
end

--- sql
function vRP.setBanned(user_id,banned,reason,adminID)
  MySQL.Async.execute('UPDATE vrp_users SET banned = @banned, ban_reason = @reason, banned_by_admin_id = @adminID WHERE id = @user_id', {user_id = user_id, banned = banned, reason = reason, adminID = adminID}, function(rowsChanged) end)
end

--- sql
function vRP.isWhitelisted(user_id, cbr)
  local task = Task(cbr, {false})
  MySQL.Async.fetchAll('SELECT whitelisted FROM vrp_users WHERE id = @user_id', {user_id = user_id}, function(rows)
    if #rows > 0 then
      task({rows[1].whitelisted})
    else
      task()
    end
  end)
end

--- sql
function vRP.setWhitelisted(user_id,whitelisted)
  MySQL.Async.execute('UPDATE vrp_users SET whitelisted = @whitelisted WHERE id = @user_id', {user_id = user_id, whitelisted = whitelisted}, function(rowsChanged) end)
end

--- sql
function vRP.getLastLogin(user_id, cbr)
  local task = Task(cbr,{""})
  MySQL.Async.fetchAll('SELECT last_login FROM vrp_users WHERE id = @user_id', {user_id = user_id}, function(rows)
    if #rows > 0 then
      task({rows[1].last_login})
    else
      task()
    end
  end)
end

function vRP.setUData(user_id,key,value)
  MySQL.Async.execute('REPLACE INTO vrp_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)', {user_id = user_id, key = key, value = value}, function(rowsChanged) end)
end

function vRP.getUData(user_id,key,cbr)
  local task = Task(cbr,{""})
  MySQL.Async.fetchAll('SELECT dvalue FROM vrp_user_data WHERE user_id = @user_id AND dkey = @key', {user_id = user_id, key = key}, function(rows)
    if #rows > 0 then
      task({rows[1].dvalue})
    else
      task()
    end
  end)
end

function vRP.setSData(key,value)
  MySQL.Async.execute('REPLACE INTO vrp_srv_data(dkey,dvalue) VALUES(@key,@value)', {key = key, value = value}, function(rowsChanged) end)
end

function vRP.setSTempData(key,value)
  vRP.server_tmp_tables[key] = value
end

function vRP.getSTempData(key)
  return vRP.server_tmp_tables[key]
end

function vRP.getSData(key, cbr)
  local task = Task(cbr,{""})
  MySQL.Async.fetchAll('SELECT dvalue FROM vrp_srv_data WHERE dkey = @key', {key = key}, function(rows)
    if #rows > 0 then
      task({rows[1].dvalue})
    else
      task()
    end
  end)
end

-- return user data table for vRP internal persistant connected user storage
function vRP.getUserDataTable(user_id)
  return vRP.user_tables[user_id]
end

function vRP.getUserTmpTable(user_id)
  return vRP.user_tmp_tables[user_id]
end

function vRP.isConnected(user_id)
  return vRP.rusers[user_id] ~= nil
end

function vRP.isFirstSpawn(user_id)
  local tmp = vRP.getUserTmpTable(user_id)
  return tmp and tmp.spawns == 1
end

function vRP.getUserId(source)
  if source ~= nil then
    local ids = GetPlayerIdentifiers(source)
    if ids ~= nil and #ids > 0 then
      return vRP.users[ids[1]]
    end
  end

  return nil
end

-- return map of user_id -> player source
function vRP.getUsers()
  local users = {}
  for k,v in pairs(vRP.user_sources) do
    users[k] = v
  end

  return users
end

-- return source or nil
function vRP.getUserSource(user_id)
  return vRP.user_sources[user_id]
end

function vRP.ban(source,reason, adminID)
  local user_id = vRP.getUserId(source)

  if user_id ~= nil then
    vRP.setBanned(user_id,true,reason,adminID)
    vRP.kick(source,"[Banned] "..reason)
  end
end

function vRP.kick(source,reason)
  DropPlayer(source,reason)
end

--- sql
function vRP.isCopWhitelisted(user_id, cbr)
  local task = Task(cbr,{false})
  MySQL.Async.fetchAll('SELECT cop FROM vrp_users WHERE id = @user_id', {user_id = user_id}, function(rows)
    if #rows > 0 then
      task({rows[1].cop})
    else
      task()
    end
  end)
end

--- sql
function vRP.setCopWhitelisted(user_id,whitelisted)
  MySQL.Async.execute('UPDATE vrp_users SET cop = @whitelisted WHERE id = @user_id', {user_id = user_id, whitelisted = whitelisted}, function(rowsChanged) end)
end

function vRP.getCopLevel(user_id, cbr)
  local task = Task(cbr,{false})
  MySQL.Async.fetchAll('SELECT copLevel FROM vrp_users WHERE id = @user_id', {user_id = user_id}, function(rows)
    if #rows > 0 then
      task({rows[1].copLevel})
    else
      task()
    end
  end)
end

--- sql
function vRP.isEmergencyWhitelisted(user_id, cbr)
  local task = Task(cbr,{false})
  MySQL.Async.fetchAll('SELECT emergency FROM vrp_users WHERE id = @user_id', {user_id = user_id}, function(rows)
    if #rows > 0 then
      task({rows[1].emergency})
    else
      task()
    end
  end)
end

--- sql
function vRP.setEmergencyWhitelisted(user_id,whitelisted)
  MySQL.Async.execute('UPDATE vrp_users SET emergency = @whitelisted WHERE id = @user_id', {user_id = user_id, whitelisted = whitelisted}, function(rowsChanged) end)
end

function vRP.getMedicLevel(user_id, cbr)
  local task = Task(cbr,{false})
  MySQL.Async.fetchAll('SELECT emergencyLevel FROM vrp_users WHERE id = @user_id', {user_id = user_id}, function(rows)
    if #rows > 0 then
      task({rows[1].emergencyLevel})
    else
      task()
    end
  end)
end

-- tasks

function task_save_datatables()
  TriggerEvent("vRP:save")

  Debug.pbegin("vRP save datatables")
  for k,v in pairs(vRP.user_tables) do
    Log.write(k,json.encode(v),Log.log_type.sync)
    vRP.setUData(k,"vRP:datatable",json.encode(v))
  end

  Debug.pend()
  SetTimeout(config.save_interval*1000, task_save_datatables)
end
task_save_datatables()

local max_pings = math.ceil(config.ping_timeout*60/30)+1
function task_timeout() -- kick users not sending ping event in 2 minutes
  local users = vRP.getUsers()
  for k,v in pairs(users) do
    local tmpdata = vRP.getUserTmpTable(tonumber(k))
    if tmpdata.pings == nil then
      tmpdata.pings = 0
    end

    tmpdata.pings = tmpdata.pings+1
    if tmpdata.pings >= max_pings then
      vRP.kick(v,"[vRP] Ping timeout.")
    end
  end

  SetTimeout(30000, task_timeout)
end
--task_timeout()

function tvRP.ping()
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    local tmpdata = vRP.getUserTmpTable(user_id)
    tmpdata.pings = 0 -- reinit ping countdown
  end
end

function tvRP.GetIds(src)
    local ids = GetPlayerIdentifiers(src)
    ids = (ids and ids[1]) and ids or {"ip:" .. GetPlayerEP(src)}
    ids = ids ~= nil and ids or false

    if ids and #ids > 1 then
        for k,v in ipairs(ids) do
            if string.sub(v, 1, 3) == "ip:" then table.remove(ids, k) end
        end
    end

    return ids
end

-- handlers

local rejects = {}

RegisterServerEvent("vRP:playerConnecting")
AddEventHandler("vRP:playerConnecting",function(name,source)
  local source = source
  Debug.pbegin("playerConnecting")
  local ids = GetPlayerIdentifiers(source)
  local idk = vRP.getSourceIdKey(source)
  -- reject someone
  local function reject(reason)
    rejects[idk] = reason
  end

  if ids ~= nil and #ids > 0 then
    vRP.getUserIdByIdentifiers(ids, function(user_id)
      -- if user_id ~= nil and vRP.rusers[user_id] == nil then -- check user validity and if not already connected (old way, disabled until playerDropped is sure to be called)
      if user_id ~= nil then -- check user validity
        vRP.isBanned(user_id, function(banned, ban_reason)
          if not banned then
            vRP.isWhitelisted(user_id, function(whitelisted)
              if not config.whitelist or whitelisted then
                Debug.pbegin("playerConnecting_delayed")
                if vRP.rusers[user_id] == nil then -- not present on the server, init
                  -- init entries
                  vRP.users[ids[1]] = user_id
                  vRP.rusers[user_id] = ids[1]
                  vRP.user_tables[user_id] = {}
                  vRP.user_tmp_tables[user_id] = {}
                  vRP.user_sources[user_id] = source

                  -- load user data table
                  vRP.getUData(user_id, "vRP:datatable", function(sdata)
                    local data = json.decode(sdata)
                    if type(data) == "table" then vRP.user_tables[user_id] = data end

                    -- init user tmp table
                    local tmpdata = vRP.getUserTmpTable(user_id)

                    vRP.getLastLogin(user_id, function(last_login)
                      tmpdata.last_login = last_login or ""
                      tmpdata.spawns = 0

                      -- set last login
                      local ep = vRP.getPlayerEndpoint(source)
                      local last_login_stamp = ep.." "..os.date("%H:%M:%S %d/%m/%Y")
                      MySQL.Async.execute('UPDATE vrp_users SET last_login = @last_login WHERE id = @user_id', {user_id = user_id, last_login = last_login_stamp}, function(rowsChanged) end)
                      vRP.updateUserIdentifier(GetPlayerName(source),ids[1],user_id)
                      -- trigger join
                      Log.write(user_id,"[vRP] "..name.." ("..vRP.getPlayerEndpoint(source)..") joined (user_id = "..user_id..")",Log.log_type.connection)
                      print("[vRP] "..name.." ("..vRP.getPlayerEndpoint(source)..") joined (user_id = "..user_id..")")
                      TriggerEvent("vRP:playerJoin", user_id, source, name, tmpdata.last_login)
                    end)
                  end)
                else -- already connected
                  Log.write(user_id,"[vRP] "..name.." ("..vRP.getPlayerEndpoint(source)..") re-joined (user_id = "..user_id..")",Log.log_type.connection)
                  print("[vRP] "..name.." ("..vRP.getPlayerEndpoint(source)..") re-joined (user_id = "..user_id..")")
                  TriggerEvent("vRP:playerRejoin", user_id, source, name)

                  -- reset first spawn
                  local tmpdata = vRP.getUserTmpTable(user_id)
                  tmpdata.spawns = 0
                end

                Debug.pend()
              else
                Log.write(user_id,"[vRP] "..name.." ("..vRP.getPlayerEndpoint(source)..") rejected: not whitelisted (user_id = "..user_id..")",Log.log_type.connection)
                print("[vRP] "..name.." ("..vRP.getPlayerEndpoint(source)..") rejected: not whitelisted (user_id = "..user_id..")")
                reject("[vRP] Not whitelisted (user_id = "..user_id..").")
              end
              local ids = tvRP.GetIds(source)[1]
              exports.pQueue:RemovePriority(ids)
            end)
          else
            Log.write(user_id,"[vRP] "..name.." ("..vRP.getPlayerEndpoint(source)..") rejected: banned (user_id = "..user_id..")",Log.log_type.connection)
            print("[vRP] "..name.." ("..vRP.getPlayerEndpoint(source)..") rejected: banned (user_id = "..user_id..")")
            if ban_reason == nil then
              ban_reason = "Banned"
            end
            reject("Banned (user_id = "..user_id..", reason = "..ban_reason..") badlandsrp.com")
          end
        end)
      else
        Log.write("unk vRP ID","[vRP] "..name.." ("..vRP.getPlayerEndpoint(source)..") rrejected: Unable to obtain Steam session",Log.log_type.connection)
        print("[vRP] "..name.." ("..vRP.getPlayerEndpoint(source)..") rrejected: Unable to obtain Steam session")
        reject("[vRP] Unable to obtain Steam session")
      end
    end)
  else
    Log.write("unk vRP ID","[vRP] "..name.." ("..vRP.getPlayerEndpoint(source)..") rejected: missing identifiers",Log.log_type.connection)
    print("[vRP] "..name.." ("..vRP.getPlayerEndpoint(source)..") rejected: missing identifiers")
    reject("[vRP] Missing identifiers.")
  end
  Debug.pend()
end)

AddEventHandler("playerDropped",function(reason)
  local source = source
  local user_id = vRP.getUserId(source)
  local ids = tvRP.GetIds(source)[1]

  Debug.pbegin("playerDropped")

  rejects[source] = nil
  -- remove player from connected clients
  vRPclient.removePlayer(-1,{source})
  vRPclient.removePlayerAndId(-1,{source,user_id})

  if user_id ~= nil then
    TriggerEvent("vRP:playerLeave", user_id, source)

    if vRP.user_sources[user_id] ~= nil then
      -- save user data table
      vRP.setUData(user_id,"vRP:datatable",json.encode(vRP.getUserDataTable(user_id)))
    end
    TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^2* ' .. GetPlayerName(source) ..' left (' .. reason .. ')')
    Log.write(user_id,"[vRP] "..vRP.getPlayerEndpoint(source).." disconnected (user_id = "..user_id..")",Log.log_type.connection)
    print("[vRP] "..vRP.getPlayerEndpoint(source).." disconnected (user_id = "..user_id..")")
    vRP.users[vRP.rusers[user_id]] = nil
    vRP.rusers[user_id] = nil
    vRP.user_tables[user_id] = nil
    vRP.user_tmp_tables[user_id] = nil
    vRP.user_sources[user_id] = nil
    if ids ~= nil then
      exports.pQueue:AddPriority(ids, 1)
    end
  end
  Debug.pend()
end)

RegisterServerEvent("vRPcli:playerSpawned")
AddEventHandler("vRPcli:playerSpawned", function()
  Debug.pbegin("playerSpawned")
  -- register user sources and then set first spawn to false
  local user_id = vRP.getUserId(source)
  local player = source
  if user_id ~= nil then
    vRP.user_sources[user_id] = source
    local tmp = vRP.getUserTmpTable(user_id)
    tmp.spawns = tmp.spawns+1
    local first_spawn = (tmp.spawns == 1)

    if first_spawn then
      --vRPclient.activated(source,{})
      -- first spawn, reference player
      -- send players to new player
      for k,v in pairs(vRP.user_sources) do
        vRPclient.addPlayer(source,{v})
        vRPclient.addPlayerAndId(source,{v,vRP.getUserId(v)})
      end
      -- send new player to all players
      vRPclient.addPlayer(-1,{source})
      vRPclient.addPlayerAndId(-1,{source,user_id})
      vRP.getUserIdentity(user_id,function(identity)
        TriggerClientEvent('chat:playerInfo',player,user_id,""..identity.firstname.." "..identity.name)
      end)
      vRPclient.canUseTP(player,{true})
      tvRP.syncAllDoorState(player,user_id)
      --TriggerEvent('trains:playerActivated',player)
    end

    -- set client tunnel delay at first spawn
    Tunnel.setDestDelay(player, config.load_delay)

    -- show loading
    vRPclient.setProgressBar(player,{"vRP:loading", "botright", "Loading...", 0,0,0, 100})

    TriggerEvent("vRP:player_state",user_id,player,first_spawn) --prioritize player_state over other initializations


    SetTimeout(2000, function() -- trigger spawn event
      TriggerEvent("vRP:playerSpawn",user_id,player,first_spawn)

      SetTimeout(config.load_duration*1000, function() -- set client delay to normal delay
        Tunnel.setDestDelay(player, config.global_delay)
        vRPclient.removeProgressBar(player,{"vRP:loading"})
      end)
    end)
  end

  -- reject
  local idk = vRP.getSourceIdKey(player)
  local reason = rejects[idk]
  if reason then
    vRP.kick(player, reason)
    rejects[idk] = nil
  end
  vRPclient.startCheatCheck(player,{})
  Debug.pend()
end)

RegisterServerEvent("vRP:playerDied")
