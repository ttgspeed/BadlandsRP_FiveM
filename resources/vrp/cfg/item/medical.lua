local items = {}

local gauze_choices = {}
gauze_choices["Use"] = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and nuser_id ~= nil then
    if vRP.tryGetInventoryItem(user_id,"gauze",1) then
      print("[DEBUG] - Applying Gauze to "..user_id)
      TriggerClientEvent("mythic_hospital:items:gauze",player)
      vRP.closeMenu(player)
    end
  end
end, "", 1}

local bandage_choices = {}
bandage_choices["Use"] = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and nuser_id ~= nil then
    if vRP.tryGetInventoryItem(user_id,"bandage",1) then
      print("[DEBUG] - Used bandages on "..user_id)
      TriggerClientEvent("mythic_hospital:items:bandage",player)
      vRP.closeMenu(player)
    end
  end
end, "", 1}

local firstaid_choices = {}
firstaid_choices["Use"] = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and nuser_id ~= nil then
    if vRP.tryGetInventoryItem(user_id,"firstaid",1) then
      print("[DEBUG] - Used First Aid on "..user_id)
      TriggerClientEvent("mythic_hospital:items:firstaid",player)
      vRP.closeMenu(player)
    end
  end
end, "", 1}

local medicalkit_choices = {}
medicalkit_choices["Administer Treatment"] = {function(player,choice)
  vRPclient.getNearestPlayer(player,{5},function(nplayer)
    local user_id = vRP.getUserId(player)
    local nuser_id = vRP.getUserId(nplayer)
    if user_id ~= nil and nuser_id ~= nil then
      if vRP.tryGetInventoryItem(user_id,"medicalkit",1) then
        print("[DEBUG] - Used Medial Kit on "..nuser_id)
        TriggerClientEvent("mythic_hospital:items:medkit",nplayer)
        vRP.closeMenu(player)
      end
    end
  end)
end,"", 1}

local vicodin_choices = {}
vicodin_choices["Use"] = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    if vRP.tryGetInventoryItem(user_id,"vicodin",1) then
      print("[DEBUG] - "..user_id.." used vicodin")
      TriggerClientEvent("mythic_hospital:items:vicodin",player)
      vRP.closeMenu(player)
    end
  end
end,"", 1}

local hydrocodone_choices = {}
hydrocodone_choices["Use"] = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    if vRP.tryGetInventoryItem(user_id,"hydrocodone",1) then
      print("[DEBUG] - "..user_id.." used hydrocodone")
      TriggerClientEvent("mythic_hospital:items:hydrocodone",player)
      vRP.closeMenu(player)
    end
  end
end, "", 1}

local morphine_choices = {}
morphine_choices["Administer Dosage"] = {function(player,choice)
  vRPclient.getNearestPlayer(player,{5},function(nplayer)
    local user_id = vRP.getUserId(player)
    local nuser_id = vRP.getUserId(nplayer)
    if user_id ~= nil and nuser_id ~= nil then
      if vRP.tryGetInventoryItem(user_id,"morphine",1) then
        print("[DEBUG] - Gave morphine to "..nuser_id)
        TriggerClientEvent("mythic_hospital:items:morphine",nplayer)
        vRP.closeMenu(player)
      end
    end
  end)
end,"", 1}

items["gauze"] = {"Gauze","It's a wrap!",function(args) return gauze_choices end,0.01}
items["bandage"] = {"Bandage","The age of bands",function(args) return bandage_choices end,0.01}
items["firstaid"] = {"First Aid Kit","A kit that help you first",function(args) return firstaid_choices end,0.01}
items["medicalkit"] = {"Medical Aid Kit","Meds in a kit",function(args) return medicalkit_choices end,0.01}
items["vicodin"] = {"Vicodin","A simple painkiller",function(args) return vicodin_choices end,0.01}
items["hydrocodone"] = {"Hydrocodone","Forget the pain",function(args) return hydrocodone_choices end,0.01}
items["morphine"] = {"Morphine","The most effective painkiller",function(args) return morphine_choices end,0.01}

return items
