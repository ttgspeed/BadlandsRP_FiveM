
local cfg = {}

cfg.db = {
  host = "45.55.232.93",
  database = "gta5_gamemode_essential",
  user = "feb5dee29051",
  password = "b46e6b907b777b92"
}

cfg.save_interval = 60 -- seconds
cfg.whitelist = true -- enable/disable whitelist

-- delay the tunnel at loading (for weak connections)
cfg.load_duration = 10 -- seconds, player duration in loading mode at the first spawn
cfg.load_delay = 60 -- milliseconds, delay the tunnel communication when in loading mode
cfg.global_delay = 0 -- milliseconds, delay the tunnel communication when not in loading mode

cfg.lang = "en"
cfg.debug = false


return cfg
