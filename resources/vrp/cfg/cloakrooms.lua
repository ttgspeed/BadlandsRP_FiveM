
-- this file configure the cloakrooms on the map

local cfg = {}

-- cloakroom types (_config, map of name => customization)
cfg.cloakroom_types = {
  ["police"] = {
    _config = { permission = "police.cloakroom" },
    ["Uniform"] = {
      [3] = {30,0},
      [4] = {25,2},
      [6] = {24,0},
      [8] = {58,0},
      [11] = {55,0},
      ["p2"] = {2,0}
    },
    ["Uniform + Vest"] = {
      [3] = {30,0},
      [4] = {25,2},
      [6] = {24,0},
      [8] = {58,0},
      [9] = {4,1},
      [11] = {55,0},
      ["p2"] = {2,0}
    }
  },
  ["emergency"] = {
    _config = { permission = "emergency.cloakroom" },
    ["Uniform"] = {
      [3] = {92,0},
      [4] = {9,3},
      [6] = {25,0},
      [8] = {15,0},
      [11] = {13,3}
    }
  }
}

cfg.cloakrooms = {
  {"police", 454.324096679688,-991.499938964844,30.6895771026611},
  {"emergency", -499.814208984375,-343.751922607422,34.5018157958984}
}

return cfg
