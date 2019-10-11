-- Source https://github.com/ESX-PUBLIC/esx_realweapons

Config = {}

-- 'bone' use bonetag https://pastebin.com/D7JMnX1g
-- x,y,z are offsets
Config.RealWeapons = {

	--{name = 'WEAPON_KNIFE', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'prop_w_me_knife_01'},
	--{name = 'WEAPON_NIGHTSTICK', 		bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'w_me_nightstick'},
	--{name = 'WEAPON_HAMMER', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'prop_tool_hammer'},
	--{name = 'WEAPON_BAT', 				bone = 24818, x = 0.3, y = -0.15, z = 0.04, xRot = 0.0, yRot = 270.0, zRot = 0.0, category = 'melee', 		model = 'w_me_bat'},
	--{name = 'WEAPON_GOLFCLUB', 			bone = 24818, x = -0.2, y = -0.15, z = -0.04, xRot = 0.0, yRot = 90.0, zRot = 0.0, category = 'melee', 		model = 'w_me_gclub'},
	--{name = 'WEAPON_CROWBAR', 			bone = 24818, x = -0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 90.0, zRot = 0.0, category = 'melee', 		model = 'w_me_crowbar'},
	--{name = 'WEAPON_BOTTLE', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'prop_w_me_bottle'},
	--{name = 'WEAPON_KNUCKLE', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'prop_w_me_dagger'},
	--{name = 'WEAPON_HATCHET', 			bone = 24818, x = 0.2, y = -0.15, z = 0.03, xRot = 0.0, yRot = 90.0, zRot = 0.0, category = 'melee', 		model = 'w_me_hatchet'},
	--{name = 'WEAPON_MACHETE', 			bone = 24818, x = 0.2, y = -0.15, z = -0.03, xRot = 0.0, yRot = 90.0, zRot = 0.0, category = 'melee', 		model = 'prop_ld_w_me_machette'},
	--{name = 'WEAPON_SWITCHBLADE', 		bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'prop_w_me_dagger'},
	--{name = 'WEAPON_FLASHLIGHT', 		bone = 24818, x = 0.0, y = 0.0, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'melee', 		model = 'prop_w_me_dagger'},

	--{name = 'WEAPON_PISTOL', 			bone = 51826, x = -0.01, y = 0.10, z = 0.07,  xRot = -115.0, yRot = 0.0,  zRot = 0.0, category = 'handguns', 	model = 'w_pi_pistol'},
	--{name = 'WEAPON_COMBATPISTOL', 		bone = 51826, x = -0.01, y = 0.10, z = 0.07,  xRot = -115.0, yRot = 0.0,  zRot = 0.0, category = 'handguns', 	model = 'w_pi_combatpistol'},
	--{name = 'WEAPON_APPISTOL', 			bone = 51826, x = -0.01, y = 0.10, z = 0.07,  xRot = -115.0, yRot = 0.0,  zRot = 0.0, category = 'handguns', 	model = 'w_pi_appistol'},
	--{name = 'WEAPON_PISTOL50', 			bone = 51826, x = -0.01, y = 0.10, z = 0.07,  xRot = -115.0, yRot = 0.0,  zRot = 0.0, category = 'handguns', 	model = 'w_pi_pistol50'},
	--{name = 'WEAPON_VINTAGEPISTOL', 	bone = 51826, x = -0.01, y = 0.10, z = 0.07,  xRot = -115.0, yRot = 0.0,  zRot = 0.0, category = 'handguns', 	model = 'w_pi_vintage_pistol'},
	--{name = 'WEAPON_HEAVYPISTOL', 		bone = 51826, x = -0.01, y = 0.10, z = 0.07,  xRot = -115.0, yRot = 0.0,  zRot = 0.0, category = 'handguns', 	model = 'w_pi_heavypistol'},
	--{name = 'WEAPON_SNSPISTOL', 		bone = 58271, x = -0.01, y = 0.1,  z = -0.07, xRot = -55.0,  yRot = 0.10, zRot = 0.0, category = 'handguns', 	model = 'w_pi_sns_pistol'},
	--{name = 'WEAPON_FLAREGUN', 			bone = 58271, x = -0.01, y = 0.1,  z = -0.07, xRot = -55.0,  yRot = 0.10, zRot = 0.0, category = 'handguns', 	model = 'w_pi_flaregun'},
	--{name = 'WEAPON_MARKSMANPISTOL', 	bone = 58271, x = -0.01, y = 0.1,  z = -0.07, xRot = -55.0,  yRot = 0.10, zRot = 0.0, category = 'handguns', 	model = ''},
	--{name = 'WEAPON_REVOLVER', 			bone = 58271, x = -0.01, y = 0.1,  z = -0.07, xRot = -55.0,  yRot = 0.10, zRot = 0.0, category = 'handguns', 	model = ''},
	--{name = 'WEAPON_STUNGUN', 			bone = 58271, x = -0.01, y = 0.1,  z = -0.07, xRot = -55.0,  yRot = 0.10, zRot = 0.0, category = 'handguns', 	model = 'w_pi_stungun'},

	--{name = 'WEAPON_MICROSMG', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'machine', 	model = 'w_sb_microsmg'},
	{name = 'WEAPON_SMG', 				bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 160.0, zRot = 0.0, category = 'machine', 	model = 'w_sb_smg'},
	--{name = 'WEAPON_MG', 				bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'machine', 	model = 'w_mg_mg'},
	--{name = 'WEAPON_COMBATMG', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'machine', 	model = 'w_mg_combatmg'},
	--{name = 'WEAPON_GUSENBERG', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'machine', 	model = 'w_sb_gusenberg'},
	--{name = 'WEAPON_COMBATPDW', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'machine', 	model = ''},
	--{name = 'WEAPON_MACHINEPISTOL', 	bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'machine', 	model = ''},
	--{name = 'WEAPON_ASSAULTSMG', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'machine', 	model = 'w_sb_assaultsmg'},
	--{name = 'WEAPON_MINISMG', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'machine', 	model = ''},

	--{name = 'WEAPON_ASSAULTRIFLE', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'assault', 	model = 'w_ar_assaultrifle'},
	--{name = 'WEAPON_CARBINERIFLE', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'assault', 	model = 'w_ar_carbinerifle'},
	--{name = 'WEAPON_ADVANCEDRIFLE', 	bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'assault', 	model = 'w_ar_advancedrifle'},
	--{name = 'WEAPON_SPECIALCARBINE', 	bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'assault', 	model = 'w_ar_specialcarbine'},
	--{name = 'WEAPON_BULLPUPRIFLE', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'assault', 	model = 'w_ar_bullpuprifle'},
	--{name = 'WEAPON_COMPACTRIFLE', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'assault', 	model = ''},

	{name = 'WEAPON_PUMPSHOTGUN', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 150.0, zRot = 0.0, category = 'shotgun', 	model = 'w_sg_pumpshotgun'},
	--{name = 'WEAPON_SAWNOFFSHOTGUN', 	bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'shotgun', 	model = ''},
	--{name = 'WEAPON_BULLPUPSHOTGUN', 	bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'shotgun', 	model = 'w_sg_bullpupshotgun'},
	--{name = 'WEAPON_ASSAULTSHOTGUN', 	bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'shotgun', 	model = 'w_sg_assaultshotgun'},
	--{name = 'WEAPON_MUSKET', 			bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'shotgun', 	model = 'w_ar_musket'},
	--{name = 'WEAPON_HEAVYSHOTGUN', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 225.0, zRot = 0.0, category = 'shotgun', 	model = 'w_sg_heavyshotgun'},
	--{name = 'WEAPON_DBSHOTGUN', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'shotgun', 	model = ''},
	--{name = 'WEAPON_AUTOSHOTGUN', 		bone = 24818, x = 0.1, y = 0.15, z = 0.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'shotgun', 	model = ''},

	--{name = 'WEAPON_SNIPERRIFLE', 		bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'sniper', 	model = 'w_sr_sniperrifle'},
	--{name = 'WEAPON_HEAVYSNIPER', 		bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'sniper', 	model = 'w_sr_heavysniper'},
	--{name = 'WEAPON_MARKSMANRIFLE', 	bone = 24818, x = 0.1, y = -0.15, z = 0.0, xRot = 0.0, yRot = 135.0, zRot = 0.0, category = 'sniper', 	model = 'w_sr_marksmanrifle'},

	--{name = 'WEAPON_REMOTESNIPER', 		bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'none', 		model = ''},
	--{name = 'WEAPON_STINGER', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'none', 		model = ''},

	--{name = 'WEAPON_GRENADELAUNCHER', 	bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'heavy', 		model = 'w_lr_grenadelauncher'},
	--{name = 'WEAPON_RPG', 				bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'heavy', 		model = 'w_lr_rpg'},
	--{name = 'WEAPON_MINIGUN', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'heavy', 		model = 'w_mg_minigun'},
	--{name = 'WEAPON_FIREWORK', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'heavy', 		model = 'w_lr_firework'},
	--{name = 'WEAPON_RAILGUN', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'heavy', 		model = 'w_ar_railgun'},
	--{name = 'WEAPON_HOMINGLAUNCHER', 	bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'heavy', 		model = 'w_lr_homing'},
	--{name = 'WEAPON_COMPACTLAUNCHER', 	bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'heavy', 		model = ''},

	--{name = 'WEAPON_STICKYBOMB', 		bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'prop_bomb_01_s'},
	--{name = 'WEAPON_MOLOTOV', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'w_ex_molotov'},
	--{name = 'WEAPON_FIREEXTINGUISHER', 	bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'w_am_fire_exting'},
	--{name = 'WEAPON_PETROLCAN', 		bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'w_am_jerrycan'},
	--{name = 'WEAPON_PROXMINE', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = ''},
	--{name = 'WEAPON_SNOWBALL', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'w_ex_snowball'},
	--{name = 'WEAPON_BALL', 				bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'w_am_baseball'},
	--{name = 'WEAPON_GRENADE', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'w_ex_grenadefrag'},
	--{name = 'WEAPON_SMOKEGRENADE', 		bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'w_ex_grenadesmoke'},
	--{name = 'WEAPON_BZGAS', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'thrown', 	model = 'w_ex_grenadesmoke'},

	--{name = 'WEAPON_DIGISCANNER', 		bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'others', 	model = 'w_am_digiscanner'},
	--{name = 'WEAPON_DAGGER', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'others', 	model = 'prop_w_me_dagger'},
	--{name = 'WEAPON_GARBAGEBAG', 		bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'others', 	model = ''},
	--{name = 'WEAPON_HANDCUFFS', 		bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'others', 	model = ''},
	--{name = 'WEAPON_BATTLEAXE', 		bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'others', 	model = 'prop_tool_fireaxe'},
	--{name = 'WEAPON_PIPEBOMB', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'others', 	model = ''},
	--{name = 'WEAPON_POOLCUE', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'others', 	model = 'prop_pool_cue'},
	--{name = 'WEAPON_WRENCH', 			bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'others', 	model = 'w_me_hammer'},
	--{name = 'GADGET_NIGHTVISION', 		bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'others', 	model = ''},
	--{name = 'GADGET_PARACHUTE', 		bone = 24818, x = 65536.0, y = 65536.0, z = 65536.0, xRot = 0.0, yRot = 0.0, zRot = 0.0, category = 'others', 	model = 'p_parachute_s'}
}

