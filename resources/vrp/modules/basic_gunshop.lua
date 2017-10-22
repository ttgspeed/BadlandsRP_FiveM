-- a basic gunshop implementation

local cfg = module("cfg/gunshops")
local Log = module("lib/Log")
local lang = vRP.lang

local gunshops = cfg.gunshops
local gunshop_types = cfg.gunshop_types

local gunshop_menus = {}

-- build gunshop menus
for gtype,weapons in pairs(gunshop_types) do
  local gunshop_menu = {
    name=lang.gunshop.title({gtype}),
    css={top = "75px", header_color="rgba(255,0,0,0.75)"}
  }

  -- build gunshop items
  local kitems = {}

  -- item choice
  local gunshop_choice = function(player,choice)
    local weapon = kitems[choice][1]
    local price = kitems[choice][2]
    local price_ammo = kitems[choice][3]

    if weapon and weapon ~= "police_vest" then
      -- get player weapons to not rebuy the body
      vRPclient.getWeapons(player,{},function(weapons)
        -- prompt amount
        vRP.prompt(player,lang.gunshop.prompt_ammo({choice}),"",function(player,amount)
          local amount = parseInt(amount)
          if amount >= 0 then
            local user_id = vRP.getUserId(player)
            local total = math.ceil(parseFloat(price_ammo)*parseFloat(amount))
            local purchaseType = "Ammo Only"

            if weapons[string.upper(weapon)] == nil then -- add body price if not already owned
              total = total+price
              purchaseType = "Weapon and Ammo"
            end

            -- payment
            if user_id ~= nil and vRP.tryPayment(user_id,total) then
              vRPclient.giveWeapons(player,{{
                [weapon] = {ammo=amount}
              }})

              vRPclient.notify(player,{lang.money.paid({total})})
              Log.write(user_id, "Purchased "..purchaseType..". Item: "..weapon.." for $"..price,Log.log_type.purchase)
            else
              vRPclient.notify(player,{lang.money.not_enough()})
            end
          else
            vRPclient.notify(player,{lang.common.invalid_value()})
          end
        end)
      end)
    elseif weapon == "police_vest" then
      -- payment
      local user_id = vRP.getUserId(player)
      if user_id ~= nil and vRP.tryPayment(user_id,price) then
        vRPclient.setArmour(player,{100})

        vRPclient.notify(player,{lang.money.paid({price})})
        Log.write(user_id, "Purchased police body armor for $"..price,Log.log_type.purchase)
      else
        vRPclient.notify(player,{lang.money.not_enough()})
      end
    end
  end

  -- add item options
  for k,v in pairs(weapons) do
    if k ~= "_config" then -- ignore config property
      kitems[v[1]] = {k,math.max(v[2],0),math.max(v[3],0)} -- idname/price/price_ammo
      gunshop_menu[v[1]] = {gunshop_choice,lang.gunshop.info({v[2],v[3],v[4]}),v[5]} -- add description
    end
  end

  gunshop_menus[gtype] = gunshop_menu
end

local function build_client_gunshops(source)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    for k,v in pairs(gunshops) do
      local gtype,x,y,z = table.unpack(v)
      local group = gunshop_types[gtype]
      local menu = gunshop_menus[gtype]

      if group and menu then
        local gcfg = group._config

        local function gunshop_enter()
          local user_id = vRP.getUserId(source)
          if user_id ~= nil and (gcfg.permission == nil or vRP.hasPermission(user_id,gcfg.permission)) then
            vRP.openMenu(source,menu)
          end
        end

        local function gunshop_leave()
          vRP.closeMenu(source)
        end

        if gcfg.blipid ~= 0 then
          vRPclient.addBlip(source,{x,y,z,gcfg.blipid,gcfg.blipcolor,lang.gunshop.title({gtype})})
        end
        vRPclient.addMarker(source,{x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})

        vRP.setArea(source,"vRP:gunshop"..k,x,y,z,1,1.5,gunshop_enter,gunshop_leave)
      end
    end
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then
    build_client_gunshops(source)
  end
end)
