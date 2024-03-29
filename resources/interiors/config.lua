INTERIORS = {
  -- HOPITAL
  [1] = {id = 1, x = 231.55276489258, y = -1360.1064453125, z = 28.65180015564, h = 50.37, name = "Exit Hospital", destination = {2}},
  [2] = {id = 2, x = 275.33160400391, y = -1360.9852294922, z = 24.537803649902, h = 49.13, name = "Enter Hospital", destination = {1}},

  -- FIB
  [4] = {id = 4, x = 138.18788146973, y = -764.86633300781, z = 45.77199508667,  name = "FIB Lobby", destination = {5}},
  [5] = {id = 5, x = 136.24076843262, y = -761.77978515625, z = 242.15208435058,  name = "FIB Office", destination = {4}},

  --La Fuente Blanca
  [6] = {id = 6, x = 1394.3980712891, y = 1141.6976318359, z = 114.62711669922,  name = "Exit House", destination = {7}},
  [7] = {id = 7, x = 1396.7640380859, y = 1141.7806396484, z = 114.33378601074,  name = "Enter House", destination = {6}},

  -- BAHMAS MAMAS -430.142, 261.665, 83.005
  [8] = {id = 8, x = -458.790, y = 284.750, z = 78.621, h = 35.407787322998, name = "Enter Split Sides", destination = {9}},
  [9] = {id = 9, x = -430.142, y = 261.665, z = 83.105 , h = 205.4248046875, name = "Exit Split Sides", destination = {8}},

  --Sandy shore cells
  [10] = {id = 10, x = 1849.8493652344, y = 3683.3837890625, z = -118.76152038574, h = 35.407787322998, name = "Enter Cells", destination = {11}},
  [11] = {id = 11, x = 1856.9282226563, y = 3689.2209472656, z = 34.277040252686, h = 205.4248046875, name = "Exit Cells", destination = {10}},
  -- Paleto bay cells
  [12] = {id = 12, x = -442.02584838867, y = 6010.388671875, z = -118.76153564453, h = 35.407787322998, name = "Enter Cells", destination = {13}},
  [13] = {id = 13, x = -449.59896850586, y = 6016.2880859375, z = 31.71639251709, h = 205.4248046875, name = "Exit Cells", destination = {12}},

  -- Morgue
  --[12] = {id = 12, x = 240.50773620605, y = -1379.4248046875, z = 33.741641998291,  name = "Exit Morgue", destination = {13}},
  --[13] = {id = 13,x = 285.69213867188, y = -1351.2567138672, z = 24.534639358521,  name = "Enter Morgue", destination = {12}},

  -- Humane labs
  [18] = {id = 18, x =  3562.8259277344, y = 3690.3332519531, z = 28.121658325195,  name = "Enter Lab", destination = {19}},
  [19] = {id = 19,x = 3526.3579101563, y = 3673.7409667969, z = 28.131139526367,  name = "Exit Lab", destination = {18}},

  --bunker -453.5365600586,-1735.9526367188,16.763278961182 // -391.1396484375,4354.8344726562,57.672813415528 // -472.49298095704,2089.0400390625,120.09169006348
  -- -143.52745056152,-575.35363769532,32.424533843994
	--1572.06640625,2242.4387207032,79.066352844238
  [20] = {id = 20, x =  894.20825195312, y = -3245.8674316406, z = -98.249925842286,  name = "Enter Bunker", destination = {21}},
  [21] = {id = 21,x = 1572.06640625, y = 2242.4387207032, z = 79.096352844238,  name = "Exit Bunker", destination = {20}},
  -- Courthouse 233.27409362793,-410.31677246094,48.111946105957
  [22] = {id = 22, x = 238.78730773926, y = -334.09741210938, z = -118.67347564697,  name = "Enter Courtroom", destination = {23}},
  [23] = {id = 23,x = 224.94427490234, y = -419.59375, z = -118.19956970215,  name = "Exit Courtroom", destination = {22}},
  -- Courtroom judge area 240.8327331543,-306.27542114258,-118.80004882813
  [24] = {id = 24, x = 240.8327331543, y = -306.27542114258, z = -118.70004882813,  name = "Enter Judge Area", destination = {25}},
  [25] = {id = 25,x = 253.80030822754, y = -314.08728027344, z = -118.699949646,  name = "Exit Judge Area", destination = {24}},

  --[26] = {id = 26, x = -1910.7185058594, y = -574.93115234375, z = 19.146911837769,  name = "Enter Psychiatrist Office", destination = {27}},
  --[27] = {id = 27,x = -1911.6326904297, y = -576.21142578125, z = 19.146910476685,  name = "Exit Psychiatrist Office", destination = {26}},

	-- [28] = {id = 28, x = 1088.8044433594, y = -3188.5224609375, z = -38.993465423584,  name = "Cocaine Packaging", destination = {29}},
  -- [29] = {id = 29,x = -1911.6326904297, y = -576.21142578125, z = 19.146910476685,  name = "Exit Cocaine Packaging", destination = {28}},

	[30] = {id = 30, x = 997.76062011718, y = -3200.7687988282, z = -36.383684387208,  name = "Cocaine Processing Lab", destination = {31}},
  [31] = {id = 31,x = -1146.730102539, y = 4940.5698242188, z = 222.28876831054,  name = "Exit Lab", destination = {30}},

	[32] = {id = 32, x = 1012.7654418946, y = -3202.4013671875, z = -38.79312210083,  name = "Cocaine Processing Lab", destination = {33}},
	[33] = {id = 33,x = -1139.3309326172, y = 4964.8662109375, z = 222.26356079102,  name = "Exit Lab", destination = {32}},

  [34] = {id = 34, x = -498.08114624023, y = -335.80911254883, z = 34.531735687256,  name = "Exit Hospital", destination = {35}},
	[35] = {id = 35,x = -458.35165405273, y = -367.51760864258, z = -186.46078491211,  name = "Enter Hospital", destination = {34}},

  -- Yankton 3557.2287597656,-4683.7763671875,114.5895767212 // -1021.4697265625,-2759.3962402344,0.80036199092864
  --[36] = {id = 36, x =  3557.2287597656, y = -4683.7763671875, z = 114.5895767212,  name = "Travel to Ludendorff", destination = {37}},
  --[37] = {id = 37,x = -1021.4697265625, y = -2759.3962402344, z = 0.80036199092864,  name = "Travel to Los Santos", destination = {36}},
  -- Prison visitor - visit section
  [38] = {id = 38, x =  1706.4376220703, y = 2581.1198730469, z = -69.411514282227,  name = "Enter Visitor's Area", destination = {39}},
  [39] = {id = 39,x = 1846.1342773438, y = 2585.7614746094, z = 45.672012329102,  name = "Exit Visitor's Area", destination = {38}},
  -- Prison inmate - visit section
  [40] = {id = 40, x =  1699.8532714844, y = 2574.5686035156, z = -69.40306854248,  name = "Enter Visitor's Area", destination = {41}},
  [41] = {id = 41,x = 1775.6333007813, y = 2552.1547851563, z = 45.564975738525,  name = "Exit Visitor's Area", destination = {40}},
  -- Prison inmate - cells section
  [42] = {id = 42, x =  1800.6802978516, y = 2483.138671875, z = -122.69062805176,  name = "Enter Prison Cells", destination = {43}},
  [43] = {id = 43,x = 1765.5489501953, y = 2565.7827148438, z = 45.565021514893,  name = "Exit Prison Cells", destination = {42}},

	--Galaxy Club
	[44] = {id = 44, x = -1286.0334472656, y = -651.07708740234, z = 26.583448410034,  name = "Exit Club Galaxy", destination = {45}},
	[45] = {id = 45,x = -1569.5811767578, y = -3016.9172363282, z = -74.406188964844,  name = "Enter Club Galaxy", destination = {44}},

  --[46] = {id = 46, x = -281.63204956055, y = -2031.1636962891, z = 30.145782470703,  name = "Exit Arena", destination = {47}},
	--[47] = {id = 47, x = 2845.0249023438, y = -3912.5244140625, z = 140.00094604492,  name = "Enter Arena", destination = {46}},

  [48] = {id = 48, x = 338.990234375, y = -584.16973876953, z = 74.165664672852,  name = "Go to helipad", destination = {49}},
	[49] = {id = 49, x = 325.23513793945, y = -598.63110351563, z = 43.291835784912,  name = "Go to lobby", destination = {48}},

  [50] = {id = 50, x = 319.4739074707, y = -559.57989501953, z = 28.743776321411,  name = "Go to parking", destination = {51}},
	[51] = {id = 51, x = 334.17172241211, y = -570.01733398438, z = 43.317386627197,  name = "Go to lobby", destination = {50}},

	[52] = {id = 52, x = 136.17930603028, y = -761.70587158204, z = 234.25194702148,  name = "", destination = {53,57,4}},
	[53] = {id = 53, x = 2625.7709960938, y = -3884.2097167968, z = 141.09983215332,  name = "Arena", destination = {}},

  [54] = {id = 54, x = 235.89375305176, y = -413.49670410156, z = -118.16348266602,  name = "Enter Courtroom Lobby", destination = {55}},
	[55] = {id = 55, x = 233.27409362793, y = -410.31677246094, z = 48.111946105957,  name = "Exit Courtroom Lobby", destination = {54}},

	[55] = {id = 55, x = 233.27409362793, y = -410.31677246094, z = 48.111946105957,  name = "Exit Courtroom Lobby", destination = {54}},

	[56] = {id = 56, x = 457.28552246094, y = -3064.7868652344, z = 6.1692967414856,  name = "Leave KillRoom", destination = {57}},
	[57] = {id = 57, x = 456.98248291016, y = -3068.1420898438, z = 6.1692895889282,  name = "KillRoom (TaserTag)", destination = {56}},


}

-- 1138.0258789062,-3198.3552246094,-39.665664672852
-- Money laundering
