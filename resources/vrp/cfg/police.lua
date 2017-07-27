
local cfg = {}

cfg.whitelist = true	--enable/disable whitelisted cops

-- PCs positions
cfg.pcs = {
  {441.595916748047,-978.925598144531,30.6896076202393}
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
  "marijuana",
  "ephedrine",
  "meth",
  "diethylamine",
  "lsd",
  "safrole",
  "mdma",
  "raw_cocaine",
  "cocaine",
  "meth_kit",
  "lockpick"
}

-- jails {x,y,z,radius}
cfg.jails = {
  {459.485870361328,-1001.61560058594,24.914867401123,2.1},
  {459.305603027344,-997.873718261719,24.914867401123,2.1},
  {459.999938964844,-994.331298828125,24.9148578643799,1.6}
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

cfg.max_fine_amount = 50000 -- (any number below is accepted. so max is 50 000)

cfg.max_prison_time = 45 -- in minutes

cfg.store_robbery_cooldown = 10*60
cfg.cops_required_for_robbery = 1

return cfg
