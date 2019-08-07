
-- this module define some police tools and functions
local lang = vRP.lang
local cfg = module("cfg/police")
local cfg_inventory = module("cfg/inventory")
local Log = module("lib/Log")
local cfg_shops = module("cfg/business_shops")

-- police records

local function choice_dispatch(player, choice)
  TriggerClientEvent('LoadCalls',player, false, "Police", "dispatch")
end

local function ch_search_police_records(player, choice)
  TriggerClientEvent('LoadCalls',player, false, "Police", "mdt")
end

local function ch_search_police_records_inVeh(player,choice)
  vRPclient.isInProtectedVeh(player,{},function(inVeh)
    if inVeh then
      TriggerClientEvent('LoadCalls',player, false, "Police", "mdt")
    end
  end)
end

local function ch_clockIn_lawyer(player,choice)
  vRP.prompt(player,"Enter Lawyer ID","",function(player, value)
    if value ~= nil and tonumber(value) > 0 then
      local sourceID = vRP.getUserId(player)
      local lawyerID = tonumber(value)
      local lawyerPed = vRP.getUserSource(lawyerID)
      if lawyerPed ~= nil and lawyerPed > 0 then
        if vRP.hasPermission(lawyerID,"lawyer.active") then
          local time = os.time()
          Log.write(sourceID, "Signed in lawyer "..lawyerID..". Start time "..time, Log.log_type.lawyer)
          vRPclient.lawyerThread(lawyerPed, {true, time})
        else
          vRPclient.notify(player, {"The individual you are trying to clock in is not Bar Certified."})
        end
      end
    end
  end)
end

local function ch_clockOut_lawyer(player,choice)
  vRP.prompt(player,"Enter Lawyer ID","",function(player, value)
    if value ~= nil and tonumber(value) > 0 then
      local sourceID = vRP.getUserId(player)
      local lawyerID = tonumber(value)
      local lawyerPed = vRP.getUserSource(lawyerID)
      if lawyerPed ~= nil and lawyerPed > 0 then
        local time = os.time()
        Log.write(sourceID, "Signed out lawyer "..lawyerID..". End time "..time, Log.log_type.lawyer)
        vRPclient.lawyerThread(lawyerPed, {false, 0})
      end
    end
  end)
end

local function ch_insert_police_records(player,choice)
  local firstName = "John"
  local lastName = "Doe"
  local registration = "XXXXXX"
  local suspectDesc = "No description"
  local wantedCrimes = "No crimes"
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRP.prompt(player,"Enter Suspects First Name","",function(player, value)
      if value ~= nil then
        firstName = value
      end
      vRP.prompt(player,"Enter Suspects Last Name","",function(player, value)
        if value ~= nil then
          lastName = value
        end
        vRP.prompt(player,"Enter Suspects Registration","",function(player, value)
          if value ~= nil then
            registration = value
          end
          vRP.prompt(player,"Enter Suspects Description","",function(player, value)
            if value ~= nil then
              suspectDesc = value
            end
            vRP.prompt(player,"Enter Suspects Crimes","",function(player, value)
              if value ~= nil then
                wantedCrimes = value
              end
              local content = "Wanted Record Entry<br>"
              content = content.."<table><tr><th>First Name</th><th>Last Name</th><th>Registration</th><th>Description</th><th>Wanted Crimes</th></tr>"
              content = content.."<tr><td>"..firstName.."</td><td>"..lastName.."</td><td>"..registration.."</td><td>"..suspectDesc.."</td><td>"..wantedCrimes.."</td></tr></table>"

              --content = "Record Entry<br>First Name: "..firstName.."<br>Last Name: "..lastName.."<br>Registration: "..registration.."<br>Description: "..suspectDesc.."<br>Wanted For: "..wantedCrimes
              vRPclient.setDiv(player,{"police_record",".div_police_record{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 1200px; padding: 10px; margin: auto; margin-top: 150px; }",content})
              -- request to hide div
              vRP.request(player, "Insert record?", 1000, function(player,ok)
                vRPclient.removeDiv(player,{"police_record"})
                MySQL.Async.execute('INSERT INTO vrp_mdt(firstName,lastName,registration,suspectDesc,wantedCrimes,insertedBy,dateInserted) VALUES (@firstName,@lastName,@registration,@suspectDesc,@wantedCrimes,@user_id, NOW())',
                  {firstName = firstName, lastName = lastName, registration = registration, suspectDesc = suspectDesc, wantedCrimes = wantedCrimes, user_id = user_id}, function(rowsChanged)
                end)
                vRPclient.notify(player, {"Record inserted"})
                Log.write(user_id, "Inserted wanted record - First Name: "..firstName.." Last Name: "..lastName.." Registration: "..registration.." Description: "..suspectDesc.." Wanted For: "..wantedCrimes, Log.log_type.action)
              end)
            end)
          end)
        end)
      end)
    end)
  end
