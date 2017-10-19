local threadStarted = false

function tvRP.startCheatCheck()
	if not threadStarted then
		threadStarted = true
		Citizen.CreateThread(function()
		    while threadStarted do
				Citizen.Wait(0)
				local playerPed = GetPlayerPed(-1)
				local playerid = PlayerId()
				local isAdmin = tvRP.isAdmin()

				-- God mode check, health above limits
				if GetEntityHealth(playerPed) > 200 or GetPedArmour(playerPed) > 100 then
					TriggerServerEvent("anticheat:ban", "Anti-Cheat Ban: Scripting / Perm", "Godmode ban. Health/Armor above limits")
				end

				-- God mode check (invinsible flag)
				if not isAdmin then
		      		if not tvRP.isInPrison() and not tvRP.isInComa() then
				      	if (GetPlayerInvincible(playerid)) then
				        	SetEntityInvincible(playerPed, false)
				        	SetPlayerInvincible(playerid, false)
				        	TriggerServerEvent("anticheat:ban", "Anti-Cheat Ban: Scripting / Perm", "Godmode ban. Godmode set by player")
				        end
			      	end
			    end

			    --Invisible check
			    if not isAdmin then
			      	if not IsEntityVisible(playerPed) and tvRP.isCheckDelayed() < 1 then
			        	SetEntityVisible(playerPed, true, false)
			        	TriggerServerEvent("anticheat:ban", "Anti-Cheat Ban: Scripting / Perm", "Invisible/NoClip ban. Action set by player")
			        end
			    end
		    end
		end)
	end
end
