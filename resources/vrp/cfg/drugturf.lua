local cfg = {}

cfg.drugs = {
	["cocaine_pure"] = {lowPrice = 1070, dirty = true, name = "Cocaine baggie", weight = 0.5},
	["cocaine_poor"] = {lowPrice = 900, dirty = true, name = "Cocaine baggie", weight = 0.5},
	["meth"] = {lowPrice = 720, dirty = true, name = "Meth baggie", weight = 0.5},
	["weed2"] = {lowPrice = 600, dirty = false, name = "Serpickle Berry joint", weight = 0.5}, -- serpickle berry
	["weed"] = {lowPrice = 570, dirty = false, name = "Kifflom Kuff joint", weight = 0.5}, -- kifflom kush
}

cfg.maxIncreasePercent = 0.85	--% increase at max rep
cfg.maxReputation = 60				--How long(minutes) it takes for the turf to reach max reputation
cfg.reputationTickRate = 2		--ticks per minute
cfg.reputationPerTick = 0.5
cfg.reputationDecayPerTick = 0.2

return cfg

--0.7 sold/min
--42/hr

--Current numbers(Theoretical)
--Assuming 1 sold per min, 60 per hour
-- cocaine_pure: $112,817/hr
-- cocaine_poor: $95,041/hr
-- meth: $76,292/hr
-- weed: $63,767/hr
-- weed2: $60,631/hr
