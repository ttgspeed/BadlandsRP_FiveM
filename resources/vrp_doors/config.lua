local cfg = {}

cfg.list = {
  -- Mission Row To locker room & roof
  --[1] = { ["objName"] = "v_ilev_ph_gendoor004", ["x"]= 449.69815063477, ["y"]= -986.46911621094,["z"]= 30.689594268799,["locked"]= true,["txtX"]=450.104,["txtY"]=-986.388,["txtZ"]=31.739},
  -- Mission Row Armory out
  [1] = { offset = -1.2, mystatus = false, hash = 749848321, x = 452.61877441406, y = -982.7021484375, z = 30.689598083496, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  -- Mission Row Armory in
  --[6] = { offset = -1.2, mystatus = false, hash = 749848321, x = 453.57894897461, y = -982.49829101563, z = 30.689605712891, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  -- Mission Row Main cells
  [2] = { offset = -1.2, mystatus = false, hash = 631614199, x = 463.95562744141, y = -992.5693359375, z = 24.91487121582, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  -- Mission Row Cell 1
  [3] = { offset = -1.2, mystatus = false, hash = 631614199, x = 462.381, y = -993.651, z = 24.9149, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  -- Mission Row Cell 2
  [4] = { offset = -1.2, mystatus = false, hash = 631614199, x = 462.331, y = -998.152, z = 24.9149, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  -- Mission Row Cell 3
  [5] = { offset = -1.2, mystatus = false, hash = 631614199, x = 462.704, y = -1001.92, z = 24.9149, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  -- Mission Row Backdoor in
  [6] = { offset = -1.2, mystatus = false, hash = -1033001619, x = 464.126, y = -1002.78, z = 24.9149, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  -- Mission Row Backdoor out
  --[6] = { offset = -1.2, mystatus = false, hash = -1033001619, x = 464.18, y = -1004.31, z = 24.9152, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  -- Mission Row Captain Office
  [7] = { offset = -1.2, mystatus = false, hash = -1320876379, x = 447.29971313477, y = -980.03033447266, z = 30.689582824707, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  -- Mission Row To downstairs right
  [8] = { offset = -1.2, mystatus = false, hash = 185711165, x = 444.19161987305, y = -989.48022460938, z = 30.689605712891, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD", pair = 9},
  -- Mission Row To downstairs left
  [9] = { offset = -1.2, mystatus = false, hash = 185711165, x = 445.30233764648, y = -989.42022705078, z = 30.689582824707, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD", pair = 8},

  -- Sandy Cells
  [10] = { offset = -1.2, mystatus = false, hash = -519068795, x = 1847.5565185547, y = 3681.6572265625, z = -118.76152801514, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  [11] = { offset = -1.2, mystatus = false, hash = -642608865, x = 1844.2766113281, y = 3682.0493164063, z = -118.76152801514, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  [12] = { offset = -1.2, mystatus = false, hash = -642608865, x = 1839.7230224609, y = 3679.7424316406, z = -118.76152801514, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  [13] = { offset = -1.2, mystatus = false, hash = -642608865, x = 1835.3383789063, y = 3677.1328125, z = -118.76151275635, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},

  --Paleto Cells
  [14] = { offset = -1.2, mystatus = false, hash = -519068795, x = -440.25454711914, y = 6008.982421875, z = -118.76160430908, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  [15] = { offset = -1.2, mystatus = false, hash = -642608865, x = -439.86236572266, y = 6005.6767578125, z = -118.76160430908, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  [16] = { offset = -1.2, mystatus = false, hash = -642608865, x = -436.20074462891, y = 6002.1166992188, z = -118.76160430908, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  [17] = { offset = -1.2, mystatus = false, hash = -642608865, x = -432.84405517578, y = 5998.5522460938, z = -118.76155853271, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
}
--[[
cfg.list = {
  [1] = { offset = -1.2, mystatus = false, hash = 1557126584, x = 449.69815063477, y = -986.46911621094, z = 30.689594268799, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  [2] = { offset = -1.2, mystatus = false, hash = 749848321, x = 452.61877441406, y = -982.7021484375, z = 30.689598083496, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  [3] = { offset = -1.2, mystatus = false, hash = -1320876379, x = 447.23818969727, y = -980.63006591797, z = 30.689598083496, locked = true, key = "key_lspd", permission="police.pc", name = "Captain's Office LSPD"},
  [4] = { offset = -1.2, mystatus = false, hash = 185711165, x = 443.97, y = -989.033, z = 30.6896, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD", pair = 5},
  [5] = { offset = -1.2, mystatus = false, hash = 185711165, x = 445.37, y = -989.705, z = 30.6896, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD", pair = 4},
  [6] = { offset = -1.2, mystatus = false, hash = 631614199, x = 464.4, y = -992.265, z = 24.9149, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  [7] = { offset = -1.2, mystatus = false, hash = 631614199, x = 462.381, y = -993.651, z = 24.9149, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  [8] = { offset = -1.2, mystatus = false, hash = 631614199, x = 462.331, y = -998.152, z = 24.9149, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  [9] = { offset = -1.2, mystatus = false, hash = 631614199, x = 462.704, y = -1001.92, z = 24.9149, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD", pair = 21},
  --[10] = { offset = 1.2, mystatus = false, hash = -1033001619, x = 464.126, y = -1002.78, z = 24.9149, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD", pair = 11},
  --[11] = { offset = 1.2, mystatus = false, hash = -1033001619, x = 464.18, y = -1004.31, z = 24.9152, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD", pair = 10},
  --[12] = { offset = -1.2, mystatus = false, hash = -340230128, x = 465.467, y = -983.446, z = 43.6918, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD", pair = 13},
  --[13] = { offset = -1.2, mystatus = false, hash = -340230128, x = 462.979, y = -984.163, z = 43.6919, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD", pair = 12},
  [14] = { offset = -1.2, mystatus = false, hash = 320433149, x = 434.7479, y = -982.2151, z = 30.83926, locked = false, key = "key_lspd", permission="police.pc", name = "LSPD", pair = 15},
  [15] = { offset = 1.2, mystatus = false, hash = -1215222675, x = 434.7479, y = -981.6184, z = 30.83926, locked = false, key = "key_lspd", permission="police.pc", name = "LSPD", pair = 14},
  [17] = { offset = -1.2, mystatus = false, hash = -131296141, x = 443.0298, y = -992.941, z = 30.8393, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD", pair = 16},
  [16] = { offset = -1.2, mystatus = false, hash = -131296141, x = 443.0298, y = -993.5412, z = 30.8393, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD", pair = 17},
  [19] = { offset = 1.2, mystatus = false, hash = -2023754432, x = 468.9679, y = -1014.452, z = 26.53623, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  [18] = { offset = 1.2, mystatus = false, hash = -2023754432, x = 468.3716, y = -1014.452, z = 26.53623, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  [21] = { offset = -1.2, mystatus = false, hash = 749848321, x = 461.2865, y = -985.3206, z = 30.83926, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD", pair = 9},
  [20] = { offset = 1.2, mystatus = false, hash = -2023754432, x = 452.6248, y = -987.3626, z = 30.83926, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  [22] = { offset = -1.2, mystatus = false, hash = 631614199, x = 462.504, y = -1001.92, z = 24.9149, locked = true, key = "key_lspd", permission="police.pc", name = "LSPD"},
  -- Grove Street
  [23] = { offset = -1.2, mystatus = false, hash = 520341586, x = -14.86892, y = -1441.182, z = 31.19323, locked = true, key = "key_grove_house", permission="grove.doors", name = "Grove Street House"},
  --- Hospital
  [24] = { offset = -1.2, mystatus = false, hash = 1653893025, x = 271.666, y = -1360.943, z = 24.19323, locked = true, key = "key_medic", permission="emergency.service", name = "Dressing rooms for LSFD"},
  [25] = { offset = -1.2, mystatus = false, hash = 580361003, x = 265.77, y = -1346.0, z = 24.19323, locked = true, key = "key_medic", permission="emergency.service", name = "Operating Room"},
  [26] = { offset = 1.2, mystatus = false, hash = 1415151278, x = 267.47, y = -1344.447, z = 24.19323, locked = true, key = "key_medic", permission="emergency.service", name = "Operating Room"},
  [27] = { offset = -1.2, mystatus = false, hash = 580361003, x = 253.011, y = -1360.902, z = 24.19323, locked = true, key = "key_medic", permission="emergency.service", name = "Operating Room"},
  [28] = { offset = 1.2, mystatus = false, hash = 1415151278, x = 253.955, y = -1359.8079, z = 24.19323, locked = true, key = "key_medic", permission="emergency.service", name = "Operating Room"},
  [29] = { offset = -1.2, mystatus = false, hash = 1859711902, x = 236.8063, y = -1368.1375, z = 39.5434, locked = true, key = "key_medic_boss", permission="zavbol_site.paycheck", name = "Chief Office Chief"},
  -- Bank
  [30] = { offset = -1.2, mystatus = false, hash = -222270721, x = 256.711, y = 220.4395, z = 106.2853, locked = true, key = "key_medic_boss123", permission="bank.key", name = "Bank", pair = 31},
  [31] = { offset = -1.2, mystatus = false, hash = 746855201, x = 261.95, y = 221.916, z = 106.2853, locked = true, key = "key_medic_boss123", permission="bank.key", name = "Bank", pair = 30},
  [32] = { offset = -1.2, mystatus = false, hash = 1956494919, x = 237.95, y = 227.916, z = 106.2853, locked = true, key = "key_medic_boss123", permission="bank.key", name = "Bank"},
  [33] = { offset = -1.2, mystatus = false, hash = 1956494919, x = 237.95, y = 227.916, z = 110.2853, locked = true, key = "key_medic_boss123", permission="bank.key", name = "Bank"},
  [34] = { offset = -1.2, mystatus = false, hash = 1956494919, x = 256.95, y = 206.916, z = 110.2853, locked = true, key = "key_medic_boss123", permission="bank.key", name = "Bank"},
  [35] = { offset = -1.2, mystatus = false, hash = 964838196, x = 260.45, y = 209.916, z = 110.2853, locked = true, key = "key_medic_boss123", permission="bank.key", name = "Bank"},
  [36] = { offset = -1.2, mystatus = false, hash = 964838196, x = 262.45, y = 214.916, z = 110.2853, locked = true, key = "key_medic_boss123", permission="bank.key", name = "Bank"},
  [37] = { offset = -1.2, mystatus = false, hash = 1956494919, x = 265.45, y = 217.516, z = 110.2853, locked = true, key = "key_medic_boss123", permission="bank.key", name = "Bank"},
}
]]--
return cfg
