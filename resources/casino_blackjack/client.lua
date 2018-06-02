local guiEnabled = false

local casinos_blackjack = {
	[1] = {x=918.21380615234,y=50.38024520874,z=80.76481628418},
	--[2] = {x=-1590.1925048828,y=-3040.2111816406,z=13.944696426392}, --debug LSIA warehouse, do not enable on prod
}

RegisterNetEvent('casino:buyin.cb')
AddEventHandler('casino:buyin.cb', function(amount)
	print(amount)
	EnableGui(true,amount)
end)

local function AddBlips()
	for i,pos in ipairs(casinos_blackjack) do
		local blip = AddBlipForCoord(pos.x,pos.y,pos.z)
		SetBlipSprite(blip, 214)
		SetBlipAsShortRange(blip,true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Casino")
		EndTextCommandSetBlipName(blip)
	end
end

function DisplayHelpText(str)
		SetTextComponentFormat("STRING")
		AddTextComponentString(str)
		DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function EnableGui(enable, buyin)
	SetNuiFocus(enable)
	guiEnabled = enable

	SendNUIMessage({
		type = "enableui",
		enable = enable,
		credits = buyin
	})
end

RegisterNUICallback('escape', function(data, cb)
	print("closing ui")
	EnableGui(false)
	cb('ok')
	TriggerServerEvent('casino:cashOut')
end)

RegisterNUICallback('testmessage', function(data, cb)
	print(data.text)
	--TriggerEvent('chatMessage', 'DEV', {255, 0, 0}, data.text)
	cb('ok')
end)

RegisterNUICallback('makeBet', function(data, cb)
	print(data.amount)
	TriggerServerEvent('casino:makeBet', data.amount)
	cb('ok')
end)

RegisterNUICallback('resolveBet', function(data, cb)
	print(data.amount)
	TriggerServerEvent('casino:resolveBet', data.amount)
	cb('ok')
end)

Citizen.CreateThread(function()
	AddBlips()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local pedpos = GetEntityCoords(ped, nil)

		for i,pos in ipairs(casinos_blackjack) do
			if GetDistanceBetweenCoords(pos.x,pos.y,pos.z,GetEntityCoords(ped)) <= 50.001 then
				DrawMarker(23, pos.x,pos.y,pos.z-1+0.01, 0, 0, 0, 0, 0, 0, 10.0001, 10.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)
				if GetDistanceBetweenCoords(pos.x,pos.y,pos.z,GetEntityCoords(ped)) <= 5.001 then
					if IsControlJustPressed(1,201) then
						TriggerServerEvent('casino:buyin')
					else
						DisplayHelpText("Press ~b~ENTER~w~ to play Blackjack")
					end
				end
			end
		end

		if guiEnabled then
			DisableControlAction(1, 18, true)
			DisableControlAction(1, 24, true)
			DisableControlAction(1, 69, true)
			DisableControlAction(1, 92, true)
			DisableControlAction(1, 106, true)
			DisableControlAction(1, 122, true)
			DisableControlAction(1, 135, true)
			DisableControlAction(1, 142, true)
			DisableControlAction(1, 144, true)
			DisableControlAction(1, 176, true)
			DisableControlAction(1, 223, true)
			DisableControlAction(1, 229, true)
			DisableControlAction(1, 237, true)
			DisableControlAction(1, 257, true)
			DisableControlAction(1, 329, true)

			DisableControlAction(1, 14, true)
			DisableControlAction(1, 16, true)
			DisableControlAction(1, 41, true)
			DisableControlAction(1, 43, true)
			DisableControlAction(1, 81, true)
			DisableControlAction(1, 97, true)
			DisableControlAction(1, 180, true)
			DisableControlAction(1, 198, true)
			DisableControlAction(1, 39, true)
			DisableControlAction(1, 50, true)

			DisableControlAction(1, 22, true)
			DisableControlAction(1, 55, true)
			DisableControlAction(1, 76, true)
			DisableControlAction(1, 102, true)
			DisableControlAction(1, 114, true)
			DisableControlAction(1, 143, true)
			DisableControlAction(1, 179, true)
			DisableControlAction(1, 193, true)
			DisableControlAction(1, 203, true)
			DisableControlAction(1, 216, true)
			DisableControlAction(1, 255, true)
			DisableControlAction(1, 298, true)
			DisableControlAction(1, 321, true)
			DisableControlAction(1, 328, true)
			DisableControlAction(1, 331, true)

			if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
				SendNUIMessage({
					type = "click"
				})
			end
		end
	end
end)
