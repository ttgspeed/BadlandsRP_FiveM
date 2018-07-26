
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
            local firearmlicense = identity.firearmlicense
            local driverlicense = identity.driverlicense
            local pilotlicense = identity.pilotlicense
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

                local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number,firearmlicense,driverlicense,pilotlicense})
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

local function ch_searchphone(player,choice)
  vRP.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, phoneNumber)
    vRP.getUserByPhone(phoneNumber, function(user_id)
      if user_id ~= nil then
        vRP.getUserIdentity(user_id, function(identity)
          if identity then
            -- display identity and business
            local name = identity.name
            local firstname = identity.firstname
            local age = identity.age
            local phone = identity.phone
            local registration = identity.registration
            local firearmlicense = identity.firearmlicense
            local driverlicense = identity.driverlicense
            local pilotlicense = identity.pilotlicense
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

                local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number,firearmlicense,driverlicense,pilotlicense})
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

menu_pc["Registration Search"] = {ch_searchreg,lang.police.pc.searchreg.description(),1}
menu_pc["Search By Phone"] = {ch_searchphone,"Search phone number owner",2}
menu_pc["Track Vehicle"] = {ch_trackveh,lang.police.pc.trackveh.description(),3 }
--menu_pc[lang.police.pc.records.show.title()] = {ch_show_police_records,lang.police.pc.records.show.description()}
--menu_pc[lang.police.pc.records.delete.title()] = {ch_delete_police_records, lang.police.pc.records.delete.description()}
--menu_pc[lang.police.pc.closebusiness.title()] = {ch_closebusiness,lang.police.pc.closebusiness.description()}

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

local choice_putinveh = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          vRPclient.stopEscort(nplayer,{})
          vRPclient.putInNearestVehicleAsPassengerBeta(nplayer, {5})
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

local choice_spikestrip = {function(player,choice)
  vRPclient.setSpikesOnGround(player,{})
end,"Deploy/Retract Spikestrip",14}

local choice_weapon_store = {function(player, choice)
  local emenu = {name="Storage",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
  emenu["Store/Get Shotgun"] = {function(player, choice)
    vRPclient.getNearestOwnedVehicle(player,{5},function(ok,vtype,name)
      if ok then
        vRPclient.storeCopWeapon(player,{"WEAPON_PUMPSHOTGUN"})
      end
    end)
  end, lang.police.menu.store_weapons.description(),1}

  emenu["Store/Get SMG"] = {function(player, choice)
    vRPclient.getNearestOwnedVehicle(player,{5},function(ok,vtype,name)
      if ok then
        vRPclient.storeCopWeapon(player,{"WEAPON_SMG"})
      end
    end)
  end, lang.police.menu.store_weapons.description(),2}

  -- open mnu
  vRP.openMenu(player, emenu)
end, lang.police.menu.store_weapons.description(),17}

--------- Player Actions Menu
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
end,"Allow/Restrict movement of handcuffed player",17}

