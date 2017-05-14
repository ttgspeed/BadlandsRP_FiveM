Citizen.CreateThread(function()
	while true do
		Wait(1)

		if IsControlJustReleased(1, 167) then
			kmhMode = not kmhMode
		end

		playerPed = GetPlayerPed(-1)
		if playerPed then
			playerCar = GetVehiclePedIsIn(playerPed, false)
			if playerCar and GetPedInVehicleSeat(playerCar, -1) == playerPed then
				carSpeed = GetEntitySpeed(playerCar)
				if kmhMode then
					speed = math.ceil(carSpeed * 3.6)
					prefix = "KM/H"
				else
					speed = math.ceil(carSpeed * 2.236936)
					prefix = "MPH"
				end

				SendNUIMessage({
					showhud = true,
					speed = speed,
					prefix = prefix
				})
			else
				SendNUIMessage({hidehud = true})
			end
		end
	end
end)