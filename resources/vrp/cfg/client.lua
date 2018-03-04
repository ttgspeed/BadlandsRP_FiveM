-- client-side vRP configuration

local cfg = {}

cfg.max_players = 32

cfg.iplload = true

cfg.traffic_density = 0.5

cfg.voice_proximity = 50.0
-- The 2 below are not used at this time
cfg.voice_proximity_vehicle = 5.0
cfg.voice_proximity_inside = 9.0

cfg.gui = {
  anchor_minimap_width = 272,
  anchor_minimap_left = 29,
  anchor_minimap_bottom = 17
}

-- gui controls (see https://wiki.fivem.net/wiki/Controls)
-- recommended to keep the default values and ask players to change their keys
cfg.controls = {
  phone = {
    -- PHONE CONTROLS
    up = {3,172},
    down = {3,173},
    left = {3,174},
    right = {3,175},
    select = {3,176},
    cancel = {3,177},
    open = {3,244} -- INPUT_PHONE, open general menu
  },
  request = {
    yes = {1,288}, -- F1
    no = {1,289} -- F2
  }
}

-- disable menu if handcuffed
cfg.handcuff_disable_menu = true

-- when health is under the threshold, player is in coma
-- set to 0 to disable coma
cfg.coma_threshold = 105

-- maximum duration of the coma in minutes
cfg.coma_duration = 3
cfg.knockout_duration = 0.5
cfg.max_bleed_out = 15*60

-- if true, a player in coma will not be able to open the main menu
cfg.coma_disable_menu = true

-- see https://wiki.fivem.net/wiki/Screen_Effects
cfg.coma_effect = "DeathFailMPIn"

-- if true, vehicles can be controlled by others, but this might corrupts the vehicles id and prevent players from interacting with their vehicles
cfg.vehicle_migration = false

cfg.lockpick_time = 45 -- How many seconds it takes to pick a car lock

cfg.caralarm_timeout = 20 -- how long the car alarm will sound
return cfg
