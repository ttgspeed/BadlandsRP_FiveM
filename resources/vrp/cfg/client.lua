-- client-side vRP configuration

cfg = {}

cfg.iplload = true

cfg.voice_proximity = 50.0

cfg.gui = {
  anchor_minimap_width = 272,
  anchor_minimap_left = 29,
  anchor_minimap_bottom = 17
}

-- disable menu if handcuffed
cfg.handcuff_disable_menu = true

-- when health is under the threshold, player is in coma
-- set to 0 to disable coma
cfg.coma_threshold = 120

-- maximum duration of the coma in minutes
cfg.coma_duration = 3

-- if true, a player in coma will not be able to open the main menu
cfg.coma_disable_menu = false

-- see https://wiki.fivem.net/wiki/Screen_Effects
cfg.coma_effect = "DeathFailMPIn"
