if cfg.iplload then
  Citizen.CreateThread(function()
    LoadMpDlcMaps()
    EnableMpDlcMaps(true)
    RequestIpl("chop_props")
  	RemoveIpl("FIBlobbyfake")
  	RequestIpl("FBI_colPLUG")
  	RequestIpl("FBI_repair")
  	RequestIpl("TrevorsMP")
  	RequestIpl("TrevorsTrailer")
  	RemoveIpl("farm_burnt")
  	RemoveIpl("farm_burnt_lod")
  	RemoveIpl("farm_burnt_props")
  	RemoveIpl("farmint_cap")
  	RemoveIpl("farmint_cap_lod")
  	RemoveIpl("CS1_02_cf_offmission")
  	RequestIpl("v_rockclub")
  	RemoveIpl("hei_bi_hw1_13_door")
  	RemoveIpl("shutter_open")
  	RemoveIpl("csr_inMission")
  	RequestIpl("v_carshowroom")
  	RequestIpl("shutter_closed")
  	RemoveIpl("smboat")
  	RemoveIpl("smboat_lod")
  	RequestIpl("cargoship")
  	RequestIpl("railing_start")
  	RemoveIpl("sp1_10_fake_interior")
  	RemoveIpl("sp1_10_fake_interior_lod")
  	RemoveIpl("id2_14_during2")
  	RemoveIpl("id2_14_on_fire")
  	RemoveIpl("id2_14_post_no_int")
  	RemoveIpl("id2_14_pre_no_int")
  	RemoveIpl("Coroner_Int_off")
  	RemoveIpl("bh1_16_refurb")
  	RemoveIpl("jewel2fake")
  	RemoveIpl("bh1_16_doors_shut")
  	RequestIpl("ferris_finale_Anim")
  	RemoveIpl("ch1_02_closed")
  	RequestIpl("AP1_04_TriAf01")
  	RequestIpl("CS2_06_TriAf02")
  	RequestIpl("CS4_04_TriAf03")
  	RemoveIpl("scafstartimap")
  	RequestIpl("scafendimap")
  	RemoveIpl("DT1_05_HC_REMOVE")
  	RequestIpl("DT1_05_HC_REQ")
  	RequestIpl("DT1_05_REQUEST")
  	RemoveIpl("DT1_03_Shutter")
  	RemoveIpl("DT1_03_Gr_Closed")
    RequestIpl("golfflags")

  	-- Simeon: -47.16170 -1115.3327 26.5
  	RequestIpl("shr_int")

  	-- Trevor: 1985.48132, 3828.76757, 32.5
  	-- Trash or Tidy. Only choose one.
  	RequestIpl("trevorstrailertidy")

  	-- Heist Jewel: -637.20159 -239.16250 38.1
  	RequestIpl("post_hiest_unload")

  	-- Max Renda: -585.8247, -282.72, 35.45475
  	RequestIpl("refit_unload")

  	-- Heist Union Depository: 2.69689322, -667.0166, 16.1306286
  	RequestIpl("FINBANK")

  	-- Morgue: 239.75195, -1360.64965, 39.53437
  	RequestIpl("Coroner_Int_on")
  	RequestIpl("coronertrash")

  	-- Cluckin Bell: -146.3837, 6161.5, 30.2062
  	RequestIpl("CS1_02_cf_onmission1")
  	RequestIpl("CS1_02_cf_onmission2")
  	RequestIpl("CS1_02_cf_onmission3")
  	RequestIpl("CS1_02_cf_onmission4")

  	-- Grapeseed's farm: 2447.9, 4973.4, 47.7
  	RequestIpl("farm")
  	RequestIpl("farmint")
  	RequestIpl("farm_lod")
  	RequestIpl("farm_props")
  	RequestIpl("des_farmhouse")

  	-- FIB lobby: 105.4557, -745.4835, 44.7548
  	RequestIpl("FIBlobby")

  	-- Billboard: iFruit
  	RequestIpl("FruitBB")
  	RequestIpl("sc1_01_newbill")
  	RequestIpl("hw1_02_newbill")
  	RequestIpl("hw1_emissive_newbill")
  	RequestIpl("sc1_14_newbill")
  	RequestIpl("dt1_17_newbill")

  	-- Lester's factory: 716.84, -962.05, 31.59
  	RequestIpl("id2_14_during_door")
  	RequestIpl("id2_14_during1")

  	-- Life Invader lobby: -1047.9, -233.0, 39.0
  	RequestIpl("facelobby")

  	-- Tunnels
  	RequestIpl("v_tunnel_hole")

  	-- Carwash: 55.7, -1391.3, 30.5
  	RequestIpl("Carwash_with_spinners")

  	-- Stadium "Fame or Shame": -248.49159240722656, -2010.509033203125, 34.57429885864258
  	RequestIpl("sp1_10_real_interior")
  	RequestIpl("sp1_10_real_interior_lod")

  	-- House in Banham Canyon: -3086.428, 339.2523, 6.3717
  	RequestIpl("ch1_02_open")

  	-- Garage in La Mesa (autoshop): 970.27453, -1826.56982, 31.11477
  	RequestIpl("bkr_bi_id1_23_door")

  	-- Hill Valley church - Grave: -282.46380000, 2835.84500000, 55.91446000
  	RequestIpl("lr_cs6_08_grave_closed")

  	-- Lost's trailer park: 49.49379000, 3744.47200000, 46.38629000
  	RequestIpl("methtrailer_grp1")

  	-- Lost safehouse: 984.1552, -95.3662, 74.50
  	RequestIpl("bkr_bi_hw1_13_int")

  	-- Raton Canyon river: -1652.83, 4445.28, 2.52
  	RequestIpl("CanyonRvrShallow")

  	-- Zancudo Gates (GTAO like): -1600.30100000, 2806.73100000, 18.79683000
  	--RequestIpl("CS3_07_MPGates")

  	-- Pillbox hospital:
  	RequestIpl("rc12b_default")

  	-- Josh's house: -1117.1632080078, 303.090698, 66.52217
  	RequestIpl("bh1_47_joshhse_unburnt")
  	RequestIpl("bh1_47_joshhse_unburnt_lod")

  	-- Zancudo River (need streamed content): 86.815, 3191.649, 30.463
  	RequestIpl("cs3_05_water_grp1")
  	RequestIpl("cs3_05_water_grp1_lod")
  	RequestIpl("cs3_05_water_grp2")
  	RequestIpl("cs3_05_water_grp2_lod")

  	-- Cassidy Creek (need streamed content): -425.677, 4433.404, 27.3253
  	RequestIpl("canyonriver01")
  	RequestIpl("canyonriver01_lod")

  	-- Optional
  		-- Graffitis
  		RequestIpl("ch3_rd2_bishopschickengraffiti") -- 1861.28, 2402.11, 58.53
  		RequestIpl("cs5_04_mazebillboardgraffiti") -- 2697.32, 3162.18, 58.1
  		RequestIpl("cs5_roads_ronoilgraffiti") -- 2119.12, 3058.21, 53.25

  		-- Heist Carrier: 3082.3117 -4717.1191 15.2622
  		RequestIpl("hei_carrier")
  		RequestIpl("hei_carrier_distantlights")
  		RequestIpl("hei_Carrier_int1")
  		RequestIpl("hei_Carrier_int2")
  		RequestIpl("hei_Carrier_int3")
  		RequestIpl("hei_Carrier_int4")
  		RequestIpl("hei_Carrier_int5")
  		RequestIpl("hei_Carrier_int6")
  		RequestIpl("hei_carrier_lodlights")
  		RequestIpl("hei_carrier_slod")

  		-- Heist Yatch: -2043.974,-1031.582, 11.981
  		RequestIpl("hei_yacht_heist")
  		RequestIpl("hei_yacht_heist_Bar")
  		RequestIpl("hei_yacht_heist_Bedrm")
  		RequestIpl("hei_yacht_heist_Bridge")
  		RequestIpl("hei_yacht_heist_DistantLights")
  		RequestIpl("hei_yacht_heist_enginrm")
  		RequestIpl("hei_yacht_heist_LODLights")
  		RequestIpl("hei_yacht_heist_Lounge")

  		-- Bunkers - Exteriors
  		RequestIpl("gr_case0_bunkerclosed")
  		RequestIpl("gr_case1_bunkerclosed")
  		RequestIpl("gr_case2_bunkerclosed")
  		RequestIpl("gr_case3_bunkerclosed")
  		RequestIpl("gr_case4_bunkerclosed")
  		RequestIpl("gr_case5_bunkerclosed")
  		RequestIpl("gr_case6_bunkerclosed")
  		RequestIpl("gr_case7_bunkerclosed")
  		RequestIpl("gr_case9_bunkerclosed")
  		RequestIpl("gr_case10_bunkerclosed")
  		RequestIpl("gr_case11_bunkerclosed")

  		-- Bunkers - Interior: 892.6384, -3245.8664, -98.2645
      RequestIpl("grdlc_int_01_shell")
      RequestIpl("gr_grdlc_int_01")
      RequestIpl("gr_grdlc_int_02")
      RequestIpl("gr_entrance_placement")
      RequestIpl("gr_grdlc_interior_placement")
      RequestIpl("gr_grdlc_interior_placement_interior_0_grdlc_int_01_milo_")
      RequestIpl("gr_grdlc_interior_placement_interior_1_grdlc_int_02_milo_")

      EnableInteriorProp(258561,"standard_bunker_set")
      EnableInteriorProp(258561,"Bunker_Style_C")
      EnableInteriorProp(258561,"Office_Upgrade_set")
      EnableInteriorProp(258561,"Gun_schematic_set")
      EnableInteriorProp(258561,"security_upgrade")
      EnableInteriorProp(258561,"gun_range_lights")
      EnableInteriorProp(258561,"gun_locker_upgrade")
      RefreshInterior(258561)

  		-- Bahama Mamas: -1388.0013, -618.41967, 30.819599
  		RequestIpl("hei_sm_16_interior_v_bahama_milo_")

  		-- Red Carpet: 300.5927, 199.7589, 104.3776
  		RequestIpl("redCarpet")

  		-- UFO
  		-- Zancudo: -2051.99463, 3237.05835, 1456.97021
  		-- Hippie base: 2490.47729, 3774.84351, 2414.035
  		-- Chiliad: 501.52880000, 5593.86500000, 796.23250000
  		RequestIpl("ufo")
  		RequestIpl("ufo_eye")
  		RequestIpl("ufo_lod")

  		-- North Yankton: 3217.697, -4834.826, 111.8152
  			-- RequestIpl("prologue01")
  			-- RequestIpl("prologue01c")
  			-- RequestIpl("prologue01d")
  			-- RequestIpl("prologue01e")
  			-- RequestIpl("prologue01f")
  			-- RequestIpl("prologue01g")
  			-- RequestIpl("prologue01h")
  			-- RequestIpl("prologue01i")
  			-- RequestIpl("prologue01j")
  			-- RequestIpl("prologue01k")
  			-- RequestIpl("prologue01z")
  			-- RequestIpl("prologue02")
  			-- RequestIpl("prologue03")
  			-- RequestIpl("prologue03b")
  			-- RequestIpl("prologue04")
  			-- RequestIpl("prologue04b")
  			-- RequestIpl("prologue05")
  			-- RequestIpl("prologue05b")
  			-- RequestIpl("prologue06")
  			-- RequestIpl("prologue06b")
  			-- RequestIpl("prologue06_int")
  			-- RequestIpl("prologuerd")
  			-- RequestIpl("prologuerdb ")
  			-- RequestIpl("prologue_DistantLights")
  			-- RequestIpl("prologue_LODLights")
  			-- RequestIpl("prologue_m2_door")

  		-- CEO Offices :
  			-- Arcadius Business Centre
  			RequestIpl("ex_dt1_02_office_02b")	-- Executive Rich
  			-- RequestIpl("ex_dt1_02_office_02c")	-- Executive Cool
  			-- RequestIpl("ex_dt1_02_office_02a")	-- Executive Contrast
  			-- RequestIpl("ex_dt1_02_office_01a")	-- Old Spice Warm
  			-- RequestIpl("ex_dt1_02_office_01b")	-- Old Spice Classical
  			-- RequestIpl("ex_dt1_02_office_01c")	-- Old Spice Vintage
  			-- RequestIpl("ex_dt1_02_office_03a")	-- Power Broker Ice
  			-- RequestIpl("ex_dt1_02_office_03b")	-- Power Broker Conservative
  			-- RequestIpl("ex_dt1_02_office_03c")	-- Power Broker Polished

  			-- Maze Bank Building
  			-- RequestIpl("ex_dt1_11_office_02b")	-- Executive Rich
  			RequestIpl("ex_dt1_11_office_02c")	-- Executive Cool -77.9037399292,-830.3989868164,243.38594055176
  			-- RequestIpl("ex_dt1_11_office_02a")	-- Executive Contrast
  			-- RequestIpl("ex_dt1_11_office_01a")	-- Old Spice Warm
  			-- RequestIpl("ex_dt1_11_office_01b")	-- Old Spice Classical
  			-- RequestIpl("ex_dt1_11_office_01c")	-- Old Spice Vintage
  			-- RequestIpl("ex_dt1_11_office_03a")	-- Power Broker Ice
  			-- RequestIpl("ex_dt1_11_office_03b")	-- Power Broker Conservative
  			-- RequestIpl("ex_dt1_11_office_03c")	-- Power Broker Polished

  			-- Lom Bank
  			-- RequestIpl("ex_sm_13_office_02b")	-- Executive Rich
  			-- RequestIpl("ex_sm_13_office_02c")	-- Executive Cool
  			RequestIpl("ex_sm_13_office_02a")	-- Executive Contrast -1580.9864501954,-561.48498535156,108.52289581298
  			-- RequestIpl("ex_sm_13_office_01a")	-- Old Spice Warm
  			-- RequestIpl("ex_sm_13_office_01b")	-- Old Spice Classical
  			-- RequestIpl("ex_sm_13_office_01c")	-- Old Spice Vintage
  			-- RequestIpl("ex_sm_13_office_03a")	-- Power Broker Ice
  			-- RequestIpl("ex_sm_13_office_03b")	-- Power Broker Conservative
  			-- RequestIpl("ex_sm_13_office_03c")	-- Power Broker Polished

  			-- Maze Bank West
  			RequestIpl("ex_sm_15_office_02b")	-- Executive Rich
  			-- RequestIpl("ex_sm_15_office_02c")	-- Executive Cool
  			-- RequestIpl("ex_sm_15_office_02a")	-- Executive Contrast
  			-- RequestIpl("ex_sm_15_office_01a")	-- Old Spice Warm
  			-- RequestIpl("ex_sm_15_office_01b")	-- Old Spice Classical
  			-- RequestIpl("ex_sm_15_office_01c")	-- Old Spice Vintage
  			-- RequestIpl("ex_sm_15_office_03a")	-- Power Broker Ice
  			-- RequestIpl("ex_sm_15_office_03b")	-- Power Broker Convservative
  			-- RequestIpl("ex_sm_15_office_03c")	-- Power Broker Polished

        -- Biker Clubhouse 1: 1107.04, -3157.399, -37.519
  			RequestIpl("bkr_biker_interior_placement_interior_0_biker_dlc_int_01_milo")
        -- Clubhouse 2: 998.4809, -3164.711, -38.907
        RequestIpl("bkr_biker_interior_placement_interior_1_biker_dlc_int_02_milo")

        -- Warehouse 1: 1009.5, -3196.6, -39
      	RequestIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware01_milo")
      	RequestIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware02_milo")
      	RequestIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware03_milo")
      	RequestIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware04_milo")
      	RequestIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware05_milo")

      	-- Warehouse 2: 1051.491, -3196.536, -39.148
      	RequestIpl("bkr_biker_interior_placement_interior_3_biker_dlc_int_ware02_milo")

      	-- Warehouse 3: 1093.6, -3196.6, -38.998
      	RequestIpl("bkr_biker_interior_placement_interior_4_biker_dlc_int_ware03_milo")

      	-- Warehouse 4: 1121.897, -3195.338, -40.4025
      	RequestIpl("bkr_biker_interior_placement_interior_5_biker_dlc_int_ware04_milo")

      	-- Warehouse 5: 1165, -3196.6, -39.013
      	RequestIpl("bkr_biker_interior_placement_interior_6_biker_dlc_int_ware05_milo")

      	-- Warehouse Small: 1094.988, -3101.776, -39
      	RequestIpl("ex_exec_warehouse_placement_interior_1_int_warehouse_s_dlc_milo")

      	-- Warehouse Medium: 1056.486, -3105.724, -39
      	RequestIpl("ex_exec_warehouse_placement_interior_0_int_warehouse_m_dlc_milo")

      	-- Warehouse Large: 1006.967, -3102.079, -39.0035
      	RequestIpl("ex_exec_warehouse_placement_interior_2_int_warehouse_l_dlc_milo")

        -- Import / Export Garage: 994.593, -3002.594, -39.647
  			RequestIpl("imp_impexp_interior_placement")
  			RequestIpl("imp_impexp_interior_placement_interior_0_impexp_int_01_milo_")
  			RequestIpl("imp_impexp_interior_placement_interior_3_impexp_int_02_milo_")
  			RequestIpl("imp_impexp_interior_placement_interior_1_impexp_intwaremed_milo_")
  			RequestIpl("imp_impexp_interior_placement_interior_2_imptexp_mod_int_01_milo_")
        --Interior IMPORT/EXPORT
  			RequestIpl("imp_dt1_02_modgarage")
  			RequestIpl("imp_dt1_02_cargarage_a")
  			RequestIpl("imp_dt1_02_cargarage_b")
  			RequestIpl("imp_dt1_02_cargarage_c")
  			RequestIpl("imp_dt1_11_modgarage")
  			RequestIpl("imp_dt1_11_cargarage_a")
  			RequestIpl("imp_dt1_11_cargarage_b")
  			RequestIpl("imp_dt1_11_cargarage_c")
  			RequestIpl("imp_sm_13_modgarage")
  			RequestIpl("imp_sm_13_cargarage_a")
  			RequestIpl("imp_sm_13_cargarage_b")
  			RequestIpl("imp_sm_13_cargarage_c")
  			RequestIpl("imp_sm_15_modgarage")
  			RequestIpl("imp_sm_15_cargarage_a")
  			RequestIpl("imp_sm_15_cargarage_b")
  			RequestIpl("imp_sm_15_cargarage_c")
  end)
  Citizen.CreateThread(function()
  	for _,ipl in pairs(allIpls) do
  		loadInt(ipl.coords, ipl.interiorsProps)
  	end
  end)