-- police check
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
-- askid
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
          local firearmlicense = identity.firearmlicense
          local driverlicense = identity.driverlicense
          local pilotlicense = identity.pilotlicense
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

              local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number,firearmlicense,driverlicense,pilotlicense})
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
              local seizedItems = " "
              for k,v in pairs(weapons) do -- display seized weapons
                -- vRPclient.notify(player,{lang.police.menu.seize.seized({k,v.ammo})})
                -- convert weapons to parametric weapon items
                vRP.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                seizedItems = seizedItems.." wbody|"..k.." Qty: 1,"
                if v.ammo > 0 then
                  vRP.giveInventoryItem(user_id, "wammo|"..k, v.ammo, true)
                  seizedItems = seizedItems.." wammo|"..k.." Qty: "..v.ammo..","
                end
              end

              -- clear all weapons
              vRPclient.giveWeapons(nplayer,{{},true})
              vRPclient.notify(nplayer,{lang.police.menu.seize.weapons.seized()})
              Log.write(user_id, "Seize weapons from "..nuser_id..". "..seizedItems, Log.log_type.action)
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
                    Log.write(user_id, "Seize "..amount.." "..item.name.." from "..nuser_id, Log.log_type.action)
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
                vRP.prompt(player,"Enter the prison fine amount","0",function(player,fine)
                  local fine = parseInt(fine)
                  if fine > cfg.max_prisonFine_amount then
                    fine = cfg.max_prisonFine_amount
                  end
                  local content = lang.police.prison.info({amount,fine})
                  vRPclient.setDiv(player,{"police_prison",".div_police_prison{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
                  -- request to hide div
                  vRP.request(player, "Send to prison?", 1000, function(player,ok)
                    vRPclient.removeDiv(player,{"police_prison"})
                    if ok then
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
                            vRP.prisonFinancialPenalty(nuser_id,fine)
                            vRP.setUData(nuser_id, "vRP:prison_time", amount)
                            vRPclient.notify(nplayer,{lang.police.menu.prison.notify_prison()})
                            if fine > 0 then
                              vRPclient.notify(nplayer,{"You were fined $"..fine.." along with your prison sentence"})
                            end
                            vRPclient.notify(player,{lang.police.menu.prison.imprisoned()})
                            Log.write(user_id, "Sent "..nuser_id.." to prison for "..amount.." minutes and paid fine of $"..fine, Log.log_type.action)
                          else
                            if jailed then
                              vRPclient.prison(nplayer,{amount})
                              vRP.prisonFinancialPenalty(nuser_id,fine)
                              vRP.setUData(nuser_id, "vRP:prison_time", amount)
                              vRPclient.notify(nplayer,{lang.police.menu.prison.notify_prison()})
                              vRPclient.notify(player,{lang.police.menu.prison.imprisoned()})
                              Log.write(user_id, "Sent "..nuser_id.." to prison for "..amount.." minutes and paid fine of $"..fine, Log.log_type.action)
                            end
                          end
                        end)
                      end)
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

-- seize driver license
local choice_seize_driverlicense = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil then
        vRP.request(player,"Are you sure you want to revoke "..nuser_id.."'s Driver License?",15,function(player,ok)
          if ok then
            MySQL.Async.execute('UPDATE vrp_user_identities SET driverlicense = 0 WHERE user_id = @user_id AND driverlicense = 1', {user_id = nuser_id}, function(rowsChanged)
              if (rowsChanged > 0) then
                Log.write(user_id, "Revoked "..nuser_id.."'s Driver License", Log.log_type.action)
              end
            end)
            vRPclient.notify(player,{"You have revoked "..nuser_id.."'s Driver License."})
            vRPclient.notify(nplayer,{"Your Driver License has been revoked."})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.seize_driverlicense.description(),14}

-- seize firearm license
local choice_seize_firearmlicense = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil then
        vRP.request(player,"Are you sure you want to revoke "..nuser_id.."'s Firearm License?",15,function(player,ok)
          if ok then
            MySQL.Async.execute('UPDATE vrp_user_identities SET firearmlicense = 0 WHERE user_id = @user_id AND firearmlicense = 1', {user_id = nuser_id}, function(rowsChanged)
              if (rowsChanged > 0) then
                Log.write(user_id, "Revoked "..nuser_id.."'s Firearm License", Log.log_type.action)
              end
            end)
            vRPclient.notify(player,{"You have revoked "..nuser_id.."'s Firearm License."})
            vRPclient.notify(nplayer,{"Your Firearm License has been revoked."})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.seize_firearmlicense.description(),15}

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
                  Log.write(user_id, "Fined "..nuser_id.." $"..amount..". "..nuser_id.." payed full amount", Log.log_type.action)
                else
                  vRPclient.notify(player,{lang.money.not_enough()})
                  Log.write(user_id, "Fined "..nuser_id.." $"..amount..". "..nuser_id.." did not have enough to pay", Log.log_type.action)
                end
              else
                vRPclient.notify(player,{"Player declined to pay ticket."})
                Log.write(user_id, "Fined "..nuser_id.." $"..amount..". "..nuser_id.." declined to pay", Log.log_type.action)
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

local choice_gsr_test = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    if vRP.tryGetInventoryItem(user_id,"gsr_kit",1,true) then
      vRPclient.getNearestPlayer(player, {5}, function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
          vRPclient.getGunFired(nplayer,{}, function(gsrPositive)
            if gsrPositive then
              vRPclient.notify(player,{"GSR Test Result: <b>POSITIVE</b>"})
            else
              vRPclient.notify(player,{"GSR Test Result: <b>NEGATIVE</b>"})
            end
          end)
        end
      end)
    else
      vRPclient.notify(player,{"You don't have a GSR Test Kit"})
    end
  end
end, "Use a GSR Test Kit to test for gunshot residue",16}

--------- Vehicle Actions Menu
local choice_check_vehicle = {function(player,choice)
  vRPclient.getNearestOwnedVehiclePlate(player,{10},function(ok,vtype,name,plate)
    if ok then
      if string.lower(name) == "khamel" then
        name = "khamelion"
      end
      vRP.getUserByRegistration(plate, function(nuser_id)
        if nuser_id ~= nil then
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
            vRPclient.vc_openDoor(player, {name,5})
            -- request to hide div
            vRP.request(player, lang.police.menu.check_vehicle.request_hide(), 1000, function(player,ok)
              vRPclient.removeDiv(player,{"police_check"})
              vRPclient.vc_closeDoor(player, {name,5})
            end)
          end)
        else
          vRPclient.notify(player,{"No information found."})
        end
      end)
    else
      vRPclient.notify(player,{"No player owned vehicle nearby."})
    end
  end)
end, "Search nearest player vehicle.",9}

