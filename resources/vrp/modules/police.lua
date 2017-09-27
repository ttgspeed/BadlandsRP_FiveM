
-- this module define some police tools and functions
local lang = vRP.lang
local cfg = module("cfg/police")
local cfg_inventory = module("cfg/inventory")
local Log = module("lib/Log")

-- police records

-- insert a police record for a specific user
--- line: text for one line (can be html)
function vRP.insertPoliceRecord(user_id, line)
  if user_id ~= nil then
    vRP.getUData(user_id, "vRP:police_records", function(data)
      local records = data..line.."<br />"
      vRP.setUData(user_id, "vRP:police_records", records)
    end)
  end
end

-- police PC

local menu_pc = {name=lang.police.pc.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

function tvRP.restrainPlayer(id)
  vRPclient.toggleHandcuff(id,{})
end

function tvRP.escortPlayer(id)
  vRPclient.toggleEscort(id,{source})
end

-- search identity by registration
local function ch_searchreg(player,choice)
  vRP.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
    vRP.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        vRP.getUserIdentity(user_id, function(identity)
          if identity then
            -- display identity and business
            local name = identity.name
            local firstname = identity.firstname
            local age = identity.age
            local phone = identity.phone
            local registration = identity.registration
            local bname = ""
            local bcapital = 0
            local home = ""
            local number = ""

            vRP.getUserBusiness(user_id, function(business)
              if business then
                bname = business.name
                bcapital = business.capital
              end

              vRP.getUserAddress(user_id, function(address)
                if address then
                  home = address.home
                  number = address.number
                end

                local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number})
                vRPclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
              end)
            end)
          else
            vRPclient.notify(player,{lang.common.not_found()})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

-- show police records by registration
local function ch_show_police_records(player,choice)
  vRP.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
    vRP.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        vRP.getUData(user_id, "vRP:police_records", function(content)
          vRPclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
        end)
      else
        vRPclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

-- delete police records by registration
local function ch_delete_police_records(player,choice)
  vRP.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
    vRP.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        vRP.setUData(user_id, "vRP:police_records", "")
        vRPclient.notify(player,{lang.police.pc.records.delete.deleted()})
      else
        vRPclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

-- close business of an arrested owner
local function ch_closebusiness(player,choice)
  vRPclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRP.getUserIdentity(nuser_id, function(identity)
        vRP.getUserBusiness(nuser_id, function(business)
          if identity and business then
            vRP.request(player,lang.police.pc.closebusiness.request({identity.name,identity.firstname,business.name}),15,function(player,ok)
              if ok then
                vRP.closeBusiness(nuser_id)
                vRPclient.notify(player,{lang.police.pc.closebusiness.closed()})
              end
            end)
          else
            vRPclient.notify(player,{lang.common.no_player_near()})
          end
        end)
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end

-- track vehicle
local function ch_trackveh(player,choice)
  vRP.prompt(player,lang.police.pc.trackveh.prompt_reg(),"",function(player, reg) -- ask reg
    vRP.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        vRP.prompt(player,lang.police.pc.trackveh.prompt_note(),"",function(player, note) -- ask note
          -- begin veh tracking
          vRPclient.notify(player,{lang.police.pc.trackveh.tracking()})
          local seconds = math.random(cfg.trackveh.min_time,cfg.trackveh.max_time)
          SetTimeout(seconds*1000,function()
            local tplayer = vRP.getUserSource(user_id)
            if tplayer ~= nil then
              vRPclient.getAnyOwnedVehiclePosition(tplayer,{},function(ok,x,y,z)
                if ok then -- track success
                  tvRP.sendServiceAlert(nil, cfg.trackveh.service,x,y,z,lang.police.pc.trackveh.tracked({reg,note}))
                else
                  vRPclient.notify(player,{lang.police.pc.trackveh.track_failed({reg,note})}) -- failed
                end
              end)
            else
              vRPclient.notify(player,{lang.police.pc.trackveh.track_failed({reg,note})}) -- failed
            end
          end)
        end)
      else
        vRPclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

menu_pc[lang.police.pc.searchreg.title()] = {ch_searchreg,lang.police.pc.searchreg.description()}
menu_pc[lang.police.pc.trackveh.title()] = {ch_trackveh,lang.police.pc.trackveh.description()}
menu_pc[lang.police.pc.records.show.title()] = {ch_show_police_records,lang.police.pc.records.show.description()}
menu_pc[lang.police.pc.records.delete.title()] = {ch_delete_police_records, lang.police.pc.records.delete.description()}
menu_pc[lang.police.pc.closebusiness.title()] = {ch_closebusiness,lang.police.pc.closebusiness.description()}

menu_pc.onclose = function(player) -- close pc gui
  vRPclient.removeDiv(player,{"police_pc"})
end

local function pc_enter(source,area)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil and vRP.hasPermission(user_id,"police.pc") then
    vRP.openMenu(source,menu_pc)
  end
end

local function pc_leave(source,area)
  vRP.closeMenu(source)
end

-- main menu choices

---- handcuff
local choice_handcuff = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    if nplayer ~= nil then
      vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)
        if handcuffed then
          vRPclient.setHandcuffed(nplayer,{false})
          vRPclient.notify(player,{"Player un-handcuffed"})
        else
          vRPclient.setHandcuffed(nplayer,{true})
          vRPclient.notify(player,{"Player handcuffed"})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.handcuff.description(),1}