end

-- delete police records by registration
local function ch_delete_police_records(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"police.delete_records") then
    vRP.prompt(player,"Enter Record ID to Delete","",function(player, id)
      if tonumber(id) > 0 then
        vRP.request(player, "Delete Record ID "..id.." ?", 1000, function(player,ok)
          if ok then
            MySQL.Async.execute('DELETE FROM vrp_mdt where id = @id',{id = id}, function(rowsChanged) end)
            vRPclient.notify(player, {"Record deleted"})
            Log.write(user_id, "Deleted wanted record ID: "..id, Log.log_type.action)
          end
        end)
      end
    end)
  else
    vRPclient.notify(player,{"You do not have the required access"})
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
  vRP.prompt(player,"Enter Registration","",function(player, reg)
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
            local lawyerlicense = identity.lawyerlicense
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

                local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number,firearmlicense,driverlicense,pilotlicense,lawyerlicense})
                local source_id = vRP.getUserId(player)
                Log.write(source_id, "Search by registration for: "..reg, Log.log_type.action)
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
  vRP.prompt(player,"Enter Phone Number","",function(player, phoneNumber)
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
            local lawyerlicense = identity.lawyerlicense
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

                local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number,firearmlicense,driverlicense,pilotlicense,lawyerlicense})
                local source_id = vRP.getUserId(player)
                Log.write(source_id, "Search by phone for: "..phoneNumber, Log.log_type.action)
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

local function ch_search_financials(player,choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRP.prompt(player, "Parent business of the shop", "", function(player, p_input)
			Log.write(user_id, "Searched financial records of business "..p_input, Log.log_type.action)
			for k,v in pairs(cfg_shops.stores) do
				if parseInt(p_input) > 0 then
					p_input = parseInt(p_input)
					if p_input == v.business then
						if v.total_income > v.clean_income then
							vRPclient.notify(player,{v.name.." has unreported income!"})
						else
							vRPclient.notify(player,{v.name.." has clean financial records."})
						end
					end
				else
					vRPclient.notify(player,{lang.common.invalid_value()})
				end
			end
		end)
	end
end

menu_pc["Registration Search"] = {ch_searchreg,lang.police.pc.searchreg.description(),1}
menu_pc["Search By Phone"] = {ch_searchphone,"Search phone number owner",2}
menu_pc["Track Vehicle"] = {ch_trackveh,lang.police.pc.trackveh.description(),3 }
menu_pc["Insert Wanted Record"] = {ch_insert_police_records,"",4 }
menu_pc["Search Wanted Record"] = {ch_search_police_records,"",5 }
menu_pc["Delete Wanted Record"] = {ch_delete_police_records,"",6 }
menu_pc["Search Shop Financials"] = {ch_search_financials,"Verify whether a shop is properly reporting their earnings",7}
menu_pc["Clock in Lawyer"] = {ch_clockIn_lawyer,"",8}
menu_pc["Clock out Lawyer"] = {ch_clockOut_lawyer,"",9}
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
function tvRP.choice_handcuff(nplayer)
  local player = source
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
end

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
function tvRP.choice_escort(nplayer)
  local player = source
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.toggleEscort(nplayer,{player})
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end
end

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

function tvRP.choice_putinveh(nplayer)
  local player = source
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
end

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
    vRPclient.getNearestEmergencyVehicle(player,{5},function(ok,vtype,class)
      if ok then
        vRPclient.storeCopWeapon(player,{"WEAPON_PUMPSHOTGUN"})
      end
    end)
  end, lang.police.menu.store_weapons.description(),1}

  emenu["Store/Get SMG"] = {function(player, choice)
    vRPclient.getNearestEmergencyVehicle(player,{5},function(ok,vtype,class)
      if ok then
        vRPclient.storeCopWeapon(player,{"WEAPON_SMG"})
      end
    end)
  end, lang.police.menu.store_weapons.description(),2}

  -- open mnu
  vRP.openMenu(player, emenu)
