-- Source https://github.com/nynjardin/outlawalert
-- Modified by serpico for vRP

local cfg = module("cfg/phone")
local services = cfg.services
local service = services["Police"]

RegisterServerEvent('9e0e633a-e1c4-451a-9014-7b8cfcf43408')
AddEventHandler('9e0e633a-e1c4-451a-9014-7b8cfcf43408', function(street1, street2, veh, sex)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
		if veh == "NULL" then
			TriggerClientEvent('463aae12-c6d6-46ec-8a40-3874ba702fd2', v, "Thief of a vehicle by a "..sex.." between "..street1.." and "..street2)
		else
			TriggerClientEvent('463aae12-c6d6-46ec-8a40-3874ba702fd2', v, "Thief of a "..veh.." by a "..sex.." between "..street1.." and "..street2)
		end
	end
end)

RegisterServerEvent('3e2bbe37-685c-427b-b73e-7013d6527002')
AddEventHandler('3e2bbe37-685c-427b-b73e-7013d6527002', function(street1, veh, sex)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
  	if veh == "NULL" then
  		TriggerClientEvent('463aae12-c6d6-46ec-8a40-3874ba702fd2', v, "Thief of a vehicle by a "..sex.." at "..street1)
  	else
  		TriggerClientEvent('463aae12-c6d6-46ec-8a40-3874ba702fd2', v, "Thief of a "..veh.." by a "..sex.." at "..street1)
  	end
	end
end)

RegisterServerEvent('1a35c113-4c55-4e48-8b03-e39e01d61817')
AddEventHandler('1a35c113-4c55-4e48-8b03-e39e01d61817', function(street1, street2, sex)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
		TriggerClientEvent('463aae12-c6d6-46ec-8a40-3874ba702fd2', v, "Fight initiated by a "..sex.." between "..street1.." and "..street2)
	end
end)

RegisterServerEvent('881136c1-bb7b-4f9d-b15b-15df907e5121')
AddEventHandler('881136c1-bb7b-4f9d-b15b-15df907e5121', function(street1, sex)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
		TriggerClientEvent('463aae12-c6d6-46ec-8a40-3874ba702fd2', v, "Fight initiated by a "..sex.." at "..street1)
	end
end)


RegisterServerEvent('f32d543d-5285-4b51-ad88-cb943d7b1710')
AddEventHandler('f32d543d-5285-4b51-ad88-cb943d7b1710', function(street1, street2, sex)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
		TriggerClientEvent('463aae12-c6d6-46ec-8a40-3874ba702fd2', v, "Gunshot by a "..sex.." between "..street1.." and "..street2)
	end
end)

RegisterServerEvent('48b9cf90-f67e-4fb8-92be-438c76105519')
AddEventHandler('48b9cf90-f67e-4fb8-92be-438c76105519', function(street1, sex)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
		TriggerClientEvent('463aae12-c6d6-46ec-8a40-3874ba702fd2', v, "Gunshot by a "..sex.." at "..street1)
	end
end)

RegisterServerEvent('30519e85-698f-485b-a5a7-f9d6b32261a3')
AddEventHandler('30519e85-698f-485b-a5a7-f9d6b32261a3', function(tx, ty, tz)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
	 TriggerClientEvent('cf5403c9-0b68-4fcc-9b31-f84d994d94ca', v, tx, ty, tz)
	end
end)

RegisterServerEvent('54a935cc-33d2-4dfd-9809-df47127c67f9')
AddEventHandler('54a935cc-33d2-4dfd-9809-df47127c67f9', function(gx, gy, gz)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
	 TriggerClientEvent('203e11f6-f7d5-4b35-80ef-750f21ab00a1', v, gx, gy, gz)
	end
end)

RegisterServerEvent('c7798036-420e-447c-b709-0d7a8abfa4ba')
AddEventHandler('c7798036-420e-447c-b709-0d7a8abfa4ba', function(mx, my, mz)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
	 TriggerClientEvent('fdfb1ea7-c5fa-40a8-abc5-bf74330db559', v, mx, my, mz)
	end
end)
