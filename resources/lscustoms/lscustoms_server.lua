local Tunnel = module("vrp", "panopticon/sv_pano_tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Log = module("vrp", "lib/Log")

vRPcustoms = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","lscustoms")
TSclient = Tunnel.getInterface("lscustoms","lscustoms")
Tunnel.bindInterface("lscustoms",vRPcustoms)
Tunnel.initiateProxy()

--[[
Los Santos Customs V1.1
Credits - MythicalBro
/////License/////
Do not reupload/re release any part of this script without my permission
]]
local tbl = {
[1] = {locked = false, player = nil},
[2] = {locked = false, player = nil},
[3] = {locked = false, player = nil},
[4] = {locked = false, player = nil},
[5] = {locked = false, player = nil},
[6] = {locked = false, player = nil},
[7] = {locked = false, player = nil},
[8] = {locked = false, player = nil},
}

AddEventHandler('playerDropped', function()
	for i,g in pairs(tbl) do
		if g.player then
			if source == g.player then
				g.locked = false
				g.player = nil
			end
		end
	end
end)

function vRPcustoms.buttonSelected(name, button)
	if button.price then -- check if button have price
		local src = source
		local user_id = vRP.getUserId({src})
		if(vRP.tryDebitedPayment({user_id,button.price})) then
			TSclient.buttonSelected(src, {name, button, true})
			Log.write(user_id,"Purchased "..name.." for $"..button.price.." at LS Customs.",Log.log_type.purchase)
		else
			TSclient.buttonSelected(src, {name, button, false})
			Log.write(user_id,"Attempted to purchased "..name.." for $"..button.price.." at LS Customs. Insufficient funds.",Log.log_type.purchase)
		end
	end
end

function setDynamicMulti(user_id, vehicle, options)
  MySQL.Async.execute('UPDATE vrp_user_vehicles SET mods = @mods, colour = @colour, scolour = @scolour, ecolor = @ecolor, ecolorextra = @ecolorextra, wheels = @wheels, platetype = @platetype, windows = @windows, smokecolor1 = @smokecolor1, smokecolor2 = @smokecolor2, smokecolor3 = @smokecolor3, neoncolor1 = @neoncolor1, neoncolor2 = @neoncolor2, neoncolor3 = @neoncolor3 WHERE user_id = @user_id AND vehicle = @vehicle', {mods = options.mods, colour = options.colour, scolour = options.scolour, ecolor = options.ecolor, ecolorextra = options.ecolorextra, wheels = options.wheels, platetype = options.platetype, windows = options.windows, smokecolor1 = options.smokecolor1, smokecolor2 = options.smokecolor2, smokecolor3 = options.smokecolor3, neoncolor1 = options.neoncolor1, neoncolor2 = options.neoncolor2, neoncolor3 = options.neoncolor3, user_id = user_id, vehicle = vehicle}, function(rowsChanged) end)
end

function vRPcustoms.updateVehicle(vehicle,mods,vCol,vColExtra,eCol,eColExtra,wheeltype,plateindex,windowtint,smokecolor1,smokecolor2,smokecolor3,neoncolor1,neoncolor2,neoncolor3)
	local user_id = vRP.getUserId({source})
	local vmods = json.encode(mods)
	setDynamicMulti(user_id, vehicle, {
    ["mods"] = vmods,
		["colour"] = vCol,
		["scolour"] = vColExtra,
		["ecolor"] = eCol,
		["ecolorextra"] = eColExtra,
		["wheels"] = wheeltype,
		["neon"] = neoncolor,
		["platetype"] = plateindex,
		["windows"] = windowtint,
    ["smokecolor1"] = smokecolor1,
    ["smokecolor2"] = smokecolor2,
    ["smokecolor3"] = smokecolor3,
    ["neoncolor1"] = neoncolor1,
    ["neoncolor2"] = neoncolor2,
    ["neoncolor3"] = neoncolor3,
	})
end

function vRPcustoms.finished(veh)
	local model = veh.model --Display name from vehicle model(comet2, entityxf)
	local mods = veh.mods
	--[[
	mods[0].mod - spoiler
	mods[1].mod - front bumper
	mods[2].mod - rearbumper
	mods[3].mod - skirts
	mods[4].mod - exhaust
	mods[5].mod - roll cage
	mods[6].mod - grille
	mods[7].mod - hood
	mods[8].mod - fenders
	mods[10].mod - roof
	mods[11].mod - engine
	mods[12].mod - brakes
	mods[13].mod - transmission
	mods[14].mod - horn
	mods[15].mod - suspension
	mods[16].mod - armor
	mods[23].mod - tires
	mods[23].variation - custom tires
	mods[24].mod - tires(Just for bikes, 23:front wheel 24:back wheel)
	mods[24].variation - custom tires(Just for bikes, 23:front wheel 24:back wheel)
	mods[25].mod - plate holder
	mods[26].mod - vanity plates
	mods[27].mod - trim design
	mods[28].mod - ornaments
	mods[29].mod - dashboard
	mods[30].mod - dial design
	mods[31].mod - doors
	mods[32].mod - seats
	mods[33].mod - steering wheels
	mods[34].mod - shift leavers
	mods[35].mod - plaques
	mods[36].mod - speakers
	mods[37].mod - trunk
	mods[38].mod - hydraulics
	mods[39].mod - engine block
	mods[40].mod - cam cover
	mods[41].mod - strut brace
	mods[42].mod - arch cover
	mods[43].mod - aerials
	mods[44].mod - roof scoops
	mods[45].mod - tank
	mods[46].mod - doors
	mods[48].mod - liveries

	--Toggle mods
	mods[20].mod - tyre smoke
	mods[22].mod - headlights
	mods[18].mod - turbo

	--]]
	local color = veh.color
	local extracolor = veh.extracolor
	local neoncolor = veh.neoncolor
	local smokecolor = veh.smokecolor
	local plateindex = veh.plateindex
	local windowtint = veh.windowtint
	local wheeltype = veh.wheeltype
	local bulletProofTyres = veh.bulletProofTyres
	--Do w/e u need with all this stuff when vehicle drives out of lsc
end
