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
	--{"treatment",294.90209960938,-1447.9886474609,29.966594696045}, -- central
  {"treatment",308.48251342773,-594.80596923828,43.291809082031}, -- pillbox
	{"treatment",1690.5688476563,3580.9155273438,35.62060546875}, -- sandy
	{"treatment",-371.57354736328,6109.3056640625,31.857046127319}, -- paleto
  {"treatment",-461.57354736328,-363.79403686523,-186.46083068848}, -- Rockford hills
}

return cfg
