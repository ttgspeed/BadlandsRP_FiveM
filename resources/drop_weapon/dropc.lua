RegisterNetEvent("dropweapon")
AddEventHandler('dropweapon', function()
	local ped = GetPlayerPed(-1)
	if DoesEntityExist(ped) and not IsEntityDead(ped) then
		SetPedDropsWeapon(ped)
		ShowNotification("~r~You have dropped your weapon.")
	end
end)


function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end