local choice_handcuff_movement = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    if nplayer ~= nil then
      vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)
        if handcuffed then
          vRPclient.getAllowMovement(nplayer,{}, function(shackled)
            if shackled then
              vRPclient.setAllowMovement(nplayer,{false})
              vRPclient.notify(player,{"Handcuffed player movement allowed"})
            else
              vRPclient.setAllowMovement(nplayer,{true})
              vRPclient.notify(player,{"Handcuffed player movement restricted"})
            end
          end)
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,"Allow/Restrict movement of handcuffed player",14}

---- putinveh
--[[
-- veh at position version
local choice_putinveh = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          vRPclient.getNearestOwnedVehicle(player, {10}, function(ok,vtype,name) -- get nearest owned vehicle
            if ok then
              vRPclient.getOwnedVehiclePosition(player, {vtype}, function(x,y,z)
                vRPclient.putInVehiclePositionAsPassenger(nplayer,{x,y,z}) -- put player in vehicle
              end)
            else
              vRPclient.notify(player,{lang.vehicle.no_owned_near()})
            end
          end)
        else
          vRPclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.putinveh.description(),3}
--]]

local choice_putinveh = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          vRPclient.stopEscort(nplayer,{})
          vRPclient.putInNearestVehicleAsPassenger(nplayer, {5})
        else
          vRPclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.putinveh.description(),3}

local choice_getoutveh = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          vRPclient.ejectVehicle(nplayer, {})
        else
          vRPclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.getoutveh.description(),4}

local choice_impoundveh = {function(player,choice)
  vRPclient.impoundVehicle(player,{})
end,lang.police.menu.impoundveh.description(),15}

---- police check
local choice_check = {function(player,choice)
  vRPclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.notify(nplayer,{lang.police.menu.check.checked()})
      vRPclient.getWeapons(nplayer,{},function(weapons)
        -- prepare display data (money, items, weapons)
        local money = vRP.getMoney(nuser_id)
        local items = ""
        local data = vRP.getUserDataTable(nuser_id)
        if data and data.inventory then
          for k,v in pairs(data.inventory) do
            local item = vRP.items[k]
            if item then
              items = items.."<br />"..item.name.." ("..v.amount..")"
            end
          end
        end

        local weapons_info = ""
        for k,v in pairs(weapons) do
          weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
        end

        vRPclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
        -- request to hide div
        vRP.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
          vRPclient.removeDiv(player,{"police_check"})
        end)
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, lang.police.menu.check.description(),6}

