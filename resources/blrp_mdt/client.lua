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

RegisterNUICallback('deleteWantedRecord', function(data)
  TriggerServerEvent("mdt:deleteWarrant", data.warrantID)
end)

RegisterNUICallback('deleteBoloRecord', function(data)
  TriggerServerEvent("mdt:deleteBolo", data.boloID)
end)

RegisterNetEvent("mdt:publishRecords")
AddEventHandler("mdt:publishRecords", function(results)
  if results ~= nil and #results > 0 then
    local str = ""
    for k,v in pairs(results) do
      if v.eventType ~= "BOLO" then
        str = str..'<button type="button" class="collapsible '..v.eventType..'Label wanted'..v.id..'">First Name: <b>'..v.firstname..'</b> Name: <b>'..v.lastname..'</b> Registration: <b>'..v.registration..'</b></button>'
        str = str..'<div class="recordcontent wanted'..v.id..'">'
        str = str..'<p><b>Record Type:</b> '..v.eventType..'</p>'
        str = str..'<p><b>First Name:</b> '..v.firstname..'</p>'
        str = str..'<p><b>Last Name:</b> '..v.lastname..'</p>'
        str = str..'<p><b>Registration:</b> '..v.registration..'</p>'
        str = str..'<p><b>Location:</b> '..v.location..'</p>'
        str = str..'<p><b>Details:</b> '..v.details..'</p>'
        str = str..'<p><b>Citation Total:</b> $'..v.citation_total..'</p>'
        str = str..'<p><b>Charges:</b> '..v.charges..'</p>'
        str = str..'<p><b>Restituation Total:</b> $'..v.restitution_total..'</p>'
        str = str..'<p><b>Prison Sentence:</b> '..v.prison_time..' month(s)</p>'
        str = str..'<p><b>Record Date:</b> '..v.inserted_date..'</p>'
        str = str..'<p><b>Record Author:</b> '..v.inserted_by..'</p>'
        if v.eventType == "Warrant" then
          str = str..'<a onclick="deleteWarrant('..v.id..')" class="btn btn-danger btn-sm">'
          str = str..'<span class="text text-white">Delete Warrant</span>'
          str = str..'</a>'
          str = str..'<div class="spacer"></div>'
          str = str..'<div class="spacer"></div>'
        end
        str = str..'</div>'
      end
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
      str = str..'<button type="button" class="collapsible '..v.eventType..'Label bolo'..v.id..'">First Name: <b>'..v.firstname..'</b> Name: <b>'..v.lastname..'</b> Registration: <b>'..v.registration..'</b></button>'
      str = str..'<div class="recordcontent bolo'..v.id..'">'
      str = str..'<p><b>First Name:</b> '..v.firstname..'</p>'
      str = str..'<p><b>Last Name:</b> '..v.lastname..'</p>'
      str = str..'<p><b>Registration:</b> '..v.registration..'</p>'
      str = str..'<p><b>Details:</b> '..v.details..'</p>'
      str = str..'<a onclick="deleteBolo('..v.id..')" class="btn btn-danger btn-sm">'
      str = str..'<span class="text text-white">Delete BOLO</span>'
      str = str..'</a>'
      str = str..'<div class="spacer"></div>'
      str = str..'<div class="spacer"></div>'
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
