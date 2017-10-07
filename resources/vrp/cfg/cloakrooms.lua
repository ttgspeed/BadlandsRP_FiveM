
-- this file configure the cloakrooms on the map

local cfg = {}

-- prepare surgeries customizations
local surgery_male = { model = "mp_m_freemode_01" }
local surgery_female = { model = "mp_f_freemode_01" }

for i=0,19 do
  surgery_female[i] = {0,0}
  surgery_male[i] = {0,0}
end

-- cloakroom types (_config, map of name => customization)
--- _config:
---- permissions (optional)
---- not_uniform (optional): if true, the cloakroom will take effect directly on the player, not as a uniform you can remove
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
    ["Male Police Model"] = {
      modelhash = 's_m_y_cop_01'
    },
    ["Female Uniform"] = {
      [3] = {44,0},
      [4] = {34,0},
      [6] = {24,0},
      [8] = {35,0},
      [9] = {0,0},
      [11] = {48,0},
      ["p2"] = {0,0}
    },
    ["Female Uniform w/Vest"] = {
      [3] = {44,0},
      [4] = {34,0},
      [6] = {24,0},
      [8] = {35,0},
      [9] = {13,1},
      [11] = {48,0},
      ["p2"] = {0,0}
    },
    ["Female Police Model"] = {
      modelhash = 's_f_y_cop_01'
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
  },
  ["surgery"] = {
    _config = { not_uniform = true },
    ["Male"] = surgery_male,
    ["Female"] = surgery_female
  }
}

cfg.cloakrooms = {
  {"police", 454.324096679688,-991.499938964844,30.6895771026611}, -- Mission Row
  --{"emergency", -499.814208984375,-343.751922607422,34.5018157958984}, -- Rockford hills
  --{"emergency", 1154.5456542969,-1544.2042236328,34.843669891357}, -- El Burrought Heights
  {"emergency", 292.74142456054,-1444.982055664,29.966623306274}, -- Central
  {"police",1848.84899902344,3689.41845703125,34.2670860290527}, -- Sandy Shores
  {"emergency",1689.78698730469,3590.32543945313,35.620964050293}, -- Sandy Shores
  {"police",-1126.89367675781,-834.825378417969,13.4480028152466} -- Vespucci
}

return cfg
