
-- define emotes
-- use the custom emotes admin action to test emotes on-the-fly
-- animation list: http://docs.ragepluginhook.net/html/62951c37-a440-478c-b389-c471230ddfc5.htm

local cfg = {}

-- map of emote_name => {upper,seq,looping}
-- seq can also be a task definition, check the examples below
cfg.emotes = {
  ["Handsup"] = { -- handsup state, use clear to lower hands
    true,
    { -- sequence, list of {dict,name,loops}
      {"random@mugging3", "handsup_standing_base", 1}
    },
    true
  },
  ["No"] = {
    true, {{"gestures@f@standing@casual","gesture_head_no",1}}, false
  },
  ["Damn"] = {
    true, {{"gestures@f@standing@casual","gesture_damn",1}}, false
  },
  ["Dance"] = {
    false, {
      {"rcmnigel1bnmt_1b","dance_intro_tyler",1},
      {"rcmnigel1bnmt_1b","dance_loop_tyler",1}
    }, false
  },
  ["Salute"] = {true,{{"mp_player_int_uppersalute","mp_player_int_salute",1}},false},
  ["Rock"] = {true,{{"mp_player_introck","mp_player_int_rock",1}},false},
  ["Clipboard"] = {false, {task="WORLD_HUMAN_CLIPBOARD"},false},
  ["Sit Chair"] = {false, {task="PROP_HUMAN_SEAT_CHAIR_MP_PLAYER"}, false},
  ["Cop"] = {false, {task="WORLD_HUMAN_COP_IDLES"}, false},
  --["Binoculars"] = {false, {task="WORLD_HUMAN_BINOCULARS"}, false},
  ["Cheer"] = {false, {task="WORLD_HUMAN_CHEERING"}, false},
  ["Drink"] = {false, {task="WORLD_HUMAN_DRINKING"}, false},
--  ["Smoke"] = {false, {task="WORLD_HUMAN_SMOKING"}, false},
  ["Film"] = {false, {task="WORLD_HUMAN_MOBILE_FILM_SHOCKING"}, false},
  ["Plant"] = {false, {task="WORLD_HUMAN_GARDENER_PLANT"}, false},
  ["Guard"] = {false, {task="WORLD_HUMAN_GUARD_STAND"}, false},
  ["Hammer"] = {false, {task="WORLD_HUMAN_HAMMERING"}, false},
  ["Hangout"] = {false, {task="WORLD_HUMAN_HANG_OUT_STREET"}, false},
  ["Hiker"] = {false, {task="WORLD_HUMAN_HIKER_STANDING"}, false},
  ["Statue"] = {false, {task="WORLD_HUMAN_HUMAN_STATUE"}, false},
  ["Jog"] = {false, {task="WORLD_HUMAN_JOG_STANDING"}, false},
  ["Lean"] = {false, {task="WORLD_HUMAN_LEANING"}, false},
  ["Flex"] = {false, {task="WORLD_HUMAN_MUSCLE_FLEX"}, false},
  ["Camera"] = {false, {task="WORLD_HUMAN_PAPARAZZI"}, false},
  ["Sit"] = {false, {task="WORLD_HUMAN_PICNIC"}, false},
  ["Hoe"] = {false, {task="WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"}, false},
  ["Hoe2"] = {false, {task="WORLD_HUMAN_PROSTITUTE_LOW_CLASS"}, false},
  ["Pushups"] = {false, {task="WORLD_HUMAN_PUSH_UPS"}, false},
  ["Situps"] = {false, {task="WORLD_HUMAN_SIT_UPS"}, false},
--  ["Fish"] = {false, {task="WORLD_HUMAN_STAND_FISHING"}, false},
  ["Impatient"] = {false, {task="WORLD_HUMAN_STAND_IMPATIENT"}, false},
  ["Mobile"] = {false, {task="WORLD_HUMAN_STAND_MOBILE"}, false},
  ["Diggit"] = {false, {task="WORLD_HUMAN_STRIP_WATCH_STAND"}, false},
  ["Sunbath"] = {false, {task="WORLD_HUMAN_SUNBATHE_BACK"}, false},
  ["Sunbath2"] = {false, {task="WORLD_HUMAN_SUNBATHE"}, false},
  ["Weld"] = {false, {task="WORLD_HUMAN_WELDING"}, false},
  ["Kneel"] = {false, {task="CODE_HUMAN_MEDIC_KNEEL"}, false},
  ["Drill"] = {false, {task="WORLD_HUMAN_CONST_DRILL"}, false},
  ["Coffee"] = {false, {task="WORLD_HUMAN_AA_COFFEE"}, false},
  ["Party"] = {false, {task="WORLD_HUMAN_PARTYING"}, false},
  ["Mechanic"] = {false, {task="WORLD_HUMAN_VEHICLE_MECHANIC"}, false},
  ["Parking Meter"] = {false, {task="PROP_HUMAN_PARKING_METER"}, false},
  --["Golf"] = {false, {task="WORLD_HUMAN_GOLF_PLAYER"}, false},
  ["Leaf Blower"] = {false, {task="WORLD_HUMAN_GARDENER_LEAF_BLOWER"}, false},
  ["Janitor"] = {false, {task="WORLD_HUMAN_JANITOR"}, false},
  ["Bum Standing"] = {false, {task="WORLD_HUMAN_BUM_STANDING"}, false},
  --["Musician"] = {false, {task="WORLD_HUMAN_MUSICIAN"}, false},
  ["Bum Slumped"] = {false, {task="WORLD_HUMAN_BUM_SLUMPED"}, false},
  ["Puff Puff"] = {false, {task="WORLD_HUMAN_DRUG_DEALER"}, false},
  ["Beggar"] = {false, {task="WORLD_HUMAN_BUM_FREEWAY"}, false},
  ["Traffic"] = {false, {task="WORLD_HUMAN_CAR_PARK_ATTENDANT"}, false},
  ["Wash Windows"] = {false, {task="WORLD_HUMAN_MAID_CLEAN"}, false},
  ["Bum Wash"] = {false, {task="WORLD_HUMAN_BUM_WASH"}, false},
  ["Tourist"] = {false, {task="WORLD_HUMAN_TOURIST_MAP"}, false},
  ["Tend To Dead"] = {false, {task="CODE_HUMAN_MEDIC_TEND_TO_DEAD"}, false},
  ["Notepad"] = {false, {task="CODE_HUMAN_MEDIC_TIME_OF_DEATH"}, false},
  ["Crowd Control"] = {false, {task="CODE_HUMAN_POLICE_CROWD_CONTROL"}, false},
  ["Investigate"] = {false, {task="CODE_HUMAN_POLICE_INVESTIGATE"}, false},
  ["Yoga"] = {false, {task="WORLD_HUMAN_YOGA"}, false},
  ["Flip Off"] = {true, {{"mp_player_intfinger", "mp_player_int_finger", 1}}, false},
  ["Wank"] = {true, {{"mp_player_intwank", "mp_player_int_wank", 1}}, false},
  ["Up Yours"] = {true, {{"mp_player_int_upperup_yours", "mp_player_int_up_yours_enter", 1}},false},
  ["Tit Squeeze"] = {true, {{"mp_player_int_uppertit_squeeze", "mp_player_int_tit_squeeze", 1},}, false},
  ["Peace Sign"] = {true,{{"mp_player_int_upperpeace_sign", "mp_player_int_peace_sign", 1}}, false},
  ["Grab Crotch"] = {true, {{"mp_player_int_uppergrab_crotch", "mp_player_int_grab_crotch", 1}}, false},
  ["Gang Sign 1"] = {true, {{"mp_player_int_uppergang_sign_a", "mp_player_int_gang_sign_a", 1}}, false},
  ["Gang Sign 2"] = {true, {{"mp_player_int_uppergang_sign_b", "mp_player_int_gang_sign_b", 1}}, false}
}

