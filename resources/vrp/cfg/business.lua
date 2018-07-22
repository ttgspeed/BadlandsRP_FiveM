
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
		title = "Dry Dock, Elysian Islands",
		coords = {350.000,-2759.000,15.74296092987}
	},
	[1] = {
		title = "ULSA, Richman",
		coords = {-1725.000,235.000,58.471687316894}
	},
	[2] = {
		title = "Scrapyard Warehouse, La puerta",
		coords = {-571.84674072266,-1603.91015625,27.010787963868}
	},
	[3] = {
		title = "Cave, Palomino Highlands",
		coords = {2823.40234375,-746.5269165039,1.635531783104}
	},
	[4] = {
		title = "Water Pipe, Tataviam Mountains",
		coords = {1881.2749023438,600.36560058594,192.99082946778}
	},
	[5] = {
		title = "End of Line, Paleto Bay",
		coords = {-170.36567687988,6062.4912109375,30.5207157135}
	},
	[6] = {
		title = "Bridge, Great Ocean Highway",
		coords = {1500.5826416016,6564.1860351562,5.122272491455}
	},
	[7] = {
		title = "Catfish View, Mount Gordo",
		coords = {3345.5615234375,5161.0395507812,17.711084365844}
	},
	[7] = {
		title = "All Seeing Eye, Sandy Shores",
		coords = {2512.6965332032,3777.6435546875,52.873783111572}
	},
	[8] = {
		title = "Garage, Ron Alternates Wind Farm",
		coords = {2330.3713378906,2572.7722167968,46.679504394532}
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
