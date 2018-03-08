
local cfg = {}

-- list of weapons for sale
-- for the native name, see the tattoos folder, the native names of the tattoos is in the files with the native name of the it's shop
-- create groups like for the garage config
-- [native_tattoo_name] = {display_name,price,description}

-- _config: blipid, blipcolor, permissions (optional, only users with the permission will have access to the shop)
-- https://wiki.gtanet.work/index.php?title=Blips
-- https://wiki.fivem.net/wiki/Controls

cfg.pack = {
	mpbeach_overlays = [[
	[
	  {
	    "Name": "TAT_BB_018",
	    "LocalizedName": "Ship Arms",
	    "HashNameMale": "MP_Bea_M_Back_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7250
	  },
	  {
	    "Name": "TAT_BB_019",
	    "LocalizedName": "Tribal Hammerhead",
	    "HashNameMale": "MP_Bea_M_Chest_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5800
	  },
	  {
	    "Name": "TAT_BB_020",
	    "LocalizedName": "Tribal Shark",
	    "HashNameMale": "MP_Bea_M_Chest_001",
	    "HashNameFemale": "",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5900
	  },
	  {
	    "Name": "TAT_BB_021",
	    "LocalizedName": "Pirate Skull",
	    "HashNameMale": "MP_Bea_M_Head_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 12000
	  },
	  {
	    "Name": "TAT_BB_022",
	    "LocalizedName": "Surf LS",
	    "HashNameMale": "MP_Bea_M_Head_001",
	    "HashNameFemale": "",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 1450
	  },
	  {
	    "Name": "TAT_BB_031",
	    "LocalizedName": "Shark",
	    "HashNameMale": "MP_Bea_M_Head_002",
	    "HashNameFemale": "",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 1850
	  },
	  {
	    "Name": "TAT_BB_027",
	    "LocalizedName": "Tribal Star",
	    "HashNameMale": "MP_Bea_M_Lleg_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 4450
	  },
	  {
	    "Name": "TAT_BB_025",
	    "LocalizedName": "Tribal Tiki Tower",
	    "HashNameMale": "MP_Bea_M_Rleg_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 6500
	  },
	  {
	    "Name": "TAT_BB_026",
	    "LocalizedName": "Tribal Sun",
	    "HashNameMale": "MP_Bea_M_RArm_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 6200
	  },
	  {
	    "Name": "TAT_BB_024",
	    "LocalizedName": "Tiki Tower",
	    "HashNameMale": "MP_Bea_M_LArm_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 4800
	  },
	  {
	    "Name": "TAT_BB_017",
	    "LocalizedName": "Mermaid L.S.",
	    "HashNameMale": "MP_Bea_M_LArm_001",
	    "HashNameFemale": "",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 6600
	  },
	  {
	    "Name": "TAT_BB_028",
	    "LocalizedName": "Little Fish",
	    "HashNameMale": "MP_Bea_M_Neck_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 1650
	  },
	  {
	    "Name": "TAT_BB_029",
	    "LocalizedName": "Surfs Up",
	    "HashNameMale": "MP_Bea_M_Neck_001",
	    "HashNameFemale": "",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 2250
	  },
	  {
	    "Name": "TAT_BB_030",
	    "LocalizedName": "Vespucci Beauty",
	    "HashNameMale": "MP_Bea_M_RArm_001",
	    "HashNameFemale": "",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 7000
	  },
	  {
	    "Name": "TAT_BB_023",
	    "LocalizedName": "Swordfish",
	    "HashNameMale": "MP_Bea_M_Stom_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 3100
	  },
	  {
	    "Name": "TAT_BB_032",
	    "LocalizedName": "Wheel",
	    "HashNameMale": "MP_Bea_M_Stom_001",
	    "HashNameFemale": "",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5500
	  },
	  {
	    "Name": "TAT_BB_003",
	    "LocalizedName": "Rock Solid",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Back_000",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5500
	  },
	  {
	    "Name": "TAT_BB_001",
	    "LocalizedName": "Hibiscus Flower Duo",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Back_001",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6900
	  },
	  {
	    "Name": "TAT_BB_005",
	    "LocalizedName": "Shrimp",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Back_002",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2500
	  },
	  {
	    "Name": "TAT_BB_012",
	    "LocalizedName": "Anchor",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Chest_000",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2500
	  },
	  {
	    "Name": "TAT_BB_013",
	    "LocalizedName": "Anchor",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Chest_001",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2500
	  },
	  {
	    "Name": "TAT_BB_000",
	    "LocalizedName": "Los Santos Wreath",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Chest_002",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 8500
	  },
	  {
	    "Name": "TAT_BB_006",
	    "LocalizedName": "Love Dagger",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_RSide_000",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6850
	  },
	  {
	    "Name": "TAT_BB_007",
	    "LocalizedName": "School of Fish",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_RLeg_000",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 2950
	  },
	  {
	    "Name": "TAT_BB_015",
	    "LocalizedName": "Tribal Fish",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_RArm_001",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 3700
	  },
	  {
	    "Name": "TAT_BB_008",
	    "LocalizedName": "Tribal Butterfly",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Neck_000",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 1700
	  },
	  {
	    "Name": "TAT_BB_011",
	    "LocalizedName": "Sea Horses",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Should_000",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5100
	  },
	  {
	    "Name": "TAT_BB_004",
	    "LocalizedName": "Catfish",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Should_001",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5250
	  },
	  {
	    "Name": "TAT_BB_014",
	    "LocalizedName": "Swallow",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Stom_000",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2100
	  },
	  {
	    "Name": "TAT_BB_009",
	    "LocalizedName": "Hibiscus Flower",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Stom_001",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2650
	  },
	  {
	    "Name": "TAT_BB_010",
	    "LocalizedName": "Dolphin",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Stom_002",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 1900
	  },
	  {
	    "Name": "TAT_BB_002",
	    "LocalizedName": "Tribal Flower",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_LArm_000",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 3500
	  },
	  {
	    "Name": "TAT_BB_016",
	    "LocalizedName": "Parrot",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_LArm_001",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 5250
	  }
	]
	]],
	mpbiker_overlays = [[
	[
	  {
	    "Name": "TAT_BI_000",
	    "LocalizedName": "Demon Rider",
	    "HashNameMale": "MP_MP_Biker_Tat_000_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_000_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6720
	  },
	  {
	    "Name": "TAT_BI_001",
	    "LocalizedName": "Both Barrels",
	    "HashNameMale": "MP_MP_Biker_Tat_001_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_001_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 10800
	  },
	  {
	    "Name": "TAT_BI_002",
	    "LocalizedName": "Rose Tribute",
	    "HashNameMale": "MP_MP_Biker_Tat_002_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_002_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 16820
	  },
	  {
	    "Name": "TAT_BI_003",
	    "LocalizedName": "Web Rider",
	    "HashNameMale": "MP_MP_Biker_Tat_003_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_003_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 10850
	  },
	  {
	    "Name": "TAT_BI_004",
	    "LocalizedName": "Dragon's Fury",
	    "HashNameMale": "MP_MP_Biker_Tat_004_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_004_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 17950
	  },
	  {
	    "Name": "TAT_BI_005",
	    "LocalizedName": "Made In America",
	    "HashNameMale": "MP_MP_Biker_Tat_005_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_005_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 9230
	  },
	  {
	    "Name": "TAT_BI_006",
	    "LocalizedName": "Chopper Freedom",
	    "HashNameMale": "MP_MP_Biker_Tat_006_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_006_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 10400
	  },
	  {
	    "Name": "TAT_BI_007",
	    "LocalizedName": "Swooping Eagle",
	    "HashNameMale": "MP_MP_Biker_Tat_007_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_007_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 5100
	  },
	  {
	    "Name": "TAT_BI_008",
	    "LocalizedName": "Freedom Wheels",
	    "HashNameMale": "MP_MP_Biker_Tat_008_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_008_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 8785
	  },
	  {
	    "Name": "TAT_BI_009",
	    "LocalizedName": "Morbid Arachnid",
	    "HashNameMale": "MP_MP_Biker_Tat_009_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_009_F",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 6350
	  },
	  {
	    "Name": "TAT_BI_010",
	    "LocalizedName": "Skull Of Taurus",
	    "HashNameMale": "MP_MP_Biker_Tat_010_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_010_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 11350
	  },
	  {
	    "Name": "TAT_BI_011",
	    "LocalizedName": "R.I.P. My Brothers",
	    "HashNameMale": "MP_MP_Biker_Tat_011_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_011_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 12350
	  },
	  {
	    "Name": "TAT_BI_012",
	    "LocalizedName": "Urban Stunter",
	    "HashNameMale": "MP_MP_Biker_Tat_012_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_012_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 4985
	  },
	  {
	    "Name": "TAT_BI_013",
	    "LocalizedName": "Demon Crossbones",
	    "HashNameMale": "MP_MP_Biker_Tat_013_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_013_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 11140
	  },
	  {
	    "Name": "TAT_BI_014",
	    "LocalizedName": "Lady Mortality",
	    "HashNameMale": "MP_MP_Biker_Tat_014_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_014_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 8300
	  },
	  {
	    "Name": "TAT_BI_015",
	    "LocalizedName": "Ride or Die",
	    "HashNameMale": "MP_MP_Biker_Tat_015_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_015_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 8975
	  },
	  {
	    "Name": "TAT_BI_016",
	    "LocalizedName": "Macabre Tree",
	    "HashNameMale": "MP_MP_Biker_Tat_016_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_016_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 9000
	  },
	  {
	    "Name": "TAT_BI_017",
	    "LocalizedName": "Clawed Beast",
	    "HashNameMale": "MP_MP_Biker_Tat_017_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_017_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 15650
	  },
	  {
	    "Name": "TAT_BI_018",
	    "LocalizedName": "Skeletal Chopper",
	    "HashNameMale": "MP_MP_Biker_Tat_018_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_018_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7650
	  },
	  {
	    "Name": "TAT_BI_019",
	    "LocalizedName": "Gruesome Talons",
	    "HashNameMale": "MP_MP_Biker_Tat_019_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_019_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 9900
	  },
	  {
	    "Name": "TAT_BI_020",
	    "LocalizedName": "Cranial Rose",
	    "HashNameMale": "MP_MP_Biker_Tat_020_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_020_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 9745
	  },
	  {
	    "Name": "TAT_BI_021",
	    "LocalizedName": "Flaming Reaper",
	    "HashNameMale": "MP_MP_Biker_Tat_021_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_021_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 13700
	  },
	  {
	    "Name": "TAT_BI_022",
	    "LocalizedName": "Western Insignia",
	    "HashNameMale": "MP_MP_Biker_Tat_022_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_022_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 9385
	  },
	  {
	    "Name": "TAT_BI_023",
	    "LocalizedName": "Western MC",
	    "HashNameMale": "MP_MP_Biker_Tat_023_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_023_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 10000
	  },
	  {
	    "Name": "TAT_BI_024",
	    "LocalizedName": "Live to Ride",
	    "HashNameMale": "MP_MP_Biker_Tat_024_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_024_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 15320
	  },
	  {
	    "Name": "TAT_BI_025",
	    "LocalizedName": "Good Luck",
	    "HashNameMale": "MP_MP_Biker_Tat_025_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_025_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 12950
	  },
	  {
	    "Name": "TAT_BI_026",
	    "LocalizedName": "American Dream",
	    "HashNameMale": "MP_MP_Biker_Tat_026_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_026_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 11000
	  },
	  {
	    "Name": "TAT_BI_027",
	    "LocalizedName": "Bad Luck",
	    "HashNameMale": "MP_MP_Biker_Tat_027_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_027_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 6960
	  },
	  {
	    "Name": "TAT_BI_028",
	    "LocalizedName": "Dusk Rider",
	    "HashNameMale": "MP_MP_Biker_Tat_028_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_028_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 14520
	  },
	  {
	    "Name": "TAT_BI_029",
	    "LocalizedName": "Bone Wrench",
	    "HashNameMale": "MP_MP_Biker_Tat_029_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_029_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 9630
	  },
	  {
	    "Name": "TAT_BI_030",
	    "LocalizedName": "Brothers For Life",
	    "HashNameMale": "MP_MP_Biker_Tat_030_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_030_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 9810
	  },
	  {
	    "Name": "TAT_BI_031",
	    "LocalizedName": "Gear Head",
	    "HashNameMale": "MP_MP_Biker_Tat_031_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_031_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 8600
	  },
	  {
	    "Name": "TAT_BI_032",
	    "LocalizedName": "Western Eagle",
	    "HashNameMale": "MP_MP_Biker_Tat_032_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_032_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7655
	  },
	  {
	    "Name": "TAT_BI_033",
	    "LocalizedName": "Eagle Emblem",
	    "HashNameMale": "MP_MP_Biker_Tat_033_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_033_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 4385
	  },
	  {
	    "Name": "TAT_BI_034",
	    "LocalizedName": "Brotherhood of Bikes",
	    "HashNameMale": "MP_MP_Biker_Tat_034_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_034_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 9975
	  },
	  {
	    "Name": "TAT_BI_035",
	    "LocalizedName": "Chain Fist",
	    "HashNameMale": "MP_MP_Biker_Tat_035_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_035_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 5780
	  },
	  {
	    "Name": "TAT_BI_036",
	    "LocalizedName": "Engulfed Skull",
	    "HashNameMale": "MP_MP_Biker_Tat_036_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_036_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 9300
	  },
	  {
	    "Name": "TAT_BI_037",
	    "LocalizedName": "Scorched Soul",
	    "HashNameMale": "MP_MP_Biker_Tat_037_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_037_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 12495
	  },
	  {
	    "Name": "TAT_BI_038",
	    "LocalizedName": "FTW",
	    "HashNameMale": "MP_MP_Biker_Tat_038_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_038_F",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 3900
	  },
	  {
	    "Name": "TAT_BI_039",
	    "LocalizedName": "Gas Guzzler",
	    "HashNameMale": "MP_MP_Biker_Tat_039_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_039_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 10950
	  },
	  {
	    "Name": "TAT_BI_040",
	    "LocalizedName": "American Made",
	    "HashNameMale": "MP_MP_Biker_Tat_040_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_040_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 13620
	  },
	  {
	    "Name": "TAT_BI_041",
	    "LocalizedName": "No Regrets",
	    "HashNameMale": "MP_MP_Biker_Tat_041_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_041_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 8320
	  },
	  {
	    "Name": "TAT_BI_042",
	    "LocalizedName": "Grim Rider",
	    "HashNameMale": "MP_MP_Biker_Tat_042_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_042_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 7865
	  },
	  {
	    "Name": "TAT_BI_043",
	    "LocalizedName": "Ride Forever",
	    "HashNameMale": "MP_MP_Biker_Tat_043_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_043_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6850
	  },
	  {
	    "Name": "TAT_BI_044",
	    "LocalizedName": "Ride Free",
	    "HashNameMale": "MP_MP_Biker_Tat_044_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_044_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 11900
	  },
	  {
	    "Name": "TAT_BI_045",
	    "LocalizedName": "Ride Hard Die Fast",
	    "HashNameMale": "MP_MP_Biker_Tat_045_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_045_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 6320
	  },
	  {
	    "Name": "TAT_BI_046",
	    "LocalizedName": "Skull Chain",
	    "HashNameMale": "MP_MP_Biker_Tat_046_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_046_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 4985
	  },
	  {
	    "Name": "TAT_BI_047",
	    "LocalizedName": "Snake Bike",
	    "HashNameMale": "MP_MP_Biker_Tat_047_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_047_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 13500
	  },
	  {
	    "Name": "TAT_BI_048",
	    "LocalizedName": "STFU",
	    "HashNameMale": "MP_MP_Biker_Tat_048_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_048_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 8930
	  },
	  {
	    "Name": "TAT_BI_049",
	    "LocalizedName": "These Colors Don't Run",
	    "HashNameMale": "MP_MP_Biker_Tat_049_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_049_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 8790
	  },
	  {
	    "Name": "TAT_BI_050",
	    "LocalizedName": "Unforgiven",
	    "HashNameMale": "MP_MP_Biker_Tat_050_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_050_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 8720
	  },
	  {
	    "Name": "TAT_BI_051",
	    "LocalizedName": "Western Stylized",
	    "HashNameMale": "MP_MP_Biker_Tat_051_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_051_F",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 4125
	  },
	  {
	    "Name": "TAT_BI_052",
	    "LocalizedName": "Biker Mount",
	    "HashNameMale": "MP_MP_Biker_Tat_052_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_052_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 9135
	  },
	  {
	    "Name": "TAT_BI_053",
	    "LocalizedName": "Muffler Helmet",
	    "HashNameMale": "MP_MP_Biker_Tat_053_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_053_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 8400
	  },
	  {
	    "Name": "TAT_BI_054",
	    "LocalizedName": "Mum",
	    "HashNameMale": "MP_MP_Biker_Tat_054_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_054_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 10450
	  },
	  {
	    "Name": "TAT_BI_055",
	    "LocalizedName": "Poison Scorpion",
	    "HashNameMale": "MP_MP_Biker_Tat_055_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_055_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 10995
	  },
	  {
	    "Name": "TAT_BI_056",
	    "LocalizedName": "Bone Cruiser",
	    "HashNameMale": "MP_MP_Biker_Tat_056_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_056_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 14960
	  },
	  {
	    "Name": "TAT_BI_057",
	    "LocalizedName": "Laughing Skull",
	    "HashNameMale": "MP_MP_Biker_Tat_057_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_057_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 13865
	  },
	  {
	    "Name": "TAT_BI_058",
	    "LocalizedName": "Reaper Vulture",
	    "HashNameMale": "MP_MP_Biker_Tat_058_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_058_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7985
	  },
	  {
	    "Name": "TAT_BI_059",
	    "LocalizedName": "Faggio",
	    "HashNameMale": "MP_MP_Biker_Tat_059_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_059_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6395
	  },
	  {
	    "Name": "TAT_BI_060",
	    "LocalizedName": "We Are The Mods!",
	    "HashNameMale": "MP_MP_Biker_Tat_060_M",
	    "HashNameFemale": "MP_MP_Biker_Tat_060_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7105
	  }
	]
	]],
	mpchristmas2_overlays = [[
	[
	  {
	    "Name": "TAT_X2_000",
	    "LocalizedName": "Skull Rider",
	    "HashNameMale": "MP_Xmas2_M_Tat_000",
	    "HashNameFemale": "MP_Xmas2_F_Tat_000",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 5950
	  },
	  {
	    "Name": "TAT_X2_001",
	    "LocalizedName": "Spider Outline",
	    "HashNameMale": "MP_Xmas2_M_Tat_001",
	    "HashNameFemale": "MP_Xmas2_F_Tat_001",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 4650
	  },
	  {
	    "Name": "TAT_X2_002",
	    "LocalizedName": "Spider Color",
	    "HashNameMale": "MP_Xmas2_M_Tat_002",
	    "HashNameFemale": "MP_Xmas2_F_Tat_002",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 6350
	  },
	  {
	    "Name": "TAT_X2_003",
	    "LocalizedName": "Snake Outline",
	    "HashNameMale": "MP_Xmas2_M_Tat_003",
	    "HashNameFemale": "MP_Xmas2_F_Tat_003",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 8450
	  },
	  {
	    "Name": "TAT_X2_004",
	    "LocalizedName": "Snake Shaded",
	    "HashNameMale": "MP_Xmas2_M_Tat_004",
	    "HashNameFemale": "MP_Xmas2_F_Tat_004",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 13250
	  },
	  {
	    "Name": "TAT_X2_005",
	    "LocalizedName": "Carp Outline",
	    "HashNameMale": "MP_Xmas2_M_Tat_005",
	    "HashNameFemale": "MP_Xmas2_F_Tat_005",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 8750
	  },
	  {
	    "Name": "TAT_X2_006",
	    "LocalizedName": "Carp Shaded",
	    "HashNameMale": "MP_Xmas2_M_Tat_006",
	    "HashNameFemale": "MP_Xmas2_F_Tat_006",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 14500
	  },
	  {
	    "Name": "TAT_X2_007",
	    "LocalizedName": "Los Muertos",
	    "HashNameMale": "MP_Xmas2_M_Tat_007",
	    "HashNameFemale": "MP_Xmas2_F_Tat_007",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 3950
	  },
	  {
	    "Name": "TAT_X2_008",
	    "LocalizedName": "Death Before Dishonor",
	    "HashNameMale": "MP_Xmas2_M_Tat_008",
	    "HashNameFemale": "MP_Xmas2_F_Tat_008",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 4300
	  },
	  {
	    "Name": "TAT_X2_009",
	    "LocalizedName": "Time To Die",
	    "HashNameMale": "MP_Xmas2_M_Tat_009",
	    "HashNameFemale": "MP_Xmas2_F_Tat_009",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7800
	  },
	  {
	    "Name": "TAT_X2_010",
	    "LocalizedName": "Electric Snake",
	    "HashNameMale": "MP_Xmas2_M_Tat_010",
	    "HashNameFemale": "MP_Xmas2_F_Tat_010",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 6200
	  },
	  {
	    "Name": "TAT_X2_011",
	    "LocalizedName": "Roaring Tiger",
	    "HashNameMale": "MP_Xmas2_M_Tat_011",
	    "HashNameFemale": "MP_Xmas2_F_Tat_011",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6850
	  },
	  {
	    "Name": "TAT_X2_012",
	    "LocalizedName": "8 Ball Skull",
	    "HashNameMale": "MP_Xmas2_M_Tat_012",
	    "HashNameFemale": "MP_Xmas2_F_Tat_012",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 8250
	  },
	  {
	    "Name": "TAT_X2_013",
	    "LocalizedName": "Lizard",
	    "HashNameMale": "MP_Xmas2_M_Tat_013",
	    "HashNameFemale": "MP_Xmas2_F_Tat_013",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7900
	  },
	  {
	    "Name": "TAT_X2_014",
	    "LocalizedName": "Floral Dagger",
	    "HashNameMale": "MP_Xmas2_M_Tat_014",
	    "HashNameFemale": "MP_Xmas2_F_Tat_014",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 10500
	  },
	  {
	    "Name": "TAT_X2_015",
	    "LocalizedName": "Japanese Warrior",
	    "HashNameMale": "MP_Xmas2_M_Tat_015",
	    "HashNameFemale": "MP_Xmas2_F_Tat_015",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 11000
	  },
	  {
	    "Name": "TAT_X2_016",
	    "LocalizedName": "Loose Lips Outline",
	    "HashNameMale": "MP_Xmas2_M_Tat_016",
	    "HashNameFemale": "MP_Xmas2_F_Tat_016",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 3150
	  },
	  {
	    "Name": "TAT_X2_017",
	    "LocalizedName": "Loose Lips Color",
	    "HashNameMale": "MP_Xmas2_M_Tat_017",
	    "HashNameFemale": "MP_Xmas2_F_Tat_017",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6350
	  },
	  {
	    "Name": "TAT_X2_018",
	    "LocalizedName": "Royal Dagger Outline",
	    "HashNameMale": "MP_Xmas2_M_Tat_018",
	    "HashNameFemale": "MP_Xmas2_F_Tat_018",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 4300
	  },
	  {
	    "Name": "TAT_X2_019",
	    "LocalizedName": "Royal Dagger Color",
	    "HashNameMale": "MP_Xmas2_M_Tat_019",
	    "HashNameFemale": "MP_Xmas2_F_Tat_019",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7500
	  },
	  {
	    "Name": "TAT_X2_020",
	    "LocalizedName": "Time's Up Outline",
	    "HashNameMale": "MP_Xmas2_M_Tat_020",
	    "HashNameFemale": "MP_Xmas2_F_Tat_020",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 2500
	  },
	  {
	    "Name": "TAT_X2_021",
	    "LocalizedName": "Time's Up Color",
	    "HashNameMale": "MP_Xmas2_M_Tat_021",
	    "HashNameFemale": "MP_Xmas2_F_Tat_021",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 3750
	  },
	  {
	    "Name": "TAT_X2_022",
	    "LocalizedName": "You're Next Outline",
	    "HashNameMale": "MP_Xmas2_M_Tat_022",
	    "HashNameFemale": "MP_Xmas2_F_Tat_022",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 3800
	  },
	  {
	    "Name": "TAT_X2_023",
	    "LocalizedName": "You're Next Color",
	    "HashNameMale": "MP_Xmas2_M_Tat_023",
	    "HashNameFemale": "MP_Xmas2_F_Tat_023",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 5100
	  },
	  {
	    "Name": "TAT_X2_024",
	    "LocalizedName": "Snake Head Outline",
	    "HashNameMale": "MP_Xmas2_M_Tat_024",
	    "HashNameFemale": "MP_Xmas2_F_Tat_024",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 2100
	  },
	  {
	    "Name": "TAT_X2_025",
	    "LocalizedName": "Snake Head Color",
	    "HashNameMale": "MP_Xmas2_M_Tat_025",
	    "HashNameFemale": "MP_Xmas2_F_Tat_025",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 4600
	  },
	  {
	    "Name": "TAT_X2_026",
	    "LocalizedName": "Fuck Luck Outline",
	    "HashNameMale": "MP_Xmas2_M_Tat_026",
	    "HashNameFemale": "MP_Xmas2_F_Tat_026",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 1300
	  },
	  {
	    "Name": "TAT_X2_027",
	    "LocalizedName": "Fuck Luck Color",
	    "HashNameMale": "MP_Xmas2_M_Tat_027",
	    "HashNameFemale": "MP_Xmas2_F_Tat_027",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 2200
	  },
	  {
	    "Name": "TAT_X2_028",
	    "LocalizedName": "Executioner",
	    "HashNameMale": "MP_Xmas2_M_Tat_028",
	    "HashNameFemale": "MP_Xmas2_F_Tat_028",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5700
	  },
	  {
	    "Name": "TAT_X2_029",
	    "LocalizedName": "Beautiful Death",
	    "HashNameMale": "MP_Xmas2_M_Tat_029",
	    "HashNameFemale": "MP_Xmas2_F_Tat_029",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 3150
	  }
	]
	]],
	mphipster_overlays = [[
	[
	  {
	    "Name": "TAT_HP_000",
	    "LocalizedName": "Crossed Arrows",
	    "HashNameMale": "FM_Hip_M_Tat_000",
	    "HashNameFemale": "FM_Hip_F_Tat_000",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6750
	  },
	  {
	    "Name": "TAT_HP_001",
	    "LocalizedName": "Single Arrow",
	    "HashNameMale": "FM_Hip_M_Tat_001",
	    "HashNameFemale": "FM_Hip_F_Tat_001",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 2000
	  },
	  {
	    "Name": "TAT_HP_002",
	    "LocalizedName": "Chemistry",
	    "HashNameMale": "FM_Hip_M_Tat_002",
	    "HashNameFemale": "FM_Hip_F_Tat_002",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2900
	  },
	  {
	    "Name": "TAT_HP_003",
	    "LocalizedName": "Diamond Sparkle",
	    "HashNameMale": "FM_Hip_M_Tat_003",
	    "HashNameFemale": "FM_Hip_F_Tat_003",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 2100
	  },
	  {
	    "Name": "TAT_HP_004",
	    "LocalizedName": "Bone",
	    "HashNameMale": "FM_Hip_M_Tat_004",
	    "HashNameFemale": "FM_Hip_F_Tat_004",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 2900
	  },
	  {
	    "Name": "TAT_HP_005",
	    "LocalizedName": "Beautiful Eye",
	    "HashNameMale": "FM_Hip_M_Tat_005",
	    "HashNameFemale": "FM_Hip_F_Tat_005",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 7450
	  },
	  {
	    "Name": "TAT_HP_006",
	    "LocalizedName": "Feather Birds",
	    "HashNameMale": "FM_Hip_M_Tat_006",
	    "HashNameFemale": "FM_Hip_F_Tat_006",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 4550
	  },
	  {
	    "Name": "TAT_HP_007",
	    "LocalizedName": "Bricks",
	    "HashNameMale": "FM_Hip_M_Tat_007",
	    "HashNameFemale": "FM_Hip_F_Tat_007",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 6000
	  },
	  {
	    "Name": "TAT_HP_008",
	    "LocalizedName": "Cube",
	    "HashNameMale": "FM_Hip_M_Tat_008",
	    "HashNameFemale": "FM_Hip_F_Tat_008",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 4850
	  },
	  {
	    "Name": "TAT_HP_009",
	    "LocalizedName": "Squares",
	    "HashNameMale": "FM_Hip_M_Tat_009",
	    "HashNameFemale": "FM_Hip_F_Tat_009",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 4000
	  },
	  {
	    "Name": "TAT_HP_010",
	    "LocalizedName": "Horseshoe",
	    "HashNameMale": "FM_Hip_M_Tat_010",
	    "HashNameFemale": "FM_Hip_F_Tat_010",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 3150
	  },
	  {
	    "Name": "TAT_HP_011",
	    "LocalizedName": "Infinity",
	    "HashNameMale": "FM_Hip_M_Tat_011",
	    "HashNameFemale": "FM_Hip_F_Tat_011",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 3000
	  },
	  {
	    "Name": "TAT_HP_012",
	    "LocalizedName": "Antlers",
	    "HashNameMale": "FM_Hip_M_Tat_012",
	    "HashNameFemale": "FM_Hip_F_Tat_012",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6500
	  },
	  {
	    "Name": "TAT_HP_013",
	    "LocalizedName": "Boombox",
	    "HashNameMale": "FM_Hip_M_Tat_013",
	    "HashNameFemale": "FM_Hip_F_Tat_013",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6950
	  },
	  {
	    "Name": "TAT_HP_014",
	    "LocalizedName": "Spray Can",
	    "HashNameMale": "FM_Hip_M_Tat_014",
	    "HashNameFemale": "FM_Hip_F_Tat_014",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 4300
	  },
	  {
	    "Name": "TAT_HP_015",
	    "LocalizedName": "Mustache",
	    "HashNameMale": "FM_Hip_M_Tat_015",
	    "HashNameFemale": "FM_Hip_F_Tat_015",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 3400
	  },
	  {
	    "Name": "TAT_HP_016",
	    "LocalizedName": "Lightning Bolt",
	    "HashNameMale": "FM_Hip_M_Tat_016",
	    "HashNameFemale": "FM_Hip_F_Tat_016",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 3700
	  },
	  {
	    "Name": "TAT_HP_017",
	    "LocalizedName": "Eye Triangle",
	    "HashNameMale": "FM_Hip_M_Tat_017",
	    "HashNameFemale": "FM_Hip_F_Tat_017",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 2650
	  },
	  {
	    "Name": "TAT_HP_018",
	    "LocalizedName": "Origami",
	    "HashNameMale": "FM_Hip_M_Tat_018",
	    "HashNameFemale": "FM_Hip_F_Tat_018",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 1800
	  },
	  {
	    "Name": "TAT_HP_019",
	    "LocalizedName": "Charm",
	    "HashNameMale": "FM_Hip_M_Tat_019",
	    "HashNameFemale": "FM_Hip_F_Tat_019",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 3400
	  },
	  {
	    "Name": "TAT_HP_020",
	    "LocalizedName": "Geo Pattern",
	    "HashNameMale": "FM_Hip_M_Tat_020",
	    "HashNameFemale": "FM_Hip_F_Tat_020",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 7350
	  },
	  {
	    "Name": "TAT_HP_021",
	    "LocalizedName": "Geo Fox",
	    "HashNameMale": "FM_Hip_M_Tat_021",
	    "HashNameFemale": "FM_Hip_F_Tat_021",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 7850
	  },
	  {
	    "Name": "TAT_HP_022",
	    "LocalizedName": "Pencil",
	    "HashNameMale": "FM_Hip_M_Tat_022",
	    "HashNameFemale": "FM_Hip_F_Tat_022",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 2250
	  },
	  {
	    "Name": "TAT_HP_023",
	    "LocalizedName": "Smiley",
	    "HashNameMale": "FM_Hip_M_Tat_023",
	    "HashNameFemale": "FM_Hip_F_Tat_023",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 7000
	  },
	  {
	    "Name": "TAT_HP_024",
	    "LocalizedName": "Pyramid",
	    "HashNameMale": "FM_Hip_M_Tat_024",
	    "HashNameFemale": "FM_Hip_F_Tat_024",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2950
	  },
	  {
	    "Name": "TAT_HP_025",
	    "LocalizedName": "Watch Your Step",
	    "HashNameMale": "FM_Hip_M_Tat_025",
	    "HashNameFemale": "FM_Hip_F_Tat_025",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 3500
	  },
	  {
	    "Name": "TAT_HP_026",
	    "LocalizedName": "Pizza",
	    "HashNameMale": "FM_Hip_M_Tat_026",
	    "HashNameFemale": "FM_Hip_F_Tat_026",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 2400
	  },
	  {
	    "Name": "TAT_HP_027",
	    "LocalizedName": "Padlock",
	    "HashNameMale": "FM_Hip_M_Tat_027",
	    "HashNameFemale": "FM_Hip_F_Tat_027",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 5750
	  },
	  {
	    "Name": "TAT_HP_028",
	    "LocalizedName": "Thorny Rose",
	    "HashNameMale": "FM_Hip_M_Tat_028",
	    "HashNameFemale": "FM_Hip_F_Tat_028",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 4800
	  },
	  {
	    "Name": "TAT_HP_029",
	    "LocalizedName": "Sad",
	    "HashNameMale": "FM_Hip_M_Tat_029",
	    "HashNameFemale": "FM_Hip_F_Tat_029",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 1850
	  },
	  {
	    "Name": "TAT_HP_030",
	    "LocalizedName": "Shark Fin",
	    "HashNameMale": "FM_Hip_M_Tat_030",
	    "HashNameFemale": "FM_Hip_F_Tat_030",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2250
	  },
	  {
	    "Name": "TAT_HP_031",
	    "LocalizedName": "Skateboard",
	    "HashNameMale": "FM_Hip_M_Tat_031",
	    "HashNameFemale": "FM_Hip_F_Tat_031",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 4950
	  },
	  {
	    "Name": "TAT_HP_032",
	    "LocalizedName": "Paper Plane",
	    "HashNameMale": "FM_Hip_M_Tat_032",
	    "HashNameFemale": "FM_Hip_F_Tat_032",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 4350
	  },
	  {
	    "Name": "TAT_HP_033",
	    "LocalizedName": "Stag",
	    "HashNameMale": "FM_Hip_M_Tat_033",
	    "HashNameFemale": "FM_Hip_F_Tat_033",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6950
	  },
	  {
	    "Name": "TAT_HP_034",
	    "LocalizedName": "Stop",
	    "HashNameMale": "FM_Hip_M_Tat_034",
	    "HashNameFemale": "FM_Hip_F_Tat_034",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 9500
	  },
	  {
	    "Name": "TAT_HP_035",
	    "LocalizedName": "Sewn Heart",
	    "HashNameMale": "FM_Hip_M_Tat_035",
	    "HashNameFemale": "FM_Hip_F_Tat_035",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7500
	  },
	  {
	    "Name": "TAT_HP_036",
	    "LocalizedName": "Shapes",
	    "HashNameMale": "FM_Hip_M_Tat_036",
	    "HashNameFemale": "FM_Hip_F_Tat_036",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 5150
	  },
	  {
	    "Name": "TAT_HP_037",
	    "LocalizedName": "Sunrise",
	    "HashNameMale": "FM_Hip_M_Tat_037",
	    "HashNameFemale": "FM_Hip_F_Tat_037",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 3750
	  },
	  {
	    "Name": "TAT_HP_038",
	    "LocalizedName": "Grub",
	    "HashNameMale": "FM_Hip_M_Tat_038",
	    "HashNameFemale": "FM_Hip_F_Tat_038",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 3500
	  },
	  {
	    "Name": "TAT_HP_039",
	    "LocalizedName": "Sleeve",
	    "HashNameMale": "FM_Hip_M_Tat_039",
	    "HashNameFemale": "FM_Hip_F_Tat_039",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 10000
	  },
	  {
	    "Name": "TAT_HP_040",
	    "LocalizedName": "Black Anchor",
	    "HashNameMale": "FM_Hip_M_Tat_040",
	    "HashNameFemale": "FM_Hip_F_Tat_040",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 2950
	  },
	  {
	    "Name": "TAT_HP_041",
	    "LocalizedName": "Tooth",
	    "HashNameMale": "FM_Hip_M_Tat_041",
	    "HashNameFemale": "FM_Hip_F_Tat_041",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2575
	  },
	  {
	    "Name": "TAT_HP_042",
	    "LocalizedName": "Sparkplug",
	    "HashNameMale": "FM_Hip_M_Tat_042",
	    "HashNameFemale": "FM_Hip_F_Tat_042",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 4300
	  },
	  {
	    "Name": "TAT_HP_043",
	    "LocalizedName": "Triangle White",
	    "HashNameMale": "FM_Hip_M_Tat_043",
	    "HashNameFemale": "FM_Hip_F_Tat_043",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 5500
	  },
	  {
	    "Name": "TAT_HP_044",
	    "LocalizedName": "Triangle Black",
	    "HashNameMale": "FM_Hip_M_Tat_044",
	    "HashNameFemale": "FM_Hip_F_Tat_044",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 5500
	  },
	  {
	    "Name": "TAT_HP_045",
	    "LocalizedName": "Mesh Band",
	    "HashNameMale": "FM_Hip_M_Tat_045",
	    "HashNameFemale": "FM_Hip_F_Tat_045",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 4000
	  },
	  {
	    "Name": "TAT_HP_046",
	    "LocalizedName": "Triangles",
	    "HashNameMale": "FM_Hip_M_Tat_046",
	    "HashNameFemale": "FM_Hip_F_Tat_046",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 3750
	  },
	  {
	    "Name": "TAT_HP_047",
	    "LocalizedName": "Cassette",
	    "HashNameMale": "FM_Hip_M_Tat_047",
	    "HashNameFemale": "FM_Hip_F_Tat_047",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 1900
	  },
	  {
	    "Name": "TAT_HP_048",
	    "LocalizedName": "Peace",
	    "HashNameMale": "FM_Hip_M_Tat_048",
	    "HashNameFemale": "FM_Hip_F_Tat_048",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 7850
	  }
	]
	]],
	mplowrider2_overlays = [[
	[
	  {
	    "Name": "TAT_S2_000",
	    "LocalizedName": "SA Assault",
	    "HashNameMale": "MP_LR_Tat_000_M",
	    "HashNameFemale": "MP_LR_Tat_000_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 19000
	  },
	  {
	    "Name": "TAT_S2_003",
	    "LocalizedName": "Lady Vamp",
	    "HashNameMale": "MP_LR_Tat_003_M",
	    "HashNameFemale": "MP_LR_Tat_003_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 5950
	  },
	  {
	    "Name": "TAT_S2_006",
	    "LocalizedName": "Love Hustle",
	    "HashNameMale": "MP_LR_Tat_006_M",
	    "HashNameFemale": "MP_LR_Tat_006_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 7450
	  },
	  {
	    "Name": "TAT_S2_008",
	    "LocalizedName": "Love the Game",
	    "HashNameMale": "MP_LR_Tat_008_M",
	    "HashNameFemale": "MP_LR_Tat_008_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 18750
	  },
	  {
	    "Name": "TAT_S2_011",
	    "LocalizedName": "Lady Liberty",
	    "HashNameMale": "MP_LR_Tat_011_M",
	    "HashNameFemale": "MP_LR_Tat_011_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 8000
	  },
	  {
	    "Name": "TAT_S2_012",
	    "LocalizedName": "Royal Kiss",
	    "HashNameMale": "MP_LR_Tat_012_M",
	    "HashNameFemale": "MP_LR_Tat_012_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7650
	  },
	  {
	    "Name": "TAT_S2_016",
	    "LocalizedName": "Two Face",
	    "HashNameMale": "MP_LR_Tat_016_M",
	    "HashNameFemale": "MP_LR_Tat_016_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6400
	  },
	  {
	    "Name": "TAT_S2_018",
	    "LocalizedName": "Skeleton Party",
	    "HashNameMale": "MP_LR_Tat_018_M",
	    "HashNameFemale": "MP_LR_Tat_018_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 11000
	  },
	  {
	    "Name": "TAT_S2_019",
	    "LocalizedName": "Death Behind",
	    "HashNameMale": "MP_LR_Tat_019_M",
	    "HashNameFemale": "MP_LR_Tat_019_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 9750
	  },
	  {
	    "Name": "TAT_S2_022",
	    "LocalizedName": "My Crazy Life",
	    "HashNameMale": "MP_LR_Tat_022_M",
	    "HashNameFemale": "MP_LR_Tat_022_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 7350
	  },
	  {
	    "Name": "TAT_S2_028",
	    "LocalizedName": "Loving Los Muertos",
	    "HashNameMale": "MP_LR_Tat_028_M",
	    "HashNameFemale": "MP_LR_Tat_028_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 8800
	  },
	  {
	    "Name": "TAT_S2_029",
	    "LocalizedName": "Death Us Do Part",
	    "HashNameMale": "MP_LR_Tat_029_M",
	    "HashNameFemale": "MP_LR_Tat_029_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 6250
	  },
	  {
	    "Name": "TAT_S2_030",
	    "LocalizedName": "San Andreas Prayer",
	    "HashNameMale": "MP_LR_Tat_030_M",
	    "HashNameFemale": "MP_LR_Tat_030_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 8150
	  },
	  {
	    "Name": "TAT_S2_031",
	    "LocalizedName": "Dead Pretty",
	    "HashNameMale": "MP_LR_Tat_031_M",
	    "HashNameFemale": "MP_LR_Tat_031_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 16500
	  },
	  {
	    "Name": "TAT_S2_032",
	    "LocalizedName": "Reign Over",
	    "HashNameMale": "MP_LR_Tat_032_M",
	    "HashNameFemale": "MP_LR_Tat_032_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 18500
	  },
	  {
	    "Name": "TAT_S2_035",
	    "LocalizedName": "Black Tears",
	    "HashNameMale": "MP_LR_Tat_035_M",
	    "HashNameFemale": "MP_LR_Tat_035_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 8250
	  }
	]
	]],
	mpluxe2_overlays = [[
	[
	  {
	    "Name": "TAT_L2_002",
	    "LocalizedName": "The Howler",
	    "HashNameMale": "MP_LUXE_TAT_002_M",
	    "HashNameFemale": "MP_LUXE_TAT_002_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 11000
	  },
	  {
	    "Name": "TAT_L2_005",
	    "LocalizedName": "Fatal Dagger",
	    "HashNameMale": "MP_LUXE_TAT_005_M",
	    "HashNameFemale": "MP_LUXE_TAT_005_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 10250
	  },
	  {
	    "Name": "TAT_L2_010",
	    "LocalizedName": "Intrometric",
	    "HashNameMale": "MP_LUXE_TAT_010_M",
	    "HashNameFemale": "MP_LUXE_TAT_010_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 14650
	  },
	  {
	    "Name": "TAT_L2_011",
	    "LocalizedName": "Cross of Roses",
	    "HashNameMale": "MP_LUXE_TAT_011_M",
	    "HashNameFemale": "MP_LUXE_TAT_011_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 13250
	  },
	  {
	    "Name": "TAT_L2_012",
	    "LocalizedName": "Geometric Galaxy",
	    "HashNameMale": "MP_LUXE_TAT_012_M",
	    "HashNameFemale": "MP_LUXE_TAT_012_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 26500
	  },
	  {
	    "Name": "TAT_L2_016",
	    "LocalizedName": "Egyptian Mural",
	    "HashNameMale": "MP_LUXE_TAT_016_M",
	    "HashNameFemale": "MP_LUXE_TAT_016_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 18600
	  },
	  {
	    "Name": "TAT_L2_017",
	    "LocalizedName": "Heavenly Deity",
	    "HashNameMale": "MP_LUXE_TAT_017_M",
	    "HashNameFemale": "MP_LUXE_TAT_017_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 21550
	  },
	  {
	    "Name": "TAT_L2_018",
	    "LocalizedName": "Divine Goddess",
	    "HashNameMale": "MP_LUXE_TAT_018_M",
	    "HashNameFemale": "MP_LUXE_TAT_018_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 23400
	  },
	  {
	    "Name": "TAT_L2_022",
	    "LocalizedName": "Cloaked Angel",
	    "HashNameMale": "MP_LUXE_TAT_022_M",
	    "HashNameFemale": "MP_LUXE_TAT_022_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 28500
	  },
	  {
	    "Name": "TAT_L2_023",
	    "LocalizedName": "Starmetric",
	    "HashNameMale": "MP_LUXE_TAT_023_M",
	    "HashNameFemale": "MP_LUXE_TAT_023_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 15600
	  },
	  {
	    "Name": "TAT_L2_025",
	    "LocalizedName": "Reaper Sway",
	    "HashNameMale": "MP_LUXE_TAT_025_M",
	    "HashNameFemale": "MP_LUXE_TAT_025_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 11500
	  },
	  {
	    "Name": "TAT_L2_026",
	    "LocalizedName": "Floral Print",
	    "HashNameMale": "MP_LUXE_TAT_026_M",
	    "HashNameFemale": "MP_LUXE_TAT_026_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 14700
	  },
	  {
	    "Name": "TAT_L2_027",
	    "LocalizedName": "Cobra Dawn",
	    "HashNameMale": "MP_LUXE_TAT_027_M",
	    "HashNameFemale": "MP_LUXE_TAT_027_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 12750
	  },
	  {
	    "Name": "TAT_L2_028",
	    "LocalizedName": "Python Skull",
	    "HashNameMale": "MP_LUXE_TAT_028_M",
	    "HashNameFemale": "MP_LUXE_TAT_028_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 11300
	  },
	  {
	    "Name": "TAT_L2_029",
	    "LocalizedName": "Geometric Design",
	    "HashNameMale": "MP_LUXE_TAT_029_M",
	    "HashNameFemale": "MP_LUXE_TAT_029_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 30000
	  },
	  {
	    "Name": "TAT_L2_030",
	    "LocalizedName": "Geometric Design",
	    "HashNameMale": "MP_LUXE_TAT_030_M",
	    "HashNameFemale": "MP_LUXE_TAT_030_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 0
	  },
	  {
	    "Name": "TAT_L2_031",
	    "LocalizedName": "Geometric Design",
	    "HashNameMale": "MP_LUXE_TAT_031_M",
	    "HashNameFemale": "MP_LUXE_TAT_031_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 0
	  }
	]
	]],
	multiplayer_overlays = [[
	[
	  {
	    "Name": "TAT_FM_008",
	    "LocalizedName": "Skull",
	    "HashNameMale": "FM_Tat_Award_M_000",
	    "HashNameFemale": "FM_Tat_Award_F_000",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 20000
	  },
	  {
	    "Name": "TAT_FM_009",
	    "LocalizedName": "Burning Heart",
	    "HashNameMale": "FM_Tat_Award_M_001",
	    "HashNameFemale": "FM_Tat_Award_F_001",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 1400
	  },
	  {
	    "Name": "TAT_FM_010",
	    "LocalizedName": "Grim Reaper Smoking Gun",
	    "HashNameMale": "FM_Tat_Award_M_002",
	    "HashNameFemale": "FM_Tat_Award_F_002",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 9750
	  },
	  {
	    "Name": "TAT_FM_011",
	    "LocalizedName": "Blackjack",
	    "HashNameMale": "FM_Tat_Award_M_003",
	    "HashNameFemale": "FM_Tat_Award_F_003",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2150
	  },
	  {
	    "Name": "TAT_FM_012",
	    "LocalizedName": "Hustler",
	    "HashNameMale": "FM_Tat_Award_M_004",
	    "HashNameFemale": "FM_Tat_Award_F_004",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 10000
	  },
	  {
	    "Name": "TAT_FM_013",
	    "LocalizedName": "Angel",
	    "HashNameMale": "FM_Tat_Award_M_005",
	    "HashNameFemale": "FM_Tat_Award_F_005",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 12400
	  },
	  {
	    "Name": "TAT_FM_014",
	    "LocalizedName": "Skull and Sword",
	    "HashNameMale": "FM_Tat_Award_M_006",
	    "HashNameFemale": "FM_Tat_Award_F_006",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 3500
	  },
	  {
	    "Name": "TAT_FM_015",
	    "LocalizedName": "Racing Blonde",
	    "HashNameMale": "FM_Tat_Award_M_007",
	    "HashNameFemale": "FM_Tat_Award_F_007",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 4950
	  },
	  {
	    "Name": "TAT_FM_016",
	    "LocalizedName": "Los Santos Customs",
	    "HashNameMale": "FM_Tat_Award_M_008",
	    "HashNameFemale": "FM_Tat_Award_F_008",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 1350
	  },
	  {
	    "Name": "TAT_FM_017",
	    "LocalizedName": "Dragon and Dagger",
	    "HashNameMale": "FM_Tat_Award_M_009",
	    "HashNameFemale": "FM_Tat_Award_F_009",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 1450
	  },
	  {
	    "Name": "TAT_FM_018",
	    "LocalizedName": "Ride or Die",
	    "HashNameMale": "FM_Tat_Award_M_010",
	    "HashNameFemale": "FM_Tat_Award_F_010",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 2700
	  },
	  {
	    "Name": "TAT_FM_019",
	    "LocalizedName": "Blank Scroll",
	    "HashNameMale": "FM_Tat_Award_M_011",
	    "HashNameFemale": "FM_Tat_Award_F_011",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 1200
	  },
	  {
	    "Name": "TAT_FM_020",
	    "LocalizedName": "Embellished Scroll",
	    "HashNameMale": "FM_Tat_Award_M_012",
	    "HashNameFemale": "FM_Tat_Award_F_012",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 1500
	  },
	  {
	    "Name": "TAT_FM_021",
	    "LocalizedName": "Seven Deadly Sins",
	    "HashNameMale": "FM_Tat_Award_M_013",
	    "HashNameFemale": "FM_Tat_Award_F_013",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2650
	  },
	  {
	    "Name": "TAT_FM_022",
	    "LocalizedName": "Trust No One",
	    "HashNameMale": "FM_Tat_Award_M_014",
	    "HashNameFemale": "FM_Tat_Award_F_014",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 1900
	  },
	  {
	    "Name": "TAT_FM_023",
	    "LocalizedName": "Racing Brunette",
	    "HashNameMale": "FM_Tat_Award_M_015",
	    "HashNameFemale": "FM_Tat_Award_F_015",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 4950
	  },
	  {
	    "Name": "TAT_FM_024",
	    "LocalizedName": "Clown",
	    "HashNameMale": "FM_Tat_Award_M_016",
	    "HashNameFemale": "FM_Tat_Award_F_016",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2400
	  },
	  {
	    "Name": "TAT_FM_025",
	    "LocalizedName": "Clown and Gun",
	    "HashNameMale": "FM_Tat_Award_M_017",
	    "HashNameFemale": "FM_Tat_Award_F_017",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5100
	  },
	  {
	    "Name": "TAT_FM_026",
	    "LocalizedName": "Clown Dual Wield",
	    "HashNameMale": "FM_Tat_Award_M_018",
	    "HashNameFemale": "FM_Tat_Award_F_018",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7400
	  },
	  {
	    "Name": "TAT_FM_027",
	    "LocalizedName": "Clown Dual Wield Dollars",
	    "HashNameMale": "FM_Tat_Award_M_019",
	    "HashNameFemale": "FM_Tat_Award_F_019",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 10000
	  },
	  {
	    "Name": "TAT_FM_204",
	    "LocalizedName": "Brotherhood",
	    "HashNameMale": "FM_Tat_M_000",
	    "HashNameFemale": "FM_Tat_F_000",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 10000
	  },
	  {
	    "Name": "TAT_FM_205",
	    "LocalizedName": "Dragons",
	    "HashNameMale": "FM_Tat_M_001",
	    "HashNameFemale": "FM_Tat_F_001",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 12500
	  },
	  {
	    "Name": "TAT_FM_209",
	    "LocalizedName": "Melting Skull",
	    "HashNameMale": "FM_Tat_M_002",
	    "HashNameFemale": "FM_Tat_F_002",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 3750
	  },
	  {
	    "Name": "TAT_FM_206",
	    "LocalizedName": "Dragons and Skull",
	    "HashNameMale": "FM_Tat_M_003",
	    "HashNameFemale": "FM_Tat_F_003",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 10000
	  },
	  {
	    "Name": "TAT_FM_219",
	    "LocalizedName": "Faith",
	    "HashNameMale": "FM_Tat_M_004",
	    "HashNameFemale": "FM_Tat_F_004",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 10000
	  },
	  {
	    "Name": "TAT_FM_201",
	    "LocalizedName": "Serpents",
	    "HashNameMale": "FM_Tat_M_005",
	    "HashNameFemale": "FM_Tat_F_005",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 2400
	  },
	  {
	    "Name": "TAT_FM_202",
	    "LocalizedName": "Oriental Mural",
	    "HashNameMale": "FM_Tat_M_006",
	    "HashNameFemale": "FM_Tat_F_006",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 5100
	  },
	  {
	    "Name": "TAT_FM_210",
	    "LocalizedName": "The Warrior",
	    "HashNameMale": "FM_Tat_M_007",
	    "HashNameFemale": "FM_Tat_F_007",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 3750
	  },
	  {
	    "Name": "TAT_FM_211",
	    "LocalizedName": "Dragon Mural",
	    "HashNameMale": "FM_Tat_M_008",
	    "HashNameFemale": "FM_Tat_F_008",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 4800
	  },
	  {
	    "Name": "TAT_FM_213",
	    "LocalizedName": "Skull on the Cross",
	    "HashNameMale": "FM_Tat_M_009",
	    "HashNameFemale": "FM_Tat_F_009",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 12350
	  },
	  {
	    "Name": "TAT_FM_218",
	    "LocalizedName": "LS Flames",
	    "HashNameMale": "FM_Tat_M_010",
	    "HashNameFemale": "FM_Tat_F_010",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2500
	  },
	  {
	    "Name": "TAT_FM_214",
	    "LocalizedName": "LS Script",
	    "HashNameMale": "FM_Tat_M_011",
	    "HashNameFemale": "FM_Tat_F_011",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 1900
	  },
	  {
	    "Name": "TAT_FM_220",
	    "LocalizedName": "Los Santos Bills",
	    "HashNameMale": "FM_Tat_M_012",
	    "HashNameFemale": "FM_Tat_F_012",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 10000
	  },
	  {
	    "Name": "TAT_FM_215",
	    "LocalizedName": "Eagle and Serpent",
	    "HashNameMale": "FM_Tat_M_013",
	    "HashNameFemale": "FM_Tat_F_013",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 4500
	  },
	  {
	    "Name": "TAT_FM_207",
	    "LocalizedName": "Flower Mural",
	    "HashNameMale": "FM_Tat_M_014",
	    "HashNameFemale": "FM_Tat_F_014",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 5000
	  },
	  {
	    "Name": "TAT_FM_203",
	    "LocalizedName": "Zodiac Skull",
	    "HashNameMale": "FM_Tat_M_015",
	    "HashNameFemale": "FM_Tat_F_015",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 3600
	  },
	  {
	    "Name": "TAT_FM_216",
	    "LocalizedName": "Evil Clown",
	    "HashNameMale": "FM_Tat_M_016",
	    "HashNameFemale": "FM_Tat_F_016",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 12250
	  },
	  {
	    "Name": "TAT_FM_212",
	    "LocalizedName": "Tribal",
	    "HashNameMale": "FM_Tat_M_017",
	    "HashNameFemale": "FM_Tat_F_017",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 3500
	  },
	  {
	    "Name": "TAT_FM_208",
	    "LocalizedName": "Serpent Skull",
	    "HashNameMale": "FM_Tat_M_018",
	    "HashNameFemale": "FM_Tat_F_018",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 7500
	  },
	  {
	    "Name": "TAT_FM_217",
	    "LocalizedName": "The Wages of Sin",
	    "HashNameMale": "FM_Tat_M_019",
	    "HashNameFemale": "FM_Tat_F_019",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 12300
	  },
	  {
	    "Name": "TAT_FM_221",
	    "LocalizedName": "Dragon",
	    "HashNameMale": "FM_Tat_M_020",
	    "HashNameFemale": "FM_Tat_F_020",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7500
	  },
	  {
	    "Name": "TAT_FM_222",
	    "LocalizedName": "Serpent Skull",
	    "HashNameMale": "FM_Tat_M_021",
	    "HashNameFemale": "FM_Tat_F_021",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 5000
	  },
	  {
	    "Name": "TAT_FM_223",
	    "LocalizedName": "Fiery Dragon",
	    "HashNameMale": "FM_Tat_M_022",
	    "HashNameFemale": "FM_Tat_F_022",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 7300
	  },
	  {
	    "Name": "TAT_FM_224",
	    "LocalizedName": "Hottie",
	    "HashNameMale": "FM_Tat_M_023",
	    "HashNameFemale": "FM_Tat_F_023",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 7250
	  },
	  {
	    "Name": "TAT_FM_225",
	    "LocalizedName": "Flaming Cross",
	    "HashNameMale": "FM_Tat_M_024",
	    "HashNameFemale": "FM_Tat_F_024",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 11900
	  },
	  {
	    "Name": "TAT_FM_226",
	    "LocalizedName": "LS Bold",
	    "HashNameMale": "FM_Tat_M_025",
	    "HashNameFemale": "FM_Tat_F_025",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2750
	  },
	  {
	    "Name": "TAT_FM_227",
	    "LocalizedName": "Smoking Dagger",
	    "HashNameMale": "FM_Tat_M_026",
	    "HashNameFemale": "FM_Tat_F_026",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 1750
	  },
	  {
	    "Name": "TAT_FM_228",
	    "LocalizedName": "Virgin Mary",
	    "HashNameMale": "FM_Tat_M_027",
	    "HashNameFemale": "FM_Tat_F_027",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 7300
	  },
	  {
	    "Name": "TAT_FM_229",
	    "LocalizedName": "Mermaid",
	    "HashNameMale": "FM_Tat_M_028",
	    "HashNameFemale": "FM_Tat_F_028",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 3250
	  },
	  {
	    "Name": "TAT_FM_230",
	    "LocalizedName": "Trinity Knot",
	    "HashNameMale": "FM_Tat_M_029",
	    "HashNameFemale": "FM_Tat_F_029",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 1000
	  },
	  {
	    "Name": "TAT_FM_231",
	    "LocalizedName": "Lucky Celtic Dogs",
	    "HashNameMale": "FM_Tat_M_030",
	    "HashNameFemale": "FM_Tat_F_030",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5000
	  },
	  {
	    "Name": "TAT_FM_232",
	    "LocalizedName": "Lady M",
	    "HashNameMale": "FM_Tat_M_031",
	    "HashNameFemale": "FM_Tat_F_031",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 7500
	  },
	  {
	    "Name": "TAT_FM_233",
	    "LocalizedName": "Faith",
	    "HashNameMale": "FM_Tat_M_032",
	    "HashNameFemale": "FM_Tat_F_032",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 5100
	  },
	  {
	    "Name": "TAT_FM_234",
	    "LocalizedName": "Chinese Dragon",
	    "HashNameMale": "FM_Tat_M_033",
	    "HashNameFemale": "FM_Tat_F_033",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 5050
	  },
	  {
	    "Name": "TAT_FM_235",
	    "LocalizedName": "Flaming Shamrock",
	    "HashNameMale": "FM_Tat_M_034",
	    "HashNameFemale": "FM_Tat_F_034",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2450
	  },
	  {
	    "Name": "TAT_FM_236",
	    "LocalizedName": "Dragon",
	    "HashNameMale": "FM_Tat_M_035",
	    "HashNameFemale": "FM_Tat_F_035",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 4950
	  },
	  {
	    "Name": "TAT_FM_237",
	    "LocalizedName": "Way of the Gun",
	    "HashNameMale": "FM_Tat_M_036",
	    "HashNameFemale": "FM_Tat_F_036",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5100
	  },
	  {
	    "Name": "TAT_FM_238",
	    "LocalizedName": "Grim Reaper",
	    "HashNameMale": "FM_Tat_M_037",
	    "HashNameFemale": "FM_Tat_F_037",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 12250
	  },
	  {
	    "Name": "TAT_FM_239",
	    "LocalizedName": "Dagger",
	    "HashNameMale": "FM_Tat_M_038",
	    "HashNameFemale": "FM_Tat_F_038",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 1150
	  },
	  {
	    "Name": "TAT_FM_240",
	    "LocalizedName": "Broken Skull",
	    "HashNameMale": "FM_Tat_M_039",
	    "HashNameFemale": "FM_Tat_F_039",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 7500
	  },
	  {
	    "Name": "TAT_FM_241",
	    "LocalizedName": "Flaming Skull",
	    "HashNameMale": "FM_Tat_M_040",
	    "HashNameFemale": "FM_Tat_F_040",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 7600
	  },
	  {
	    "Name": "TAT_FM_242",
	    "LocalizedName": "Dope Skull",
	    "HashNameMale": "FM_Tat_M_041",
	    "HashNameFemale": "FM_Tat_F_041",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 2600
	  },
	  {
	    "Name": "TAT_FM_243",
	    "LocalizedName": "Flaming Scorpion",
	    "HashNameMale": "FM_Tat_M_042",
	    "HashNameFemale": "FM_Tat_F_042",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 2500
	  },
	  {
	    "Name": "TAT_FM_244",
	    "LocalizedName": "Indian Ram",
	    "HashNameMale": "FM_Tat_M_043",
	    "HashNameFemale": "FM_Tat_F_043",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 7450
	  },
	  {
	    "Name": "TAT_FM_245",
	    "LocalizedName": "Stone Cross",
	    "HashNameMale": "FM_Tat_M_044",
	    "HashNameFemale": "FM_Tat_F_044",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7500
	  },
	  {
	    "Name": "TAT_FM_246",
	    "LocalizedName": "Skulls and Rose",
	    "HashNameMale": "FM_Tat_M_045",
	    "HashNameFemale": "FM_Tat_F_045",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 10000
	  },
	  {
	    "Name": "TAT_FM_247",
	    "LocalizedName": "Lion",
	    "HashNameMale": "FM_Tat_M_047",
	    "HashNameFemale": "FM_Tat_F_047",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 2500
	  }
	]
	]],
	mpbeach_overlays = [[
	[
	  {
	    "Name": "TAT_BB_018",
	    "LocalizedName": "Ship Arms",
	    "HashNameMale": "MP_Bea_M_Back_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7250
	  },
	  {
	    "Name": "TAT_BB_019",
	    "LocalizedName": "Tribal Hammerhead",
	    "HashNameMale": "MP_Bea_M_Chest_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5800
	  },
	  {
	    "Name": "TAT_BB_020",
	    "LocalizedName": "Tribal Shark",
	    "HashNameMale": "MP_Bea_M_Chest_001",
	    "HashNameFemale": "",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5900
	  },
	  {
	    "Name": "TAT_BB_021",
	    "LocalizedName": "Pirate Skull",
	    "HashNameMale": "MP_Bea_M_Head_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 12000
	  },
	  {
	    "Name": "TAT_BB_022",
	    "LocalizedName": "Surf LS",
	    "HashNameMale": "MP_Bea_M_Head_001",
	    "HashNameFemale": "",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 1450
	  },
	  {
	    "Name": "TAT_BB_031",
	    "LocalizedName": "Shark",
	    "HashNameMale": "MP_Bea_M_Head_002",
	    "HashNameFemale": "",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 1850
	  },
	  {
	    "Name": "TAT_BB_027",
	    "LocalizedName": "Tribal Star",
	    "HashNameMale": "MP_Bea_M_Lleg_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 4450
	  },
	  {
	    "Name": "TAT_BB_025",
	    "LocalizedName": "Tribal Tiki Tower",
	    "HashNameMale": "MP_Bea_M_Rleg_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 6500
	  },
	  {
	    "Name": "TAT_BB_026",
	    "LocalizedName": "Tribal Sun",
	    "HashNameMale": "MP_Bea_M_RArm_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 6200
	  },
	  {
	    "Name": "TAT_BB_024",
	    "LocalizedName": "Tiki Tower",
	    "HashNameMale": "MP_Bea_M_LArm_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 4800
	  },
	  {
	    "Name": "TAT_BB_017",
	    "LocalizedName": "Mermaid L.S.",
	    "HashNameMale": "MP_Bea_M_LArm_001",
	    "HashNameFemale": "",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 6600
	  },
	  {
	    "Name": "TAT_BB_028",
	    "LocalizedName": "Little Fish",
	    "HashNameMale": "MP_Bea_M_Neck_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 1650
	  },
	  {
	    "Name": "TAT_BB_029",
	    "LocalizedName": "Surfs Up",
	    "HashNameMale": "MP_Bea_M_Neck_001",
	    "HashNameFemale": "",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 2250
	  },
	  {
	    "Name": "TAT_BB_030",
	    "LocalizedName": "Vespucci Beauty",
	    "HashNameMale": "MP_Bea_M_RArm_001",
	    "HashNameFemale": "",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 7000
	  },
	  {
	    "Name": "TAT_BB_023",
	    "LocalizedName": "Swordfish",
	    "HashNameMale": "MP_Bea_M_Stom_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 3100
	  },
	  {
	    "Name": "TAT_BB_032",
	    "LocalizedName": "Wheel",
	    "HashNameMale": "MP_Bea_M_Stom_001",
	    "HashNameFemale": "",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5500
	  },
	  {
	    "Name": "TAT_BB_003",
	    "LocalizedName": "Rock Solid",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Back_000",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5500
	  },
	  {
	    "Name": "TAT_BB_001",
	    "LocalizedName": "Hibiscus Flower Duo",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Back_001",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6900
	  },
	  {
	    "Name": "TAT_BB_005",
	    "LocalizedName": "Shrimp",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Back_002",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2500
	  },
	  {
	    "Name": "TAT_BB_012",
	    "LocalizedName": "Anchor",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Chest_000",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2500
	  },
	  {
	    "Name": "TAT_BB_013",
	    "LocalizedName": "Anchor",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Chest_001",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2500
	  },
	  {
	    "Name": "TAT_BB_000",
	    "LocalizedName": "Los Santos Wreath",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Chest_002",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 8500
	  },
	  {
	    "Name": "TAT_BB_006",
	    "LocalizedName": "Love Dagger",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_RSide_000",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6850
	  },
	  {
	    "Name": "TAT_BB_007",
	    "LocalizedName": "School of Fish",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_RLeg_000",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 2950
	  },
	  {
	    "Name": "TAT_BB_015",
	    "LocalizedName": "Tribal Fish",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_RArm_001",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 3700
	  },
	  {
	    "Name": "TAT_BB_008",
	    "LocalizedName": "Tribal Butterfly",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Neck_000",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 1700
	  },
	  {
	    "Name": "TAT_BB_011",
	    "LocalizedName": "Sea Horses",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Should_000",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5100
	  },
	  {
	    "Name": "TAT_BB_004",
	    "LocalizedName": "Catfish",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Should_001",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5250
	  },
	  {
	    "Name": "TAT_BB_014",
	    "LocalizedName": "Swallow",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Stom_000",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2100
	  },
	  {
	    "Name": "TAT_BB_009",
	    "LocalizedName": "Hibiscus Flower",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Stom_001",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 2650
	  },
	  {
	    "Name": "TAT_BB_010",
	    "LocalizedName": "Dolphin",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_Stom_002",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 1900
	  },
	  {
	    "Name": "TAT_BB_002",
	    "LocalizedName": "Tribal Flower",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_LArm_000",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 3500
	  },
	  {
	    "Name": "TAT_BB_016",
	    "LocalizedName": "Parrot",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Bea_F_LArm_001",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 5250
	  }
	]
	]],
	mpbusiness_overlays = [[
	[
	  {
	    "Name": "TAT_BUS_005",
	    "LocalizedName": "Cash is King",
	    "HashNameMale": "MP_Buis_M_Neck_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 5000
	  },
	  {
	    "Name": "TAT_BUS_006",
	    "LocalizedName": "Bold Dollar Sign",
	    "HashNameMale": "MP_Buis_M_Neck_001",
	    "HashNameFemale": "",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 1600
	  },
	  {
	    "Name": "TAT_BUS_007",
	    "LocalizedName": "Script Dollar Sign",
	    "HashNameMale": "MP_Buis_M_Neck_002",
	    "HashNameFemale": "",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 1750
	  },
	  {
	    "Name": "TAT_BUS_008",
	    "LocalizedName": "$100",
	    "HashNameMale": "MP_Buis_M_Neck_003",
	    "HashNameFemale": "",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 6900
	  },
	  {
	    "Name": "TAT_BUS_003",
	    "LocalizedName": "$100 Bill",
	    "HashNameMale": "MP_Buis_M_LeftArm_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 3500
	  },
	  {
	    "Name": "TAT_BUS_004",
	    "LocalizedName": "All-Seeing Eye",
	    "HashNameMale": "MP_Buis_M_LeftArm_001",
	    "HashNameFemale": "",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 7300
	  },
	  {
	    "Name": "TAT_BUS_009",
	    "LocalizedName": "Dollar Skull",
	    "HashNameMale": "MP_Buis_M_RightArm_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 4800
	  },
	  {
	    "Name": "TAT_BUS_010",
	    "LocalizedName": "Green",
	    "HashNameMale": "MP_Buis_M_RightArm_001",
	    "HashNameFemale": "",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 1500
	  },
	  {
	    "Name": "TAT_BUS_011",
	    "LocalizedName": "Refined Hustler",
	    "HashNameMale": "MP_Buis_M_Stomach_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6400
	  },
	  {
	    "Name": "TAT_BUS_001",
	    "LocalizedName": "Rich",
	    "HashNameMale": "MP_Buis_M_Chest_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 3250
	  },
	  {
	    "Name": "TAT_BUS_002",
	    "LocalizedName": "$$$",
	    "HashNameMale": "MP_Buis_M_Chest_001",
	    "HashNameFemale": "",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 3500
	  },
	  {
	    "Name": "TAT_BUS_000",
	    "LocalizedName": "Makin' Paper",
	    "HashNameMale": "MP_Buis_M_Back_000",
	    "HashNameFemale": "",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5500
	  },
	  {
	    "Name": "TAT_BUS_F_002",
	    "LocalizedName": "High Roller",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Buis_F_Chest_000",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7000
	  },
	  {
	    "Name": "TAT_BUS_F_003",
	    "LocalizedName": "Makin' Money",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Buis_F_Chest_001",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7200
	  },
	  {
	    "Name": "TAT_BUS_F_004",
	    "LocalizedName": "Love Money",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Buis_F_Chest_002",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 1600
	  },
	  {
	    "Name": "TAT_BUS_F_011",
	    "LocalizedName": "Diamond Back",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Buis_F_Stom_000",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6800
	  },
	  {
	    "Name": "TAT_BUS_F_012",
	    "LocalizedName": "Santo Capra Logo",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Buis_F_Stom_001",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 1800
	  },
	  {
	    "Name": "TAT_BUS_F_013",
	    "LocalizedName": "Money Bag",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Buis_F_Stom_002",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 1500
	  },
	  {
	    "Name": "TAT_BUS_F_000",
	    "LocalizedName": "Respect",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Buis_F_Back_000",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 4200
	  },
	  {
	    "Name": "TAT_BUS_F_001",
	    "LocalizedName": "Gold Digger",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Buis_F_Back_001",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 4000
	  },
	  {
	    "Name": "TAT_BUS_F_007",
	    "LocalizedName": "Val-de-Grace Logo",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Buis_F_Neck_000",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 1900
	  },
	  {
	    "Name": "TAT_BUS_F_008",
	    "LocalizedName": "Money Rose",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Buis_F_Neck_001",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 2500
	  },
	  {
	    "Name": "TAT_BUS_F_009",
	    "LocalizedName": "Dollar Sign",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Buis_F_RArm_000",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 4900
	  },
	  {
	    "Name": "TAT_BUS_F_005",
	    "LocalizedName": "Greed is Good",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Buis_F_LArm_000",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 5500
	  },
	  {
	    "Name": "TAT_BUS_F_006",
	    "LocalizedName": "Single",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Buis_F_LLeg_000",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 4850
	  },
	  {
	    "Name": "TAT_BUS_F_010",
	    "LocalizedName": "Diamond Crown",
	    "HashNameMale": "",
	    "HashNameFemale": "MP_Buis_F_RLeg_000",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 4500
	  }
	]
	]],
	mpgunrunning_overlays = [[
	[
	  {
	    "Name": "TAT_GR_000",
	    "LocalizedName": "Bullet Proof",
	    "HashNameMale": "MP_Gunrunning_Tattoo_000_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_000_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 16985
	  },
	  {
	    "Name": "TAT_GR_001",
	    "LocalizedName": "Crossed Weapons",
	    "HashNameMale": "MP_Gunrunning_Tattoo_001_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_001_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 19355
	  },
	  {
	    "Name": "TAT_GR_002",
	    "LocalizedName": "Grenade",
	    "HashNameMale": "MP_Gunrunning_Tattoo_002_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_002_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 14650
	  },
	  {
	    "Name": "TAT_GR_003",
	    "LocalizedName": "Lock & Load",
	    "HashNameMale": "MP_Gunrunning_Tattoo_003_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_003_F",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 8750
	  },
	  {
	    "Name": "TAT_GR_004",
	    "LocalizedName": "Sidearm",
	    "HashNameMale": "MP_Gunrunning_Tattoo_004_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_004_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 11285
	  },
	  {
	    "Name": "TAT_GR_005",
	    "LocalizedName": "Patriot Skull",
	    "HashNameMale": "MP_Gunrunning_Tattoo_005_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_005_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 9120
	  },
	  {
	    "Name": "TAT_GR_006",
	    "LocalizedName": "Combat Skull",
	    "HashNameMale": "MP_Gunrunning_Tattoo_006_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_006_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 10670
	  },
	  {
	    "Name": "TAT_GR_007",
	    "LocalizedName": "Stylized Tiger",
	    "HashNameMale": "MP_Gunrunning_Tattoo_007_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_007_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 9660
	  },
	  {
	    "Name": "TAT_GR_008",
	    "LocalizedName": "Bandolier",
	    "HashNameMale": "MP_Gunrunning_Tattoo_008_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_008_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 13445
	  },
	  {
	    "Name": "TAT_GR_009",
	    "LocalizedName": "Butterfly Knife",
	    "HashNameMale": "MP_Gunrunning_Tattoo_009_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_009_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 14650
	  },
	  {
	    "Name": "TAT_GR_010",
	    "LocalizedName": "Cash Money",
	    "HashNameMale": "MP_Gunrunning_Tattoo_010_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_010_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 19050
	  },
	  {
	    "Name": "TAT_GR_011",
	    "LocalizedName": "Death Skull",
	    "HashNameMale": "MP_Gunrunning_Tattoo_011_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_011_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 9785
	  },
	  {
	    "Name": "TAT_GR_012",
	    "LocalizedName": "Dollar Daggers",
	    "HashNameMale": "MP_Gunrunning_Tattoo_012_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_012_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 15060
	  },
	  {
	    "Name": "TAT_GR_013",
	    "LocalizedName": "Wolf Insignia",
	    "HashNameMale": "MP_Gunrunning_Tattoo_013_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_013_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 16115
	  },
	  {
	    "Name": "TAT_GR_014",
	    "LocalizedName": "Backstabber",
	    "HashNameMale": "MP_Gunrunning_Tattoo_014_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_014_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 17200
	  },
	  {
	    "Name": "TAT_GR_015",
	    "LocalizedName": "Spiked Skull",
	    "HashNameMale": "MP_Gunrunning_Tattoo_015_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_015_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 10425
	  },
	  {
	    "Name": "TAT_GR_016",
	    "LocalizedName": "Blood Money",
	    "HashNameMale": "MP_Gunrunning_Tattoo_016_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_016_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 10360
	  },
	  {
	    "Name": "TAT_GR_017",
	    "LocalizedName": "Dog Tags",
	    "HashNameMale": "MP_Gunrunning_Tattoo_017_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_017_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 8980
	  },
	  {
	    "Name": "TAT_GR_018",
	    "LocalizedName": "Dual Wield Skull",
	    "HashNameMale": "MP_Gunrunning_Tattoo_018_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_018_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 17755
	  },
	  {
	    "Name": "TAT_GR_019",
	    "LocalizedName": "Pistol Wings",
	    "HashNameMale": "MP_Gunrunning_Tattoo_019_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_019_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 18025
	  },
	  {
	    "Name": "TAT_GR_020",
	    "LocalizedName": "Crowned Weapons",
	    "HashNameMale": "MP_Gunrunning_Tattoo_020_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_020_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 19875
	  },
	  {
	    "Name": "TAT_GR_021",
	    "LocalizedName": "Have a Nice Day",
	    "HashNameMale": "MP_Gunrunning_Tattoo_021_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_021_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 9460
	  },
	  {
	    "Name": "TAT_GR_022",
	    "LocalizedName": "Explosive Heart",
	    "HashNameMale": "MP_Gunrunning_Tattoo_022_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_022_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 10825
	  },
	  {
	    "Name": "TAT_GR_023",
	    "LocalizedName": "Rose Revolver",
	    "HashNameMale": "MP_Gunrunning_Tattoo_023_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_023_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 8880
	  },
	  {
	    "Name": "TAT_GR_024",
	    "LocalizedName": "Combat Reaper",
	    "HashNameMale": "MP_Gunrunning_Tattoo_024_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_024_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 10340
	  },
	  {
	    "Name": "TAT_GR_025",
	    "LocalizedName": "Praying Skull",
	    "HashNameMale": "MP_Gunrunning_Tattoo_025_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_025_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 12150
	  },
	  {
	    "Name": "TAT_GR_026",
	    "LocalizedName": "Restless Skull",
	    "HashNameMale": "MP_Gunrunning_Tattoo_026_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_026_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 11510
	  },
	  {
	    "Name": "TAT_GR_027",
	    "LocalizedName": "Serpent Revolver",
	    "HashNameMale": "MP_Gunrunning_Tattoo_027_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_027_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 8420
	  },
	  {
	    "Name": "TAT_GR_028",
	    "LocalizedName": "Micro SMG Chain",
	    "HashNameMale": "MP_Gunrunning_Tattoo_028_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_028_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 9960
	  },
	  {
	    "Name": "TAT_GR_029",
	    "LocalizedName": "Win Some Lose Some",
	    "HashNameMale": "MP_Gunrunning_Tattoo_029_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_029_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 14090
	  },
	  {
	    "Name": "TAT_GR_030",
	    "LocalizedName": "Pistol Ace",
	    "HashNameMale": "MP_Gunrunning_Tattoo_030_M",
	    "HashNameFemale": "MP_Gunrunning_Tattoo_030_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 11050
	  }
	]
	]],
	mpimportexport_overlays = [[
	[
	  {
	    "Name": "TAT_IE_000",
	    "LocalizedName": "Block Back",
	    "HashNameMale": "MP_MP_ImportExport_Tat_000_M",
	    "HashNameFemale": "MP_MP_ImportExport_Tat_000_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 13780
	  },
	  {
	    "Name": "TAT_IE_001",
	    "LocalizedName": "Power Plant",
	    "HashNameMale": "MP_MP_ImportExport_Tat_001_M",
	    "HashNameFemale": "MP_MP_ImportExport_Tat_001_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 12900
	  },
	  {
	    "Name": "TAT_IE_002",
	    "LocalizedName": "Tuned to Death",
	    "HashNameMale": "MP_MP_ImportExport_Tat_002_M",
	    "HashNameFemale": "MP_MP_ImportExport_Tat_002_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 12120
	  },
	  {
	    "Name": "TAT_IE_003",
	    "LocalizedName": "Mechanical Sleeve",
	    "HashNameMale": "MP_MP_ImportExport_Tat_003_M",
	    "HashNameFemale": "MP_MP_ImportExport_Tat_003_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 17200
	  },
	  {
	    "Name": "TAT_IE_004",
	    "LocalizedName": "Piston Sleeve",
	    "HashNameMale": "MP_MP_ImportExport_Tat_004_M",
	    "HashNameFemale": "MP_MP_ImportExport_Tat_004_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 16350
	  },
	  {
	    "Name": "TAT_IE_005",
	    "LocalizedName": "Dialed In",
	    "HashNameMale": "MP_MP_ImportExport_Tat_005_M",
	    "HashNameFemale": "MP_MP_ImportExport_Tat_005_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 18615
	  },
	  {
	    "Name": "TAT_IE_006",
	    "LocalizedName": "Engulfed Block",
	    "HashNameMale": "MP_MP_ImportExport_Tat_006_M",
	    "HashNameFemale": "MP_MP_ImportExport_Tat_006_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 15720
	  },
	  {
	    "Name": "TAT_IE_007",
	    "LocalizedName": "Drive Forever",
	    "HashNameMale": "MP_MP_ImportExport_Tat_007_M",
	    "HashNameFemale": "MP_MP_ImportExport_Tat_007_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 16685
	  },
	  {
	    "Name": "TAT_IE_008",
	    "LocalizedName": "Scarlett",
	    "HashNameMale": "MP_MP_ImportExport_Tat_008_M",
	    "HashNameFemale": "MP_MP_ImportExport_Tat_008_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 19900
	  },
	  {
	    "Name": "TAT_IE_009",
	    "LocalizedName": "Serpents of Destruction",
	    "HashNameMale": "MP_MP_ImportExport_Tat_009_M",
	    "HashNameFemale": "MP_MP_ImportExport_Tat_009_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 16500
	  },
	  {
	    "Name": "TAT_IE_010",
	    "LocalizedName": "Take the Wheel",
	    "HashNameMale": "MP_MP_ImportExport_Tat_010_M",
	    "HashNameFemale": "MP_MP_ImportExport_Tat_010_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 14235
	  },
	  {
	    "Name": "TAT_IE_011",
	    "LocalizedName": "Talk Shit Get Hit",
	    "HashNameMale": "MP_MP_ImportExport_Tat_011_M",
	    "HashNameFemale": "MP_MP_ImportExport_Tat_011_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 15985
	  }
	]
	]],
	mplowrider_overlays = [[
	[
	  {
	    "Name": "TAT_S1_001",
	    "LocalizedName": "King Fight",
	    "HashNameMale": "MP_LR_Tat_001_M",
	    "HashNameFemale": "MP_LR_Tat_001_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6100
	  },
	  {
	    "Name": "TAT_S1_002",
	    "LocalizedName": "Holy Mary",
	    "HashNameMale": "MP_LR_Tat_002_M",
	    "HashNameFemale": "MP_LR_Tat_002_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 10250
	  },
	  {
	    "Name": "TAT_S1_004",
	    "LocalizedName": "Gun Mic",
	    "HashNameMale": "MP_LR_Tat_004_M",
	    "HashNameFemale": "MP_LR_Tat_004_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 3500
	  },
	  {
	    "Name": "TAT_S1_005",
	    "LocalizedName": "No Evil",
	    "HashNameMale": "MP_LR_Tat_005_M",
	    "HashNameFemale": "MP_LR_Tat_005_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 5900
	  },
	  {
	    "Name": "TAT_S1_007",
	    "LocalizedName": "LS Serpent",
	    "HashNameMale": "MP_LR_Tat_007_M",
	    "HashNameFemale": "MP_LR_Tat_007_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 5500
	  },
	  {
	    "Name": "TAT_S1_009",
	    "LocalizedName": "Amazon",
	    "HashNameMale": "MP_LR_Tat_009_M",
	    "HashNameFemale": "MP_LR_Tat_009_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 9500
	  },
	  {
	    "Name": "TAT_S1_010",
	    "LocalizedName": "Bad Angel",
	    "HashNameMale": "MP_LR_Tat_010_M",
	    "HashNameFemale": "MP_LR_Tat_010_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 16500
	  },
	  {
	    "Name": "TAT_S1_013",
	    "LocalizedName": "Love Gamble",
	    "HashNameMale": "MP_LR_Tat_013_M",
	    "HashNameFemale": "MP_LR_Tat_013_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 8300
	  },
	  {
	    "Name": "TAT_S1_014",
	    "LocalizedName": "Love is Blind",
	    "HashNameMale": "MP_LR_Tat_014_M",
	    "HashNameFemale": "MP_LR_Tat_014_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 17750
	  },
	  {
	    "Name": "TAT_S1_015",
	    "LocalizedName": "Seductress",
	    "HashNameMale": "MP_LR_Tat_015_M",
	    "HashNameFemale": "MP_LR_Tat_015_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 6150
	  },
	  {
	    "Name": "TAT_S1_017",
	    "LocalizedName": "Ink Me",
	    "HashNameMale": "MP_LR_Tat_017_M",
	    "HashNameFemale": "MP_LR_Tat_017_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 7700
	  },
	  {
	    "Name": "TAT_S1_020",
	    "LocalizedName": "Presidents",
	    "HashNameMale": "MP_LR_Tat_020_M",
	    "HashNameFemale": "MP_LR_Tat_020_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 6850
	  },
	  {
	    "Name": "TAT_S1_021",
	    "LocalizedName": "Sad Angel",
	    "HashNameMale": "MP_LR_Tat_021_M",
	    "HashNameFemale": "MP_LR_Tat_021_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 15000
	  },
	  {
	    "Name": "TAT_S1_023",
	    "LocalizedName": "Dance of Hearts",
	    "HashNameMale": "MP_LR_Tat_023_M",
	    "HashNameFemale": "MP_LR_Tat_023_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 6500
	  },
	  {
	    "Name": "TAT_S1_026",
	    "LocalizedName": "Royal Takeover",
	    "HashNameMale": "MP_LR_Tat_026_M",
	    "HashNameFemale": "MP_LR_Tat_026_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 7400
	  },
	  {
	    "Name": "TAT_S1_027",
	    "LocalizedName": "Los Santos Life",
	    "HashNameMale": "MP_LR_Tat_027_M",
	    "HashNameFemale": "MP_LR_Tat_027_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 7800
	  },
	  {
	    "Name": "TAT_S1_033",
	    "LocalizedName": "City Sorrow",
	    "HashNameMale": "MP_LR_Tat_033_M",
	    "HashNameFemale": "MP_LR_Tat_033_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 10000
	  }
	]
	]],
	mpluxe_overlays = [[
	[
	  {
	    "Name": "TAT_LX_000",
	    "LocalizedName": "Serpent of Death",
	    "HashNameMale": "MP_LUXE_TAT_000_M",
	    "HashNameFemale": "MP_LUXE_TAT_000_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 11900
	  },
	  {
	    "Name": "TAT_LX_001",
	    "LocalizedName": "Elaborate Los Muertos",
	    "HashNameMale": "MP_LUXE_TAT_001_M",
	    "HashNameFemale": "MP_LUXE_TAT_001_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 14350
	  },
	  {
	    "Name": "TAT_LX_003",
	    "LocalizedName": "Abstract Skull",
	    "HashNameMale": "MP_LUXE_TAT_003_M",
	    "HashNameFemale": "MP_LUXE_TAT_003_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 8350
	  },
	  {
	    "Name": "TAT_LX_004",
	    "LocalizedName": "Floral Raven",
	    "HashNameMale": "MP_LUXE_TAT_004_M",
	    "HashNameFemale": "MP_LUXE_TAT_004_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 12200
	  },
	  {
	    "Name": "TAT_LX_006",
	    "LocalizedName": "Adorned Wolf",
	    "HashNameMale": "MP_LUXE_TAT_006_M",
	    "HashNameFemale": "MP_LUXE_TAT_006_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 25000
	  },
	  {
	    "Name": "TAT_LX_007",
	    "LocalizedName": "Eye of the Griffin",
	    "HashNameMale": "MP_LUXE_TAT_007_M",
	    "HashNameFemale": "MP_LUXE_TAT_007_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 12450
	  },
	  {
	    "Name": "TAT_LX_008",
	    "LocalizedName": "Flying Eye",
	    "HashNameMale": "MP_LUXE_TAT_008_M",
	    "HashNameFemale": "MP_LUXE_TAT_008_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 18000
	  },
	  {
	    "Name": "TAT_LX_009",
	    "LocalizedName": "Floral Symmetry",
	    "HashNameMale": "MP_LUXE_TAT_009_M",
	    "HashNameFemale": "MP_LUXE_TAT_009_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 19150
	  },
	  {
	    "Name": "TAT_LX_013",
	    "LocalizedName": "Mermaid Harpist",
	    "HashNameMale": "MP_LUXE_TAT_013_M",
	    "HashNameFemale": "MP_LUXE_TAT_013_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 16900
	  },
	  {
	    "Name": "TAT_LX_014",
	    "LocalizedName": "Ancient Queen",
	    "HashNameMale": "MP_LUXE_TAT_014_M",
	    "HashNameFemale": "MP_LUXE_TAT_014_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 18200
	  },
	  {
	    "Name": "TAT_LX_015",
	    "LocalizedName": "Smoking Sisters",
	    "HashNameMale": "MP_LUXE_TAT_015_M",
	    "HashNameFemale": "MP_LUXE_TAT_015_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 16250
	  },
	  {
	    "Name": "TAT_LX_019",
	    "LocalizedName": "Geisha Bloom",
	    "HashNameMale": "MP_LUXE_TAT_019_M",
	    "HashNameFemale": "MP_LUXE_TAT_019_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 16850
	  },
	  {
	    "Name": "TAT_LX_020",
	    "LocalizedName": "Archangel & Mary",
	    "HashNameMale": "MP_LUXE_TAT_020_M",
	    "HashNameFemale": "MP_LUXE_TAT_020_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 22500
	  },
	  {
	    "Name": "TAT_LX_021",
	    "LocalizedName": "Gabriel",
	    "HashNameMale": "MP_LUXE_TAT_021_M",
	    "HashNameFemale": "MP_LUXE_TAT_021_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 12850
	  },
	  {
	    "Name": "TAT_LX_024",
	    "LocalizedName": "Feather Mural",
	    "HashNameMale": "MP_LUXE_TAT_024_M",
	    "HashNameFemale": "MP_LUXE_TAT_024_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 27250
	  }
	]
	]],
	mpstunt_overlays = [[
	[
	  {
	    "Name": "TAT_ST_000",
	    "LocalizedName": "Stunt Skull",
	    "HashNameMale": "MP_MP_Stunt_Tat_000_M",
	    "HashNameFemale": "MP_MP_Stunt_Tat_000_F",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 4850
	  },
	  {
	    "Name": "TAT_ST_001",
	    "LocalizedName": "8 Eyed Skull",
	    "HashNameMale": "MP_MP_Stunt_tat_001_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_001_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 11600
	  },
	  {
	    "Name": "TAT_ST_002",
	    "LocalizedName": "Big Cat",
	    "HashNameMale": "MP_MP_Stunt_tat_002_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_002_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 8850
	  },
	  {
	    "Name": "TAT_ST_003",
	    "LocalizedName": "Poison Wrench",
	    "HashNameMale": "MP_MP_Stunt_tat_003_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_003_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 4300
	  },
	  {
	    "Name": "TAT_ST_004",
	    "LocalizedName": "Scorpion",
	    "HashNameMale": "MP_MP_Stunt_tat_004_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_004_F",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 6350
	  },
	  {
	    "Name": "TAT_ST_005",
	    "LocalizedName": "Demon Spark Plug",
	    "HashNameMale": "MP_MP_Stunt_tat_005_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_005_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 8850
	  },
	  {
	    "Name": "TAT_ST_006",
	    "LocalizedName": "Toxic Spider",
	    "HashNameMale": "MP_MP_Stunt_tat_006_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_006_F",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 5900
	  },
	  {
	    "Name": "TAT_ST_007",
	    "LocalizedName": "Dagger Devil",
	    "HashNameMale": "MP_MP_Stunt_tat_007_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_007_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 8150
	  },
	  {
	    "Name": "TAT_ST_008",
	    "LocalizedName": "Moonlight Ride",
	    "HashNameMale": "MP_MP_Stunt_tat_008_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_008_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 14750
	  },
	  {
	    "Name": "TAT_ST_009",
	    "LocalizedName": "Arachnid of Death",
	    "HashNameMale": "MP_MP_Stunt_tat_009_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_009_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 10800
	  },
	  {
	    "Name": "TAT_ST_010",
	    "LocalizedName": "Grave Vulture",
	    "HashNameMale": "MP_MP_Stunt_tat_010_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_010_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 11000
	  },
	  {
	    "Name": "TAT_ST_011",
	    "LocalizedName": "Wheels of Death",
	    "HashNameMale": "MP_MP_Stunt_tat_011_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_011_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 10750
	  },
	  {
	    "Name": "TAT_ST_012",
	    "LocalizedName": "Punk Biker",
	    "HashNameMale": "MP_MP_Stunt_tat_012_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_012_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 11950
	  },
	  {
	    "Name": "TAT_ST_013",
	    "LocalizedName": "Dirt Track Hero",
	    "HashNameMale": "MP_MP_Stunt_tat_013_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_013_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 15500
	  },
	  {
	    "Name": "TAT_ST_014",
	    "LocalizedName": "Bat Cat of Spades",
	    "HashNameMale": "MP_MP_Stunt_tat_014_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_014_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 8300
	  },
	  {
	    "Name": "TAT_ST_015",
	    "LocalizedName": "Praying Gloves",
	    "HashNameMale": "MP_MP_Stunt_tat_015_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_015_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 13400
	  },
	  {
	    "Name": "TAT_ST_016",
	    "LocalizedName": "Coffin Racer",
	    "HashNameMale": "MP_MP_Stunt_tat_016_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_016_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 12950
	  },
	  {
	    "Name": "TAT_ST_017",
	    "LocalizedName": "Bat Wheel",
	    "HashNameMale": "MP_MP_Stunt_tat_017_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_017_F",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 3800
	  },
	  {
	    "Name": "TAT_ST_018",
	    "LocalizedName": "Vintage Bully",
	    "HashNameMale": "MP_MP_Stunt_tat_018_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_018_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 5400
	  },
	  {
	    "Name": "TAT_ST_019",
	    "LocalizedName": "Engine Heart",
	    "HashNameMale": "MP_MP_Stunt_tat_019_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_019_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 8900
	  },
	  {
	    "Name": "TAT_ST_020",
	    "LocalizedName": "Piston Angel",
	    "HashNameMale": "MP_MP_Stunt_tat_020_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_020_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 6950
	  },
	  {
	    "Name": "TAT_ST_021",
	    "LocalizedName": "Golden Cobra",
	    "HashNameMale": "MP_MP_Stunt_tat_021_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_021_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 21200
	  },
	  {
	    "Name": "TAT_ST_022",
	    "LocalizedName": "Piston Head",
	    "HashNameMale": "MP_MP_Stunt_tat_022_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_022_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 16850
	  },
	  {
	    "Name": "TAT_ST_023",
	    "LocalizedName": "Tanked",
	    "HashNameMale": "MP_MP_Stunt_tat_023_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_023_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 18500
	  },
	  {
	    "Name": "TAT_ST_024",
	    "LocalizedName": "Road Kill",
	    "HashNameMale": "MP_MP_Stunt_tat_024_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_024_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 8650
	  },
	  {
	    "Name": "TAT_ST_025",
	    "LocalizedName": "Speed Freak",
	    "HashNameMale": "MP_MP_Stunt_tat_025_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_025_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 7200
	  },
	  {
	    "Name": "TAT_ST_026",
	    "LocalizedName": "Winged Wheel",
	    "HashNameMale": "MP_MP_Stunt_tat_026_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_026_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 12300
	  },
	  {
	    "Name": "TAT_ST_027",
	    "LocalizedName": "Punk Road Hog",
	    "HashNameMale": "MP_MP_Stunt_tat_027_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_027_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 8950
	  },
	  {
	    "Name": "TAT_ST_028",
	    "LocalizedName": "Quad Goblin",
	    "HashNameMale": "MP_MP_Stunt_tat_028_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_028_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 9850
	  },
	  {
	    "Name": "TAT_ST_029",
	    "LocalizedName": "Majestic Finish",
	    "HashNameMale": "MP_MP_Stunt_tat_029_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_029_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 17350
	  },
	  {
	    "Name": "TAT_ST_030",
	    "LocalizedName": "Man's Ruin",
	    "HashNameMale": "MP_MP_Stunt_tat_030_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_030_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 8150
	  },
	  {
	    "Name": "TAT_ST_031",
	    "LocalizedName": "Stunt Jesus",
	    "HashNameMale": "MP_MP_Stunt_tat_031_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_031_F",
	    "Zone": "ZONE_LEFT_LEG",
	    "ZoneID": 4,
	    "Price": 11000
	  },
	  {
	    "Name": "TAT_ST_032",
	    "LocalizedName": "Wheelie Mouse",
	    "HashNameMale": "MP_MP_Stunt_tat_032_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_032_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 10350
	  },
	  {
	    "Name": "TAT_ST_033",
	    "LocalizedName": "Sugar Skull Trucker",
	    "HashNameMale": "MP_MP_Stunt_tat_033_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_033_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 10400
	  },
	  {
	    "Name": "TAT_ST_034",
	    "LocalizedName": "Feather Road Kill",
	    "HashNameMale": "MP_MP_Stunt_tat_034_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_034_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 9900
	  },
	  {
	    "Name": "TAT_ST_035",
	    "LocalizedName": "Stuntman's End",
	    "HashNameMale": "MP_MP_Stunt_tat_035_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_035_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 12700
	  },
	  {
	    "Name": "TAT_ST_036",
	    "LocalizedName": "Biker Stallion",
	    "HashNameMale": "MP_MP_Stunt_tat_036_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_036_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 2350
	  },
	  {
	    "Name": "TAT_ST_037",
	    "LocalizedName": "Big Grills",
	    "HashNameMale": "MP_MP_Stunt_tat_037_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_037_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 6850
	  },
	  {
	    "Name": "TAT_ST_038",
	    "LocalizedName": "One Down Five Up",
	    "HashNameMale": "MP_MP_Stunt_tat_038_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_038_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 5750
	  },
	  {
	    "Name": "TAT_ST_039",
	    "LocalizedName": "Kaboom",
	    "HashNameMale": "MP_MP_Stunt_tat_039_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_039_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 9350
	  },
	  {
	    "Name": "TAT_ST_040",
	    "LocalizedName": "Monkey Chopper",
	    "HashNameMale": "MP_MP_Stunt_tat_040_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_040_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 15950
	  },
	  {
	    "Name": "TAT_ST_041",
	    "LocalizedName": "Brapp",
	    "HashNameMale": "MP_MP_Stunt_tat_041_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_041_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 10100
	  },
	  {
	    "Name": "TAT_ST_042",
	    "LocalizedName": "Flaming Quad",
	    "HashNameMale": "MP_MP_Stunt_tat_042_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_042_F",
	    "Zone": "ZONE_HEAD",
	    "ZoneID": 1,
	    "Price": 4150
	  },
	  {
	    "Name": "TAT_ST_043",
	    "LocalizedName": "Engine Arm",
	    "HashNameMale": "MP_MP_Stunt_tat_043_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_043_F",
	    "Zone": "ZONE_LEFT_ARM",
	    "ZoneID": 2,
	    "Price": 10300
	  },
	  {
	    "Name": "TAT_ST_044",
	    "LocalizedName": "Ram Skull",
	    "HashNameMale": "MP_MP_Stunt_tat_044_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_044_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 13900
	  },
	  {
	    "Name": "TAT_ST_045",
	    "LocalizedName": "Severed Hand",
	    "HashNameMale": "MP_MP_Stunt_tat_045_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_045_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 19650
	  },
	  {
	    "Name": "TAT_ST_046",
	    "LocalizedName": "Full Throttle",
	    "HashNameMale": "MP_MP_Stunt_tat_046_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_046_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 12750
	  },
	  {
	    "Name": "TAT_ST_047",
	    "LocalizedName": "Brake Knife",
	    "HashNameMale": "MP_MP_Stunt_tat_047_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_047_F",
	    "Zone": "ZONE_RIGHT_LEG",
	    "ZoneID": 5,
	    "Price": 9200
	  },
	  {
	    "Name": "TAT_ST_048",
	    "LocalizedName": "Racing Doll",
	    "HashNameMale": "MP_MP_Stunt_tat_048_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_048_F",
	    "Zone": "ZONE_TORSO",
	    "ZoneID": 0,
	    "Price": 11300
	  },
	  {
	    "Name": "TAT_ST_049",
	    "LocalizedName": "Seductive Mechanic",
	    "HashNameMale": "MP_MP_Stunt_tat_049_M",
	    "HashNameFemale": "MP_MP_Stunt_tat_049_F",
	    "Zone": "ZONE_RIGHT_ARM",
	    "ZoneID": 3,
	    "Price": 23000
	  }
	]
	]],

}

