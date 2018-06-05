--[[
---------------------------------------------------
LUXART VEHICLE CONTROL (FOR FIVEM)
---------------------------------------------------
Last revision: NOV 07 2016
Coded by Lt.Caine
---------------------------------------------------
NOTES
	
---------------------------------------------------
]]


RegisterServerEvent('3a7ba253-0ec1-4c63-92cb-31cf0998cfaf')
AddEventHandler('3a7ba253-0ec1-4c63-92cb-31cf0998cfaf', function(toggle)
	TriggerClientEvent('503f3c7c-2ad8-40df-845a-909499d564a2', -1, source, toggle)
end)

RegisterServerEvent('6d2ae693-79d8-4535-828e-2d1cdabbda30')
AddEventHandler('6d2ae693-79d8-4535-828e-2d1cdabbda30', function(newstate)
	TriggerClientEvent('fd674029-6340-4f10-9409-d029c33e6ef5', -1, source, newstate)
end)

RegisterServerEvent('102319c3-1026-423b-9f1c-60b74b68ad86')
AddEventHandler('102319c3-1026-423b-9f1c-60b74b68ad86', function(toggle)
	TriggerClientEvent('a1320829-e55e-4214-b7f4-0b7f255b1348', -1, source, toggle)
end)

RegisterServerEvent('c1492956-9521-46c7-8afb-1b969425694f')
AddEventHandler('c1492956-9521-46c7-8afb-1b969425694f', function(newstate)
	TriggerClientEvent('6bb4bb51-434a-42cc-8241-865b001627c7', -1, source, newstate)
end)

RegisterServerEvent('64480953-9b5e-47be-987e-6bc9e458b9df')
AddEventHandler('64480953-9b5e-47be-987e-6bc9e458b9df', function(newstate)
	TriggerClientEvent('6fdf0ed1-0fb7-4edf-90aa-603544866248', -1, source, newstate)
end)
