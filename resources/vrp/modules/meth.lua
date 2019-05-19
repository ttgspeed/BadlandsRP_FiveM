-----------------
--- Variables ---
-----------------

local cfg = module("cfg/meth")

activeMethLabs = {}

------------------------
--- Server functions ---
------------------------

--inform the server that a player has entered a meth lab
function tvRP.enterMethLab(vehicleId,vehicleModel,vehiceName)
  if activeMethLabs[vehicleId] ~= nil then
    activeMethLabs[vehicleId].players[source] = true
    vRPclient.setProgressBar(source,{"MethLab:"..activeMethLabs[vehicleId].chestname,"center","Cooking meth ...",255,1,1,0})
  end
end

--inform the server that a player has left a meth lab
function tvRP.exitMethLab(vehicleId)
  if activeMethLabs[vehicleId] ~= nil then
    vRPclient.removeProgressBar(source,{"MethLab:"..activeMethLabs[vehicleId].chestname})
    activeMethLabs[vehicleId].players[source] = nil
  end
end

-- sync smoke to all clients
function tvRP.syncMethSmoke(vehicleId,on,x,y,z)
  SetTimeout(1000,function()
    if on then
      vRPclient.addMethSmoke(-1,{vehicleId,x,y,z})
    else
      vRPclient.removeMethSmoke(-1,{vehicleId})
    end
  end)
end

--syncs meth lab position
function tvRP.syncMethLabPosition(vehicleId,x,y,z)
  activeMethLabs[vehicleId].location = {x=x,y=y,z=z}
end

function tvRP.getLabPosition(vehicleId)
  if activeMethLabs[vehicleId] ~= nil then
    return activeMethLabs[vehiceId].location
  else
    return {}
  end
end

--get the location of a random meth lab
--nil if no meth labs are active
--empty table {} if meth lab exists but hasn't started cooking
function tvRP.getRandomLabPosition()
  if next(activeMethLabs) == nil then return nil end
  local keyset = {}
  for k in pairs(activeMethLabs) do
    table.insert(keyset, k)
  end
  -- Initialize the pseudo random number generator
  math.randomseed( os.time() )
  math.random(); math.random(); math.random()
  -- done. :-)
  local lab = activeMethLabs[keyset[math.random(#keyset+1)]]
  if lab ~= nil then
    return lab.location
  end
  return nil
end

--adds a vehicle as a meth lab
--called from the use of the meth_kit item
function tvRP.addMethLab(vehicleId,name,user_id)
  if activeMethLabs[vehiceId] ~= nil then return end

  --check if name is a meth lab
  if not isCarMethLab(name) then
    vRP.giveInventoryItem(user_id,"meth_kit",1)
    return
  end

  local methLab = {}
  methLab.players = {}
  methLab.location = {}
  methLab.chestname = "u"..user_id.."veh_"..string.lower(name)

  --get chest data
  vRP.getSData("chest:"..methLab.chestname,function(items)
    methLab.items = json.decode(items) or {}
  end)
  activeMethLabs[vehicleId] = methLab
  vRPclient.addMethLab(-1,{vehicleId})
end

--------------------------
--- Internal Functions ---
--------------------------

--removes a meth lab
--TODO: figure out when this needs to be called, currently once a meth lab is added it is there forever
function removeMethLab(vehicleId)
  activeMethLabs[vehicleId] = nil
  vRPclient.removeMethLab(-1,{vehicleId})
end

--check if a given car is a meth lab
function isCarMethLab(carModel)
  for i,v in ipairs(cfg.methLabs) do
    if carModel == v then return true end
  end
  return false
end

--processes a tick of the meth lab, removes reagent and adds products
function methLabTick(lab)
  lab.items = {}
  vRP.getSData("chest:"..lab.chestname,function(items)
    for k,v in pairs(lab.players) do
      lab.items = json.decode(items) or {}

      --check if vehicle has meth ingredients
      local reagents_ok = true
      for reagent,amount in pairs(cfg.methIngredients) do
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
      for reagent,amount in pairs(cfg.methIngredients) do
        lab.items[reagent].amount = lab.items[reagent].amount - amount
        if lab.items[reagent].amount == 0 then
          lab.items[reagent] = nil
        end
      end

      --add products
      for product,amount in pairs(cfg.methProducts) do
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
      for reagent,amount in pairs(cfg.methIngredients) do
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
      for product,amount in pairs(cfg.methProducts) do
        local currAmount = 1000
        if lab.items[product] == nil then
          currAmount = 0
        else
          currAmount = lab.items[product].amount
        end
        if productAmount == nil then productAmount = currAmount end
        if currAmount > productAmount then productAmount = currAmount end
      end

      vRPclient.setProgressBarValue(k,{"MethLab:"..lab.chestname,math.floor((productAmount/(reagentAmount+productAmount))*100.0)})
      vRPclient.setProgressBarText(k,{"MethLab:"..lab.chestname,"Cooking meth... "..reagentAmount.."-->"..productAmount})
    end
  end)
end

-- Loop the ticking of the meth lab
function methLabLoop()
  for k,v in pairs(activeMethLabs) do
    open = vRP.isChestOpen(v.chestname)
    if open then
      for player,_ in pairs(v.players) do
        vRPclient.notify(player,{"Cannot cook meth while the trunk is open."})
      end
    else
      vRP.setChestOpen(v.chestname)
      methLabTick(v)
      vRP.setChestClosed(v.chestname)
    end
  end
  SetTimeout(10000,methLabLoop)
end

methLabLoop()

-- JIP
AddEventHandler('playerConnecting', function(playerName, setKickReason)
  for k,v in pairs(activeMethLabs) do
    vRPclient.addMethLab(source,{k})
  end
end)

-- Remove dropped players from meth lab
AddEventHandler('playerDropped', function()
  for vehicleId, lab in pairs(activeMethLabs) do
    if lab.players[source] ~= nil then
      activeMethLabs[vehicleId].players[source] = nil
    end
  end
end)
