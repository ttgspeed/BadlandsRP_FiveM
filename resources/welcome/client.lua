local guiEnabled = false

function EnableGui(enable, shopType)
	SetNuiFocus(enable)
	guiEnabled = enable

	SendNUIMessage({
		type = "enableui",
		enable = enable
	})
end

RegisterNetEvent('displayDisclaimer')
AddEventHandler('displayDisclaimer', function()
  Citizen.CreateThread(function()
    local display = true

    TriggerEvent('disclaimer:display', true)
  end)
end)

RegisterNetEvent('disclaimer:display')
AddEventHandler('disclaimer:display', function(value)
	print("enable ui...")
	EnableGui(value)
end)

RegisterNUICallback('escape', function(data, cb)
	print("closing ui")
	EnableGui(false)
	cb('ok')
end)

RegisterNUICallback('testmessage', function(data, cb)
	print(data.text)
	--TriggerEvent('chatMessage', 'DEV', {255, 0, 0}, data.text)
	cb('ok')
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
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


-- Citizen.CreateThread(function()
-- 	Citizen.Wait(5000)
-- 	print("enable ui...")
-- 	SetNuiFocus(true)
-- 	SendNUIMessage({
-- 		type = "enableui",
-- 		enable = true
-- 	})
-- end)
