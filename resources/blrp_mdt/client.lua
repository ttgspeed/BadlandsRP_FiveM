function enableMDT(toggle)
  SetNuiFocus(toggle, toggle)
  tabletAnim(toggle)
  SendNUIMessage({
    type = "enableui",
    enable = toggle
  })
end

local tabletEntity = nil

function tabletAnim(boolean)
  if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
  	if boolean then
  		loadModels(GetHashKey("prop_cs_tablet"))

  		tabletEntity = CreateObject(GetHashKey("prop_cs_tablet"), GetEntityCoords(PlayerPedId()), true)

  		AttachEntityToEntity(tabletEntity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -0.03, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

      loadModels("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a")

  		TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", 3.0, -8, -1, 63, 0, 0, 0, 0 )

  		Citizen.CreateThread(function()
  			while DoesEntityExist(tabletEntity) do
  				Citizen.Wait(5)

  				if not IsEntityPlayingAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", 3) then
  					TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a", 3.0, -8, -1, 63, 0, 0, 0, 0 )
  				end
  			end

  			ClearPedTasks(PlayerPedId())
  		end)
  	else
      if tabletEntity ~= nil then
        DeleteEntity(tabletEntity)
      end
  	end
  end
end

function loadModels(model)
  if IsModelValid(model) then
		while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(10)
		end
	else
		while not HasAnimDictLoaded(model) do
			RequestAnimDict(model)
			Citizen.Wait(10)
		end
	end
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