local choice_check_vehicle = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    if nplayer ~= nil then
      vRPclient.getNearestOwnedVehicle(nplayer,{10},function(ok,vtype,name)
        if ok then
          vRP.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
            vRP.getUserByRegistration(reg, function(nuser_id)
              if nuser_id ~= nil then
                vRPclient.notify(nplayer,{"Your vehicle is being searched."})
                local chest = {}
                vRP.getSData("chest:u"..nuser_id.."veh_"..name,function(data)
                  chest.items = json.decode(data) or {}
                  local items = ""
                  for k,v in pairs(chest.items) do
                    local item = vRP.items[k]
                    if item then
                      items = items.."<br />"..item.name.." ("..v.amount..")"
                    end
                  end

                  vRPclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check_vehicle.info({items})})
                  -- request to hide div
                  vRP.request(player, lang.police.menu.check_vehicle.request_hide(), 1000, function(player,ok)
                    vRPclient.removeDiv(player,{"police_check"})
                  end)
                end)
              else
                vRPclient.notify(player,{"No information found."})
              end
            end)
          end)
        else
          vRPclient.notify(player,{"No player owned vehicle nearby."})
        end
      end)
    else
      vRPclient.notify(player,{"No player nearby."})
    end
  end)
end, "Search nearest player vehicle.",9}

local choice_seize_veh_items = {function(player, choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    if nplayer ~= nil then
      vRPclient.getNearestOwnedVehicle(nplayer,{10},function(ok,vtype,name)
        if ok then
          vRP.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
            vRP.getUserByRegistration(reg, function(nuser_id)
              if nuser_id ~= nil then
                vRP.setSData("chest:u"..nuser_id.."veh_"..name, json.encode({}))
                vRPclient.notify(player,{"Illegal items seized from vehicle."})
              else
                vRPclient.notify(player,{"No information found."})
              end
            end)
          end)
        else
          vRPclient.notify(player,{"No player owned vehicle nearby."})
        end
      end)
    else
      vRPclient.notify(player,{"No player nearby."})
    end
  end)
end, "Seize illegal items in player vehicles.",10}

---- askid
local choice_checkid = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.notify(nplayer,{"Police are checking your ID"})
      vRP.getUserIdentity(nuser_id, function(identity)
        if identity then
          -- display identity and business
          local name = identity.name
          local firstname = identity.firstname
          local age = identity.age
          local phone = identity.phone
          local registration = identity.registration
          local bname = ""
          local bcapital = 0
          local home = ""
          local number = ""

          vRP.getUserBusiness(nuser_id, function(business)
            if business then
              bname = business.name
              bcapital = business.capital
            end

            vRP.getUserAddress(nuser_id, function(address)
              if address then
                home = address.home
                number = address.number
              end

              local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number})
              vRPclient.setDiv(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
              -- request to hide div
              vRP.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
                vRPclient.removeDiv(player,{"police_identity"})
              end)
            end)
          end)
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, "Check the ID of the nearest player.",5}

local choice_seize_weapons = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil and vRP.hasPermission(nuser_id, "police.seizable") then
        vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            vRPclient.getWeapons(nplayer,{},function(weapons)
              for k,v in pairs(weapons) do -- display seized weapons
                -- vRPclient.notify(player,{lang.police.menu.seize.seized({k,v.ammo})})
                -- convert weapons to parametric weapon items
                vRP.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                if v.ammo > 0 then
                  vRP.giveInventoryItem(user_id, "wammo|"..k, v.ammo, true)
                end
              end

              -- clear all weapons
              vRPclient.giveWeapons(nplayer,{{},true})
              vRPclient.notify(nplayer,{lang.police.menu.seize.weapons.seized()})
            end)
          else
            vRPclient.notify(player,{lang.police.not_handcuffed()})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.seize.weapons.description(),7}

