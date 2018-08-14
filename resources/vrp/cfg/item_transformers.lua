
local cfg = {}

-- define static item transformers
-- see https://github.com/ImagicTheCat/vRP to understand the item transformer concept/definition

cfg.item_transformers = {
	-- example of harvest item transformer
	--[[
	{
		 name="Water bottles tree", -- menu name
		 -- permission = "harvest.water_bottle", -- you can add a permission
		 r=0,g=125,b=255, -- color
		 max_units=10,
		 units_per_minute=5,
		 x=1861,y=3680.5,z=33.26, -- pos
		 radius=5, height=1.5, -- area
		 action="Harvest", -- action name
		 description="Harvest some water bottles.", -- action description
		 in_money=0, -- money taken per unit
		 out_money=0, -- money earned per unit
		 reagents={}, -- items taken per unit
			products={ -- items given per unit
				["water"] = 1
			}
		--, onstart = function(player) end, -- optional start callback
		-- onstep = function(player) end, -- optional step callback
		-- onstop = function(player) end -- optional stop callback
		},]]--
	{
		name="Winery Supplier",
		tr_type = "sell",
		r=255,g=125,b=24,
		max_units=1000,
		units_per_minute=1000,
		x=-1892.4835205078,y=2076.6997070312,z=140.99745178222,
		radius=5, height=5,
		recipes = {
			["Sell Wine"] = {
				description="Sell high quality wine.",
				in_money=0,
				out_money=1800,
				reagents={
					["wine"] = 1
				},
				products={}
			},
			["Sell Bitter Wine"] = {
				description="Sell your poor quality wine that nobody actually wants.",
				in_money=0,
				out_money=500,
				reagents={
					["bitter_wine"] = 1
				},
				products={}
			},
		}
	},
	{
		name="Cocaine Dealer",
		tr_type = "sell",
		r=255,g=125,b=24,
		max_units=1000,
		units_per_minute=1000,
		x=-252.41233825684,y=-2419.8056640625,z=6.000636100769,
		radius=5, height=5,
		recipes = {
			["Sell"] = {
				description="Sell pure cocaine. None of that poor quality shit. Sell that to the street rats.",
				in_money=0,
				out_money=800,
				reagents={
					["cocaine_pure"] = 1
				},
				products={}
			}
		}
	},
	{
		name="Cement Powder",
		r=255,g=125,b=24,
		max_units=100,
		units_per_minute=10,
		x=380.24658203125,y=2882.4543457032,z=49.08724975586,
		radius=15, height=4,
		recipes = {
						["Gather"] = { -- action name
						description="Gather cement powder.",
				in_money=0,
				out_money=0,
				reagents={},
				products={
					["cement"] = 1
				},
				aptitudes={ -- optional
								["physical.strength"] = 0.1 -- "group.aptitude", give 1 exp per unit
							}
					}
				}
		},
	{
		name="Peach Field",
		r=255,g=125,b=24,
		max_units=100,
		units_per_minute=10,
		x=-2141.46630859375,y=-79.5226974487305,z=53.7380447387695,
		radius=15, height=4,
		recipes = {
  	      	["Harvest"] = { -- action name
		        description="Harvest peaches.",
				in_money=0,
				out_money=0,
				reagents={},
				products={
					["peach"] = 1
				},
				aptitudes={ -- optional
          			["physical.strength"] = 0.1 -- "group.aptitude", give 1 exp per unit
          		}
      		}
      	}
    },
	{
		name="Peach Field",
		r=255,g=125,b=24,
		max_units=100,
		units_per_minute=10,
		x=-2185.3857421875,y=-43.3630828857422,z=74.495719909668,
		radius=15, height=4,
		recipes = {
			["Harvest"] = {
				description="Harvest peaches.",
				in_money=0,
				out_money=0,
				reagents={},
				products={
					["peach"] = 1
				},
				aptitudes={ -- optional
          			["physical.strength"] = 0.1 -- "group.aptitude", give 1 exp per unit
          		}
			}
		}
	},
	{
		name="Peach Field",
		r=255,g=125,b=24,
		max_units=100,
		units_per_minute=10,
		x=-2217.4716796875,y=33.9435615539551,z=111.254753112793,
		radius=15, height=4,
		recipes = {
			["Harvest"] = {
				description="Harvest peaches.",
				in_money=0,
				out_money=0,
				reagents={},
				products={
					["peach"] = 1
				},
				aptitudes={ -- optional
          			["physical.strength"] = 0.1 -- "group.aptitude", give 1 exp per unit
          		}
			}
		}
	},
	{
		name="Peach Merchant",
		tr_type = "sell",
		r=255,g=125,b=24,
		max_units=1000,
		units_per_minute=1000,
		x=-1186.8271484375,y=-1532.5947265625,z=4.3794932365418,
		radius=5, height=5,
		recipes = {
			["Sell Peaches"] = {
				description="Sell peaches.",
				in_money=0,
				out_money=30,
				reagents={
					["peach"] = 1
				},
				products={}
			},
			["Sell Grapes"] = {
				description="Sell Grapes.",
				in_money=0,
				out_money=75,
				reagents={
					["grapes"] = 1
				},
				products={}
			}
		}
	},
	{
		name="Gold Mine",
		r=255,g=255,b=0,
		max_units=500,
		units_per_minute=10,
		x=-742.129760742188,y=2067.0029296875,z=106.176864624023,
		radius=30, height=8,
		recipes = {
			["Search for gold"] = {
				description="Search for gold",
				in_money=0,
				out_money=0,
				reagents={},
				products={
					["gold_ore"] = 1
				},
				aptitudes={ -- optional
          			["physical.strength"] = 0.1 -- "group.aptitude", give 1 exp per unit
          		}
			}
		}
	},
	--[[
	{
		name="Gold Treatment",
		tr_type = "transform",
		r=255,g=255,b=0,
		max_units=1000,
		units_per_minute=1000,
		x=-75.9527359008789,y=6495.42919921875,z=31.4908847808838,
		radius=24, height=2,
		action="Process ore",
		description="Process ore minerals",
		in_money=0,
		out_money=0,
		reagents={
			["gold_ore"] = 1
		},
		products={
			["gold_processed"] = 1
		}
	},
	]]--
	{
		name="Gold Refinement",
		tr_type = "transform",
		r=255,g=255,b=0,
		max_units=1000,
		units_per_minute=1000,
		x=1088.7426757812,y=-2000.430053711,z=30.87661933899,
		radius=10,height=3,
		recipes = {
			["Refine ore"] = {
				description="Process 2 ore into 1 ingot.",
				in_money=0,
				out_money=0,
				reagents={
					["gold_ore"] = 2
				},
				products={
					["gold_ingot"] = 1
				}
			}
		}
	},
	{
		name="Gold Merchant",
		tr_type = "sell",
		r=255,g=255,b=0,
		max_units=1000,
		units_per_minute=1000,
		x=-139.963653564453,y=-823.515258789063,z=31.4466247558594,
		radius=8,height=1.5,
		recipes = {
			["Sell"] = {
				description="Sell gold ingot.",
				in_money=0,
				out_money=110,
				reagents={
					["gold_ingot"] = 1
				},
				products={}
			}
		}
	},
	--[[
	{
		name="Marijuana Field",
		r=255,g=255,b=0,
		max_units=500,
		units_per_minute=10,
		x=2225.00927734375,y=5577.3154296875,z=53.8353805541992,
		radius=8,height=1.5,
		recipes = {
			["Harvest Marijuana"] = {
				description="Harvest Marijuana",
				in_money=0,
				out_money=0,
				reagents={},
				products={
					["marijuana"] = 1
				},
				aptitudes={ -- optional
          			["physical.strength"] = 0.1 -- "group.aptitude", give 1 exp per unit
          		}
			}
		}
	},
	]]--
	{
		name="Weed Processor",
		tr_type = "transform",
		r=255,g=255,b=0,
		max_units=1000,
		units_per_minute=1000,
		x=166.024078369141,y=2229.79077148438,z=89.7329788208008,
		radius=8,height=1.5,
		recipes = {
			["Process Kifflom Kush"] = {
				description="Process 2 Kifflom Kush buds into 1 joint.",
				in_money=0,
				out_money=0,
				reagents={
					 ["marijuana"] = 2
				},
				products={
					["weed"] = 1
				}
			},
			["Process Serpickle Berry"] = {
				description="Process 2 Serpickle Berry buds into 1 joint.",
				in_money=0,
				out_money=0,
				reagents={
					 ["marijuana2"] = 2
				},
				products={
					["weed2"] = 1
				}
			}
		}
	},
	{
		name="Ephedrine Drop",
		r=255,g=255,b=0,
		max_units=300,
		units_per_minute=8,
		x=71.386817932128,y=3710.556640625,z=39.754932403564,
		radius=15,height=1.5,
		recipes = {
			["Pick up Ephedrine"] = {
				description="The bikers probably wont miss this.",
				in_money=0,
				out_money=0,
				reagents={},
				products={
					["ephedrine"] = 1
				},
				aptitudes={ -- optional
          			["physical.strength"] = 0.1 -- "group.aptitude", give 1 exp per unit
          		}
			}
		}
	},
	--[[
	{
		name="Meth Processing Lab",
		tr_type = "transform",
		r=255,g=255,b=0,
		max_units=1000,
		units_per_minute=1000,
		x=1391.11328125,y=3608.18896484375,z=37.94189453125,
		radius=8,height=1.5,
		action="Process Ephedrine",
		description="Process 1 ephedrine into 1 meth.",
		in_money=0,
		out_money=0,
		reagents={["ephedrine"] = 1},
		products={
			["meth"] = 1
		}
	},
	{
		name="Diethylamine Field",
		r=255,g=255,b=0,
		max_units=320,
		units_per_minute=3,
		x=166.024078369141,y=2229.79077148438,z=89.7329788208008,
		radius=8,height=1.5,
		action="Harvest Diethylamine",
		description="Harvest Diethylamine.",
		in_money=0,
		out_money=0,
		reagents={},
		products={
			["diethylamine"] = 1
		}
	},
	{
		name="LSD Processing Lab",
		tr_type = "transform",
		r=255,g=255,b=0,
		max_units=1000,
		units_per_minute=1000,
		x=2515.3354492187,y=3792.3996582031,z=52.1224937438965,
		radius=8,height=1.5,
		action="Process Diethylamine",
		description="Process 1 diethylamine into 1 LSD.",
		in_money=0,
		out_money=0,
		reagents={["diethylamine"] = 1},
		products={
			["lsd"] = 1
		}
	},
	{
		name="Safrole Field",
		r=255,g=255,b=0,
		max_units=320,
		units_per_minute=3,
		x=3856.02709960938,y=4459.1904296875,z=0.84976637363434,
		radius=8,height=1.5,
		action="Harvest Safrole",
		description="Harvest Safrole.",
		in_money=0,
		out_money=0,
		reagents={},
		products={
			["safrole"] = 1
		}
	},
	{
		name="MDMA Processing Lab",
		tr_type = "transform",
		r=255,g=255,b=0,
		max_units=1000,
		units_per_minute=1000,
		x=-1145.96435546875,y=4940.06689453125,z=221.268676757813,
		radius=8,height=1.5,
		action="Process Safrole",
		description="Process 1 safrole into 1 MDMA.",
		in_money=0,
		out_money=0,
		reagents={["safrole"] = 1},
		products={
			["mdma"] = 1
		}
	},
	{
		name="Cocaine Field",
		r=255,g=255,b=0,
		max_units=480,
		units_per_minute=3,
		x=-553.635620117188,y=5324.27734375,z=72.5996704101563,
		radius=8,height=1.5,
		action="Harvest Cocaine",
		description="Harvest Cocaine.",
		in_money=0,
		out_money=0,
		reagents={},
		products={
			["raw_cocaine"] = 1
		}
	},
	{
		name="Cocaine Processing Lab",
		tr_type = "transform",
		r=255,g=255,b=0,
		max_units=1000,
		units_per_minute=1000,
		x=2434.9562988281,y=4968.6137695312,z=41.3476028442383,
		radius=8,height=1.5,
		action="Process Cocaine",
		description="Process 1 raw cocaine into 1 cocaine.",
		in_money=0,
		out_money=0,
		reagents={["raw_cocaine"] = 1},
		products={
			["cocaine"] = 1
		}
	},
	]]--
	--[[
	{
		name="Weed Dealer",
		tr_type = "sell",
		r=255,g=125,b=24,
		max_units=1000,
		units_per_minute=1000,
		x=77.885513305664,y=-1948.2086181641,z=19.174139022827,
		radius=5, height=2.5,
		recipes = {
			["Sell"] = {
				description="Sell weed",
				in_money=0,
				out_money=120,
				reagents={
					["weed"] = 1
				},
				products={}
			}
		}
	},
	]]--
	--[[
	{
		name="Cocaine Dealer",
		tr_type = "sell",
		r=255,g=125,b=24,
		max_units=1000,
		units_per_minute=1000,
		x=-224.3656463623,y=-224.3656463623,z=35.636913299561,
		radius=5, height=2.5,
		action="Sell",
		description="Sell cocaine. 25$",
		in_money=0,
		out_money=25,
		reagents = {
			["cocaine"] = 1
		},
		products={}
	},
	]]--
	--[[
	{
		name="Meth Dealer",
		tr_type = "sell",
		r=255,g=125,b=24,
		max_units=1000,
		units_per_minute=1000,
		x=-1724.7882080078,y=234.66094970703,z=57.471710205078,
		radius=5, height=2.5,
		recipes = {
			["Sell"] = {
				description="Sell meth.",
				in_money=0,
				out_money=150,
				reagents={
					["meth"] = 1
				},
				products={}
			}
		}
	},
	]]--
	--[[
	{
		name="LSD Dealer",
		tr_type = "sell",
		r=255,g=125,b=24,
		max_units=1000,
		units_per_minute=1000,
		x=-1724.7882080078,y=234.66094970703,z=57.471710205078,
		radius=5, height=2.5,
		action="Sell",
		description="Sell LSD. 25$",
		in_money=0,
		out_money=25,
		reagents = {
			["lsd"] = 1
		},
		products={}
	},
	{
		name="MDMA Dealer",
		tr_type = "sell",
		r=255,g=125,b=24,
		max_units=1000,
		units_per_minute=1000,
		x=1302.6696777344,y=4226.1025390625,z=31.908679962158,
		radius=5, height=2.5,
		action="Sell",
		description="Sell MDMA. 25$",
		in_money=0,
		out_money=25,
		reagents = {
			["mdma"] = 1
		},
		products={}
	},
	]]--
	{
		name="Fish Trader", -- menu name
		tr_type = "sell",
		-- permission = "harvest.water_bottle", -- you can add a permission
		r=0,g=125,b=255, -- color
		max_units=1000,
		units_per_minute=1000,
		x =-1424.05676269531,
		y = -712.087829589844,
		z = 23.8108673095703,
		radius=5, height=1.5, -- area
		recipes = {
			["Sell high quality fish."] = {
				description="Sell some fish.",
				in_money=0,
				out_money=185,
				reagents={
					["high_quality_fish"] = 1
				},
				products={}
			},
			["Sell medium quality fish."] = {
				description="Sell some fish.",
				in_money=0,
				out_money=150,
				reagents={
					["regular_fish"] = 1
				},
				products={}
			},
			["Sell low quality fish."] = {
				description="Sell some fish.",
				in_money=0,
				out_money=125,
				reagents={
					["low_quality_fish"] = 1
				},
				products={}
			}
		}
	},
	{
		name="Church of Epsilon",
		tr_type = "sell",
		r=255,g=125,b=24,
		max_units=1000,
		units_per_minute=1000,
		x=-766.43145751954,
		y=-24.12066078186,
		z=41.079685211182,
		radius=5, height=2.5,
		recipes = {
			["Marriage"] = {
				description="Obtain a marriage license and ring",
				in_money=1000000,
				out_money=0,
				reagents={
					["gold_ingot"] = 1,
					["diamond"] = 1,
				},
				products={
					["diamond_ring"] = 1
				}
			}
		}
	},
	--[[,
	{
		name="Body training", -- menu name
		r=255,g=125,b=0, -- color
		max_units=1000,
		units_per_minute=1000,
		x=-1202.96252441406,y=-1566.14086914063,z=4.61040639877319,
		radius=7.5, height=1.5, -- area
		recipes = {
		  	["Strength"] = { -- action name
			    description="Increase your strength.", -- action description
			    in_money=0, -- money taken per unit
			    out_money=0, -- money earned per unit
			    reagents={}, -- items taken per unit
			    products={}, -- items given per unit
			    aptitudes={ -- optional
		      		["physical.strength"] = 1 -- "group.aptitude", give 1 exp per unit
		    	}
		  	}
		}
	}]]-- Rate is wayyyyy too faste
}

