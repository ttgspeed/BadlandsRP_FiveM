RegisterServerEvent('mdt:warningInsert')
AddEventHandler("mdt:warningInsert", function(data)
  MySQL.Async.execute('INSERT INTO cad_mdt(eventType, firstname, lastname, registration, location, details) VALUES (@eventType, @firstname, @lastname, @registration, @location, @details)',
    {eventType = data.eventType, firstname = data.firstname, lastname = data.lastname, registration = data.registration, location = data.location, details = data.details }, function(rowsChanged) end)
end)

RegisterServerEvent('mdt:citationInsert')
AddEventHandler("mdt:citationInsert", function(data)
  MySQL.Async.execute('INSERT INTO cad_mdt(eventType, firstname, lastname, registration, location, citation_total, charges, details) VALUES (@eventType, @firstname, @lastname, @registration, @location, @citation_total, @charges, @details)',
    {eventType = data.eventType, firstname = data.firstname, lastname = data.lastname, registration = data.registration, location = data.location, citation_total = data.citationAmount, charges = data.charges, details = data.details }, function(rowsChanged) end)
end)

RegisterServerEvent('mdt:arrestInsert')
AddEventHandler("mdt:arrestInsert", function(data)
  MySQL.Async.execute('INSERT INTO cad_mdt(eventType, firstname, lastname, registration, location, citation_total, restitution_total, prison_time, charges, details) VALUES (@eventType, @firstname, @lastname, @registration, @location, @citation_total, @restitution_total, @prison_time, @charges, @details)',
    {eventType = data.eventType, firstname = data.firstname, lastname = data.lastname, registration = data.registration, location = data.location, citation_total = data.citationAmount, restitution_total = data.restitutionAmount, prison_time =  data.prisonTime, charges = data.charges, details = data.details }, function(rowsChanged) end)
end)

RegisterServerEvent('mdt:boloInsert')
AddEventHandler("mdt:boloInsert", function(data)
  MySQL.Async.execute('INSERT INTO cad_mdt(eventType, firstname, lastname, registration, details) VALUES (@eventType, @firstname, @lastname, @registration, @details)',
    {eventType = data.eventType, firstname = data.firstname, lastname = data.lastname, registration = data.registration, details = data.details }, function(rowsChanged) end)
end)

RegisterServerEvent('mdt:warrantInsert')
AddEventHandler("mdt:warrantInsert", function(data)
  MySQL.Async.execute('INSERT INTO cad_mdt(eventType, firstname, lastname, registration, description, details) VALUES (@eventType, @firstname, @lastname, @registration, @description, @details)',
    {eventType = data.eventType, firstname = data.firstname, lastname = data.lastname, registration = data.registration, description = data.description, details = data.details }, function(rowsChanged) end)
end)

RegisterServerEvent('mdt:searchRecords')
AddEventHandler("mdt:searchRecords", function(data)
  local pSource = source
  local firstname = '%'..data.firstname..'%'
  local lastname = '%'..data.lastname..'%'
  local registration = '%'..data.registration..'%'
  print(firstname)
  MySQL.Async.fetchAll('SELECT * FROM cad_mdt WHERE firstname like @firstname OR lastname like @lastname OR registration like @registration',
    {firstname = firstname, lastname = lastname, registration = registration}, function(rows)
      if #rows > 0 then
        TriggerClientEvent("mdt:publishRecords", pSource, rows)
      else
        print("no results found")
      end
  end)
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
