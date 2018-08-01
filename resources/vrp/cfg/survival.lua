local cfg = {}

cfg = {
  thirst_per_minute = 0.5,
  hunger_per_minute = 0.5,
  overflow_damage_factor = 5,
  pvp = true,
  police = false
}

cfg.reviveReward = 350

cfg.treatment_fee = 500

cfg.treatment_centers = {
	{"treatment",294.90209960938,-1447.9886474609,29.966594696045}, -- central
	{"treatment",1690.5688476563,3580.9155273438,35.62060546875}, -- sandy
	{"treatment",-380.68725585938,6118.8178710938,31.631261825562}, -- paleto
  {"treatment",-449.09201049805,-340.79925537109,34.501731872559}, -- Rockford hills
}

return cfg
