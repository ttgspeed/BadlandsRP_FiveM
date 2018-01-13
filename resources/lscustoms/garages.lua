
cfg = {}
-- define garage types with their associated vehicles
-- (vehicle list: https://wiki.fivem.net/wiki/Vehicles)

-- each garage type is an associated list of veh_name/veh_definition
-- they need a _config property to define the blip and the vehicle type for the garage (each vtype allow one vehicle to be spawned at a time, the default vtype is "default")
-- this is used to let the player spawn a boat AND a car at the same time for example, and only despawn it in the correct garage
-- _config: vtype, blipid, blipcolor, permission (optional, only users with the permission will have access to the shop)

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
    ["mule"] = {"Mule", 90000, "Trunk Capacity: 180 kg"},
    ["hauler"] = {"Hauler", 120000, "Used for the Trucking job"},
    ["packer"] = {"Packer", 120000, "Used for the Trucking job"},
    ["phantom"] = {"Phantom", 120000, "Used for the Trucking job"}
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
    ["sentinel"] = {"Sentinel XS", 100000, "Trunk Capacity: 40 kg"},
    ["sentinel2"] = {"Sentinel", 90000, "Trunk Capacity: 40 kg"},
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
    ["pigalle"] = {"Pigalle",61000, "Trunk Capacity: 40 kg"},
    ["stinger"] = {"Stinger",256000, "Trunk Capacity: 40 kg"},
    ["casco"] = {"Casco",465000, "Trunk Capacity: 40 kg"},
    ["cheetah2"] = {"Cheetah Classic",865000, "Trunk Capacity: 40 kg"},
    ["coquette2"] = {"Coquette Classic",665000, "Trunk Capacity: 40 kg"},
    ["btype2"] = {"Franken Strange",550000, "Trunk Capacity: 40 kg"},
    ["infernus2"] = {"Infernus Classic",330000, "Trunk Capacity: 40 kg"},
    ["mamba"] = {"Mamba",995000, "Trunk Capacity: 40 kg"},
    ["manana"] = {"Manana",60000, "Trunk Capacity: 40 kg"},
    ["monroe"] = {"Monroe",490000, "Trunk Capacity: 40 kg"},
    ["peyote"] = {"Peyote",130000, "Trunk Capacity: 40 kg"},
    ["rapidgt3"] = {"Rapid GT Classic",340000, "Trunk Capacity: 40 kg"},
    ["btype"] = {"Roosevelt",220000, "Trunk Capacity: 40 kg"},
    ["btype3"] = {"Roosevelt Valor",422000, "Trunk Capacity: 40 kg"},
    ["stingergt"] = {"Stinger GT",475000, "Trunk Capacity: 40 kg"},
    ["feltzer3"] = {"Stirling",575000, "Trunk Capacity: 40 kg"},
    ["torero"] = {"Torero",389000, "Trunk Capacity: 40 kg"},
    ["tornado"] = {"Tornado",122000, "Trunk Capacity: 40 kg"},
    ["tornado3"] = {"Rusty Tornado",65000, "Trunk Capacity: 40 kg"},
    ["tornado4"] = {"Mariachi Tornado",82000, "Trunk Capacity: 40 kg"},
    ["tornado5"] = {"Tornado Custom",155000, "Trunk Capacity: 40 kg"},
    ["turismo2"] = {"Turismo Classic",330000, "Trunk Capacity: 40 kg"},
    ["jb700"] = {"JB 700",354000, "Trunk Capacity: 40 kg"},
    ["ztype"] = {"Z-Type",620000,"Trunk Capacity: 40 kg"},
  },

	["supercars"] = {
    ["pfister811"] = {"Pfister 811",4800000, "Trunk Capacity: 20 kg"},
    ["adder"] = {"Adder",3100000, "Trunk Capacity: 20 kg"},
    ["banshee2"] = {"Banshee 900R",1500000, "Trunk Capacity: 20 kg"},
    ["bullet"] = {"Bullet",1500000, "Trunk Capacity: 20 kg"},
    ["cheetah"] = {"Cheetah",2200000, "Trunk Capacity: 20 kg"},
    ["entityxf"] = {"Entity XF",1750000, "Trunk Capacity: 20 kg"},
    ["sheava"] = {"ETR1",2300000, "Trunk Capacity: 20 kg"},
    ["fmj"] = {"FMJ",3600000, "Trunk Capacity: 20 kg"},
    ["gp1"] = {"GP1",2600000, "Trunk Capacity: 20 kg"},
    ["infernus"] = {"Infernus",1850000, "Trunk Capacity: 20 kg"},
    ["italigtb"] = {"Itali GTB",2500000, "Trunk Capacity: 20 kg"},
    ["italigtb2"] = {"Itali GTB Custom",3800000, "Trunk Capacity: 20 kg"},
    ["nero"] = {"Nero",4300000, "Trunk Capacity: 20 kg"},
    ["nero2"] = {"Nero Custom",4900000, "Trunk Capacity: 20 kg"},
    ["osiris"] = {"Osiris",2350000, "Trunk Capacity: 20 kg"},
    ["penetrator"] = {"Penetrator",2700000, "Trunk Capacity: 20 kg"},
    ["le7b"] = {"RE-7B",2600000, "Trunk Capacity: 20 kg"},
    ["reaper"] = {"Reaper",2950000, "Trunk Capacity: 20 kg"},
    ["sultanrs"] = {"Sultan RS",970000, "Trunk Capacity: 20 kg"},
    ["t20"] = {"T20",3200000,"Trunk Capacity: 20 kg"},
    ["tempesta"] = {"Tempesta",3400000, "Trunk Capacity: 20 kg"},
    ["turismor"] = {"Turismo R",4500000, "Trunk Capacity: 20 kg"},
    ["tyrus"] = {"Tyrus",3350000, "Trunk Capacity: 20 kg"},
    ["vacca"] = {"Vacca",2950000, "Trunk Capacity: 20 kg"},
    ["vagner"] = {"Vagner",2500000, "Trunk Capacity: 20 kg"},
    ["voltic"] = {"Voltic",1600000, "Trunk Capacity: 20 kg"},
    ["prototipo"] = {"X80 Proto",4700000, "Trunk Capacity: 20 kg"},
    ["xa21"] = {"XA-21",6000000, "Trunk Capacity: 20 kg"},
    ["zentorno"] = {"Zentorno",5200000,"Trunk Capacity: 20 kg"}
		},

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
    ["journey"] = {"Journey - Meth Job",65000, "Trunk Capacity: 100 kg"},
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
    ["fbitahoe"] = {"SGT UC Tahoe",50000,""}
  },

  ["emergency"] = {
    ["ambulance"] = {"Ambulance",100,""},
    ["firetruk"] = {"Firetruck",100,""},
    ["firesuv"] = {"EMS SUV",15000,""},
    ["asstchief"] = {"",20000,"Requires rank Asst. Chief and above."},
    ["chiefpara"] = {"",20000,"Requires rank Chief Paramedic and above."},
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
