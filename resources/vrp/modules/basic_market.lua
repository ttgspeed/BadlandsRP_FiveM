-- a basic market implementation

local lang = vRP.lang
local cfg = module("cfg/markets")
local Log = module("lib/Log")
local market_types = cfg.market_types
local markets = cfg.markets

local market_menus = {}


-- build market menus
local function build_market_menus()
  for gtype,mitems in pairs(market_types) do
    local market_menu = {
      name=lang.market.title({gtype}),
      css={top = "75px", header_color="rgba(0,255,125,0.75)"}
    }

    -- build market items
    local kitems = {}
    local player_selected_item = {}

    -- item choice
    local market_choice_buy = function(player,choice)
      local user_id = vRP.getUserId(player)
      if user_id ~= nil then
        choice = player_selected_item[user_id]
        if choice then
          vRP.prompt(player,lang.market.prompt({choice.item.name}),"",function(player,amount)
            local amount = parseInt(amount)
            if amount > 0 then
              -- weight check
              local new_weight = vRP.getInventoryWeight(user_id)+choice.item.weight*amount
              if new_weight <= vRP.getInventoryMaxWeight(user_id) then
                -- payment
                if vRP.tryPayment(user_id,amount*choice.price) then
                  vRP.giveInventoryItem(user_id,choice.idname,amount,true)
                  vRPclient.notify(player,{lang.money.paid({amount*choice.price})})
                  Log.write(user_id, "Purchased "..amount.."x "..choice.idname.." for $"..amount*choice.price,Log.log_type.purchase)
                else
                  vRPclient.notify(player,{lang.money.not_enough()})
                end
              else
                vRPclient.notify(player,{lang.inventory.full()})
              end
            else
              vRPclient.notify(player,{lang.common.invalid_value()})
            end
            vRP.openMenu(player,market_menus[gtype])
          end)
        end
      end
    end

    local market_choice_sell = function(player,choice)
      -- prompt amount
      local user_id = vRP.getUserId(player)
      if user_id ~= nil then
        choice = player_selected_item[user_id]
        if choice then
          vRP.prompt(player,lang.market.prompt_sell({choice.item.name}),"",function(player,amount)
            local amount = parseInt(amount)
            if amount > 0 then
              if vRP.tryGetInventoryItem(user_id,choice.idname,amount,true) then
                vRP.giveMoney(user_id,amount*choice.price_sell)
                vRPclient.notify(player,{lang.money.received({amount*choice.price_sell})})
                Log.write(user_id, "Sold "..amount.."x "..choice.idname.." for $"..amount*choice.price_sell,Log.log_type.purchase)
              end
            else
              vRPclient.notify(player,{lang.common.invalid_value()})
            end
            vRP.openMenu(player,market_menus[gtype])
          end)
        end
      end
    end

    local buy_sell = function(player,choice)
      -- prompt amount
      local user_id = vRP.getUserId(player)
      if user_id ~= nil then
        -- build item menu
        local idname = kitems[choice][1]
        local item = vRP.items[idname]
        local price = kitems[choice][2]
        local price_sell = math.floor(price*0.9)
        player_selected_item[user_id] = {
          ['idname'] = idname,
          ['item'] = item,
          ['price'] = price,
          ['price_sell'] = price_sell
        } -- This fix is stupid as hell but I don't feel like rewriting all of this code to fix it properly
        local submenudata = {name=choice,css={top="75px",header_color="rgba(0,125,255,0.75)"}}

        submenudata["Buy"] = {market_choice_buy,"Buy "..item.name.." for $"..price}
        submenudata["Sell"] = {market_choice_sell,"Sell "..item.name.." for $"..price_sell}

        -- open menu
        vRP.openMenu(player,submenudata)
      end
    end

    -- add item options
    for k,v in pairs(mitems) do
      local item = vRP.items[k]
      if item then
        kitems[item.name] = {k,math.max(v,0)} -- idname/price
        market_menu[item.name] = {buy_sell,"Buy/Sell "..item.name}
      end
    end

    market_menus[gtype] = market_menu
  end
end

local first_build = true

local function build_client_markets(source)
  -- prebuild the market menu once (all items should be defined now)
  if first_build then
    build_market_menus()
    first_build = false
  end

  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    for k,v in pairs(markets) do
      local gtype,x,y,z = table.unpack(v)
      local group = market_types[gtype]
      local menu = market_menus[gtype]

      if group and menu then -- check market type
        local gcfg = group._config

        local function market_enter()
          local user_id = vRP.getUserId(source)
          if user_id ~= nil and (gcfg.permission == nil or vRP.hasPermission(user_id,gcfg.permission)) then
            vRP.openMenu(source,menu)
          end
        end

        local function market_leave()
          vRP.closeMenu(source)
        end

        if gcfg.blipid ~= 0 then
          vRPclient.addBlip(source,{x,y,z,gcfg.blipid,gcfg.blipcolor,lang.market.title({gtype})})
        end
        vRPclient.addMarker(source,{x,y,z-0.97,0.7,0.7,0.5,0,255,125,125,150,23})

        vRP.setArea(source,"vRP:market"..k,x,y,z,1,1.5,market_enter,market_leave)
      end
    end
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then
    build_client_markets(source)
  end
end)
