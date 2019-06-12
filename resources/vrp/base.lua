--MySQL = module("vrp_mysql", "MySQL")

local Proxy = module("lib/Proxy")
local Tunnel = module("panopticon/sv_pano_tunnel")
local Lang = module("lib/Lang")
local Log = module("lib/Log")
Debug = module("lib/Debug")

local config = module("cfg/base")
local version = module("version")
Debug.active = config.debug

-- versioning
print("[vRP] Initializing Server Version "..version)
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

vRPhs = Proxy.getInterface("hospital")

-- load language
local dict = module("cfg/lang/"..config.lang) or {}
vRP.lang = Lang.new(dict)

-- init
vRPclient = Tunnel.getInterface("vRP","vRP") -- server -> client tunnel
vRPcustom = Tunnel.getInterface("CustomScripts","CustomScripts")
vRPjobs = Tunnel.getInterface("jobs","jobs")
iZoneClient = Tunnel.getInterface("iZone","iZone")

vRP.users = {} -- will store logged users (id) by first identifier
vRP.rusers = {} -- store the opposite of users
vRP.user_tables = {} -- user data tables (logger storage, saved to database)
vRP.user_characters = {} -- user characters (which character the player is currently using)
vRP.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
vRP.server_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
vRP.user_sources = {} -- user sources

Tunnel.initiateProxy()
print("[vRP] Server Initialized")


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

function tvRP.updatePlayTime(isMedic,isCop)
	local user_id = vRP.getUserId(source)
	local civTime = 0
	local medicTime = 0
	local copTime = 0

	if isMedic then medicTime = 5 end
	if isCop then copTime = 5 end
	if not isCop and not isMedic then civTime = 5 end

	MySQL.Async.execute('UPDATE bl_time_played SET civ_time_played = civ_time_played+@civ_time_played, ems_time_played = ems_time_played+@ems_time_played, cop_time_played = cop_time_played+@cop_time_played WHERE date = CURDATE() AND user_id = @user_id',
		{user_id = user_id, civ_time_played = civTime, ems_time_played = medicTime, cop_time_played = copTime}, function(rowsChanged)
			if rowsChanged == 0 then
				MySQL.Async.execute('INSERT INTO bl_time_played(date,user_id,civ_time_played,ems_time_played,cop_time_played) VALUES (CURDATE(),@user_id,@civ_time_played,@ems_time_played,@cop_time_played)',
					{user_id = user_id, civ_time_played = civTime, ems_time_played = medicTime, cop_time_played = copTime}, function(rowsChanged) end)
			end
	end)
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

-- Check that both steam and RSC licenses are added to player ID if avail. Does not update current values
function vRP.addMissingIDs(source,user_id)
	if source ~= nil and user_id ~= nil then
		local ids = GetPlayerIdentifiers(source)
		local function addData(user_id,id,key)
			if user_id ~= nil and id ~= nil then
        MySQL.Async.fetchAll("SELECT * FROM vrp_user_ids WHERE user_id = @user_id AND identifier like '%@key%'",{user_id = user_id, key = key},function(rows)
					if #rows < 1 then
            MySQL.Async.execute('INSERT INTO vrp_user_ids(identifier,user_id) VALUES(@identifier,@user_id) ON DUPLICATE KEY UPDATE user_id=user_id', {user_id = user_id, identifier = id}, function(rowsChanged)
							if rowsChanged > 0 then
								Log.write(user_id,"Added identifier "..id.." to account",Log.log_type.account)
							end
						end)
					end
				end)
			end
		end
		for k,v in pairs(ids) do
			if string.find(v, "license:") ~= nil then
				addData(user_id,v,"license")
			elseif string.find(v, "discord:") ~= nil then
				addData(user_id,v,"discord")
			elseif string.find(v, "live:") ~= nil then
				addData(user_id,v,"live")
			elseif string.find(v, "xbl:") ~= nil then
				addData(user_id,v,"xbl")
			end
		end
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

function tvRP.broadcastSpatializedSound(dict,name,x,y,z,range)
	vRPclient.playSpatializedSound(-1,{dict,name,x,y,z,range})
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

function vRP.vRPQueueData(user_id, cbr)
	local task = Task(cbr, {false})

	MySQL.Async.fetchAll('SELECT banned, ban_reason, cop, emergency FROM vrp_users WHERE id = @user_id', {user_id = user_id}, function(rows)
		if #rows > 0 then
			task({rows[1].banned, rows[1].ban_reason, rows[1].cop, rows[1].emergency})
		else
			task()
		end
	end)
end

