------------------------------------------
--	iEnsomatic RealisticVehicleFailure  --
------------------------------------------
--
--	Created by Jens Sandalgaard
--
--	This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
--
--	https://github.com/iEns/RealisticVehicleFailure
--


local pedInSameVehicleLast=false
local vehicle
local lastVehicle
local vehicleClass
local carModel
local carName
local restrictedNotified = false
local fCollisionDamageMult = 0.0
local fDeformationDamageMult = 0.0
local fEngineDamageMult = 0.0
local fBrakeForce = 1.0
local isBrakingForward = false
local isBrakingReverse = false

local healthEngineLast = 1000.0
local healthEngineCurrent = 1000.0
local healthEngineNew = 1000.0
local healthEngineDelta = 0.0
local healthEngineDeltaScaled = 0.0

local healthBodyLast = 1000.0
local healthBodyCurrent = 1000.0
local healthBodyNew = 1000.0
local healthBodyDelta = 0.0
local healthBodyDeltaScaled = 0.0

local healthPetrolTankLast = 1000.0
local healthPetrolTankCurrent = 1000.0
local healthPetrolTankNew = 1000.0
local healthPetrolTankDelta = 0.0
local healthPetrolTankDeltaScaled = 0.0
local tireBurstLuckyNumber

math.randomseed(GetGameTimer());

local tireBurstMaxNumber = cfg.randomTireBurstInterval * 1200; 												-- the tire burst lottery runs roughly 1200 times per minute
if cfg.randomTireBurstInterval ~= 0 then tireBurstLuckyNumber = math.random(tireBurstMaxNumber) end			-- If we hit this number again randomly, a tire will burst.

local fixMessagePos = math.random(repairCfg.fixMessageCount)
local noFixMessagePos = math.random(repairCfg.noFixMessageCount)

-- Display blips on map
Citizen.CreateThread(function()
	if (cfg.displayBlips == true) then
		for _, item in pairs(repairCfg.mechanics) do
			item.blip = AddBlipForCoord(item.x, item.y, item.z)
			SetBlipSprite(item.blip, item.id)
			SetBlipAsShortRange(item.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(item.name)
			SetBlipScale(item.blip,0.8)
			EndTextCommandSetBlipName(item.blip)
		end
	end
end)

local function notification(msg)
	vRP.notify({msg})
end

local function isPedDrivingAVehicle()
	local ped = GetPlayerPed(-1)
	vehicle = GetVehiclePedIsIn(ped, false)
	if IsPedInAnyVehicle(ped, false) then
		-- Check if ped is in driver seat
		if GetPedInVehicleSeat(vehicle, -1) == ped then
			local class = GetVehicleClass(vehicle)
			-- We don't want planes, helicopters, bicycles and trains
			if class ~= 15 and class ~= 16 and class ~=21 and class ~=13 then
				return true
			end
		end
	end
	return false
end

local function IsNearMechanic()
	local ped = GetPlayerPed(-1)
	local pedLocation = GetEntityCoords(ped, 0)
	for _, item in pairs(repairCfg.mechanics) do
		local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  pedLocation["x"], pedLocation["y"], pedLocation["z"], true)
		if distance <= item.r then
			return true
		end
	end
end

