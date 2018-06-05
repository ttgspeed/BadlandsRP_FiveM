--[[
Los Santos Customs V1.1
Credits - MythicalBro
/////License/////
Do not reupload/re release any part of this script without my permission
]]
local colors = {
	{name = "Black", colorindex = 0},{name = "Carbon Black", colorindex = 147},
	{name = "Graphite", colorindex = 1},{name = "Anthracite Black", colorindex = 11},
	{name = "Black Steel", colorindex = 2},{name = "Dark Steel", colorindex = 3},
	{name = "Silver", colorindex = 4},{name = "Bluish Silver", colorindex = 5},
	{name = "Rolled Steel", colorindex = 6},{name = "Shadow Silver", colorindex = 7},
	{name = "Stone Silver", colorindex = 8},{name = "Midnight Silver", colorindex = 9},
	{name = "Cast Iron Silver", colorindex = 10},{name = "Red", colorindex = 27},
	{name = "Torino Red", colorindex = 28},{name = "Formula Red", colorindex = 29},
	{name = "Lava Red", colorindex = 150},{name = "Blaze Red", colorindex = 30},
	{name = "Grace Red", colorindex = 31},{name = "Garnet Red", colorindex = 32},
	{name = "Sunset Red", colorindex = 33},{name = "Cabernet Red", colorindex = 34},
	{name = "Wine Red", colorindex = 143},{name = "Candy Red", colorindex = 35},
	{name = "Hot Pink", colorindex = 135},{name = "Pfsiter Pink", colorindex = 137},
	{name = "Salmon Pink", colorindex = 136},{name = "Sunrise Orange", colorindex = 36},
	{name = "Orange", colorindex = 38},{name = "Bright Orange", colorindex = 138},
	{name = "Gold", colorindex = 99},{name = "Bronze", colorindex = 90},
	{name = "Yellow", colorindex = 88},{name = "Race Yellow", colorindex = 89},
	{name = "Dew Yellow", colorindex = 91},{name = "Dark Green", colorindex = 49},
	{name = "Racing Green", colorindex = 50},{name = "Sea Green", colorindex = 51},
	{name = "Olive Green", colorindex = 52},{name = "Bright Green", colorindex = 53},
	{name = "Gasoline Green", colorindex = 54},{name = "Lime Green", colorindex = 92},
	{name = "Midnight Blue", colorindex = 141},
	{name = "Galaxy Blue", colorindex = 61},{name = "Dark Blue", colorindex = 62},
	{name = "Saxon Blue", colorindex = 63},{name = "Blue", colorindex = 64},
	{name = "Mariner Blue", colorindex = 65},{name = "Harbor Blue", colorindex = 66},
	{name = "Diamond Blue", colorindex = 67},{name = "Surf Blue", colorindex = 68},
	{name = "Nautical Blue", colorindex = 69},{name = "Racing Blue", colorindex = 73},
	{name = "Ultra Blue", colorindex = 70},{name = "Light Blue", colorindex = 74},
	{name = "Chocolate Brown", colorindex = 96},{name = "Bison Brown", colorindex = 101},
	{name = "Creeen Brown", colorindex = 95},{name = "Feltzer Brown", colorindex = 94},
	{name = "Maple Brown", colorindex = 97},{name = "Beechwood Brown", colorindex = 103},
	{name = "Sienna Brown", colorindex = 104},{name = "Saddle Brown", colorindex = 98},
	{name = "Moss Brown", colorindex = 100},{name = "Woodbeech Brown", colorindex = 102},
	{name = "Straw Brown", colorindex = 99},{name = "Sandy Brown", colorindex = 105},
	{name = "Bleached Brown", colorindex = 106},{name = "Schafter Purple", colorindex = 71},
	{name = "Spinnaker Purple", colorindex = 72},{name = "Midnight Purple", colorindex = 142},
	{name = "Bright Purple", colorindex = 145},{name = "Cream", colorindex = 107},
	{name = "Ice White", colorindex = 111},{name = "Frost White", colorindex = 112}
}
local metalcolors = {
	{name = "Brushed Steel",colorindex = 117},
	{name = "Brushed Black Steel",colorindex = 118},
	{name = "Brushed Aluminum",colorindex = 119},
	{name = "Pure Gold",colorindex = 158},
	{name = "Brushed Gold",colorindex = 159}
}
local mattecolors = {
	{name = "Black", colorindex = 12},
	{name = "Gray", colorindex = 13},
	{name = "Light Gray", colorindex = 14},
	{name = "Ice White", colorindex = 131},
	{name = "Blue", colorindex = 83},
	{name = "Dark Blue", colorindex = 82},
	{name = "Midnight Blue", colorindex = 84},
	{name = "Midnight Purple", colorindex = 149},
	{name = "Schafter Purple", colorindex = 148},
	{name = "Red", colorindex = 39},
	{name = "Dark Red", colorindex = 40},
	{name = "Orange", colorindex = 41},
	{name = "Yellow", colorindex = 42},
	{name = "Lime Green", colorindex = 55},
	{name = "Green", colorindex = 128},
	{name = "Frost Green", colorindex = 151},
	{name = "Foliage Green", colorindex = 155},
	{name = "Olive Drab", colorindex = 152},
	{name = "Dark Earth", colorindex = 153},
	{name = "Desert Tan", colorindex = 154}
}



LSC_Config = {}
LSC_Config.prices = {}

