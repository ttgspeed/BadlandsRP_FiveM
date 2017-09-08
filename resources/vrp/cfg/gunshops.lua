
local cfg = {}
-- list of weapons for sale
-- for the native name, see https://wiki.fivem.net/wiki/Weapons (not all of them will work, look at client/player_state.lua for the real weapon list)
-- create groups like for the garage config
-- [native_weapon_name] = {display_name,body_price,ammo_price,description}
-- ammo_price can be < 1, total price will be rounded
-- description
-- position in list (order)

-- _config: blipid, blipcolor, permission (optional, only users with the permission will have access to the shop)

cfg.gunshop_types = {
	["Ammunation"] = {
		_config = {blipid=110,blipcolor=1},
		["WEAPON_FLASHLIGHT"] = {"FlashLight",300,0,"",1},
		["WEAPON_GOLFCLUB"] = {"Golf club",300,0,"",2},
		["WEAPON_BAT"] = {"Bat",900,0,"",3},
		["WEAPON_HAMMER"] = {"Hammer",1000,0,"",4},
		["WEAPON_CROWBAR"] = {"Crowbar",2000,0,"",5},
		["WEAPON_KNIFE"] = {"Knife",2500,0,"",6},
		["WEAPON_SNSPISTOL"] = {"SNS Pistol",3500,15,"",7},
		["WEAPON_VINTAGEPISTOL"] = {"Vintage Pistol",4500,15,"",8},
		["WEAPON_PISTOL"] = {"Pistol",5500,15,"",9},
		["WEAPON_REVOLVER"] = {"Revolver",10500,35,"",10}
	},
    	["GunsNAmmo"] = {
		_config = {blipid=110,blipcolor=8},
		["WEAPON_FLASHLIGHT"] = {"FlashLight",300,0,"",1},
		["WEAPON_GOLFCLUB"] = {"Golf club",300,0,"",2},
		["WEAPON_BAT"] = {"Bat",900,0,"",3},
		["WEAPON_BOTTLE"] = {"Bottle",1200,0,"Illegal",4},
		["WEAPON_DAGGER"] = {"Dagger",2000,0,"Illegal",5},
		["WEAPON_HAMMER"] = {"Hammer",1000,0,"",6},
		["WEAPON_KNIFE"] = {"Knife",2500,0,"",7},
		["WEAPON_CROWBAR"] = {"Crowbar",2000,0,"",7},
		["WEAPON_SNSPISTOL"] = {"SNS Pistol",3500,15,"",8},
		["WEAPON_VINTAGEPISTOL"] = {"Vintage Pistol",4500,15,"",9},
		["WEAPON_PISTOL"] = {"Pistol",5500,15,"",10},
		["WEAPON_REVOLVER"] = {"Revolver",10500,35,"",11},
		["WEAPON_PISTOL50"] = {"Deagle",10500,35,"Illegal",12},
		["WEAPON_MACHINEPISTOL"] = {"Machine Pistol",13500,55,"Illegal",13},
		["WEAPON_MICROSMG"] = {"Mini SMG",18000,55,"Illegal",14}

	},
	["Police Armory"] = {
		_config = {blipid=0,blipcolor=38,permission = "police.armory"},
		["WEAPON_NIGHTSTICK"] = {"Nightstick",0,0,"",1},
		["WEAPON_FLASHLIGHT"] = {"FlashLight",0,0,"",2},
		["WEAPON_PETROLCAN"] = {"Petrol",0,0,"",3},
		["WEAPON_FLARE"] = {"Flare",50,0,"",4},
		["WEAPON_STUNGUN"] = {"Taser",0,0,"",5},
		["WEAPON_COMBATPISTOL"] = {"Combat Pistol",0,0,"",6},
		["WEAPON_HEAVYPISTOL"] = {"Heavy Pistol",1500,15,"",7},
		["WEAPON_PUMPSHOTGUN"] = {"Shotgun",600,15,"",8},
		["WEAPON_SMG"] = {"SMG",2000,15,"",9},
		["WEAPON_CARBINERIFLE"] = {"Assault Rifle",3000,15,"",10},
		["WEAPON_SPECIALCARBINE"] = {"Special Carabine",3000,15,"",11},
		["police_vest"] = {"Police Vest",1000,0,"",12}
	},
	["EMS Supply Cabinet"] = {
		_config = {blipid=0,blipcolor=61,permission = "emergency.cabinet"},
		["WEAPON_FLASHLIGHT"] = {"FlashLight",0,0,"",1},
		["WEAPON_FIREEXTINGUISHER"] = {"Fire Extinguisher",0,0,"",2},
		["WEAPON_FLARE"] = {"Flare",50,0,"",3}
	}
}

-- list of gunshops positions

cfg.gunshops = {
	{"Ammunation", 1692.41, 3758.22, 34.7053},
	{"Ammunation", 252.696, -48.2487, 69.941},
	{"Ammunation", 844.299, -1033.26, 28.1949},
	{"Ammunation", -331.624, 6082.46, 31.4548},
	{"Ammunation", -664.147, -935.119, 21.8292},
	{"Ammunation", -1305.93420410156,-393.309448242188,36.6957969665527},
	{"GunsNAmmo", -1119.48803710938,2697.08666992188,18.5541591644287},
	{"Ammunation", 2569.62, 294.453, 108.735},
	{"Ammunation", -3172.60375976563,1085.74816894531,20.8387603759766},
	{"Ammunation", 21.70, -1107.41, 29.79},
	{"Ammunation", 810.15, -2156.88, 29.61},
	{"Police Armory",451.978698730469,-979.936645507813,30.6895847320557}, -- Mission row
	{"Police Armory",1849.80053710938,3687.724609375,34.2670364379883}, -- Sandy Shores
	{"Police Armory",-1120.54675292969,-842.215148925781,13.373724937439}, -- Vespucci
	--{"EMS Supply Cabinet",-494.091766357422,-324.365142822266,34.5015754699707}, -- Rockford Hills
	{"EMS Supply Cabinet",1154.6973876953,-1549.6778564453,34.843669891357}, -- El Burrought Heights
	{"EMS Supply Cabinet",1695.76110839844,3594.73754882813,35.6209259033203} -- Sandy Shores
}

return cfg
