local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_hunting")

RegisterServerEvent('7c9afc2f-3bc5-480c-92e2-26104778d488') -- calls the event from client file
AddEventHandler('7c9afc2f-3bc5-480c-92e2-26104778d488', function(animal,harvest,amount)
  vRPclient.setJobLabel(source,{amount.." "..animal.." "..harvest})
end)

RegisterServerEvent('4ba21ad3-861a-4302-9172-613b6af70e67') -- calls the event from client file
AddEventHandler('4ba21ad3-861a-4302-9172-613b6af70e67', function(type,amount) -- handles the event
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})

    vRPclient.setActionLock(player,{true})
    vRPclient.playAnim(player,{false,{task="CODE_HUMAN_MEDIC_KNEEL"},false})
    SetTimeout(10000, function()
      vRPclient.stopAnim(player,{false})
      vRPclient.setActionLock(player,{false})

      vRP.giveInventoryItem({user_id,type,amount})
    end)
end)

-- player spawn
RegisterServerEvent('a632cb83-289e-47db-810b-790f5fbbdcc8') -- calls the event from client file
AddEventHandler('a632cb83-289e-47db-810b-790f5fbbdcc8', function(harvest,harvestTotal,reward)
  local user_id = vRP.getUserId({source})
  local player = vRP.getUserSource({user_id})
  if reward ~= 0 then
    vRP.tryGetInventoryItem({user_id, harvest, harvestTotal, false})
    vRP.giveMoney({user_id,reward})
    vRPclient.notify(player,{"You sold your goods for $"..reward})
  end
  vRPclient.setJobLabel(player,{"Unemployed"})
end)
