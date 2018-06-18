-- a basic tattooshop implementation
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPts = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_tattoos")
TSclient = Tunnel.getInterface("vrp_tattoos","vrp_tattoos")
Tunnel.bindInterface("vrp_tattoos",vRPts)

local Lang = module("vrp", "lib/Lang")
local lcfg = module("vrp", "cfg/base")
local lang = Lang.new(module("vrp", "cfg/lang/"..lcfg.lang) or {})

local cfg = module("vrp_tattoos", "cfg/tattoos")

local tattooshop_menus = {}

local zones = {
	["ZONE_TORSO"] = "Torso",
	["ZONE_LEFT_ARM"] = "Left Arm",
	["ZONE_LEFT_LEG"] = "Left Leg",
	["ZONE_RIGHT_ARM"] = "Right Arm",
	["ZONE_RIGHT_LEG"] = "Right Leg",
	["ZONE_HEAD"] = "Head"
}

function vRPts.addTattoo(user_id, tattoo, store)
	local player = vRP.getUserSource({user_id})
	if player ~= nil then
		TSclient.drawTattoo(player,{tattoo,store})
		vRP.getUData({user_id,"vRP:tattoos",function(value)
			local tattoos = json.decode(value)
			if tattoos == nil then
				tattoos = {}
			end
			tattoos[tattoo] = store
			vRP.setUData({user_id,"vRP:tattoos",json.encode(tattoos)})
		end})
	end
end

-- build tattooshop menus
for shop,tattoos in pairs(cfg.tattoos) do
	local tattooshop_menu = {
		name="Tattoos",
		css={top = "75px", header_color="rgba(255,0,0,0.75)"}
	}

	-- build tattooshop items
	local kitems = {}

	-- item choice
	local tattoshop_choice = function(player,choice)
		local tattoo = kitems[choice][1]
		local price = kitems[choice][2]

		if tattoo then
			local user_id = vRP.getUserId({player})
			local owned = false
			if tattoo == "CLEAR" then-- get player weapons to not rebuy the body
				vRP.request({player, "Do you want to clear ALL your tattoos for $"..price.."?", 15, function(player,ok)
					if ok then
						-- payment
						if user_id ~= nil and vRP.tryFullPayment({user_id,price}) then
							TSclient.cleanPlayer(player,{})
							TriggerEvent("vRP:cloakroom:update", player)
							vRP.setUData({user_id,"vRP:tattoos",json.encode({})})
							vRPclient.notify(player,{lang.money.paid({price})})
						else
							vRPclient.notify(player,{lang.money.not_enough()})
						end
					end
				end})
			else
				-- get player tattoos to not rebuy
				vRP.getUData({user_id,"vRP:tattoos",function(value)
					local tattoos = json.decode(value)
					if tattoos ~= nil then
						for k,v in pairs(tattoos) do
							if k == tattoo then
								owned = true
							end
						end
					end
					if not owned then
						-- payment
						TSclient.drawTattoo(player,{tattoo,shop})
						vRP.request({player, "Do you want to purchase this tattoo for $"..price.."?", 15, function(player,ok)
							if ok then
								if user_id ~= nil and vRP.tryFullPayment({user_id,price}) then
									vRPts.addTattoo(user_id, tattoo, shop)
									vRPclient.notify(player,{lang.money.paid({price})})
								else
									vRPclient.notify(player,{lang.money.not_enough()})
								end
							else
								TSclient.cleanPlayer(player,{})
								TriggerEvent("vRP:cloakroom:update", player)
								local tattoos = json.decode(value)
								if tattoos ~= nil then
									for k,v in pairs(tattoos) do
										TSclient.drawTattoo(player,{k,v})
									end
								end
							end
						end})
					else
						vRPclient.notify(player,{"You already have that tattoo"})
					end
				end})
			end
		end
	end

	-- add item options
	tattoos.catalog = json.decode(tattoos.catalog)

	kitems[">Clear Tattoos"] = {"CLEAR",50} -- idname/price
	tattooshop_menu[">Clear Tattoos"] = {tattoshop_choice,"",0} -- add description

	for i=1,#tattoos.catalog do
		local hash = tattoos.catalog[i].HashNameMale
		if hash == "" then
			hash = tattoos.catalog[i].HashNameFemale
		end
		kitems[tattoos.catalog[i].LocalizedName] = {hash,math.floor(tattoos.catalog[i].Price/10)} -- idname/price
		tattooshop_menu[tattoos.catalog[i].LocalizedName] = {tattoshop_choice,zones[tattoos.catalog[i].Zone].." - $"..math.floor(tattoos.catalog[i].Price/10),i} -- add description
	end

	-- sort choices per entry name
	table.sort(tattooshop_menu, function(a,b)
		if a[4] ~= nil and b[4] ~= nil then
			return a[4] < b[4]
		else
			return string.upper(a[1]) < string.upper(b[1])
		end
	end)

	tattooshop_menus[shop] = tattooshop_menu
end

local function build_client_tattooshops(source)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		for k,v in pairs(cfg.shops) do
			local shop,x,y,z = table.unpack(v)
			local group = cfg.tattoos[shop]
			local menu = tattooshop_menus[shop]

			if group and menu then
				local gcfg = group._config

				local function tattooshop_enter()
					local user_id = vRP.getUserId({source})
					if user_id ~= nil and vRP.hasPermissions({user_id,gcfg.permissions or {}}) then
						vRP.openMenu({source,menu})
					end
				end

				local function tattooshop_leave()
					vRP.closeMenu({source})
				end

				if gcfg.blip then
					vRPclient.addBlip(source,{x,y,z,gcfg.blipid,gcfg.blipcolor,gcfg.title})
				end

				vRPclient.addMarker(source,{x,y,z-1,1.0,1.0,0.5,0,255,125,125,150,23})

				vRP.setArea({source,"vRP:tattooshop"..k,x,y,z,1,1.5,tattooshop_enter,tattooshop_leave})
			end
		end
	end
end

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
	if first_spawn then
		build_client_tattooshops(source)
		SetTimeout(10000,function() -- increase this if you have problems with tattoos not saving on login has to be >31000
			vRP.getUData({user_id,"vRP:tattoos",function(value)
				local tattoos = json.decode(value)
				if tattoos ~= nil then
					for k,v in pairs(tattoos) do
						TSclient.drawTattoo(source,{k,v})
					end
				end
			end})
		end)
	else
		SetTimeout(15000,function() -- increase this if you have problems with tattoos not saving after death has to be >16000
			vRP.getUData({user_id,"vRP:tattoos",function(value)
				local tattoos = json.decode(value)
				if tattoos ~= nil then
					for k,v in pairs(tattoos) do
						TSclient.drawTattoo(source,{k,v})
					end
				end
			end})
		end)
	end
end)

RegisterServerEvent('vRP:cloakroom:update')
AddEventHandler('vRP:cloakroom:update', function(player)
	local user_id = vRP.getUserId({player})
	local source = player
	SetTimeout(1000,function()
		vRP.getUData({user_id,"vRP:tattoos",function(value)
			local tattoos = json.decode(value)
			if tattoos ~= nil then
				for k,v in pairs(tattoos) do
					TSclient.drawTattoo(source,{k,v})
				end
			end
		end})
	end)
end)
