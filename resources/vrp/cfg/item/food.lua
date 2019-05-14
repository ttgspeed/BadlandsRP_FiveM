-- define some basic inventory items

local items = {}

local function play_eat(player,conf)
  local defaults = {
    seq = {
      {"mp_player_inteat@burger", "mp_player_int_eat_burger_enter",1},
      {"mp_player_inteat@burger", "mp_player_int_eat_burger",1},
      {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp",1},
      {"mp_player_inteat@burger", "mp_player_int_eat_exit_burger",1}
    },
    prop = 'prop_cs_burger_01',
    animationLength = 3, --seconds
    bone = 60309,
    x = 0,
    y = 0,
    z = 0,
    xRot = 180,
    yRot = 0,
    zRot = 0
  }
  if conf == nil then conf = {} end
  local seq = conf.seq or defaults.seq
  local prop = conf.prop or defaults.prop
  local animationLength = conf.animationLength or defaults.animationLength
  local bone = conf.bone or defaults.bone
  local x = conf.x or defaults.x
  local y = conf.y or defaults.y
  local z = conf.z or defaults.z
  local xRot = conf.xRot or defaults.xRot
  local yRot = conf.yRot or defaults.yRot
  local zRot = conf.zRot or defaults.zRot

  vRPclient.getActionLock(player,{},function(isActionLocked)
    if not isActionLocked then
      vRPclient.setActionLock(player,{true})
      vRPclient.attachProp(player,{prop,bone,x,y,z,xRot,yRot,zRot})
      SetTimeout(animationLength*1000,function()
    		vRPclient.deleteProp(player,{prop})
        vRPclient.setActionLock(player,{false})
    	end)
      vRPclient.playAnim(player,{true,seq,false})
    else
      vRPclient.notify(player,{"You can't eat now!"})
    end
  end)
end

local function play_drink(player,conf)
  local defaults = {
    seq = {
      {"mp_player_intdrink","intro_bottle",1},
      {"mp_player_intdrink","loop_bottle",1},
      {"mp_player_intdrink","outro_bottle",1}
    },
    prop = 'prop_ld_flow_bottle',
    animationLength = 4, --seconds
    bone = 60309,
    x = 0,
    y = 0,
    z = 0,
    xRot = 180,
    yRot = 0,
    zRot = 0
  }
  if conf == nil then conf = {} end
  local seq = conf.seq or defaults.seq
  local prop = conf.prop or defaults.prop
  local animationLength = conf.animationLength or defaults.animationLength
  local bone = conf.bone or defaults.bone
  local x = conf.x or defaults.x
  local y = conf.y or defaults.y
  local z = conf.z or defaults.z
  local xRot = conf.xRot or defaults.xRot
  local yRot = conf.yRot or defaults.yRot
  local zRot = conf.zRot or defaults.zRot

  vRPclient.getActionLock(player,{},function(isActionLocked)
    if not isActionLocked then
      vRPclient.setActionLock(player,{true})
      vRPclient.attachProp(player,{prop,bone,x,y,z,rotX,rotY,rotZ})
      SetTimeout(animationLength*1000,function()
        vRPclient.deleteProp(player,{prop})
        vRPclient.setActionLock(player,{false})
      end)
      vRPclient.playAnim(player,{true,seq,false})
    else
      vRPclient.notify(player,{"You can't drink now!"})
    end
  end)
end

-- gen food choices as genfunc
-- idname
-- ftype: eat or drink
-- vary_hunger
-- vary_thirst
local function gen(ftype, vary_hunger, vary_thirst,conf)
  local fgen = function(args)
    local idname = args[1]
    local choices = {}
    local act = "Unknown"
    if ftype == "eat" then act = "Eat" elseif ftype == "drink" then act = "Drink" end
    local name = vRP.getItemName(idname)

    choices[act] = {function(player,choice)
      local user_id = vRP.getUserId(player)
      if user_id ~= nil then
        if vRP.tryGetInventoryItem(user_id,idname,1,false) then
          if vary_hunger ~= 0 then vRP.varyHunger(user_id,vary_hunger) end
          if vary_thirst ~= 0 then vRP.varyThirst(user_id,vary_thirst) end

          if ftype == "drink" then
            vRPclient.notify(player,{"Drinking "..name.."."})
            play_drink(player,conf)
            if(name == "Vodka" or name == "Beer" or name == "Bitter Wine" or name == "Wine" or name == "Don Pereon") then
              vRPclient.play_alcohol(player)
            end
          elseif ftype == "eat" then
            vRPclient.notify(player,{"Eating "..name.."."})
            play_eat(player,conf)
          end

          vRP.closeMenu(player)
        end
      end
    end}

    return choices
  end

  return fgen
end

-- DRINKS --
items["water"] = {"Water bottle","", gen("drink",0,-10),0.5}
items["milk"] = {"Milk","", gen("drink",0,-5),0.5}
items["coffee"] = {"Coffee","", gen("drink",0,-10),0.2}
items["starlatte"] = {"Morning Star Latte","Will leave you running all day", gen("drink",0,-40),0.2}
items["tea"] = {"Tea","", gen("drink",0,-15),0.2}
items["icetea"] = {"Ice-Tea","", gen("drink",0,-20), 0.5}
items["orangejuice"] = {"Orange Juice.","", gen("drink",0,-15),0.5}
items["lemonlimonad"] = {"Lemon limonad","", gen("drink",0,-45),0.3}
items["sareneshake"] = {"Sarene's Shake","Brings all the tastes buds to the yard", gen("drink",0,-15),0.3}
items["don_pereon"] = {"Don Pereon","A prestigeous champagne served to only the finest clients.", gen("drink",15,-30),0.5}

items["gocagola"] = {"Goca Gola","", gen("drink",0,-100,
  {
    prop='prop_ecola_can',
    seq={
      {"mp_player_intdrink", "loop", 3},
      {"mp_player_intdrink", "outro", 1}
    },
    animationLength=9
  }
),0.5}

items["redgull"] = {"RedGull","", gen("drink",0,-40,
  {
    prop='prop_ecola_can',
    seq={
      {"mp_player_intdrink", "loop", 3},
      {"mp_player_intdrink", "outro", 1}
    },
    animationLength=9
  }
),0.3}

items["vodka"] = {"Vodka","", gen("drink",15,-65,
  {
    prop='prop_cs_whiskey_bottle'
  }
),0.5}
items["vodka2"] = items["vodka"]

items["beer"] = {"Beer","", gen("drink",15,-30,
  {
    seq={
      {"amb@world_human_drinking@beer@male@enter", "enter", 1},
      {"amb@world_human_drinking@beer@male@base", "base", 1},
      {"amb@world_human_drinking@beer@male@idle_a", "idle_a", 1},
      {"amb@world_human_drinking@beer@male@idle_a", "idle_b", 1},
      {"amb@world_human_drinking@beer@male@idle_a", "idle_c", 1},
      {"amb@world_human_drinking@beer@male@exit", "exit", 1}
    },
    prop='prop_cs_beer_bot_40oz_02',
    animationLength=45,
    bone=28422,
    xRot=0
  }
),0.5}
items["beer2"] = items["beer"]

--Wine
items["wine"] = {"Wine","", gen("drink",15,-65),0.8}
items["bitter_wine"] = {"Bitter Wine","", gen("drink",15,-65),0.8}
items["grapes"] = {"Grapes","", gen("eat",-10,-10),0.5}
items["yeast"] = {"Italian Yeast","", gen("eat",0,0),0.3}

--FOOD

-- create Breed item
items["salt"] = {"Bag of Salt","Feeling salty?", gen("eat",0,50),0.5}
items["bread"] = {"Bread","", gen("eat",-10,0),0.5}
items["donut"] = {"Donut","", gen("eat",-15,0),0.2}
items["tacos"] = {"Taco","Artisan taco crafted with love in a completely sanitary food truck.", gen("eat",-50,0),0.2}
items["ppizza"] = {"Pineapple Pizza","", gen("eat",-100,0),0.8}
items["sandwich"] = {"Sandwich","A tasty snack.", gen("eat",-25,0),0.5}
items["kebab"] = {"Kebab","", gen("eat",-20,0),0.85}
items["peach"] = {"Peach","", gen("eat",-10,-10),0.5}
items["bobburger"] = {"Fatty Burger","A tasty and greasy treat that Bob would approve", gen("eat",-25,0),0.5}
items["scooby_snacks"] = {"Scooby Snacks","Pet food. It's a bit dry.", gen("eat",-1,0),0.2}
items["box_chocolate"] = {"Box of Chocolates","Thank you for being a part of the Badlands One Year Celebration!", gen("eat",-100,-100),0.2}

items["donut"] = {"Donut","", gen("eat",-15,0,
  {
    prop="prop_donut_01",
    seq={{"amb@code_human_wander_eating_donut@male@idle_a", "idle_a", 1},{"amb@code_human_wander_eating_donut@male@idle_a", "idle_b", 1},{"amb@code_human_wander_eating_donut@male@idle_a", "idle_c", 1}},
    bone=28422,
    xRot=0,
    animationLength=14
  }
),0.2}

items["pdonut"] = {"Premium Donut","", gen("eat",-25,0,
  {
    prop="prop_donut_02",
    seq={{"amb@code_human_wander_eating_donut@male@idle_a", "idle_a", 1},{"amb@code_human_wander_eating_donut@male@idle_a", "idle_b", 1},{"amb@code_human_wander_eating_donut@male@idle_a", "idle_c", 1}},
    bone=28422,
    xRot=0,
    animationLength=14
  }
),0.5}

items["steak"] = {"Steak","Medium Rare",gen("eat",-25,0, {prop='prop_cs_steak'})}
items["hotdog"] = {"Hot Dog","",gen("eat",-25,0, {prop='prop_cs_hotdog_01'})}

return items
