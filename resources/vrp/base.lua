
local MySQL = require("resources/vrp/lib/MySQL/MySQL")
local Proxy = require("resources/vrp/lib/Proxy")
local Tunnel = require("resources/vrp/lib/Tunnel")
local Lang = require("resources/vrp/lib/Lang")
Debug = require("resources/vrp/lib/Debug")

local config = require("resources/vrp/cfg/base")
local version = require("resources/vrp/version")
Debug.active = config.debug

-- versioning
print("[vRP] launch version "..version)
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

vRP = {}
Proxy.addInterface("vRP",vRP)

tvRP = {}
Tunnel.bindInterface("vRP",tvRP) -- listening for client tunnel

-- load language 
local dict = require("resources/vrp/cfg/lang/"..config.lang) or {}
vRP.lang = Lang.new(dict)

-- init
vRPclient = Tunnel.getInterface("vRP","vRP") -- server -> client tunnel

vRP.users = {} -- will store logged users (id) by first identifier
vRP.rusers = {} -- store the opposite of users
vRP.user_tables = {} -- user data tables (logger storage, saved to database)
vRP.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
vRP.user_sources = {} -- user sources 

-- open MySQL connection
vRP.sql = MySQL.open(config.db.host,config.db.user,config.db.password,config.db.database)

