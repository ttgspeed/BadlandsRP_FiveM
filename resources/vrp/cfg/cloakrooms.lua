
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
    _config = { permissions = {"police.cloakroom"} },
    ["Male uniform"] = {
      [3] = {30,0},
      [4] = {25,2},
      [6] = {24,0},
      [8] = {58,0},
      [11] = {55,0},
      ["p2"] = {2,0}
    },
    ["Female uniform"] = {
      [3] = {35,0},
      [4] = {30,0},
      [6] = {24,0},
      [8] = {6,0},
      [11] = {48,0},
      ["p2"] = {2,0}
    }
  },
  ["surgery"] = {
    _config = { not_uniform = true },
    ["Male"] = surgery_male,
    ["Female"] = surgery_female
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
