vRPcustom = {}
Tunnel.bindInterface("CustomScripts",vRPcustom)
Proxy.addInterface("CustomScripts",vRPcustom)
vRP = Proxy.getInterface("vRP")
vRPserver = Tunnel.getInterface("vRP","CustomScripts")
vRPfuel = Proxy.getInterface("vRP_AdvancedFuel")

-----------------
--TRAFFIC DENSITY
--source:https://github.com/TomGrobbe/vBasic/
-----------------
traffic_density = 0.50
ped_density = 0.50

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local current_zone = GetNameOfZone(pos.x, pos.y, pos.z)
		if current_zone == 'ARMYB' or pos.z < -110.0 then
			SetVehicleDensityMultiplierThisFrame(tonumber(0.0))
			SetRandomVehicleDensityMultiplierThisFrame(tonumber(0.0))
			SetParkedVehicleDensityMultiplierThisFrame(tonumber(0.0))
			SetPedDensityMultiplierThisFrame(tonumber(0.0))
		else
			SetVehicleDensityMultiplierThisFrame(tonumber(traffic_density))
			SetRandomVehicleDensityMultiplierThisFrame(tonumber(traffic_density))
			SetParkedVehicleDensityMultiplierThisFrame(tonumber(traffic_density))
			SetPedDensityMultiplierThisFrame(tonumber(ped_density))
		end
	end
end)

---------------
-- Pickup snowballs
-- https://github.com/TomGrobbe/Snowballs
---------------
-- Snowballs disabled while 24/7 snow.

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

---------------------------------------------------------------
--Source https://github.com/D3uxx/hypr9stun
--Extended stun time

-- Included disable vehicle rewards
---------------------------------------------------------------
local stunTime = 7000 -- in miliseconds >> 1000 ms = 1s

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedBeingStunned(GetPlayerPed(-1)) then
			SetPedMinGroundTimeForStungun(GetPlayerPed(-1), stunTime)
		end
		DisablePlayerVehicleRewards(PlayerId())
	end
end)

---------------------------------------------------------------
--Source https://github.com/indilo53/fxserver-pubg_aim
--PUBG style aiming. Right click will toggle 1/3 mode. Hold it will still act as aiming
---------------------------------------------------------------
local useFirstPerson = false
local justpressed = 0
local lastThirdView = 0

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(1)

		if IsControlPressed(0, 25) then -- Right click/weapon aim
			justpressed = justpressed + 1
		end

		if IsControlJustReleased(0, 25) then -- Right click/weapon aim
			if justpressed < 20 then
				useFirstPerson = true
			end
			justpressed = 0
		end

		if useFirstPerson then
			local currentView = GetFollowPedCamViewMode()
			if currentView ~= 4 then
				lastThirdView = currentView
				SetFollowPedCamViewMode(4)
			else
				SetFollowPedCamViewMode(lastThirdView)
			end
			useFirstPerson = false
		end
	end
end)

RegisterNetEvent('walkstyle')
AddEventHandler('walkstyle', function(style)
	if style ~= "clear" then
		RequestAnimSet(style)
		while not HasAnimSetLoaded(style) do
			Citizen.Wait(0)
		end
		SetPedMovementClipset(GetPlayerPed(-1),style,0.2)
	else
		ResetPedMovementClipset(GetPlayerPed(-1), 0.2)
	end
end)

-- Minimal HUD
local no_hud_active = false
local minimal_hud_active = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if no_hud_active then
			DisplayRadar(false)
			HideHudComponentThisFrame(6) -- Vehicle Name
			HideHudComponentThisFrame(7) -- Area Name
			HideHudComponentThisFrame(8) -- Vehicle Class
			HideHudComponentThisFrame(9) -- Street Name
			HideHudComponentThisFrame(15) -- Subtitle Text (ammo hud)
			HideHudComponentThisFrame(16) -- Radio Stations
		end
		if not IsControlPressed(0, 121) then
			if (IsControlPressed(0, 21) or IsDisabledControlPressed(0, 21)) and (IsControlJustPressed(0, 166) or IsDisabledControlJustPressed(0, 166)) then
				if minimal_hud_active then
					TriggerEvent('vrp:minimalHUDtoggle',true)
					minimal_hud_active = false
				end
				if no_hud_active then
					TriggerEvent('camera:hideUI',true)
					no_hud_active = false
					DisplayRadar(true)
				else
					TriggerEvent('camera:hideUI',false)
					no_hud_active = true
				end
			elseif (IsControlJustPressed(0, 166) or IsDisabledControlJustPressed(0, 166)) then
				if no_hud_active then
					TriggerEvent('camera:hideUI',true)
					no_hud_active = false
					DisplayRadar(true)
				end
				if minimal_hud_active then
					TriggerEvent('vrp:minimalHUDtoggle',true)
					minimal_hud_active = false
				else
					TriggerEvent('vrp:minimalHUDtoggle',false)
					minimal_hud_active = true
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
	   collectgarbage()
	   Wait(10000)
	end
end)