function vRPcustom.repairVehicle()
	local ped = GetPlayerPed(-1)
	if not IsPedInAnyVehicle(ped, false) then
		vehicle = vRP.getVehicleAtRaycast({7})
		if vehicle ~= nil then
			if IsNearMechanic() then
				SetVehicleUndriveable(vehicle,false)
				SetVehicleFixed(vehicle)
				healthBodyLast=1000.0
				healthEngineLast=1000.0
				healthPetrolTankLast=1000.0
				SetVehicleEngineOn(vehicle, true, false )
				notification("The mechanic repaired your car!")
				return
			end
			if GetVehicleEngineHealth(vehicle) < cfg.cascadingFailureThreshold + 300 then
				--if GetVehicleOilLevel(vehicle) > 0 then
					SetVehicleUndriveable(vehicle,false)
					SetVehicleEngineHealth(vehicle, cfg.cascadingFailureThreshold + 300)
					SetVehiclePetrolTankHealth(vehicle, 750.0)
					healthEngineLast=cfg.cascadingFailureThreshold + 300
					healthPetrolTankLast=750.0
					SetVehicleEngineOn(vehicle, true, false )
					SetVehicleOilLevel(vehicle,(GetVehicleOilLevel(vehicle)/3)-0.5)
					notification(repairCfg.fixMessages[fixMessagePos] .. ", now get to a mechanic!")
					fixMessagePos = fixMessagePos + 1
					if fixMessagePos > repairCfg.fixMessageCount then fixMessagePos = 1 end
				--else
					--notification("Your vehicle was too badly damaged. Unable to repair!")
				--end
			else
				notification(repairCfg.noFixMessages[noFixMessagePos] )
				noFixMessagePos = noFixMessagePos + 1
				if noFixMessagePos > repairCfg.noFixMessageCount then noFixMessagePos = 1 end
			end
		else
			notification("No vehicle found that needs fixing")
		end
	else
		notification("You must be outside of the vehicle to be able to repair it")
	end
end


RegisterNetEvent('iens:repair')
AddEventHandler('iens:repair', function()
	if isPedDrivingAVehicle() then
		local ped = GetPlayerPed(-1)
		vehicle = GetVehiclePedIsIn(ped, false)
		if IsNearMechanic() then
			SetVehicleUndriveable(vehicle,false)
			SetVehicleFixed(vehicle)
			healthBodyLast=1000.0
			healthEngineLast=1000.0
			healthPetrolTankLast=1000.0
			SetVehicleEngineOn(vehicle, true, false )
			notification("The mechanic repaired your car!")
			return
		end
		if GetVehicleEngineHealth(vehicle) < cfg.cascadingFailureThreshold + 300 then
			--if GetVehicleOilLevel(vehicle) > 0 then
				SetVehicleUndriveable(vehicle,false)
				SetVehicleEngineHealth(vehicle, cfg.cascadingFailureThreshold + 300)
				SetVehiclePetrolTankHealth(vehicle, 750.0)
				healthEngineLast=cfg.cascadingFailureThreshold + 300
				healthPetrolTankLast=750.0
				SetVehicleEngineOn(vehicle, true, false )
				SetVehicleOilLevel(vehicle,(GetVehicleOilLevel(vehicle)/3)-0.5)
				notification(repairCfg.fixMessages[fixMessagePos] .. ", now get to a mechanic!")
				fixMessagePos = fixMessagePos + 1
				if fixMessagePos > repairCfg.fixMessageCount then fixMessagePos = 1 end
			--else
				--notification("Your vehicle was too badly damaged. Unable to repair!")
			--end
		else
			notification(repairCfg.noFixMessages[noFixMessagePos] )
			noFixMessagePos = noFixMessagePos + 1
			if noFixMessagePos > repairCfg.noFixMessageCount then noFixMessagePos = 1 end
		end
	else
		notification("You must be in a vehicle to be able to repair it")
	end
end)

RegisterNetEvent('iens:notAllowed')
AddEventHandler('iens:notAllowed', function()
	notification("You don't have permission to repair vehicles")
end)

