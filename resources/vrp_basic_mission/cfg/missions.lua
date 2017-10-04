
local cfg = {}

cfg.lang = "en"

-- REPAIR

-- map of permission -> repair config
-- (multiple repair permissions can work)
--- chance: chance factor per minute (1 => everytime, 10 => 1/10)
--- title
--- positions
--- reward: money reward
--- steps: number of things to fix
cfg.repair = {
  ["mission.repair.satellite_dishes"] = {
    chance = 5,
    title = "satellite dishes",
    steps = 3,
    positions = {
      {1985.55017089844,2929.42211914063,46.5480003356934},
      {1965.38012695313,2917.47241210938,56.1684608459473},
      {1963.78540039063,2923.09497070313,58.674430847168},
      {2000.7314453125,2930.4404296875,56.9706687927246},
      {2008.03125,2933.06591796875,59.4772453308105},
      {2021.29052734375,2945.23486328125,47.3697547912598},
      {2046.88366699219,2944.65673828125,51.0216827392578},
      {2048.24487304688,2950.81567382813,57.5155029296875},
      {2049.64965820313,2945.82641601563,57.5173225402832},
      {2043.96203613281,2945.04541015625,60.0233764648438},
      {2063.26318359375,2954.65551757813,47.1244201660156},
      {2078.7734375,2945.44653320313,56.4166870117188},
      {2084.89599609375,2949.8955078125,58.922477722168},
      {2075.71948242188,2950.55688476563,58.9233741760254},
      {2098.6142578125,2939.935546875,47.3400077819824},
      {2106.00659179688,2926.54125976563,50.9320068359375},
      {2106.63671875,2923.71069335938,57.4270858764648},
      {2106.38110351563,2929.37817382813,59.9300575256348},
      {2114.44677734375,2924.77514648438,59.933162689209},
      {2127.35888671875,2918.94116210938,47.7327079772949},
      {2137.28881835938,2900.53442382813,57.263298034668},
      {2137.61767578125,2906.61645507813,59.770336151123},
      {2144.6728515625,2900.85595703125,59.7593727111816}
    },
    reward = 5000
  },
  ["mission.repair.wind_turbines"] = {
    chance = 3,
    steps = 3,
    title = "wind turbines",
    positions = {
      {2363.77880859375,2288.63891601563,94.252693176269},
      {2347.873046875,2237.5771484375,99.3171691894531},
      {2330.4150390625,2114.89965820313,108.288673400879},
      {2331.23291015625,2054.52392578125,103.90625},
      {2287.10668945313,2075.57153320313,122.888381958008},
      {2271.43725585938,1996.4248046875,132.123352050781},
      {2307.3681640625,1972.44323730469,131.318496704102},
      {2267.27758789063,1917.859375,123.269912719727},
      {2299.90209960938,1857.3779296875,106.976081848145},
      {2356.48413085938,1836.69982910156,102.337211608887},
      {2368.70874023438,2189.45849609375,102.39933013916},
      {2331.19360351563,2115.28173828125,107.752799987793},
      {2394.2724609375,2032.27978515625,90.8146057128906},
      {2421.9619140625,1993.5029296875,84.0663833618164},
      {2238.2080078125,1832.9072265625,109.165466308594},
      {2182.4912109375,1790.45751953125,107.034156799316},
      {2121.57470703125,1751.63940429688,102.770606994629},
      {2078.06030273438,1691.92431640625,102.583801269531},
      {2193.9462890625,1872.39624023438,101.700164794922},
      {2171.10546875,1935.40234375,98.1589431762695},
      {2122.02001953125,1873.73413085938,94.2072296142578},
      {2060.23754882813,1891.8916015625,92.4888229370117},
      {2028.44543457031,1839.34899902344,95.2226181030273},
      {1998.96032714844,1928.62060546875,91.9152069091797},
      {2130.341796875,1991.19201660156,95.6245269775391},
      {2053.09692382813,2003.02526855469,85.7673645019531},
      {2045.7783203125,2121.36596679688,92.9723968505859},
      {1962.72485351563,2071.3837890625,84.2049255371094},
      {1986.53564453125,2201.74438476563,104.56078338623},
      {2403.23461914063,1421.8095703125,46.545524597168},
      {2395.29418945313,1275.31909179688,62.1865119934082},
      {2357.93920898438,1396.03503417969,58.766471862793},
      {2356.21923828125,1510.16247558594,53.7959403991699},
      {2357.71459960938,1672.58813476563,48.1546020507813},
      {2315.60717773438,1610.32861328125,57.4214057922363},
      {2318.15893554688,1451.642578125,62.7128677368164},
      {2315.06176757813,1332.63635253906,69.2738342285156},
      {2278.50537109375,1411.84729003906,74.4589614868164},
      {2277.935546875,1571.73840332031,65.2866058349609},
      {2285.47924804688,1718.18908691406,67.5195388793945},
      {2301.67553710938,1720.00378417969,67.5191650390625},
      {2236.84521484375,1533.4443359375,74.0033187866211},
      {2209.943359375,1402.51538085938,81.0048446655273},
      {2198.42260742188,1494.8056640625,82.1489868164063},
      {2201.107421875,1651.48608398438,83.2020797729492},
      {2135.998046875,1947.80163574219,93.2610549926758},
      {2136.65356445313,1935.0078125,93.3092422485352},
      {2237.078125,2047.81457519531,130.29948425293},
      {2193.90966796875,2098.634765625,127.141845703125},
      {2091.07739257813,2151.51904296875,109.695846557617},
      {2176.53930664063,2169.36450195313,116.783210754395},
      {2125.458984375,2235.02221679688,105.50072479248},
      {2165.76440429688,2263.04467773438,106.057846069336},
      {2152.46899414063,2335.74755859375,109.374145507813},
      {2114.52075195313,2401.951171875,100.229370117188},
      {2066.3115234375,2356.34008789063,96.4738998413086},
      {2067.13208007813,2277.85473632813,92.7935256958008},
      {1976.95776367188,2270.2734375,92.7666320800781},
      {2094.6669921875,2496.67724609375,90.2791900634766},
      {2198.02294921875,2489.65673828125,87.8666534423828}
    },
    reward = 2500
  }
}

