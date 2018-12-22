-- CFG
local cfg = module("cfg/barbershop")
local config = module("cfg/base")
-- LANG
local Lang = module("lib/Lang")
local lang = Lang.new(module("cfg/lang/"..cfg.lang) or {})

-- open the skin shop for the specified ped parts
-- name = partid
function vRP.openBarbershop(source,parts)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then

    -- get old customization to compute the price
    vRP.getUData(user_id,"vRP:head:overlay"..vRP.getUserCharacter(user_id),function(value)
      local old_custom = json.decode(value)
      if old_custom == nil then
        --print("create overlay")
        old_custom = {
          ["-1"] = {255,0,0},
          ["0"] = {255,0,0},
          ["1"] = {255,1,0},
          ["2"] = {255,1,0},
          ["3"] = {255,0,0},
          ["4"] = {255,0,0},
          ["5"] = {255,2,0},
          ["6"] = {255,0,0},
          ["7"] = {255,0,0},
          ["8"] = {255,2,0},
          ["9"] = {255,0,0},
          ["10"] = {255,1,0},
          ["11"] = {255,0,0},
          ["12"] = {255,0,0}
        }
        vRPclient.setOverlay(source,{old_custom,false})
      end
      -- start building menu
      local menudata = {
        name=cfg.barbershops_title,
        css={top = "75px", header_color="rgba(0,255,125,0.75)"}
      }

      local drawables = {}
      local textures = {}

      local ontexture = function(player, choice)
        -- change texture
        textures[choice][1] = textures[choice][1]+1
        if textures[choice][1] >= textures[choice][2] then textures[choice][1] = 0 end -- circular selection

        -- apply change
        vRP.getUData(user_id,"vRP:head:overlay"..vRP.getUserCharacter(user_id),function(value_t)
          local custom = json.decode(value_t)
          vRPclient.missionText(source,{"Item Category: ~b~"..choice.."~n~~w~Item ID: ~b~"..drawables[choice][1].."~n~~w~Color ID: ~b~"..textures[choice][1],5000})
          --print(drawables[choice][1] .. " " .. custom[tostring(parts[choice])][2] .. " " .. textures[choice][1])
          custom[tostring(parts[choice])] = {drawables[choice][1],custom[tostring(parts[choice])][2],textures[choice][1]}
          vRPclient.setOverlay(player,{custom,false})
        end)
      end

      local ondrawable = function(player, choice, mod)
        if mod == 0 then -- tex variation
          ontexture(player,choice)
        else
          -- change drawable
          drawables[choice][1] = drawables[choice][1]+mod

        -- circular selection
        --print( drawables[choice][1] )
          if drawables[choice][1] == 256 then
            drawables[choice][1] = 0
          elseif drawables[choice][1] == 254 then
            drawables[choice][1] = drawables[choice][2]-1
          elseif drawables[choice][1] >= drawables[choice][2] then
            drawables[choice][1] = 255
          elseif drawables[choice][1] < 0 then
            drawables[choice][1] = 255
          end

          -- apply change
          vRP.getUData(user_id,"vRP:head:overlay"..vRP.getUserCharacter(user_id),function(value_d)
            local custom = json.decode(value_d)
            vRPclient.missionText(source,{"Item Category: ~b~"..choice.."~n~~w~Item ID: ~b~"..drawables[choice][1].."~n~~w~Color ID: ~b~"..textures[choice][1],5000})
            --print(drawables[choice][1] .. " " .. custom[tostring(parts[choice])][2] .. " " .. textures[choice][1])
            custom[tostring(parts[choice])] = {drawables[choice][1],custom[tostring(parts[choice])][2],textures[choice][1]}
            vRPclient.setOverlay(player,{custom,false})
          end)
        end
      end

      for k,v in pairs(parts) do -- for each part, get number of drawables and build menu

        drawables[k] = {0,0} -- {current,max}
        textures[k] = {0,0}  -- {current,max}

        -- init using old customization
        local old_part = old_custom[tostring(v)]
        if old_part then
          drawables[k][1] = old_part[1]
          textures[k][1] = old_part[3]
        end

         -- get max drawables
        vRPclient.getDrawablesBarber(source,{v},function(n)
          drawables[k][2] = n
        end)

         -- get max textures for this drawables
        vRPclient.getTextures(source,{v},function(n)
          textures[k][2] = n
        end)
         -- add menu choices
        menudata[k] = {ondrawable}
      end

      menudata.onclose = function(player)
        -- compute price
        vRP.getUData(user_id,"vRP:head:overlay"..vRP.getUserCharacter(user_id),function(value2)
          local new_custom = json.decode(value2)
          local price = 0
          if new_custom then
            for k,v in pairs(new_custom) do
              local old = old_custom[k]
              --print(v[1] .. " ~= " .. old[1])
              --print(v[3] .. " ~= " .. old[3])
              if v[1] ~= old[1] then price = price + cfg.drawable_change_price end -- change of drawable
              if v[3] ~= old[3] then price = price + cfg.texture_change_price end -- change of texture
            end
          end
          --print(price)
          if vRP.tryPayment(user_id,price) then
            if price > 0 then
              vRPclient.notify(player,{lang.money.paid({price})})
            end
          else
            vRPclient.notify(player,{lang.money.not_enough()})
            -- revert changes
            vRPclient.setOverlay(player,{old_custom,false}) --custom {id,ct,c1}
          end
        end)
      end

      -- open menu
      vRP.openMenu(source,menudata)
    end)
  end