local choice_seize_items = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil and vRP.hasPermission(nuser_id, "police.seizable") then
        vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            for k,v in pairs(cfg.seizable_items) do -- transfer seizable items
              local amount = vRP.getInventoryItemAmount(nuser_id,v)
              if amount > 0 then
                local item = vRP.items[v]
                if item then -- do transfer
                  if vRP.tryGetInventoryItem(nuser_id,v,amount,true) then
                    vRP.giveInventoryItem(user_id,v,amount,false)
                    vRPclient.notify(player,{lang.police.menu.seize.seized({item.name,amount})})
                  end
                end
              end
            end

            vRPclient.notify(nplayer,{lang.police.menu.seize.items.seized()})
          else
            vRPclient.notify(player,{lang.police.not_handcuffed()})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.seize.items.description(),8}

-- toggle jail nearest player
local choice_jail = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil then
        vRPclient.isJailed(nplayer, {}, function(jailed)
          if jailed then -- unjail
            vRPclient.unjail(nplayer, {})
            vRPclient.notify(nplayer,{lang.police.menu.jail.notify_unjailed()})
            vRPclient.notify(player,{lang.police.menu.jail.unjailed()})
          else -- find the nearest jail
            vRPclient.getPosition(nplayer,{},function(x,y,z)
              local d_min = 1000
              local v_min = nil
              for k,v in pairs(cfg.jails) do
                local dx,dy,dz = x-v[1],y-v[2],z-v[3]
                local dist = math.sqrt(dx*dx+dy*dy+dz*dz)

                if dist <= d_min and dist <= 15 then -- limit the research to 15 meters
                  d_min = dist
                  v_min = v
                end

                -- jail
                if v_min then
                  vRPclient.jail(nplayer,{v_min[1],v_min[2],v_min[3],v_min[4]})
                  vRPclient.notify(nplayer,{lang.police.menu.jail.notify_jailed()})
                  vRPclient.notify(player,{lang.police.menu.jail.jailed()})
                else
                  vRPclient.notify(player,{lang.police.menu.jail.not_found()})
                end
              end
            end)
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.jail.description(),11}

local choice_prison = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil then
        vRPclient.isInPrison(nplayer, {}, function(inprison)
          if inprison then -- release from prison
            vRPclient.unprison(nplayer, {})
            vRPclient.notify(nplayer,{lang.police.menu.prison.notify_unprison()})
            vRPclient.notify(player,{lang.police.menu.prison.released()})
          else -- send to priton
            vRP.prompt(player,lang.police.menu.prison.prompt({choice}),"",function(player,amount)
              local amount = parseInt(amount)
              if amount > 0 then
                if amount > cfg.max_prison_time then
                  amount = cfg.max_prison_time
                end
                vRPclient.isJailed(nplayer, {}, function(jailed)
                  vRPclient.getPosition(nplayer,{},function(x,y,z)
                    local d_min = 1000
                    local v_min = false
                    local dx,dy,dz = x-1848.9006347656,y-2585.685546875,z-45.672023773193
                    local dist = math.sqrt(dx*dx+dy*dy+dz*dz)

                    if dist <= d_min and dist <= 15 then -- limit the research to 15 meters
                      d_min = dist
                      v_min = true
                    end

                    -- jail
                    if v_min then
                      vRPclient.prison(nplayer,{amount})
                      vRP.setUData(nuser_id, "vRP:prison_time", amount)
                      vRPclient.notify(nplayer,{lang.police.menu.prison.notify_prison()})
                      vRPclient.notify(player,{lang.police.menu.prison.imprisoned()})
                    else
                      if jailed then
                        vRPclient.prison(nplayer,{amount})
                        vRP.setUData(nuser_id, "vRP:prison_time", amount)
                        vRPclient.notify(nplayer,{lang.police.menu.prison.notify_prison()})
                        vRPclient.notify(player,{lang.police.menu.prison.imprisoned()})
                      end
                    end
                  end)
                end)
              else
                vRPclient.notify(player,{"Invalid time value entered"})
              end
            end)
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.prison.description(),12}

