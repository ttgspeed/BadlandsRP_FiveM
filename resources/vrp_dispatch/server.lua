local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

local cfg = module("vrp", "cfg/phone")
local services = cfg.services
local serverLabel = GetConvar('server_watermark','server.com')
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_dispatch")

local callMaxAge = 20 -- Minutes

RegisterServerEvent('loadcalls')
AddEventHandler('loadcalls', function(reload)
  local source = source
  MySQL.ready(function ()
    local user_id = vRP.getUserId({source})
    local serverLabel = GetConvar('server_watermark','server.com')
    MySQL.Async.fetchAll('SELECT * FROM vrp_dispatch WHERE `server` = @serverLabel ORDER BY `id` ASC',
    {serverLabel = serverLabel}, function(rows)
      if #rows > 0 then  -- found
        local count = 1
        local content = ""
        content = content.."<table class='table sans'><col class='column-one'><col class='column-two'><col class='column-three'><col class='column-four'> <col class='column-five'> <col class='column-six'><col class='column-seven'><col class='column-eight'><tr><th>CALL ID</th><th>CALL AGE</th><th>PHONE NUMBER</th><th>LOCATION</th><th>INCIDENT DESCRIPTION</th><th>RESPONDING UNITS</th><th>RESPOND</th><th>RESOLVE</th></tr>"
        while count <= #rows do
          local service = services[rows[count].calltype]
          local callAge
          if rows[count].calltime > 0 then
            callAge = (os.time() - rows[count].calltime) / 60
          else
            callAge = 0
          end
          if callAge > callMaxAge then
            MySQL.Async.execute('DELETE FROM vrp_dispatch WHERE id = @id AND `server` = @serverLabel',
            {
              ['@id'] = rows[count].id, serverLabel = serverLabel
            })
          else
            if vRP.hasPermission({user_id,service.alert_permission}) then
              content = content.."<tr><td>"..rows[count].id.."</td><td>"..string.format( "%.2f", tostring(round(callAge, 2))).." mins</td><td>"..rows[count].callerphone.."</td><td><a class='gps' id='"..rows[count].id.."'href='#'>"..rows[count].location.."</a></td><td>"..rows[count].calltext.."</td><td>"..rows[count].responding.."</td><td><a class='respond' id='"..rows[count].id.."'href='#'>✓</a></td><td><a class='resolve' id='"..rows[count].id.."'href='#'>✓</a></td></tr>"
            end
          end
          count = count + 1
        end
        content = content.."</table>"

        TriggerClientEvent("LoadDispatchCalls", source, content, reload)
      else
        local content = ""
        content = content.."<table class='table sans'><col class='column-one'><col class='column-two'><col class='column-three'><col class='column-four'> <col class='column-five'> <col class='column-six'><col class='column-seven'><col class='column-eight'><tr><th>CALL ID</th><th>CALL AGE</th><th>PHONE NUMBER</th><th>LOCATION</th><th>INCIDENT DESCRIPTION</th><th>RESPONDING UNITS</th><th>RESPOND</th><th>RESOLVE</th></tr>"
        content = content.."</table>"
        TriggerClientEvent("LoadDispatchCalls", source, content, reload)
      end
    end)
  end)
end)

RegisterServerEvent('loadcallsWanted')
AddEventHandler('loadcallsWanted', function(reload)
  local source = source
  MySQL.ready(function ()
    local user_id = vRP.getUserId({source})
    local serverLabel = GetConvar('server_watermark','server.com')
    MySQL.Async.fetchAll("SELECT m.id, m.firstName, m.lastName, m.registration, m.suspectDesc, m.wantedCrimes, concat(i.firstname, ' ', i.name) as officer, DATE_FORMAT(m.dateInserted, '%d-%m-%Y %T') as insertedDate FROM gta5_gamemode_essential.vrp_mdt as m JOIN vrp_user_identities AS i ON m.insertedBy= i.user_id; ",{},function(rows)
      if #rows > 0 then  -- found
        local count = 1
        local content = ""
        content = content.."<table class='table sans'><col class='column-oneb'><col class='column-twob'><col class='column-threeb'><col class='column-fourb'> <col class='column-fiveb'> <col class='column-sixb'><col class='column-sevenb'><col class='column-eightb'><tr><th>ID</th><th>FIRST NAME</th><th>LAST NAME</th><th>REGISTRATION</th><th>SUSPECT DESCRIPTION</th><th>WANTED CRIMES</th><th>INSERTED BY</th><th>DATE ENTERED</th></tr>"
        while count <= #rows do
          content = content.."<tr><td>"..rows[count].id.."</td><td>"..rows[count].firstName.."</td><td>"..rows[count].lastName.."</td><td>"..rows[count].registration.."</td><td>"..rows[count].suspectDesc.."</td><td>"..rows[count].wantedCrimes.."</td><td>"..rows[count].officer.."</td><td>"..rows[count].insertedDate.."</td></tr>"
          count = count + 1
        end
        content = content.."</table>"

        TriggerClientEvent("LoadDispatchCalls", source, content, reload)
      else
        local content = ""
        content = content.."<table class='table sans'><col class='column-one'><col class='column-two'><col class='column-three'><col class='column-four'> <col class='column-five'> <col class='column-six'><col class='column-seven'><col class='column-eight'><tr><th>FIRST NAME</th><th>LAST NAME</th><th>REGISTRATION</th><th>SUSPECT DESCRIPTION</th><th>WANTED CRIMES</th><th>INSERTED BY</th><th>DATE ENTERED</th></tr>"
        content = content.."</table>"
        TriggerClientEvent("LoadDispatchCalls", source, content, reload)
      end
    end)
  end)
end)

