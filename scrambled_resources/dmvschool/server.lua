--[[Info]]--

-- require "resources/essentialmode/lib/MySQL"
-- MySQL:open("127.0.0.1", "DBNAME", "root", "password")



--[[Register]]--

RegisterServerEvent('11d4c114-22d8-41c5-be7c-8045bcae3cd9')
RegisterServerEvent('99860454-d585-4b5c-922a-0c6ebb990fbb')
RegisterServerEvent('11b8f044-25bd-4e91-890b-75fbc87e7b00')
RegisterServerEvent('ada0755c-07de-4147-8828-1ff70e78ce31')

--[[DMV TheoryTest]]--

AddEventHandler('11d4c114-22d8-41c5-be7c-8045bcae3cd9', function()
	-- TriggerEvent('fd051362-29f6-4232-bdfc-f5b7bdd90c2f', source, function(player)
	-- 	--MySQL:executeQuery("UPDATE users SET DmvTest='Passed' WHERE identifier = '@username'", { ['@username'] = player.identifier})
	-- end)
end)

AddEventHandler('11b8f044-25bd-4e91-890b-75fbc87e7b00', function()
end)

AddEventHandler('ada0755c-07de-4147-8828-1ff70e78ce31', function()
end)

--[[ ***** SPAWN CHECK ***** ]]
AddEventHandler('99860454-d585-4b5c-922a-0c6ebb990fbb', function()
		TriggerClientEvent('dmv:CheckLicStatus',source)
end)
