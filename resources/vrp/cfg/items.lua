-- define items, see the Inventory API on github

local cfg = {}

-- idname = {name,description,choices,weight}
-- a good practice is to create your own item pack file instead of adding items here
cfg.items = {
  ["marijuana"] = {"Kifflom Kush Buds", "", nil, 0.5}, -- no choices
  ["marijuana2"] = {"Serpickle Berry Buds", "", nil, 0.5}, -- no choices
  ["ephedrine"] = {"Ephedrine", "", nil, 0.5},
  ["diethylamine"] = {"Diethylamine", "", nil, 0.5},
  ["lsd"] = {"LSD", "", nil, 0.5},
  ["safrole"] = {"Safrole", "", nil, 0.5},
  ["mdma"] = {"MDMA", "", nil, 0.5},
  ["gold_ore"] = {"Gold Ore", "Raw ore", nil, 0.5},
  ["gold_processed"] = {"Processed Gold", "Processed ore", nil, 0.5},
  ["gold_ingot"] = {"Gold Ingot", "Ingot", nil, 0.5},
  ["gold_catalyst"] = {"Gold Catalyst", "Catalyst to turn processed gold into ingots", nil, 0.5},
  --hunting
  ["rabbit_meat"] = {"Rabbit Meat", "Meat harvested from a poor, defenseless rabbit. You monster", nil, 0.5},
  ["boar_meat"] = {"Boar Meat", "Meat harvested from a boar", nil, 0.5},
  ["deer_meat"] = {"Deer Meat", "Meat harvested from a deer", nil, 0.5},
  ["mlion_meat"] = {"Lion Meat", "Meat harvested from a mountain lion", nil, 0.5},
  ["rabbit_hide"] = {"Rabbit Hide", "Hide harvested from a poor, defenseless rabbit. You monster", nil, 0.5},
  ["boar_hide"] = {"Boar Hide", "Hide harvested from a boar", nil, 0.5},
  ["deer_hide"] = {"Deer Hide", "Hide harvested from a deer", nil, 0.5},
  ["mlion_hide"] = {"Lion Hide", "Hide harvested from a mountain lion", nil, 0.5},

  ["sapphire"] = {"Sapphire", "A dull blue gem", nil, 0.5},
  ["old_boot"] = {"Old Boot", "Sorry aboot that", nil, 0.5},
  ["ruby"] = {"Ruby", "A shiny red gem", nil, 0.5},
  ["gold_coin"] = {"Gold Coin", "A shiny gold coin", nil, 0.5},
  ["diamond"] = {"Diamond", "An ancient piece of carbon", nil, 0.5},
	["blood_diamond"] = {"Blood Diamond", "A questionably sourced, albeit remarkably clear diamond.", nil, 0.5},
  ["common_artifact"] = {"Common Artifact", "An old carved stone", nil, 0.5},
  ["rare_artifact"] = {"Rare Artifact", "A chisled stone roughly resembling a frog", nil, 0.5},
	["diamond_ring2"] = {"Diamond Ring", "Try not to lose it", nil, 0.1},
  ["gsr_kit"] = {"GSR Test Kit", "Who done it?", nil, 0.5},
}

-- load more items function
local function load_item_pack(name)
  local items = module("cfg/item/"..name)

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
load_item_pack("misc")

return cfg
