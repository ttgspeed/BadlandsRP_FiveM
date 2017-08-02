
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
cfg.load_delay = 30 -- milliseconds, delay the tunnel communication when in loading mode
cfg.global_delay = 0 -- milliseconds, delay the tunnel communication when not in loading mode

cfg.ping_timeout = 5 -- number of minutes after a client should be kicked if not sending pings

cfg.lang = "en"
cfg.debug = true
cfg.debugTunnel = true -- Enable this only if you need to debug calls passing through the tunnel; will spam your console


return cfg
