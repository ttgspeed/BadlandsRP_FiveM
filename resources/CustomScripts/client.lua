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
        else
        	if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_SNOWBALL') then
        		ClearPedSecondaryTask(GetPlayerPed(-1))
        	end
        	RemoveWeaponFromPed(GetPlayerPed(-1),0x787F0BB) -- WEAPON_SNOWBALL
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

------------------------------------------------------------------
-- Remove weapons rewards from vehicles. Prevent known exploit
-- Original only deals with police vehicles
-- https://forum.fivem.net/t/release-police-vehicle-weapon-deleter/39514
------------------------------------------------------------------

local vehWeapons = {
	0x1D073A89, -- ShotGun
	0x83BF0278, -- Carbine
	0x5FC3C11, -- Sniper
	0x1B06D571, -- Pistol
	0x2BE6766B, -- SMG
	0x440E4788, -- Golf club
	0x958A4A8F, -- Bat
	0x4E875F73, -- Hammer
	0x99B507EA, -- Knife
	0x84BD7BFD, -- Crowbar
	0xBFD21232, -- SNS
	0x083839C4, -- Vintage
	0xC1B3C3D1, -- Revolver
	0x99AEEB3B, -- Pistol50
	0xF9E6AA4B, -- Bottle
	0x92A27487, -- Dagger
	0x34A67B97, -- Petrol Can
}


local hasBeenInVehicle = false

local alreadyHaveWeapon = {}

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)

		if(IsPedInAnyVehicle(GetPlayerPed(-1))) then
			if(not hasBeenInVehicle) then
				hasBeenInVehicle = true
			end
		else
			if(hasBeenInVehicle) then
				for i,k in pairs(vehWeapons) do
					if(not alreadyHaveWeapon[i]) then
						TriggerEvent("PoliceVehicleWeaponDeleter:drop",k)
					end
				end
				hasBeenInVehicle = false
			end
		end

	end

end)


Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)
		if(not IsPedInAnyVehicle(GetPlayerPed(-1))) then
			for i=1,#vehWeapons do
				if(HasPedGotWeapon(GetPlayerPed(-1), vehWeapons[i], false)==1) then
					alreadyHaveWeapon[i] = true
				else
					alreadyHaveWeapon[i] = false
				end
			end
		end
		Citizen.Wait(5000)
	end

end)


RegisterNetEvent("PoliceVehicleWeaponDeleter:drop")
AddEventHandler("PoliceVehicleWeaponDeleter:drop", function(wea)
	RemoveWeaponFromPed(GetPlayerPed(-1), wea)
end)

------------------------------------------------------------------
-- Leave engine running unless you turn it off
-- https://github.com/ToastinYou/LeaveEngineRunning
------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local ped = GetPlayerPed(-1)

		if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
			local engineWasRunning = GetIsVehicleEngineRunning(GetVehiclePedIsIn(ped, true))
			Citizen.Wait(1000)
			if DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) and not IsEntityDead(ped) and not IsPauseMenuActive() then
				local veh = GetVehiclePedIsIn(ped, true)
				if (engineWasRunning) then
					SetVehicleEngineOn(veh, true, true, true)
				end
			end
		end
	end
end)