--------Prices---------
LSC_Config.prices = {

------Window tint------
	windowtint = {
		{ name = "Pure Black", tint = 1, price = 1000},
		{ name = "Dark Smoke", tint = 2, price = 1000},
		{ name = "Light Smoke", tint = 3, price = 1000},
		{ name = "Limo", tint = 4, price = 1000},
		{ name = "Green", tint = 5, price = 1000},
	},

-------Respray--------
----Primary color---
	--Chrome
	chrome = {
		colors = {
			{name = "Chrome", colorindex = 120}
		},
		price = 5000
	},
	--Classic
	classic = {
		colors = colors,
		price = 200
	},
	--Matte
	matte = {
		colors = mattecolors,
		price = 500
	},
	--Metallic
	metallic = {
		colors = colors,
		price = 300
	},
	--Metals
	metal = {
		colors = metalcolors,
		price = 300
	},

----Secondary color---
	--Chrome
	chrome2 = {
		colors = {
			{name = "Chrome", colorindex = 120}
		},
		price = 1000
	},
	--Classic
	classic2 = {
		colors = colors,
		price = 200
	},
	--Matte
	matte2 = {
		colors = mattecolors,
		price = 500
	},
	--Metallic
	metallic2 = {
		colors = colors,
		price = 300
	},
	--Metals
	metal2 = {
		colors = metalcolors,
		price = 300
	},

------Neon layout------
	neonlayout = {
		{name = "Front,Back and Sides", price = 5000},
	},
	--Neon color
	neoncolor = {
		{ name = "White", neon = {255,255,255}, price = 1000},
		{ name = "Blue", neon = {0,0,255}, price = 1000},
		{ name = "Electric Blue", neon = {0,150,255}, price = 1000},
		{ name = "Mint Green", neon = {50,255,155}, price = 1000},
		{ name = "Lime Green", neon = {0,255,0}, price = 1000},
		{ name = "Yellow", neon = {255,255,0}, price = 1000},
		{ name = "Golden Shower", neon = {204,204,0}, price = 1000},
		{ name = "Orange", neon = {255,128,0}, price = 1000},
		{ name = "Red", neon = {255,0,0}, price = 1000},
		{ name = "Pony Pink", neon = {255,102,255}, price = 1000},
		{ name = "Hot Pink",neon = {255,0,255}, price = 1000},
		{ name = "Purple", neon = {153,0,153}, price = 1000},
		{ name = "Brown", neon = {139,69,19}, price = 1000},
	},

--------Plates---------
	plates = {
		{ name = "Blue on White 1", plateindex = 0, price = 200},
		{ name = "Blue On White 2", plateindex = 3, price = 200},
		{ name = "Blue On White 3", plateindex = 4, price = 200},
		{ name = "Yellow on Blue", plateindex = 2, price = 300},
		{ name = "Yellow on Black", plateindex = 1, price = 600},
	},

--------Wheels--------
----Wheel accessories----
	wheelaccessories = {
		{ name = "Stock Tires", price = 1000},
		{ name = "Custom Tires", price = 1250},
		--{ name = "Bulletproof Tires", price = 5000},
		{ name = "White Tire Smoke",smokecolor = {254,254,254}, price = 3000},
		{ name = "Black Tire Smoke", smokecolor = {1,1,1}, price = 3000},
		{ name = "Blue Tire Smoke", smokecolor = {0,150,255}, price = 3000},
		{ name = "Yellow Tire Smoke", smokecolor = {255,255,50}, price = 3000},
		{ name = "Orange Tire Smoke", smokecolor = {255,153,51}, price = 3000},
		{ name = "Red Tire Smoke", smokecolor = {255,10,10}, price = 3000},
		{ name = "Green Tire Smoke", smokecolor = {10,255,10}, price = 3000},
		{ name = "Purple Tire Smoke", smokecolor = {153,10,153}, price = 3000},
		{ name = "Pink Tire Smoke", smokecolor = {255,102,178}, price = 3000},
		{ name = "Gray Tire Smoke",smokecolor = {128,128,128}, price = 3000},
	},

----Wheel color----
	wheelcolor = {
		colors = colors,
		price = 1000,
	},

----Front wheel (Bikes)----
	frontwheel = {
		{name = "Stock", wtype = 6, mod = -1, price = 1000},
		{name = "Speedway", wtype = 6, mod = 0, price = 1000},
		{name = "Street Special", wtype = 6, mod = 1, price = 1000},
		{name = "Racer", wtype = 6, mod = 2, price = 1000},
		{name = "TrackStar", wtype = 6, mod = 3, price = 1000},
		{name = "Overlord", wtype = 6, mod = 4, price = 1000},
		{name = "Trident", wtype = 6, mod = 5, price = 1000},
		{name = "Triple Threat", wtype = 6, mod = 6, price = 1000},
		{name = "Stilleto", wtype = 6, mod = 7, price = 1000},
		{name = "Wires", wtype = 6, mod = 8, price = 1000},
		{name = "Bobber", wtype = 6, mod = 9, price = 1000},
		{name = "Solidus", wtype = 6, mod = 10, price = 1000},
		{name = "Ice Shield", wtype = 6, mod = 11, price = 1000},
		{name = "Loops", wtype = 6, mod = 12, price = 1000},
		{name = "Speedway (Chrome)", wtype = 6, mod = 13, price = 5000},
		{name = "Street Special (Chrome)", wtype = 6, mod = 14, price = 5000},
		{name = "Racer (Chrome)", wtype = 6, mod = 15, price = 5000},
		{name = "TrackStar (Chrome)", wtype = 6, mod = 16, price = 5000},
		{name = "Overlord (Chrome)", wtype = 6, mod = 17, price = 5000},
		{name = "Trident (Chrome)", wtype = 6, mod = 18, price = 5000},
		{name = "Triple Threat (Chrome)", wtype = 6, mod = 19, price = 5000},
		{name = "Stilleto (Chrome)", wtype = 6, mod = 20, price = 5000},
		{name = "Ice Shield (Chrome)", wtype = 6, mod = 21, price = 5000},
		{name = "Loops (Chrome)", wtype = 6, mod = 22, price = 5000},
	},

----Back wheel (Bikes)-----
	backwheel = {
		{name = "Stock", wtype = 6, mod = -1, price = 1000},
		{name = "Speedway", wtype = 6, mod = 0, price = 1000},
		{name = "Street Special", wtype = 6, mod = 1, price = 1000},
		{name = "Racer", wtype = 6, mod = 2, price = 1000},
		{name = "TrackStar", wtype = 6, mod = 3, price = 1000},
		{name = "Overlord", wtype = 6, mod = 4, price = 1000},
		{name = "Trident", wtype = 6, mod = 5, price = 1000},
		{name = "Triple Threat", wtype = 6, mod = 6, price = 1000},
		{name = "Stilleto", wtype = 6, mod = 7, price = 1000},
		{name = "Wires", wtype = 6, mod = 8, price = 1000},
		{name = "Bobber", wtype = 6, mod = 9, price = 1000},
		{name = "Solidus", wtype = 6, mod = 10, price = 1000},
		{name = "Ice Shield", wtype = 6, mod = 11, price = 1000},
		{name = "Loops", wtype = 6, mod = 12, price = 1000},
		{name = "Speedway (Chrome)", wtype = 6, mod = 13, price = 5000},
		{name = "Street Special (Chrome)", wtype = 6, mod = 14, price = 5000},
		{name = "Racer (Chrome)", wtype = 6, mod = 15, price = 5000},
		{name = "TrackStar (Chrome)", wtype = 6, mod = 16, price = 5000},
		{name = "Overlord (Chrome)", wtype = 6, mod = 17, price = 5000},
		{name = "Trident (Chrome)", wtype = 6, mod = 18, price = 5000},
		{name = "Triple Threat (Chrome)", wtype = 6, mod = 19, price = 5000},
		{name = "Stilleto (Chrome)", wtype = 6, mod = 20, price = 5000},
		{name = "Ice Shield (Chrome)", wtype = 6, mod = 21, price = 5000},
		{name = "Loops (Chrome)", wtype = 6, mod = 22, price = 5000},
	},

----Sport wheels-----
	sportwheels = {
		{name = "Stock", wtype = 0, mod = -1, price = 1000},
		{name = "Inferno", wtype = 0, mod = 0, price = 1000},
		{name = "Deep Five", wtype = 0, mod = 1, price = 1000},
		{name = "LozSpeed", wtype = 0, mod = 2, price = 1000},
		{name = "Diamond Cut", wtype = 0, mod = 3, price = 1000},
		{name = "Chrono", wtype = 0, mod = 4, price = 1000},
		{name = "Ferocci RR", wtype = 0, mod = 5, price = 1000},
		{name = "FiftyNine", wtype = 0, mod = 6, price = 1000},
		{name = "Mercie", wtype = 0, mod = 7, price = 1000},
		{name = "Synthetic Z", wtype = 0, mod = 8, price = 1000},
		{name = "Organic Type D", wtype = 0, mod = 9, price = 1000},
		{name = "Endo V1", wtype = 0, mod = 10, price = 1000},
		{name = "GT One", wtype = 0, mod = 11, price = 1000},
		{name = "Duper7", wtype = 0, mod = 12, price = 1000},
		{name = "Uzer", wtype = 0, mod = 13, price = 1000},
		{name = "GroundRide", wtype = 0, mod = 14, price = 1000},
		{name = "Spacer", wtype = 0, mod = 15, price = 1000},
		{name = "Venum", wtype = 0, mod = 16, price = 1000},
		{name = "Cosmo", wtype = 0, mod = 17, price = 1000},
		{name = "Dash VIP", wtype = 0, mod = 18, price = 1000},
		{name = "IceKid", wtype = 0, mod = 19, price = 1000},
		{name = "Ruffel'd", wtype = 0, mod = 20, price = 1000},
		{name = "WangenMaster", wtype = 0, mod = 21, price = 1000},
		{name = "Super Five", wtype = 0, mod = 22, price = 1000},
		{name = "Endo V2", wtype = 0, mod = 23, price = 1000},
		{name = "Split Six", wtype = 0, mod = 24, price = 1000},
		{name = "Inferno (Chrome)", wtype = 0, mod = 25, price = 5000},
		{name = "Deep Five (Chrome)", wtype = 0, mod = 26, price = 5000},
		{name = "LozSpeed (Chrome)", wtype = 0, mod = 27, price = 5000},
		{name = "Diamond Cut (Chrome)", wtype = 0, mod = 28, price = 5000},
		{name = "Chrono (Chrome)", wtype = 0, mod = 29, price = 5000},
		{name = "Ferocci RR (Chrome)", wtype = 0, mod = 30, price = 5000},
		{name = "FiftyNine (Chrome)", wtype = 0, mod = 31, price = 5000},
		{name = "Mercie (Chrome)", wtype = 0, mod = 32, price = 5000},
		{name = "Synthetic Z (Chrome)", wtype = 0, mod = 33, price = 5000},
		{name = "Organic Type D (Chrome)", wtype = 0, mod = 34, price = 5000},
		{name = "Endo V1 (Chrome)", wtype = 0, mod = 35, price = 5000},
		{name = "GT One (Chrome)", wtype = 0, mod = 36, price = 5000},
		{name = "Duper7 (Chrome)", wtype = 0, mod = 37, price = 5000},
		{name = "Uzer (Chrome)", wtype = 0, mod = 38, price = 5000},
		{name = "GroundRide (Chrome)", wtype = 0, mod = 39, price = 5000},
		{name = "Spacer (Chrome)", wtype = 0, mod = 40, price = 5000},
		{name = "Venum (Chrome)", wtype = 0, mod = 41, price = 5000},
		{name = "Cosmo (Chrome)", wtype = 0, mod = 42, price = 5000},
		{name = "Dash VIP (Chrome)", wtype = 0, mod = 43, price = 5000},
		{name = "IceKid (Chrome)", wtype = 0, mod = 44, price = 5000},
		{name = "Ruffel'd (Chrome)", wtype = 0, mod = 45, price = 5000},
		{name = "WangenMaster (Chrome)", wtype = 0, mod = 46, price = 5000},
		{name = "Super Five (Chrome)", wtype = 0, mod = 47, price = 5000},
		{name = "Endo V2 (Chrome)", wtype = 0, mod = 48, price = 5000},
		{name = "Split Six (Chrome)", wtype = 0, mod = 49, price = 5000},

	},
-----Suv wheels------
	suvwheels = {
		{name = "Stock", wtype = 3, mod = -1, price = 1000},
		{name = "VIP", wtype = 3, mod = 0, price = 1000},
		{name = "Benefactor", wtype = 3, mod = 1, price = 1000},
		{name = "Cosmo", wtype = 3, mod = 2, price = 1000},
		{name = "Bippu", wtype = 3, mod = 3, price = 1000},
		{name = "Royal Six", wtype = 3, mod = 4, price = 1000},
		{name = "Fagorme", wtype = 3, mod = 5, price = 1000},
		{name = "Deluxe", wtype = 3, mod = 6, price = 1000},
		{name = "Iced Out", wtype = 3, mod = 7, price = 1000},
		{name = "Cognoscenti", wtype = 3, mod = 8, price = 1000},
		{name = "LozSpeed Ten", wtype = 3, mod = 9, price = 1000},
		{name = "Supernova", wtype = 3, mod = 10, price = 1000},
		{name = "Obey RS", wtype = 3, mod = 11, price = 1000},
		{name = "LozSpeed Baller", wtype = 3, mod = 12, price = 1000},
		{name = "Extra Vaganzo", wtype = 3, mod = 13, price = 1000},
		{name = "Split Six", wtype = 3, mod = 14, price = 1000},
		{name = "Empowered", wtype = 3, mod = 15, price = 1000},
		{name = "Sunrise", wtype = 3, mod = 16, price = 1000},
		{name = "Dash VIP", wtype = 3, mod = 17, price = 1000},
		{name = "Cutter", wtype = 3, mod = 18, price = 1000},
		{name = "VIP (Chrome)", wtype = 3, mod = 19, price = 5000},
		{name = "Benefactor (Chrome)", wtype = 3, mod = 20, price = 5000},
		{name = "Cosmo (Chrome)", wtype = 3, mod = 21, price = 5000},
		{name = "Bippu (Chrome)", wtype = 3, mod = 22, price = 5000},
		{name = "Royal Six (Chrome)", wtype = 3, mod = 23, price = 5000},
		{name = "Fagorme (Chrome)", wtype = 3, mod = 24, price = 5000},
		{name = "Deluxe (Chrome)", wtype = 3, mod = 25, price = 5000},
		{name = "Iced Out (Chrome)", wtype = 3, mod = 26, price = 5000},
		{name = "Cognoscenti (Chrome)", wtype = 3, mod = 27, price = 5000},
		{name = "LozSpeed Ten (Chrome)", wtype = 3, mod = 28, price = 5000},
		{name = "Supernova (Chrome)", wtype = 3, mod = 29, price = 5000},
		{name = "Obey RS (Chrome)", wtype = 3, mod = 30, price = 5000},
		{name = "LozSpeed Baller (Chrome)", wtype = 3, mod = 31, price = 5000},
		{name = "Extra Vaganzo (Chrome)", wtype = 3, mod = 32, price = 5000},
		{name = "Split Six (Chrome)", wtype = 3, mod = 33, price = 5000},
		{name = "Empowered (Chrome)", wtype = 3, mod = 34, price = 5000},
		{name = "Sunrise (Chrome)", wtype = 3, mod = 35, price = 5000},
		{name = "Dash VIP (Chrome)", wtype = 3, mod = 36, price = 5000},
		{name = "Cutter (Chrome)", wtype = 3, mod = 37, price = 5000},
	},
-----Offroad wheels-----
	offroadwheels = {
		{name = "Stock", wtype = 4, mod = -1, price = 1000},
		{name = "Raider", wtype = 4, mod = 0, price = 1000},
		{name = "MudSlinger", wtype = 4, modtype = 23, wtype = 4, mod = 1, price = 1000},
		{name = "Nevis", wtype = 4, mod = 2, price = 1000},
		{name = "Cairngorm", wtype = 4, mod = 3, price = 1000},
		{name = "Amazon", wtype = 4, mod = 4, price = 1000},
		{name = "Challenger", wtype = 4, mod = 5, price = 1000},
		{name = "DuneBasher", wtype = 4, mod = 6, price = 1000},
		{name = "FiveStar", wtype = 4, mod = 7, price = 1000},
		{name = "RockCrawler", wtype = 4, mod = 8, price = 1000},
		{name = "Mil-spec Steelie", wtype = 4, mod = 9, price = 1000},
		{name = "Raider (Chrome)", wtype = 4, mod = 10, price = 5000},
		{name = "MudSlinger (Chrome)", wtype = 4, mod = 11, price = 5000},
		{name = "Nevis (Chrome)", wtype = 4, mod = 12, price = 5000},
		{name = "Cairngorm (Chrome)", wtype = 4, mod = 13, price = 5000},
		{name = "Amazon (Chrome)", wtype = 4, mod = 14, price = 5000},
		{name = "Challenger (Chrome)", wtype = 4, mod = 15, price = 5000},
		{name = "DuneBasher (Chrome)", wtype = 4, mod = 16, price = 5000},
		{name = "FiveStar (Chrome)", wtype = 4, mod = 17, price = 5000},
		{name = "RockCrawler (Chrome)", wtype = 4, mod = 18, price = 5000},
		{name = "Mil-spec Steelie (Chrome)", wtype = 4, mod = 19, price = 5000},
	},
-----Tuner wheels------
	tunerwheels = {
		{name = "Stock", wtype = 5, mod = -1, price = 1000},
		{name = "Cosmo", wtype = 5, mod = 0, price = 1000},
		{name = "SuperMesh", wtype = 5, mod = 1, price = 1000},
		{name = "Outsider", wtype = 5, mod = 2, price = 1000},
		{name = "Rolla S", wtype = 5, mod = 3, price = 1000},
		{name = "DriftMeister", wtype = 5, mod = 4, price = 1000},
		{name = "Slicer", wtype = 5, mod = 5, price = 1000},
		{name = "El Quatro", wtype = 5, mod = 6, price = 1000},
		{name = "Dubbed", wtype = 5, mod = 7, price = 1000},
		{name = "FiveStar", wtype = 5, mod = 8, price = 1000},
		{name = "Slideways", wtype = 5, mod = 9, price = 1000},
		{name = "Apex", wtype = 5, mod = 10, price = 1000},
		{name = "Stanced EG", wtype = 5, mod = 11, price = 1000},
		{name = "CounterSteer", wtype = 5, mod = 12, price = 1000},
		{name = "Endo V1", wtype = 5, mod = 13, price = 1000},
		{name = "Endo V2 (Dish)", wtype = 5, mod = 14, price = 1000},
		{name = "Guppe Z", wtype = 5, mod = 15, price = 1000},
		{name = "Chokadori", wtype = 5, mod = 16, price = 1000},
		{name = "Chicane", wtype = 5, mod = 17, price = 1000},
		{name = "Saisoku", wtype = 5, mod = 18, price = 1000},
		{name = "Dished Eight", wtype = 5, mod = 19, price = 1000},
		{name = "Fujiwara", wtype = 5, mod = 20, price = 1000},
		{name = "Zokusha", wtype = 5, mod = 21, price = 1000},
		{name = "Battlevill", wtype = 5, mod = 22, price = 1000},
		{name = "Rally Master", wtype = 5, mod = 23, price = 1000},
		{name = "Cosmo (Chrome)", wtype = 5, mod = 24, price = 5000},
		{name = "SuperMesh (Chrome)", wtype = 5, mod = 25, price = 5000},
		{name = "Outsider (Chrome)", wtype = 5, mod = 26, price = 5000},
		{name = "Rolla S (Chrome)", wtype = 5, mod = 27, price = 5000},
		{name = "DriftMeister (Chrome)", wtype = 5, mod = 28, price = 5000},
		{name = "Slicer (Chrome)", wtype = 5, mod = 29, price = 5000},
		{name = "El Quatro (Chrome)", wtype = 5, mod = 30, price = 5000},
		{name = "Dubbed (Chrome)", wtype = 5, mod = 31, price = 5000},
		{name = "FiveStar (Chrome)", wtype = 5, mod = 32, price = 5000},
		{name = "Slideways (Chrome)", wtype = 5, mod = 33, price = 5000},
		{name = "Apex (Chrome)", wtype = 5, mod = 34, price = 5000},
		{name = "Stanced EG (Chrome)", wtype = 5, mod = 35, price = 5000},
		{name = "CounterSteer (Chrome)", wtype = 5, mod = 36, price = 5000},
		{name = "Endo V1 (Chrome)", wtype = 5, mod = 37, price = 5000},
		{name = "Endo V2 (Chrome)", wtype = 5, mod = 38, price = 5000},
		{name = "Guppe Z (Chrome)", wtype = 5, mod = 39, price = 5000},
		{name = "Chokadori (Chrome)", wtype = 5, mod = 40, price = 5000},
		{name = "Chicane (Chrome)", wtype = 5, mod = 41, price = 5000},
		{name = "Saisoku (Chrome)", wtype = 5, mod = 42, price = 5000},
		{name = "Dished Eight (Chrome)", wtype = 5, mod = 43, price = 5000},
		{name = "Fujiwara (Chrome)", wtype = 5, mod = 44, price = 5000},
		{name = "Zokusha (Chrome)", wtype = 5, mod = 45, price = 5000},
		{name = "Battlevill (Chrome)", wtype = 5, mod = 46, price = 5000},
		{name = "Rally Master (Chrome)", wtype = 5, mod = 47, price = 5000},
	},
-----Highend wheels------
	highendwheels = {
		{name = "Stock", wtype = 7, mod = -1, price = 1000},
		{name = "Shadow", wtype = 7, mod = 0, price = 1000},
		{name = "Hyper", wtype = 7, mod = 1, price = 1000},
		{name = "Blade", wtype = 7, mod = 2, price = 1000},
		{name = "Diamond", wtype = 7, mod = 3, price = 1000},
		{name = "Supa Gee", wtype = 7, mod = 4, price = 1000},
		{name = "Chromatic Z", wtype = 7, mod = 5, price = 1000},
		{name = "Mercie CH", wtype = 7, mod = 6, price = 1000},
		{name = "Obey RS", wtype = 7, mod = 7, price = 1000},
		{name = "GeeTee", wtype = 7, mod = 8, price = 1000},
		{name = "Cheetah R", wtype = 7, mod = 9, price = 1000},
		{name = "Solar", wtype = 7, mod = 10, price = 1000},
		{name = "Split Ten", wtype = 7, mod = 11, price = 1000},
		{name = "Dash VIP", wtype = 7, mod = 12, price = 1000},
		{name = "LozSpeed Ten", wtype = 7, mod = 13, price = 1000},
		{name = "Carbon Inferno", wtype = 7, mod = 14, price = 1000},
		{name = "Carbon Shadow", wtype = 7, mod = 15, price = 1000},
		{name = "Carbon Z", wtype = 7, mod = 16, price = 1000},
		{name = "Carbon Solar", wtype = 7, mod = 17, price = 1000},
		{name = "Carbon Cheetah R", wtype = 7, mod = 18, price = 1000},
		{name = "Carbon S Racer", wtype = 7, mod = 19, price = 1000},
		{name = "Shadow (Chrome)", wtype = 7, mod = 20, price = 5000},
		{name = "Hyper (Chrome)", wtype = 7, mod = 21, price = 5000},
		{name = "Blade (Chrome)", wtype = 7, mod = 22, price = 5000},
		{name = "Diamond (Chrome)", wtype = 7, mod = 23, price = 5000},
		{name = "Supa Gee (Chrome)", wtype = 7, mod = 24, price = 5000},
		{name = "Chromatic Z (Chrome)", wtype = 7, mod = 25, price = 5000},
		{name = "Mercie CH (Chrome)", wtype = 7, mod = 26, price = 5000},
		{name = "Obey RS (Chrome)", wtype = 7, mod = 27, price = 5000},
		{name = "Gee Tee (Chrome)", wtype = 7, mod = 28, price = 5000},
		{name = "Cheetah R (Chrome)", wtype = 7, mod = 29, price = 5000},
		{name = "Solar (Chrome)", wtype = 7, mod = 30, price = 5000},
		{name = "Split Ten (Chrome)", wtype = 7, mod = 31, price = 5000},
		{name = "Dash VIP (Chrome)", wtype = 7, mod = 32, price = 5000},
		{name = "LozSpeed Ten (Chrome)", wtype = 7, mod = 33, price = 5000},
		{name = "Carbon Inferno (Chrome)", wtype = 7, mod = 34, price = 5000},
		{name = "Carbon Shadow (Chrome)", wtype = 7, mod = 35, price = 5000},
		{name = "Carbon Z (Chrome)", wtype = 7, mod = 36, price = 5000},
		{name = "Carbon Solar (Chrome)", wtype = 7, mod = 37, price = 5000},
		{name = "Carbon Cheetah R (Chrome)", wtype = 7, mod = 38, price = 5000},
		{name = "Carbon S Racer (Chrome)", wtype = 7, mod = 39, price = 5000},
	},
-----Lowrider wheels------
	lowriderwheels = {
		{name = "Stock", wtype = 2, mod = -1, price = 1000},
		{name = "Flare", wtype = 2, mod = 0, price = 1000},
		{name = "Wired", wtype = 2, mod = 1, price = 1000},
		{name = "Triple Golds", wtype = 2, mod = 2, price = 1000},
		{name = "Big Worm", wtype = 2, mod = 3, price = 1000},
		{name = "SevenFive S", wtype = 2, mod = 4, price = 1000},
		{name = "Split Six", wtype = 2, mod = 5, price = 1000},
		{name = "FreshMesh", wtype = 2, mod = 6, price = 1000},
		{name = "LeadSled", wtype = 2, mod = 7, price = 1000},
		{name = "Turbine", wtype = 2, mod = 8, price = 1000},
		{name = "Super Fin", wtype = 2, mod = 9, price = 1000},
		{name = "Classic Rod", wtype = 2, mod = 10, price = 1000},
		{name = "Dollar", wtype = 2, mod = 11, price = 1000},
		{name = "Dukes", wtype = 2, mod = 12, price = 1000},
		{name = "Low Five", wtype = 2, mod = 13, price = 1000},
		{name = "Gooch", wtype = 2, mod = 14, price = 1000},
		{name = "Flare (Chrome)", wtype = 2, mod = 15, price = 5000},
		{name = "Wired (Chrome)", wtype = 2, mod = 16, price = 5000},
		{name = "Triple Golds (Chrome)", wtype = 2, mod = 17, price = 5000},
		{name = "Big Worm (Chrome)", wtype = 2, mod = 18, price = 5000},
		{name = "SevenFive S (Chrome)", wtype = 2, mod = 19, price = 5000},
		{name = "Split Six (Chrome)", wtype = 2, mod = 20, price = 5000},
		{name = "FreshMesh (Chrome)", wtype = 2, mod = 21, price = 5000},
		{name = "LeadSled (Chrome)", wtype = 2, mod = 22, price = 5000},
		{name = "Turbine (Chrome)", wtype = 2, mod = 23, price = 5000},
		{name = "Super Fin (Chrome)", wtype = 2, mod = 24, price = 5000},
		{name = "Classic Rod (Chrome)", wtype = 2, mod = 25, price = 5000},
		{name = "Dollar (Chrome)", wtype = 2, mod = 26, price = 5000},
		{name = "Dukes (Chrome)", wtype = 2, mod = 27, price = 5000},
		{name = "Low Five (Chrome)", wtype = 2, mod = 28, price = 5000},
		{name = "Gooch (Chrome)", wtype = 2, mod = 29, price = 5000},
	},
-----Muscle wheels-----
	musclewheels = {
		{name = "Stock", wtype = 1, mod = -1, price = 1000},
		{name = "Classic Five", wtype = 1, mod = 0, price = 1000},
		{name = "Dukes", wtype = 1, mod = 1, price = 1000},
		{name = "Muscle Freak", wtype = 1, mod = 2, price = 1000},
		{name = "Kracka", wtype = 1, mod = 3, price = 1000},
		{name = "Azrea", wtype = 1, mod = 4, price = 1000},
		{name = "Mecha", wtype = 1, mod = 5, price = 1000},
		{name = "Blacktop", wtype = 1, mod = 6, price = 1000},
		{name = "Drag SPl", wtype = 1, mod = 7, price = 1000},
		{name = "Revolver", wtype = 1, mod = 8, price = 1000},
		{name = "Classic Rod", wtype = 1, mod = 9, price = 1000},
		{name = "Fairlie", wtype = 1, mod = 10, price = 1000},
		{name = "Spooner", wtype = 1, mod = 11, price = 1000},
		{name = "FiveStar", wtype = 1, mod = 12, price = 1000},
		{name = "Old School", wtype = 1, mod = 13, price = 1000},
		{name = "El Jefe", wtype = 1, mod = 14, price = 1000},
		{name = "Dodman", wtype = 1, mod = 15, price = 1000},
		{name = "Six Gun", wtype = 1, mod = 16, price = 1000},
		{name = "Mercenary", wtype = 1, mod = 17, price = 1000},
		{name = "Classic Five (Chrome)", wtype = 1, mod = 18, price = 5000},
		{name = "Dukes (Chrome)", wtype = 1, mod = 19, price = 5000},
		{name = "Muscle Freak (Chrome)", wtype = 1, mod = 20, price = 5000},
		{name = "Kracka (Chrome)", wtype = 1, mod = 21, price = 5000},
		{name = "Azrea (Chrome)", wtype = 1, mod = 22, price = 5000},
		{name = "Mecha (Chrome)", wtype = 1, mod = 23, price = 5000},
		{name = "Blacktop (Chrome)", wtype = 1, mod = 24, price = 5000},
		{name = "Drag SPl (Chrome)", wtype = 1, mod = 25, price = 5000},
		{name = "Revolver (Chrome)", wtype = 1, mod = 26, price = 5000},
		{name = "Classic Rod (Chrome)", wtype = 1, mod = 27, price = 5000},
		{name = "Fairlie (Chrome)", wtype = 1, mod = 28, price = 5000},
		{name = "Spooner (Chrome)", wtype = 1, mod = 29, price = 5000},
		{name = "FiveStar (Chrome)", wtype = 1, mod = 30, price = 5000},
		{name = "Old School (Chrome)", wtype = 1, mod = 31, price = 5000},
		{name = "El Jefe (Chrome)", wtype = 1, mod = 32, price = 5000},
		{name = "Dodman (Chrome)", wtype = 1, mod = 33, price = 5000},
		{name = "Six Gun (Chrome)", wtype = 1, mod = 34, price = 5000},
		{name = "Mercenary (Chrome)", wtype = 1, mod = 35, price = 5000},

	},

---------Trim color--------
	trim = {
		colors = colors,
		price = 1000
	},

----------Mods-----------
	mods = {

----------Liveries--------
	[48] = {
		startprice = 15000,
		increaseby = 2500
	},

----------Windows--------
	[46] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Tank--------
	[45] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Trim--------
	[44] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Aerials--------
	[43] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Arch cover--------
	[42] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Struts--------
	[41] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Air filter--------
	[40] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Engine block--------
	[39] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Hydraulics--------
	[38] = {
		startprice = 15000,
		increaseby = 2500
	},

----------Trunk--------
	[37] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Speakers--------
	[36] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Plaques--------
	[35] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Shift leavers--------
	[34] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Steeringwheel--------
	[33] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Seats--------
	[32] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Door speaker--------
	[31] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Dial--------
	[30] = {
		startprice = 5000,
		increaseby = 1250
	},
----------Dashboard--------
	[29] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Ornaments--------
	[28] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Trim--------
	[27] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Vanity plates--------
	[26] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Plate holder--------
	[25] = {
		startprice = 5000,
		increaseby = 1250
	},

---------Headlights---------
	[22] = {
		{name = "Stock Lights", mod = 0, price = 0},
		{name = "Xenon Lights", mod = 1, price = 1625},
	},

----------Turbo---------
	[18] = {
		{ name = "None", mod = 0, price = 0},
		{ name = "Turbo Tuning", mod = 1, price = 15000},
	},

-----------Armor-------------
	[16] = {
		{name = "Armor Upgrade 20%",modtype = 16, mod = 0, price = 2500},
		{name = "Armor Upgrade 40%",modtype = 16, mod = 1, price = 5000},
		{name = "Armor Upgrade 60%",modtype = 16, mod = 2, price = 7500},
		{name = "Armor Upgrade 80%",modtype = 16, mod = 3, price = 10000},
		{name = "Armor Upgrade 100%",modtype = 16, mod = 4, price = 12500},
	},

---------Suspension-----------
	[15] = {
		{name = "Lowered Suspension",mod = 0, price = 1000},
		{name = "Street Suspension",mod = 1, price = 2000},
		{name = "Sport Suspension",mod = 2, price = 3500},
		{name = "Competition Suspension",mod = 3, price = 4000},
	},

-----------Horn----------
	[14] = {
		{name = "Truck Horn", mod = 0, price = 1625},
		--{name = "Police Horn", mod = 1, price = 4062},
		{name = "Clown Horn", mod = 2, price = 6500},
		{name = "Musical Horn 1", mod = 3, price = 11375},
		{name = "Musical Horn 2", mod = 4, price = 11375},
		{name = "Musical Horn 3", mod = 5, price = 11375},
		{name = "Musical Horn 4", mod = 6, price = 11375},
		{name = "Musical Horn 5", mod = 7, price = 11375},
		{name = "Sad Trombone Horn", mod = 8, price = 11375},
		{name = "Classical Horn 1", mod = 9, price = 11375},
		{name = "Classical Horn 2", mod = 10, price = 11375},
		{name = "Classical Horn 3", mod = 11, price = 11375},
		{name = "Classical Horn 4", mod = 12, price = 11375},
		{name = "Classical Horn 5", mod = 13, price = 11375},
		{name = "Classical Horn 6", mod = 14, price = 11375},
		{name = "Classical Horn 7", mod = 15, price = 11375},
		{name = "Scale Do Horn", mod = 16, price = 11375},
		{name = "Scale Re Horn", mod = 17, price = 11375},
		{name = "Scale Mi Horn", mod = 18, price = 11375},
		{name = "Scale Fa Horn", mod = 19, price = 11375},
		{name = "Scale So Horn", mod = 20, price = 11375},
		{name = "Scale La Horn", mod = 21, price = 11375},
		{name = "Scale Ti Horn", mod = 22, price = 11375},
		{name = "Scale Do(high) Horn", mod = 23, price = 11375},
		{name = "Jazz Horn 1", mod = 25, price = 11375},
		{name = "Jazz Horn 2", mod = 26, price = 11375},
		{name = "Jazz Horn 3", mod = 27, price = 11375},
		{name = "Star Spangled Banner 1", mod = 28, price = 11375},
		{name = "Star Spangled Banner 2", mod = 29, price = 11375},
		{name = "Star Spangled Banner 3", mod = 30, price = 11375},
		{name = "Star Spangled Banner 4", mod = 31, price = 11375},
		{name = "Classical Loop 1", mod = 32, price = 11375},
		{name = "Classical Loop 2", mod = 33, price = 11375},
		{name = "Classical Loop 3", mod = 34, price = 11375},
		{name = "Classical Loop 4", mod = 35, price = 11375},
	},

----------Transmission---------
	[13] = {
		{name = "Street Transmission", mod = 0, price = 10000},
		{name = "Sports Transmission", mod = 1, price = 12500},
		{name = "Race Transmission", mod = 2, price = 15000},
	},

-----------Brakes-------------
	[12] = {
		{name = "Street Brakes", mod = 0, price = 6500},
		{name = "Sport Brakes", mod = 1, price = 8775},
		{name = "Race Brakes", mod = 2, price = 11375},
	},

------------Engine----------
	[11] = {
		{name = "EMS Upgrade, Level 2", mod = 0, price = 4500},
		{name = "EMS Upgrade, Level 3", mod = 1, price = 8000},
		{name = "EMS Upgrade, Level 4", mod = 2, price = 10500},
	},

-------------Roof----------
	[10] = {
		startprice = 1250,
		increaseby = 400
	},

------------Fenders---------
	[8] = {
		startprice = 1500,
		increaseby = 400
	},

------------Hood----------
	[7] = {
		startprice = 1500,
		increaseby = 400
	},

----------Grille----------
	[6] = {
		startprice = 1250,
		increaseby = 400
	},

----------Roll cage----------
	[5] = {
		startprice = 1250,
		increaseby = 400
	},

----------Exhaust----------
	[4] = {
		startprice = 1000,
		increaseby = 400
	},

----------Skirts----------
	[3] = {
		startprice = 1250,
		increaseby = 400
	},

-----------Rear bumpers----------
	[2] = {
		startprice = 2500,
		increaseby = 500
	},

----------Front bumpers----------
	[1] = {
		startprice = 2500,
		increaseby = 500
	},

----------Spoiler----------
	[0] = {
		startprice = 2500,
		increaseby = 400
	},
	}

}

