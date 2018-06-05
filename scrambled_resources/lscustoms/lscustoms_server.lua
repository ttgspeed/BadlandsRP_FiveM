local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","lscustoms") -- server -> client tunnel

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
RegisterServerEvent('d6e30ed8-4aab-43d3-a795-fe63b96c64da')
AddEventHandler('d6e30ed8-4aab-43d3-a795-fe63b96c64da', function(b,garage)
	tbl[tonumber(garage)].locked = b
	if not b then
		tbl[tonumber(garage)].player = nil
	else
		tbl[tonumber(garage)].player = source
	end
	TriggerClientEvent('5852317a-87f8-47f3-a0af-7e3db05ad871',-1,tbl)
	--print(json.encode(tbl))
end)
RegisterServerEvent('09ff8574-8436-42f2-bf98-e913b6dc2c1f')
AddEventHandler('09ff8574-8436-42f2-bf98-e913b6dc2c1f', function()
	TriggerClientEvent('5852317a-87f8-47f3-a0af-7e3db05ad871',-1,tbl)
	--print(json.encode(tbl))
end)
AddEventHandler('playerDropped', function()
	for i,g in pairs(tbl) do
		if g.player then
			if source == g.player then
				g.locked = false
				g.player = nil
				TriggerClientEvent('5852317a-87f8-47f3-a0af-7e3db05ad871',-1,tbl)
			end
		end
	end
end)

RegisterServerEvent('f6811409-861b-4ee2-b52b-4e3ded922f92')
AddEventHandler('f6811409-861b-4ee2-b52b-4e3ded922f92', function(name, button)
	if button.price then -- check if button have price
		local src = source
		local user_id = vRP.getUserId({src})
		if(vRP.tryDebitedPayment({user_id,button.price})) then
			TriggerClientEvent('504a0b66-0d05-4b09-bf22-f35c3227aad2', src,name, button, true)
		else
			TriggerClientEvent('504a0b66-0d05-4b09-bf22-f35c3227aad2', src,name, button, false)
		end
	end
end)

RegisterServerEvent('3264074e-098e-4738-85e9-68832ed49689')
AddEventHandler('3264074e-098e-4738-85e9-68832ed49689', function(veh)
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
end)
