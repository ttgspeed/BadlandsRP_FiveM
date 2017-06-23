
local cfg = {}

-- define market types like garages and weapons
-- _config: blipid, blipcolor, permission (optional, only users with the permission will have access to the market)

cfg.market_types = {
  ["food"] = {
    _config = {blipid=52, blipcolor=2},

    -- list itemid => price
    -- Drinks
    ["milk"] = 2,
    ["water"] = 2,
    ["coffee"] = 4,
    ["tea"] = 4,
    ["icetea"] = 8,
    ["orangejuice"] = 8,
    ["gocagola"] = 12,
    ["redgull"] = 12,
    ["lemonlimonad"] = 14,
    ["vodka"] = 30,

    --Food
    ["bread"] = 2,
    ["donut"] = 2,
    ["tacos"] = 8,
    ["sandwich"] = 20,
    ["kebab"] = 20,
    ["pdonut"] = 65,
    ["pills"] = 200, -- higher price to encourage calling medic?

	--Misc
	["cigarette"] = 20,
	["fishing_rod"] = 100
  },
  ["chemist"] = {
    _config = {blipid=52, blipcolor=46},
    ["gold_catalyst"] = 50
  },
  ["drugstore"] = {
    _config = {blipid=0, blipcolor=2, permission="emergency.shop"},
    ["medkit"] = 75,
    ["pills"] = 10,
    ["milk"] = 2,
    ["water"] = 2,
    ["coffee"] = 4,
    ["tea"] = 4,
    ["icetea"] = 8,
    ["orangejuice"] = 8,
    ["gocagola"] = 12,
    ["redgull"] = 12,
    ["lemonlimonad"] = 14,
    ["vodka"] = 30,

    --Food
    ["bread"] = 2,
    ["donut"] = 2,
    ["tacos"] = 8,
    ["sandwich"] = 20,
    ["kebab"] = 20,
    ["pdonut"] = 65
  },
  ["coffeshop"] = {
    _config = {blipid=0, blipcolor=38, permission="police.shop"},
    ["pills"] = 10,
    ["milk"] = 2,
    ["water"] = 2,
    ["coffee"] = 4,
    ["tea"] = 4,
    ["icetea"] = 8,
    ["orangejuice"] = 8,
    ["gocagola"] = 12,
    ["redgull"] = 12,
    ["lemonlimonad"] = 14,
    ["vodka"] = 30,

    --Food
    ["bread"] = 2,
    ["donut"] = 2,
    ["tacos"] = 8,
    ["sandwich"] = 20,
    ["kebab"] = 20,
    ["pdonut"] = 65
  },
  ["BlackMarket"] = {
	_config = {blipid=403,blipcolor=1},	
	["weed"] = 100,
	["meth"] = 150,
	["meth_kit"] = 10000
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
  {"drugstore",-497.977142333984,-328.329895019531,34.501636505127},
  {"drugstore",1698.42834472656,3589.11694335938,35.620964050293},
  {"coffeshop",436.2197265625,-985.924865722656,30.689603805542},
  {"coffeshop",1851.13903808594,3684.64233398438,34.2670822143555},
  {"BlackMarket",1390.47351074219,3607.759765625,38.9419250488281}
}

return cfg
