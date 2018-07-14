-- author https://forum.fivem.net/u/thespartapt
-- modified byt https://github.com/TheSpartaPT/FiveM-ES-CarWash and https://forum.fivem.net/t/release-carwash/9615

--DO-NOT-EDIT-BELLOW-THIS-LINE--

Key = 201 -- ENTER

vehicleWashStation = {
	{26.357481002808,-1391.9879150391,29.363983154297},
	{170.57823181152,-1718.3736572266,29.301683425903},
	{-74.070068359375,6428.0239257813,31.43995475769},
	{-699.9755859375,-932.71099853516,19.013917922974}
}

Citizen.CreateThread(function ()
	Citizen.Wait(0)
	for i = 1, #vehicleWashStation do
		garageCoords = vehicleWashStation[i]
		stationBlip = AddBlipForCoord(garageCoords[1], garageCoords[2], garageCoords[3])
		SetBlipSprite(stationBlip, 100) -- 100 = carwash
		SetBlipAsShortRange(stationBlip, true)
	end
  return
end)

function DrawSpecialText(m_text, showtime)
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
    local ped = GetPlayerPed(-1)
		if IsPedSittingInAnyVehicle(ped) then
			for i = 1, #vehicleWashStation do
				garageCoords2 = vehicleWashStation[i]
        if IsEntityAtCoord(ped, garageCoords2[1], garageCoords2[2], garageCoords2[3], 40.001, 40.001, 5.001, 0, 1, 0) then
          DrawMarker(23, garageCoords2[1], garageCoords2[2], garageCoords2[3]-1.0, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
          if IsEntityAtCoord(ped, garageCoords2[1], garageCoords2[2], garageCoords2[3], 5.001, 5.001, 5.001, 0, 1, 0) then
  					DrawSpecialText("Press [~g~ENTER~s~] to clean your vehicle!")
  					if(IsControlJustPressed(1, Key)) then
  						SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)),0)
  						SetVehicleUndriveable(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)
  						msg = "Vehicle ~y~Clean~s~!"
  						DrawSpecialText(msg, 5000)
  						Wait(5000)
  					end
          end
				end
			end
		end
	end
end)