end, lang.police.menu.store_weapons.description(),17}

--------- Player Actions Menu
function tvRP.choice_revoke_keys(nplayer)
  local player = source
  if nplayer ~= nil then
    vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)
      if handcuffed then
        vRP.request(player, "Revoke Shared Keys?", 30, function(player,ok)
          vRPclient.clearKeys(nplayer, {})
          vRPclient.notify(player, {"You have revoked their shared keys."})
          vRPclient.notify(nplayer, {"Your shared keys have been revoked."})
          Log.write(user_id, "Revoked shared keys from "..nuser_id, Log.log_type.action)
        end)
      else
        vRPclient.notify(player,{"Target must be handcuffed to do this."})
      end
    end)
  else
    vRPclient.notify(player,{lang.common.no_player_near()})
  end
end

local choice_revoke_keys = {function(player,choice)
  vRPclient.getNearestPlayer(player,{5},function(nplayer)
    if nplayer ~= nil then
      vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)
        if handcuffed then
          vRP.request(player, "Revoke Shared Keys?", 30, function(player,ok)
            vRPclient.clearKeys(nplayer, {})
            vRPclient.notify(player, {"You have revoked their shared keys."})
            vRPclient.notify(nplayer, {"Your shared keys have been revoked."})
            Log.write(user_id, "Revoked shared keys from "..nuser_id, Log.log_type.action)
          end)
        else
          vRPclient.notify(player,{"Target must be handcuffed to do this."})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,"Revoke shared keys from player",14}

function tvRP.choice_handcuff_movement(nplayer)
  local player = source
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
end

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
end,"Allow/Restrict movement of handcuffed player",18}

-- police check
function tvRP.choice_checkPd(nplayer)
  local player = source
  local nuser_id = vRP.getUserId(nplayer)
  if nuser_id ~= nil then
    vRPclient.notify(nplayer,{"You are being searched"})
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

      vRPclient.getKeys(nplayer, {}, function(keys)
        local keyChain = ""
        if #keys > 0 then
          for k,v in pairs(keys) do
            keyChain = keyChain.."<br>Vehicle: "..string.upper(v.name).."&nbsp;&nbsp;&nbsp;&nbsp;Registration: "..string.upper(v.plate)
          end
        end
        vRPclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info,keyChain})})
        -- request to hide div
        vRP.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
          vRPclient.removeDiv(player,{"police_check"})
        end)
      end)

    end)
  else
    vRPclient.notify(player,{lang.common.no_player_near()})
  end
end

local choice_check = {function(player,choice)
  vRPclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.notify(nplayer,{"You are being searched"})
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

        vRPclient.getKeys(nplayer, {}, function(keys)
          local keyChain = ""
          if #keys > 0 then
            for k,v in pairs(keys) do
              keyChain = keyChain.."<br>Vehicle: "..string.upper(v.name).."&nbsp;&nbsp;&nbsp;&nbsp;Registration: "..string.upper(v.plate)
            end
          end
          vRPclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info,keyChain})})
          -- request to hide div
          vRP.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
            vRPclient.removeDiv(player,{"police_check"})
          end)
        end)

      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, lang.police.menu.check.description(),6}