-- define transformers randomly placed on the map
cfg.hidden_transformers = {
--[[
	["weed field"] = {
		def = {
			name="Weed field", -- menu name
			-- permission = "harvest.water_bottle", -- you can add a permission
			r=0,g=200,b=0, -- color
			max_units=30,
			units_per_minute=1,
			x=0,y=0,z=0, -- pos
			radius=5, height=1.5, -- area
			action="Harvest", -- action name
			description="Harvest some weed.", -- action description
			in_money=0, -- money taken per unit
			out_money=0, -- money earned per unit
			reagents={}, -- items taken per unit
			products={ -- items given per unit
				["weed"] = 1
			}
		},
		positions = {
			{1873.36901855469,3658.46215820313,33.8029747009277},
			{1856.33776855469,3635.12109375,34.1897926330566},
			{1830.75390625,3621.44140625,33.8487205505371}
		}
	}
]]--
}

-- time in minutes before hidden transformers are relocated (min is 5 minutes)
cfg.hidden_transformer_duration = 5*24*60 -- 5 days

-- configure the information reseller (can sell hidden transformers positions)
cfg.informer = {
  infos = {
    ["Meth Operations"] = 4000
  },
  positions = {
    {1821.12390136719,3685.9736328125,34.2769317626953},
    {714.0942993164,-1191.4069824218,24.287609100342},
		{969.17108154296,-2196.6889648438,31.534769058228},
		{159.08741760254,-2940.4799804688,7.2396726608276},
		{-123.82935333252,-2233.6437988282,7.8116765022278},
		{-1545.3728027344,-235.23178100586,48.276481628418},
		{-1381.7531738282,-1328.3778076172,4.150158405304}
  },
  interval = 1, -- interval in minutes for the reseller respawn
  duration = 20, -- duration in minutes of the spawned reseller
  blipid = 133,
  blipcolor = 2
}

return cfg
