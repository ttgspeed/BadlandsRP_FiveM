local Keys = {["E"] = 38,["ENTER"] = 18}

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local pos = GetEntityCoords(ped, nil)

		DisplayHelpText("~w~Press ~g~E~w~ to do something")
		if (IsControlJustReleased(1, Keys['E'])) then
			--do something
		end
	end
end)