-- queries
local q_init = vRP.sql:prepare([[
CREATE TABLE IF NOT EXISTS vrp_users(
  id INTEGER AUTO_INCREMENT,
  last_login VARCHAR(255),
  whitelisted BOOLEAN,
  banned BOOLEAN,
  CONSTRAINT pk_user PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS vrp_user_ids(
  identifier VARCHAR(255),
  user_id INTEGER,
  CONSTRAINT pk_user_ids PRIMARY KEY(identifier),
  CONSTRAINT fk_user_ids_users FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS vrp_user_data(
  user_id INTEGER,
  dkey VARCHAR(255),
  dvalue TEXT,
  CONSTRAINT pk_user_data PRIMARY KEY(user_id,dkey),
  CONSTRAINT fk_user_data_users FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS vrp_srv_data(
  dkey VARCHAR(255),
  dvalue TEXT,
  CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
);

]])

local q_create_user = vRP.sql:prepare("INSERT INTO vrp_users(whitelisted,banned) VALUES(false,false)")
local q_add_identifier = vRP.sql:prepare("INSERT INTO vrp_user_ids(identifier,user_id) VALUES(@identifier,@user_id)")
local q_userid_byidentifier = vRP.sql:prepare("SELECT user_id FROM vrp_user_ids WHERE identifier = @identifier")

local q_set_userdata = vRP.sql:prepare("REPLACE INTO vrp_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
local q_get_userdata = vRP.sql:prepare("SELECT dvalue FROM vrp_user_data WHERE user_id = @user_id AND dkey = @key")

local q_set_srvdata = vRP.sql:prepare("REPLACE INTO vrp_srv_data(dkey,dvalue) VALUES(@key,@value)")
local q_get_srvdata = vRP.sql:prepare("SELECT dvalue FROM vrp_srv_data WHERE dkey = @key")

local q_get_banned = vRP.sql:prepare("SELECT banned FROM vrp_users WHERE id = @user_id")
local q_set_banned = vRP.sql:prepare("UPDATE vrp_users SET banned = @banned WHERE id = @user_id")
local q_get_whitelisted = vRP.sql:prepare("SELECT whitelisted FROM vrp_users WHERE id = @user_id")
local q_set_whitelisted = vRP.sql:prepare("UPDATE vrp_users SET whitelisted = @whitelisted WHERE id = @user_id")
local q_set_last_login = vRP.sql:prepare("UPDATE vrp_users SET last_login = @last_login WHERE id = @user_id")
local q_get_last_login = vRP.sql:prepare("SELECT last_login FROM vrp_users WHERE id = @user_id")

-- init tables
print("[vRP] init base tables")
q_init:execute()

-- identification system

--- sql.
-- @return user id or nil if not found
function vRP.getUserIdByIdentifiers(ids)
  if ids ~= nil then
    for k,v in pairs(ids) do
      q_userid_byidentifier:bind("@identifier",v)

      local r = q_userid_byidentifier:query()
      local val = nil
      if r:fetch() then
        val = r:getValue(0)
      end

      r:close()

      return val
    end
  end

  return nil
end

--- sql.
-- @return new user id or nil if not created
function vRP.registerUser(ids)
  if ids ~= nil and #ids > 0 then
    -- create user
    q_create_user:execute()
    local id = q_create_user:last_insert_id()

    -- add identifiers
    q_add_identifier:bind("@user_id",id)

    for k,v in pairs(ids) do
      q_add_identifier:bind("@identifier",v)
      q_add_identifier:execute()
    end

    return id
  end

  return nil
end

--- sql
function vRP.isBanned(user_id)
  q_get_banned:bind("@user_id",user_id)
  local r = q_get_banned:query()
  local v = false
  if r:fetch() then 
    v = r:getValue(0)
  end

  r:close()
  return v
end

--- sql
function vRP.setBanned(user_id,banned)
  q_set_banned:bind("@user_id",user_id)
  q_set_banned:bind("@banned",banned)

  q_set_banned:execute()
end

--- sql
function vRP.isWhitelisted(user_id)
  q_get_whitelisted:bind("@user_id",user_id)
  local r = q_get_whitelisted:query()
  local v = false
  if r:fetch() then 
    v = r:getValue(0)
  end

  r:close()
  return v
end

--- sql
function vRP.setWhitelisted(user_id,whitelisted)
  q_set_whitelisted:bind("@user_id",user_id)
  q_set_whitelisted:bind("@whitelisted",whitelisted)

  q_set_whitelisted:execute()
end

--- sql
function vRP.getLastLogin(user_id)
  q_get_last_login:bind("@user_id",user_id)
  local r = q_get_last_login:query()
  local v = ""
  if r:fetch() then 
    v = r:getValue(0) 
  end

  r:close()
  return v
end

function vRP.setUData(user_id,key,value)
  q_set_userdata:bind("@user_id",user_id)
  q_set_userdata:bind("@key",key)
  q_set_userdata:bind("@value",value)
  q_set_userdata:execute()
end

function vRP.getUData(user_id,key)
  q_get_userdata:bind("@user_id",user_id)
  q_get_userdata:bind("@key",key)

  local v = ""

  local r = q_get_userdata:query()
  if r:fetch() then
    v = r:getValue(0)
    if type(v) ~= "string" then v = "" end
  end

  r:close()
  return v
end

function vRP.setSData(key,value)
  q_set_srvdata:bind("@key",key)
  q_set_srvdata:bind("@value",value)
  q_set_srvdata:execute()
end

function vRP.getSData(key)
  q_get_srvdata:bind("@key",key)

  local v = ""

  local r = q_get_srvdata:query()
  if r:fetch() then
    v = r:getValue(0)
    if type(v) ~= "string" then v = "" end
  end

  r:close()
  return v
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
  local ids = GetPlayerIdentifiers(source)
  if ids ~= nil and #ids > 0 then
    return vRP.users[ids[1]]
  end

  return nil
end

-- return source or nil
function vRP.getUserSource(user_id)
  return vRP.user_sources[user_id]
end

function vRP.ban(source,reason)
  local user_id = vRP.getUserId(source)

  if user_id ~= nil then
    vRP.setBanned(user_id,true)
    vRP.kick(source,"[Banned] "..reason)
  end
end

function vRP.kick(source,reason)
  DropPlayer(source,reason)
end

-- tasks

function task_save_datatables()
  Debug.pbegin("vRP save datatables")
  for k,v in pairs(vRP.user_tables) do
    vRP.setUData(k,"vRP:datatable",json.encode(v))
  end

  Debug.pend()
  SetTimeout(config.save_interval*1000, task_save_datatables)
end
task_save_datatables()

-- handlers

AddEventHandler("playerConnecting",function(name,setMessage)
  Debug.pbegin("playerConnecting")
  local ids = GetPlayerIdentifiers(source)
  
  if ids ~= nil and #ids > 0 then
    local user_id = vRP.getUserIdByIdentifiers(ids)
    if user_id == nil then
      user_id = vRP.registerUser(ids)
      -- redo getUserIdByIdentifiers, there is a strange TriggerEvent issue with the id returned by registerUser
--      user_id = vRP.getUserIdByIdentifiers(ids)
    end

    -- if user_id ~= nil and vRP.rusers[user_id] == nil then -- check user validity and if not already connected (old way, disabled until playerDropped is sure to be called)
    if user_id ~= nil then -- check user validity 
      if not vRP.isBanned(user_id) then
        if not config.whitelist or vRP.isWhitelisted(user_id) then
          SetTimeout(1,function() -- create a delayed function to prevent the nil <-> string deadlock issue
          Debug.pbegin("playerConnecting_delayed")
          if vRP.rusers[user_id] == nil then -- not present on the server, init
            -- init entries
            vRP.users[ids[1]] = user_id
            vRP.rusers[user_id] = ids[1]
            vRP.user_tables[user_id] = {}
            vRP.user_tmp_tables[user_id] = {}
            vRP.user_sources[user_id] = source

            -- load user data table
            -- gsub fix a strange deadlock issue with " in json data
            local sdata = vRP.getUData(user_id,"vRP:datatable")

  --          local s = json.decode([[{"hunger":0,"thirst":0}"]]) -- prevent strange json deadlock at next decode

            local data = json.decode(sdata)
            if type(data) == "table" then vRP.user_tables[user_id] = data end

            -- init user tmp table
            local tmpdata = vRP.getUserTmpTable(user_id)
            tmpdata.last_login = vRP.getLastLogin(user_id) or ""
            tmpdata.spawns = 0

            -- set last login
            local ep = GetPlayerEP(source)
            local last_login_stamp = string.sub(ep,1,string.find(ep,":")-1).." "..os.date("%H:%M:%S %d/%m/%Y")
            q_set_last_login:bind("@user_id",user_id)
            q_set_last_login:bind("@last_login",last_login_stamp)
            q_set_last_login:execute()

            -- trigger join
            print("[vRP] "..name.." ("..GetPlayerEP(source)..") joined (user_id = "..user_id..")")
            TriggerEvent("vRP:playerJoin", user_id, source, name, tmpdata.last_login)

          else -- already connected
            print("[vRP] "..name.." ("..GetPlayerEP(source)..") re-joined (user_id = "..user_id..")")
            TriggerEvent("vRP:playerRejoin", user_id, source, name)

            -- reset first spawn
            local tmpdata = vRP.getUserTmpTable(user_id)
            tmpdata.spawns = 0
          end

          Debug.pend()
          end)
        else
          print("[vRP] "..name.." ("..GetPlayerEP(source)..") rejected: not whitelisted (user_id = "..user_id..")")
          setMessage("[vRP] Not whitelisted (user_id = "..user_id..").")
          CancelEvent()
        end
      else
        print("[vRP] "..name.." ("..GetPlayerEP(source)..") rejected: banned (user_id = "..user_id..")")
        setMessage("[vRP] Banned (user_id = "..user_id..").")
        CancelEvent()
      end
    else
      print("[vRP] "..name.." ("..GetPlayerEP(source)..") rejected: identification error")
      setMessage("[vRP] Identification error.")
      CancelEvent()
    end
  else
    print("[vRP] "..name.." ("..GetPlayerEP(source)..") rejected: missing identifiers")
    setMessage("[vRP] Missing identifiers.")
    CancelEvent()
  end
  Debug.pend()
end)

AddEventHandler("playerDropped",function(reason)
  Debug.pbegin("playerDropped")
  local user_id = vRP.getUserId(source)

  -- remove player from connected clients
  vRPclient.removePlayer(-1,{source})

  if user_id ~= nil then
    TriggerEvent("vRP:playerLeave", user_id, source)

    -- save user data table
    vRP.setUData(user_id,"vRP:datatable",json.encode(vRP.getUserDataTable(user_id)))

    print("[vRP] "..GetPlayerEP(source).." disconnected (user_id = "..user_id..")")
    vRP.users[vRP.rusers[user_id]] = nil
    vRP.rusers[user_id] = nil
    vRP.user_tables[user_id] = nil
    vRP.user_tmp_tables[user_id] = nil
    vRP.user_sources[user_id] = nil
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
      -- first spawn, reference player
      -- send players to new player
      for k,v in pairs(vRP.user_sources) do
        vRPclient.addPlayer(source,{v})
      end
      -- send new player to all players
      vRPclient.addPlayer(-1,{source})
    end

    -- set client tunnel delay at first spawn
    Tunnel.setDestDelay(player, config.load_delay)

    -- show loading
    vRPclient.setProgressBar(player,{"vRP:loading", "botright", "Loading...", 0,0,0, 100})

    SetTimeout(2000, function() -- trigger spawn event
      TriggerEvent("vRP:playerSpawn",user_id,player,first_spawn)

      SetTimeout(config.load_duration*1000, function() -- set client delay to normal delay
        Tunnel.setDestDelay(player, config.global_delay)
        vRPclient.removeProgressBar(player,{"vRP:loading"})
      end)
    end)
  end
  Debug.pend()
end)

RegisterServerEvent("vRP:playerDied")
