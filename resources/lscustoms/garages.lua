
cfg = {}
-- define garage types with their associated vehicles
-- (vehicle list: https://wiki.fivem.net/wiki/Vehicles)

-- each garage type is an associated list of veh_name/veh_definition
-- they need a _config property to define the blip and the vehicle type for the garage (each vtype allow one vehicle to be spawned at a time, the default vtype is "default")
-- this is used to let the player spawn a boat AND a car at the same time for example, and only despawn it in the correct garage
-- _config: vtype, blipid, blipcolor, permission (optional, only users with the permission will have access to the shop)

cfg.garage_types = {
  ["job"] = {
    ["mule"] = {"Mule", 90000, ""}
  },

  ["compacts"]  = {
    ["panto"] = {"Panto", 500, ""},
    ["dilettante"] = {"Dilettante", 2500, ""},
    ["blista"] = {"Blista", 15000, ""},
    ["issi2"] = {"Issi", 18000, ""},
    ["prairie"] = {"Prairie", 25000, ""},
    ["rhapsody"] = {"Rhapsody", 30000, ""},
    ["brioso"] = {"Brioso R/A", 155000, ""}
  },

  ["coupe"] = {
    ["oracle"] = {"Oracle", 40000, ""},
    ["jackal"] = {"Jackal", 50000, ""},
    ["zion"] = {"Zion", 60000, ""},
    ["oracle2"] = {"Oracle XS",65000, ""},
    ["zion2"] = {"Zion Cabrio", 75000, ""},
    ["F620"] = {"F620", 80000, ""},
    ["felon"] = {"Felon", 90000, ""},
    ["felon2"] = {"Felon GT", 95000, ""},
    ["sentinel"] = {"Sentinel", 90000, ""},
    ["sentinel2"] = {"Sentinel XS", 100000, ""},
    ["exemplar"] = {"Exemplar", 120000, ""},
    ["cogcabrio"] = {"Cognoscenti Cabrio",180000, ""},
    ["windsor"] = {"Windsor",800000, ""},
    ["windsor2"] = {"Windsor Drop",850000, ""}
  },

  ["sports"] = {
    ["blista"] = {"Blista Compact",5000, ""},
    ["sultan"] = {"Sultan",8000, ""},
    ["schafter3"] = {"Schafter V12",18000, ""},
    ["buffalo"] = {"Buffalo",35000, ""},
    ["fusilade"] = {"Fusilade",46000, ""},
    ["ninef"] = {"9F",50000, ""},
    ["buffalo2"] = {"Buffalo S",55000, ""},
    ["penumbra"] = {"Penumbra",64000, ""},
    ["rapidgt"] = {"Rapid GT",70000, ""},
    ["ninef2"] = {"9F Cabrio",85000, ""},
    ["surano"] = {"Surano",110000, ""},
    ["rapidgt2"] = {"Rapid GT Convertible",110000, ""},
    ["feltzer2"] = {"Feltzer",130000, ""},
    ["alpha"] = {"Alpha",130000, ""},
    ["banshee"] = {"Banshee",155000, ""},
    ["kuruma"] = {"Kuruma",155000, ""},
    ["carbonizzare"] = {"Carbonizzare",195000, ""},
    ["coquette"] = {"Coquette",238000, ""},
    ["comet2"] = {"Comet",310000, ""},
    ["omnis"] = {"Omnis",330000, ""},
    ["massacro"] = {"Massacro",375000, ""},
    ["massacro2"] = {"Massacro (Racecar)",385000, ""},
    ["furoregt"] = {"Furore GT",428000, ""},
    ["bestiagts"] = {"Bestia GTS",430000, ""},
    ["jester"] = {"Jester",440000, ""},
    ["tampa2"] = {"Drift Tampa",465000, ""},
    ["lynx"] = {"Lynx",520000, ""},
    ["jester2"] = {"Jester (Racecar)",550000, ""},
    ["tropos"] = {"Tropos",816000, ""},
    ["verlierer2"] = {"Verlierer",1595000,""}
  },

  ["sportsclassics"] = {
    ["pigalle"] = {"Pigalle",200000, ""},
    ["stinger"] = {"Stinger",250000, ""},
    ["casco"] = {"Casco",380000, ""},
    ["coquette2"] = {"Coquette Classic",425000, ""},
    ["stingergt"] = {"Stinger GT",475000, ""},
    ["feltzer3"] = {"Stirling",575000, ""},
    ["jb700"] = {"JB 700",1500000, ""},
    ["ztype"] = {"Z-Type",1950000,""}
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
    ["picador"] = {"Picador",9000, ""},
    ["sabregt"] = {"Sabre Turbo",15000, ""},
    ["vigero"] = {"Vigero",21000, ""},
    ["buccaneer"] = {"Buccaneer",29000, ""},
    ["faction"] = {"Faction",36000, ""},
    ["Chino"] = {"Chino",45000, ""},
    ["blade"] = {"Blade",48000, ""},
    ["dukes"] = {"Dukes",62000, ""},
    ["tampa"] = {"Tampa",75000, ""},
    ["hotknife"] = {"Hotknife",90000, ""},
    ["dominator"] = {"Dominator",105000, ""},
    ["gauntlet"] = {"Gauntlet",120000, ""},
    ["virgo"] = {"Virgo",195000, ""},
    ["nightshade"] = {"Nightshade",485000, ""},
    ["coquette3"] = {"Coquette BlackFin",695000, ""}
  },

  ["off-road"] = {
    ["blazer"] = {"Blazer",8000, ""},
    ["bifta"] = {"Bifta",55000, ""},
    ["dune"] = {"Dune Buggy",70000, ""},
    ["rebel2"] = {"Rebel",92000, ""},
    ["sandking"] = {"Sandking",188000, ""},
    ["dubsta3"] = {"Dubsta 6x6",249000, ""},
    --["monster"] = {"The Liberator",550000, ""},
    ["brawler"] = {"Brawler",1515000, ""},
    ["trophytruck"] = {"Trophy Truck",2550000, ""}
  },

  ["suvs"]  = {
    ["seminole"] = {"Seminole",30000, ""},
    ["radi"] = {"Radius",42000, ""},
    ["landstalker"] = {"Landstalker",78000, ""},
    ["cavalcade"] = {"Cavalcade",80000, ""},
    ["rocoto"] = {"Rocoto",85000, ""},
    ["baller"] = {"Baller",90000, ""},
    ["granger"] = {"Granger",105000, ""},
    ["xls"] = {"XLS",253000, ""},
    ["huntley"] = {"Huntley",395000, ""}
  },

  ["vans"] = {
    ["youga"] = {"Youga",32000, ""},
    ["surfer"] = {"Surfer",19000, ""},
    ["bison"] = {"Bison",70000, ""},
    ["minivan"] = {"Minivan",55000, ""},
    ["bobcatxl"] = {"Bobcat XL",75000, ""},
    ["paradise"] = {"Paradise",77000, ""},
    ["rumpo"] = {"Rumpo",53000, ""},
    ["journey"] = {"Journey - Meth Job",95000, ""},
    ["gburrito"] = {"Gang Burrito",85000, ""}
  },

  ["sedans"] = {
    ["premier"] = {"Premier",300, ""},
    ["ingot"] = {"Ingot",400, ""},
    ["regina"] = {"Regina",8000, ""},
    ["primo"] = {"Primo",9000, ""},
    ["asea"] = {"Asea",5000, ""},
    ["stanier"] = {"Stanier",10000, ""},
    ["stratum"] = {"Stratum",10000, ""},
    ["washington"] = {"Washington",15000, ""},
    ["primo2"] = {"Primo Custom",18000, ""},
    ["asterope"] = {"Asterope",20000, ""},
    ["intruder"] = {"Intruder",25000, ""},
    ["fugitive"] = {"Fugitive",44000, ""},
    ["tailgater"] = {"Tailgater",55000, ""},
    ["glendale"] = {"Glendale",60000, ""},
    ["schafter2"] = {"Schafter",65000, ""},
    ["surge"] = {"Surge",78000, ""},
    ["warrener"] = {"Warrener",120000, ""},
    ["stretch"] = {"Stretch",230000, ""},
    ["superd"] = {"Super Diamond",350000, ""},
    ["cognoscenti"] = {"Cognoscenti",1600000, ""}
    --["zentorno"] = {"zentorno",1500000, ""},
    --["cognoscenti2"] = {"Cognoscenti(Armored)",1000000, ""},
    --["cognoscenti3"] = {"Cognoscenti 55",1000000, ""},
  },

  ["motorcycles"] = {
    ["faggio2"] = {"Faggio",4000, ""},
    ["pcj"] = {"PCJ-600",9000, ""},
    ["ruffian"] = {"Ruffian",15000, ""},
    ["sanchez"] = {"Sanchez",23000, ""},
    ["daemon"] = {"Daemon",25000, ""},
    ["enduro"] = {"Enduro",28000, ""},
    ["AKUMA"] = {"Akuma",29000, ""},
    ["bagger"] = {"Bagger",35000, ""},
    ["vader"] = {"Vader",49000, ""},
    ["carbonrs"] = {"Carbon RS",52000, ""},
    ["nemesis"] = {"Nemesis",72000, ""},
    ["hexer"] = {"Hexer",80000, ""},
    ["sovereign"] = {"Sovereign",90000, ""},
    ["bati"] = {"Bati 801",185000, ""},
    ["bf400"] = {"BF400",195000, ""},
    ["vindicator"] = {"Vindicator",210000,""},
    ["bati2"] = {"Bati 801RR",250000, ""},
    ["cliffhanger"] = {"Cliffhanger",275000, ""},
    ["innovation"] = {"Innovation",290000, ""},
    ["lectro"] = {"Lectro",310000, ""},
    ["thrust"] = {"Thrust",335000, ""},
    ["gargoyle"] = {"Gargoyle",360000, ""},
    ["hakuchou"] = {"Hakuchou",382000, ""},
    ["double"] = {"Double T",412000, ""}
  },

  ["taxi"] = {
    ["taxi"] = {"Taxi - Taxi Job",30000,""}
  },

  ["police"] = {
    ["police"] = {"Patrol Car 1",100,""},
    ["police2"] = {"Patrol Car 2",3100,""},
    ["police3"] = {"Patrol Car 3",4100,""},
    ["police4"] = {"UC Patrol Car",4100,""},
    ["policet"] = {"Police Van",2200,""}
    --["police"] = {"Impala",400,""},
    --["police2"] = {"2015 Charger Marked",100,""},
    --["police3"] = {"2013 Ford FPIU",100,""},
    --["police4"] = {"2013 Ford FPIS",100,""},
    --["police5"] = {"2016 Ford FPIU",100,""},
    --["police6"] = {"2013 Tahoe",100,""},
    --["police7"] = {"2011 Crown Vic",100,""},
  },

  ["emergency"] = {
    ["ambulance"] = {"Ambulance",100,""},
    ["firetruk"] = {"Firetruck",100,""}
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
