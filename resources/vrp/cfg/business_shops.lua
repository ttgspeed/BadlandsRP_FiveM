local cfg = {}
-- default flats safes from https://github.com/Nadochima/HomeGTAV/blob/master/List

-- define the home slots (each entry coordinate should be unique for ALL types)
-- each slots is a list of home components
--- {component,x,y,z} (optional _config)
--- the entry component is required
cfg.stores = {
	-- ["paleto_twentyfourseven"] = {
	-- 	blipid = 52,
	-- 	blipcolor = 1,
	-- 	safe_pos = {1734.82250976563,6420.0400390625,35.0372276306152},
	-- 	rent = 25000,
	-- 	reward = 10000,
	-- 	safe_money = 0,
	-- 	recipes = {},
	-- 	name = "Twenty Four Seven (Paleto Bay)",
	-- 	lastrobbed = 0,
	-- 	timetorob = 8
	-- },
	-- ["grapeseed_twentyfoursever"] = {
	-- 	blipid = 52,
	-- 	blipcolor = 1,
	-- 	safe_pos = {1706.8193359375,4920.0903320313,42.063671112061},
	-- 	rent = 20000,
	-- 	reward = 8000,
	-- 	safe_money = 0,
	-- 	recipes = {},
	-- 	name = "Twenty Four Seven (Grapeseed)",
	-- 	lastrobbed = 0,
	-- 	timetorob = 6
	-- },
	-- ["sandyshores_twentyfoursever"] = {
	-- 	blipid = 52,
	-- 	blipcolor = 1,
	-- 	safe_pos = {1959.357421875,3748.55346679688,32.3437461853027},
	-- 	rent = 17500,
	-- 	reward = 7000,
	-- 	safe_money = 0,
	-- 	recipes = {},
	-- 	name = "Twenty Four Seven (Sandy Shores)",
	-- 	lastrobbed = 0,
	-- 	timetorob = 6
	-- },
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
	-- ["routesixtyeight_twentyfoursever"] = {
	-- 	blipid = 52,
	-- 	blipcolor = 1,
	-- 	safe_pos = {546.11102294922,2663.4409179688,42.156536102295},
	-- 	rent = 20000,
	-- 	reward = 8000,
	-- 	safe_money = 0,
	-- 	recipes = {},
	-- 	name = "Twenty Four Seven (Route 68)",
	-- 	lastrobbed = 0,
	-- 	timetorob = 5,
	-- },
	-- ["chumash_twentyfoursever"] = {
	-- 	blipid = 52,
	-- 	blipcolor = 1,
	-- 	safe_pos = {-3249.4548339844,1004.3596191406,12.830714225769},
	-- 	rent = 17500,
	-- 	reward = 7000,
	-- 	safe_money = 0,
	-- 	recipes = {},
	-- 	name = "Twenty Four Seven (Chumash)",
	-- 	lastrobbed = 0,
	-- 	timetorob = 5,
	-- },
	["littleseoul_twentyfourseven"] = {
		blipid = 52,
		blipcolor = 1,
		safe_pos = {-709.17022705078,-904.21722412109,19.215591430664},
		shop_pos = {-707.408996582031,-913.681701660156,19.2155857086182},
		rent = 20000,
		reward = 8000,
		safe_money = 0,
		recipes = {},
		name = "Twenty Four Seven (Little Seoul)",
		lastrobbed = 0,
		timetorob = 5
	},
	-- ["mirrorpark_twentyfourseven"] = {
	-- 	blipid = 52,
	-- 	blipcolor = 1,
	-- 	safe_pos = {1160.5590820313,-314.16375732422,69.205055236816},
	-- 	rent = 17500,
	-- 	reward = 7000,
	-- 	safe_money = 0,
	-- 	recipes = {},
	-- 	name = "Twenty Four Seven (Mirror Park)",
	-- 	lastrobbed = 0,
	-- 	timetorob = 5
	-- },
}

return cfg
