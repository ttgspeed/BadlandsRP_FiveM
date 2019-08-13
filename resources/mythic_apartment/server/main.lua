RegisterServerEvent('mythic_apartment:server:GetStash')
AddEventHandler('mythic_apartment:server:GetStash', function()
    local src = source
	local mPlayer = exports['mythic_base']:getPlayerFromId(src)
    local cData = mPlayer.getChar().getCharData()
    local owner = 'stash-' .. cData.id
    TriggerEvent('mythic_inventory:server:GetSecondaryInventory', src, owner)
end)