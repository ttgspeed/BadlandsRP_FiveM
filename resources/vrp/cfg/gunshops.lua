
local cfg = {}
-- list of weapons for sale
-- for the native name, see https://wiki.fivem.net/wiki/Weapons (not all of them will work, look at client/player_state.lua for the real weapon list)
-- create groups like for the garage config
-- [native_weapon_name] = {display_name,body_price,ammo_price,description}
-- ammo_price can be < 1, total price will be rounded

-- _config: blipid, blipcolor, permission (optional, only users with the permission will have access to the shop)

cfg.gunshop_types = {
  ["Ammunation"] = {
    _config = {blipid=110,blipcolor=1},
    ["WEAPON_BOTTLE"] = {"Bottle",1000,0,""},
    ["WEAPON_BAT"] = {"Bat",1500,0,""},
    ["WEAPON_DAGGER"] = {"Dagger",2000,0,""},
    ["WEAPON_HAMMER"] = {"Hammer",2500,0,""},
    ["WEAPON_KNIFE"] = {"Knife",2000,0,""},
	  ["WEAPON_CROWBAR"] = {"Crowwbar",3000,0,""},
    ["WEAPON_GOLFCLUB"] = {"Golf club",3500,0,""},
	  ["WEAPON_SNSPISTOL"] = {"SNS Pistol",2500,15,""},
    ["WEAPON_VINTAGEPISTOL"] = {"Vintage Pistol",2500,15,""},
    ["WEAPON_PISTOL"] = {"Pistol",2500,15,""},
	  ["WEAPON_MICROSMG"] = {"Mini SMG",50000,25,""},
	  ["WEAPON_MACHINEPISTOL"] = {"Machine Pistol",7500,25,""}
  },

  ["Armory"] = {
    _config = {blipid=2,blipcolor=38,permission = "police.armory"},
    ["WEAPON_NIGHTSTICK"] = {"Nighstick",0,0,""},
    ["WEAPON_STUNGUN"] = {"Taser",0,0,""},
	  ["WEAPON_COMBATPISTOL"] = {"Combat Pistol",5000,15,""},
    ["WEAPON_HEAVYPISTOL"] = {"Heavy Pistol",5000,15,""},
    ["WEAPON_PUMPSHOTGUN"] = {"Shotgun",0,0,""},
	  ["WEAPON_SMG"] = {"SMG",5000,25,""},
    ["WEAPON_CARBINERIFLE"] = {"Assault Rifle",0,0,""},
	  ["WEAPON_SPECIALCARBINE"] = {"Special Carabine",200000,50,""},
	  ["WEAPON_FLASHLIGHT"] = {"FlashLight",50000,0,""},
	  ["WEAPON_PETROLCAN"] = {"Petrol",50000,0,""},
	  ["WEAPON_FLARE"] = {"Flare",200000,50,""}
  }
}

-- list of gunshops positions

cfg.gunshops = {
  {"Ammunation", 1692.41, 3758.22, 34.7053},
  {"Ammunation", 252.696, -48.2487, 69.941},
  {"Ammunation", 844.299, -1033.26, 28.1949},
  {"Ammunation", -331.624, 6082.46, 31.4548},
  {"Ammunation", -664.147, -935.119, 21.8292},
  {"Ammunation", -1320.983, -389.260, 36.483},
  {"Ammunation", -1119.48803710938,2697.08666992188,18.5541591644287},
  {"Ammunation", 2569.62, 294.453, 108.735},
  {"Ammunation", -3172.60375976563,1085.74816894531,20.8387603759766},
  {"Ammunation", 21.70, -1107.41, 29.79},
  {"Ammunation", 810.15, -2156.88, 29.61},
  {"Armory",451.978698730469,-979.936645507813,30.6895847320557},
  {"Armory",1849.80053710938,3687.724609375,34.2670364379883},
  {"Armory",-1120.54675292969,-842.215148925781,13.373724937439}
}

return cfg
