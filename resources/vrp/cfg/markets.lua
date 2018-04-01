
local cfg = {}

-- define market types like garages and weapons
-- _config: blipid, blipcolor, permission (optional, only users with the permission will have access to the market)

cfg.market_types = {
	["food"] = {
		_config = {blipid=52, blipcolor=2},

		-- list itemid => price
		-- Drinks
		["milk"] = 20,
		["water"] = 20,
		["coffee"] = 40,
		["tea"] = 40,
		["icetea"] = 40,
		["orangejuice"] = 40,
		["gocagola"] = 60,
		["redgull"] = 60,
		["lemonlimonad"] = 60,
		["vodka"] = 200,
		["beer"] = 100,

		--Food
		["bacon"] = 20,
		["donut"] = 40,
		["tacos"] = 40,
		["ppizza"] = 80,
		["sandwich"] = 40,
		["kebab"] = 40,
		["pdonut"] = 65,
		["pills"] = 100, -- higher price to encourage calling medic?

		--Misc
		["cigarette"] = 20,
		["fishing_rod"] = 350,
		["repairkit"] = 550,
		["carrepairkit"] = 150,
		["binoculars"] = 1500,
	},

	["Vending Machine"] = {
		_config = {blipid=0, blipcolor=2},

		["water"] = 20,
		["coffee"] = 40,
		["gocagola"] = 60,
		["redgull"] = 60,

		--Food
		["donut"] = 40,
		["ppizza"] = 80,
		["sandwich"] = 40,
		["pdonut"] = 65,

		["pills"] = 100,

		--Misc
		["cigarette"] = 20,
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
		["pills"] = 100,
		["milk"] = 20,
		["water"] = 20,
		["coffee"] = 40,
		["tea"] = 40,
		["icetea"] = 40,
		["orangejuice"] = 40,
		["gocagola"] = 60,
		["redgull"] = 60,
		["lemonlimonad"] = 60,

		--Food
		["bacon"] = 20,
		["donut"] = 40,
		["tacos"] = 40,
		["ppizza"] = 80,
		["sandwich"] = 40,
		["kebab"] = 40,
		["pdonut"] = 65,

		-- Misc
		["binoculars"] = 1500,
 	},

	["coffeshop"] = {
		_config = {blipid=0, blipcolor=38, permission="police.shop"},
		["medkit"] = 10,
		["carrepairkit"] = 150,
		["pills"] = 100,
		["milk"] = 20,
		["water"] = 20,
		["coffee"] = 40,
		["tea"] = 40,
		["icetea"] = 40,
		["orangejuice"] = 40,
		["gocagola"] = 60,
		["redgull"] = 60,
		["lemonlimonad"] = 60,

		--Food
		["bacon"] = 20,
		["donut"] = 40,
		["tacos"] = 40,
		["ppizza"] = 80,
		["sandwich"] = 40,
		["kebab"] = 40,
		["pdonut"] = 65,

		-- Misc
		["binoculars"] = 1500,
	},

	["BlackMarket"] = {
	_config = {blipid=403,blipcolor=1},
		--["weed"] = 200,
		--["meth"] = 250,
		["meth_kit"] = 2000,
		["lockpick"] = 500,
		["cannabis_seed"] = 50,
	},
	["JewelryStore"] = {
	_config = {blipid=439,blipcolor=5},
		["sapphire"] = 300,
		["ruby"] = 480,
		["diamond"] = 840
	},
	["CalicoJacks"] = {
	_config = {blipid=439,blipcolor=3},
		["gold_coin"] = 720,
		["common_artifact"] = 960,
		["rare_artifact"] = 1440,
		["scuba_kit"] = 3000
	}
}

-- list of markets {type,x,y,z}

cfg.markets = {
	{"food",128.1410369873, -1286.1120605469, 29.281036376953},
	{"food",-47.522762298584,-1756.85717773438,29.4210109710693},
	{"food",25.7454013824463,-1345.26232910156,29.4970207214355},
	{"food",1135.57678222656,-981.78125,46.4157981872559},
	{"food",1163.53820800781,-323.541320800781,69.2050552368164},
	{"food",374.190032958984,327.506713867188,103.566368103027},
	{"food",2555.35766601563,382.16845703125,108.622947692871},
	{"food",2676.76733398438,3281.57788085938,55.2411231994629},
	{"food",1960.50793457031,3741.84008789063,32.3437385559082},
	{"food",547.987609863281,2669.7568359375,42.1565132141113},
	{"food",1698.30737304688,4924.37939453125,42.0636749267578},
	{"food",1729.54443359375,6415.76513671875,35.0372200012207},
	{"food",-3243.9013671875,1001.40405273438,12.8307056427002},
	{"food",-1820.55725097656,792.770568847656,138.113250732422},
	{"food",-1486.76574707031,-379.553985595703,40.163387298584},
	{"food",-1223.18127441406,-907.385681152344,12.3263463973999},
	{"food",-707.408996582031,-913.681701660156,19.2155857086182},
	--{"chemist",1163.79260253906,2705.58544921875,38.1576995849609},
	--{"drugstore",-497.977142333984,-328.329895019531,34.501636505127}, -- Rockford hills
	--{"drugstore",1154.5095214844,-1546.8057861328,34.843502044678}, -- El Burrought Heights
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
