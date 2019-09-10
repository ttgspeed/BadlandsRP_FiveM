function enableMDT(toggle)
  SetNuiFocus(toggle, toggle)
  SendNUIMessage({
    type = "enableui",
    enable = toggle
  })
end

RegisterNUICallback('escape', function(data, cb)
  enableMDT(false)
end)

RegisterNUICallback('insertData', function(data)
  if data ~= nil and data.eventType ~= nil then
    eventType = data.eventType
    TriggerServerEvent("mdt:"..eventType, data)
  end
end)

RegisterNUICallback('searchData', function(data)
  if data ~= nil and data.eventType == "searchRecords" then
    eventType = data.eventType
    TriggerServerEvent("mdt:searchRecords", data)
  end
end)

RegisterNetEvent("mdt:publishRecords")
AddEventHandler("mdt:publishRecords", function(results)
  print("Search step 2")
  local currentKey = 0
  local string = "<table>"
  for k,v in pairs(results) do
    if k > currentKey then
      if currentKey ~= 0 then
        string = string.."</tr>"
      end
      string = string.."<tr>"
      currentKey = k
    end
    for c,d in pairs(v) do
      string = string.."<td>"..d.."</td>"
    end
  end
  string = string.."</tr></table>"
  SendNUIMessage({
    type = "publishResults",
    string = string
  })
end)

RegisterNetEvent("mdt:show")
AddEventHandler("mdt:show", function()
  enableMDT(true)
end)