if cfg.torqueMultiplierEnabled or cfg.limpMode then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if cfg.torqueMultiplierEnabled or cfg.sundayDriver or cfg.limpMode then
				if pedInSameVehicleLast then
					local factor = 1.0
					if cfg.torqueMultiplierEnabled and healthEngineNew < 750 then
						factor = (healthEngineNew+200.0) / 1100
					end
					if cfg.limpMode == true and healthEngineNew < cfg.engineSafeGuard + 5 then
						factor = cfg.limpModeMultiplier
					end
					SetVehicleEngineTorqueMultiplier(vehicle, factor)
				end
			end
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
		local ped = GetPlayerPed(-1)
		if isPedDrivingAVehicle() then
			vehicle = GetVehiclePedIsIn(ped, false)
			vehicleClass = GetVehicleClass(vehicle)
			carModel = GetEntityModel(vehicle)
			if not vRP.isCarBlacklisted({carModel}) then
				healthEngineCurrent = GetVehicleEngineHealth(vehicle)
				if healthEngineCurrent == 1000 then healthEngineLast = 1000.0 end
				healthEngineNew = healthEngineCurrent
				healthEngineDelta = healthEngineLast - healthEngineCurrent
				healthEngineDeltaScaled = healthEngineDelta * cfg.damageFactorEngine * cfg.classDamageMultiplier[vehicleClass]

				healthBodyCurrent = GetVehicleBodyHealth(vehicle)
				if healthBodyCurrent == 1000 then healthBodyLast = 1000.0 end
				healthBodyNew = healthBodyCurrent
				healthBodyDelta = healthBodyLast - healthBodyCurrent
				healthBodyDeltaScaled = healthBodyDelta * cfg.damageFactorBody * cfg.classDamageMultiplier[vehicleClass]

				healthPetrolTankCurrent = GetVehiclePetrolTankHealth(vehicle)
				if cfg.compatibilityMode and healthPetrolTankCurrent < 1 then
					--	SetVehiclePetrolTankHealth(vehicle, healthPetrolTankLast)
					--	healthPetrolTankCurrent = healthPetrolTankLast
					healthPetrolTankLast = healthPetrolTankCurrent
				end
				if healthPetrolTankCurrent == 1000 then healthPetrolTankLast = 1000.0 end
				healthPetrolTankNew = healthPetrolTankCurrent
				healthPetrolTankDelta = healthPetrolTankLast-healthPetrolTankCurrent
				healthPetrolTankDeltaScaled = healthPetrolTankDelta * cfg.damageFactorPetrolTank * cfg.classDamageMultiplier[vehicleClass]

				if healthEngineCurrent > cfg.engineSafeGuard+1 then
					SetVehicleUndriveable(vehicle,false)
				end

				if healthEngineCurrent <= cfg.engineSafeGuard+1 and cfg.limpMode == false then
					SetVehicleUndriveable(vehicle,true)
				end

				-- If ped spawned a new vehicle while in a vehicle or teleported from one vehicle to another, handle as if we just entered the car
				if vehicle ~= lastVehicle then
					pedInSameVehicleLast = false
				end


				if pedInSameVehicleLast == true then
					-- Damage happened while in the car = can be multiplied

					-- Only do calculations if any damage is present on the car. Prevents weird behavior when fixing using trainer or other script
					if healthEngineCurrent ~= 1000.0 or healthBodyCurrent ~= 1000.0 or healthPetrolTankCurrent ~= 1000.0 then

						-- Combine the delta values (Get the largest of the three)
						local healthEngineCombinedDelta = math.max(healthEngineDeltaScaled, healthBodyDeltaScaled, healthPetrolTankDeltaScaled)

						-- If huge damage, scale back a bit
						if healthEngineCombinedDelta > (healthEngineCurrent - cfg.engineSafeGuard) then
							healthEngineCombinedDelta = healthEngineCombinedDelta * 0.7
						end

						-- If complete damage, but not catastrophic (ie. explosion territory) pull back a bit, to give a couple of seconds og engine runtime before dying
						if healthEngineCombinedDelta > healthEngineCurrent then
							healthEngineCombinedDelta = healthEngineCurrent - (cfg.cascadingFailureThreshold / 5)
						end


						------- Calculate new value

						healthEngineNew = healthEngineLast - healthEngineCombinedDelta


						------- Sanity Check on new values and further manipulations

						-- If somewhat damaged, slowly degrade until slightly before cascading failure sets in, then stop

						if healthEngineNew > (cfg.cascadingFailureThreshold + 5) and healthEngineNew < cfg.degradingFailureThreshold then
							healthEngineNew = healthEngineNew-(0.038 * cfg.degradingHealthSpeedFactor)
						end

						-- If Damage is near catastrophic, cascade the failure
						if healthEngineNew < cfg.cascadingFailureThreshold then
							healthEngineNew = healthEngineNew-(0.1 * cfg.cascadingFailureSpeedFactor)
						end

						-- Prevent Engine going to or below zero. Ensures you can reenter a damaged car.
						if healthEngineNew < cfg.engineSafeGuard then
							healthEngineNew = cfg.engineSafeGuard
						end

						-- Prevent Explosions
						if cfg.compatibilityMode == false and healthPetrolTankCurrent < 750 then
							healthPetrolTankNew = 750.0
						end

						-- Prevent negative body damage.
						if healthBodyNew < 0  then
							healthBodyNew = 0.0
						end
					end
				else
					-- Just got in the vehicle. Damage can not be multiplied this round
					-- Set vehicle handling data
					fDeformationDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDeformationDamageMult')
					fBrakeForce = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeForce')
					local newFDeformationDamageMult = fDeformationDamageMult ^ cfg.deformationExponent	-- Pull the handling file value closer to 1
					if cfg.deformationMultiplier ~= -1 then SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDeformationDamageMult', newFDeformationDamageMult * cfg.deformationMultiplier) end  -- Multiply by our factor
					if cfg.weaponsDamageMultiplier ~= -1 then SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fWeaponDamageMult', cfg.weaponsDamageMultiplier/cfg.damageFactorBody) end -- Set weaponsDamageMultiplier and compensate for damageFactorBody

					--Get the CollisionDamageMultiplier
					fCollisionDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fCollisionDamageMult')
					--Modify it by pulling all number a towards 1.0
					local newFCollisionDamageMultiplier = fCollisionDamageMult ^ cfg.collisionDamageExponent	-- Pull the handling file value closer to 1
					SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fCollisionDamageMult', newFCollisionDamageMultiplier)

					--Get the EngineDamageMultiplier
					fEngineDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fEngineDamageMult')
					--Modify it by pulling all number a towards 1.0
					local newFEngineDamageMult = fEngineDamageMult ^ cfg.engineDamageExponent	-- Pull the handling file value closer to 1
					SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fEngineDamageMult', newFEngineDamageMult)

					-- If body damage catastrophic, reset somewhat so we can get new damage to multiply
					if healthBodyCurrent < cfg.cascadingFailureThreshold then
						healthBodyNew = cfg.cascadingFailureThreshold
					end
					pedInSameVehicleLast = true
				end

				-- set the actual new values
				if healthEngineNew ~= healthEngineCurrent then
					SetVehicleEngineHealth(vehicle, healthEngineNew)
				end
				if healthBodyNew ~= healthBodyCurrent then SetVehicleBodyHealth(vehicle, healthBodyNew) end
				if healthPetrolTankNew ~= healthPetrolTankCurrent then SetVehiclePetrolTankHealth(vehicle, healthPetrolTankNew) end

				-- Store current values, so we can calculate delta next time around
				healthEngineLast = healthEngineNew
				healthBodyLast = healthBodyNew
				healthPetrolTankLast = healthPetrolTankNew
				lastVehicle=vehicle
			else
				SetVehicleEngineHealth(vehicle,100)
				SetVehicleUndriveable(vehicle, true)
				if not restrictedNotified then
					vRP.notify({"The security system in this vehicle has disabled the engine"})
					restrictedNotified = true
          SetTimeout(10000, function()
            restrictedNotified = false
          end)
				end
			end
		else
			if pedInSameVehicleLast == true then
				-- We just got out of the vehicle
				lastVehicle = GetVehiclePedIsIn(ped, true)
				if cfg.deformationMultiplier ~= -1 then SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fDeformationDamageMult', fDeformationDamageMult) end -- Restore deformation multiplier
				SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fBrakeForce', fBrakeForce)  -- Restore Brake Force multiplier
				if cfg.weaponsDamageMultiplier ~= -1 then SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fWeaponDamageMult', cfg.weaponsDamageMultiplier) end	-- Since we are out of the vehicle, we should no longer compensate for bodyDamageFactor
				SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fCollisionDamageMult', fCollisionDamageMult) -- Restore the original CollisionDamageMultiplier
				SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fEngineDamageMult', fEngineDamageMult) -- Restore the original EngineDamageMultiplier
			end
			pedInSameVehicleLast = false
		end
	end
end)