cfg.chatEmotes = {
  ["handsup"] = { -- handsup state, use clear to lower hands
    true,
    { -- sequence, list of {dict,name,loops}
      {"random@mugging3", "handsup_standing_base", 1}
    },
    true
  },
  ["no"] = {
    true, {{"gestures@f@standing@casual","gesture_head_no",1}}, false
  },
  ["damn"] = {
    true, {{"gestures@f@standing@casual","gesture_damn",1}}, false
  },
  ["shrug"] = {
    true, {{"gestures@f@standing@casual","gesture_shrug_hard",1}}, false
  },
  ["what"] = {
    true, {{"gestures@f@standing@casual","gesture_what_hard",1}}, false
  },
  ["dance"] = {
    false, {
      {"rcmnigel1bnmt_1b","dance_intro_tyler",1},
      {"rcmnigel1bnmt_1b","dance_loop_tyler",1}
    }, false
  },
  ["salute"] = {true,{{"mp_player_int_uppersalute","mp_player_int_salute",1}},false},
  ["rock"] = {true,{{"mp_player_introck","mp_player_int_rock",1}},false},
  ["clipboard"] = {false, {task="WORLD_HUMAN_CLIPBOARD"},false},
  ["sitchair"] = {false, {task="PROP_HUMAN_SEAT_CHAIR_MP_PLAYER"}, false},
  ["cop"] = {false, {task="WORLD_HUMAN_COP_IDLES"}, false},
  --["Binoculars"] = {false, {task="WORLD_HUMAN_BINOCULARS"}, false},
  ["cheer"] = {false, {task="WORLD_HUMAN_CHEERING"}, false},
  ["drink"] = {false, {task="WORLD_HUMAN_DRINKING"}, false},
  ["dealer"] = {false, {task="world_human_drug_dealer_hard"}, false},
  ["tennis"] = {false, {task="world_human_tennis_player"}, false},
  ["stupor"] = {false, {task="world_human_stupor"}, false},
--  ["Smoke"] = {false, {task="WORLD_HUMAN_SMOKING"}, false},
  ["film"] = {false, {task="WORLD_HUMAN_MOBILE_FILM_SHOCKING"}, false},
  ["plant"] = {false, {task="WORLD_HUMAN_GARDENER_PLANT"}, false},
  ["guard"] = {false, {task="WORLD_HUMAN_GUARD_STAND"}, false},
  ["hammer"] = {false, {task="WORLD_HUMAN_HAMMERING"}, false},
  ["hangout"] = {false, {task="WORLD_HUMAN_HANG_OUT_STREET"}, false},
  ["hiker"] = {false, {task="WORLD_HUMAN_HIKER_STANDING"}, false},
  ["statue"] = {false, {task="WORLD_HUMAN_HUMAN_STATUE"}, false},
  ["jog"] = {false, {task="WORLD_HUMAN_JOG_STANDING"}, false},
  ["lean"] = {false, {task="WORLD_HUMAN_LEANING"}, false},
  ["flex"] = {false, {task="WORLD_HUMAN_MUSCLE_FLEX"}, false},
  ["camera"] = {false, {task="WORLD_HUMAN_PAPARAZZI"}, false},
  ["sit"] = {false, {task="WORLD_HUMAN_PICNIC"}, false},
  ["hoe"] = {false, {task="WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"}, false},
  ["hoe2"] = {false, {task="WORLD_HUMAN_PROSTITUTE_LOW_CLASS"}, false},
  ["pushups"] = {false, {task="WORLD_HUMAN_PUSH_UPS"}, false},
  ["situps"] = {false, {task="WORLD_HUMAN_SIT_UPS"}, false},
  ["impatient"] = {false, {task="WORLD_HUMAN_STAND_IMPATIENT"}, false},
  ["mobile"] = {false, {task="WORLD_HUMAN_STAND_MOBILE"}, false},
  ["diggit"] = {false, {task="WORLD_HUMAN_STRIP_WATCH_STAND"}, false},
  ["sunbath"] = {false, {task="WORLD_HUMAN_SUNBATHE_BACK"}, false},
  ["sunbath2"] = {false, {task="WORLD_HUMAN_SUNBATHE"}, false},
  ["weld"] = {false, {task="WORLD_HUMAN_WELDING"}, false},
  ["kneel"] = {false, {task="CODE_HUMAN_MEDIC_KNEEL"}, false},
  ["drill"] = {false, {task="WORLD_HUMAN_CONST_DRILL"}, false},
  ["coffee"] = {false, {task="WORLD_HUMAN_AA_COFFEE"}, false},
  ["party"] = {false, {task="WORLD_HUMAN_PARTYING"}, false},
  ["mechanic"] = {false, {task="WORLD_HUMAN_VEHICLE_MECHANIC"}, false},
  ["parkingmeter"] = {false, {task="PROP_HUMAN_PARKING_METER"}, false},
  ["leafblower"] = {false, {task="WORLD_HUMAN_GARDENER_LEAF_BLOWER"}, false},
  ["janitor"] = {false, {task="WORLD_HUMAN_JANITOR"}, false},
  ["bumstanding"] = {false, {task="WORLD_HUMAN_BUM_STANDING"}, false},
  ["musician"] = {false, {task="WORLD_HUMAN_MUSICIAN"}, false},
  ["bumslumped"] = {false, {task="WORLD_HUMAN_BUM_SLUMPED"}, false},
  ["puffpuff"] = {false, {task="WORLD_HUMAN_DRUG_DEALER"}, false},
  ["beggar"] = {false, {task="WORLD_HUMAN_BUM_FREEWAY"}, false},
  ["traffic"] = {false, {task="WORLD_HUMAN_CAR_PARK_ATTENDANT"}, false},
  ["washwindows"] = {false, {task="WORLD_HUMAN_MAID_CLEAN"}, false},
  ["bumwash"] = {false, {task="WORLD_HUMAN_BUM_WASH"}, false},
  ["tourist"] = {false, {task="WORLD_HUMAN_TOURIST_MAP"}, false},
  ["tendtodead"] = {false, {task="CODE_HUMAN_MEDIC_TEND_TO_DEAD"}, false},
  ["notepad"] = {false, {task="CODE_HUMAN_MEDIC_TIME_OF_DEATH"}, false},
  ["crowdcontrol"] = {false, {task="CODE_HUMAN_POLICE_CROWD_CONTROL"}, false},
  ["investigate"] = {false, {task="CODE_HUMAN_POLICE_INVESTIGATE"}, false},
  ["yoga"] = {false, {task="WORLD_HUMAN_YOGA"}, false},
  ["flipoff"] = {true, {{"mp_player_intfinger", "mp_player_int_finger", 1}}, false},
  ["wank"] = {true, {{"mp_player_intwank", "mp_player_int_wank", 1}}, false},
  ["upyours"] = {true, {{"mp_player_int_upperup_yours", "mp_player_int_up_yours_enter", 1}},false},
  ["titsqueeze"] = {true, {{"mp_player_int_uppertit_squeeze", "mp_player_int_tit_squeeze", 1},}, false},
  ["peacesign"] = {true,{{"mp_player_int_upperpeace_sign", "mp_player_int_peace_sign", 1}}, false},
  ["grabcrotch"] = {true, {{"mp_player_int_uppergrab_crotch", "mp_player_int_grab_crotch", 1}}, false},
  ["gangsign1"] = {true, {{"mp_player_int_uppergang_sign_a", "mp_player_int_gang_sign_a", 1}}, false},
  ["gangsign2"] = {true, {{"mp_player_int_uppergang_sign_b", "mp_player_int_gang_sign_b", 1}}, false}
}

return cfg