------Model Blacklist--------
--Does'nt allow specific vehicles to be upgraded
LSC_Config.ModelBlacklist = {
	--"police",
}

--Sets if garage will be locked if someone is inside it already
LSC_Config.lock = false

--Enable/disable old entering way
LSC_Config.oldenter = true

--Menu settings
LSC_Config.menu = {

-------Controls--------
	controls = {
		menu_up = 27,
		menu_down = 173,
		menu_left = 174,
		menu_right = 175,
		menu_select = 201,
		menu_back = 177
	},

-------Menu position-----
	--Possible positions:
	--Left
	--Right
	--Custom position, example: position = {x = 0.2, y = 0.2}
	position = "left",

-------Menu theme--------
	--Possible themes: light, darkred, bluish, greenish
	--Custom example:
	--[[theme = {
		text_color = { r = 255,g = 255, b = 255, a = 255},
		bg_color = { r = 0,g = 0, b = 0, a = 155},
		--Colors when button is selected
		stext_color = { r = 0,g = 0, b = 0, a = 255},
		sbg_color = { r = 255,g = 255, b = 0, a = 200},
	},]]
	theme = "light",

--------Max buttons------
	--Default: 10
	maxbuttons = 10,

-------Size---------
	--[[
	Default:
	width = 0.24
	height = 0.36
	]]
	width = 0.24,
	height = 0.36

}