-- toggle escort nearest player
local choice_escort = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil then
        vRPclient.toggleEscort(nplayer,{player})
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.escort.description(),2}

local choice_fine = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil then
        -- prompt number
        vRP.prompt(player,lang.police.menu.fine.prompt_amount(),"",function(player,amount)
          local amount = parseInt(amount)
          if amount > cfg.max_fine_amount then
            vRPclient.notify(player,{"Max fine amount is $"..cfg.max_fine_amount})
          elseif amount ~= nil and amount > 0 then
            vRP.request(nplayer,lang.police.menu.fine.prompt_pay({amount}),15,function(nplayer,ok)
              if ok then
                if vRP.tryFullPayment(nuser_id, amount) then
                  --vRP.insertPoliceRecord(nuser_id, lang.police.menu.fine.record({choice,amount}))
                  vRPclient.notify(player,{lang.police.menu.fine.fined({amount})})
                  vRPclient.notify(nplayer,{lang.police.menu.fine.notify_fined({amount})})
                  vRP.closeMenu(player)
                else
                  vRPclient.notify(player,{lang.money.not_enough()})
                end
              else
                vRPclient.notify(player,{"Player declined to pay ticket."})
              end
            end)
          else
            vRPclient.notify(player,{"Invalid fine amount"})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.fine.description(),13}

local choice_store_weapons = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getWeapons(player,{},function(weapons)
      for k,v in pairs(weapons) do
        -- convert weapons to parametric weapon items
        vRP.giveInventoryItem(user_id, "wbody|"..k, 1, true)
        if v.ammo > 0 then
          vRP.giveInventoryItem(user_id, "wammo|"..k, v.ammo, true)
        end
      end

      -- clear all weapons
      vRPclient.giveWeapons(player,{{},true})
    end)
  end
end, lang.police.menu.store_weapons.description()}

-- search trunk (cop action)
local choice_search_trunk = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.getNearestOwnedVehicle(nplayer,{7},function(ok,vtype,name)
        if ok then
          local chestname = "u"..nuser_id.."veh_"..string.lower(name)
          local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight

          -- open chest
          local cb_out = function(idname,amount)
            vRPclient.notify(nplayer,{lang.inventory.give.given({vRP.getItemName(idname),amount})})
          end

          local cb_in = function(idname,amount)
            vRPclient.notify(nplayer,{lang.inventory.give.received({vRP.getItemName(idname),amount})})
          end

          vRPclient.vc_openDoor(nplayer, {name,5})
          vRP.openChest(player, chestname, max_weight, function()
            vRPclient.vc_closeDoor(nplayer, {name,5})
          end,cb_in,cb_out)
        else
          vRPclient.notify(player,{lang.vehicle.no_owned_near()})
          vRPclient.notify(nplayer,{lang.vehicle.no_owned_near()})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.search_trunk.description()}

-- search trunk (cop action)
local choice_seize_vehicle = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.getNearestOwnedVehicle(nplayer,{7},function(ok,vtype,name)
        if ok then
          vRPclient.notify(player,{"Vehicle seize process started. Walk away to cancel."})
          vRPclient.impoundVehicle(player,{})
          SetTimeout(5 * 1000, function()
            vRPclient.notify(nplayer,{"Your vehicle has been seized by the police."})
            MySQL.Async.execute('DELETE FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle', {user_id = nuser_id, vehicle = name}, function(rowsChanged) end)
            Log.write(user_id, " seized "..name.." from ".. nuser_id, Log.log_type.action)
            
          end)
        else
          vRPclient.notify(player,{lang.vehicle.no_owned_near()})
          vRPclient.notify(nplayer,{lang.vehicle.no_owned_near()})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.seize_vehicle.description()}