-- DELIVERY

local common_delivery_positions = {
  {-1087.20959472656,479.4970703125,81.5277786254883},
  {-1215.48083496094,457.809478759766,91.9756546020508},
  {-1277.36901855469,496.794769287109,97.8074340820313},
  {-1380.82360839844,474.517272949219,105.052627563477},
  {-1063.642578125,-1054.95007324219,2.15036153793335},
  {-1113.640625,-1068.970703125,2.15036201477051},
  {-1161.85144042969,-1099.05871582031,2.17665767669678},
  {-1772.1751708984,-378.6180114746,46.479431152344},
  {-1715.5146484375,-447.2216796875,42.649215698242},
  {-1667.3563232422,-441.39227294922,40.355995178222},
  {-1622.4475097656,-380.03134155274,43.715744018554},
  {-1309.2189941406,-1220.6778564454,8.9804763793946},
  {-1269.5224609375,-1296.1706542968,4.0039443969726},
  {-1246.7803955078,-1358.6873779296,7.8206057548522},
  {-1135.4965820312,-1468.528930664,4.6186709403992},
  {-1108.2194824218,-1527.2702636718,6.7795333862304},
  {-1092.9938964844,-1607.8138427734,8.4588050842286},
  {-1076.8057861328,-1620.7866210938,4.4532718658448},
  {-1097.8958740234,-1673.4764404296,8.3939685821534},
  {-969.67510986328,-1431.4162597656,7.6791667938232},
  {-1898.9274902344,132.82568359375,81.984642028808},
  {-1960.1437988282,212.57887268066,86.511459350586},
  {-1570.5612792968,23.423141479492,59.553813934326},
  {-1467.4301757812,35.775554656982,54.54487991333},
  {-1549.5588378906,-89.921577453614,54.92917251587},
  {-1733.5130615234,379.7091369629,89.725158691406},
  {-668.14776611328,-971.60418701172,22.340843200684},
  {-765.6802368164,-917.08984375,21.078199386596},
  {-711.3060913086,-1028.2080078125,16.111251831054},
  {-824.90045166016,422.6056213379,92.124366760254},
  {-783.96655273438,459.17443847656,100.17904663086},
  {-817.75036621094,178.01774597168,72.222496032714},
  {-929.49249267578,18.535720825196,47.858421325684},
  {-970.97448730468,122.48963928222,57.04857635498},
  {-949.63372802734,196.2360534668,67.390548706054},
  {-213.99922180176,400.11880493164,111.10845184326},
  {-175.99383544922,502.64245605468,137.42123413086},
  {-7.4046478271484,468.58294677734,145.87322998046},
  {119.44979095458,494.02285766602,147.34295654296},
  {84.791717529296,562.98028564454,182.5719909668},
  {8.720009803772,540.67004394532,176.0271911621},
  {331.52429199218,465.50479125976,151.23458862304},
  {1265.9752197266,-457.85153198242,70.516967773438},
  {1252.4274902344,-494.27676391602,69.71011352539},
  {1385.831665039,-593.27001953125,74.485260009766},
  {1341.6217041016,-597.71545410156,74.700820922852},
  {1250.957397461,-621.27990722656,69.413261413574},
  {1265.8054199218,-703.47784423828,64.556999206542},
  {1404.6149902344,-1496.2314453125,59.962329864502},
  {1338.0715332032,-1525.207397461,54.18157196045},
  {1286.3358154296,-1604.1381835938,54.824897766114},
  {1193.2202148438,-1656.294921875,43.02645111084},
  {1275.474243164,-1722.0346679688,54.65502166748},
  {1258.2724609375,-1760.6298828125,49.260257720948},
  {4.9088191986084,-1223.494140625,29.295244216918},
  {236.42668151856,-2046.0174560546,18.37999534607},
  {323.91357421875,-1937.9777832032,25.018978118896},
  {386.16543579102,-1882.9266357422,25.602701187134},
  {513.84185791016,-1781.1392822266,28.913980484008},
  {490.35809326172,-1714.3005371094,29.706544876098},
  {405.65231323242,-1751.4143066406,29.710332870484},
  {-1335.8581542968,-1146.1765136718,6.7313966751098},
  {-1400.8743896484,-1445.9260253906,4.1273121833802}
}

-- map of permission => delivery config
--- items: map of idname => {min_amount,max_amount,reward_per_item}
--- positions
-- only one delivery permission can be used per player (no permission selection, only one will work)
cfg.delivery = {
  ["mission.delivery.food"] = {
    positions = common_delivery_positions,
    items = {
      ["tacos"] = {0,8,130},
      ["water"] = {0,8,60}
    }
  }
}

return cfg