Config.WeaponObjects = {
	--["WEAPON_BAT"] = {name = "w_me_bat"},
	--["WEAPON_GOLFCLUB"] = {name = "w_me_gclub"},
	--["WEAPON_CROWBAR"] = {name = "w_me_crowbar"},
	["WEAPON_SMG"] = {name = "w_sb_smg"},
	["WEAPON_PUMPSHOTGUN"] = {name = "w_sg_pumpshotgun"},
}

local Weapons = {}
local Loaded = false
local wearable_enable = true
-----------------------------------------------------------
-----------------------------------------------------------
Citizen.CreateThread(function()

Citizen.Wait(20000)
	while wearable_enable do
		local playerPed = GetPlayerPed(-1)

		for i=1, #Config.RealWeapons, 1 do

			local weaponHash = GetHashKey(Config.RealWeapons[i].name)

			if HasPedGotWeapon(playerPed, weaponHash, false) then
				local onPlayer = false

				for weaponName, entity in pairs(Weapons) do
					if weaponName == Config.RealWeapons[i].name then
						onPlayer = true
						break
					end
				end

				if not onPlayer and weaponHash ~= GetSelectedPedWeapon(playerPed) then
					tvRP.SetGear(Config.RealWeapons[i].name)
				elseif onPlayer and weaponHash == GetSelectedPedWeapon(playerPed) then
					tvRP.RemoveGear(Config.RealWeapons[i].name)
				end
			end
		end
		Wait(500)
	end
end)

