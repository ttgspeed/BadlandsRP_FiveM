local threadStarted = false
local banTriggerCount = 0
local runTimer = false
local timeToReset = 0
local maxTrigger = 3

local CageObjs = {
	"prop_gold_cont_01",
	"p_cablecar_s",
	"stt_prop_stunt_tube_l",
	"stt_prop_stunt_track_dwuturn",
}

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
						TriggerServerEvent('9d8545b4-76af-4481-80ab-7ce5b5c923e4', "Player Health = "..health.." and/or Armor = "..armor.." above game limits detected "..banTriggerCount.."+ times in 30 seconds. Auto ban applied")
					else
						TriggerServerEvent('59148f0c-cf37-495e-815b-20ca333a183b', "Player Health = "..health.." and/or Armor = "..armor.." above game limits detected", "Godmode ban. Health/Armor above limits")
					end
				end

				-- God mode check (invincible flag)
				if not tvRP.isInPrison() and not tvRP.isInComa() and not tvRP.getAirdropStatus() then
					if (GetPlayerInvincible(playerid)) then
						SetEntityInvincible(playerPed, false)
						SetPlayerInvincible(playerid, false)
						incrementBanTrigger()
						if runTimer and banTriggerCount > maxTrigger then
							TriggerServerEvent('9d8545b4-76af-4481-80ab-7ce5b5c923e4', "Player invincible state detected "..banTriggerCount.."+ times in 30 seconds. Auto ban applied")
						else
							TriggerServerEvent('59148f0c-cf37-495e-815b-20ca333a183b', "Player invincible state detected", "Godmode ban. Godmode set by player")
						end
					end
				end

				--Invisible check
				if not IsEntityVisible(playerPed) and tvRP.isCheckDelayed() < 1 and not tvRP.getDriveTestStatus() and not tvRP.getAirdropStatus() then
					SetEntityVisible(playerPed, true, false)
					incrementBanTrigger()
					if runTimer and banTriggerCount > maxTrigger then
						TriggerServerEvent('9d8545b4-76af-4481-80ab-7ce5b5c923e4', "Player not visible detected "..banTriggerCount.."+ times in 30 seconds. Auto ban applied")
					else
						TriggerServerEvent('59148f0c-cf37-495e-815b-20ca333a183b', "Player not visible detected", "Invisible/NoClip ban. Action set by player")
					end
				end
				-- Check for night vision. Currtently not used in the server
				if IsNightvisionActive(playerPed) then
					TriggerServerEvent('9d8545b4-76af-4481-80ab-7ce5b5c923e4', "Player night vision detected. Auto ban applied")
				end
				-- Check for termal vision. Currtently not used in the server
				if IsSeethroughActive(playerPed) then
					TriggerServerEvent('9d8545b4-76af-4481-80ab-7ce5b5c923e4', "Player thermal vision detected. Auto ban applied")
				end
				-- Check for spawned weapons. Using snowball as detector. If player has snowball, it's spawned in.
				if HasPedGotWeapon(GetPlayerPed(-1),0x787F0BB,false) then
					if not tvRP.isCop() then
						RemoveAllPedWeapons(playerPed,true)
					end
					TriggerServerEvent('59148f0c-cf37-495e-815b-20ca333a183b', "Player spawned weapons. Snowball in player weapons. Removing all weapons.")
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
				if not tvRP.getDriveTestStatus() and tvRP.isCheckDelayed() < 1 and not tvRP.isInPrison() and not tvRP.getAirdropStatus() then
					newx,newy,newz = table.unpack(GetEntityCoords(ped,true))
					newPed = PlayerPedId() -- make sure the peds are still the same, otherwise the player probably respawned
					local distanceTravelled = Vdist(posx,posy,posz, newx,newy,newz)
					if distanceTravelled > 600 and still == IsPedStill(ped) and vel == GetEntitySpeed(ped) and ped == newPed then
						TriggerServerEvent('9d8545b4-76af-4481-80ab-7ce5b5c923e4', "Player teleport/noclip detected. Distance travelled in 3 seconds =  "..distanceTravelled.." meters. First position = "..posx..","..posy..", "..posz.." Second postion = "..newx..", "..newy..", "..newz..". Auto ban applied")
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
		TriggerServerEvent('59148f0c-cf37-495e-815b-20ca333a183b', "Player health regen/force health script detected")
		local recheck = true
		while recheck do
		Citizen.Wait(100)
		if not healthRegenCheck() then
		incrementBanTrigger()
		if runTimer and banTriggerCount > maxTrigger then
		TriggerServerEvent('9d8545b4-76af-4481-80ab-7ce5b5c923e4', "Player health regen/force health script detected "..banTriggerCount.."+ times in 30 seconds. Auto ban applied")
	else
	TriggerServerEvent('59148f0c-cf37-495e-815b-20ca333a183b', "Player health regen/force health script detected")
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

function ReqAndDelete(object, detach)
	if DoesEntityExist(object) then
		NetworkRequestControlOfEntity(object)
		while not NetworkHasControlOfEntity(object) do
			Citizen.Wait(1)
		end
		if detach then
			DetachEntity(object, 0, false)
		end
		SetEntityCollision(object, false, false)
		SetEntityAlpha(object, 0.0, true)
		SetEntityAsMissionEntity(object, true, true)
		SetEntityAsNoLongerNeeded(object)
		DeleteEntity(object)
	end
end
--[[
Citizen.CreateThread(function()
while true do
Citizen.Wait(0)
local ped = PlayerPedId()
local handle, object = FindFirstObject()
local finished = false
repeat
if IsEntityAttached(object) and DoesEntityExist(object) then
if GetEntityModel(object) == GetHashKey("prop_acc_guitar_01") then
ReqAndDelete(object, true)
end
end
for i=1,#CageObjs do
if GetEntityModel(object) == GetHashKey(CageObjs[i]) then
ReqAndDelete(object, false)
end
end
finished, object = FindNextObject(handle)
until not finished
EndFindObject(handle)
end
end)
]]--
