
local cfg = {}

cfg.whitelist = true	--enable/disable whitelisted cops

-- PCs positions
cfg.pcs = {
  {441.595916748047,-978.925598144531,30.6896076202393}, --mrpd top
  {459.58465576172,-988.96569824219,24.9147605896}, -- mrpd bottom
  {1853.2869873047,3689.9880371094,34.267086029053}, --spd top
  {1842.8067626953,3675.2272949219,-118.76161956787}, --spd bottom
  {-449.4421081543,6012.591796875,31.716407775879}, -- ppd top
  {-432.8235168457,6006.21875,-118.76152038574}, -- ppd bottom
}

-- vehicle tracking configuration
cfg.trackveh = {
  min_time = 300, -- min time in seconds
  max_time = 600, -- max time in seconds
  service = "Police" -- service to alert when the tracking is successful
}

-- wanted display
cfg.wanted = {
  blipid = 458,
  blipcolor = 38,
  service = "Police"
}

-- illegal items (seize)
cfg.seizable_items = {
  "dirty_money",
  "weed",
  "weed2",
  "marijuana",
  "marijuana2",
  "cannabis_seed",
  "ephedrine",
  "meth",
  "diethylamine",
  "lsd",
  "safrole",
  "mdma",
  "coca_leaves",
	"coca_paste",
  "cocaine_pure",
	"cocaine_poor",
	"cement",
  "meth_kit",
  "lockpick",
	"safe_kit",
  "weapon_disable_kit",
	"speedbomb"
}

-- jails {x,y,z,radius}
cfg.jails = {
  -- Mission row
  {459.485870361328,-1001.61560058594,24.914867401123,2.1},
  {459.305603027344,-997.873718261719,24.914867401123,2.1},
  {459.999938964844,-994.331298828125,24.9148578643799,1.6},
  --{1844.1209716797,3664.5881347656,-116.789894104,2.1},
  --{1849.7084960938,3667.8369140625,-116.7899017334,2.1},
  --{1855.4504394531,3671.1003417969,-116.7899017334,2.1},
  --{1866.5147705078,3677.5546875,-116.78020477295,2.1},
  --{1870.6162109375,3679.4665527344,-116.7899017334,2.1},
  -- Sandy Shores
  {1843.0675048828,3684.3073730469,-118.76154327393,2.1},
  {1838.8367919922,3681.6520996094,-118.76139068604,2.1},
  {1834.34765625,3679.3251953125,-118.76160430908,2.1},
  -- Paleto
  {-441.55349731445,6003.9418945313,-118.76148986816,2.1},
  {-438.21740722656,6000.4907226563,-118.76148223877,2.1},
  {-434.61242675781,5997.1875,-118.76155853271,2.1},
}

-- fines
-- map of name -> money
cfg.fines = {
  ["Insult"] = 100,
  ["Speeding"] = 250,
  ["Stealing"] = 1000,
  ["Organized crime (low)"] = 10000,
  ["Organized crime (medium)"] = 25000,
  ["Organized crime (high)"] = 50000
}

cfg.max_fine_amount = 40000 -- (any number below is accepted. so max is 40 000)
cfg.max_prisonFine_amount = 40000 -- (any number below is accepted. so max is 40 000)

cfg.max_prison_time = 30 -- in minutes

cfg.store_robbery_cooldown = 15*60
cfg.cops_required_for_robbery = 2

return cfg
