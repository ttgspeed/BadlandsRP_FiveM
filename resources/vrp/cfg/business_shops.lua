local cfg = {}
-- default flats safes from https://github.com/Nadochima/HomeGTAV/blob/master/List

-- define the home slots (each entry coordinate should be unique for ALL types)
-- each slots is a list of home components
--- {component,x,y,z} (optional _config)
--- the entry component is required
cfg.stores = {
	["strawberry_twentyfourseven"] = {
		blipid = 52,
		blipcolor = 1,
		safe_pos = {28.17778968811,-1339.5158691406,29.49701499939},
		shop_pos = {25.709329605102,-1345.450805664,29.49701499939},
		rent = 5000,
		reward = 10000,
		business = 0,
		safe_money = 0,
		recipes = {},
		name = "Twenty Four Seven (Strawberry)",
		lastrobbed = 0,
		timetorob = 8
	},
	-- ["grapeseed_twentyfoursever"] = {
	-- 	blipid = 52,
	-- 	blipcolor = 1,
	-- 	safe_pos = {1707.5734863282,4919.9111328125,42.063621520996},
	-- 	shop_pos = {1698.3913574218,4924.3657226562,42.063621520996},
	-- 	rent = 20000,
	-- 	reward = 8000,
	-- 	business = 0,
	-- 	safe_money = 0,
	-- 	recipes = {},
	-- 	name = "Twenty Four Seven (Grapeseed)",
	-- 	lastrobbed = 0,
	-- 	timetorob = 6
	-- },
	["sandyshores_twentyfoursever"] = {
		blipid = 52,
		blipcolor = 1,
		safe_pos = {1959.6484375,3748.5061035156,32.343727111816},
		shop_pos = {1960.6652832032,3741.9538574218,32.34373474121},
		rent = 3500,
		reward = 7000,
		business = 0,
		safe_money = 0,
		recipes = {},
		name = "Twenty Four Seven (Sandy Shores)",
		lastrobbed = 0,
		timetorob = 6
	},
	-- ["bar_one"] = {
	-- 	blipid = 52,
	-- 	blipcolor = 1,
	-- 	safe_pos = {1982.78100585938,3052.92529296875,47.2150535583496},
	-- 	rent = 17500,
	-- 	reward = 7000,
	-- 	safe_money = 0,
	-- 	recipes = {},
	-- 	name = "Yellow Jack (Sandy Shores)",
	-- 	lastrobbed = 0,
	-- 	timetorob = 5
	-- },
	["routesixtyeight_twentyfoursever"] = {
		blipid = 52,
		blipcolor = 1,
		safe_pos = {546.42370605468,2663.2272949218,42.156475067138},
		shop_pos = {547.92974853516,2669.7360839844,42.156475067138},
		rent = 4000,
		reward = 8000,
		business = 0,
		safe_money = 0,
		recipes = {},
		name = "Twenty Four Seven (Route 68)",
		lastrobbed = 0,
		timetorob = 5,
	},
	["chumash_twentyfoursever"] = {
		blipid = 52,
		blipcolor = 1,
		safe_pos = {-3249.4548339844,1004.3596191406,12.830714225769},
		shop_pos = {-3243.9440917968,1001.3483276368,12.830703735352},
		rent = 3500,
		reward = 7000,
		business = 0,
		safe_money = 0,
		recipes = {},
		name = "Twenty Four Seven (Chumash)",
		lastrobbed = 0,
		timetorob = 5,
	},
	["littleseoul_twentyfourseven"] = {
		blipid = 52,
		blipcolor = 1,
		safe_pos = {-709.17022705078,-904.21722412109,19.215591430664},
		shop_pos = {-707.408996582031,-913.681701660156,19.2155857086182},
		rent = 5000,
		reward = 10000,
		business = 0,
		safe_money = 0,
		recipes = {},
		name = "Twenty Four Seven (Little Seoul)",
		lastrobbed = 0,
		timetorob = 5
	},
	["lostmc_club"] = {
		blipid = 52,
		blipcolor = 1,
		safe_pos = {977.01623535156,-103.9479751587,74.845222473144},
		shop_pos = {988.3662109375,-96.841957092286,74.84536743164},
		rent = 3500,
		reward = 7000,
		business = 0,
		safe_money = 0,
		recipes = {},
		name = "The Lost Motorcycle Club",
		lastrobbed = 0,
		timetorob = 5
	},
	["tequilala"] = {
		blipid = 280,
		blipcolor = 2,
		safe_pos = {-564.51959228516,279.73104858398,82.976257324218},
		shop_pos = {-559.94354248046,287.06802368164,82.176391601562},
		rent = 2000,
		reward = 0,
		business = 0,
		safe_money = 0,
		recipes = {},
		name = "Tequi-La-La",
		lastrobbed = 0,
		timetorob = 5
	},
	["bahamamamas"] = {
		blipid = 280,
		blipcolor = 2,
		safe_pos = {-1391.3736572266,-597.94622802734,30.319570541382},
		shop_pos = {-1377.595336914,-626.78240966796,30.819568634034},
		rent = 2000,
		reward = 0,
		business = 0,
		safe_money = 0,
		recipes = {},
		name = "Bahama Mamas",
		lastrobbed = 0,
		timetorob = 5
	},
}

return cfg
