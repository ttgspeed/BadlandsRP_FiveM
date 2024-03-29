local Tools = module("lib/Tools")
local Debug = module("lib/Debug")
local Log = module("lib/Log")
local Proxy = module("lib/Proxy")
local panopticon = module("panopticon/sv_panopticon")
local vRP = nil
local Tunnel = {}

--
-- KEYMASTER
--
local keys_issued = {}
local tunnel_key = panopticon.generate_token(16)
local key_obj = {}
key_obj._6b6579 = tunnel_key
print("[Panopticon] Tunnel Key Generated: "..key_obj._6b6579)

RegisterServerEvent("_73766b_")
AddEventHandler("_73766b_", function(resource)
	local user_id = vRP.getUserId({source})
	if keys_issued[source] == nil then
		keys_issued[source] = {}
	end
	if keys_issued[source][resource] == nil then
		keys_issued[source][resource] = true
		TriggerClientEvent("_73766b_recv",source,key_obj)
	else
		DropPlayer(source,"Illegal Request (1)")

		local user_id = vRP.getUserId({source})
		Log.write(user_id,"Multiple key requests for "..resource, Log.log_type.anticheat)
	end
end)

--
-- vRP PROXY
--

function Tunnel.initiateProxy()
	vRP = Proxy.getInterface("vRP")
	if vRP ~= nil then
		print("[Panopticon] Reverse Proxy Created")
	else
		print("[Panopticon] Could not initialize vRP Proxy")
	end
end

AddEventHandler('playerConnecting', function()
	if vRP == nil then
		DropPlayer(source,"The server is not ready to accept connections. Please try again")
	end
end)

AddEventHandler('playerDropped', function()
	keys_issued[source] = nil
end)

--
-- TUNNEL
--
-- this file describe a two way proxy between the server and the clients (request system)
-- define per dest regulator
Tunnel.delays = {}

-- set the base delay between Triggers for this destination in milliseconds (0 for instant trigger)
function Tunnel.setDestDelay(dest, delay)
  Tunnel.delays[dest] = {delay, 0}
end

local function tunnel_resolve(itable,key)
  local mtable = getmetatable(itable)
  local iname = mtable.name
  local ids = mtable.tunnel_ids
  local callbacks = mtable.tunnel_callbacks
  local identifier = mtable.identifier
  -- generate access function
  local fcall = function(dest,args,callback)
    if args == nil then
      args = {}
    end

    -- get delay data
    local delay_data = Tunnel.delays[dest]
    if delay_data == nil then
      delay_data = {0,0}
    end

    -- increase delay
    local add_delay = delay_data[1]
    delay_data[2] = delay_data[2]+add_delay
    if delay_data[2] > 0 then -- delay trigger
      SetTimeout(delay_data[2], function()
        -- remove added delay
        delay_data[2] = delay_data[2]-add_delay

        -- send request
        if type(callback) == "function" then -- ref callback if exists (become a request)
          local rid = ids:gen()
          callbacks[rid] = callback
          TriggerClientEvent(iname..":tunnel_req",dest,key,args,identifier,rid)
        else -- regular trigger
          TriggerClientEvent(iname..":tunnel_req",dest,key,args,"",-1)
        end
      end)
    else -- no delay
      -- send request
      if type(callback) == "function" then -- ref callback if exists (become a request)
        local rid = ids:gen()
        callbacks[rid] = callback
        TriggerClientEvent(iname..":tunnel_req",dest,key,args,identifier,rid)
      else -- regular trigger
        TriggerClientEvent(iname..":tunnel_req",dest,key,args,"",-1)
      end
    end
  end

  itable[key] = fcall -- add generated call to table (optimization)
  return fcall
end

-- bind an interface (listen to net requests)
-- name: interface name
-- interface: table containing functions
function Tunnel.bindInterface(name,interface)
  -- receive request
	print("[Panopticon] bindInterface Registered: "..name..":tunnel_req_"..tunnel_key)
  RegisterServerEvent(name..":tunnel_req_"..tunnel_key)
  AddEventHandler(name..":tunnel_req_"..tunnel_key,function(member,args,identifier,rid)
    local source = source
    local delayed = false

    if Debug.active and Debug.debugTunnel then
      Debug.pbegin("tunnelreq#"..rid.."_"..name..":"..member.." "..json.encode(Debug.safeTableCopy(args)))
    end

    local f = interface[member]

    local rets = {}
    if type(f) == "function" then
      -- bind the global function to delay the return values using the returned function with args
      TUNNEL_DELAYED = function()
        delayed = true
        return function(rets)
          rets = rets or {}

          if rid >= 0 then
            TriggerClientEvent(name..":"..identifier..":tunnel_res",source,rid,rets)
          end
        end
      end

      rets = {f(table.unpack(args))} -- call function
      -- CancelEvent() -- cancel event doesn't seem to cancel the event for the other handlers, but if it does, uncomment this
    end

    -- send response (even if the function doesn't exist)
    if not delayed and rid >= 0 then
      TriggerClientEvent(name..":"..identifier..":tunnel_res",source,rid,rets)
    end

    if Debug.active and Debug.debugTunnel then
      Debug.pend()
    end
  end)

	RegisterServerEvent(name..":tunnel_req")
	AddEventHandler(name..":tunnel_req",function(member,args,identifier,rid)
		--BAN PLAYER
		local user_id = vRP.getUserId({source})
		Log.write(user_id,"Illegal tunnel_req for "..name..":tunnel_req".." "..identifier.." "..json.encode(args), Log.log_type.anticheat)
		--vRP.ban({source, user_id.." Scripting perm (serpickle)", 0})
		DropPlayer(source,"Illegal Request (2)")
	end)
end

-- get a tunnel interface to send requests
-- name: interface name
-- identifier: unique string to identify this tunnel interface access (the name of the current resource should be fine)
function Tunnel.getInterface(name,identifier)
  local ids = Tools.newIDGenerator()
  local callbacks = {}

  -- build interface
  local r = setmetatable({},{ __index = tunnel_resolve, name = name, tunnel_ids = ids, tunnel_callbacks = callbacks, identifier = identifier })

  -- receive response
	print("[Panopticon] getInterface Registered: "..name..":"..identifier..":tunnel_res_"..tunnel_key)
  RegisterServerEvent(name..":"..identifier..":tunnel_res_"..tunnel_key)
  AddEventHandler(name..":"..identifier..":tunnel_res_"..tunnel_key,function(rid,args)
    if Debug.active and Debug.debugTunnel then
      Debug.pbegin("tunnelres#"..rid.."_"..name.." "..json.encode(Debug.safeTableCopy(args)))
    end

    local callback = callbacks[rid]
    if callback ~= nil then
      -- free request id
      ids:free(rid)
      callbacks[rid] = nil

      -- call
      callback(table.unpack(args))
    end

    Debug.pend()
  end)

	RegisterServerEvent(name..":"..identifier..":tunnel_res")
	AddEventHandler(name..":"..identifier..":tunnel_res",function(rid,args)
		--BAN PLAYER
		local user_id = vRP.getUserId({source})
		Log.write(user_id,"Illegal tunnel_res for "..name..":"..identifier..":tunnel_res ".." "..json.encode(args), Log.log_type.anticheat)
		--vRP.ban({source, user_id.." Scripting perm (serpickle)", 0})
		DropPlayer(source,"Illegal Request (3)")
	end)

  return r
end

return Tunnel
