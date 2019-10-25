local Tunnel = module("vrp", "panopticon/sv_pano_tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Log = module("vrp", "lib/Log")

vRP = Proxy.getInterface("vRP")

RegisterServerEvent('mdt:insertWarning')
AddEventHandler("mdt:insertWarning", function(data)
  local user_id = vRP.getUserId({source})
  MySQL.Async.fetchAll('SELECT * FROM vrp_user_identities WHERE user_id = @user_id', {user_id = user_id}, function(rows)
    if rows[1] ~= nil then
      local reporterName = rows[1].firstname.." "..rows[1].name
      MySQL.Async.execute('INSERT INTO cad_mdt(eventType, firstname, lastname, registration, location, details, inserted_date, inserted_by) VALUES (@eventType, @firstname, @lastname, @registration, @location, @details, CONCAT((SELECT CURRENT_TIMESTAMP()), " EST"), @reporterName)',
        {eventType = data.eventType, firstname = data.firstname, lastname = data.lastname, registration = data.registration, location = data.location, details = data.details, reporterName = reporterName}, function(rowsChanged)
          Log.write(user_id,"Inserted MDT Warning. First name: "..data.firstname..", Last Name: "..data.lastname..", Registration: "..data.registration..", Location: "..data.location..", Details: "..data.details,Log.log_type.action)
      end)
    end
  end)
end)

RegisterServerEvent('mdt:insertCitation')
AddEventHandler("mdt:insertCitation", function(data)
  local user_id = vRP.getUserId({source})
  MySQL.Async.fetchAll('SELECT * FROM vrp_user_identities WHERE user_id = @user_id', {user_id = user_id}, function(rows)
    if rows[1] ~= nil then
      local reporterName = rows[1].firstname.." "..rows[1].name
      MySQL.Async.execute('INSERT INTO cad_mdt(eventType, firstname, lastname, registration, location, citation_total, charges, details, inserted_date, inserted_by) VALUES (@eventType, @firstname, @lastname, @registration, @location, @citation_total, @charges, @details, CONCAT((SELECT CURRENT_TIMESTAMP()), " EST"), @reporterName)',
        {eventType = data.eventType, firstname = data.firstname, lastname = data.lastname, registration = data.registration, location = data.location, citation_total = data.citationAmount, charges = data.charges, details = data.details, reporterName = reporterName }, function(rowsChanged)
          Log.write(user_id,"Inserted MDT Citation. First name: "..data.firstname..", Last Name: "..data.lastname..", Registration: "..data.registration..", Location: "..data.location..", Citation Amt: "..data.citationAmount..", Charges: "..data.charges..", Details: "..data.details,Log.log_type.action)
      end)
    end
  end)
end)

RegisterServerEvent('mdt:insertArrest')
AddEventHandler("mdt:insertArrest", function(data)
  local user_id = vRP.getUserId({source})
  MySQL.Async.fetchAll('SELECT * FROM vrp_user_identities WHERE user_id = @user_id', {user_id = user_id}, function(rows)
    if rows[1] ~= nil then
      local reporterName = rows[1].firstname.." "..rows[1].name
      MySQL.Async.execute('INSERT INTO cad_mdt(eventType, firstname, lastname, registration, location, citation_total, restitution_total, prison_time, charges, details, inserted_date, inserted_by) VALUES (@eventType, @firstname, @lastname, @registration, @location, @citation_total, @restitution_total, @prison_time, @charges, @details, CONCAT((SELECT CURRENT_TIMESTAMP()), " EST"), @reporterName)',
        {eventType = data.eventType, firstname = data.firstname, lastname = data.lastname, registration = data.registration, location = data.location, citation_total = data.citationAmount, restitution_total = data.restitutionAmount, prison_time =  data.prisonTime, charges = data.charges, details = data.details, reporterName = reporterName }, function(rowsChanged)
          Log.write(user_id,"Inserted MDT Arrest. First name: "..data.firstname..", Last Name: "..data.lastname..", Registration: "..data.registration..", Location: "..data.location..", Citation Amt: "..data.citationAmount..", Restitution: "..data.restitutionAmount..", Prison Time: "..data.prisonTime..", Charges: "..data.charges..", Details: "..data.details,Log.log_type.action)
      end)
    end
  end)
end)

RegisterServerEvent('mdt:insertBOLO')
AddEventHandler("mdt:insertBOLO", function(data)
  local user_id = vRP.getUserId({source})
  MySQL.Async.fetchAll('SELECT * FROM vrp_user_identities WHERE user_id = @user_id', {user_id = user_id}, function(rows)
    if rows[1] ~= nil then
      local reporterName = rows[1].firstname.." "..rows[1].name
      MySQL.Async.execute('INSERT INTO cad_mdt(eventType, firstname, lastname, registration, details, inserted_date, inserted_by) VALUES (@eventType, @firstname, @lastname, @registration, @details, CONCAT((SELECT CURRENT_TIMESTAMP()), " EST"), @reporterName)',
        {eventType = data.eventType, firstname = data.firstname, lastname = data.lastname, registration = data.registration, details = data.details, reporterName = reporterName }, function(rowsChanged)
          Log.write(user_id,"Inserted MDT BOLO. First name: "..data.firstname..", Last Name: "..data.lastname..", Registration: "..data.registration..", Details: "..data.details,Log.log_type.action)
      end)
    end
  end)
end)

RegisterServerEvent('mdt:insertWarrant')
AddEventHandler("mdt:insertWarrant", function(data)
  local user_id = vRP.getUserId({source})
  MySQL.Async.fetchAll('SELECT * FROM vrp_user_identities WHERE user_id = @user_id', {user_id = user_id}, function(rows)
    if rows[1] ~= nil then
      local reporterName = rows[1].firstname.." "..rows[1].name
      MySQL.Async.execute('INSERT INTO cad_mdt(eventType, firstname, lastname, registration, description, details, inserted_date, inserted_by) VALUES (@eventType, @firstname, @lastname, @registration, @description, @details, CONCAT((SELECT CURRENT_TIMESTAMP()), " EST"), @reporterName)',
        {eventType = data.eventType, firstname = data.firstname, lastname = data.lastname, registration = data.registration, description = data.description, details = data.details, reporterName = reporterName }, function(rowsChanged)
          Log.write(user_id,"Inserted MDT Wanted. First name: "..data.firstname..", Last Name: "..data.lastname..", Registration: "..data.registration..", Description: "..data.description..", Details: "..data.details,Log.log_type.action)
      end)
    end
  end)
end)

RegisterServerEvent('mdt:searchRecords')
AddEventHandler("mdt:searchRecords", function(data)
  local pSource = source
  local firstname = '%'..data.firstname..'%'
  local lastname = '%'..data.lastname..'%'
  local registration = '%'..data.registration..'%'
  local eventType = data.recordType
  if eventType == "all" then
    eventType = "%%"
  end
  if firstname ~= "%%" and lastname == "%%" and registration == "%%" then -- Search First name only
    MySQL.Async.fetchAll('SELECT * FROM cad_mdt WHERE firstname like @firstname AND eventType like @eventType',
      {firstname = firstname, eventType = eventType}, function(rows)
        if #rows > 0 then
          TriggerClientEvent("mdt:publishRecords", pSource, rows)
        else
          TriggerClientEvent("mdt:clearSearchResults", pSource)
        end
    end)
  elseif firstname == "%%" and lastname ~= "%%" and registration == "%%" then -- Search Last name only
    MySQL.Async.fetchAll('SELECT * FROM cad_mdt WHERE lastname like @lastname AND eventType like @eventType',
      {lastname = lastname, eventType = eventType}, function(rows)
        if #rows > 0 then
          TriggerClientEvent("mdt:publishRecords", pSource, rows)
        else
          TriggerClientEvent("mdt:clearSearchResults", pSource)
        end
    end)
  elseif firstname == "%%" and lastname == "%%" and registration ~= "%%" then -- Search Registration only
    MySQL.Async.fetchAll('SELECT * FROM cad_mdt WHERE registration like @registration AND eventType like @eventType',
      {registration = registration, eventType = eventType}, function(rows)
        if #rows > 0 then
          TriggerClientEvent("mdt:publishRecords", pSource, rows)
        else
          TriggerClientEvent("mdt:clearSearchResults", pSource)
        end
    end)
  elseif firstname ~= "%%" and lastname ~= "%%" and registration == "%%" then -- Search with first name and last name
    MySQL.Async.fetchAll('SELECT * FROM cad_mdt WHERE (firstname like @firstname OR lastname like @lastname) AND eventType like @eventType',
      {firstname = firstname, lastname = lastname, eventType = eventType}, function(rows)
        if #rows > 0 then
          TriggerClientEvent("mdt:publishRecords", pSource, rows)
        else
          TriggerClientEvent("mdt:clearSearchResults", pSource)
        end
    end)
  elseif firstname ~= "%%" and lastname == "%%" and registration ~= "%%" then -- search with first name and registration
    MySQL.Async.fetchAll('SELECT * FROM cad_mdt WHERE (firstname like @firstname OR registration like @registration) AND eventType like @eventType',
      {firstname = firstname, registration = registration, eventType = eventType}, function(rows)
        if #rows > 0 then
          TriggerClientEvent("mdt:publishRecords", pSource, rows)
        else
          TriggerClientEvent("mdt:clearSearchResults", pSource)
        end
    end)
  elseif firstname == "%%" and lastname ~= "%%" and registration ~= "%%" then -- search with last name and registration
    MySQL.Async.fetchAll('SELECT * FROM cad_mdt WHERE (lastname like @lastname OR registration like @registration) AND eventType like @eventType',
      {lastname = lastname, registration = registration, eventType = eventType}, function(rows)
        if #rows > 0 then
          TriggerClientEvent("mdt:publishRecords", pSource, rows)
        else
          TriggerClientEvent("mdt:clearSearchResults", pSource)
        end
    end)
  else -- Search with all three populated or blank
    MySQL.Async.fetchAll('SELECT * FROM cad_mdt WHERE (firstname like @firstname OR lastname like @lastname OR registration like @registration) AND eventType like @eventType',
      {firstname = firstname, lastname = lastname, registration = registration, eventType = eventType}, function(rows)
        if #rows > 0 then
          TriggerClientEvent("mdt:publishRecords", pSource, rows)
        else
          TriggerClientEvent("mdt:clearSearchResults", pSource)
        end
    end)
  end
end)

RegisterServerEvent('mdt:getBoloData')
AddEventHandler("mdt:getBoloData", function(data)
  local pSource = source

  MySQL.Async.fetchAll('SELECT * FROM cad_mdt WHERE eventType = "BOLO"',
    {}, function(rows)
      if #rows > 0 then
        TriggerClientEvent("mdt:sendBoloData", pSource, rows)
      end
  end)
end)

RegisterServerEvent('mdt:deleteWarrant')
AddEventHandler("mdt:deleteWarrant", function(id)
  if id ~= nil then
    MySQL.Async.fetchAll('SELECT * FROM cad_mdt WHERE id = @id',
      {id = id}, function(rows)
        if #rows > 0 then
          MySQL.Async.execute('DELETE FROM cad_mdt where id = @id',{id = tonumber(id)}, function(rowsChanged) end)
          Log.write(user_id,"Deleted MDT Warrant ID: "..id..", First name: "..rows[1].firstname..", Last Name: "..rows[1].lastname..", Registration: "..rows[1].registration..", Description: "..rows[1].description..", Details: "..rows[1].details,Log.log_type.action)
        end
    end)
  end
end)

RegisterServerEvent('mdt:deleteBolo')
AddEventHandler("mdt:deleteBolo", function(id)
  if id ~= nil then
    MySQL.Async.fetchAll('SELECT * FROM cad_mdt WHERE id = @id',
      {id = id}, function(rows)
        if #rows > 0 then
          MySQL.Async.execute('DELETE FROM cad_mdt where id = @id',{id = tonumber(id)}, function(rowsChanged) end)
          Log.write(user_id,"Deleted MDT BOLO ID: "..id..", First name: "..row[1].firstname..", Last Name: "..row[1].lastname..", Registration: "..row[1].registration..", Details: "..row[1].details,Log.log_type.action)
        end
    end)
  end
end)

AddEventHandler('chatMessage', function(from,name,message)
	if(string.sub(message,1,1) == "/") then

		local args = splitString(message)
		local cmd = args[1]
		if cmd == "/mdt" then
			CancelEvent()
			TriggerClientEvent('mdt:show', from)
		end
	end
end)

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
