vRP = Proxy.getInterface("vRP")

local Keys = {
	["E"] = 38
}

local robbingBank = false
local heistInProgress = false

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

--sets the status of the heist
RegisterNetEvent('heist:setStatus')
AddEventHandler('heist:setStatus',
	function(status)
		if not status and robbingBank then 
			robbingBank = false
		end
		heistInProgress = status
	end
)

--set the wanted level of the player
RegisterNetEvent('heist:setWantedLevel')
AddEventHandler('heist:setWantedLevel',
	function()
		Citizen.CreateThread(
			function()
				Citizen.Wait(1)
				vRP.setPolice({true})
				robbingBank = true
				while robbingBank do
					Citizen.Wait(10)
					SetMaxWantedLevel(4)
					SetPoliceIgnorePlayer(PlayerId(), false)
					SetPlayerWantedLevel(PlayerId(), 4, false)
					SetPlayerWantedLevelNow(PlayerId(), false) 
				end
				vRP.setPolice({false})
			end
		)

	end
)

--stage 1
RegisterNetEvent('heist:stage1')
AddEventHandler('heist:stage1',
	function()
		local timer = 300
		robbingBank = true
		Citizen.CreateThread(
			function()
				Citizen.Wait(1)
				local died = false
				while timer > 0 and robbingBank and not died do
					Citizen.Wait(1000)
					timer = timer - 1
					if IsEntityDead(PlayerPedId()) then
						died = true
					end
				end
				if not died then

				end
				TriggerEvent('heist:stage2')
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

--stage 2: get to safehouse
RegisterNetEvent('heist:stage2')
AddEventHandler('heist:stage2',
	function()	
		Citizen.CreateThread(
			function()
				Citizen.Wait(1)
				local safehouse = {
					x = -14.561519622803,
					y = -1433.8459472656,
					z = 31.11852645874
				}
				DrawMarker(1, safehouse.x, safehouse.y, safehouse.z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)	
				BLIP = AddBlipForCoord(safehouse.x, safehouse.y, safehouse.z)
				SetBlipSprite(BLIP, 2)
				SetNewWaypoint(safehouse.x, safehouse.y)
				local died = false
				local success = false
				while robbingBank and not died and not success do
					Citizen.Wait(10)
					vRP.missionText({"~r~ Vault has been cracked! Get to the safe house!",.1})
					if IsEntityDead(PlayerPedId()) then
						died = true
					end
					local ped = GetPlayerPed(-1)
					local playerPos = GetEntityCoords(ped, true)
					if (Vdist(playerPos.x, playerPos.y, playerPos.z, safehouse.x, safehouse.y, safehouse.z) < 2.0) then 
						success = true
					end
				end
				if success then
					TriggerServerEvent('heist:payout')
				end
				TriggerServerEvent('heist:bankHeistEnd')
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
		--254.61827087402,225.81831359863,101.87574005127
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

			--check if you are at marker pos
			if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 100.0) then
				DrawMarker(1, x, y, z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)

				if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 2.0) then
					DisplayHelpText("Press ~g~E~s~ to rob bank")

					if IsControlJustReleased(1, Keys['E']) then
						TriggerServerEvent('heist:bankHeistStarted')
					end
				end
			end
						
			--check if you are in vinicity of bank in progress		
			local timer = 30.0
			local pos = GetEntityCoords(ped, false)
			local zone = GetNameOfZone(pos.x, pos.y, pos.z)
			while zone == "DTVINE" and heistInProgress and not robbingBank do
				Citizen.Wait(5)
				drawTxt(1.0, 1.0, 1.0,1.0,0.5,"~r~WARNING: BANK HEIST IN PROGRESS\nSTAYING IN THIS AREA WILL RESULT IN YOU BEING WANTED", 255,1,1,255)
				if timer <= 0 then 
					TriggerEvent('heist:setWantedLevel')
				end
				if IsPedShooting(GetPlayerPed(-1)) then 
					TriggerEvent('heist:setWantedLevel')
				end
				if IsPedInAnyVehicle(ped, false) then
					local speed = GetEntitySpeed(GetVehiclePedIsIn(ped, false)) * 2.236936
					if speed < 20 then 
						timer = timer - .005
					end
				else
					timer = timer - .005
				end
				pos = GetEntityCoords(ped, false)
				zone = GetNameOfZone(pos.x, pos.y, pos.z)
			end
		end
	end
)