cfg.tattoos = {
	["mpbeach_overlays"] = { -- native store name
		_config = {blipid=75,blipcolor=48,title="Beach Tattoos", blip = true},
		catalog = cfg.pack.mpbeach_overlays
	},
	["mpbiker_overlays"] = { -- native store name
		_config = {blipid=75,blipcolor=48,title="Biker Tattoos", blip = false},
		catalog = cfg.pack.mpbiker_overlays
	},
	["mpchristmas2_overlays"] = { -- native store name
		_config = {blipid=75,blipcolor=48,title="Rebel Tattoos", blip = true},
		catalog = cfg.pack.mpchristmas2_overlays
	},
	["mphipster_overlays"] = { -- native store name
		_config = {blipid=75,blipcolor=48,title="Hipster Tattoos", blip = false},
		catalog = cfg.pack.mphipster_overlays
	},
	["mplowrider2_overlays"] = { -- native store name
		_config = {blipid=75,blipcolor=48,title="Lowrider Tattoos", blip = false},
		catalog = cfg.pack.mplowrider2_overlays
	},
	["mpluxe2_overlays"] = { -- native store name
		_config = {blipid=75,blipcolor=48,title="Lux Tattoos", blip = false},
		catalog = cfg.pack.mpluxe2_overlays
	},
	["multiplayer_overlays"] = { -- native store name
		_config = {blipid=75,blipcolor=48,title="MP Tattoos", blip = false},
		catalog = cfg.pack.multiplayer_overlays
	},
	["mpbusiness_overlays"] = { -- native store name
		_config = {blipid=75,blipcolor=48,title="Business/Lux Tattoos", blip = true},
		catalog = cfg.pack.mpbusiness_overlays
	},
	["mpgunrunning_overlays"] = { -- native store name
		_config = {blipid=75,blipcolor=48,title="Gunrunning Tattoos", blip = false},
		catalog = cfg.pack.mpgunrunning_overlays
	},
	["mpimportexport_overlays"] = { -- native store name
		_config = {blipid=75,blipcolor=48,title="Fuck It Tattoos", blip = true},
		catalog = cfg.pack.mpimportexport_overlays
	},
	["mplowrider_overlays"] = { -- native store name
		_config = {blipid=75,blipcolor=48,title="Lowrider Tattoos", blip = true},
		catalog = cfg.pack.mplowrider_overlays
	},
	["mpluxe_overlays"] = { -- native store name
		_config = {blipid=75,blipcolor=48,title="Lux Tattoos", blip = false},
		catalog = cfg.pack.mpluxe_overlays
	},
	["mpstunt_overlays"] = { -- native store name
		_config = {blipid=75,blipcolor=48,title="Stunt Tattoos", blip = true},
		catalog = cfg.pack.mpstunt_overlays
	},
}

-- list of tattooshops positions
cfg.shops = {
	{"mpluxe2_overlays", 1325.5324707032,-1652.1652832032,52.275661468506},
	{"mpbusiness_overlays", 1321.2465820312,-1653.0145263672,52.275093078614},

	{"mpbiker_overlays", 321.2341003418,182.64710998536,103.5864944458},
	{"mpgunrunning_overlays", 323.82653808594,179.71516418458,103.5864944458},
	{"mpstunt_overlays", 323.2322692871,181.71348571778,103.5864944458},

	{"mpchristmas2_overlays", -3172.1164550782,1074.410522461,20.829183578492},
	{"mpluxe_overlays", -3168.8488769532,1077.0018310546,20.829183578492},

	{"mphipster_overlays", 1864.633,3747.738,33.032},
	{"mpbeach_overlays", 1863.6225585938,3750.7084960938,33.031875610352},

	{"mplowrider2_overlays", -293.713,6200.04,31.487},
	{"mplowrider_overlays", -292.15939331054,6197.3212890625,31.488454818726},

	{"multiplayer_overlays", -1151.6091308594,-1426.0134277344,4.9544610977172},
	{"mpimportexport_overlays", -1155.745727539,-1426.5623779296,4.9544606208802},

}
return cfg