-- askid
function tvRP.choice_checkidPd(nplayer)
  local player = source
  local nuser_id = vRP.getUserId(nplayer)
  if nuser_id ~= nil then
    vRPclient.notify(nplayer,{"Police are checking your ID"})
    vRP.getUserIdentity(nuser_id, function(identity)
      vRP.getAllPlayerLicenses(nuser_id, function(licenses)
        if identity and licenses then
          -- display identity and business
          local name = identity.name
          local firstname = identity.firstname
          local age = identity.age
          local phone = identity.phone
          local registration = identity.registration
          local firearmlicense = tonumber(licenses["firearmlicense"].licensed)
          local driverlicense = tonumber(licenses["driverlicense"].licensed)
          local pilotlicense = tonumber(licenses["pilotlicense"].licensed)
          local lawyerlicense = tonumber(licenses["lawyerlicense"].licensed)
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

              local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number,firearmlicense,driverlicense,pilotlicense,lawyerlicense})
              vRPclient.setDiv(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
              -- request to hide div
              vRP.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
                vRPclient.removeDiv(player,{"police_identity"})
              end)
            end)
          end)
        end
      end)
    end)
  else
    vRPclient.notify(player,{lang.common.no_player_near()})
  end
end

local choice_checkid = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.notify(nplayer,{"Police are checking your ID"})
      vRP.getUserIdentity(nuser_id, function(identity)
        vRP.getAllPlayerLicenses(nuser_id, function(licenses)
          if identity and licenses then
            -- display identity and business
            local name = identity.name
            local firstname = identity.firstname
            local age = identity.age
            local phone = identity.phone
            local registration = identity.registration
            local firearmlicense = tonumber(licenses["firearmlicense"].licensed)
            local driverlicense = tonumber(licenses["driverlicense"].licensed)
            local pilotlicense = tonumber(licenses["pilotlicense"].licensed)
            local lawyerlicense = tonumber(licenses["lawyerlicense"].licensed)
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

                local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number,firearmlicense,driverlicense,pilotlicense,lawyerlicense})
                vRPclient.setDiv(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
                -- request to hide div
                vRP.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
                  vRPclient.removeDiv(player,{"police_identity"})
                end)
              end)
            end)
          end
        end)
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, "Check the ID of the nearest player.",5}

function tvRP.choice_seize_weapons(nplayer)
  local player = source
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
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
  end
end

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

function tvRP.choice_seize_items(nplayer)
  local player = source
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
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
  end
end

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
function tvRP.choice_jail(nplayer)
  local player = source
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
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
            end
						-- jail
						if v_min then
							vRPclient.jail(nplayer,{v_min[1],v_min[2],v_min[3],v_min[4]})
							vRPclient.notify(nplayer,{lang.police.menu.jail.notify_jailed()})
							vRPclient.notify(player,{lang.police.menu.jail.jailed()})
						else
							vRPclient.notify(player,{lang.police.menu.jail.not_found()})
						end
          end)
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end
end

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
              end
							-- jail
							if v_min then
								vRPclient.jail(nplayer,{v_min[1],v_min[2],v_min[3],v_min[4]})
								vRPclient.notify(nplayer,{lang.police.menu.jail.notify_jailed()})
								vRPclient.notify(player,{lang.police.menu.jail.jailed()})
							else
								vRPclient.notify(player,{lang.police.menu.jail.not_found()})
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

function tvRP.choice_prison(nplayer)
  local player = source
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
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
                          if vRP.hasGroup(nuser_id, "towtruck") then
                            vRP.removeUserGroup(nuser_id, "towtruck")
                            vRPclient.notify(nplayer,{"You have been removed from the Tow Truck job"})
                            vRP.addUserGroup(nuser_id, "citizen")
                          end
                          vRP.setUData(nuser_id, "vRP:prison_time", amount)
                          vRPclient.notify(nplayer,{lang.police.menu.prison.notify_prison()})
                          if fine > 0 then
														vRP.prisonFinancialPenalty(nuser_id,fine)
                            vRPclient.notify(nplayer,{"You were fined $"..fine.." along with your prison sentence"})
                          end
                          vRPclient.notify(player,{lang.police.menu.prison.imprisoned()})
                          Log.write(user_id, "Sent "..nuser_id.." to prison for "..amount.." minutes and paid fine of $"..fine, Log.log_type.action)
                        else
                          if jailed then
														if fine > 0 then
															vRP.prisonFinancialPenalty(nuser_id,fine)
                            end
                            vRPclient.prison(nplayer,{amount})
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
  end
