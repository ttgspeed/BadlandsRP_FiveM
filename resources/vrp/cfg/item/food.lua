-- define some basic inventory items

local items = {}

local function play_eat(player)
  local seq = {
    {"mp_player_inteat@burger", "mp_player_int_eat_burger_enter",1},
    {"mp_player_inteat@burger", "mp_player_int_eat_burger",1},
    {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp",1},
    {"mp_player_inteat@burger", "mp_player_int_eat_exit_burger",1}
  }

  vRPclient.playAnim(player,{true,seq,false})
end

local function play_drink(player)
  local seq = {
    {"mp_player_intdrink","intro_bottle",1},
    {"mp_player_intdrink","loop_bottle",1},
    {"mp_player_intdrink","outro_bottle",1}
  }

  vRPclient.playAnim(player,{true,seq,false})
end

-- gen food choices as genfunc
-- idname
-- ftype: eat or drink
-- vary_hunger
-- vary_thirst
local function gen(ftype, vary_hunger, vary_thirst)
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
            play_drink(player)
            if(name == "Vodka" or name == "Beer" or name == "Bitter Wine" or name == "Wine" or name == "Don Pereon") then
              vRPclient.play_alcohol(player)
            end
          elseif ftype == "eat" then
            vRPclient.notify(player,{"Eating "..name.."."})
            play_eat(player)
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
items["tea"] = {"Tea","", gen("drink",0,-15),0.2}
items["icetea"] = {"Ice-Tea","", gen("drink",0,-20), 0.5}
items["orangejuice"] = {"Orange Juice.","", gen("drink",0,-15),0.5}
items["gocagola"] = {"Goca Gola","", gen("drink",0,-100),0.5}
items["redgull"] = {"RedGull","", gen("drink",0,-40),0.3}
items["lemonlimonad"] = {"Lemon limonad","", gen("drink",0,-45),0.3}
items["vodka"] = {"Vodka","", gen("drink",15,-65),0.5}
items["beer"] = {"Beer","", gen("drink",15,-30),0.5}
items["vodka2"] = {"Vodka","", gen("drink",15,-65),0.5}
items["beer2"] = {"Beer","", gen("drink",15,-30),0.5}
items["don_pereon"] = {"Don Pereon","A prestigeous champagne served to only the finest clients.", gen("drink",15,-30),0.5}

--Wine
items["wine"] = {"Wine","", gen("drink",15,-65),0.8}
items["bitter_wine"] = {"Bitter Wine","", gen("drink",15,-65),0.8}
items["grapes"] = {"Grapes","", gen("eat",-10,-10),0.5}
items["yeast"] = {"Italian Yeast","", gen("eat",0,0),0.3}

--FOOD

-- create Breed item
items["bread"] = {"Bread","", gen("eat",-10,0),0.5}
items["donut"] = {"Donut","", gen("eat",-15,0),0.2}
items["tacos"] = {"Tacos","", gen("eat",-20,0),0.2}
items["ppizza"] = {"Pineapple Pizza","", gen("eat",-100,0),0.8}
items["sandwich"] = {"Sandwich","A tasty snack.", gen("eat",-25,0),0.5}
items["kebab"] = {"Kebab","", gen("eat",-20,0),0.85}
items["pdonut"] = {"Premium Donut","", gen("eat",-25,0),0.5}
items["peach"] = {"Peach","", gen("eat",-10,-10),0.5}
items["scooby_snacks"] = {"Scooby Snacks","Pet food. It's a bit dry.", gen("eat",-1,0),0.2}
items["box_chocolate"] = {"Box of Chocolates","Thank you for being a part of the Badlands One Year Celebration!", gen("eat",-100,-100),0.2}

return items
