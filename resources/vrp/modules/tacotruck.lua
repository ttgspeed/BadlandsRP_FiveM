-----------------
--- Variables ---
-----------------

local cfg = module("cfg/tacotruck")

activetacoLabs = {}

------------------------
--- Server functions ---
------------------------

--inform the server that a player has entered a taco lab
function tvRP.entertacoLab(vehicleId,vehicleModel,vehiceName)
  if activetacoLabs[vehicleId] ~= nil then
    activetacoLabs[vehicleId].players[source] = true
    vRPclient.setProgressBar(source,{"tacoLab:"..activetacoLabs[vehicleId].chestname,"center","Cooking taco ...",255,1,1,0})
  end
end

--inform the server that a player has left a taco lab
function tvRP.exittacoLab(vehicleId)
  if activetacoLabs[vehicleId] ~= nil then
    vRPclient.removeProgressBar(source,{"tacoLab:"..activetacoLabs[vehicleId].chestname})
    activetacoLabs[vehicleId].players[source] = nil
  end
end

-- sync smoke to all clients
function tvRP.syncSmoke(vehicleId,on,x,y,z)
  SetTimeout(1000,function()
    if on then
      vRPclient.addSmoke(-1,{vehicleId,x,y,z})
    else
      vRPclient.removeSmoke(-1,{vehicleId})
    end
  end)
end

--syncs taco lab position
function tvRP.syncPosition(vehicleId,x,y,z)
  activetacoLabs[vehicleId].location = {x=x,y=y,z=z}
end

function tvRP.getLabPosition(vehicleId)
  if activetacoLabs[vehicleId] ~= nil then
    return activetacoLabs[vehiceId].location
  else
    return {}
  end
end