end

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
                            if vRP.hasGroup(nuser_id, "towtruck") then
                              vRP.removeUserGroup(nuser_id, "towtruck")
                              vRPclient.notify(nplayer,{"You have been removed from the Tow Truck job"})
                              vRP.addUserGroup(nuser_id, "citizen")
                            end
                            vRP.setUData(nuser_id, "vRP:prison_time", amount)
                            vRPclient.notify(nplayer,{lang.police.menu.prison.notify_prison()})
                            if fine > 0 then
															vRP.prisonFinancialPenalty(nuser_id,fine)
                              vRPclient.notify(nplayer,{"You were fined $"..fine.." along with your prison sentence"})
                            end
                            vRPclient.notify(player,{lang.police.menu.prison.imprisoned()})
                            Log.write(user_id, "Sent "..nuser_id.." to prison for "..amount.." minutes and paid fine of $"..fine, Log.log_type.action)
                          else
                            if jailed then
															if fine > 0 then
																vRP.prisonFinancialPenalty(nuser_id,fine)
	                            end
                              vRPclient.prison(nplayer,{amount})
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
function tvRP.choice_seize_driverlicense(nplayer)
  local player = source
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRP.request(player,"Are you sure you want to revoke "..nuser_id.."'s Driver License?",15,function(player,ok)
        if ok then
					vRP.suspendPlayerLicense(nuser_id, "driverlicense")
					Log.write(user_id, "Revoked "..nuser_id.."'s Driver License", Log.log_type.action)
          vRPclient.notify(player,{"You have revoked "..nuser_id.."'s Driver License."})
          vRPclient.notify(nplayer,{"Your Driver License has been revoked."})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end
end

local choice_seize_driverlicense = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil then
        vRP.request(player,"Are you sure you want to revoke "..nuser_id.."'s Driver License?",15,function(player,ok)
          if ok then
						vRP.suspendPlayerLicense(nuser_id, "driverlicense")
						Log.write(user_id, "Revoked "..nuser_id.."'s Driver License", Log.log_type.action)
            vRPclient.notify(player,{"You have revoked "..nuser_id.."'s Driver License."})
            vRPclient.notify(nplayer,{"Your Driver License has been revoked."})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.seize_driverlicense.description(),15}

-- seize firearm license
function tvRP.choice_seize_firearmlicense(nplayer)
  local player = source
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRP.request(player,"Are you sure you want to revoke "..nuser_id.."'s Firearm License?",15,function(player,ok)
        if ok then
					vRP.suspendPlayerLicense(nuser_id, "firearmlicense")
					Log.write(user_id, "Revoked "..nuser_id.."'s Firearm License", Log.log_type.action)
          vRPclient.notify(player,{"You have revoked "..nuser_id.."'s Firearm License."})
          vRPclient.notify(nplayer,{"Your Firearm License has been revoked."})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end
end

local choice_seize_firearmlicense = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil then
        vRP.request(player,"Are you sure you want to revoke "..nuser_id.."'s Firearm License?",15,function(player,ok)
          if ok then
						vRP.suspendPlayerLicense(nuser_id, "firearmlicense")
						Log.write(user_id, "Revoked "..nuser_id.."'s Firearm License", Log.log_type.action)
            vRPclient.notify(player,{"You have revoked "..nuser_id.."'s Firearm License."})
            vRPclient.notify(nplayer,{"Your Firearm License has been revoked."})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.seize_firearmlicense.description(),16}

function tvRP.choice_fine(nplayer)
  local player = source
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
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
  end
end

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

function tvRP.choice_gsr_test(nplayer)
  local player = source
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    if vRP.tryGetInventoryItem(user_id,"gsr_kit",1,true) then
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
    else
      vRPclient.notify(player,{"You don't have a GSR Test Kit"})
    end
  end
end

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
end, "Use a GSR Test Kit to test for gunshot residue",17}

--------- Vehicle Actions Menu

---- START NEW FUNCTIONS FOR NEW MENU
function tvRP.choice_check_vehicle(name,plate)
  local player = source
  if name ~= nil and plate ~= nil then
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
end

function tvRP.searchVehicleVin(name,plate)
  local player = source
	local veh_name = name
  if veh_name ~= nil and plate ~= nil then
    vRP.getUserByRegistration(plate, function(nuser_id)
      if nuser_id ~= nil then
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
            local lawyerlicense = identity.lawyerlicense
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

	              local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number,firearmlicense,driverlicense,pilotlicense,lawyerlicense})
	              vRPclient.setDiv(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
								Log.write(user_id, "Checked VIN for "..nuser_id.." "..veh_name, Log.log_type.action)
	              -- request to hide div
	              vRP.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
	                vRPclient.removeDiv(player,{"police_identity"})
	              end)
	            end)
	          end)
	        end
	      end)
      else
        vRPclient.notify(player,{"No VIN found."})
      end
    end)
  else
    vRPclient.notify(player,{"No player owned vehicle nearby."})
  end