function vRP.canBypassSteamCheck(user_id, cbr)
	local task = Task(cbr, {false})

	MySQL.Async.fetchAll('SELECT steam_check_bypass FROM vrp_users WHERE id = @user_id', {user_id = user_id}, function(rows)
		if #rows > 0 then
			task({rows[1].steam_check_bypass})
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
function vRP.getUserCharacter(user_id, cbr)
	if cbr then
		local task = Task(cbr,{""})
		task({vRP.user_characters[user_id]})
	else
		return vRP.user_characters[user_id]
	end
end

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

function vRP.testPrint(message)
	print(message)
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

RegisterServerEvent('vRP:banPlayer')
AddEventHandler('vRP:banPlayer', function(source,msg,bannedBy)
	if source ~= nil and msg ~= nil and bannedBy ~= nil then
		vRP.ban(source,msg, bannedBy)
	end
end)

function vRP.kick(source,reason)
	DropPlayer(source,reason)
end

RegisterServerEvent('vRP:dropSelf')
AddEventHandler('vRP:dropSelf', function(reason)
	if source ~= nil and reason ~= nil then
		DropPlayer(source,reason)
	end
end)

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
function vRP.isCFRWhitelisted(user_id, cbr)
	local task = Task(cbr,{false})
	MySQL.Async.fetchAll('SELECT cfr FROM vrp_users WHERE id = @user_id', {user_id = user_id}, function(rows)
		if #rows > 0 then
			task({rows[1].cfr})
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
		local user_id = k
		local character = vRP.user_characters[user_id]
		if character ~= nil then
			local datatable = "vRP:datatable"..character
			-- save user data table
			Log.write(k,json.encode(v),Log.log_type.sync)
			vRP.setUData(user_id,datatable,json.encode(v))
		end
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
	if src ~= nil then
		local ids = GetPlayerIdentifiers(src)
		if ids ~= nil then
			ids = (ids and ids[1]) and ids or {"ip:" .. vRP.getPlayerEndpoint(src)}
			ids = ids ~= nil and ids or false

			if ids and #ids > 1 then
					for k,v in ipairs(ids) do
							if string.sub(v, 1, 3) == "ip:" then table.remove(ids, k) end
					end
			end
		end

		return ids
	end
	return nil
end

function tvRP.ConfigureUserTable(charnum)
	local task = TUNNEL_DELAYED()
	local user_id = vRP.getUserId(source)

	if user_id ~= nil and charnum ~= nil then
		vRP.user_characters[user_id] = charnum
		local character = vRP.user_characters[user_id]
		local datatable = "vRP:datatable"..character

		if character ~= nil then
			-- load user data table
			vRP.getUData(user_id, datatable, function(sdata)
				if sdata ~= nil and sdata ~= "" then
					local data = json.decode(sdata)
					if type(data) == "table" then
						vRP.user_tables[user_id] = data
					end
				end
				task({true})
			end)
		else
			print("invalid character")
			task({false})
		end
	else
		print("no user id / charnum")
		task({false})
	end
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
				vRP.addMissingIDs(source,user_id)
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

									-- init user tmp table
									local tmpdata = vRP.getUserTmpTable(user_id)
									if tmpdata ~= nil then
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
									end
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
							if ids ~= nil then
								exports.pQueue:RemovePriority(ids)
							end
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
			local character = vRP.user_characters[user_id]
			if character ~= nil then
				local datatable = "vRP:datatable"..character
				-- save user data table
				vRP.setUData(user_id,datatable,json.encode(vRP.getUserDataTable(user_id)))
			end
		end
		TriggerClientEvent('chat:addMessage', -1, {
				template = '<div class="chat-bubble" style="background-color: rgba(230, 0, 115, 0.6);"><i class="fas fa-exclamation-circle"></i> {0}</div>',
				args = { '^2* ' .. GetPlayerName(source) ..' left (' .. reason .. ')'}
		})
		Log.write(user_id,"[vRP] "..vRP.getPlayerEndpoint(source).." disconnected (user_id = "..user_id..")",Log.log_type.connection)
		print("[vRP] "..vRP.getPlayerEndpoint(source).." disconnected (user_id = "..user_id..")")
		vRP.users[vRP.rusers[user_id]] = nil
		vRP.rusers[user_id] = nil
		vRP.user_tables[user_id] = nil
		vRP.user_tmp_tables[user_id] = nil
		vRP.user_sources[user_id] = nil
		vRP.user_characters[user_id] = nil
		if ids ~= nil then
			exports.pQueue:AddPriority(ids, 11)
		end
	end
	Debug.pend()
end)

RegisterServerEvent("vRPcli:preSpawn")
AddEventHandler("vRPcli:preSpawn", function()
	Debug.pbegin("preSpawn")
	-- register user sources and then set first spawn to false
	local user_id = vRP.getUserId(source)
	local player = source
	if user_id ~= nil then
		vRP.user_sources[user_id] = source
		vRPclient.setMyVrpId(source,{user_id})
		-- send players to new player
		for k,v in pairs(vRP.user_sources) do
			vRPclient.addPlayer(source,{v})
			vRPclient.addPlayerAndId(source,{v,vRP.getUserId(v)})
		end
		-- send new player to all players
		vRPclient.addPlayer(-1,{source})
		vRPclient.addPlayerAndId(-1,{source,user_id})
		vRPclient.canUseTP(player,{true})
		TriggerClientEvent('vRP:setHostName',source,GetConvar('blrp_watermark','badlandsrp.com'))
		TriggerClientEvent('displayDisclaimer', player)
		TriggerEvent("startDaTrains", player)
		vRPclient.playerFreeze(player, {true})
		vRP.loadEmoteBinds(player)

		-- set client tunnel delay at first spawn
		Tunnel.setDestDelay(player, config.load_delay)
	else
		DropPlayer(source,"Unable to obtain session")
		local ids = json.encode(tvRP.GetIds(source))
		if ids == nil then
			ids = "error occured"
		end
		Log.write(0,"Unable to aquire vRP ID (bypass?) - "..ids,Log.log_type.anticheat)
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

		-- set client tunnel delay at first spawn
		Tunnel.setDestDelay(player, config.load_delay)

		-- show loading
		TriggerEvent("vRP:player_state",user_id,player,first_spawn) --prioritize player_state over other initializations

		SetTimeout(2000, function() -- trigger spawn event
			TriggerEvent("vRP:playerSpawn",user_id,player,first_spawn)

			if first_spawn then
				SetTimeout(config.load_duration*1000, function() -- set client delay to normal delay
					Tunnel.setDestDelay(player, config.global_delay)
					TriggerEvent("vRP:player_state_position",user_id,player,first_spawn)
					TriggerClientEvent('closeDisclaimer',player)
				end)
			end
		end)
	else
		DropPlayer(source,"Unable to obtain session")
		local ids = json.encode(tvRP.GetIds(source))
		if ids == nil then
			ids = "error occured"
		end
		Log.write(0,"Unable to aquire vRP ID (bypass?) - "..ids,Log.log_type.anticheat)
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

Citizen.CreateThread(function()
	Citizen.Wait(10000)
	if GetConvar('blrp_watermark','badlandsrp.com') ~= 'us2.blrp.life' then
		print("[vRP] Storing all vehicles")
		MySQL.Async.execute('UPDATE vrp_user_vehicles SET out_status = 0', {}, function(rowsChanged) end)
	end
end)

local maxmdtHours = 48
function mdtCleanup()
	if GetConvar('blrp_watermark','badlandsrp.com') ~= 'us2.blrp.life' then
		print("MDT Debug - Cleanup started")
		Citizen.Wait(10000)
		MySQL.Async.execute('DELETE FROM gta5_gamemode_essential.vrp_mdt WHERE (TIMESTAMPDIFF(HOUR, dateInserted, NOW())) > 47', {}, function(rowsChanged)	end)
		print("MDT Debug - Cleanup completed")
		SetTimeout(60000 * 15, mdtCleanup)
	end
end

SetTimeout(10000, mdtCleanup)

local run_char_setup = false
local max_id = 42407
local counter = 1

Citizen.CreateThread(function()
	Citizen.Wait(5000)
	if run_char_setup then
		Citizen.Trace("Charater Slot Shit Started")
		while counter <= max_id and run_char_setup do
			Citizen.Wait(3)
			MySQL.Async.fetchAll("SELECT user_id,registration,phone,firstname,name,age,height,gender FROM vrp_user_identities WHERE user_id = @counter",{counter = counter},function(rows)
				if #rows > 0 then
					MySQL.Async.execute('insert into gta5_gamemode_essential.characters (identifier, firstname, lastname, dateofbirth, sex, height, registration, phone) values (@user_id,@fname,@lname,@dob,@gender,@height,@registration,@phone)', {user_id = rows[1].user_id, fname = rows[1].firstname, lname = rows[1].name, dob = rows[1].age, gender = rows[1].gender, height = rows[1].height, registration = rows[1].registration, phone = rows[1].phone}, function(rowsChanged)	end)
				end
			end)
			counter = counter + 1
		end
	end
end)