--get the location of a random taco lab
--nil if no taco labs are active
--empty table {} if taco lab exists but hasn't started cooking
function tvRP.getRandomLabPosition()
  if next(activetacoLabs) == nil then return nil end
  local keyset = {}
  for k in pairs(activetacoLabs) do
    table.insert(keyset, k)
  end
  -- Initialize the pseudo random number generator
  math.randomseed( os.time() )
  math.random(); math.random(); math.random()
  -- done. :-)
  local lab = activetacoLabs[keyset[math.random(#keyset+1)]]
  if lab ~= nil then
    return lab.location
  end
  return nil
end

--adds a vehicle as a taco lab
--called from the use of the taco_kit item
function tvRP.addtacoLab(vehicleId,name,user_id)
  if activetacoLabs[vehiceId] ~= nil then return end

  --check if name is a taco lab
  if not isCartacoLab(name) then
    vRP.giveInventoryItem(user_id,"taco_kit",1)
    return
  end

  local tacoLab = {}
  tacoLab.players = {}
  tacoLab.location = {}
  tacoLab.chestname = "u"..user_id.."veh_"..string.lower(name)

  --get chest data
  vRP.getSData("chest:"..tacoLab.chestname,function(items)
    tacoLab.items = json.decode(items) or {}
  end)
  activetacoLabs[vehicleId] = tacoLab
  vRPclient.addtacoLab(-1,{vehicleId})
  print("Taco truck added")
end

--------------------------
--- Internal Functions ---
--------------------------

--removes a taco lab
--TODO: figure out when this needs to be called, currently once a taco lab is added it is there forever
function removetacoLab(vehicleId)
  activetacoLabs[vehicleId] = nil
  vRPclient.removetacoLab(-1,{vehicleId})
end

--check if a given car is a taco lab
function isCartacoLab(carModel)
  for i,v in ipairs(cfg.tacoLabs) do
    if carModel == v then return true end
  end
  return false
end

--processes a tick of the taco lab, removes reagent and adds products
function tacoLabTick(lab)
  lab.items = {}
  vRP.getSData("chest:"..lab.chestname,function(items)
    for k,v in pairs(lab.players) do
      lab.items = json.decode(items) or {}

      --check if vehicle has taco ingredients
      local reagents_ok = true
      for reagent,amount in pairs(cfg.tacoIngredients) do
        if lab.items[reagent] == nil then
          reagents_ok = false
          break
        end
        reagents_ok = reagents_ok and (lab.items[reagent].amount >= amount)
      end

      if not reagents_ok then
        vRPclient.notify(k,{"You are missing ingredients"})
        return
      end

      --take ingredients from car
      for reagent,amount in pairs(cfg.tacoIngredients) do
        lab.items[reagent].amount = lab.items[reagent].amount - amount
        if lab.items[reagent].amount == 0 then
          lab.items[reagent] = nil
        end
      end

      --add products
      for product,amount in pairs(cfg.tacoProducts) do
        if lab.items[product] ~= nil then
          lab.items[product].amount = lab.items[product].amount + amount
        else
          lab.items[product] = {}
          lab.items[product].amount = 1
        end
      end

      --------------------
      --Process drink pack
      -------------------

      --check if vehicle has taco ingredients
      local reagents_ok = true
      for reagent,amount in pairs(cfg.drinkIngredients) do
        if lab.items[reagent] == nil then
          reagents_ok = false
          break
        end
        reagents_ok = reagents_ok and (lab.items[reagent].amount >= amount)
      end

      --take ingredients from car
      for reagent,amount in pairs(cfg.drinkIngredients) do
        lab.items[reagent].amount = lab.items[reagent].amount - amount
        if lab.items[reagent].amount == 0 then
          lab.items[reagent] = nil
        end
      end

      --add products
      for product,amount in pairs(cfg.drinkProducts) do
        if lab.items[product] ~= nil then
          lab.items[product].amount = lab.items[product].amount + amount
        else
          lab.items[product] = {}
          lab.items[product].amount = 1
        end
      end

      vRP.setSData("chest:"..lab.chestname, json.encode(lab.items))
    end

    -- display transformation state to all transforming players
    for k,v in pairs(lab.players) do
      local reagentAmount = 1000
      for reagent,amount in pairs(cfg.tacoIngredients) do
        local currAmount = 0
        if lab.items[reagent] == nil then
          currAmount = 0
        else
          currAmount = lab.items[reagent].amount
        end
        if reagentAmount == nil then reagentAmount = currAmount end
        if currAmount < reagentAmount then reagentAmount = currAmount end
      end

      local productAmount = 0
      for product,amount in pairs(cfg.tacoProducts) do
        local currAmount = 1000
        if lab.items[product] == nil then
          currAmount = 0
        else
          currAmount = lab.items[product].amount
        end
        if productAmount == nil then productAmount = currAmount end
        if currAmount > productAmount then productAmount = currAmount end
      end

      vRPclient.setProgressBarValue(k,{"tacoLab:"..lab.chestname,math.floor((productAmount/(reagentAmount+productAmount))*100.0)})
      vRPclient.setProgressBarText(k,{"tacoLab:"..lab.chestname,"Cooking taco... "..reagentAmount.."-->"..productAmount})
    end
  end)
end

-- Loop the ticking of the taco lab
function loop()
  for k,v in pairs(activetacoLabs) do
    open = vRP.isChestOpen(v.chestname)
    if open then
      for player,_ in pairs(v.players) do
        vRPclient.notify(player,{"Cannot cook taco while the trunk is open."})
      end
    else
      vRP.setChestOpen(v.chestname)
      tacoLabTick(v)
      vRP.setChestClosed(v.chestname)
    end
  end
  SetTimeout(10000,loop)
end

loop()

-- JIP
AddEventHandler('playerConnecting', function(playerName, setKickReason)
  for k,v in pairs(activetacoLabs) do
    vRPclient.addtacoLab(source,{k})
  end
end)

-- Remove dropped players from taco lab
AddEventHandler('playerDropped', function()
  for vehicleId, lab in pairs(activetacoLabs) do
    if lab.players[source] ~= nil then
      activetacoLabs[vehicleId].players[source] = nil
    end
  end
end)
