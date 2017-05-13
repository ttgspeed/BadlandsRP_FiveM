local carWashes = {
	{name="Lave-auto", id=100, x= -700.00, y= -932.59, z= 19.01},
	{name="Lave-auto", id=100, x= 170.85, y= -1718.23, z= 29.30},
	{name="Lave-auto", id=100, x= 21.74, y= -1392.35, z= 29.32},
	{name="Lave-auto", id=100, x= 1363.72, y= 3592.51, z= 34.91},
}

local function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline, center)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
	if(center)then
		Citizen.Trace("CENTER\n")
		SetTextCentre(false)
	end
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

local displayingBoughtMessage = false

Citizen.CreateThread(function()
	for _, item in pairs(carWashes) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end
	
	while true do
		Citizen.Wait(0)

		if(displayingBoughtMessage)then
			DisplayHelpText("You ~g~washed~w~ your vehicle!")
			Citizen.Wait(3000)
			displayingBoughtMessage = false
		end

		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		for k,v in pairs(carWashes)do
			if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 55.0)then
				DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 2.4001, 2.4001, 0.8001, 0, 75, 255, 165, 0,0, 0,0)

				if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 2.0 and displayingBoughtMessage == false)then
					if(IsPedInAnyVehicle(GetPlayerPed(-1),  false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)), -1) == GetPlayerPed(-1))then
						if(GetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(-1),  false)) < 2)then
							DisplayHelpText("Your ~b~vehicle~w~ is already clean.")
						else
							DisplayHelpText("Press ~INPUT_CONTEXT~ to ~g~wash~w~ your ~b~vehicle~w~ for ~g~50~w~ pounds.")

							if(IsControlJustReleased(1, 51))then
								TriggerServerEvent('es_roleplay:washCar', k)
								SetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(-1),  false),  0.0000000001)

								displayingBoughtMessage = true
							end
						end
					end
				end
			end
		end
	end
end)