RegisterServerEvent('respondtocall')
AddEventHandler('respondtocall', function(callid)
  local source = source
  TriggerEvent("respondtocall_sv",callid,source)
end)

RegisterServerEvent('respondtocall_sv')
AddEventHandler('respondtocall_sv', function(callid, pSource)
  local source = pSource
  local user_id = vRP.getUserId({source})
  local serverLabel = GetConvar('server_watermark','server.com')
  MySQL.ready(function ()
    MySQL.Async.fetchAll('SELECT responding FROM vrp_dispatch WHERE id = @id AND server = @serverLabel',
    {
      ['@id'] = callid, serverLabel = serverLabel
    }, function(rows)
      if #rows > 0 then
        local responders = splitString(rows[1].responding, ", ")
        local count = 1
        local found = 0
        while count <= #responders do
          if responders[count] == tostring(user_id) then
            found = 1
          end
          count = count + 1
        end
        if found == 0 then
          MySQL.Async.fetchAll('SELECT responding FROM vrp_dispatch where id = @id AND server = @serverLabel',
          {
            ['@id']      = callid, serverLabel = serverLabel
          }, function(rows)
            if #rows > 0 then
              if rows[1].responding == "" then
                MySQL.Async.execute('UPDATE vrp_dispatch SET responding = @responder WHERE id = @id AND server = @serverLabel',
                {
                  ['@id']      = callid,
                  ['@responder'] = user_id,
                  serverLabel = serverLabel
                })
              else
                MySQL.Async.execute('UPDATE vrp_dispatch SET responding = CONCAT(responding, ",", @responder) WHERE id = @id AND server = @serverLabel',
                {
                  ['@id']      = callid,
                  ['@responder'] = user_id,
                  serverLabel = serverLabel
                })
              end
            end
          end)
        end
        MySQL.Async.fetchAll('SELECT * FROM vrp_dispatch WHERE id = @id AND server = @serverLabel',
        {
          ['@id']      = callid, serverLabel = serverLabel
        }, function(rows)
          if #rows > 0 then
            vRPclient.setGPS(source, {tonumber(rows[1].posx), tonumber(rows[1].posy)})
          end
        end)
      end
    end)
  end)
end)

RegisterServerEvent('gpstocall')
AddEventHandler('gpstocall', function(callid)
  local source = source
  local user_id = vRP.getUserId({source})
  local serverLabel = GetConvar('server_watermark','server.com')
  MySQL.ready(function ()
    MySQL.Async.fetchAll('SELECT * FROM vrp_dispatch WHERE id = @id AND server = @serverLabel',
    {
      ['@id']      = callid, serverLabel = serverLabel
    }, function(rows)
      if #rows > 0 then
        vRPclient.setGPS(user_id, {tonumber(rows[1].posx), tonumber(rows[1].posy)})
      end
    end)
  end)
end)

RegisterServerEvent('resolvecall')
AddEventHandler('resolvecall', function(callid)
  local source = source
  local serverLabel = GetConvar('server_watermark','server.com')
  MySQL.ready(function ()
    local calls = MySQL.Async.execute('DELETE FROM vrp_dispatch WHERE id = @id AND server = @serverLabel',
    {
      ['@id'] = callid, serverLabel = serverLabel
    })
  end)
end)

-- HELPER FUNCTIONS
function round(num, numDecimalPlaces)
  local mult = 5^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function splitString(str, sep)
  if sep == nil then sep = "%s" end

  local t={}
  local i=1

  for str in string.gmatch(str, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end

  return t
end

function GetVehicleInDirectionSphere( entFrom, coordFrom, coordTo )
  local rayHandle = StartShapeTestCapsule( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 2.0, 10, entFrom, 7 )
  local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
  return vehicle
end

AddEventHandler('chatMessage', function(from,name,message)
  if(string.sub(message,1,1) == "/") then

    local args = splitString(message)
    local cmd = args[1]
    local user_id = vRP.getUserId({from})
    if(cmd == "/dispatch") then
      if vRP.hasPermission({user_id,"police.service"}) then
        TriggerClientEvent('LoadCalls', from, false, "police", "dispatch")
      elseif vRP.hasPermission({user_id,"emergency.revive"}) then
        TriggerClientEvent('LoadCalls',from, false, "EMS/Fire", "dispatch")
      --elseif vRP.hasPermission({user_id,"taxi.service"}) then
      --  TriggerClientEvent('LoadCalls',from, false, "taxi")
      --elseif vRP.hasPermission({user_id,"repair.service"}) then
      --  TriggerClientEvent('LoadCalls',from, false, "repair")
      end
    end
    if(cmd == "/wanted") then
      if vRP.hasPermission({user_id,"police.service"}) then
        TriggerClientEvent('LoadCalls', from, false, "police", "mdt")
      end
    end
    if(cmd == "/responding")then
      TriggerEvent('respondtocall', args[2])
    end
    if(cmd == "/resolved")then
      TriggerEvent('resolvecall', args[2])
    end
  end
end)

function stringsplit(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str i = i + 1
  end
  return t
end
