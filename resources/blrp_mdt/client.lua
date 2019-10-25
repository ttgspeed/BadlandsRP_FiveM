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
    TriggerServerEvent("mdt:insert"..eventType, data)
  end
end)

RegisterNUICallback('searchData', function(data)
  if data ~= nil and data.eventType == "searchRecords" then
    eventType = data.eventType
    TriggerServerEvent("mdt:searchRecords", data)
  end
end)

RegisterNUICallback('refreshBoloData', function(data)
  if data ~= nil and data.eventType == "refreshBolo" then
    eventType = data.eventType
    TriggerServerEvent("mdt:getBoloData", data)
  end
end)

RegisterNetEvent("mdt:clearSearchResults")
AddEventHandler("mdt:clearSearchResults", function()
  SendNUIMessage({
    type = "clearResults"
  })
end)

RegisterNetEvent("mdt:publishRecords")
AddEventHandler("mdt:publishRecords", function(results)
  if results ~= nil and #results > 0 then
    local str = ""
    for k,v in pairs(results) do
      str = str..'<button type="button" class="collapsible">First Name: '..v.firstname..' Name: '..v.lastname..' Registration: '..v.registration..'</button>'
      str = str..'<div class="recordcontent">'
      str = str..'<p>Record Type: '..v.eventType..'</p>'
      str = str..'<p>First Name: '..v.firstname..'</p>'
      str = str..'<p>Last Name: '..v.lastname..'</p>'
      str = str..'<p>Registration: '..v.registration..'</p>'
      str = str..'<p>Location: '..v.location..'</p>'
      str = str..'<p>Details: '..v.details..'</p>'
      str = str..'<p>Citation Total: '..v.citation_total..'</p>'
      str = str..'<p>Charges: '..v.charges..'</p>'
      str = str..'<p>Restituation Total: '..v.restitution_total..'</p>'
      str = str..'<p>Prison Sentence: '..v.prison_time..'</p>'
      str = str..'<p>Record Date: '..v.inserted_date..'</p>'
      str = str..'<p>Record Author: '..v.inserted_by..'</p>'
      str = str..'</div>'
    end

    SendNUIMessage({
      type = "publishResults",
      string = str
    })
  end
end)

RegisterNetEvent("mdt:sendBoloData")
AddEventHandler("mdt:sendBoloData", function(results)
  if results ~= nil and #results > 0 then
    local str = ""
    for k,v in pairs(results) do
      str = str..'<button type="button" class="collapsible">First Name: '..v.firstname..' Name: '..v.lastname..' Registration: '..v.registration..'</button>'
      str = str..'<div class="recordcontent">'
      str = str..'<p>First Name: '..v.firstname..'</p>'
      str = str..'<p>Last Name: '..v.lastname..'</p>'
      str = str..'<p>Registration: '..v.registration..'</p>'
      str = str..'<p>Details: '..v.details..'</p>'
      str = str..'</div>'
    end

    SendNUIMessage({
      type = "publishBoloData",
      string = str
    })
  end
end)

RegisterNetEvent("mdt:show")
AddEventHandler("mdt:show", function()
  enableMDT(true)
end)
