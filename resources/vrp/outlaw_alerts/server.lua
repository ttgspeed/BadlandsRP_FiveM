-- Source https://github.com/nynjardin/outlawalert
-- Modified by serpico for vRP

local cfg = module("cfg/phone")
local services = cfg.services
local service = services["Police"]

RegisterServerEvent('thiefInProgress')
AddEventHandler('thiefInProgress', function(street1, street2, veh, sex)
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
			TriggerClientEvent("outlawNotify", v, "Thief of a vehicle by a "..sex.." between "..street1.." and "..street2)
		else
			TriggerClientEvent("outlawNotify", v, "Thief of a "..veh.." by a "..sex.." between "..street1.." and "..street2)
		end
	end
end)

RegisterServerEvent('thiefInProgressS1')
AddEventHandler('thiefInProgressS1', function(street1, veh, sex)
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
  		TriggerClientEvent("outlawNotify", v, "Thief of a vehicle by a "..sex.." at "..street1)
  	else
  		TriggerClientEvent("outlawNotify", v, "Thief of a "..veh.." by a "..sex.." at "..street1)
  	end
	end
end)

RegisterServerEvent('meleeInProgress')
AddEventHandler('meleeInProgress', function(street1, street2, sex)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
		TriggerClientEvent("outlawNotify", v, "Fight initiated by a "..sex.." between "..street1.." and "..street2)
	end
end)

RegisterServerEvent('meleeInProgressS1')
AddEventHandler('meleeInProgressS1', function(street1, sex)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
		TriggerClientEvent("outlawNotify", v, "Fight initiated by a "..sex.." at "..street1)
	end
end)


RegisterServerEvent('gunshotInProgress')
AddEventHandler('gunshotInProgress', function(street1, street2, sex)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
		TriggerClientEvent("outlawNotify", v, "Gunshot by a "..sex.." between "..street1.." and "..street2)
	end
end)

RegisterServerEvent('gunshotInProgressS1')
AddEventHandler('gunshotInProgressS1', function(street1, sex)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
		TriggerClientEvent("outlawNotify", v, "Gunshot by a "..sex.." at "..street1)
	end
end)

RegisterServerEvent('thiefInProgressPos')
AddEventHandler('thiefInProgressPos', function(tx, ty, tz)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
	 TriggerClientEvent('thiefPlace', v, tx, ty, tz)
	end
end)

RegisterServerEvent('gunshotInProgressPos')
AddEventHandler('gunshotInProgressPos', function(gx, gy, gz)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
	 TriggerClientEvent('gunshotPlace', v, gx, gy, gz)
	end
end)

RegisterServerEvent('meleeInProgressPos')
AddEventHandler('meleeInProgressPos', function(mx, my, mz)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
	 TriggerClientEvent('meleePlace', v, mx, my, mz)
	end
end)

RegisterServerEvent('terrorismInProgressPos')
AddEventHandler('terrorismInProgressPos', function(gx, gy, gz, message)
	local players = {}
  for k,v in pairs(vRP.rusers) do
    local player = vRP.getUserSource(tonumber(k))
    -- check user
    if vRP.hasPermission(k,service.alert_permission) and player ~= nil then
      table.insert(players,player)
    end
  end
  for k,v in pairs(players) do
		TriggerClientEvent("outlawNotify", v, message)
	 TriggerClientEvent('terrorismPlace', v, gx, gy, gz)
	end
end)
