
local cfg = {}

-- exp notes:
-- levels are defined by the amount of xp
-- with a step of 5: 5|15|30|50|75 (by default)
-- total exp for a specific level, exp = step*lvl*(lvl+1)/2
-- level for a specific exp amount, lvl = (sqrt(1+8*exp/step)-1)/2

-- define groups of aptitudes
--- _title: title of the group
--- map of aptitude => {title,init_exp,max_exp}
---- max_exp: -1 for infinite exp
cfg.gaptitudes = {
  ["physical"] = {
    _title = "Physical",
    ["strength"] = {"Strength", 30, 105} -- required, level 3 to 6 (by default, can carry 10kg per level)
  }--[[, --Not in use yet
  ["science"] = {
    _title = "Science",
    ["chemicals"] = {"Study of chemicals", 0, -1}, -- example
    ["mathematics"] = {"Study of mathematics", 0, -1} -- example
  }]]--
}

cfg.gym_title = "Gym"

cfg.gym_fee = 5000
cfg.membership_duration = 15 --in minutes

cfg.excercises = {
	["pushup"] = {task = "WORLD_HUMAN_PUSH_UPS", gain = 3, time = 30, text = "Press ~INPUT_PICKUP~ to do push-ups"},
	["situp"] = {task = "WORLD_HUMAN_SIT_UPS", gain = 3, time = 30, text = "Press ~INPUT_PICKUP~ to do sit-ups"},
	["jog"] = {task = "WORLD_HUMAN_JOG_STANDING", gain = 3, time = 30, text = "Press ~INPUT_PICKUP~ to jog in place" },
	["pullup"] = {task = "prop_human_muscle_chin_ups", gain = 3, time = 30, text = "Press ~INPUT_PICKUP~ to do pull-ups"},
	["freeweight"] = {task = "world_human_muscle_free_weights", gain = 3, time = 30, text = "Press ~INPUT_PICKUP~ to use free weights"},
	["flex"] = {task = "world_human_muscle_flex", gain = 3, time = 30, text = "Press ~INPUT_PICKUP~ to flex"},
}

cfg.marker_type = 409
cfg.marker_colour = 61

cfg.workouts = {
	["beach"] = {
		-- {x,y,z,task,time (sec)}
		{-1204.7703857422,-1564.3238525391,4.6095085144043,"pullup"},
		{-1199.9503173828,-1571.2508544922,4.6094765663147,"pullup"},
		{-1195.9681396484,-1568.4527587891,4.619779586792,"jog"},
		{-1198.0915527344,-1566.1832275391,4.6188163757324,"jog"},
		{-1200.1920166016,-1563.7802734375,4.6180872917175,"flex"},
		{-1201.8264160156,-1561.3947753906,4.6181583404541,"freeweight"},
		{-1204.6652832031,-1557.8795166016,4.6175208091736,"freeweight"},
		{-1209.2840576172,-1559.787109375,4.6079320907593,"situp"},
		{-1207.6096191406,-1565.9970703125,4.6079335212708,"situp"},
		{-1202.3642578125,-1567.1461181641,4.6102633476257,"pushup"},
		{-1202.3364257813,-1572.6575927734,4.6079297065735,"pushup"},
		{-1206.5948486328,-1568.5745849609,4.6079316139221,"flex"},
	}
}

cfg.gyms = {
	{"beach",-1195.4742431641,-1577.4378662109,4.6080050468445},
}

return cfg
