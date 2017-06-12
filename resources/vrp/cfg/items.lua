-- define items, see the Inventory API on github

local cfg = {}

-- idname = {name,description,choices,weight}
-- a good practice is to create your own item pack file instead of adding items here
cfg.items = {
  ["marijuna"] = {"Marijuna", "", {}, 0.5}, -- no choices
  ["ephedrine"] = {"Ephedrine", "", {}, 0.5},
  ["diethylamine"] = {"Diethylamine", "", {}, 0.5},
  ["lsd"] = {"LSD", "", {}, 0.5},
  ["safrole"] = {"Safrole", "", {}, 0.5},
  ["mdma"] = {"MDMA", "", {}, 0.5},
  ["raw_cocaine"] = {"Raw Cocaine", "", {}, 0.5},
  ["cocaine"] = {"Cocaine", "", {}, 0.5},
  ["gold_ore"] = {"Gold Ore", "Raw ore", {}, 0.5},
  ["gold_processed"] = {"Processed Gold", "Processed ore", {}, 0.5},
  ["gold_ingot"] = {"Gold Ingot", "Ingot", {}, 0.5},
  ["gold_catalyst"] = {"Gold Catalyst", "Catalyst to turn processed gold into ingots", {}, 0.5}
}

-- load more items function
local function load_item_pack(name)
  local items = require("resources/vrp/cfg/item/"..name)
  if items then
    for k,v in pairs(items) do
      cfg.items[k] = v
    end
  else
    print("[vRP] item pack ["..name.."] not found")
  end
end

-- PACKS
load_item_pack("required")
load_item_pack("food")
load_item_pack("drugs")
load_item_pack("fishing")

return cfg
