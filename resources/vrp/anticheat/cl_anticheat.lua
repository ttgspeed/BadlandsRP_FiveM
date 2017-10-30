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
				if GetEntityHealth(playerPed) > 200 or GetPedArmour(playerPed) > 100 then
					incrementBanTrigger()
		        	if runTimer and banTriggerCount > maxTrigger then
		        		TriggerServerEvent("anticheat:ban", "Player Health/Armor above game limits detected "..banTriggerCount.."+ times in 30 seconds. Auto ban applied")
		        	else
		        		TriggerServerEvent("anticheat:log", "Player Health/Armor above game limits detected", "Godmode ban. Health/Armor above limits")
		        	end
				end

				-- God mode check (invinsible flag)
	      		if not tvRP.isInPrison() and not tvRP.isInComa() then
			      	if (GetPlayerInvincible(playerid)) then
			        	SetEntityInvincible(playerPed, false)
			        	SetPlayerInvincible(playerid, false)
			        	incrementBanTrigger()
			        	if runTimer and banTriggerCount > maxTrigger then
			        		TriggerServerEvent("anticheat:ban", "Player invinsible state detected "..banTriggerCount.."+ times in 30 seconds. Auto ban applied")
			        	else
			        		TriggerServerEvent("anticheat:log", "Player invinsible state detected", "Godmode ban. Godmode set by player")
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

		        -- Prevent unlimited ammo
		        SetPedInfiniteAmmoClip(PlayerPedId(), false)
		    end
		end)
		Citizen.CreateThread(function()
			Citizen.Wait(30000)
		    while threadStarted and not tvRP.isAdmin() do
		    	Citizen.Wait(60000)

				if not tvRP.isInPrison() and not tvRP.isInComa() then
					local curPed = PlayerPedId()
					local curHealth = GetEntityHealth( curPed )
					SetEntityHealth( curPed, curHealth-2)
					-- this will substract 2hp from the current player, wait 50ms and then add it back, this is to check for hacks that force HP at 200
					Citizen.Wait(50)

					if PlayerPedId() == curPed and GetEntityHealth(curPed) == curHealth and GetEntityHealth(curPed) ~= 0 then
						TriggerServerEvent("anticheat:ban", "Player health regen/force health script detected. Auto ban applied")
					elseif GetEntityHealth(curPed) == curHealth-2 then
						SetEntityHealth(curPed, GetEntityHealth(curPed)+2)
					end
				end
		    end
		end)
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
