
cfg = {}
-- define garage types with their associated vehicles
-- (vehicle list: https://wiki.fivem.net/wiki/Vehicles)

-- each garage type is an associated list of veh_name/veh_definition
-- they need a _config property to define the blip and the vehicle type for the garage (each vtype allow one vehicle to be spawned at a time, the default vtype is "default")
-- this is used to let the player spawn a boat AND a car at the same time for example, and only despawn it in the correct garage
-- _config: vtype, blipid, blipcolor, permission (optional, only users with the permission will have access to the shop)

cfg.garage_types = {
	["job"] = {
		["mule"] = {"Mule", 90000, "Trunk Capacity: 180 kg"}
	},

	["compacts"]  = {
		["panto"] = {"Panto", 500, "Trunk Capacity: 40 kg"},
		["dilettante"] = {"Dilettante", 2500, "Trunk Capacity: 40 kg"},
		["blista"] = {"Blista", 15000, "Trunk Capacity: 40 kg"},
		["issi2"] = {"Issi", 18000, "Trunk Capacity: 40 kg"},
		["prairie"] = {"Prairie", 25000, "Trunk Capacity: 40 kg"},
		["rhapsody"] = {"Rhapsody", 30000, "Trunk Capacity: 40 kg"},
		["brioso"] = {"Brioso R/A", 155000, "Trunk Capacity: 40 kg"}
	},

	["coupe"] = {
		["oracle"] = {"Oracle", 40000, "Trunk Capacity: 40 kg"},
		["jackal"] = {"Jackal", 50000, "Trunk Capacity: 40 kg"},
		["zion"] = {"Zion", 60000, "Trunk Capacity: 40 kg"},
		["oracle2"] = {"Oracle XS",65000, "Trunk Capacity: 40 kg"},
		["zion2"] = {"Zion Cabrio", 75000, "Trunk Capacity: 40 kg"},
		["F620"] = {"F620", 80000, "Trunk Capacity: 40 kg"},
		["felon"] = {"Felon", 90000, "Trunk Capacity: 40 kg"},
		["felon2"] = {"Felon GT", 95000, "Trunk Capacity: 40 kg"},
		["sentinel"] = {"Sentinel", 90000, "Trunk Capacity: 40 kg"},
		["sentinel2"] = {"Sentinel XS", 100000, "Trunk Capacity: 40 kg"},
		["exemplar"] = {"Exemplar", 120000, "Trunk Capacity: 40 kg"},
		["cogcabrio"] = {"Cognoscenti Cabrio",180000, "Trunk Capacity: 40 kg"},
		["windsor"] = {"Windsor",800000, "Trunk Capacity: 40 kg"},
		["windsor2"] = {"Windsor Drop",850000, "Trunk Capacity: 40 kg"}
	},

	["sports"] = {
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
		["pigalle"] = {"Pigalle",200000, "Trunk Capacity: 40 kg"},
		["stinger"] = {"Stinger",250000, "Trunk Capacity: 40 kg"},
		["casco"] = {"Casco",380000, "Trunk Capacity: 40 kg"},
		["coquette2"] = {"Coquette Classic",425000, "Trunk Capacity: 40 kg"},
		["stingergt"] = {"Stinger GT",475000, "Trunk Capacity: 40 kg"},
		["feltzer3"] = {"Stirling",575000, "Trunk Capacity: 40 kg"},
		["jb700"] = {"JB 700",1500000, "Trunk Capacity: 40 kg"},
		["ztype"] = {"Z-Type",1950000,"Trunk Capacity: 40 kg"}
	},

	-- ["supercars"] = {
	--   ["adder"] = {"Adder",1000000, ""},
	--   ["banshee2"] = {"Banshee 900R",565000, ""},
	--   ["bullet"] = {"Bullet",155000, ""},
	--   ["cheetah"] = {"Cheetah",650000, ""},
	--   ["entityxf"] = {"Entity XF",795000, ""},
	--   ["sheava"] = {"ETR1",199500, "4 - (less numner better car"},
	--   ["fmj"] = {"FMJ",1750000, "10 - (less numner better car"},
	--   ["infernus"] = {"Infernus",440000, ""},
	--   ["osiris"] = {"Osiris",1950000, "8 - (less numner better car"},
	--   ["le7b"] = {"RE-7B",5075000, "1 - (less numner better car"},
	--   ["reaper"] = {"Reaper",1595000, ""},
	--   ["sultanrs"] = {"Sultan RS",795000, ""},
	--   ["t20"] = {"T20",2200000,"7 - (less numner better car"},
	--   ["turismor"] = {"Turismo R",500000, "9 - (less numner better car"},
	--   ["tyrus"] = {"Tyrus",2550000, "5 - (less numner better car"},
	--   ["vacca"] = {"Vacca",240000, ""},
	--   ["voltic"] = {"Voltic",150000, ""},
	--   ["prototipo"] = {"X80 Proto",2700000, "6 - (less numner better car"},
	--   ["zentorno"] = {"Zentorno",725000,"3 - (less numner better car"}
	-- },

	["musclecars"] = {
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
		["youga"] = {"Youga",32000, "Trunk Capacity: 100 kg"},
		["surfer"] = {"Surfer",19000, "Trunk Capacity: 100 kg"},
		["bison"] = {"Bison",70000, "Trunk Capacity: 100 kg"},
		["minivan"] = {"Minivan",55000, "Trunk Capacity: 100 kg"},
		["bobcatxl"] = {"Bobcat XL",75000, "Trunk Capacity: 100 kg"},
		["paradise"] = {"Paradise",77000, "Trunk Capacity: 100 kg"},
		["rumpo"] = {"Rumpo",53000, "Trunk Capacity: 100 kg"},
		["journey"] = {"Journey - Meth Job",95000, "Trunk Capacity: 100 kg"},
		["gburrito"] = {"Gang Burrito",85000, "Trunk Capacity: 100 kg"}
	},

	["sedans"] = {
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
		--["zentorno"] = {"zentorno",1500000, ""},
		--["cognoscenti2"] = {"Cognoscenti(Armored)",1000000, ""},
		--["cognoscenti3"] = {"Cognoscenti 55",1000000, ""},
	},

	["motorcycles"] = {
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
		["taxi"] = {"Taxi - Taxi Job",30000,""}
	},

	["police"] = {
		["cvpi"] = {"CVPI",100,"Requires police rank Recruit and above."},
	    ["charger"] = {"Police Charger 2015",2000,"Requires police rank Officer and above."},
	    ["fpis"] = {"Police Interceptor",5000,"Requires police rank Sergeant and above."},
	    ["uccvpi"] = {"UC Crown Vic",8000,"Requires police rank Corporal and above."},
	    ["tahoe"] = {"Tahoe Slicktop",15000,"Requires police rank Officer and above."},
	    ["policeb"] = {"Police Motorcycle",8000,"Requires police rank Corporal and above."},
	    ["policet"] = {"Police Van",2000,"Requires police rank Recruit and above."},
	    ["explorer"] ={"Police Explorer 2013",15000,"Requires police rank Corporal and above."},
	    ["explorer2"] ={"Police Explorer 2016",15000,"Requires police rank Lieutenant and above."},
	    ["fbicharger"] = {"UC Charger",50000,"Requires police rank Captain"},
	    ["fbitahoe"] = {"UC Tahoe",50000,"Requires police rank Sergeant and above."}
	},

	["emergency"] = {
		["ambulance"] = {"Ambulance",100,"Requires rank EMT and above."},
		["firetruk"] = {"Firetruck",2000,"Requires rank EMT and above."},
		["firesuv"] = {"EMS SUV",15000,"Requires rank Paramedic and above."},
	},

	["bicycles"] = {
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
	{"compacts",-356.146, -134.69, 39.0097},
	{"coupe",723.013, -1088.92, 22.1829},
	{"sports",233.69268798828, -788.97814941406, 30.605836868286},
	{"sportsclassics",1174.76, 2645.46, 37.7545},
	{"supercars",112.275, 6619.83, 31.8154},
	{"motorcycles",-205.789, -1308.02, 31.2916},
	{"taxi",-286.870056152344,-917.948181152344,31.080623626709},
	{"police",454.4,-1017.6,28.4},
	{"emergency",-492.08544921875,-336.749206542969,34.3731842041016},
	{"bicycles",-352.038482666016,-109.240043640137,38.6970825195313}
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