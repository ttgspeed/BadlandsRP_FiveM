-- Source https://forum.fivem.net/t/release-cellphone-camera/43599

phone = false
phoneId = 0

local function chatMessage(msg)
	TriggerEvent('chatMessage', '', {0, 0, 0}, msg)
end

phones = {
[0] = "Michael's",
[1] = "Trevor's",
[2] = "Franklin's",
[4] = "Prologue"
}

RegisterNetEvent('camera:phone')
AddEventHandler('camera:phone', function(message)
	local id = tonumber(string.sub(message, 7, 8))

	if id == 0 or id == 1 or id == 2 or id == 4 then
		ChangePhone(id)
	else
		chatMessage("^1/phone [ID]")
		chatMessage("^10 - Michael's phone")
		chatMessage("^11 - Trevor's phone")
		chatMessage("^12 - Franklin's phone")
		chatMessage("^14 - Prologue phone")
	end
end)

function ChangePhone(flag)
	if flag == 0 or flag == 1 or flag == 2 or flag == 4 then
		phoneId = flag
		chatMessage("^2Changed phone to "..phones[flag].." phone")
	end
end

frontCam = false

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

-- RemoveLoadingPrompt()

TakePhoto = N_0xa67c35c56eb1bd9d
WasPhotoTaken = N_0x0d6ca79eeebd8ca3
SavePhoto = N_0x3dec726c25a11bac
ClearPhoto = N_0xd801cc02177fa3f1

Citizen.CreateThread(function()
DestroyMobilePhone()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)

		if IsControlJustPressed(0, 170) and phone == true then -- SELFIE MODE
			frontCam = not frontCam
			CellFrontCamActivate(frontCam)
		end

		if IsControlJustPressed(0, 170) then -- OPEN PHONE
			CreateMobilePhone(phoneId)
			CellCamActivate(true, true)
			phone = true
			TriggerEvent('camera:hideUI',false)
		end

		if IsControlJustPressed(0, 177) and phone == true then -- CLOSE PHONE
			DestroyMobilePhone()
			phone = false
			TriggerEvent('camera:hideUI',true)
			CellCamActivate(false, false)
			if firstTime == true then
				firstTime = false
				Citizen.Wait(2500)
				displayDoneMission = true
			end
		end

		if phone == true then
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(19)
			HideHudAndRadarThisFrame()
		end

		-- If hold F while getting out of vehicle, door will stay open
		-- https://github.com/ToastinYou/KeepMyDoorOpen
		if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
			Citizen.Wait(150)
			if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
				local veh = GetVehiclePedIsIn(ped, false)
				TaskLeaveVehicle(ped, veh, 256)
			end
		end
	end
end)

-----------------
--TRAFFIC DENSITY
--source:https://github.com/TomGrobbe/vBasic/
-----------------
traffic_density = 0.75
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    SetVehicleDensityMultiplierThisFrame(tonumber(traffic_density))
    SetRandomVehicleDensityMultiplierThisFrame(tonumber(traffic_density))
    SetParkedVehicleDensityMultiplierThisFrame(tonumber(traffic_density))
  end
end)

---------------
-- Pickup snowballs
-- https://github.com/TomGrobbe/Snowballs
---------------
Citizen.CreateThread(function()
    showHelp = true
    while true do
        Citizen.Wait(0) -- prevent crashing
        if IsNextWeatherType('XMAS') then -- check for xmas weather type
            RequestAnimDict('anim@mp_snowball') -- pre-load the animation
            if IsControlJustReleased(0, 58) and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not IsPlayerFreeAiming(PlayerId()) and not IsPedSwimming(PlayerPedId()) and not IsPedSwimmingUnderWater(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedRunning(PlayerPedId()) and not IsPedSprinting(PlayerPedId()) then -- check if the snowball should be picked up
                TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 1, 0, 0, 0) -- pickup the snowball
                Citizen.Wait(1950) -- wait 1.95 seconds to prevent spam clicking and getting a lot of snowballs without waiting for animatin to finish.
                GiveWeaponToPed(GetPlayerPed(-1), GetHashKey('WEAPON_SNOWBALL'), 2, false, true) -- get 2 snowballs each time.
            end
        end
        if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_SNOWBALL') then
            -- SetCanAttackFriendly(PlayerPedId(), false, false)
            SetPlayerWeaponDamageModifier(PlayerId(), 0.0)
            SetPedSuffersCriticalHits(PlayerPedId(), false)
        else
            -- SetCanAttackFriendly(PlayerPedId(), true, false)
            SetPedSuffersCriticalHits(PlayerPedId(), true)
        end
    end
end)
