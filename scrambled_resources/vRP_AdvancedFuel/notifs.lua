function showDoneNotif(mes)
	SendNUIMessage({
		showDone = true,
		text = mes
	})
end

function showWarnNotif(mes)
	SendNUIMessage({
		showWarn = true,
		text = mes
	})
end

RegisterNetEvent('a5b59dfd-f41a-49ce-991b-05754b5959d4')
AddEventHandler('a5b59dfd-f41a-49ce-991b-05754b5959d4', function(mes)
	SendNUIMessage({
		showError = true,
		text = mes
	})
end)

function showNoneNotif(mes)
	SendNUIMessage({
		showNone = true,
		text = mes
	})
end

