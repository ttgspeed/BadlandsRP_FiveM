
local cfg = {}

-- define the first spawn position/radius of the player (very first spawn on the server, or after death)
cfg.spawn_enabled = true -- set to false to disable the feature
--cfg.spawn_position = {-538.570434570313,-215.849624633789,37.6497993469238} -- City hall
cfg.spawn_position = {-256.33142089844,-295.1545715332,21.626396179199} -- Rockford hills subway platform
cfg.respawn_positions = {
	{360.26232910156,-589.84228515625,28.656833648682}, --Textile city
	{339.4430847168,-1394.6103515625,32.509262084961}, --Strawberry
	{-496.83184814453,-335.97592163086,34.501708984375} --Rockford Hills
}
cfg.spawn_radius = 0.5

-- customization set when spawning for the first time
-- see https://wiki.fivem.net/wiki/Peds
-- mp_m_freemode_01 (male)
-- mp_f_freemode_01 (female)
cfg.default_customization = {
  model = "mp_m_freemode_01"
}

-- init default ped parts
for i=0,19 do
  cfg.default_customization[i] = {0,0}
end

cfg.clear_phone_directory_on_death = false
cfg.lose_aptitudes_on_death = true

return cfg
