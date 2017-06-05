
local cfg = {}

-- define static item transformers
-- see https://github.com/ImagicTheCat/vRP to understand the item transformer concept/definition

cfg.item_transformers = {
  -- example of harvest item transformer
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
  },
  {
    name="Peache Field",
    r=255,g=125,b=24,
    max_units=10,
    units_per_minute=1,
    x=-2141.46630859375,y=-79.5226974487305,z=53.7380447387695,
    radius=15, height=4,
    action="Harvest",
    description="Harvest peaches.",
    in_money=0,
    out_money=0,
    reagents={},
    products={
      ["peach"] = 3
    }
  },
  {
    name="Peache Field",
    r=255,g=125,b=24,
    max_units=10,
    units_per_minute=1,
    x=-2185.3857421875,y=-43.3630828857422,z=74.495719909668,
    radius=15, height=4,
    action="Harvest",
    description="Harvest peaches.",
    in_money=0,
    out_money=0,
    reagents={},
    products={
      ["peach"] = 3
    }
  },
  {
    name="Peache Field",
    r=255,g=125,b=24,
    max_units=10,
    units_per_minute=1,
    x=-2217.4716796875,y=33.9435615539551,z=111.254753112793,
    radius=15, height=4,
    action="Harvest",
    description="Harvest peaches.",
    in_money=0,
    out_money=0,
    reagents={},
    products={
      ["peach"] = 3
    }
  },
  {
    name="Peach Merchant",
    r=255,g=125,b=24,
    max_units=1000,
    units_per_minute=1000,
    x=-1484.080078125,y=-397.131927490234,z=38.3666610717773,
    radius=5, height=2.5,
    action="Sell",
    description="Sell peaches. 25$ for 5.",
    in_money=0,
    out_money=25,
    reagents = {
      ["peach"] = 5
    },
    products={}
  },
  {
    name="Gold Mine",
    r=255,g=255,b=0,
    max_units=60,
    units_per_minute=3,
    x=123.05940246582,y=3336.2939453125,z=30.7280216217041,
    radius=30, height=8,
    action="Search for gold",
    description="Search for gold",
    in_money=0,
    out_money=0,
    reagents={},
    products={
      ["gold_ore"] = 1
    }
  },
  {
    name="Gold Treatment",
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
  {
    name="Gold Refinement",
    r=255,g=255,b=0,
    max_units=1000,
    units_per_minute=1000,
    x=1032.71105957031,y=2516.86010742188,z=46.6488876342773,
    radius=24,height=4,
    action="Refine ore",
    description="Refine 10 processed and 1 catalyst into 1 gold ingot.",
    in_money=0,
    out_money=0,
    reagents={
      ["gold_processed"] = 10,
      ["gold_catalyst"] = 1
    },
    products={
      ["gold_ingot"] = 1
    }
  },
  {
    name="Gold Merchant",
    r=255,g=255,b=0,
    max_units=1000,
    units_per_minute=1000,
    x=-139.963653564453,y=-823.515258789063,z=31.4466247558594,
    radius=8,height=1.5,
    action="Sell gold ingot",
    description="Sell gold ingot for $1000.",
    in_money=0,
    out_money=1000,
    reagents={
      ["gold_ingot"] = 1
    },
    products={}
  },
  {
    name="Marijuna Field",
    r=255,g=255,b=0,
    max_units=60,
    units_per_minute=3,
    x=2213.0224609375,y=5577.65380859375,z=52.7998313903809,
    radius=8,height=1.5,
    action="Harvest Marijuna",
    description="Harvest Marijuna",
    in_money=0,
    out_money=0,
    reagents={},
    products={
      ["marijuna"] = 1
    }
  },
  {
    name="Weed Processor",
    r=255,g=255,b=0,
    max_units=1000,
    units_per_minute=1000,
    x=-1840.15637207031,y=2152.9907226563,z=115.324966430664,
    radius=8,height=1.5,
    action="Process Marijuna",
    description="Process 1 marijuna into 1 weed.",
    in_money=0,
    out_money=0,
    reagents={ ["marijuna"] = 1},
    products={
      ["weed"] = 1
    }
  },
  {
    name="Ephedrine Field",
    r=255,g=255,b=0,
    max_units=60,
    units_per_minute=3,
    x=65.3316345214844,y=3716.21728515625,z=38.754467010498,
    radius=8,height=1.5,
    action="Harvest Ephedrine",
    description="Harvest Ephedrine.",
    in_money=0,
    out_money=0,
    reagents={},
    products={
      ["ephedrine"] = 1
    }
  },
  {
    name="Meth Processing Lab",
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
    max_units=60,
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
    max_units=60,
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
    max_units=60,
    units_per_minute=3,
    x=3856.02709960938,y=4459.1904296875,z=0.84976637363434,
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
  {
    name="Weed Dealer",
    r=255,g=125,b=24,
    max_units=1000,
    units_per_minute=1000,
    x=77.885513305664,y=-1948.2086181641,z=19.174139022827,
    radius=5, height=2.5,
    action="Sell",
    description="Sell weed. 25$",
    in_money=0,
    out_money=25,
    reagents = {
      ["weed"] = 1
    },
    products={}
  },
  {
    name="Cocaine Dealer",
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
  {
    name="Meth Dealer",
    r=255,g=125,b=24,
    max_units=1000,
    units_per_minute=1000,
    x=1177.1647949219,y=2722.220703125,z=37.004173278809,
    radius=5, height=2.5,
    action="Sell",
    description="Sell meth. 25$",
    in_money=0,
    out_money=25,
    reagents = {
      ["meth"] = 1
    },
    products={}
  },
  {
    name="LSD Dealer",
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
  }
}

-- define transformers randomly placed on the map
cfg.hidden_transformers = {
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
}

-- time in minutes before hidden transformers are relocated (min is 5 minutes)
cfg.hidden_transformer_duration = 5*24*60 -- 5 days

-- configure the information reseller (can sell hidden transformers positions)
cfg.informer = {
  infos = {
    ["weed field"] = 20000
  },
  positions = {
    {1821.12390136719,3685.9736328125,34.2769317626953},
    {1804.2958984375,3684.12280273438,34.217945098877}
  },
  interval = 60, -- interval in minutes for the reseller respawn
  duration = 10, -- duration in minutes of the spawned reseller
  blipid = 133,
  blipcolor = 2
}

return cfg
