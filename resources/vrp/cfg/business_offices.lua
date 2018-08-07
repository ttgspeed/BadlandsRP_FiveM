local cfg = {}

local itemtr_minibar = {
  name="Minibar", -- menu name
  r=0,g=255,b=0, -- color
  max_units=20,
  units_per_minute=10,
  x=0,y=0,z=0, -- pos (doesn't matter as home component)
  radius=1.1, height=1.5, -- area
  recipes = {
    ["Beer"] = { -- action name
      description="A perfectly chilled bottle of Beer", -- action description
      in_money=0, -- money taken per unit
      out_money=0, -- money earned per unit
      reagents={}, -- items taken per unit
      products={
        ["beer2"] = 1 -- "group.aptitude", give 1 exp per unit
      }, -- items given per unit
      aptitudes={}
    },
    ["Vodka"] = { -- action name
      description="A perfectly chilled bottle of Vodka", -- action description
      in_money=0, -- money taken per unit
      out_money=0, -- money earned per unit
      reagents={}, -- items taken per unit
      products={
        ["vodka2"] = 1 -- "group.aptitude", give 1 exp per unit
      }, -- items given per unit
      aptitudes={}
    }
  }
}

-- default flats positions from https://github.com/Nadochima/HomeGTAV/blob/master/List

-- define the home slots (each entry coordinate should be unique for ALL types)
-- each slots is a list of home components
--- {component,x,y,z} (optional _config)
--- the entry component is required
cfg.slot_types = {
  ["business_office"] = {
    {
      {"entry",-77.652908325196,-829.83068847656,243.38598632812},
      {"chest",-82.742790222168,-809.87322998046,243.38598632812, _config = {weight=250}},
      {"wardrobe",-78.459571838378,-811.73638916016,243.38598632812},
      {"business_pc",-80.71784210205,-801.505859375,243.38763427734},
			{"inventory_mgr",-61.852813720704,-811.47674560546,243.4882598877},
      --{"itemtr", _config = itemtr_study, -758.670104980469,315.048156738281,221.854904174805}
    },
		{
      {"entry",-140.83624267578,-616.4614868164,168.82054138184},
      {"chest",-127.83407592774,-633.30603027344,168.82055664062, _config = {weight=250}},
      {"wardrobe",-132.17987060546,-634.14910888672,168.82055664062},
      {"business_pc",-125.8636932373,-640.76721191406,168.82223510742},
			{"inventory_mgr",-147.1781616211,-641.06536865234,168.82279968262},
      --{"itemtr", _config = itemtr_study, -758.670104980469,315.048156738281,221.854904174805}
    }
  }
}

-- define home clusters
cfg.homes = {
  ["Maze Bank Offices"] = {
    slot = "business_office",
    entry_point = {-68.759468078614,-801.47875976562,44.227298736572},
    buy_price = 2000000,
    sell_price = 1500000,
    max = 99,
    blipid=431,
    blipcolor=70
  }
}

return cfg
