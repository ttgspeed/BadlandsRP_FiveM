
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
    ["Male Police Model"] = {
      modelhash = 's_m_y_cop_01'
    },
    ["Female Police Model"] = {
      modelhash = 's_f_y_cop_01'
    },

    ["Male LSPD Class A"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {200,0},
      [3] = {4,0},
      [10] = {0,0},
      [8] = {56,0},
      [4] = {35,0},
      [6] = {51,0},
      [7] = {8,0},
      [9] = {0,0},
      [5] = {52,0},
    },

    ["Male LSPD Class B"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {193,0},
      [3] = {4,0},
      [10] = {0,0},
      [8] = {56,0},
      [4] = {35,0},
      [6] = {51,0},
      [7] = {8,0},
      [9] = {13,0},
      [5] = {52,0},
    },

    ["Male LSPD Class C"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {3,0},
      [1] = {0,0},
      [11] = {190,0},
      [3] = {0,0},
      [10] = {0,0},
      [8] = {56,0},
      [4] = {35,0},
      [6] = {51,0},
      [7] = {8,0},
      [9] = {13,0},
      [5] = {52,0},
    },

    ["Female LSPD Class A"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {202,0},
      [3] = {3,0},
      [10] = {0,0},
      [8] = {33,0},
      [4] = {34,0},
      [6] = {52,0},
      [7] = {8,0},
      [9] = {0,0},
      [5] = {52,0},
    },

    ["Female LSPD Class B"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {195,0},
      [3] = {3,0},
      [10] = {0,0},
      [8] = {33,0},
      [4] = {34,0},
      [6] = {52,0},
      [7] = {8,0},
      [9] = {0,0},
      [5] = {52,0},
    },

    ["Female LSPD Class C"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {192,0},
      [3] = {14,0},
      [10] = {0,0},
      [8] = {33,0},
      [4] = {34,0},
      [6] = {52,0},
      [7] = {8,0},
      [9] = {0,0},
      [5] = {52,0},
    },

    ["Male LSPD Jacket"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {39,0},
      [3] = {4,0},
      [10] = {0,0},
      [8] = {66,0},
      [4] = {35,0},
      [6] = {51,0},
      [7] = {8,0},
      [9] = {2,0},
      [5] = {48,0},
    },

    ["Female LSPD Jacket"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {172,0},
      [3] = {14,0},
      [10] = {0,0},
      [8] = {46,0},
      [4] = {34,0},
      [6] = {52,0},
      [7] = {8,0},
      [9] = {2,0},
      [5] = {48,0},
    },

    ["Male LSPD Winter Uniform"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {154,0},
      [3] = {38,0},
      [10] = {0,0},
      [8] = {56,0},
      [4] = {35,0},
      [6] = {51,0},
      [7] = {8,0},
      [9] = {28,0},
      [5] = {0,0},
    },

    ["Female LSPD Winter Uniform"] = {
      ["p0"] = {45,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {151,0},
      [3] = {36,0},
      [10] = {0,0},
      [8] = {33,0},
      [4] = {34,0},
      [6] = {52,0},
      [7] = {8,0},
      [9] = {30,0},
      [5] = {48,0},
    },

    ["Male LSPD Raincoat"] = {
      ["p0"] = {10,6},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {189,6},
      [3] = {4,0},
      [10] = {0,0},
      [8] = {65,0},
      [4] = {35,0},
      [6] = {51,0},
      [7] = {0,0},
      [9] = {31,0},
      [5] = {52,0},
    },

    ["Female LSPD Raincoat"] = {
      ["p0"] = {10,2},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {191,6},
      [3] = {3,0},
      [10] = {0,0},
      [8] = {45,0},
      [4] = {34,0},
      [6] = {52,0},
      [7] = {0,0},
      [9] = {35,0},
      [5] = {0,0},
    },

    ["Male LSPD Motor Unit Class A"] = {
      ["p0"] = {17,1},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {200,1},
      [3] = {20,0},
      [10] = {0,0},
      [8] = {56,0},
      [4] = {32,1},
      [6] = {13,0},
      [7] = {8,0},
      [9] = {0,0},
      [5] = {52,0},
    },

    ["Male LSPD Motor Unit Class B"] = {
      ["p0"] = {17,1},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {193,1},
      [3] = {20,0},
      [10] = {0,0},
      [8] = {56,0},
      [4] = {32,1},
      [6] = {13,0},
      [7] = {8,0},
      [9] = {0,0},
      [5] = {52,0},
    },

    ["Male LSPD Motor Unit Class C"] = {
      ["p0"] = {17,1},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {190,1},
      [3] = {21,0},
      [10] = {0,0},
      [8] = {56,0},
      [4] = {32,1},
      [6] = {13,0},
      [7] = {8,0},
      [9] = {0,0},
      [5] = {52,0},
    },

    ["Female LSPD Motor Unit Class A"] = {
      ["p0"] = {17,1},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {202,1},
      [3] = {23,0},
      [10] = {0,0},
      [8] = {33,0},
      [4] = {31,1},
      [6] = {9,0},
      [7] = {8,0},
      [9] = {0,0},
      [5] = {52,0},
    },

    ["Female LSPD Motor Unit Class B"] = {
      ["p0"] = {17,1},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {195,1},
      [3] = {23,0},
      [10] = {0,0},
      [8] = {33,0},
      [4] = {31,1},
      [6] = {9,0},
      [7] = {8,0},
      [9] = {0,0},
      [5] = {52,0},
    },

    ["Female LSPD Motor Unit Class C"] = {
      ["p0"] = {17,1},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {192,1},
      [3] = {31,0},
      [10] = {0,0},
      [8] = {33,0},
      [4] = {31,1},
      [6] = {9,0},
      [7] = {8,0},
      [9] = {0,0},
      [5] = {52,0},
    },

    ["Male LSPD Bicycle Uniform"] = {
      ["p0"] = {49,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {93,2},
      [3] = {19,0},
      [10] = {0,0},
      [8] = {37,0},
      [4] = {12,2},
      [6] = {2,0},
      [7] = {8,0},
      [9] = {14,0},
      [5] = {48,0},
    },

    ["Female LSPD Bicycle Uniform"] = {
      ["p0"] = {47,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {84,2},
      [3] = {31,0},
      [10] = {0,0},
      [8] = {2,0},
      [4] = {14,2},
      [6] = {10,0},
      [7] = {8,0},
      [9] = {1,0},
      [5] = {48,0},
    },

    ["Male LSPD Suit"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {4,4},
      [3] = {4,0},
      [10] = {0,0},
      [8] = {10,0},
      [4] = {10,4},
      [6] = {10,0},
      [7] = {38,5},
      [9] = {24,0},
      [5] = {66,0},
    },

    ["Female LSPD Suit"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {24,1},
      [3] = {7,0},
      [10] = {0,0},
      [8] = {64,1},
      [4] = {3,3},
      [6] = {29,0},
      [7] = {0,0},
      [9] = {26,0},
      [5] = {66,0},
    },

    ["Male LSPD Detective"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {12,0},
      [3] = {12,0},
      [10] = {0,0},
      [8] = {12,5},
      [4] = {10,4},
      [6] = {10,0},
      [7] = {6,0},
      [9] = {24,0},
      [5] = {0,0},
    },

    ["Female LSPD Detective"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {28,1},
      [3] = {0,0},
      [10] = {0,0},
      [8] = {24,5},
      [4] = {3,3},
      [6] = {29,0},
      [7] = {6,0},
      [9] = {26,0},
      [5] = {0,0},
    },

    ["Male LSPD Detective (Vest)"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {3,0},
      [3] = {12,0},
      [10] = {0,0},
      [8] = {131,0},
      [4] = {10,4},
      [6] = {10,0},
      [7] = {6,0},
      [9] = {24,0},
      [5] = {0,0},
    },

    ["Female LSPD Detective (Vest)"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {27,5},
      [3] = {0,0},
      [10] = {0,0},
      [8] = {161,0},
      [4] = {3,3},
      [6] = {29,0},
      [7] = {6,0},
      [9] = {26,0},
      [5] = {0,0},
    },

    ["Male LSPD Detective Winter"] = {
      ["p0"] = {2,1},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {38,0},
      [3] = {33,0},
      [10] = {0,0},
      [8] = {10,0},
      [4] = {10,4},
      [6] = {25,0},
      [7] = {38,5},
      [9] = {24,0},
      [5] = {66,0},
    },

    ["Female LSPD Detective Winter"] = {
      ["p0"] = {5,1},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {240,1},
      [3] = {44,0},
      [10] = {0,0},
      [8] = {77,5},
      [4] = {3,3},
      [6] = {25,0},
      [7] = {0,0},
      [9] = {26,0},
      [5] = {66,0},
    },

  },
  ["emergency"] = {
    _config = { permission = "emergency.cloakroom" },

    ["Male LSFD Bunker Pants"] = {
      ["p0"] = {-1,0},
      ["p1"] = {0,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {73,14},
      [3] = {0,0},
      [10] = {0,0},
      [8] = {15,0},
      [4] = {19,1},
      [6] = {51,0},
      [7] = {18,0},
      [9] = {0,0},
      [5] = {0,0},
    },

    ["Male LSFD Turnouts"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {80,0},
      [3] = {96,0},
      [10] = {16,0},
      [8] = {15,0},
      [4] = {43,0},
      [6] = {13,0},
      [7] = {0,0},
      [9] = {0,0},
      [5] = {48,0},
    },

    ["Male LSFD PPE Gear"] = {
      ["p0"] = {45,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {77,0},
      [3] = {96,0},
      [10] = {16,0},
      [8] = {68,0},
      [4] = {43,0},
      [6] = {13,0},
      [7] = {45,0},
      [9] = {0,0},
      [5] = {48,0},
    },

    ["Female LSFD Bunker Pants"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {224,21},
      [3] = {14,0},
      [10] = {0,0},
      [8] = {14,0},
      [4] = {48,1},
      [6] = {52,0},
      [7] = {12,0},
      [9] = {0,0},
      [5] = {48,0},
    },

    ["Female LSFD Turnouts"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {73,0},
      [3] = {111,0},
      [10] = {15,0},
      [8] = {14,0},
      [4] = {18,0},
      [6] = {28,0},
      [7] = {0,0},
      [9] = {0,0},
      [5] = {48,0},
    },

    ["Female LSFD PPE Gear"] = {
      ["p0"] = {44,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {64,0},
      [3] = {111,0},
      [10] = {15,0},
      [8] = {48,0},
      [4] = {18,0},
      [6] = {28,0},
      [7] = {32,0},
      [9] = {0,0},
      [5] = {48,0},
    },

    ["Male LSFD Fireman Class A"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {118,0},
      [3] = {4,0},
      [10] = {0,0},
      [8] = {88,0},
      [4] = {25,3},
      [6] = {51,0},
      [7] = {0,0},
      [9] = {0,0},
      [5] = {37,4},
    },

    ["Male LSFD Fireman Class B"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {75,1},
      [3] = {4,0},
      [10] = {0,0},
      [8] = {88,0},
      [4] = {25,3},
      [6] = {51,0},
      [7] = {0,0},
      [9] = {0,0},
      [5] = {70,1},
    },

    ["Male LSFD Fireman Class C"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {74,1},
      [3] = {0,0},
      [10] = {0,0},
      [8] = {88,0},
      [4] = {25,3},
      [6] = {51,0},
      [7] = {0,0},
      [9] = {0,0},
      [5] = {70,1},
    },

    ["Female LSFD Fireman Class A"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {18,0},
      [3] = {3,0},
      [10] = {0,0},
      [8] = {7,0},
      [4] = {41,3},
      [6] = {52,0},
      [7] = {0,0},
      [9] = {0,0},
      [5] = {37,4},
    },

    ["Female LSFD Fireman Class B"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {26,1},
      [3] = {3,0},
      [10] = {0,0},
      [8] = {7,0},
      [4] = {41,3},
      [6] = {52,0},
      [7] = {0,0},
      [9] = {0,0},
      [5] = {70,1},
    },

    ["Female LSFD Fireman Class C"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {25,1},
      [3] = {14,0},
      [10] = {0,0},
      [8] = {7,0},
      [4] = {41,3},
      [6] = {52,0},
      [7] = {0,0},
      [9] = {0,0},
      [5] = {70,1},
    },

    ["Male LSFD EMT Class A"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {75,6},
      [3] = {86,0},
      [10] = {0,0},
      [8] = {54,0},
      [4] = {86,12},
      [6] = {51,0},
      [7] = {30,3},
      [9] = {29,0},
      [5] = {70,0},
    },
    ["Male LSFD EMT Class B"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {74,6},
      [3] = {85,0},
      [10] = {0,0},
      [8] = {54,0},
      [4] = {86,12},
      [6] = {51,0},
      [7] = {30,3},
      [9] = {29,0},
      [5] = {70,0},
    },

    ["Male LSFD EMT Class C"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {75,0},
      [3] = {86,0},
      [10] = {0,0},
      [8] = {54,0},
      [4] = {86,12},
      [6] = {51,0},
      [7] = {30,3},
      [9] = {29,0},
      [5] = {70,0},
    },

    ["Male LSFD EMT Class D"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {74,0},
      [3] = {85,0},
      [10] = {0,0},
      [8] = {54,0},
      [4] = {86,12},
      [6] = {51,0},
      [7] = {30,3},
      [9] = {29,0},
      [5] = {70,0},
    },

    ["Male LSFD T-Shirt"] = {
      ["p0"] = {-1,0},
      ["p1"] = {23,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {73,14},
      [3] = {85,0},
      [10] = {0,0},
      [8] = {54,0},
      [4] = {86,12},
      [6] = {51,0},
      [7] = {0,0},
      [9] = {29,0},
      [5] = {0,0},
    },

    ["Female LSFD EMT Class A"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {26,6},
      [3] = {101,0},
      [10] = {0,0},
      [8] = {6,0},
      [4] = {89,12},
      [6] = {52,0},
      [7] = {14,3},
      [9] = {33,0},
      [5] = {70,0},
    },

    ["Female LSFD EMT Class B"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {25,6},
      [3] = {109,0},
      [10] = {0,0},
      [8] = {6,0},
      [4] = {89,12},
      [6] = {52,0},
      [7] = {14,3},
      [9] = {33,0},
      [5] = {70,0},
    },

    ["Female LSFD EMT Class C"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {26,0},
      [3] = {101,0},
      [10] = {0,0},
      [8] = {6,0},
      [4] = {89,12},
      [6] = {52,0},
      [7] = {14,3},
      [9] = {33,0},
      [5] = {70,0},
    },

    ["Female LSFD EMT Class D"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {25,0},
      [3] = {109,0},
      [10] = {0,0},
      [8] = {6,0},
      [4] = {89,12},
      [6] = {52,0},
      [7] = {14,3},
      [9] = {33,0},
      [5] = {70,0},
    },

    ["Female LSFD T-Shirt"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {224,21},
      [3] = {109,0},
      [10] = {0,0},
      [8] = {6,0},
      [4] = {89,12},
      [6] = {52,0},
      [7] = {0,0},
      [9] = {33,0},
      [5] = {48,0},
    },

    ["Male LSFD Jacket"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {151,2},
      [3] = {4,0},
      [10] = {0,0},
      [8] = {65,6},
      [4] = {25,3},
      [6] = {51,0},
      [7] = {0,0},
      [9] = {1,0},
      [5] = {48,0},
    },

    ["Female LSFD Jacket"] = {
      ["p0"] = {-1,0},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {148,2},
      [3] = {3,0},
      [10] = {0,0},
      [8] = {45,6},
      [4] = {41,3},
      [6] = {52,0},
      [7] = {0,0},
      [9] = {1,0},
      [5] = {48,0},
    },

    ["Male LSFD Winter Jacket"] = {
      ["p0"] = {2,1},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {249,1},
      [3] = {31,0},
      [10] = {57,0},
      [8] = {15,0},
      [4] = {86,12},
      [6] = {51,0},
      [7] = {126,0},
      [9] = {0,0},
      [5] = {48,0},
    },

    ["Female LSFD Winter Jacket"] = {
      ["p0"] = {5,1},
      ["p1"] = {-1,0},
      ["p2"] = {-1,0},
      ["p6"] = {-1,0},
      [1] = {0,0},
      [11] = {257,1},
      [3] = {36,0},
      [10] = {65,0},
      [8] = {14,0},
      [4] = {41,3},
      [6] = {52,0},
      [7] = {96,0},
      [9] = {0,0},
      [5] = {0,0},
    },

    ["EMS Female Model"] = {
      modelhash = 's_f_y_scrubs_01'
    },
    ["EMS Male Model"] = {
      modelhash = 's_m_m_paramedic_01'
    },
    ["Fireman Model"] = {
      modelhash = 's_m_y_fireman_01',
      [3] = {0,1,0},
      [4] = {0,1,0},
      [14] = {0,0,255},
      [15] = {0,0,118},
      [19] = {0,0,63},
      ["p0"] = {0,1}
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
  {"emergency", -473.88092041016,-339.03283691406,-186.4801940918}, -- Rockford hills
  --{"emergency", 1154.5456542969,-1544.2042236328,34.843669891357}, -- El Burrought Heights
  --{"emergency", 308.99197387695,-1435.7248535156,29.86044883728}, -- Central
  {"emergency",309.57379150391,-602.57849121094,43.291843414307}, -- pillboox
  {"police",1848.84899902344,3689.41845703125,34.2670860290527}, -- Sandy Shores
  {"emergency",1689.78698730469,3590.32543945313,35.620964050293}, -- Sandy Shores
  {"police",-1126.89367675781,-834.825378417969,13.4480028152466}, -- Vespucci
  {"police",-447.69735717773,6008.19921875,31.716371536255}, -- Paleto Bay
  {"emergency",-366.33590698242,6125.568359375,31.440427780151}, -- Paleto Bay
}

return cfg
