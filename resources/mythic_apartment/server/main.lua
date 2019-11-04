RegisterServerEvent('mythic_apartment:server:GetStash')
AddEventHandler('mythic_apartment:server:GetStash', function()
    local src = source
	local mPlayer = exports['mythic_base']:FetchComponent('Fetch'):Source(src)
    local cData = mPlayer:GetData('character'):GetData()
	local owner = { type = 8, owner = cData.id }
    TriggerEvent('mythic_inventory:server:GetSecondaryInventory', src, owner)
end)