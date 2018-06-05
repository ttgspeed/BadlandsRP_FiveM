-- FiveM Heli Cam by mraes, Version 1.3 (2017-06-12)
-- Modified by rjross2013 (2017-06-23)
-- Further modified by Loque (2017-08-15)

RegisterServerEvent('03497724-b931-4bdc-b5ed-125ab89f70fc')
AddEventHandler('03497724-b931-4bdc-b5ed-125ab89f70fc', function(state)
	local serverID = source
	TriggerClientEvent('50d379ac-8178-440f-a86f-daf6e98c5673', -1, serverID, state)
end)

RegisterServerEvent('efeeef65-eae9-4610-8030-f4eb5fdcbb37')
AddEventHandler('efeeef65-eae9-4610-8030-f4eb5fdcbb37', function(target_netID, target_plate, targetposx, targetposy, targetposz)
	local serverID = source
	TriggerClientEvent('8e005569-c01c-4e7a-91dd-1e7c25344916', -1, serverID, target_netID, target_plate, targetposx, targetposy, targetposz)
end)

RegisterServerEvent('4537caad-1677-4d8e-859e-831cdf33aaa0')
AddEventHandler('4537caad-1677-4d8e-859e-831cdf33aaa0', function()
	local serverID = source
	TriggerClientEvent('7915c128-d2cc-4d6a-852f-958200a8ffae', -1, serverID)
end)

RegisterServerEvent('f7e5ccbc-0d1c-48ba-9f32-1c9f0c83d5fa')
AddEventHandler('f7e5ccbc-0d1c-48ba-9f32-1c9f0c83d5fa', function(pause_Tspotlight)
	local serverID = source
	TriggerClientEvent('b32f6b7c-514b-4d15-865c-bd1e2613c4f6', -1, serverID, pause_Tspotlight)
end)

RegisterServerEvent('c30622c0-c616-4de2-9c57-fea236fb3b85')
AddEventHandler('c30622c0-c616-4de2-9c57-fea236fb3b85', function()
	local serverID = source
	TriggerClientEvent('d1ee5c74-04ad-4ae1-b928-2135986a9a9b', -1, serverID)
end)

RegisterServerEvent('2938c3cc-2af1-4add-bde5-5a43dadd8862')
AddEventHandler('2938c3cc-2af1-4add-bde5-5a43dadd8862', function()
	local serverID = source
	TriggerClientEvent('66cdb535-8e4f-4dd5-9311-b953e16ae7f0', -1, serverID)
end)

RegisterServerEvent('c04cad83-7abc-4441-8642-b2a560072a08')
AddEventHandler('c04cad83-7abc-4441-8642-b2a560072a08', function()
	local serverID = source
	TriggerClientEvent('e271d232-d180-4fdb-a83f-9921cabad88c', -1, serverID)
end)

RegisterServerEvent('496d0515-9309-47d1-b4e5-b80cb77309c8')
AddEventHandler('496d0515-9309-47d1-b4e5-b80cb77309c8', function()
	local serverID = source
	TriggerClientEvent('013a8732-22b4-4cf7-9344-8562c7f51dfa', -1, serverID)
end)

RegisterServerEvent('e0b4eb67-a918-43b5-ae0a-625c3c3c2a75')
AddEventHandler('e0b4eb67-a918-43b5-ae0a-625c3c3c2a75', function()
	local serverID = source
	TriggerClientEvent('e157529e-db22-4561-98e9-6a81caf3869f', -1, serverID)
end)

RegisterServerEvent('608b8c8b-7346-4826-9727-e2d20fadd503')
AddEventHandler('608b8c8b-7346-4826-9727-e2d20fadd503', function()
	local serverID = source
	TriggerClientEvent('d4770c50-be2b-453b-b87e-3a295c0e82bc', -1, serverID)
end)