-----------------------------------------------------------
-----------------------------------------------------------
AddEventHandler('skinchanger:modelLoaded', function()
	if wearable_enable then
		tvRP.SetGears()
		Loaded = true
	end
end)
-----------------------------------------------------------
-----------------------------------------------------------
RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName)
	if wearable_enable then
		tvRP.RemoveGear(weaponName)
	end
end)
-----------------------------------------------------------
-----------------------------------------------------------
-- Remove only one weapon that's on the ped
function tvRP.RemoveGear(weapon)
	if wearable_enable then
		local _Weapons = {}
		local ped = GetPlayerPed(-1)
    local pedCoord = GetEntityCoords(ped)

		for weaponName, entity in pairs(Weapons) do
			if weaponName ~= weapon then
				_Weapons[weaponName] = entity
			else
				if Config.WeaponObjects[weaponName] then
					obj = GetClosestObjectOfType(pedCoord["x"], pedCoord["y"], pedCoord["z"]+0.5, 1.0, GetHashKey(Config.WeaponObjects[weaponName].name), false, false, false)
					if obj ~= nil then
						SetEntityAsMissionEntity(obj, true, true)
						DeleteObject(obj)
					end
				end
			end
		end

		Weapons = _Weapons
		Citizen.Trace("[WEAPON REMOVED] " .. weapon)
	end
