-- Author Kai McKee / MoistGoat

local holstered = true
local DisableStuff = false
local isCop = false
local equipedWeapon = nil
local weaponlist = {
	"WEAPON_KNIFE",
	"WEAPON_DAGGER",
	"WEAPON_BOTTLE",
	"WEAPON_STUNGUN",
	"WEAPON_FLASHLIGHT",
	"WEAPON_NIGHTSTICK",
	"WEAPON_HAMMER",
	"WEAPON_PISTOL",
	"WEAPON_SNSPISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_REVOLVER",
}

-- Fix timings when weapon is disabled
-- Try to get hash of current weapon
-- Find holster animation for cop
-- Changing to another weapon in the list doesn't trigger holstering (or other weapons)
-- Timings probably need changing
-- Need a way of getting the current weapon to make it visible when holstering (Line 66)
-- Has timers implemented that disable weapon usage for 2 seconds as per Badlands current time.
-- More weapons could be added I guess, and knife animation could differ from the pulling out back of pants.

RegisterNetEvent('CustomScripts:setCop')
AddEventHandler('CustomScripts:setCop', function(toggle)
	if toggle ~= nil then
		isCop = toggle
	end
end)


 Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped, true) then
			if GetIsTaskActive(ped, 56) then
				if canPlayAnimation(ped) then
					if holstered then
						if isCop then --If I'm a cop, play this exclusively
							loadAnimDict( "rcmjosh4" )
							loadAnimDict( "reaction@intimidation@cop@unarmed" )
							TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, 1400, 50, 10.0, 0, 0, 0 )
							SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
							DisableStuff = true
							Citizen.Wait(1400)
							TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 5.0, 2.0, 400, 48, 10, 0, 0, 0 )
							Citizen.Wait(300)
							SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
							Citizen.Wait(300)
							ClearPedTasks(ped)
							holstered = false
							DisableStuff = false
						else
							loadAnimDict( "reaction@intimidation@1h" )
							TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 8.0, 2.0, 1700, 48, 10, 0, 0, 0 )
							SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
							DisableStuff = true
							Citizen.Wait(1300)
							SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
							Citizen.Wait(700)
							ClearPedTasks(ped)
							holstered = false
							DisableStuff = false
						end
						equipedWeapon = CurrentWeapon(ped)
					end

				elseif not canPlayAnimation(ped) then
					if not holstered then
						if isCop then
							loadAnimDict( "weapons@pistol@" )
							TaskPlayAnim(ped, "weapons@pistol@", "aim_2_holster", 8.0, 2.0, -1, 48, 10, 0, 0, 0 ) -- COP ANIM
						else
							loadAnimDict( "reaction@intimidation@1h" )
							TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 2.0, 1700, 48, 10, 0, 0, 0 )
						end
						DisableStuff = true
						SetCurrentPedWeapon(ped, GetHashKey(equipedWeapon), true) -- This needs to recognize current weapon set it so it appears when holstering. Hex stuff /shrug
						Citizen.Wait(1300)
						SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)

						Citizen.Wait(700)
						ClearPedTasks(ped)
						holstered = true
						DisableStuff = false
						equipedWeapon = nil
					end
				end
			end
		end
	end
end)

function canPlayAnimation(ped)
	currentWeapon = GetSelectedPedWeapon(ped)
	for k,v in pairs(weaponlist) do
		if GetHashKey(v) == currentWeapon then
			return true
		end
	end
	return false
end

function CurrentWeapon(ped)
	currentWeapon = GetSelectedPedWeapon(ped)
	for k,v in pairs(weaponlist) do
		if GetHashKey(v) == currentWeapon then
			return v
		end
	end
	return nil
end

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end
