local threadStarted = false
local banTriggerCount = 0
local runTimer = false
local timeToReset = 0
local maxTrigger = 3

function tvRP.startCheatCheck()
	if not threadStarted then
		threadStarted = true
		Citizen.CreateThread(function()
			Citizen.Wait(30000)
		    while threadStarted and not tvRP.isAdmin() do
				Citizen.Wait(1)
				local playerPed = GetPlayerPed(-1)
				local playerid = PlayerId()

				-- God mode check, health above limits
				local health = GetEntityHealth(playerPed)
				local armor =  GetPedArmour(playerPed)
				if health > 200 or armor > 100 then
					incrementBanTrigger()
		        	if runTimer and banTriggerCount > maxTrigger then
		        		TriggerServerEvent("anticheat:ban", "Player Health = "..health.." and/or Armor = "..armor.." above game limits detected "..banTriggerCount.."+ times in 30 seconds. Auto ban applied")
		        	else
		        		TriggerServerEvent("anticheat:log", "Player Health = "..health.." and/or Armor = "..armor.." above game limits detected", "Godmode ban. Health/Armor above limits")
		        	end
				end

				-- God mode check (invincible flag)
	      		if not tvRP.isInPrison() and not tvRP.isInComa() then
			      	if (GetPlayerInvincible(playerid)) then
			        	SetEntityInvincible(playerPed, false)
			        	SetPlayerInvincible(playerid, false)
			        	incrementBanTrigger()
			        	if runTimer and banTriggerCount > maxTrigger then
			        		TriggerServerEvent("anticheat:ban", "Player invincible state detected "..banTriggerCount.."+ times in 30 seconds. Auto ban applied")
			        	else
			        		TriggerServerEvent("anticheat:log", "Player invincible state detected", "Godmode ban. Godmode set by player")
			        	end
			        end
		      	end

			    --Invisible check
					if not IsEntityVisible(playerPed) and tvRP.isCheckDelayed() < 1 and not tvRP.getDriveTestStatus() then
					SetEntityVisible(playerPed, true, false)
					incrementBanTrigger()
					if runTimer and banTriggerCount > maxTrigger then
						TriggerServerEvent("anticheat:ban", "Player not visible detected "..banTriggerCount.."+ times in 30 seconds. Auto ban applied")
					else
						TriggerServerEvent("anticheat:log", "Player not visible detected", "Invisible/NoClip ban. Action set by player")
					end
				end
				-- Check for night vision. Currtently not used in the server
				if IsNightvisionActive(playerPed) then
					TriggerServerEvent("anticheat:ban", "Player night vision detected. Auto ban applied")
				end
				-- Check for termal vision. Currtently not used in the server
				if IsSeethroughActive(playerPed) then
					TriggerServerEvent("anticheat:ban", "Player thermal vision detected. Auto ban applied")
				end

		        -- Prevent unlimited ammo
		        SetPedInfiniteAmmoClip(PlayerPedId(), false)
		        -- prevent player from going invisible using alpha values
		        ResetEntityAlpha(PlayerPedId())
		    end
		end)
		-- Teleport/No clip detection
		Citizen.CreateThread(function()
			Citizen.Wait(30000)
			while threadStarted and not tvRP.isAdmin() do
				Citizen.Wait(0)
				local ped = PlayerPedId()
				local posx,posy,posz = table.unpack(GetEntityCoords(ped,true))
				local still = IsPedStill(ped)
				local vel = GetEntitySpeed(ped)
				local ped = PlayerPedId()
				local veh = IsPedInAnyVehicle(ped, true)

				Wait(3000) -- wait 3 seconds and check again
				if not tvRP.getDriveTestStatus() and tvRP.isCheckDelayed() < 1 and not tvRP.isInPrison() then
					newx,newy,newz = table.unpack(GetEntityCoords(ped,true))
					newPed = PlayerPedId() -- make sure the peds are still the same, otherwise the player probably respawned
					local distanceTravelled = GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz)
					if distanceTravelled > 600 and still == IsPedStill(ped) and vel == GetEntitySpeed(ped) and ped == newPed then
						TriggerServerEvent("anticheat:ban", "Player teleport/noclip detected. Distance travelled in 3 seconds =  "..distanceTravelled.." meters. First position = "..posx..","..posy..", "..posz.." Second postion = "..newx..", "..newy..", "..newz..". Auto ban applied")
					end
				end
			end
		end)
		--[[
		Citizen.CreateThread(function()
			Citizen.Wait(30000)
		    while threadStarted and not tvRP.isAdmin() do
		    	Citizen.Wait(300000)

				if not tvRP.isInPrison() and not tvRP.isInComa() then
					if not healthRegenCheck() then
						TriggerServerEvent("anticheat:log", "Player health regen/force health script detected")
						local recheck = true
						while recheck do
							Citizen.Wait(100)
							if not healthRegenCheck() then
								incrementBanTrigger()
								if runTimer and banTriggerCount > maxTrigger then
									TriggerServerEvent("anticheat:ban", "Player health regen/force health script detected "..banTriggerCount.."+ times in 30 seconds. Auto ban applied")
								else
									TriggerServerEvent("anticheat:log", "Player health regen/force health script detected")
								end
							else
								recheck = false
							end
						end
					end
				end
		    end
		end)
		]]--
	end
end

function healthRegenCheck()
	local curPed = PlayerPedId()
	local curHealth = GetEntityHealth(curPed)
	SetEntityHealth( curPed, curHealth-2)
	-- this will substract 2hp from the current player, wait 50ms and then add it back, this is to check for hacks that force HP at 200
	Citizen.Wait(50)

	if PlayerPedId() == curPed and GetEntityHealth(curPed) == curHealth and GetEntityHealth(curPed) ~= 0 then
		SetEntityHealth(curPed, GetEntityHealth(curPed)+2)
		return false
	elseif GetEntityHealth(curPed) == curHealth-2 then
		SetEntityHealth(curPed, GetEntityHealth(curPed)+2)
		return true
	end
end

function incrementBanTrigger()
	if not runTimer then
		runTimer = true
		timeToReset = 30
		Citizen.CreateThread(function() -- coma decrease thread
			while runTimer do
				Citizen.Wait(1000)
				timeToReset = timeToReset-1
				if timeToReset < 1 then
					banTriggerCount = 0
				end
			end
		end)
	end
	banTriggerCount = banTriggerCount + 1
end