end

local function build_client_barbershops(source)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    for k,v in pairs(cfg.barbershops) do
      local parts,x,y,z = table.unpack(v)

      local barbershop_enter = function(source)
        local user_id = vRP.getUserId(source)
        if user_id ~= nil then
          vRP.openBarbershop(source,parts)
        end
      end

      local function barbershop_leave(source)
        vRP.closeMenu(source)
      end

      vRPclient.addBlip(source,{x,y,z,71,13,cfg.barbershops_title})
      vRPclient.addMarker(source,{x,y,z-0.97,0.7,0.7,0.5,0,255,125,125,150,23})

      vRP.setArea(source,"vRP:barbershop"..k,x,y,z,1,1.5,barbershop_enter,barbershop_leave)
    end
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then
    build_client_barbershops(source)
    SetTimeout(config.load_duration*1000,function()
      local custom = {}
      vRP.getUData(user_id,"vRP:head:overlay"..vRP.getUserCharacter(user_id),function(value)
        if value ~= nil then
          custom = json.decode(value)
          vRPclient.setOverlay(source,{custom,true})
        end
      end)
    end)
  else
    SetTimeout(15000,function()
      local custom = {}
      vRP.getUData(user_id,"vRP:head:overlay"..vRP.getUserCharacter(user_id),function(value)
        if value ~= nil then
          custom = json.decode(value)
          vRPclient.setOverlay(source,{custom,true})
        end
      end)
    end)
  end
end)

RegisterServerEvent('vRP:cloakroom:update')
AddEventHandler('vRP:cloakroom:update', function(player)
  local user_id = vRP.getUserId(player)
  local player = vRP.getUserSource(user_id)
  SetTimeout(1000,function()
    local custom = {}
    vRP.getUData(user_id,"vRP:head:overlay"..vRP.getUserCharacter(user_id),function(value)
      if value ~= nil then
        custom = json.decode(value)
        vRPclient.setOverlay(player,{custom,true})
      end
    end)
  end)
end)

-- UPDATE
function tvRP.updateOverlay(value)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    vRP.setUData(user_id,"vRP:head:overlay"..vRP.getUserCharacter(user_id),json.encode(value))
  end
end

--[[ Disabled. Causing major lag in admin menu. To be investigated, but we dont really need this.
-- ADMIN BUTTON
local player_customs = {}

local ch_display_custom = {function(player, choice)
  local custom = tvRP.getOverlay(player) or {
    [0] = {255,0,0},
    [1] = {255,1,0},
    [2] = {255,1,0},
    [3] = {255,0,0},
    [4] = {255,0,0},
    [5] = {255,2,0},
    [6] = {255,0,0},
    [7] = {255,0,0},
    [8] = {255,2,0},
    [9] = {255,0,0},
    [10] = {255,1,0},
    [11] = {255,0,0},
    [12] = {255,0,0},
    [13] = {255,0,0}
  }
  if player_customs[player] then -- hide
    player_customs[player] = nil
    vRPclient.removeDiv(player,{"customization"})
  else -- show
    local content = ""
    for k,v in pairs(custom) do
      content = content..k.." => "..json.encode(v).."<br />"
    end
    player_customs[player] = true
    vRPclient.setDiv(player,{"customization",".div_customization{ margin: auto; padding: 8px; width: 500px; margin-top: 80px; background: black; color: white; font-weight: bold; ", content})
  end
end, "Shows head overlays."}

local ch_display_blend = {function(player, choice)
-- SetPedHeadBlendData(GetPlayerPed(-1),12,12,12,12,1,2,1.0,0.0,0.0,false) -- Face {12,1,2}
  vRPclient.getCustomization(player,{},function(custom)
    if player_customs[player] then -- hide
      player_customs[player] = nil
      vRPclient.removeDiv(player,{"customization"})
    else -- show
      local content = ""
      content = content.. "modelHash" .." => ".. custom.modelhash .."<br />"
      content = content.. "1" .." => "..json.encode(custom[2][1]).."<br />"
      content = content.. "2" .." => "..json.encode(custom[2][1]).."<br />"
      content = content.. "3" .." => "..json.encode(custom[2][1]).."<br />"
      content = content.. "4" .." => "..json.encode(custom[2][1]).."<br />"
      content = content.. "5" .." => "..json.encode(custom[2][2]).."<br />"
      content = content.. "6" .." => "..json.encode(custom[2][3]).."<br />"
      content = content.. "7" .." => ".. "1.0" .."<br />"
      content = content.. "8" .." => ".. "0.0" .."<br />"
      content = content.. "9" .." => ".. "0.0" .."<br />"
      content = content.. "10" .." => ".. "false" .."<br />"

      player_customs[player] = true
      vRPclient.setDiv(player,{"customization",".div_customization{ margin: auto; padding: 8px; width: 500px; margin-top: 80px; background: black; color: white; font-weight: bold; ", content})
    end
  end)
end, "Shows head blend data."}

vRP.registerMenuBuilder("admin", function(add, data)
  local user_id = vRP.getUserId({data.player})
  if user_id ~= nil then
    local choices = {}

    if vRP.hasPermission(user_id,"player.display_overlays") then
      choices["@Display overlays"] = ch_display_custom
      choices["@Display blend"] = ch_display_blend
    end

    add(choices)
  end
end)
]]----
