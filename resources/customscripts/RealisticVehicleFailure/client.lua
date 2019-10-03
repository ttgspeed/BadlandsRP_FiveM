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
-----------------------------------------
-- Chat based car mod for LSFD and LSPD
-----------------------------------------
local approvedGarages = {
  { 454.4, -1017.6, 28.4}, -- mission row police
  { 1871.0380859375, 3692.90258789063, 33.5941047668457}, -- sandy shores police
  { -1119.01953125, -858.455627441406, 13.5303745269775}, -- vespuci
  { -470.90957641602, 6017.8525390625, 31.340526580811}, -- paleto police

  { 1699.84045410156, 3582.97412109375, 35.5014381408691}, -- sandy shores ems
  { -373.39953613281, 6129.71875, 31.478042602539}, -- paleto ems
  --{ 302.42324829102, -1440.243774414, 29.79786491394}, -- strawberry ems
  {331.12121582031,-552.54223632813,28.743782043457}, -- pillbox
  {-454.30502319336,-340.23458862305,34.363471984863}, -- mount zonah ems
}

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
			return true
		end
	end
	return false
end

function vRPcustom.IsNearMechanic()
	local ped = GetPlayerPed(-1)
	local pedLocation = GetEntityCoords(ped, 0)
	for _, item in pairs(repairCfg.mechanics) do
		local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  pedLocation["x"], pedLocation["y"], pedLocation["z"], true)
		if distance <= item.r then
			return true
		end
	end
	if vRP.isCop({}) or vRP.isMedic({}) then
		for _, item in ipairs(approvedGarages) do
			local distance = GetDistanceBetweenCoords(item[1], item[2], item[3],  pedLocation["x"], pedLocation["y"], pedLocation["z"], true)
			if distance <= 20.0 then
				return true
			end
		end
	end
  return false
end

function vRPcustom.canRepairVehicle()
  local ped = GetPlayerPed(-1)
  if not IsPedInAnyVehicle(ped, false) then
    local vehicle = GetVehicleInFront()
    if vehicle ~= nil and vehicle ~= 0 then
      local vehClass = GetVehicleClass(vehicle)
			local plyPos = GetEntityCoords(GetPlayerPed(PlayerId()), false)
			local boneIndex = GetEntityBoneIndexByName(vehicle, "bonnet")
			local doorPos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
			local distance = Vdist(plyPos.x, plyPos.y, plyPos.z, doorPos.x, doorPos.y, doorPos.z)
      if vehClass == 14 or vehClass == 15 or vehClass == 16 then
        return true
			elseif distance < 2.5 or boneIndex == -1 then
				return true
			end
    end
  end
  return false
end


function vRPcustom.attemptRepairVehicle(mechanic)
	local mechanic = mechanic
	local ped = GetPlayerPed(-1)
	if not IsPedInAnyVehicle(ped, false) then
		local vehicle = GetVehicleInFront()
		if vehicle ~= nil and vehicle ~= 0 then
      local vehClass = GetVehicleClass(vehicle)
			local plyPos = GetEntityCoords(GetPlayerPed(PlayerId()), false)
			local boneIndex = GetEntityBoneIndexByName(vehicle, "bonnet")
			local doorPos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
			local distance = Vdist(plyPos.x, plyPos.y, plyPos.z, doorPos.x, doorPos.y, doorPos.z)
			if mechanic then
				if not isNearRepairVehicle() then
					mechanic = false
				end
			end
      if vehClass == 14 or vehClass == 15 or vehClass == 16 then
        fullRepair(vehicle)
			elseif distance < 2.5 or boneIndex == -1 then
				repairVehicle(vehicle, mechanic)
			end
		else
			notification("No vehicle found that needs fixing")
		end
	else
		notification("You must be outside of the vehicle to be able to repair it")
	end
end

