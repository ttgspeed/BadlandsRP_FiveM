
local cfg = {}

-- list of weapons for sale
-- for the native name, see the tattoos folder, the native names of the tattoos is in the files with the native name of the it's shop
-- create groups like for the garage config
-- [native_tattoo_name] = {display_name,price,description}

-- _config: blipid, blipcolor, permissions (optional, only users with the permission will have access to the shop)
-- https://wiki.gtanet.work/index.php?title=Blips
-- https://wiki.fivem.net/wiki/Controls

cfg.tattoos = {
	["mpbeach_overlays"] = { -- native store name
		_config = {blipid=75,blipcolor=48,title="Beach Tattoos"}, -- you can add permissions like on other vRP features
		["CLEAR"] = {">Clear Tattoos",0,"",0},
		["MP_Bea_M_Head_000"] = {"Pirate Skull - Head",50,"",2},
		["MP_Bea_M_Head_001"] = {"Surf LS - Head",50,"",3},
		["MP_Bea_M_Head_002"] = {"Shark - Head",50,"",4},
		["MP_Bea_F_Neck_000"] = {"Tribal Butterfly - Neck",50,"",5},
		["MP_Bea_M_Neck_000"] = {"Little Fish - Neck",50,"",6},
		["MP_Bea_M_Neck_001"] = {"Surfs Up - Neck",50,"",7},
		["MP_Bea_F_Back_000"] = {"Rock Solid - Back",50,"",8},
		["MP_Bea_F_Back_001"] = {"Hibiscus Flower Duo - Back",50,"",9},
		["MP_Bea_F_Back_002"] = {"Shrimp - Back",50,"",10},
		["MP_Bea_M_Back_000"] = {"Ship Arms - Back",50,"",11},
		["MP_Bea_F_Chest_000"] = {"Anchor - Chest",50,"",12},
		["MP_Bea_F_Chest_001"] = {"Anchor 2 - Chest",50,"",13},
		["MP_Bea_F_Chest_002"] = {"Los Santos Wreath - Chest",50,"",14},
		["MP_Bea_M_Chest_000"] = {"Tribal Hammerhead - Chest",50,"",15},
		["MP_Bea_M_Chest_001"] = {"Tribal Shark - Chest",50,"",16},
		["MP_Bea_F_Stom_000"] = {"Swallow - Stomach",50,"",17},
		["MP_Bea_F_Stom_001"] = {"Hibiscus Flower - Stomach",50,"",18},
		["MP_Bea_F_Stom_002"] = {"Dolphin - Stomach",50,"",19},
		["MP_Bea_M_Stom_000"] = {"Swordfish - Stomach",50,"",20},
		["MP_Bea_M_Stom_001"] = {"Wheel - Stomach",50,"",21},
		["MP_Bea_F_RSide_000"] = {"Love Dagger - Stomach",50,"",22},
		["MP_Bea_F_Should_000"] = {"Sea Horses - Shoulder",50,"",23},
		["MP_Bea_F_Should_001"] = {"Catfish - Shoulder",50,"",24},
		["MP_Bea_F_RArm_001"] = {"Tribal Fish - Right Arm",50,"",25},
		["MP_Bea_M_RArm_001"] = {"Vespucci Beauty - Right Arm",50,"",26},
		["MP_Bea_M_RArm_000"] = {"Tribal Sun - Right Arm",50,"",27},
		["MP_Bea_F_LArm_000"] = {"Tribal Flower - Left Arm",50,"",28},
		["MP_Bea_F_LArm_001"] = {"Parrot - Left Arm",50,"",29},
		["MP_Bea_M_LArm_000"] = {"Tiki Tower - Left Arm",50,"",30},
		["MP_Bea_M_Lleg_000"] = {"Tribal Star - Left Leg",50,"",31},
		["MP_Bea_F_RLeg_000"] = {"School of Fish - Right Leg",50,"",32}
	},
	["mpbusiness_overlays"] = {
		_config = {blipid=75,blipcolor=48,title="Business Tattoos"},
		["CLEAR"] = {">Clear Tattoos",0,"",0},
		["MP_Buis_M_Neck_000"] = {"Cash is King - Neck",50,"",1},
		["MP_Buis_M_Neck_001"] = {"Bold Dollar Sign - Neck",50,"",2},
		["MP_Buis_M_Neck_002"] = {"Script Dollar Sign - Neck",50,"",3},
		["MP_Buis_M_Neck_003"] = {"$100 - Neck",50,"",4},
		["MP_Buis_F_Neck_000"] = {"Val-de-Grace Logo - Neck",50,"",5},
		["MP_Buis_F_Neck_001"] = {"Money Rose - Neck",50,"",6},
		["MP_Buis_F_Back_000"] = {"Respect - Back",50,"",7},
		["MP_Buis_F_Back_001"] = {"Gold Digger - Back",50,"",8},
		["MP_Buis_M_Back_000"] = {"Makin' Paper - Back",50,"",9},
		["MP_Buis_M_Chest_000"] = {"Rich - Chest",50,"",10},
		["MP_Buis_M_Chest_001"] = {"$$$ - Chest",50,"",11},
		["MP_Buis_F_Chest_000"] = {"High Roller - Chest",50,"",12},
		["MP_Buis_F_Chest_001"] = {"Makin' Money - Chest",50,"",13},
		["MP_Buis_F_Chest_002"] = {"Love Money - Chest",50,"",14},
		["MP_Buis_F_Stom_000"] = {"Diamond Back - Stomach",50,"",15},
		["MP_Buis_F_Stom_001"] = {"Santo Capra Logo - Stomach",50,"",16},
		["MP_Buis_F_Stom_002"] = {"Money Bag - Stomach",50,"",17},
		["MP_Buis_M_Stomach_000"] = {"Refined Hustler - Stomach",50,"",18},
		["MP_Buis_M_LeftArm_000"] = {"$100 Bill - Left Arm",50,"",19},
		["MP_Buis_M_LeftArm_001"] = {"All-Seeing Eye - Left Arm",50,"",20},
		["MP_Buis_F_LArm_000"] = {"Greed is Good - Left Arm",50,"",21},
		["MP_Buis_F_LLeg_000"] = {"Single - Left Leg",50,"",22},
		["MP_Buis_M_RightArm_000"] = {"Dollar Skull - Right Arm",50,"",23},
		["MP_Buis_M_RightArm_001"] = {"Green - Right Arm",50,"",24},
		["MP_Buis_F_RArm_000"] = {"Dollar Sign - Right Arm",50,"",25},
		["MP_Buis_F_RLeg_000"] = {"Diamond Crown - Right Leg",50,"",26}

	},

	["mphipster_overlays"] = {
		_config = {blipid=75,blipcolor=48,title="Hipster Tattoos"},
		["CLEAR"] = {">Clear Tattoos",0,"",0},
		["FM_Hip_M_Tat_005"] = {"Beautiful Eye - Head",50,"",1},
		["FM_Hip_M_Tat_021"] = {"Geo Fox- Head",50,"",2},
		["FM_Hip_M_Tat_000"] = {"Crossed Arrows - Torso",50,"",3},
		["FM_Hip_M_Tat_002"] = {"Chemistry - Torso",50,"",4},
		["FM_Hip_M_Tat_006"] = {"Feather Birds - Torso",50,"",5},
		["FM_Hip_M_Tat_011"] = {"Infinity - Torso",50,"",6},
		["FM_Hip_M_Tat_012"] = {"Antlers - Torso",50,"",7},
		["FM_Hip_M_Tat_013"] = {"Boombox - Torso",50,"",8},
		["FM_Hip_M_Tat_024"] = {"Pyramid - Torso",50,"",9},
		["FM_Hip_M_Tat_025"] = {"Watch Your Step - Torso",50,"",10},
		["FM_Hip_M_Tat_029"] = {"Sad - Torso",50,"",11},
		["FM_Hip_M_Tat_030"] = {"Shark Fin - Torso",50,"",12},
		["FM_Hip_M_Tat_031"] = {"Skateboard - Torso",50,"",13},
		["FM_Hip_M_Tat_032"] = {"Paper Plane - Torso",50,"",14},
		["FM_Hip_M_Tat_033"] = {"Stag - Torso",50,"",15},
		["FM_Hip_M_Tat_035"] = {"Sewn Heart - Torso",50,"",16},
		["FM_Hip_M_Tat_046"] = {"Triangles - Torso",50,"",17},
		["FM_Hip_M_Tat_047"] = {"Cassette - Torso",50,"",18},
		["FM_Hip_M_Tat_001"] = {"Single Arrow - Right Arm",50,"",19},
		["FM_Hip_M_Tat_004"] = {"Bone - Right Arm",50,"",20},
		["FM_Hip_M_Tat_008"] = {"Cube - Right Arm",50,"",21},
		["FM_Hip_M_Tat_010"] = {"Horseshoe - Right Arm",50,"",22},
		["FM_Hip_M_Tat_014"] = {"Spray Can - Right Arm",50,"",23},
		["FM_Hip_M_Tat_018"] = {"Origami - Right Arm",50,"",24},
		["FM_Hip_M_Tat_017"] = {"Eye Triangle - Right Arm",50,"",25},
		["FM_Hip_M_Tat_020"] = {"Geo Pattern - Right Arm",50,"",26},
		["FM_Hip_M_Tat_022"] = {"Pencil - Right Arm",50,"",27},
		["FM_Hip_M_Tat_023"] = {"Smiley - Right Arm",50,"",28},
		["FM_Hip_M_Tat_036"] = {"Shapes - Right Arm",50,"",29},
		["FM_Hip_M_Tat_044"] = {"Triangle Black - Right Arm",50,"",30},
		["FM_Hip_M_Tat_045"] = {"Mesh Band - Right Arm",50,"",31},
		["FM_Hip_M_Tat_003"] = {"Diamond Sparkle - Left Arm",50,"",32},
		["FM_Hip_M_Tat_007"] = {"Bricks - Left Arm",50,"",33},
		["FM_Hip_M_Tat_015"] = {"Mustache - Left Arm",50,"",34},
		["FM_Hip_M_Tat_016"] = {"Lightning Bolt - Left Arm",50,"",35},
		["FM_Hip_M_Tat_026"] = {"Pizza - Left Arm",50,"",36},
		["FM_Hip_M_Tat_027"] = {"Padlock - Left Arm",50,"",37},
		["FM_Hip_M_Tat_028"] = {"Thorny Rose - Left Arm",50,"",38},
		["FM_Hip_M_Tat_034"] = {"Stop - Left Arm",50,"",39},
		["FM_Hip_M_Tat_037"] = {"Sunrise - Left Arm",50,"",40},
		["FM_Hip_M_Tat_038"] = {"Grub - Right Leg",50,"",41},
		["FM_Hip_M_Tat_039"] = {"Sleeve - Left Arm",50,"",42},
		["FM_Hip_M_Tat_043"] = {"Triangle White - Left Arm",50,"",43},
		["FM_Hip_M_Tat_048"] = {"Peace - Left Arm",50,"",44},
		["FM_Hip_M_Tat_041"] = {"Tooth - Right Leg",50,"",45},
		["FM_Hip_M_Tat_042"] = {"Sparkplug - Right Leg",50,"",46},
		["FM_Hip_M_Tat_009"] = {"Squares - Left Leg",50,"",47},
		["FM_Hip_M_Tat_019"] = {"Charm - Left Leg",50,"",48},
		["FM_Hip_M_Tat_040"] = {"Black Anchor - Left Leg",50,"",49},
	},
}

-- list of tattooshops positions
cfg.shops = {
  {"mpbeach_overlays", 1322.645,-1651.976,52.275},
  {"mpbeach_overlays", -1153.676,-1425.68,4.954},
  {"mpbusiness_overlays", 322.139,180.467,103.587},
  {"mpbusiness_overlays", -3170.071,1075.059,20.829},
  {"mphipster_overlays", 1864.633,3747.738,33.032},
  {"mphipster_overlays", -293.713,6200.04,31.487}
}

return cfg
