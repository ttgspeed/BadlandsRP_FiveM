local Keys = {
	["E"] = 38
}

local robbingBank = false

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

--set the wanted level of the player
RegisterNetEvent('heist:setWantedLevel')
AddEventHandler('heist:setWantedLevel',
	function()
		Citizen.CreateThread(
			function()
				Citizen.Wait(1)
				TriggerEvent("es_roleplay:robbingBank", -1)
				while robbingBank do
					Citizen.Wait(10)
					SetMaxWantedLevel(4)
					SetPoliceIgnorePlayer(PlayerId(), false)
					SetPlayerWantedLevel(PlayerId(), 4, false)
					SetPlayerWantedLevelNow(PlayerId(), false) 
				end
			end
		)

	end
)

RegisterNetEvent('heist:timer')
AddEventHandler('heist:timer',
	function()
		local timer = 300
		robbingBank = true
		Citizen.CreateThread(
			function()
				Citizen.Wait(1)
				while timer > 0 and robbingBank do
					Citizen.Wait(1000)
					timer = timer - 1
					if IsEntityDead(PlayerPedId()) then
						robbingBank = false
					end
				end
				TriggerServerEvent('heist:payout')
				TriggerServerEvent('heist:bankHeistEnd')
				TriggerEvent("es_roleplay:robbingBank", -1)
				robbingBank = false
			end		
		)
		
		Citizen.CreateThread(
			function()
				Citizen.Wait(1)
				while timer > 0 and robbingBank do
					drawTxt(0.515, 0.95, 1.0,1.0,0.4, string.format("Vault Cracked In: %02d",timer), 255, 255, 255, 255)
					Citizen.Wait(1)
				end
			end
		)
	end
)

--	Marker and event start
Citizen.CreateThread(
	function()
		
		x = 254.61827087402
		y = 225.81831359863
		z = 101.87574005127

		--[[
		--default spawn for debug
		x = -258.78100585938
		y = -978.7626953125
		z = 31.219959259033
		]]--
		
		DrawMarker(1, x, y, z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)
		while true do
			Citizen.Wait(1)
			local ped = GetPlayerPed(-1)
			local playerPos = GetEntityCoords(ped, true)

			if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 100.0) then
				DrawMarker(1, x, y, z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)

				if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 2.0) then
					DisplayHelpText("Press ~g~E~s~ to rob bank")

					if IsControlJustReleased(1, Keys['E']) then
						TriggerServerEvent('heist:bankHeistStarted')
					end
				end
			end
		end
	end
)