-- Evaluate what repair is needed and what type of repair
function repairVehicle(vehicle, mechanic)
	if vehicle ~= nil then
		if vRPcustom.IsNearMechanic() then
			fullRepair(vehicle)
			return
		end
		if GetVehicleEngineHealth(vehicle) < cfg.cascadingFailureThreshold + 300 then
			repairEngineOnly(vehicle, mechanic)
		else
			notification(repairCfg.noFixMessages[noFixMessagePos] )
			noFixMessagePos = noFixMessagePos + 1
			if noFixMessagePos > repairCfg.noFixMessageCount then noFixMessagePos = 1 end
		end
	end
end

-- Repair fully engine and body
function fullRepair(vehicle)
  if not IsEntityDead(vehicle) then
  	vRP.playAnim({false,{task="PROP_HUMAN_BUM_BIN"},false})
  	vRP.setActionLock({true})
  	SetVehicleDoorOpen(vehicle,4,0,false)
  	Citizen.Wait(10000)
  	vRP.playAnim({false,{task="WORLD_HUMAN_WELDING"},false})
  	Citizen.Wait(1500)
  	SetVehicleDoorShut(vehicle,4,false)
  	Citizen.Wait(10000)
  	vRP.stopAnim({false})
  	vRP.setActionLock({false})
  	SetVehicleUndriveable(vehicle,false)
  	SetVehicleFixed(vehicle)
  	healthBodyLast=1000.0
  	healthEngineLast=1000.0
  	healthPetrolTankLast=1000.0
  	SetVehicleEngineOn(vehicle, true, false )
  	notification("Your vehicle is fully repaired!")
  else
    notification("The vehicle is destroyed. Can't repair that!")
  end
end

-- Only repair engine
function repairEngineOnly(vehicle, mechanic)
	vRP.playAnim({false,{task="PROP_HUMAN_BUM_BIN"},false})
	vRP.setActionLock({true})
	SetVehicleDoorOpen(vehicle,4,0,false)
	Citizen.Wait(10000)
	vRP.stopAnim({false})
	vRP.setActionLock({false})
	Citizen.Wait(1500)
	SetVehicleDoorShut(vehicle,4,false)
	SetVehicleUndriveable(vehicle,false)
	if mechanic then
		Citizen.Trace("Mechanic repair")
		SetVehicleEngineHealth(vehicle, 1000.0)
		SetVehiclePetrolTankHealth(vehicle, 1000.0)
		healthEngineLast=1000.0
		healthPetrolTankLast=1000.0
	else
		Citizen.Trace("Non-Mechanic repair")
		SetVehicleEngineHealth(vehicle, 650.0)
		SetVehiclePetrolTankHealth(vehicle, 750.0)
		healthEngineLast=650.0
		healthPetrolTankLast=750.0
		SetVehicleOilLevel(vehicle,(GetVehicleOilLevel(vehicle)/3)-0.5)
	end
	SetVehicleEngineOn(vehicle, true, false )
	notification(repairCfg.fixMessages[fixMessagePos] .. ", now get to a mechanic!")
	fixMessagePos = fixMessagePos + 1
	if fixMessagePos > repairCfg.fixMessageCount then fixMessagePos = 1 end
end

function isNearRepairVehicle()
  local playerped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerped, true)

	local isVehicleTow = vRP.isVehicleATowTruck({vehicle})

	if isVehicleTow then
    local coordPed = GetEntityCoords(playerped, 1)
    local coordTow = GetEntityCoords(vehicle, 1)
    local distance = GetDistanceBetweenCoords(coordPed, coordTow, false)
    if distance < 35 then -- meters
      return true
    end
  end
	return false
end

function vRPcustom.IsNearMechanicOrRepairTruck()
	if vRPcustom.IsNearMechanic() or isNearRepairVehicle() then
		return true
	end
	return false
end

function GetVehicleInFront()
    local plyCoords = GetEntityCoords(GetPlayerPed(PlayerId()), false)
    local plyOffset = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 1.2, 0.0)
    --local rayHandle = StartShapeTestRay(plyCoords.x, plyCoords.y, plyCoords.z, plyOffset.x, plyOffset.y, plyOffset.z, 2, GetPlayerPed(PlayerId()), 1)
    local rayHandle = StartShapeTestCapsule(plyCoords.x, plyCoords.y, plyCoords.z, plyOffset.x, plyOffset.y, plyOffset.z, 0.3, 10, GetPlayerPed(PlayerId()), 7)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)

    return vehicle
