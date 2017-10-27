--[[Info]]--

-- require "resources/essentialmode/lib/MySQL"
-- MySQL:open("127.0.0.1", "DBNAME", "root", "password")



--[[Register]]--

RegisterServerEvent("dmv:success")
RegisterServerEvent("dmv:LicenseStatus")
RegisterServerEvent("dmv:ttcharge")
RegisterServerEvent("dmv:dtcharge")

--[[DMV TheoryTest]]--

AddEventHandler("dmv:success", function()
	-- TriggerEvent("es:getPlayerFromId", source, function(player)
	-- 	--MySQL:executeQuery("UPDATE users SET DmvTest='Passed' WHERE identifier = '@username'", { ['@username'] = player.identifier})
	-- end)
end)

AddEventHandler("dmv:ttcharge", function()
end)

AddEventHandler("dmv:dtcharge", function()
end)

--[[ ***** SPAWN CHECK ***** ]]
AddEventHandler("dmv:LicenseStatus", function()
		TriggerClientEvent('dmv:CheckLicStatus',source)
end)
