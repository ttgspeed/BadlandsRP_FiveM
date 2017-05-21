local globalInventory = {
	["WEAPON_SNOWBALL"] = 100,
	["WEAPON_FIREEXTINGUISHER"] = 100,
	["WEAPON_PETROLCAN"] = 300,
	["WEAPON_SMOKEGRENADE"] = 300,
	["WEAPON_FLAREGUN"] = 300,
	["WEAPON_FLASHLIGHT"] = 300,
	["WEAPON_STUNGUN"] = 1000,
	["WEAPON_BAT"] = 1000,
	["WEAPON_HATCHET"] = 2000,
	["WEAPON_SWITCHBLADE"] = 3000,
	["WEAPON_MACHETE"] = 4000,
	["WEAPON_PISTOL"] = 10000,
	["WEAPON_MARKSMANPISTOL"] = 15000,
	["WEAPON_SNSPISTOL"] = 20000,
	["WEAPON_COMBATPISTOL"] = 25000,
	["WEAPON_MICROSMG"] = 35000,
	["WEAPON_SMG"] = 50000,
	["WEAPON_PUMPSHOTGUN"] = 75000,
	["WEAPON_MUSKET"] = 75000,
}

local shops = {
	['sandyshores1'] = {
		['type'] = 'ammunation',
		['position'] = {['x'] = 1693.93, ['y'] = 3759.73, ['z'] = 34.7},
		['stock'] = globalInventory
	},

		['vinewood1'] = {
			['type'] = 'ammunation',
			['position'] = {['x'] = 251.85, ['y'] = -49.87, ['z'] = 69.94},
			['stock'] = globalInventory
		},

		['delperro1'] = {
			['type'] = 'ammunation',
			['position'] = {['x'] = -1306.17, ['y'] = -394.16, ['z'] = 36.69},
			['stock'] = globalInventory
		},

		['vespuccibeach1'] = {
			['type'] = 'ammunation',
			['position'] = {['x'] = -662.22, ['y'] = -935.71, ['z'] = 21.82},
			['stock'] = globalInventory
		},

		['paletobay1'] = {
			['type'] = 'ammunation',
			['position'] = {['x'] = -330.12, ['y'] = 6083.16, ['z'] = 31.45},
			['stock'] = globalInventory
		},

		['tataviammountains1'] = {
			['type'] = 'ammunation',
			['position'] = {['x'] = 2567.91, ['y'] = 294.74, ['z'] = 108.73},
			['stock'] = globalInventory
		},

		['chumash1'] = {
			['type'] = 'ammunation',
			['position'] = {['x'] = -3171.67, ['y'] = 1087.66, ['z'] = 20.83},
			['stock'] = globalInventory
		},

		['eastlossantos1'] = {
			['type'] = 'ammunation',
			['position'] = {['x'] = 842.40, ['y'] = -1033.12, ['z'] = 28.19},
			['stock'] = globalInventory
		},

		['midlossantosrange'] = {
			['type'] = 'ammunation',
			['position'] = {['x'] = 21.70, ['y'] = -1107.41, ['z'] = 29.79},
			['stock'] = globalInventory
		},

		['greatchaparral1'] = {
			['type'] = 'ammunation',
			['position'] = {['x'] = -1117.81, ['y'] = 2698.16, ['z'] = 18.55},
			['stock'] = globalInventory
		},

		['cypressflatsrange1'] = {
			['type'] = 'ammunation',
			['position'] = {['x'] = 810.15, ['y'] = -2156.88, ['z'] = 29.61},
			['stock'] = globalInventory
		},
}

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

require "resources/essentialmode/lib/MySQL"
-- MySQL:open("IP", "databasname", "user", "password")
MySQL:open("45.55.232.93", "gta5_gamemode_essential", "feb5dee29051", "b46e6b907b777b92")

local weaponsOwned = {}

AddEventHandler('es:firstSpawn', function(source)
	TriggerEvent("es:getPlayerFromId", source, function(target)
		local executed_query = MySQL:executeQuery("SELECT * FROM owned WHERE identifier = '@name'", {['@name'] = target.identifier})
		local result = MySQL:getResults(executed_query, {'weapon'}, "identifier")

		weaponsOwned[source] = {}
		for k,v in ipairs(result)do
			weaponsOwned[source][k] = v.weapon
			TriggerClientEvent('es_roleplay:giveWeapon', source, v.weapon)
		end
	end)

	for k,v in pairs(shops)do
		TriggerClientEvent('es_miscstores:addWeaponShop', source, k, v.position.x, v.position.y, v.position.z, 255, 0, 0, v.stock)
	end
end)

RegisterServerEvent("es_roleplay:washCar")
AddEventHandler("es_roleplay:washCar", function()
	TriggerEvent("es:getPlayerFromId", source, function(user)
		user:removeMoney(50)
	end)
end)

AddEventHandler('es:playerLoaded', function(source, user)
	TriggerEvent("es:getPlayerFromId", source, function(target)
		local executed_query = MySQL:executeQuery("SELECT * FROM owned WHERE identifier = '@name'", {['@name'] = target.identifier})
		local result = MySQL:getResults(executed_query, {'weapon'}, "identifier")

		weaponsOwned[source] = {}
		for k,v in ipairs(result)do
			weaponsOwned[source][k] = v.weapon
			TriggerClientEvent('es_roleplay:giveWeapon', source, v.weapon)
		end
	end)

	TriggerClientEvent('es:playerLoaded', source)

	for k,v in pairs(shops)do
		TriggerClientEvent('es_miscstores:addWeaponShop', source, k, v.position.x, v.position.y, v.position.z, 255, 0, 0, v.stock)
	end
end)