end
-----------------------------------------------------------
-----------------------------------------------------------
-- Remove all weapons that are on the ped
function tvRP.RemoveGears()
	if wearable_enable then
		local ped = GetPlayerPed(-1)
		local pedCoord = GetEntityCoords(ped)
		for weaponName, entity in pairs(Weapons) do
			if Config.WeaponObjects[weaponName] then
				obj = GetClosestObjectOfType(pedCoord["x"], pedCoord["y"], pedCoord["z"], 2.0, GetHashKey(Config.WeaponObjects[weaponName].name), false, false, false)
				if obj ~= nil then
					SetEntityAsMissionEntity(obj, true, true)
					DeleteObject(obj)
				end
			end
		end
		Weapons = {}
		Citizen.Trace("[GEAR REMOVED] ")
	end
end
-----------------------------------------------------------
-----------------------------------------------------------
-- Add one weapon on the ped
function tvRP.SetGear(weapon)
	if wearable_enable then
		local bone       = nil
		local boneX      = 0.0
		local boneY      = 0.0
		local boneZ      = 0.0
		local boneXRot   = 0.0
		local boneYRot   = 0.0
		local boneZRot   = 0.0
		local playerPed  = GetPlayerPed(-1)
		local model      = nil

		for i=1, #Config.RealWeapons, 1 do
			if Config.RealWeapons[i].name == weapon then
				bone     = Config.RealWeapons[i].bone
				boneX    = Config.RealWeapons[i].x
				boneY    = Config.RealWeapons[i].y
				boneZ    = Config.RealWeapons[i].z
				boneXRot = Config.RealWeapons[i].xRot
				boneYRot = Config.RealWeapons[i].yRot
				boneZRot = Config.RealWeapons[i].zRot
				model    = Config.RealWeapons[i].model
				break
			end
		end

		local obj = CreateObject(GetHashKey(model),  1729.73,  6403.90,  34.56,  true,  true,  true)

		local playerPed = GetPlayerPed(-1)
		local boneIndex = GetPedBoneIndex(playerPed, bone)
		local bonePos 	= GetWorldPositionOfEntityBone(playerPed, boneIndex)

		AttachEntityToEntity(obj, playerPed, boneIndex, boneX, boneY, boneZ, boneXRot, boneYRot, boneZRot, false, false, false, false, 2, true)

		Weapons[weapon] = obj

		Citizen.Trace("[SET GEAR] " .. weapon)
	end
end
-----------------------------------------------------------
-----------------------------------------------------------
-- Add all the weapons in the xPlayer's loadout
-- on the ped
function tvRP.SetGears()
	if wearable_enable then
		local bone       = nil
		local boneX      = 0.0
		local boneY      = 0.0
		local boneZ      = 0.0
		local boneXRot   = 0.0
		local boneYRot   = 0.0
		local boneZRot   = 0.0
		local playerPed  = GetPlayerPed(-1)
		local model      = nil
		local playerData = tvRP.getWeapons()
		local weapon 	 = nil

		for k,weapon in pairs(playerData) do
			for j=1, #Config.RealWeapons, 1 do
				if Config.RealWeapons[j].name == k then
					bone     = Config.RealWeapons[j].bone
					boneX    = Config.RealWeapons[j].x
					boneY    = Config.RealWeapons[j].y
					boneZ    = Config.RealWeapons[j].z
					boneXRot = Config.RealWeapons[j].xRot
					boneYRot = Config.RealWeapons[j].yRot
					boneZRot = Config.RealWeapons[j].zRot
					model    = Config.RealWeapons[j].model
					weapon   = Config.RealWeapons[j].name

					break
				end
			end

			local obj = CreateObject(GetHashKey(model),  1729.73,  6403.90,  34.56,  true,  true,  true)

			local playerPed = GetPlayerPed(-1)
			local boneIndex = GetPedBoneIndex(playerPed, bone)
			local bonePos 	= GetWorldPositionOfEntityBone(playerPed, boneIndex)

			AttachEntityToEntity(obj, playerPed, boneIndex, boneX, boneY, boneZ, boneXRot, boneYRot, boneZRot, false, false, false, false, 2, true)

			Weapons[weapon] = obj
			Wait(0)
		end
	end
end
