
local cfg = {}

-- minimum capital to open a business
cfg.minimum_capital = 2500000

-- capital transfer reset interval in minutes
-- default: reset every 24h
cfg.transfer_reset_interval = 24*60

-- commerce chamber {blipid,blipcolor}
cfg.blip = {431,70}

-- positions of commerce chambers
cfg.commerce_chambers = {
  --{-156.09016418457,-603.548278808594,48.2438659667969}
}

cfg.dropzones = {
	[0] = {
		title = "Port of Los Santos, Elysian Islands",
		coords = {350.000,-2759.000,15.74296092987}
	},
	[1] = {
		title = "ULSA, Richman",
		coords = {-1725.000,235.000,58.471687316894} --          -68.759468078614,-801.47875976562,44.227298736572
	},
}

cfg.itempacks = {
	["Coca Leaves"] = {
		item_hash = "coca_leaves",
		description = "Receive a shipment of 100 Coca Leaves",
		amount = 100,
		price = 10000,
		illegal = true
	},
	["Italian Yeast"] = {
		item_hash = "yeast",
		description = "Receive a shipment of 100 Italian Yeast",
		amount = 100,
		price = 10000,
		illegal = false
	}
}

return cfg
