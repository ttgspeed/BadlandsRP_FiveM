
local cfg = {}

-- define the first spawn position/radius of the player (very first spawn on the server, or after death)
cfg.spawn_enabled = true -- set to false to disable the feature
cfg.spawn_position = {-538.570434570313,-215.849624633789,37.6497993469238}
cfg.spawn_radius = 0.5

-- customization set when spawning for the first time
-- see https://wiki.fivem.net/wiki/Peds
-- mp_m_freemode_01 (male)
-- mp_f_freemode_01 (female)
cfg.default_customization = {
  model = "mp_m_freemode_01"
}

cfg.male_model = {
  model = "mp_m_freemode_01"
}

cfg.female_model = {
  model = "mp_f_freemode_01"
}

-- init default ped parts
for i=0,19 do
  cfg.default_customization[i] = {0,0}
  cfg.female_model[i] = {0,0}
end
cfg.female_model[0] = {21,0}

cfg.clear_phone_directory_on_death = false

return cfg