-- add choices to the menu
vRP.registerMenuBuilder("main", function(add, data)
  local player = data.player

  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    local choices = {}

    if vRP.hasPermission(user_id,"police.service") then
      -- build police menu
      choices[lang.police.title()] = {function(player,choice)
        vRP.buildMenu("police", {player = player}, function(menu)
          menu.name = lang.police.title()
          menu.css = {top="75px",header_color="rgba(0,125,255,0.75)"}

          if vRP.hasPermission(user_id,"police.handcuff") then
            menu[lang.police.menu.handcuff.title()] = choice_handcuff
          end
          if vRP.hasPermission(user_id,"police.escort") then
            menu[lang.police.menu.escort.title()] = choice_escort
          end
          if vRP.hasPermission(user_id,"police.putinveh") then
            menu[lang.police.menu.putinveh.title()] = choice_putinveh
          end
          if vRP.hasPermission(user_id,"police.getoutveh") then
            menu[lang.police.menu.getoutveh.title()] = choice_getoutveh
          end
          if vRP.hasPermission(user_id,"police.check") then
            menu["Check ID"] = choice_checkid
          end
          if vRP.hasPermission(user_id,"police.check") then
            menu[lang.police.menu.check.title()] = choice_check
          end
          if vRP.hasPermission(user_id,"police.seize.weapons") then
            menu[lang.police.menu.seize.weapons.title()] = choice_seize_weapons
          end
          if vRP.hasPermission(user_id,"police.seize.items") then
            menu[lang.police.menu.seize.items.title()] = choice_seize_items
          end
          if vRP.hasPermission(user_id,"police.check") then
            menu[lang.police.menu.check_vehicle.title()] = choice_check_vehicle
          end
          if vRP.hasPermission(user_id,"police.seize.items") then
            menu["Seize Vehicle Illegal"] = choice_seize_veh_items
          end
          if vRP.hasPermission(user_id,"police.jail") then
            menu[lang.police.menu.jail.title()] = choice_jail
          end
          if vRP.hasPermission(user_id,"police.jail") then
            menu["Send to prison"] = choice_prison
          end
          if vRP.hasPermission(user_id,"police.fine") then
            menu[lang.police.menu.fine.title()] = choice_fine
          end
          if vRP.hasPermission(user_id,"police.handcuff") then
            menu["Toggle Handcuff Movement"] = choice_handcuff_movement
          end
          if vRP.hasPermission(user_id,"police.pulloutveh") then
            menu[lang.police.menu.impoundveh.title()] = choice_impoundveh
          end
          if vRP.hasPermission(user_id,"police.searchtrunk") then
            menu[lang.police.menu.search_trunk.title()] = choice_search_trunk
          end
          if vRP.hasPermission(user_id,"police.seize_vehicle") then
            menu[lang.police.menu.seize_vehicle.title()] = choice_seize_vehicle
          end

          --if vRP.hasPermission(user_id, "police.store_weapons") then
          --  menu[lang.police.menu.store_weapons.title()] = choice_store_weapons
          --end

          vRP.openMenu(player,menu)
        end)
      end,"Police Menu",2}
    end

    add(choices)
  end
end)

local function build_client_points(source)
  -- PC
  for k,v in pairs(cfg.pcs) do
    local x,y,z = table.unpack(v)
    vRPclient.addMarker(source,{x,y,z-1,0.7,0.7,0.5,0,125,255,125,150})
    vRP.setArea(source,"vRP:police:pc"..k,x,y,z,1,1.5,pc_enter,pc_leave)
  end
end

-- build police points
AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then
    build_client_points(source)
  end
end)

-- WANTED SYNC

local wantedlvl_players = {}

function vRP.getUserWantedLevel(user_id)
  return wantedlvl_players[user_id] or 0
end

