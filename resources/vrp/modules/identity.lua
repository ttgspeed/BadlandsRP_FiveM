local htmlEntities = module("lib/htmlEntities")
local Log = module("lib/Log")
local cfg = module("cfg/identity")
local lang = vRP.lang

local sanitizes = module("cfg/sanitizes")

-- this module describe the identity system
-- api

-- cbreturn user identity
function vRP.getUserIdentity(user_id, cbr)
	local task = Task(cbr)
	MySQL.Async.fetchAll('SELECT * FROM vrp_user_identities WHERE user_id = @user_id', {user_id = user_id}, function(rows)
		task({rows[1]})
	end)
end

-- cbreturn user_id by registration or nil
function vRP.getUserByRegistration(registration, cbr)
	local task = Task(cbr)
	MySQL.Async.fetchAll('SELECT user_id FROM vrp_user_identities WHERE registration = @registration', {registration = registration or ""}, function(rows)
		if #rows > 0 then
			task({rows[1].user_id})
		else
			task()
		end
	end)
end

-- cbreturn user_id by phone or nil
function vRP.getUserByPhone(phone, cbr)
	local task = Task(cbr)
	MySQL.Async.fetchAll('SELECT user_id FROM vrp_user_identities WHERE phone = @phone', {phone = phone or ""}, function(rows)
		if #rows > 0 then
			task({rows[1].user_id})
		else
			task()
		end
	end)
end

function vRP.getUserSpouse(user_id, cbr)
	local task = Task(cbr)
	MySQL.Async.fetchAll('SELECT spouse FROM vrp_user_identities WHERE user_id = @user_id', {user_id = user_id or ""}, function(rows)
		if #rows > 0 then
			task({rows[1].spouse})
		else
			task()
		end
	end)
end

function vRP.setUserSpouse(user_id, nuser_id)
	MySQL.Async.execute('UPDATE vrp_user_identities set spouse = @spouse where user_id = @user_id',{spouse = nuser_id, user_id = user_id}, function(rowsChanged) end)
end

function vRP.generateStringNumber(format) -- (ex: DDDLLL, D => digit, L => letter)
	local abyte = string.byte("A")
	local zbyte = string.byte("0")

	local number = ""
	for i=1,#format do
		local char = string.sub(format, i,i)
		if char == "D" then number = number..string.char(zbyte+math.random(0,9))
		elseif char == "L" then number = number..string.char(abyte+math.random(0,25))
		else number = number..char end
	end

	return number
end

-- cbreturn a unique registration number
function vRP.generateRegistrationNumber(cbr)
	local task = Task(cbr)

	local function search()
		-- generate registration number
		local registration = vRP.generateStringNumber("DDDLLL")
		vRP.getUserByRegistration(registration, function(user_id)
			if user_id ~= nil then
				search() -- continue generation
			else
				task({registration})
			end
		end)
	end

	search()
end

-- cbreturn a unique phone number (0DDDDD, D => digit)
function vRP.generatePhoneNumber(cbr)
	local task = Task(cbr)

	local function search()
		-- generate phone number
		local phone = vRP.generateStringNumber(cfg.phone_format)
		vRP.getUserByPhone(phone, function(user_id)
			if user_id ~= nil then
				search() -- continue generation
			else
				task({phone})
			end
		end)
	end

	search()
end