local choice_seize_veh_items = {function(player, choice)
  vRPclient.getNearestOwnedVehiclePlate(player,{10},function(ok,vtype,name,plate)
    if ok then
      if string.lower(name) == "khamel" then
        name = "khamelion"
      end
      vRP.getUserByRegistration(plate, function(nuser_id)
        if nuser_id ~= nil then
          vRP.request(player,"Are you sure you want to seize the vehicles trunk contents?",15,function(player,ok)
            if ok then
              vRP.setSData("chest:u"..nuser_id.."veh_"..name, json.encode({}))
              vRPclient.notify(player,{"Illegal items seized from vehicle."})
              Log.write(user_id, "Seize vehicle inventory. Trunk = chest:u"..nuser_id.."veh_"..name, Log.log_type.action)
            end
          end)
        else
          vRPclient.notify(player,{"No information found."})
        end
      end)
    else
      vRPclient.notify(player,{"No player owned vehicle nearby."})
    end
  end)
end, "Seize illegal items in player vehicles.",10}

-- Seize vehicle
local choice_seize_vehicle = {function(player,choice)
  local puser_id = vRP.getUserId(player)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.getNearestOwnedVehicle(nplayer,{7},function(ok,vtype,name)
        if ok then
          vRP.request(player,"Are you sure you want this vehicle?",15,function(player,ok)
            if ok then
              vRPclient.notify(player,{"Vehicle seize process started. Walk away to cancel."})
              vRPclient.impoundVehicle(player,{})
              SetTimeout(10 * 1000, function()
                vRPclient.notify(nplayer,{"Your vehicle has been seized by the police."})
                MySQL.Async.execute('DELETE FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle', {user_id = nuser_id, vehicle = name}, function(rowsChanged) end)
                Log.write(puser_id, " seized "..name.." from ".. nuser_id, Log.log_type.action)
                vRP.setSData("chest:u"..nuser_id.."veh_"..name, json.encode({}))
                MySQL.Async.execute('DELETE FROM vrp_srv_data WHERE dkey = @dkey', {dkey = "chest:u"..nuser_id.."veh_"..name}, function(rowsChanged) end)
              end)
            end
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
end,lang.police.menu.seize_vehicle.description(),16}

local choice_impoundveh = {function(player,choice)
  vRP.request(player, "Impound vehicle?", 15, function(player,ok)
      if ok then
        vRPclient.impoundVehicle(player,{})
      end
  end)
end,lang.police.menu.impoundveh.description(),29}

local choice_repair_weapons = {function(player, choice)
  vRPclient.getNearestOwnedVehiclePlate(player,{10},function(ok,vtype,name,plate)
    if ok then
      vRPclient.setFiringPinState(player,{true})
    else
      vRPclient.notify(player,{"No player owned vehicle nearby."})
    end
  end)
end, "Repair your items.",28}
------------------------------------------------------------

local choice_player_actions = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    local emenu = {name="Player Action",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
    if vRP.hasPermission(user_id,"police.check") then
      emenu["Check ID"] = choice_checkid
      emenu[lang.police.menu.check.title()] = choice_check
      emenu["GSR Test"] = choice_gsr_test
    end
    if vRP.hasPermission(user_id,"police.seize.weapons") then
      emenu[lang.police.menu.seize.weapons.title()] = choice_seize_weapons
    end
    if vRP.hasPermission(user_id,"police.seize.items") then
      emenu[lang.police.menu.seize.items.title()] = choice_seize_items
    end
    if vRP.hasPermission(user_id,"police.jail") then
      emenu[lang.police.menu.jail.title()] = choice_jail
      emenu["Send to prison"] = choice_prison
    end
    if vRP.hasPermission(user_id,"police.fine") then
      emenu[lang.police.menu.fine.title()] = choice_fine
    end
    if vRP.hasPermission(user_id,"police.handcuff") then
      emenu["Toggle Handcuff Movement"] = choice_handcuff_movement
    end
    if vRP.hasPermission(user_id,"police.seize_driverlicense") then
      emenu[lang.police.menu.seize_driverlicense.title()] = choice_seize_driverlicense
    end
    if vRP.hasPermission(user_id,"police.seize_firearmlicense") then
      emenu[lang.police.menu.seize_firearmlicense.title()] = choice_seize_firearmlicense
    end

    -- open mnu
    vRP.openMenu(player, emenu)
  end
end, "Action for players",30}

local choice_vehicle_actions = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    local emenu = {name="Vehicle Action",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
    if vRP.hasPermission(user_id,"police.check") then
      emenu[lang.police.menu.check_vehicle.title()] = choice_check_vehicle
    end
    if vRP.hasPermission(user_id,"police.seize.items") then
      emenu["Seize Vehicle Illegal"] = choice_seize_veh_items
    end
    if vRP.hasPermission(user_id,"police.pulloutveh") then
      emenu[lang.police.menu.impoundveh.title()] = choice_impoundveh
      emenu["Repair Items"] = choice_repair_weapons
    end
    if vRP.hasPermission(user_id,"police.seize_vehicle") then
      emenu[lang.police.menu.seize_vehicle.title()] = choice_seize_vehicle
    end

    -- open mnu
    vRP.openMenu(player, emenu)
  end
end, "Action for vehicles",31}

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
          if vRP.hasPermission(user_id,"police.spikestrip") then
            menu["Deploy/Pack Spikestrip"] = choice_spikestrip
          end
          if vRP.hasPermission(user_id, "police.store_vehWeapons") then
            menu["Weapon Storage"] = choice_weapon_store
          end
          menu["Player Action Menu"] = choice_player_actions
          menu["Vehicle Action Menu"] = choice_vehicle_actions

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
    vRPclient.addMarker(source,{x,y,z-0.97,0.7,0.7,0.5,0,125,255,125,150,23})
    vRP.setArea(source,"vRP:police:pc"..k,x,y,z,1,1.5,pc_enter,pc_leave)
  end
end

-- build police points
AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then
    build_client_points(source)
  end
end)

-- delete wanted entry on leave
AddEventHandler("vRP:playerLeave", function(user_id, player)
  vRPclient.removeNamedBlip(-1, {"vRP:wanted:"..user_id})  -- remove wanted blip (all to prevent phantom blip)
  vRPclient.removeNamedBlip(-1, {"vRP:officer:"..user_id})  -- remove cop blip (all to prevent phantom blip)
  vRPclient.removeNamedBlip(-1, {"vRP:medic:"..user_id})  -- remove medic blip (all to prevent phantom blip)
end)

AddEventHandler("vRP:playerLeaveGroup", function(user_id, player)
  vRPclient.removeNamedBlip(-1, {"vRP:officer:"..user_id})  -- remove cop blip (all to prevent phantom blip)
  vRPclient.removeNamedBlip(-1, {"vRP:medic:"..user_id})  -- remove medic blip (all to prevent phantom blip)
end)

function tvRP.updatePrisonTime(time)
  local user_id = vRP.getUserId(source)
  vRP.setUData(user_id, "vRP:prison_time", time)
end
