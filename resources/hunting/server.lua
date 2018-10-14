local Tunnel = module("vrp", "panopticon/sv_pano_tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Log = module("vrp", "lib/Log")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_hunting")
Tunnel.initiateProxy()

RegisterServerEvent('hunting:start') -- calls the event from client file
AddEventHandler("hunting:start", function(animal,harvest,amount)
  vRPclient.setJobLabel(source,{amount.." "..animal.." "..harvest})
end)

RegisterServerEvent('hunting:harvest') -- calls the event from client file
AddEventHandler('hunting:harvest', function(type,amount) -- handles the event
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
RegisterServerEvent('hunting:end') -- calls the event from client file
AddEventHandler("hunting:end", function(harvest,harvestTotal,reward)
  local user_id = vRP.getUserId({source})
  if reward ~= 0 then
		if reward > 10000 then
			Log.write(user_id,"[Injection] Attempted to reward $"..reward.." for hunting", Log.log_type.anticheat)
			vRP.ban({source, user_id.." Scripting perm (serpickle)", 0})
		end
    vRP.tryGetInventoryItem({user_id, harvest, harvestTotal, false})
    vRP.giveMoney({user_id,reward})
    vRPclient.notify(source,{"You sold your goods for $"..reward})
  end
  vRPclient.setJobLabel(source,{"Unemployed"})
end)
