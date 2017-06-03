
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
    name="Peaches",
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
    name="Peaches",
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
    name="Peaches",
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
