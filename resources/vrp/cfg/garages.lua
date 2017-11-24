local cfg = {}
-- define garage types with their associated vehicles
-- (vehicle list: https://wiki.fivem.net/wiki/Vehicles)

-- each garage type is an associated list of veh_name/veh_definition
-- they need a _config property to define the blip and the vehicle type for the garage (each vtype allow one vehicle to be spawned at a time, the default vtype is "default")
-- this is used to let the player spawn a boat AND a car at the same time for example, and only despawn it in the correct garage
-- _config: vtype, blipid, blipcolor, permission (optional, only users with the permission will have access to the shop)

cfg.rent_factor = 0.1 -- 10% of the original price if a rent
cfg.sell_factor = 0.75 -- sell for 75% of the original price
cfg.garage_types = {
	["planes"] = {
		_config = {vtype="air",blipid=16,blipcolor=4},
		["cuban800"] = {"Cuban 800", 1042500, "Seats 2"},
		["dodo"] = {"Dodo", 2550000, "Seats 4"},
		["duster"] = {"Duster", 1010500, "Seats 2"},
		["luxor"] = {"Luxor", 5500000, "Seats 10"},
		["mammatus"] = {"Mammatus", 1625000, "Seats 4"},
		["nimbus"] = {"Nimbus", 4500000, "Seats 8"},
		["shamal"] = {"Shamal", 4750000, "Seats 10"},
		["velum2"] = {"Velum2", 1825000, "Seats 5"}
	},
	["helicopters"] = {
		_config = {vtype="air",blipid=16,blipcolor=4},
		--helicopters
		["buzzard2"] = {"Buzzard", 1200000, "Seats 4"},
		["frogger"] = {"Frogger", 1400000, "Seats 4"},
		["maverick"] = {"Maverick", 1600000, "Seats 4"},
		["supervolito"] = {"Supervolito", 2005000, "Seats 4"},
		["swift"] = {"Swift", 2400000, "Seats 4"},
		["volatus"] = {"Volatus", 3015000, "Seats 4"}
	},
	["boats"] = {
		_config = {vtype="boat",blipid=50,blipcolor=4},
		["submersible"] = {"Submersible", 80000, ""},
		["submersible2"] = {"Kraken", 90000, ""},
		["dinghy2"] = {"Dinghy", 20000, ""},
		["jetmax"] = {"Jetmax", 50000, ""},
		["marquis"] = {"Marquis", 70000, ""},
		["seashark"] = {"Seashark", 8000, ""},
		["squalo"] = {"Squalo", 30000, ""},
		["suntrap"] = {"Suntrap", 35000, ""},
		["tropic"] = {"Tropic", 45000, ""},
		["toro"] = {"Toro", 55000, ""},
		["tug"] = {"Tug", 250000, ""}
	},
	["job"] = {
		_config = {vtype="car",blipid=50,blipcolor=4},
		["mule"] = {"Mule", 90000, ""},
		["hauler"] = {"Hauler", 120000, "Used for the Trucking job"},
		["packer"] = {"Packer", 120000, "Used for the Trucking job"},
		["phantom"] = {"Phantom", 120000, "Used for the Trucking job"}
	},

	["compacts"]  = {
		_config = {vtype="car",blipid=50,blipcolor=4},
		    ["panto"] = {"Panto", 500, "Trunk Capacity: 40 kg"},
		    ["blista"] = {"Blista", 15000, "Trunk Capacity: 40 kg"},
		    ["issi2"] = {"Issi", 18000, "Trunk Capacity: 40 kg"},
		    ["prairie"] = {"Prairie", 25000, "Trunk Capacity: 40 kg"},
		    ["rhapsody"] = {"Rhapsody", 30000, "Trunk Capacity: 40 kg"},
		    ["brioso"] = {"Brioso R/A", 155000, "Trunk Capacity: 40 kg"}
  	},

	["coupe"] = {
		_config = {vtype="car",blipid=50,blipcolor=4},
		["oracle"] = {"Oracle", 40000, "Trunk Capacity: 40 kg"},
		["jackal"] = {"Jackal", 50000, "Trunk Capacity: 40 kg"},
		["zion"] = {"Zion", 60000, "Trunk Capacity: 40 kg"},
		["oracle2"] = {"Oracle XS",65000, "Trunk Capacity: 40 kg"},
		["zion2"] = {"Zion Cabrio", 75000, "Trunk Capacity: 40 kg"},
		["F620"] = {"F620", 80000, "Trunk Capacity: 40 kg"},
		["felon"] = {"Felon", 90000, "Trunk Capacity: 40 kg"},
		["felon2"] = {"Felon GT", 95000, "Trunk Capacity: 40 kg"},
		["sentinel"] = {"Sentinel XS", 100000, "Trunk Capacity: 40 kg"},
		["sentinel2"] = {"Sentinel", 90000, "Trunk Capacity: 40 kg"},
		["exemplar"] = {"Exemplar", 120000, "Trunk Capacity: 40 kg"},
		["cogcabrio"] = {"Cognoscenti Cabrio",180000, "Trunk Capacity: 40 kg"},
		["windsor"] = {"Windsor",800000, "Trunk Capacity: 40 kg"},
		["windsor2"] = {"Windsor Drop",850000, "Trunk Capacity: 40 kg"}
	},

	["sports"] = {
		_config = {vtype="car",blipid=50,blipcolor=4},
		["sultan"] = {"Sultan",8000, "Trunk Capacity: 40 kg"},
		["schafter3"] = {"Schafter V12",18000, "Trunk Capacity: 40 kg"},
		["buffalo"] = {"Buffalo",35000, "Trunk Capacity: 40 kg"},
		["fusilade"] = {"Fusilade",46000, "Trunk Capacity: 40 kg"},
		["ninef"] = {"9F",50000, "Trunk Capacity: 40 kg"},
		["buffalo2"] = {"Buffalo S",55000, "Trunk Capacity: 40 kg"},
		["penumbra"] = {"Penumbra",64000, "Trunk Capacity: 40 kg"},
		["rapidgt"] = {"Rapid GT",70000, "Trunk Capacity: 40 kg"},
		["ninef2"] = {"9F Cabrio",85000, "Trunk Capacity: 40 kg"},
		["surano"] = {"Surano",110000, "Trunk Capacity: 40 kg"},
		["rapidgt2"] = {"Rapid GT Convertible",110000, "Trunk Capacity: 40 kg"},
		["feltzer2"] = {"Feltzer",130000, "Trunk Capacity: 40 kg"},
		["alpha"] = {"Alpha",130000, "Trunk Capacity: 40 kg"},
		["banshee"] = {"Banshee",155000, "Trunk Capacity: 40 kg"},
		["kuruma"] = {"Kuruma",155000, "Trunk Capacity: 40 kg"},
		["carbonizzare"] = {"Carbonizzare",195000, "Trunk Capacity: 40 kg"},
		["coquette"] = {"Coquette",238000, "Trunk Capacity: 40 kg"},
		["comet2"] = {"Comet",310000, "Trunk Capacity: 40 kg"},
		["omnis"] = {"Omnis",330000, "Trunk Capacity: 40 kg"},
		["massacro"] = {"Massacro",375000, "Trunk Capacity: 40 kg"},
		["massacro2"] = {"Massacro (Racecar)",385000, "Trunk Capacity: 40 kg"},
		["furoregt"] = {"Furore GT",428000, "Trunk Capacity: 40 kg"},
		["bestiagts"] = {"Bestia GTS",430000, "Trunk Capacity: 40 kg"},
		["jester"] = {"Jester",440000, "Trunk Capacity: 40 kg"},
		["tampa2"] = {"Drift Tampa",465000, "Trunk Capacity: 40 kg"},
		["lynx"] = {"Lynx",520000, "Trunk Capacity: 40 kg"},
		["jester2"] = {"Jester (Racecar)",550000, "Trunk Capacity: 40 kg"},
		["tropos"] = {"Tropos",816000, "Trunk Capacity: 40 kg"},
		["verlierer2"] = {"Verlierer",1595000,"Trunk Capacity: 40 kg"}
	},

	["sportsclassics"] = {
		_config = {vtype="car",blipid=50,blipcolor=5},
		["pigalle"] = {"Pigalle",200000, "Trunk Capacity: 40 kg"},
		["stinger"] = {"Stinger",250000, "Trunk Capacity: 40 kg"},
		["casco"] = {"Casco",380000, "Trunk Capacity: 40 kg"},
		["coquette2"] = {"Coquette Classic",425000, "Trunk Capacity: 40 kg"},
		["stingergt"] = {"Stinger GT",475000, "Trunk Capacity: 40 kg"},
		["feltzer3"] = {"Stirling",575000, "Trunk Capacity: 40 kg"},
		["jb700"] = {"JB 700",1500000, "Trunk Capacity: 40 kg"},
		["ztype"] = {"Z-Type",1950000,"Trunk Capacity: 40 kg"}
	},

	["supercars"] = {
		_config = {vtype="car",blipid=50,blipcolor=5},
		["adder"] = {"Adder",1000000, ""},
		["banshee2"] = {"Banshee 900R",565000, ""},
		["bullet"] = {"Bullet",155000, ""},
		["cheetah"] = {"Cheetah",650000, ""},
		["entityxf"] = {"Entity XF",795000, ""},
		["sheava"] = {"ETR1",199500, ""},
		["fmj"] = {"FMJ",1750000, ""},
		["infernus"] = {"Infernus",440000, ""},
		["osiris"] = {"Osiris",1950000, ""},
		["le7b"] = {"RE-7B",5075000, ""},
		["reaper"] = {"Reaper",1595000, ""},
		["sultanrs"] = {"Sultan RS",795000, ""},
		["t20"] = {"T20",2200000,""},
		["turismor"] = {"Turismo R",500000, ""},
		["tyrus"] = {"Tyrus",2550000, ""},
		["vacca"] = {"Vacca",240000, ""},
		["voltic"] = {"Voltic",150000, ""},
		["prototipo"] = {"X80 Proto",2700000, ""},
		["zentorno"] = {"Zentorno",725000,""}
	},

	["musclecars"] = {
		_config = {vtype="car",blipid=50,blipcolor=4},
		["picador"] = {"Picador",9000, "Trunk Capacity: 40 kg"},
		["sabregt"] = {"Sabre Turbo",15000, "Trunk Capacity: 40 kg"},
		["vigero"] = {"Vigero",21000, "Trunk Capacity: 40 kg"},
		["buccaneer"] = {"Buccaneer",29000, "Trunk Capacity: 40 kg"},
		["faction"] = {"Faction",36000, "Trunk Capacity: 40 kg"},
		["Chino"] = {"Chino",45000, "Trunk Capacity: 40 kg"},
		["blade"] = {"Blade",48000, "Trunk Capacity: 40 kg"},
		["dukes"] = {"Dukes",62000, "Trunk Capacity: 40 kg"},
		["tampa"] = {"Tampa",75000, "Trunk Capacity: 40 kg"},
		["hotknife"] = {"Hotknife",90000, "Trunk Capacity: 40 kg"},
		["dominator"] = {"Dominator",105000, "Trunk Capacity: 40 kg"},
		["gauntlet"] = {"Gauntlet",120000, "Trunk Capacity: 40 kg"},
		["virgo"] = {"Virgo",195000, "Trunk Capacity: 40 kg"},
		["nightshade"] = {"Nightshade",485000, "Trunk Capacity: 40 kg"},
		["coquette3"] = {"Coquette BlackFin",695000, "Trunk Capacity: 40 kg"}
	},

	["off-road"] = {
		_config = {vtype="car",blipid=50,blipcolor=4},
		["blazer"] = {"Blazer",8000, "Trunk Capacity: 40 kg"},
		["bifta"] = {"Bifta",55000, "Trunk Capacity: 40 kg"},
		["dune"] = {"Dune Buggy",70000, "Trunk Capacity: 40 kg"},
		["rebel2"] = {"Rebel",92000, "Trunk Capacity: 40 kg"},
		["sandking"] = {"Sandking",188000, "Trunk Capacity: 40 kg"},
		["dubsta3"] = {"Dubsta 6x6",249000, "Trunk Capacity: 40 kg"},
		--["monster"] = {"The Liberator",550000, ""},
		["brawler"] = {"Brawler",1515000, "Trunk Capacity: 40 kg"},
		["trophytruck"] = {"Trophy Truck",2550000, "Trunk Capacity: 40 kg"}
	},

	["suvs"]  = {
		_config = {vtype="car",blipid=50,blipcolor=4},
		["seminole"] = {"Seminole",30000, "Trunk Capacity: 70 kg"},
		["radi"] = {"Radius",42000, "Trunk Capacity: 70 kg"},
		["landstalker"] = {"Landstalker",78000, "Trunk Capacity: 70 kg"},
		["cavalcade"] = {"Cavalcade",80000, "Trunk Capacity: 70 kg"},
		["rocoto"] = {"Rocoto",85000, "Trunk Capacity: 70 kg"},
		["baller"] = {"Baller",90000, "Trunk Capacity: 70 kg"},
		["granger"] = {"Granger",105000, "Trunk Capacity: 70 kg"},
		["xls"] = {"XLS",253000, "Trunk Capacity: 70 kg"},
		["huntley"] = {"Huntley",395000, "Trunk Capacity: 70 kg"}
	},

	["vans"] = {
		_config = {vtype="car",blipid=50,blipcolor=4},
		["youga"] = {"Youga",32000, "Trunk Capacity: 100 kg"},
		["surfer"] = {"Surfer",19000, "Trunk Capacity: 100 kg"},
		["bison"] = {"Bison",70000, "Trunk Capacity: 100 kg"},
		["minivan"] = {"Minivan",55000, "Trunk Capacity: 100 kg"},
		["bobcatxl"] = {"Bobcat XL",75000, "Trunk Capacity: 100 kg"},
		["paradise"] = {"Paradise",77000, "Trunk Capacity: 100 kg"},
		["rumpo"] = {"Rumpo",53000, "Trunk Capacity: 100 kg"},
		["journey"] = {"Journey - Meth Job",65000, "Trunk Capacity: 100 kg"},
		["gburrito"] = {"Gang Burrito",85000, "Trunk Capacity: 100 kg"}
	},

	["sedans"] = {
		_config = {vtype="car",blipid=50,blipcolor=4},
		["premier"] = {"Premier",300, "Trunk Capacity: 40 kg"},
		["ingot"] = {"Ingot",400, "Trunk Capacity: 40 kg"},
		["regina"] = {"Regina",8000, "Trunk Capacity: 40 kg"},
		["primo"] = {"Primo",9000, "Trunk Capacity: 40 kg"},
		["asea"] = {"Asea",5000, "Trunk Capacity: 40 kg"},
		["stanier"] = {"Stanier",10000, "Trunk Capacity: 40 kg"},
		["stratum"] = {"Stratum",10000, "Trunk Capacity: 40 kg"},
		["washington"] = {"Washington",15000, "Trunk Capacity: 40 kg"},
		["primo2"] = {"Primo Custom",18000, "Trunk Capacity: 40 kg"},
		["asterope"] = {"Asterope",20000, "Trunk Capacity: 40 kg"},
		["intruder"] = {"Intruder",25000, "Trunk Capacity: 40 kg"},
		["fugitive"] = {"Fugitive",44000, "Trunk Capacity: 40 kg"},
		["tailgater"] = {"Tailgater",55000, "Trunk Capacity: 40 kg"},
		["glendale"] = {"Glendale",60000, "Trunk Capacity: 40 kg"},
		["schafter2"] = {"Schafter",65000, "Trunk Capacity: 40 kg"},
		["surge"] = {"Surge",78000, "Trunk Capacity: 40 kg"},
		["warrener"] = {"Warrener",120000, "Trunk Capacity: 40 kg"},
		["stretch"] = {"Stretch",230000, "Trunk Capacity: 40 kg"},
		["superd"] = {"Super Diamond",350000, "Trunk Capacity: 40 kg"},
		["cognoscenti"] = {"Cognoscenti",1600000, "Trunk Capacity: 40 kg"}
	},

	["motorcycles"] = {
		_config = {vtype="bike",blipid=226,blipcolor=4},
		["faggio2"] = {"Faggio",4000, "Trunk Capacity: 25 kg"},
		["pcj"] = {"PCJ-600",9000, "Trunk Capacity: 25 kg"},
		["ruffian"] = {"Ruffian",15000, "Trunk Capacity: 25 kg"},
		["sanchez"] = {"Sanchez",23000, "Trunk Capacity: 25 kg"},
		["daemon"] = {"Daemon",25000, "Trunk Capacity: 25 kg"},
		["enduro"] = {"Enduro",28000, "Trunk Capacity: 25 kg"},
		["AKUMA"] = {"Akuma",29000, "Trunk Capacity: 25 kg"},
		["bagger"] = {"Bagger",35000, "Trunk Capacity: 25 kg"},
		["vader"] = {"Vader",49000, "Trunk Capacity: 25 kg"},
		["carbonrs"] = {"Carbon RS",52000, "Trunk Capacity: 25 kg"},
		["nemesis"] = {"Nemesis",72000, "Trunk Capacity: 25 kg"},
		["hexer"] = {"Hexer",80000, "Trunk Capacity: 25 kg"},
		["sovereign"] = {"Sovereign",90000, "Trunk Capacity: 25 kg"},
		["bati"] = {"Bati 801",185000, "Trunk Capacity: 25 kg"},
		["bf400"] = {"BF400",195000, "Trunk Capacity: 25 kg"},
		["vindicator"] = {"Vindicator",210000,"Trunk Capacity: 25 kg"},
		["bati2"] = {"Bati 801RR",250000, "Trunk Capacity: 25 kg"},
		["cliffhanger"] = {"Cliffhanger",275000, "Trunk Capacity: 25 kg"},
		["innovation"] = {"Innovation",290000, "Trunk Capacity: 25 kg"},
		["lectro"] = {"Lectro",310000, "Trunk Capacity: 25 kg"},
		["thrust"] = {"Thrust",335000, "Trunk Capacity: 25 kg"},
		["gargoyle"] = {"Gargoyle",360000, "Trunk Capacity: 25 kg"},
		["hakuchou"] = {"Hakuchou",382000, "Trunk Capacity: 25 kg"},
		["double"] = {"Double T",412000, "Trunk Capacity: 25 kg"}
	},

	["taxi"] = {
		_config = {vtype="car", blipid=56, blipcolor=5, permission = "taxi.vehicle"},
		["taxi"] = {"Taxi - Taxi Job",30000,""}
	},

	["police"] = {
		_config = {vtype="car", blipid=0, blipcolor=38, permission = "police.vehicle"},
		["cvpi"] = {"CVPI",100,""},
	    ["charger"] = {"Police Charger 2015",2000,""},
	    ["fpis"] = {"Police Interceptor",5000,""},
	    ["uccvpi"] = {"Corporal UC Crown Vic",8000,""},
	    ["tahoe"] = {"Tahoe Slicktop",15000,""},
	    ["policeb"] = {"Corporal Motorcycle",8000,""},
	    ["policet"] = {"Police Van",2000,""},
	    ["explorer"] ={"Police Explorer 2013",15000,""},
	    ["explorer2"] ={"Police Explorer 2016",15000,""},
	    ["fbicharger"] = {"Captain Charger",50000,""},
	    ["fbitahoe"] = {"SGT UC SUV",50000,""}
	},

	["emergency"] = {
		_config = {vtype="car",blipid=0,blipcolor=3,permission="emergency.vehicle"},
		["ambulance"] = {"Ambulance",100,""},
    	["firetruk"] = {"Firetruck",100,""},
    	["firesuv"] = {"EMS SUV",15000,""},
	},

	["bicycles"] = {
		_config = {vtype="bike",blipid=376,blipcolor=4},
		["cruiser"] = {"Cruiser (Free)", 0, ""},
	    ["tribike"] = {"Tribike", 250, ""},
	    ["tribike2"] = {"Tribike", 250, ""},
	    ["tribike3"] = {"Tribike", 250, ""},
	    ["BMX"] = {"BMX", 250, ""},
	    ["fixter"] = {"Fixter", 250, ""},
	    ["scorcher"] = {"Scorcher", 250, ""}
	}
}

-- {garage_type,x,y,z}
cfg.garages = {
	-- {"compacts",-371.413940429688,-109.966941833496,38.6809768676758},
	-- {"coupe",699.799865722656,-1107.65551757813,22.471040725708},
	-- {"sports",233.69268798828, -788.97814941406, 30.605836868286},
	-- {"sportsclassics",1205.17858886719,2639.01123046875,37.8154525756836},
	-- --{"supercars",112.838088989258,6603.64306640625,31.9413013458252},
	-- {"motorcycles",-180.176086425781,-1286.54211425781,31.2959651947021},
	-- {"taxi",-286.870056152344,-917.948181152344,31.080623626709},
	-- {"police",454.4,-1017.6,28.4},
	-- {"emergency",-492.08544921875,-336.749206542969,34.3731842041016},
	-- {"bicycles",-352.038482666016,-109.240043640137,38.6970825195313},
	-- {"police",1871.0380859375,3692.90258789063,33.5941047668457},
	-- {"police",-1119.01953125,-858.455627441406,13.5303745269775},
	-- {"emergency",1842.67443847656,3666.43383789063,33.7249450683594},
	-- {"bicycles",-775.406677246094,5590.533203125,33.4857215881348}
	--{"boats",-849.501281738281,-1367.69567871094,1.60516905784607},
	--{"boats",1299.11730957031,4215.66162109375,33.9086799621582},
	--{"boats",3867.17578125,4464.54248046875,2.72485375404358},
	--{"planes",1640, 3236, 40.4},
	--{"planes",2123, 4805, 41.19},
	--{"planes",-1348, -2230, 13.9},
	--{"helicopter",1750, 3260, 41.37},
	--{"helicopter",-1233, -2269, 13.9},
	--{"helicopter",-745, -1468, 5},
	--{"container",-978.674682617188,-2994.29028320313,13.945068359375},
	--{"transport",-962.553039550781,-2965.82470703125,13.9450702667236}
}

return cfg