AddEventHandler('playerSpawn', function()
	TriggerClientEvent('es_roleplay:removeAllWeapons', source)

	if(weaponsOwned[source] ~= nil)then
		for k,v in pairs(weaponsOwned[source])do
			TriggerClientEvent('es_roleplay:giveWeapon', source, v)
		end
	end

	TriggerEvent('es_roleplay:weaponSpawningDone', source)
end)

AddEventHandler("es_weaponshop:getOwnedWeapons", function(id, cb)
	cb(weaponsOwned[id])
end)

AddEventHandler('onResourceStart', function(rs)
	if(rs == "es_miscstores")then
		for k,v in pairs(shops)do
			SetTimeout(2000, function()
				TriggerEvent('es:getPlayers', function(players)
					for u,_ in pairs(players) do
						if(GetPlayerName(u))then
							TriggerEvent("es:getPlayerFromId", u, function(target)
								if(weaponsOwned[u] == nil)then
									local executed_query = MySQL:executeQuery("SELECT * FROM owned WHERE identifier = '@name'", {['@name'] = target.identifier})
									local result = MySQL:getResults(executed_query, {'weapon'}, "identifier")

									weaponsOwned[u] = {}
									for k,v in ipairs(result)do
										weaponsOwned[u][k] = tostring(v.weapon)
										TriggerClientEvent('es_roleplay:giveWeapon', u, v.weapon)
									end
								end
							end)
							TriggerClientEvent('es_miscstores:addWeaponShop', u, k, v.position.x, v.position.y, v.position.z, 255, 0, 0, v.stock)
						end
					end
				end)
			end)
		end
	end
end)

RegisterServerEvent("es_roleplay:buyWeapon")
AddEventHandler('es_roleplay:buyWeapon', function(weapon, ped)
	TriggerEvent("es:getPlayerFromId", source, function(user)
		for k,v in pairs(shops)do
			if(get3DDistance(v.position.x, v.position.y, v.position.z, user.coords.x, user.coords.y, user.coords.z) < 3.0)then
					if(not weaponsOwned[source])then
						weaponsOwned[source] = {}
					end
					for key,value in ipairs(weaponsOwned[source]) do
						if(value == weapon)then
							TriggerClientEvent("es_miscstores:clerkSpeech", source, ped, 3)
							TriggerClientEvent('chatMessage', source, "SHOP", {255, 0, 0}, "You already own this weapon.")
							return
						end
					end

				if(v.stock[weapon])then
					local price = v.stock[weapon]

				if(price <= user.money)then
						user:removeMoney(price)
						TriggerClientEvent('chatMessage', source, "SHOP", {255, 0, 0}, "Weapon bought.")
						TriggerClientEvent("es_roleplay:giveWeapon", source, weapon)
						TriggerClientEvent("es_miscstores:clerkSpeech", -1, ped, 1)
						if(not weaponsOwned[source])then
							weaponsOwned[source] = {}
						end
						table.insert(weaponsOwned[source], weapon)
						addWeapon(source, weapon)
					else
						TriggerClientEvent("es_miscstores:clerkSpeech", source, ped, 2)
						TriggerClientEvent('chatMessage', source, "SHOP", {255, 0, 0}, "You currently do not have money to buy this.")
					end
				else
					TriggerClientEvent('chatMessage', source, "SHOP", {255, 0, 0}, "That weapon cannot be bought here.")
				end

				return
			end
		end
		TriggerClientEvent('chatMessage', source, "SHOP", {255, 0, 0}, "You're not at a shop.")
	end)
end)

local twentyfourseven_shops = {
	{ ['x'] = 1961.1140136719, ['y'] = 3741.4494628906, ['z'] = 32.34375 },
	{ ['x'] = 1392.4129638672, ['y'] = 3604.47265625, ['z'] = 34.980926513672 },
	{ ['x'] = 546.98962402344, ['y'] = 2670.3176269531, ['z'] = 42.156539916992 },
	{ ['x'] = 2556.2534179688, ['y'] = 382.876953125, ['z'] = 108.62294769287 },
	{ ['x'] = 128.1410369873, ['y'] = -1286.1120605469, ['z'] = 29.281036376953 },
	{ ['x'] = -1821.9542236328, ['y'] = 792.40191650391, ['z'] = 138.13920593262 },
}

RegisterServerEvent('es_roleplay:buySnack')
AddEventHandler('es_roleplay:buySnack', function(s)
	if(not twentyfourseven_shops[s])then
		return
	end

	local lpos = twentyfourseven_shops[s]

	TriggerEvent('es:getPlayerFromId', source, function(user)
		local pos = user.coords
		if(get3DDistance(pos.x, pos.y, pos.z, lpos.x, lpos.y, lpos.z) < 1.0)then
			if(user.money > 250)then
				user:removeMoney(250)
				TriggerClientEvent('chatMessage', source, 'SHOP', {255, 0, 0}, "You were healed.")
				TriggerClientEvent('es_roleplay:heal', source)
			else

			end
		end
	end)
end)

function addWeapon(u, w)
	TriggerEvent("es:getPlayerFromId", u, function(user)
		MySQL:executeQuery("INSERT INTO owned (`identifier`, `weapon`) VALUES ('@username', '@weapon')",
		{['@username'] = user.identifier, ['@weapon'] = w})
	end)
end
