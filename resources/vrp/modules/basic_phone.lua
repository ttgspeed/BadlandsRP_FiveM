
-- basic phone module

local lang = vRP.lang
local cfg = module("cfg/phone")
local htmlEntities = module("lib/htmlEntities")
local Log = module("lib/Log")
local services = cfg.services
local announces = cfg.announces

local sanitizes = module("cfg/sanitizes")

RegisterServerEvent('vRP_drugNPC:police_alert')
AddEventHandler('vRP_drugNPC:police_alert', function(x,y,z)
  tvRP.sendServiceAlert(nil, "Police",x,y,z,"Someone is offering me drugs.")
end)

function tvRP.gcphoneAlert(service)
  local player = source
  if service == "message_police" then
    ch_service_alert(player, "Police")
  elseif service == "message_emergency" then
    ch_service_alert(player, "EMS/Fire")
  elseif service == "message_taxi" then
    ch_service_alert(player, "Taxi")
  elseif service == "message_towtruck" then
    ch_service_alert(player, "Tow Truck")
  elseif service == "tag_towtruck" then
    ch_tagTow(player, 1)
  elseif service == "message_lawyer" then
    ch_service_alert(player, "Lawyer")
  end
end

-- api

-- Send a service alert to all service listeners
--- sender: a player or nil (optional, if not nil, it is a call request alert)
--- service_name: service name
--- x,y,z: coordinates
--- msg: alert message
function tvRP.sendServiceAlert(sender, service_name,x,y,z,msg,loc,log)
  local service = services[service_name]
  local answered = false
  local userId = vRP.getUserId(sender)
  local serverLabel = GetConvar('blrp_watermark','badlandsrp.com')

  if loc == nil then
    loc = "No Information"
  end
  if log == nil then
    log = false
  end
  if service then
    local players = {}
    for k,v in pairs(vRP.rusers) do
      local player = vRP.getUserSource(tonumber(k))
      -- check user
      if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
        table.insert(players,player)
      end
    end
    if log then
      vRP.getUserIdentity(userId, function(identity)
        if identity then
          local phone = identity.phone
          local name = identity.name
          local firstname = identity.firstname
          local time = os.time()

          MySQL.Async.fetchAll('SELECT * FROM vrp_dispatch where user_id = @userId AND server = @server', {userId = userId, server = serverLabel}, function(rows)
            if #rows > 0 then
              local message = rows[1].calltext.."<br><br><b>Update:&nbsp;</b>"..msg
              MySQL.Async.execute('UPDATE vrp_dispatch SET posx = @posx, posy = @posy, posz = @posz, calltext = @calltext, location = @location where user_id = @userId and server = @server', {calltext = message, posx = x, posy = y, posz = z, location = loc, userId = userId, server = serverLabel}, function(rowsChanged) end)
            else
              msg = "<b>Initial Call:&nbsp;</b>"..msg
              MySQL.Async.execute('INSERT INTO vrp_dispatch (callerphone, callerfirst, callerlast, posx, posy, posz, calltext, calltype, calltime, location, user_id, server) VALUES (@callerphone,@callerfirst,@callerlast,@posx,@posy,@posz,@calltext,@calltype,@calltime,@location,@userId,@server)', {callerphone = phone, callerfirst = firstname, callerlast = name, calltext = msg, posx = x, posy = y, posz = z, calltype = service_name, calltime = time, location = loc, userId = userId, server = serverLabel}, function(rowsChanged) end)
            end
          end)
        end
      end)
    end
    -- send notify and alert to all listening players
    for k,v in pairs(players) do
      vRPclient.notify(v,{service.alert_notify..msg})
      -- add position for service.time seconds
      local timeout = service.alert_time
      if sender == nil then
        timeout = 45
      end
      vRPclient.addBlip(v,{x,y,z,service.blipid,service.blipcolor,"("..service_name..") "..msg}, function(bid)
        if bid ~= false then
          SetTimeout(timeout*1000,function()
            vRPclient.removeBlip(v,{bid})
          end)
        end
      end)

      -- call request
      if sender ~= nil then
        vRP.request(v,lang.phone.service.ask_call({service_name, htmlEntities.encode(msg)}), 30, function(v,ok)
          if ok then -- take the call
            MySQL.Async.fetchAll('SELECT * FROM vrp_dispatch WHERE user_id = @userId AND server = @server ORDER BY calltime DESC', {userId = userId, server = serverLabel}, function(rows)
              if #rows > 0 then
                if rows[1].id ~= nil then
                  print("Call ID is "..rows[1].id)
                  TriggerEvent('respondtocall_sv',tonumber(rows[1].id),v)
                end
              end
            end)
            if not answered then
              -- answer the call
              vRPclient.notify(sender,{service.answer_notify})
              answered = true
            else
              vRPclient.notify(v,{lang.phone.service.taken()})
            end
            vRPclient.setGPS(v,{x,y})
          end
        end)
      end
    end
  end
end

function ch_service_alert(player,choice) -- alert a service
  local service = services[choice]
  local log = false
  if service then
    local inServiceCount = 0
    if choice == "Police" or choice == "EMS/Fire" then
      log = true
      for _ in pairs(vRP.getUsersByPermission(service.alert_permission)) do
        inServiceCount = inServiceCount + 1
      end
      if inServiceCount < 1 then
        log = false
        inServiceCount = 1
      end
    else
      for _ in pairs(vRP.getUsersByPermission(service.alert_permission)) do
        inServiceCount = inServiceCount + 1
      end
    end
    if inServiceCount > 0 then
      vRPclient.getPosition(player,{},function(x,y,z)
        vRP.prompt(player,lang.phone.service.prompt(),"",function(player, msg)
          msg = sanitizeString(msg,sanitizes.text[1],sanitizes.text[2])
          msg = string.gsub(msg, "%s+$", "")
          if string.len(msg) > 0 then
            vRPclient.notify(player,{service.notify}) -- notify player
            local user_id = vRP.getUserId(player)
            vRP.getUserIdentity(user_id, function(identity)
              if identity ~= nil then
                vRPclient.GetZoneName(player, {x, y, z}, function(location)
                  tvRP.sendServiceAlert(player,choice,x,y,z,msg,location,log) -- send service alert (call request)
                  Log.write(user_id,"Sent "..choice.." alert. Message: "..msg,Log.log_type.sms)
                end)
              else
                vRPclient.notify(player,{"Network failed to send message. Try again later."})
              end
            end)
          else
            vRPclient.notify(player,{"No message sent. No text entered."})
          end
        end)
      end)
    else
      vRPclient.notify(player,{choice.." services are not available at this time"})
    end
  end
end

function ch_tagTow(player, choice)
  local towCount = 0
  for _ in pairs(vRP.getUsersByPermission("towtruck.service")) do towCount = towCount + 1 end
  if towCount > 0 then
    vRPclient.tagNearestVehicleForTow(player,{5})
  else
    vRPclient.notify(player,{"No tow trucks in service. Tagging cancelled."})
  end
end
