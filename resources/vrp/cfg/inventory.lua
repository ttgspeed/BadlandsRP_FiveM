
local cfg = {}

cfg.inventory_weight_per_strength = 10 -- weight for an user inventory per strength level (no unit, but thinking in "kg" is a good norm)

-- default chest weight for vehicle trunks
cfg.default_vehicle_chest_weight = 40

-- define vehicle chest weight by model in lower case
cfg.vehicle_chest_weights = {

	-- job vehicles
	["mule"] = 180,
	-- suvs
	["baller"] = 70,
	["cavalcade"] = 70,
	["granger"] = 70,
	["huntley"] = 70,
	["landstalker"] = 70,
	["radi"] = 70,
	["rocoto"] = 70,
	["seminole"] = 70,
	["xls"] = 70,
	-- vans
	["bison"] = 100,
	["bobcatxl"] = 100,
	["gburrito"] = 100,
	["journey"] = 100,
	["minivan"] = 100,
	["paradise"] = 100,
	["rumpo"] = 100,
	["surfer"] = 100,
	["youga"] = 100,
	-- bikes
	["AKUMA"] = 25,
	["bagger"] = 25,
	["bati"] = 25,
	["bati2"] = 25,
	["bf400"] = 25,
	["carbonrs"] = 25,
	["cliffhanger"] = 25,
	["daemon"] = 25,
	["double"] = 25,
	["enduro"] = 25,
	["faggio2"] = 25,
	["gargoyle"] = 25,
	["hakuchou"] = 25,
	["hexer"] = 25,
	["innovation"] = 25,
	["lectro"] = 25,
	["nemesis"] = 25,
	["pcj"] = 25,
	["ruffian"] = 25,
	["sanchez"] = 25,
	["sovereign"] = 25,
	["thrust"] = 25,
	["vader"] = 25,
	["vindicator"] = 25
}

return cfg
