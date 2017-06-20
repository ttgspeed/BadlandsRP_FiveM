
local cfg = {}
-- define garage types with their associated vehicles
-- (vehicle list: https://wiki.fivem.net/wiki/Vehicles)

-- each garage type is an associated list of veh_name/veh_definition
-- they need a _config property to define the blip and the vehicle type for the garage (each vtype allow one vehicle to be spawned at a time, the default vtype is "default")
-- this is used to let the player spawn a boat AND a car at the same time for example, and only despawn it in the correct garage
-- _config: vtype, blipid, blipcolor, permission (optional, only users with the permission will have access to the shop)

cfg.garage_types = {
  ["compacts"]  = {
    _config = {vtype="car",blipid=50,blipcolor=4},
    ["blista"] = {"Blista", 15000, ""},
    ["brioso"] = {"Brioso R/A", 155000, ""},
    ["dilettante"] = {"Dilettante", 25000, ""},
    ["issi2"] = {"Issi", 18000, ""},
    ["panto"] = {"Panto", 85000, ""},
    ["prairie"] = {"Prairie", 30000, ""},
    ["rhapsody"] = {"Rhapsody", 120000, ""}
  },

  ["coupe"] = {
    _config = {vtype="car",blipid=50,blipcolor=4},
    ["cogcabrio"] = {"Cognoscenti Cabrio",180000, ""},
    ["exemplar"] = {"Exemplar", 200000, ""},
    ["F620"] = {"F620", 80000, ""},
    ["felon"] = {"Felon", 90000, ""},
    ["felon2"] = {"Felon GT", 95000, ""},
    ["jackal"] = {"Jackal", 60000, ""},
    ["oracle"] = {"Oracle", 80000, ""},
    ["oracle2"] = {"Oracle XS",82000, ""},
    ["sentinel"] = {"sentinel", 90000, ""},
    ["sentinel2"] = {"Sentinel XS", 60000, ""},
    ["windsor"] = {"Windsor",800000, ""},
    ["windsor2"] = {"Windsor Drop",850000, ""},
    ["zion"] = {"Zion", 60000, ""},
    ["zion2"] = {"Zion Cabrio", 65000, ""}
  },

  ["sports"] = {
    _config = {vtype="car",blipid=50,blipcolor=4},
    ["ninef"] = {"9F",120000, ""},
    ["ninef2"] = {"9F Cabrio",130000, ""},
    ["alpha"] = {"Alpha",150000, ""},
    ["banshee"] = {"Banshee",105000, ""},
    ["bestiagts"] = {"Bestia GTS",610000, ""},
    ["blista"] = {"Blista Compact",42000, ""},
    ["buffalo"] = {"Buffalo",35000, ""},
    ["buffalo2"] = {"Buffalo S",96000, ""},
    ["carbonizzare"] = {"Carbonizzare",195000, ""},
    ["comet2"] = {"Comet",100000, ""},
    ["coquette"] = {"Coquette",138000, ""},
    ["tampa2"] = {"Drift Tampa",995000, ""},
    ["feltzer2"] = {"Feltzer",130000, ""},
    ["furoregt"] = {"Furore GT",448000, ""},
    ["fusilade"] = {"Fusilade",36000, ""},
    ["jester"] = {"Jester",240000, ""},
    ["jester2"] = {"Jester (Racecar)",350000, ""},
    ["kuruma"] = {"Kuruma",95000, ""},
    ["lynx"] = {"Lynx",1735000, ""},
    ["massacro"] = {"Massacro",275000, ""},
    ["massacro2"] = {"Massacro (Racecar)",385000, ""},
    ["omnis"] = {"Omnis",701000, ""},
    ["penumbra"] = {"Penumbra",24000, ""},
    ["rapidgt"] = {"Rapid GT",140000, ""},
    ["rapidgt2"] = {"Rapid GT Convertible",150000, ""},
    ["schafter3"] = {"Schafter V12",140000, ""},
    ["sultan"] = {"Sultan",12000, ""},
    ["surano"] = {"Surano",110000, ""},
    ["tropos"] = {"Tropos",816000, ""},
    ["verlierer2"] = {"Verlierer",695000,""}
  },

  ["sportsclassics"] = {
    _config = {vtype="car",blipid=50,blipcolor=5},
    ["casco"] = {"Casco",680000, ""},
    ["coquette2"] = {"Coquette Classic",665000, ""},
    ["jb700"] = {"JB 700",3500000, ""},
    ["pigalle"] = {"Pigalle",400000, ""},
    ["stinger"] = {"Stinger",850000, ""},
    ["stingergt"] = {"Stinger GT",875000, ""},
    ["feltzer3"] = {"Stirling",975000, ""},
    ["ztype"] = {"Z-Type",950000,""}
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
    ["blade"] = {"Blade",160000, ""},
    ["buccaneer"] = {"Buccaneer",29000, ""},
    ["Chino"] = {"Chino",225000, ""},
    ["coquette3"] = {"Coquette BlackFin",695000, ""},
    ["dominator"] = {"Dominator",35000, ""},
    ["dukes"] = {"Dukes",62000, ""},
    ["gauntlet"] = {"Gauntlet",32000, ""},
    ["hotknife"] = {"Hotknife",90000, ""},
    ["faction"] = {"Faction",36000, ""},
    ["nightshade"] = {"Nightshade",585000, ""},
    ["picador"] = {"Picador",9000, ""},
    ["sabregt"] = {"Sabre Turbo",15000, ""},
    ["tampa"] = {"Tampa",375000, ""},
    ["virgo"] = {"Virgo",195000, ""},
    ["vigero"] = {"Vigero",21000, ""}
  },

  ["off-road"] = {
    _config = {vtype="car",blipid=50,blipcolor=4},
    ["bifta"] = {"Bifta",75000, ""},
    ["blazer"] = {"Blazer",8000, ""},
    ["brawler"] = {"Brawler",715000, ""},
    ["dubsta3"] = {"Bubsta 6x6",249000, ""},
    ["dune"] = {"Dune Buggy",20000, ""},
    ["rebel2"] = {"Rebel",22000, ""},
    ["sandking"] = {"Sandking",38000, ""},
    ["monster"] = {"The Liberator",550000, ""},
    ["trophytruck"] = {"The Liberator",550000, ""}
  },

  ["suvs"]  = {
    _config = {vtype="car",blipid=50,blipcolor=4},
    ["baller"] = {"Baller",90000, ""},
    ["cavalcade"] = {"Cavalcade",60000, ""},
    ["granger"] = {"Granger",35000, ""},
    ["huntley"] = {"Huntley",195000, ""},
    ["landstalker"] = {"Landstalker",58000, ""},
    ["radi"] = {"Radius",32000, ""},
    ["rocoto"] = {"Rocoto",85000, ""},
    ["seminole"] = {"Seminole",30000, ""},
    ["xls"] = {"XLS",253000, ""}
  },

  ["vans"] = {
    _config = {vtype="car",blipid=50,blipcolor=4},
    ["bison"] = {"Bison",30000, ""},
    ["bobcatxl"] = {"Bobcat XL",23000, ""},
    ["gburrito"] = {"Gang Burrito",65000, ""},
    ["journey"] = {"Journey",15000, ""},
    ["minivan"] = {"Minivan",30000, ""},
    ["paradise"] = {"Paradise",25000, ""},
    ["rumpo"] = {"Rumpo",13000, ""},
    ["surfer"] = {"Surfer",11000, ""},
    ["youga"] = {"Youga",16000, ""}
  },

  ["sedans"] = {
    _config = {vtype="car",blipid=50,blipcolor=4},
    ["asea"] = {"Asea",1000000, ""},
    ["asterope"] = {"Asterope",1000000, ""},
    ["cognoscenti"] = {"Cognoscenti",1000000, ""},
    ["cognoscenti2"] = {"Cognoscenti(Armored)",1000000, ""},
    ["cognoscenti3"] = {"Cognoscenti 55",1000000, ""},
    ["zentorno"] = {"Cognoscenti 55(Armored)",1500000, ""},
    ["fugitive"] = {"Fugitive",24000, ""},
    ["glendale"] = {"Glendale",200000, ""},
    ["ingot"] = {"Ingot",9000, ""},
    ["intruder"] = {"Intruder",16000, ""},
    ["premier"] = {"Premier",10000, ""},
    ["primo"] = {"Primo",9000, ""},
    ["primo2"] = {"Primo Custom",9500, ""},
    ["regina"] = {"Regina",8000, ""},
    ["schafter2"] = {"Schafter",65000, ""},
    ["stanier"] = {"Stanier",10000, ""},
    ["stratum"] = {"Stratum",10000, ""},
    ["stretch"] = {"Stretch",30000, ""},
    ["superd"] = {"Super Diamond",250000, ""},
    ["surge"] = {"Surge",38000, ""},
    ["tailgater"] = {"Tailgater",55000, ""},
    ["warrener"] = {"Warrener",120000, ""},
    ["washington"] = {"Washington",15000, ""}
  },

  ["motorcycles"] = {
    _config = {vtype="bike",blipid=226,blipcolor=4},
    ["AKUMA"] = {"Akuma",9000, ""},
    ["bagger"] = {"Bagger",5000, ""},
    ["bati"] = {"Bati 801",15000, ""},
    ["bati2"] = {"Bati 801RR",15000, ""},
    ["bf400"] = {"BF400",95000, ""},
    ["carbonrs"] = {"Carbon RS",40000, ""},
    ["cliffhanger"] = {"Cliffhanger",225000, ""},
    ["daemon"] = {"Daemon",5000, ""},
    ["double"] = {"Double T",12000, ""},
    ["enduro"] = {"Enduro",48000, ""},
    ["faggio2"] = {"Faggio",4000, ""},
    ["gargoyle"] = {"Gargoyle",120000, ""},
    ["hakuchou"] = {"Hakuchou",82000, ""},
    ["hexer"] = {"Hexer",15000, ""},
    ["innovation"] = {"Innovation",90000, ""},
    ["lectro"] = {"Lectro",700000, ""},
    ["nemesis"] = {"Nemesis",12000, ""},
    ["pcj"] = {"PCJ-600",9000, ""},
    ["ruffian"] = {"Ruffian",9000, ""},
    ["sanchez"] = {"Sanchez",7000, ""},
    ["sovereign"] = {"Sovereign",90000, ""},
    ["thrust"] = {"Thrust",75000, ""},
    ["vader"] = {"Vader",9000, ""},
    ["vindicator"] = {"Vindicator",600000,""}
  },

  ["taxi"] = {
    _config = {vtype="car", blipid=56, blipcolor=5, permission = "taxi.vehicle"},
    ["taxi"] = {"Taxi",100,""}
  },

  ["police"] = {
    _config = {vtype="car", blipid=0, blipcolor=38, permission = "police.vehicle"},
    ["police"] = {"Patrol Car 1",100,""},
    ["police2"] = {"Patrol Car 2",100,""},
    ["police3"] = {"Patrol Car 3",100,""},
    ["police4"] = {"UC Patrol Car",100,""},
    ["policet"] = {"Police Van",100,""}
  },

  ["emergency"] = {
    _config = {vtype="car",blipid=0,blipcolor=3,permission="emergency.vehicle"},
    ["ambulance"] = {"Ambulance",100,""},
    ["firetruk"] = {"Firetruck",100,""}
  },

  ["bicycles"] = {
    _config = {vtype="bike",blipid=376,blipcolor=4},
    ["tribike"] = {"Tribike", 250, ""},
    ["BMX"] = {"BMX", 450, ""}
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
