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
		    while threadStarted do
				Citizen.Wait(1)
				local playerPed = GetPlayerPed(-1)
				local playerid = PlayerId()
				local isAdmin = tvRP.isAdmin()

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
				if not isAdmin then
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
			    end

			    --Invisible check
			    if not isAdmin then
			      	if not IsEntityVisible(playerPed) and tvRP.isCheckDelayed() < 1 then
			        	SetEntityVisible(playerPed, true, false)
			        	incrementBanTrigger()
			        	if runTimer and banTriggerCount > maxTrigger then
			        		TriggerServerEvent("anticheat:ban", "Player not visible detected "..banTriggerCount.."+ times in 30 seconds. Auto ban applied")
			        	else
			        		TriggerServerEvent("anticheat:log", "Player not visible detected", "Invisible/NoClip ban. Action set by player")
			        	end
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