-- receive wanted level
function tvRP.updateWantedLevel(level)
  local player = source
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    local was_wanted = (vRP.getUserWantedLevel(user_id) > 0)
    wantedlvl_players[user_id] = level
    local is_wanted = (level > 0)

    -- send wanted to listening service
    if not was_wanted and is_wanted then
      vRPclient.getPosition(player, {}, function(x,y,z)
        tvRP.sendServiceAlert(nil, cfg.wanted.service,x,y,z,lang.police.wanted({level}))
      end)
    end

    if was_wanted and not is_wanted then
      vRPclient.removeNamedBlip(-1, {"vRP:wanted:"..user_id}) -- remove wanted blip (all to prevent phantom blip)
    end
  end
end

-- delete wanted entry on leave
AddEventHandler("vRP:playerLeave", function(user_id, player)
  wantedlvl_players[user_id] = nil
  vRPclient.removeNamedBlip(-1, {"vRP:wanted:"..user_id})  -- remove wanted blip (all to prevent phantom blip)
  vRPclient.removeNamedBlip(-1, {"vRP:officer:"..user_id})  -- remove cop blip (all to prevent phantom blip)
  vRPclient.removeNamedBlip(-1, {"vRP:medic:"..user_id})  -- remove medic blip (all to prevent phantom blip)
end)

AddEventHandler("vRP:playerLeaveGroup", function(user_id, player)
  vRPclient.removeNamedBlip(-1, {"vRP:officer:"..user_id})  -- remove cop blip (all to prevent phantom blip)
  vRPclient.removeNamedBlip(-1, {"vRP:medic:"..user_id})  -- remove medic blip (all to prevent phantom blip)
end)

-- display wanted positions
local function task_wanted_positions()
  local listeners = vRP.getUsersByPermission("police.wanted")
  for k,v in pairs(wantedlvl_players) do -- each wanted player
    local player = vRP.getUserSource(tonumber(k))
    if player ~= nil and v ~= nil and v > 0 then
      vRPclient.getPosition(player, {}, function(x,y,z)
        for l,w in pairs(listeners) do -- each listening player
          local lplayer = vRP.getUserSource(w)
          if lplayer ~= nil then
            vRPclient.setNamedBlip(lplayer, {"vRP:wanted:"..k,x,y,z,cfg.wanted.blipid,cfg.wanted.blipcolor,lang.police.wanted({v})})
          end
        end
      end)
    end
  end

  SetTimeout(5000, task_wanted_positions)
end
task_wanted_positions()

local function task_police_ems_positions()
  local listeners = vRP.getUsersByPermission("safety.mapmarkers")
  local police_list = vRP.getUsersByPermission("police.mapmarkers")
  local ems_list = vRP.getUsersByPermission("emergency.mapmarkers")
  for k,v in pairs(police_list) do -- each police player
    local player = vRP.getUserSource(v)
    if player ~= nil and v ~= nil and v > 0 then
      vRPclient.getPosition(player, {}, function(x,y,z)
        for l,w in pairs(police_list) do -- each listening player
          local lplayer = vRP.getUserSource(w)
          if lplayer ~= nil and lplayer ~= player then
            vRPclient.setNamedBlip(lplayer, {"vRP:officer:"..v,x,y,z,1,cfg.wanted.blipcolor,GetPlayerName(player)})
          end
        end
      end)
    end
  end
  for k2,v2 in pairs(ems_list) do -- each ems player
    local player = vRP.getUserSource(v2)
    if player ~= nil and v2 ~= nil and v2 > 0 then
      vRPclient.getPosition(player, {}, function(x,y,z)
        for l2,w2 in pairs(listeners) do -- each listening player
          local lplayer = vRP.getUserSource(w2)
          if lplayer ~= nil and lplayer ~= player then
            vRPclient.setNamedBlip(lplayer, {"vRP:medic:"..v2,x,y,z,1,1,GetPlayerName(player)})
          end
        end
      end)
    end
  end

  SetTimeout(5000, task_police_ems_positions)
end
task_police_ems_positions()

function tvRP.updatePrisonTime(time)
  local user_id = vRP.getUserId(source)
  vRP.setUData(user_id, "vRP:prison_time", time)
end

