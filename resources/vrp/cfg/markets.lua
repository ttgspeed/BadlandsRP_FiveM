
local cfg = {}

-- define market types like garages and weapons
-- _config: blipid, blipcolor, permission (optional, only users with the permission will have access to the market)

cfg.market_types = {
	["food"] = {
		_config = {blipid=52, blipcolor=2},

		-- list itemid => price
		-- Drinks
		["lotto_ticket"] = 1000,
		["water"] = 40,
		["coffee"] = 80,
		["icetea"] = 80,
		["redgull"] = 120,
		["lemonlimonad"] = 120,

		--Food
		["scooby_snacks"] = 1,
		["pdonut"] = 120,
		["tacos"] = 80,
		["sandwich"] = 80,
		["pills"] = 200, -- higher price to encourage calling medic?

		--Misc
		["inv_pack_mini_1"] = 550,
		["inv_pack_mini_2"] = 550,
		["cigarette"] = 80,
		["fishing_rod"] = 350,
		["repairkit"] = 550,
		["carrepairkit"] = 150,
		["binoculars"] = 1500,
		["heelys"] = 2500,
		["tidalpod"] = 200,
		["key_chain"] = 5,
	},

	["Vending Machine"] = {
		_config = {blipid=0, blipcolor=2},

		["water"] = 40,
		["coffee"] = 80,
		["redgull"] = 120,

		--Food
		["donut"] = 40,
		["sandwich"] = 80,
		["pdonut"] = 65,

		["pills"] = 200,

		--Misc
		["cigarette"] = 80,
		["carrepairkit"] = 150,
	},

	["chemist"] = {
		_config = {blipid=52, blipcolor=46},
		["gold_catalyst"] = 50
	},

	["drugstore"] = {
		_config = {blipid=0, blipcolor=2, permission="emergency.shop"},
		["medkit"] = 10,
		["carrepairkit"] = 150,
		["pills"] = 200,
		["milk"] = 20,
		["water"] = 40,
		["coffee"] = 80,
		["tea"] = 40,
		["icetea"] = 80,
		["orangejuice"] = 40,
		["redgull"] = 120,
		["lemonlimonad"] = 120,

		--Food
		["donut"] = 60,
		["tacos"] = 80,
		["sandwich"] = 80,
		["kebab"] = 80,
		["pdonut"] = 120,

		-- Misc
		["binoculars"] = 1500,
 	},

	["lab"] = {
		_config = {blipid=0, blipcolor=2, permission="emergency.shop"},
		["drugkit"] = 50,
		["lidocaine"] = 20,
		["labetalol"] = 20,
		["bupropion"] = 20,
		["methylphenidate"] = 20,
		["naloxone"] = 20,
 	},

	["coffeshop"] = {
		_config = {blipid=0, blipcolor=38, permission="police.shop"},
		["medkit"] = 10,
		["carrepairkit"] = 150,
		["pills"] = 200,
		["milk"] = 20,
		["water"] = 40,
		["coffee"] = 80,
		["tea"] = 40,
		["icetea"] = 80,
		["orangejuice"] = 40,
		["redgull"] = 120,
		["lemonlimonad"] = 120,

		--Food
		["donut"] = 60,
		["tacos"] = 80,
		["sandwich"] = 80,
		["kebab"] = 80,
		["pdonut"] = 120,

		-- Misc
		["binoculars"] = 1500,
		["gsr_kit"] = 10
	},

	["BlackMarket"] = {
	_config = {blipid=403,blipcolor=1},
		--["weed"] = 200,
		--["meth"] = 250,
		["meth_kit"] = 2000,
		["lockpick"] = 500,
		["cannabis_seed"] = 50,
		["weapon_disable_kit"] = 1000,
		["safe_kit"] = 2000,
	},
	["JewelryStore"] = {
	_config = {blipid=439,blipcolor=5},
		["sapphire"] = 300,
		["ruby"] = 480,
		["diamond"] = 840,
		["blood_diamond"] = 5000
	},
	["CalicoJacks"] = {
	_config = {blipid=439,blipcolor=3},
		["gold_coin"] = 720,
		["common_artifact"] = 960,
		["rare_artifact"] = 1440,
		["scuba_kit"] = 3000
	},
	["Liquor"] = {
	_config = {blipid=439,blipcolor=3},
		["lotto_ticket"] = 1000,
		["beer"] = 720,
		["vodka"] = 960,
		["don_pereon"] = 8000,
		["binoculars"] = 1500,
	},
	["You Tool"] = {
	_config = {blipid=402,blipcolor=47},
		["dynamite"] = 100,
		["prospecting_kit"] = 1000,
		["nocrack"] = 7500,
	},
}

-- list of markets {type,x,y,z}

cfg.markets = {
	{"You Tool",2749.2573242188,3472.2922363282,55.679069519042},

	{"Liquor",128.1410369873, -1286.1120605469, 29.281036376953},
	{"Liquor",1135.57678222656,-981.78125,46.4157981872559},
	{"Liquor",-1486.76574707031,-379.553985595703,40.163387298584},
	{"Liquor",-1223.18127441406,-907.385681152344,12.3263463973999},

	{"food",-47.522762298584,-1756.85717773438,29.4210109710693},
	{"food",1163.53820800781,-323.541320800781,69.2050552368164},
	{"food",374.190032958984,327.506713867188,103.566368103027},
	{"food",2555.35766601563,382.16845703125,108.622947692871},
	{"food",2676.76733398438,3281.57788085938,55.2411231994629},
	{"food",1698.30737304688,4924.37939453125,42.0636749267578},
	{"food",1729.54443359375,6415.76513671875,35.0372200012207},
	{"food",-1820.55725097656,792.770568847656,138.113250732422},

	{"lab",-467.08670043946,-338.984375,-186.48709106446}, -- at kart track
	{"drugstore",-466.23666381836,-366.93399047852,-186.45489501953}, -- Rockford hills
	{"drugstore",304.99392700195,-1453.3599853516,29.968500137329}, -- Central Hospital
	{"drugstore",1698.42834472656,3589.11694335938,35.620964050293}, -- Sandy Shores
	{"drugstore",-372.40713500977,6120.236328125,31.440305709839}, -- paleto
	{"coffeshop",436.2197265625,-985.924865722656,30.689603805542}, -- Mission Row
	{"coffeshop",1851.13903808594,3684.64233398438,34.2670822143555}, -- Sandy Shores
	{"coffeshop",-443.76013183594,6011.6645507813,31.716371536255}, -- Paleto Bay

	{"BlackMarket",1390.47351074219,3607.759765625,38.9419250488281},
	{"JewelryStore",-622.38262939454,-229.97526550292,38.057010650634},
	{"CalicoJacks",-2963.7043457032,454.88302612304,15.316339492798},
	{"Vending Machine",1128.0802001953,-3300.1433105469,8.7199287414551}, -- at kart track
}

return cfg