-- events, init user identity at connection
AddEventHandler("vRP:playerJoin",function(user_id,source,name,last_login)
	vRP.getUserIdentity(user_id, function(identity)
		if identity == nil then
			vRP.generateRegistrationNumber(function(registration)
				vRP.generatePhoneNumber(function(phone)
					local firstname = cfg.random_first_names[math.random(1,#cfg.random_first_names)]
					local name = cfg.random_last_names[math.random(1,#cfg.random_last_names)]
					local age = math.random(25,40)
					MySQL.Async.execute('INSERT IGNORE INTO vrp_user_identities(user_id,registration,phone,firstname,name,age) VALUES(@user_id,@registration,@phone,@firstname,@name,@age)', {user_id = user_id, registration = registration, phone = phone, firstname = firstname, name = name, age = age}, function(rowsChanged) end)
					MySQL.Async.execute('INSERT IGNORE INTO characters(identifier,firstname,lastname,dateofbirth,sex,height,registration,phone) VALUES(@identifier,@firstname,@lastname,@dateofbirth,@sex,@height,@registration,@phone)', {identifier=user_id,firstname=firstname,lastname=name,dateofbirth=age,sex="m",height="175",registration=registration,phone=phone}, function(rowsChanged) end)
				end)
			end)
		else
			if identity.phone == nil then
				vRP.generatePhoneNumber(function(phone)
					MySQL.Async.execute('UPDATE vrp_user_identities set phone = @phone where user_id = @user_id',{phone = phone, user_id = user_id}, function(rowsChanged) end)
				end)
			end
		end
	end)
end)

-- city hall menu

local cityhall_menu = {name=lang.cityhall.title(),css={top="75px", header_color="rgba(0,125,255,0.75)"}}

local function ch_identity(player,choice)
	TriggerEvent("esx_identity:vRPcharRegister", player)
	vRP.closeMenu(player)
end

local function ch_list_characters(player, choice)
	TriggerEvent('esx_identity:vRPcharList', player)
	vRP.closeMenu(player)
end

local function ch_select_character(player, choice)
	local user_id = vRP.getUserId(player)
	vRP.prompt(player,"Which character do you want to Select? [1-3]","",function(player,selection)
		MySQL.Async.fetchAll('SELECT active_character FROM vrp_user_identities WHERE user_id = @user_id', {user_id = user_id}, function(rows)
			if tonumber(rows[1].active_character) ~= tonumber(selection) then
				TriggerEvent('esx_identity:vRPcharSelect', player, selection)
				vRP.closeMenu(player)
			else
				vRPclient.notify(player, {"You are already using this character"})
			end
		end)
	end)
end

local function ch_delete_character(player, choice)
	local user_id = vRP.getUserId(player)
	vRP.prompt(player,"Which character do you want to delete? [1-3]","",function(player,selection)
		MySQL.Async.fetchAll('SELECT active_character FROM vrp_user_identities WHERE user_id = @user_id', {user_id = user_id}, function(rows)
			if tonumber(rows[1].active_character) ~= tonumber(selection) then
				TriggerEvent('esx_identity:vRPcharDelete', player, selection)
				vRP.closeMenu(player)
			else
				vRPclient.notify(player, {"You cannot delete this character as it is your current"})
			end
		end)
	end)
end

cityhall_menu[lang.cityhall.identity.title()] = {ch_identity,"",1}
-- cityhall_menu["Select Character"] = {ch_select_character,"",2}
-- cityhall_menu["List My Characters"] = {ch_list_characters,"",3}
-- cityhall_menu["Delete Character"] = {ch_delete_character,"",4}

local function cityhall_enter()
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		vRP.openMenu(source,cityhall_menu)
	end
end

local function cityhall_leave()
	vRP.closeMenu(source)
end

local function build_client_cityhall(source) -- build the city hall area/marker/blip
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local x,y,z = table.unpack(cfg.city_hall)

		vRPclient.addBlip(source,{x,y,z,cfg.blip[1],cfg.blip[2],lang.cityhall.title()})
		vRPclient.addMarker(source,{x,y,z-0.97,0.7,0.7,0.5,0,255,125,125,150,23})

		vRP.setArea(source,"vRP:cityhall",x,y,z,1,1.5,cityhall_enter,cityhall_leave)
	end
end

---- askid
vRP.choice_askid = {function(player,choice)
	vRPclient.getNearestPlayer(player,{10},function(nplayer)
		local nuser_id = vRP.getUserId(nplayer)
		if nuser_id ~= nil then
			vRPclient.notify(player,{lang.police.menu.askid.asked()})
			vRP.request(nplayer,lang.police.menu.askid.request(),15,function(nplayer,ok)
				if ok then
					vRP.getUserIdentity(nuser_id, function(identity)
						if identity then
							-- display identity and business
							local name = identity.name
							local firstname = identity.firstname
							local age = identity.age
							local phone = identity.phone
							local registration = identity.registration
							local firearmlicense = identity.firearmlicense
							local driverlicense = identity.driverlicense
							local pilotlicense = identity.pilotlicense
							local bname = ""
							local bcapital = 0
							local home = ""
							local number = ""

							vRP.getUserBusiness(nuser_id, function(business)
								if business then
									bname = business.name
									bcapital = business.capital
								end

								vRP.getUserAddress(nuser_id, function(address)
									if address then
										home = address.home
										number = address.number
									end

									local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number,firearmlicense,driverlicense,pilotlicense})
									vRPclient.setDiv(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
									-- request to hide div
									vRP.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
										vRPclient.removeDiv(player,{"police_identity"})
									end)
								end)
							end)
						end
					end)
				else
					vRPclient.notify(player,{lang.common.request_refused()})
				end
			end)
		else
			vRPclient.notify(player,{lang.common.no_player_near()})
		end
	end)
end, lang.police.menu.askid.description()}

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
	-- send registration number to client at spawn
	vRP.getUserIdentity(user_id, function(identity)
		if identity then
			if identity.registration ~= nil then
				vRPclient.setRegistrationNumber(source,{identity.registration})
			else
				vRP.generateRegistrationNumber(function(registration)
					MySQL.Async.execute('UPDATE vrp_user_identities set registration = @registration where user_id = @user_id',{registration = registration, user_id = user_id}, function(rowsChanged) end)
					vRPclient.setRegistrationNumber(source,{registration})
				end)
			end
		end
	end)

	-- first spawn, build city hall
	if first_spawn then
		build_client_cityhall(source)
	end
end)
