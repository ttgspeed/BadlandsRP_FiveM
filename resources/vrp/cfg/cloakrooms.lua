
-- this file configure the cloakrooms on the map

local cfg = {}

-- cloakroom types (_config, map of name => customization)
cfg.cloakroom_types = {
  ["police"] = {
    _config = { permission = "police.cloakroom" },
    ["Male Uniform"] = {
      [3] = {30,0},
      [4] = {25,2},
      [6] = {24,0},
      [8] = {58,0},
      [9] = {0,0},
      [11] = {55,0},
      ["p2"] = {2,0}
    },
    ["Male Uniform w/Vest"] = {
      [3] = {30,0},
      [4] = {25,2},
      [6] = {24,0},
      [8] = {58,0},
      [9] = {4,1},
      [11] = {55,0},
      ["p2"] = {2,0}
    },
    ["Female Uniform"] = {
      [3] = {44,0},
      [4] = {34,0},
      [6] = {24,0},
      [8] = {35,0},
      [9] = {0,0},
      [11] = {48,0},
      ["p2"] = {0,0}
    }
  },
  ["emergency"] = {
    _config = { permission = "emergency.cloakroom" },
    ["Male Uniform"] = {
      [3] = {92,0},
      [4] = {9,3},
      [6] = {25,0},
      [8] = {15,0},
      [9] = {0,0},
      [11] = {13,3}
    },
    ["EMS Female Model"] = {
      modelhash = 's_f_y_scrubs_01'
    },
    ["EMS Male Model"] = {
      modelhash = 's_m_m_paramedic_01'
    },
    ["Fireman Model"] = {
      modelhash = 's_m_y_fireman_01'
    }
  }
}

cfg.cloakrooms = {
  {"police", 454.324096679688,-991.499938964844,30.6895771026611},
  {"emergency", -499.814208984375,-343.751922607422,34.5018157958984},
  {"police",1848.84899902344,3689.41845703125,34.2670860290527},
  {"emergency",1689.78698730469,3590.32543945313,35.620964050293},
  {"police",-1126.89367675781,-834.825378417969,13.4480028152466}
}

return cfg