end

function loadInt(coordsTable, table)
	for _,coords in pairs(coordsTable) do
		local interiorID = GetInteriorAtCoords(coords[1], coords[2], coords[3])
		LoadInterior(interiorID)
		for _,propName in pairs(table) do
			Citizen.Wait(25)
			EnableInteriorProp(interiorID, propName)
		end

		RefreshInterior(interiorID)
	end
end

allIpls = {
	-- 			METH LAB

	{
		names = {"bkr_biker_interior_placement_interior_2_biker_dlc_int_ware01_milo"},
		interiorsProps = {

			--"meth_lab_basic",
			--"meth_lab_empty",
			--"meth_lab_production",
			"meth_lab_security_high",
			--"meth_lab_setup",
			"meth_lab_upgrade",

		},
		coords={{1009.5, -3196.6, -38.99682}}
	},

	-- 			WEED LAB

	{
		interiorsProps = {
			"weed_drying",
			"weed_production",
			--"weed_set_up",
			--"weed_standard_equip",
			"weed_upgrade_equip",
			--"weed_growtha_stage1",
			--"weed_growtha_stage2",
			"weed_growtha_stage3",
			--"weed_growthb_stage1",
			--"weed_growthb_stage2",
			--"weed_growthb_stage3",
			"weed_growthc_stage1",
			--"weed_growthc_stage2",
			--"weed_growthc_stage3",
			"weed_growthd_stage1",
			--"weed_growthd_stage2",
			--"weed_growthd_stage3",
			--"weed_growthe_stage1",
			"weed_growthe_stage2",
			--"weed_growthe_stage3",
			--"weed_growthf_stage1",
			"weed_growthf_stage2",
			--"weed_growthf_stage3",
			"weed_growthg_stage1",
			--"weed_growthg_stage2",
			--"weed_growthg_stage3",
			--"weed_growthh_stage1",
			--"weed_growthh_stage2",
			"weed_growthh_stage3",
			--"weed_growthi_stage1",
			"weed_growthi_stage2",
			--"weed_growthi_stage3",
			"weed_hosea",
			"weed_hoseb",
			"weed_hosec",
			"weed_hosed",
			"weed_hosee",
			"weed_hosef",
			"weed_hoseg",
			"weed_hoseh",
			"weed_hosei",
			--"light_growtha_stage23_standard",
			--"light_growthb_stage23_standard",
			--"light_growthc_stage23_standard",
			--"light_growthd_stage23_standard",
			--"light_growthe_stage23_standard",
			--"light_growthf_stage23_standard",
			--"light_growthg_stage23_standard",
			--"light_growthh_stage23_standard",
			--"light_growthi_stage23_standard",
			"light_growtha_stage23_upgrade",
			"light_growthb_stage23_upgrade",
			"light_growthc_stage23_upgrade",
			"light_growthc_stage23_upgrade",
			"light_growthd_stage23_upgrade",
			"light_growthe_stage23_upgrade",
			"light_growthf_stage23_upgrade",
			"light_growthg_stage23_upgrade",
			"light_growthh_stage23_upgrade",
			"light_growthi_stage23_upgrade",
			--"weed_low_security",
			"weed_security_upgrade",
			"weed_chairs"
		},
		coords={{1051.491, -3196.536, -39.14842}}
	},

	-- 			Cocaine LAB

	{
		interiorsProps = {

			--"security_low",
			"security_high",
			"equipment_basic",
			"equipment_upgrade",
			--"set_up",
			--"production_basic",
			"production_upgrade",
			--"table_equipment",
			"table_equipment_upgrade",
			--"coke_press_basic",
			"coke_press_upgrade",
			"coke_cut_01",
			"coke_cut_02",
			"coke_cut_03",
			"coke_cut_04",
			"coke_cut_05"
		},
		coords={{1093.6, -3196.6, -38.99841}}
	},

	-- 			BUNKERS

	{
		interiorsProps = {
			--"Bunker_Style_A",
			--"Bunker_Style_B",
			"Bunker_Style_C",
			--"standard_bunker_set",
			"upgrade_bunker_set",
			--"standard_security_set",
			"security_upgrade",
			--"Office_blocker_set",
			"Office_Upgrade_set",
			--"gun_range_blocker_set",
			"gun_wall_blocker",
			"gun_range_lights",
			"gun_locker_upgrade",
			"Gun_schematic_set"
		},
		coords={{899.5518,-3246.038, -98.04907}}
	},

	-- 			FIB Lobby

	{
		interiorsProps = {
			"V_FIB03_door_light",
			"V_FIB02_set_AH3b",
			"V_FIB03_set_AH3b",
			"V_FIB04_set_AH3b"
		},
		coords={{110.4, -744.2, 45.7496}}
	},

	-- 			Counterfeit Cash Factory

	{
		interiorsProps = {
			--"counterfeit_cashpile10a",
			--"counterfeit_cashpile10b",
			--"counterfeit_cashpile10c",
			"counterfeit_cashpile10d",
			--"counterfeit_cashpile20a",
			--"counterfeit_cashpile20b",
			--"counterfeit_cashpile20c",
			"counterfeit_cashpile20d",
			--"counterfeit_cashpile100a",
			--"counterfeit_cashpile100b",
			--"counterfeit_cashpile100c",
			"counterfeit_cashpile100d",
			--"counterfeit_low_security",
			"counterfeit_security",
			--"counterfeit_setup",
			--"counterfeit_standard_equip",
			--"counterfeit_standard_equip_no_prod",
			"counterfeit_upgrade_equip",
			--"counterfeit_upgrade_equip_no_prod",
			"money_cutter",
			"special_chairs",
			--"dryera_off",
			"dryera_on",
			"dryera_open",
			--"dryerb_off",
			"dryerb_on",
			"dryerb_open",
			--"dryerc_off",
			"dryerc_on",
			"dryerc_open",
			--"dryerd_off",
			"dryerd_on",
			"dryerd_open"
		},
		coords={{1121.897, -3195.338, -40.4025}}
	},

	-- 			CLUBHOUSE 1

	{
		interiorsProps = {
			--"cash_stash1",
			--"cash_stash2",
			"cash_stash3",
			--"coke_stash1",
			--"coke_stash2",
			"coke_stash3",
			--"counterfeit_stash1",
			--"counterfeit_stash2",
			"counterfeit_stash3",
			--"weed_stash1",
			--"weed_stash2",
			"weed_stash3",
			--"id_stash1",
			--"id_stash2",
			"id_stash3",
			--"meth_stash1",
			--"meth_stash2",
			"meth_stash3",
			--"decorative_01",
			"decorative_02",
			--"furnishings_01",
			"furnishings_02",
			--"walls_01",
			"walls_02",
			--"mural_01",
			--"mural_02",
			--"mural_03",
			--"mural_04",
			--"mural_05",
			--"mural_06",
			--"mural_07",
			--"mural_08",
			"mural_09",
			"gun_locker",
			"mod_booth",
			--"no_gun_locker",
			--"no_mod_booth"
		},
		coords={{1107.04, -3157.399, -37.51859}}
	},

	--			CLUBHOUSE 2

	{
		interiorsProps = {
			"cash_large",
			--"cash_medium",
			--"cash_small",
			"coke_large",
			--"coke_medium",
			--"coke_small",
			"counterfeit_large",
			--"counterfeit_medium",
			--"counterfeit_small",
			"id_large",
			--"id_medium",
			--"id_small",
			"meth_large",
			--"meth_medium",
			--"meth_small",
			"weed_large",
			--"weed_medium",
			--"weed_small",
			--"decorative_01",
			"decorative_02",
			--"furnishings_01",
			"furnishings_02",
			--"walls_01",
			"walls_02",
			"lower_walls_default",
			"gun_locker",
			"mod_booth",
			--"no_gun_locker",
			--"no_mod_booth"
		},
		coords={{998.4809, -3164.711, -38.90733}}
	},

	-- 			IMPORT / EXPORT GARAGES

	{
		interiorsProps = {
			"garage_decor_01",
			"garage_decor_02",
			"garage_decor_03",
			"garage_decor_04",
			"lighting_option01",
			"lighting_option02",
			"lighting_option03",
			"lighting_option04",
			"lighting_option05",
			"lighting_option06",
			"lighting_option07",
			"lighting_option08",
			"lighting_option09",
			--"numbering_style01_n1",
			--"numbering_style01_n2",
			"numbering_style01_n3",
			--"numbering_style02_n1",
			--"numbering_style02_n2",
			"numbering_style02_n3",
			--"numbering_style03_n1",
			--"numbering_style03_n2",
			"numbering_style03_n3",
			--"numbering_style04_n1",
			--"numbering_style04_n2",
			"numbering_style04_n3",
			--"numbering_style05_n1",
			--"numbering_style05_n2",
			"numbering_style05_n3",
			--"numbering_style06_n1",
			--"numbering_style06_n2",
			"numbering_style06_n3",
			--"numbering_style07_n1",
			--"numbering_style07_n2",
			"numbering_style07_n3",
			--"numbering_style08_n1",
			--"numbering_style08_n2",
			"numbering_style08_n3",
			--"numbering_style09_n1",
			--"numbering_style09_n2",
			"numbering_style09_n3",
			"floor_vinyl_01",
			"floor_vinyl_02",
			"floor_vinyl_03",
			"floor_vinyl_04",
			"floor_vinyl_05",
			"floor_vinyl_06",
			"floor_vinyl_07",
			"floor_vinyl_08",
			"floor_vinyl_09",
			"floor_vinyl_10",
			"floor_vinyl_11",
			"floor_vinyl_12",
			"floor_vinyl_13",
			"floor_vinyl_14",
			"floor_vinyl_15",
			"floor_vinyl_16",
			"floor_vinyl_17",
			"floor_vinyl_18",
			"floor_vinyl_19",
			--"basic_style_set",
			--"branded_style_set",
			"urban_style_set",
			"car_floor_hatch",
			"door_blocker"
		},
		coords={{994.5925, -3002.594, -39.64699}}
	},

	-- 			CEO OFFICES

	{
		interiorsProps = {
			--"cash_set_01",
			--"cash_set_02",
			--"cash_set_03",
			--"cash_set_04",
			--"cash_set_05",
			--"cash_set_06",
			--"cash_set_07",
			--"cash_set_08",
			--"cash_set_09",
			--"cash_set_10",
			--"cash_set_11",
			--"cash_set_12",
			--"cash_set_13",
			--"cash_set_14",
			--"cash_set_15",
			--"cash_set_16",
			--"cash_set_17",
			--"cash_set_18",
			--"cash_set_19",
			--"cash_set_20",
			--"cash_set_21",
			--"cash_set_22",
			--"cash_set_23",
			--"cash_set_24",
			--"office_booze",
			"office_chairs",
			--"swag_art",
			--"swag_art2",
			"swag_art3",
			--"swag_booze_cigs",
			--"swag_booze_cigs2",
			--"swag_booze_cigs3",
			--"swag_counterfeit",
			--"swag_counterfeit2",
			"swag_counterfeit3",
			--"swag_drugbags",
			--"swag_drugbags2",
			--"swag_drugbags3",
			--"swag_drugstatue",
			--"swag_drugstatue2",
			--"swag_drugstatue3",
			--"swag_electronic",
			--"swag_electronic2",
			--"swag_electronic3",
			--"swag_furcoats",
			--"swag_furcoats2",
			--"swag_furcoats3",
			--"swag_gems",
			--"swag_gems2",
			--"swag_gems3",
			--"swag_guns",
			--"swag_guns2",
			--"swag_guns3",
			--"swag_ivory",
			--"swag_ivory2",
			--"swag_ivory3",
			--"swag_jewelwatch",
			"swag_jewelwatch2",
			--"swag_jewelwatch3",
			--"swag_med",
			--"swag_med2",
			--"swag_med3",
			--"swag_pills",
			--"swag_pills2",
			--"swag_pills3",
			--"swag_silver",
			--"swag_silver2",
			--"swag_silver3"
		},
		coords={{-141.1987, -620.913, 168.8205}, {-141.5429, -620.9524, 168.8204}, {-141.2896, -620.9618, 168.8204}, {-141.4966, -620.8292, 168.8204}, {-141.3997, -620.9006, 168.8204}, {-141.5361, -620.9186, 168.8204}, {-141.392, -621.0451, 168.8204}, {-141.1945, -620.8729, 168.8204}, {-141.4924, -621.0035, 168.8205},
				{-75.8466, -826.9893, 243.3859}, {-75.49945, -827.05, 243.386}, {-75.49827, -827.1889, 243.386}, {-75.44054, -827.1487, 243.3859}, {-75.63942, -827.1022, 243.3859}, {-75.47446, -827.2621, 243.386}, {-75.56978, -827.1152, 243.3859}, {-75.51953, -827.0786, 243.3859}, {-75.41915, -827.1118, 243.3858},
				{-1579.756, -565.0661, 108.523}, {-1579.678, -565.0034, 108.5229}, {-1579.583, -565.0399, 108.5229}, {-1579.702, -565.0366, 108.5229}, {-1579.643, -564.9685, 108.5229}, {-1579.681, -565.0003, 108.523}, {-1579.677, -565.0689, 108.5229}, {-1579.708, -564.9634, 108.5229}, {-1579.693, -564.8981, 108.5229},
			    {-1392.667, -480.4736, 72.04217}, {-1392.542, -480.4011, 72.04211}, {-1392.626, -480.4856, 72.04212}, {-1392.617, -480.6363, 72.04208}, {-1392.532, -480.7649, 72.04207}, {-1392.611, -480.5562, 72.04214}, {-1392.563, -480.549, 72.0421}, {-1392.528, -480.475, 72.04206}, {-1392.416, -480.7485, 72.04207}}
	},

	-- 			CEO GARAGES

	{
		interiorsProps = {
			--"garage_decor_01",
			--"garage_decor_02",
			--"garage_decor_03",
			"garage_decor_04",
			--"lighting_option01",
			--"lighting_option02",
			--"lighting_option03",
			--"lighting_option04",
			--"lighting_option05",
			--"lighting_option06",
			--"lighting_option07",
			--"lighting_option08",
			"lighting_option09",
			"numbering_style01_n1",
			--"numbering_style01_n2",
			--"numbering_style01_n3",
			"numbering_style02_n1",
			--"numbering_style02_n2",
			--"numbering_style02_n3",
			"numbering_style03_n1",
			--"numbering_style03_n2",
			--"numbering_style03_n3",
			"numbering_style04_n1",
			--"numbering_style04_n2",
			--"numbering_style04_n3",
			"numbering_style05_n1",
			--"numbering_style05_n2",
			--"numbering_style05_n3",
			"numbering_style06_n1",
			--"numbering_style06_n2",
			--"numbering_style06_n3",
			"numbering_style07_n1",
			--"numbering_style07_n2",
			--"numbering_style07_n3",
			"numbering_style08_n1",
			--"numbering_style08_n2",
			--"numbering_style08_n3",
			"numbering_style09_n1",
			--"numbering_style09_n2",
			--"numbering_style09_n3",
			"basic_style_set"
		},
		coords={{795.75439453125, -2997.3317871094, -22.960731506348}}
	},

	-- 			CEO VEHICLES SHOPS

	{
		interiorsProps = {
			--"floor_vinyl_01",
			--"floor_vinyl_02",
			"floor_vinyl_03",
			--"floor_vinyl_04",
			--"floor_vinyl_05",
			--"floor_vinyl_06",
			--"floor_vinyl_07",
			--"floor_vinyl_08",
			--"floor_vinyl_09",
			--"floor_vinyl_10",
			--"floor_vinyl_11",
			--"floor_vinyl_12",
			--"floor_vinyl_13",
			--"floor_vinyl_14",
			--"floor_vinyl_15",
			--"floor_vinyl_16",
			--"floor_vinyl_17",
			--"floor_vinyl_18",
			--"floor_vinyl_19"
		},
		coords={{730.63916015625, -2993.2373046875, -38.999904632568}}
	},

	-- 			BIKERS Document Forgery Office

	{
		interiorsProps = {
			"chair01",
			"chair02",
			"chair03",
			"chair04",
			"chair05",
			"chair06",
			"chair07",
			"clutter",
			--"equipment_basic",
			"equipment_upgrade",
			--"interior_basic",
			"interior_upgrade",
			"production",
			"security_high",
			--"security_low",
			"set_up"
		},
		coords={{1163.842,-3195.7,-39.008}}
	}
}
