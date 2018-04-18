

local cfg = {}

cfg.db = {
  host = "127.0.0.1",
  database = "gta5_gamemode_essential",
  user = "user",
  password = "password"
}

cfg.save_interval = 60 -- seconds
cfg.whitelist = false -- enable/disable whitelist

cfg.ignore_ip_identifier = true

-- delay the tunnel at loading (for weak connections)
cfg.load_duration = 10 -- seconds, player duration in loading mode at the first spawn
cfg.load_delay = 30 -- milliseconds, delay the tunnel communication when in loading mode
cfg.global_delay = 0 -- milliseconds, delay the tunnel communication when not in loading mode

cfg.ping_timeout = 5 -- number of minutes after a client should be kicked if not sending pings

cfg.lang = "en"
cfg.debug = false
cfg.debugTunnel = false -- Enable this only if you need to debug calls passing through the tunnel; will spam your console


return cfg