end

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
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		if isPedDrivingAVehicle() then
      if not IsEntityAtCoord(ped, 2796.9389648438, -3798.2019042969, 137.76863098145, 435.9753, 435.9753, 100.01, 0, 1, 0) then
  			vehicle = GetVehiclePedIsIn(ped, false)
  			vehicleClass = GetVehicleClass(vehicle)
  			carModel = GetEntityModel(vehicle)
  			if not vRP.isCarBlacklisted({carModel, vehicleClass}) then
          if vehicleClass ~= 21 and vehicleClass ~= 13 and vehicleClass ~= 15 and vehicleClass ~= 16 and vehicleClass ~= 14 then
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
          end
  			else
          SetVehicleForwardSpeed(vehicle,0.0)
  				if not restrictedNotified then
  					vRP.notify({"The security system in this vehicle has disabled the engine"})
  					restrictedNotified = true
            SetTimeout(10000, function()
              restrictedNotified = false
            end)
  				end
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


------------------------------------------------------------------
-- Toggle engine if you own it
-- https://github.com/ToastinYou/LeaveEngineRunning
------------------------------------------------------------------
local engineVehicles = {}

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    if veh ~= nil then
      if GetSeatPedIsTryingToEnter(GetPlayerPed(-1)) == -1 and not table.contains(engineVehicles, veh) then
        table.insert(engineVehicles, {veh, IsVehicleEngineOn(veh)})
      elseif IsPedInAnyVehicle(GetPlayerPed(-1), false) and not table.contains(engineVehicles, GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
        table.insert(engineVehicles, {GetVehiclePedIsIn(GetPlayerPed(-1), false), IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false))})
      end
      for i, vehicle in ipairs(engineVehicles) do
        if DoesEntityExist(vehicle[1]) then
          if (GetPedInVehicleSeat(vehicle[1], -1) == GetPlayerPed(-1)) or IsVehicleSeatFree(vehicle[1], -1) then
            if GetVehicleEngineHealth(vehicle[1]) >= cfg.engineSafeGuard+1 and cfg.limpMode == false then
              SetVehicleEngineOn(vehicle[1], vehicle[2], true, false)
            else
              SetVehicleUndriveable(vehicle[1], true)
            end
          end
        else
          table.remove(engineVehicles, i)
        end
      end
      if IsControlJustPressed(0, 47) and (GetVehicleClass(veh) ~= 15 and GetVehicleClass(veh) ~= 16) then
        vRPcustom.toggleEngine()
      elseif IsControlJustPressed(0, 182) and (GetVehicleClass(veh) == 15 or GetVehicleClass(veh) == 16) then
        vRPcustom.toggleEngine()
      end
    end
  end
end)

function vRPcustom.toggleEngine()
  local veh
  local StateIndex
  for i, vehicle in ipairs(engineVehicles) do
    if vehicle[1] == GetVehiclePedIsIn(GetPlayerPed(-1), false) then
      veh = vehicle[1]
      StateIndex = i
    end
  end
  local plate = GetVehicleNumberPlateText(veh)
  local carModel = GetEntityModel(veh)
  local carName = GetDisplayNameFromVehicleModel(carModel)
  args = vRP.stringsplit({plate})
  if args ~= nil then
    plate = args[1]
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
      if (GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)) then
        if vRP.hasKey({carName, plate}) or vRP.getRegistrationNumber({}) == plate or not IsEntityAMissionEntity(veh) then
          engineVehicles[StateIndex][2] = not GetIsVehicleEngineRunning(veh)
          local msg = nil
          if engineVehicles[StateIndex][2] then
            vRP.DrawText3DsThreaded({veh, "Engine turned ON", 150})
            vRP.notify({"Engine turned ON!"})
          else
            vRP.DrawText3DsThreaded({veh, "Engine turned OFF", 150})
            vRP.notify({"Engine turned OFF!"})
          end
        else
          vRP.notify({"You don't have the keys to this vehicle."})
        end
      end
    end
  end
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value[1] == element then
      return true
    end
  end
  return false
end