end

function tvRP.choice_seize_vehicle(vehicle,name,plate)
  local player = source
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRP.getUserByRegistration(plate, function(nuser_id)
      if nuser_id ~= nil then
        local nplayer = vRP.getUserSource(nuser_id)
        vRP.request(player,"Are you sure you want this vehicle?",15,function(player,ok)
          if ok then
            vRPclient.notify(player,{"The vehicle has been seized."})
            vRPclient.impoundVehicle(player,{})
            vRPclient.notify(nplayer,{"Your vehicle has been seized by the police."})
            MySQL.Async.execute('DELETE FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle', {user_id = nuser_id, vehicle = name}, function(rowsChanged) end)
            Log.write(user_id, " seized "..name.." from ".. nuser_id, Log.log_type.action)
            vRP.setSData("chest:u"..nuser_id.."veh_"..name, json.encode({}))
            MySQL.Async.execute('DELETE FROM vrp_srv_data WHERE dkey = @dkey', {dkey = "chest:u"..nuser_id.."veh_"..name}, function(rowsChanged) end)
          end
        end)
      else
        vRPclient.notify(player,{"You are unable to seize this vehicle"})
      end
    end)
  end
end

function tvRP.choice_impoundveh()
  local player = source
  vRP.request(player, "Impound vehicle?", 15, function(player,ok)
    if ok then
      vRPclient.impoundVehicle(player,{false})
    end
  end)
end

function tvRP.choice_getoutveh()
  local player = source
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
end
------ END OF NEW FUNCTIONS FOR NEW MENU

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

local choice_check_vehicle_vin = {function(player,choice)
  vRPclient.getNearestOwnedVehiclePlate(player,{10},function(ok,vtype,name,plate)
		local veh_name = name
    if ok then
      vRP.getUserByRegistration(plate, function(nuser_id)
        if nuser_id ~= nil then
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
              local lawyerlicense = identity.lawyerlicense
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

		              local content = lang.police.identity.info({name,firstname,age,registration,phone,bname,bcapital,home,number,firearmlicense,driverlicense,pilotlicense,lawyerlicense})
		              vRPclient.setDiv(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
									Log.write(user_id, "Checked VIN for "..nuser_id.." "..veh_name, Log.log_type.action)
		              -- request to hide div
		              vRP.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
		                vRPclient.removeDiv(player,{"police_identity"})
		              end)
		            end)
		          end)
		        end
		      end)
        else
          vRPclient.notify(player,{"No VIN found."})
        end
      end)
    else
      vRPclient.notify(player,{"No player owned vehicle nearby."})
    end
  end)
end, "Search nearest vehicle's VIN.",11}

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
        vRPclient.impoundVehicle(player,{false})
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
      emenu["Seize Items"] = choice_seize_items
    end
    if vRP.hasPermission(user_id,"police.jail") then
      emenu[lang.police.menu.jail.title()] = choice_jail
      emenu["Send to prison"] = choice_prison
    end
    if vRP.hasPermission(user_id,"police.fine") then
      emenu[lang.police.menu.fine.title()] = choice_fine
      emenu["Revoke Keys"] = choice_revoke_keys
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
		if vRP.hasPermission(user_id,"police.check") then
      emenu["Search vehicle VIN"] = choice_check_vehicle_vin
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
          if vRP.hasPermission(user_id, "police.pc") then
            menu["Search Wanted Record"] = {ch_search_police_records_inVeh,"",18 }
            menu["Mobile Data Terminal"] = {choice_dispatch, "", 19}
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
