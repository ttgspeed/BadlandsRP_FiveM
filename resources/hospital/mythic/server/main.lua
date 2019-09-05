local cfg = module('hospital',"mythic/cfg/config")
local Log = module("vrp", "lib/Log")
local beds = cfg.beds

local bedsTaken = {}
local injuryBasePrice = 100

function vRPhs.getInjuries(player)
  local injuries = GetCharsInjuries(player)
  return injuries
end

AddEventHandler('playerDropped', function()
    if bedsTaken[source] ~= nil then
        beds[bedsTaken[source]].taken = false
    end
end)

RegisterServerEvent('mythic_hospital:server:RequestBed')
AddEventHandler('mythic_hospital:server:RequestBed', function(location)
  for k, v in pairs(beds) do
    if not v.takenand and v.location == location then
      v.taken = true
      bedsTaken[source] = k
      local src = source

      local injuries = GetCharsInjuries(src)

      local totalBill = injuryBasePrice

      if injuries ~= nil then
        for k, v in pairs(injuries.limbs) do
          if v.isDamaged then
            totalBill = totalBill + (injuryBasePrice * v.severity)
          end
        end

        if injuries.isBleeding > 0 then
          totalBill = totalBill + (injuryBasePrice * injuries.isBleeding)
        end
      end
      print("Total bill = "..totalBill)


      vRP.request({src, "Pay Medical Fee of $"..totalBill.."?", 15, function(player,ok)
        if ok then
          local user_id = vRP.getUserId({src})
          local result = vRP.tryDebitedPayment({user_id,totalBill})
          if result then
            TriggerClientEvent('mythic_hospital:client:SendToBed', src, k, v)
          end
        end
      end})

      return
    end
  end

  TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'No Beds Available' })
end)

-- This is for /bed function... unused
RegisterServerEvent('mythic_hospital:server:RPRequestBed')
AddEventHandler('mythic_hospital:server:RPRequestBed', function(plyCoords)
  local foundbed = false
  for k, v in pairs(beds) do
    local distance = #(vector3(v.x, v.y, v.z) - plyCoords)
    if distance < 3.0 then
      if not v.taken then
        v.taken = true
        foundbed = true

        TriggerClientEvent('mythic_hospital:client:SendToBed', source, k, v)
        return
      else
        TriggerEvent('mythic_chat:server:System', source, 'That Bed Is Taken')
      end
    end
  end

  if not foundbed then
    TriggerEvent('mythic_chat:server:System', source, 'Not Near A Hospital Bed')
  end
end)

RegisterServerEvent('mythic_hospital:server:EnteredBed')
AddEventHandler('mythic_hospital:server:EnteredBed', function()
  local src = source
  local injuries = GetCharsInjuries(src)

  local totalBill = injuryBasePrice

  if injuries ~= nil then
    for k, v in pairs(injuries.limbs) do
      if v.isDamaged then
        totalBill = totalBill + (injuryBasePrice * v.severity)
      end
    end

    if injuries.isBleeding > 0 then
      totalBill = totalBill + (injuryBasePrice * injuries.isBleeding)
    end
  end
  print("Total bill = "..totalBill)

	-- YOU NEED TO IMPLEMENT YOUR FRAMEWORKS BILLING HERE
	TriggerClientEvent('mythic_hospital:client:FinishServices', src)
end)

RegisterServerEvent('mythic_hospital:server:LeaveBed')
AddEventHandler('mythic_hospital:server:LeaveBed', function(id)
  if id ~= nil and beds[id] ~= nil then
    beds[id].taken = false
  end
end)
