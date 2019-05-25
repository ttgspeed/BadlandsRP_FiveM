local medic = false
local emergencyLevel = 0
local healTimeout = 10
local treating = false

local relationship_hashes = {
  "PLAYER",
  "CIVMALE",
  "CIVFEMALE",
  "COP",
  "SECURITY_GUARD",
  "PRIVATE_SECURITY",
  "FIREMAN",
  "GANG_1",
  "GANG_2",
  "GANG_9",
  "GANG_10",
  "AMBIENT_GANG_LOST",
  "AMBIENT_GANG_MEXICAN",
  "AMBIENT_GANG_FAMILY",
  "AMBIENT_GANG_BALLAS",
  "AMBIENT_GANG_MARABUNTE",
  "AMBIENT_GANG_CULT",
  "AMBIENT_GANG_SALVA",
  "AMBIENT_GANG_WEICHENG",
  "AMBIENT_GANG_HILLBILLY",
  "DEALER",
  "HATES_PLAYER",
  "HEN",
  "WILD_ANIMAL",
  "SHARK",
  "COUGAR",
  "NO_RELATIONSHIP",
  "SPECIAL",
  "MISSION2",
  "MISSION3",
  "MISSION4",
  "MISSION5",
  "MISSION6",
  "MISSION7",
  "MISSION8",
  "ARMY",
  "GUARD_DOG",
  "AGGRESSIVE_INVESTIGATE",
  "MEDIC",
  "PRISONER",
  "DOMESTIC_ANIMAL",
  "DEER"
}

function tvRP.setMedic(flag)
  medic = flag
  if medic then
  	vRPserver.addPlayerToActiveEMS({})
    --SetPedRelationshipGroupHash(GetPlayerPed(-1), GetHashKey("blrp_ems")) --add player to non-agro group
    TriggerEvent('chat:addSuggestion', '/carmod', 'Toggle vehicle extras.',{{name = "extra", help = "Number 1-14"},{name = "toggle", help = "0 = on, 1 = off"}})
    TriggerEvent('chat:addSuggestion', '/headgear', 'Change current head gear.',{{name = "id", help = "Number"}, {name = "texture", help = "Number"}})
  else
    -- Remove medic weapons when going off duty
    RemoveWeaponFromPed(GetPlayerPed(-1),0x497FACC3) -- WEAPON_FLARE
    RemoveWeaponFromPed(GetPlayerPed(-1),0xCB13D282) -- WEAPON_FIREEXTINGUISHER (pickup)
    RemoveWeaponFromPed(GetPlayerPed(-1),0x060EC506) -- WEAPON_FIREEXTINGUISHER
    vRPserver.removePlayerToActiveEMS({})
    SetPedRelationshipGroupHash(GetPlayerPed(-1), GetHashKey("PLAYER")) --set player back to default group
    TriggerEvent('chat:removeSuggestion', '/carmod')
    TriggerEvent('chat:removeSuggestion', '/headgear')
  end
end

function tvRP.isMedic()
	return medic
end

function tvRP.setEmergencyLevel(level)
  emergencyLevel = tonumber(level)
end

function tvRP.getEmergencyLevel()
  return emergencyLevel or 0
end

function tvRP.putInNearestVehicleAsPassengerEMS(radius)
  local player = GetPlayerPed(-1)
  local vehicle = tvRP.getVehicleAtRaycast(radius)
  Citizen.Trace("putinveh 1 "..vehicle)
  if IsEntityAVehicle(vehicle) then
    for i=1,math.max(GetVehicleMaxNumberOfPassengers(vehicle),3) do
      if IsVehicleSeatFree(vehicle,i) then
        Citizen.Trace("putinveh 2 "..vehicle.." "..i)
        TaskWarpPedIntoVehicle(player,vehicle,i)
        Citizen.Trace("putinveh 3 "..vehicle.." "..i)
				tvRP.stopEscort()
        Citizen.Trace("putinveh 4 "..vehicle.." "..i)
        break
      end
    end
  end
  Citizen.Trace("putinveh 5 ")
end

-- (experimental, based on experimental getNearestVehicle)
function tvRP.putInNearestVehicleAsPassenger(radius)
  local veh = tvRP.getNearestVehicle(radius)

  if IsEntityAVehicle(veh) then
    for i=1,math.max(GetVehicleMaxNumberOfPassengers(veh),3) do
      if IsVehicleSeatFree(veh,i) then
        TaskWarpPedIntoVehicle(GetPlayerPed(-1),vehicle,i)
        tvRP.stopEscort()
        return true
      end
    end
  end

  return false
end

Citizen.CreateThread(function()
  AddRelationshipGroup("blrp_ems")
  --Make all groups consider blrp_ems a companion so they will not agro
  for _,v in pairs(relationship_hashes) do
     SetRelationshipBetweenGroups(0, GetHashKey("blrp_ems"), GetHashKey(v))
     SetRelationshipBetweenGroups(0, GetHashKey(v), GetHashKey("blrp_ems"))
  end
end)

------------------------------------------------
-- EMS Injury Treatment
------------------------------------------------

function tvRP.attemptFieldTreatment(random)
  local action_performed = 0
	treating = true
	healTimeout = 10

  while treating do
    Citizen.Wait(0)
    DisableControlAction(0, 157, true)
    DisableControlAction(0, 158, true)
    DisableControlAction(0, 160, true)

    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
		local nearPlayer = tvRP.getNearestPlayer(3)

		if nearPlayer ~= nil then
			local targetPed = GetPlayerPed(GetPlayerFromServerId(nearServId))
			local targetPedPos = GetEntityCoords(targetPed,true)

	    local distance = Vdist(x,y,z,targetPedPos.x,targetPedPos.y,targetPedPos.z)
	    if distance <= 2 then
	      tvRP.DrawText3d(targetPedPos.x,targetPedPos.y,targetPedPos.z+1,healTimeout.."s to complete action",0.35)
	      tvRP.missionText("~r~1~w~: treat coughing~n~ ~r~2~w~: treat shortness of breath~n~~r~3~w~: treat vomiting~n~", 1)
	      if IsDisabledControlJustPressed(0, 157) then
	        RequestAnimDict("weapon@w_sp_jerrycan")
	        while not HasAnimDictLoaded("weapon@w_sp_jerrycan") do
	          Citizen.Wait(100)
	        end
	        TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_PARKING_METER", 0, 1)
	        Citizen.Wait(5000)
	        ClearPedTasks(GetPlayerPed(-1))
	        treating = false
	        healTimeout = 0
	        action_performed = 1
	      end
	      if IsDisabledControlJustPressed(0, 158) then
	        TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_PARKING_METER", 0, 1)
	        Citizen.Wait(5000)
	        ClearPedTasks(GetPlayerPed(-1))
	        treating = false
	        healTimeout = 0
	        action_performed = 2
	      end
	      if IsDisabledControlJustPressed(0, 160) then
	        TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_PARKING_METER", 0, 1)
	        Citizen.Wait(5000)
	        ClearPedTasks(GetPlayerPed(-1))
	        treating = false
	        healTimeout = 0
	        action_performed = 3
	      end
	      if healTimeout < 1 then
	        treating = false
	        if action_performed == 0 then
	          action_performed = 4
	        end
	      end
	    else
	      if healTimeout < 1 then
	        treating = false
	        if action_performed == 0 then
	          action_performed = -1
	        end
	      end
	      tvRP.showHelpNotification("Too far")
	    end
		end
  end
  if action_performed == random then
    tvRP.notify("You applied a medkit, healing the patient.")
    return true
  elseif action_performed == -1 then
    tvRP.notify("You were too far away from the patient.")
    return false
  else
    tvRP.notify("Incorrect Action Performed")
    return false
  end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if(treating)then
			healTimeout = healTimeout - 1
		end
	end
end)

------------------------------------------------
-- AI revive start
------------------------------------------------
local actionInProgress = false
local currentped = nil
local ped_custom = {}

local revive_seq = {
  {"amb@medic@standing@kneel@enter","enter",1},
  {"amb@medic@standing@kneel@idle_a","idle_a",1},
  {"amb@medic@standing@kneel@exit","exit",1}
}

function tvRP.attempAiRevive()
	if not actionInProgress and not tvRP.getActionLock() then
		local player = GetPlayerPed(-1)
		local playerloc = GetEntityCoords(player, 0)
			local handle, ped = FindFirstPed()
			local success
			repeat
				success, ped = FindNextPed(handle)
				local pos = GetEntityCoords(ped)
					local distance = Vdist(pos.x, pos.y, pos.z, playerloc['x'], playerloc['y'], playerloc['z'])
					if canRevive(ped) then
						if distance <= 2.5 and ped  ~= GetPlayerPed(-1) and ped ~= oldped then
							actionInProgress = true
              tvRP.setActionLock(true)
							oldped = ped
							DecorSetInt(ped, "AiRevived", 2)
							currentped = ped
              SetEntityAsMissionEntity(currentped)
							getCustomization(currentped)
              bodyPos = GetEntityCoords(currentped)
              local x, y, z = table.unpack(bodyPos)
              local pedHash = GetEntityModel(currentped)

              RequestModel(pedHash)
              while not HasModelLoaded(pedHash) do
                Citizen.Wait(1)
              end
              local newPed = CreatePed(4, pedHash, x, y, z-1, 90, true, true)
							SetEntityAsMissionEntity(newPed)
							SetEntityVisible(newPed, false, false)
							setCustomization(newPed)
							TaskStartScenarioInPlace(newPed, "WORLD_HUMAN_BUM_SLUMPED", 0, false)
							tvRP.playAnim(false, revive_seq, false)
							--TaskSetBlockingOfNonTemporaryEvents(newPed, true)
							SetPedToRagdoll(newPed, 22000, 22000, 0, 0, 0, 0)
							Citizen.Wait(1000)
							SetEntityVisible(newPed, true, false)
							DeleteEntity(currentped)
              SetPedAsNoLongerNeeded(currentped)
							Citizen.Wait(23000)
              TaskSetBlockingOfNonTemporaryEvents(newPed, true)
              SetPedAsNoLongerNeeded(newPed)

              actionInProgress = false
              tvRP.setActionLock(false)

						end
					end
			until not success
			EndFindPed(handle)
	end
end


function getCustomization(ped)
  -- ped parts
  for i=0,20 do -- index limit to 20
    ped_custom[i] = {GetPedDrawableVariation(ped,i), GetPedTextureVariation(ped,i), GetPedPaletteVariation(ped,i)}
  end

  -- props
  for i=0,10 do -- index limit to 10
    ped_custom["p"..i] = {GetPedPropIndex(ped,i), math.max(GetPedPropTextureIndex(ped,i),0)}
  end
end

function setCustomization(ped) -- indexed [drawable,texture,palette] components or props (p0...) plus .modelhash or .model
	if ped ~= nil then
    -- parts
    for k,v in pairs(ped_custom) do
      local isprop, index = parse_part(k)
      if isprop then
        if v[1] < 0 then
          ClearPedProp(ped,index)
        else
          SetPedPropIndex(ped,index,v[1],v[2],v[3] or 2)
        end
      else
        	SetPedComponentVariation(ped,index,v[1],v[2], 2)
      end
    end
  end
end

function parse_part(key)
  if type(key) == "string" and string.sub(key,1,1) == "p" then
    return true,tonumber(string.sub(key,2))
  else
    return false,tonumber(key)
  end
end

function canRevive(aiPed)
	if IsPedInAnyVehicle(GetPlayerPed(-1)) == false then
		if DoesEntityExist(aiPed)then
			if IsEntityDead(aiPed) then
				if IsPedInAnyVehicle(aiPed) == false then
					local pedType = GetPedType(aiPed)
					if IsPedAPlayer(aiPed) == false then
						if DecorGetInt(aiPed, "AiRevived") ~= 2 then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

-------------------------------------------------
-- AI revive end
-------------------------------------------------
local allHumanBones = {
    ["Everything is broken"] = {0x0, false, 0, run = function() clumsy() end},

    -- Lower Body
    ["Left Thigh"] = {0xE39F, false, 0, run = function() clumsy() end},
    ["Left Calf"] = {0xF9BB, false, 0, run = function() clumsy() end},
    ["Left Foot"] = {0x3779, false, 0, run = function() clumsy() end},
    ["Left Foot Toes"] = {0x83C, false, 0, run = function() clumsy() end},

    ["Right Thigh"] = {0xCA72, false, 0, run = function() clumsy() end},
    ["Right Calf"] = {0x9000, false, 0, run = function() clumsy() end},
    ["Right Foot"] = {0xCC4D, false, 0, run = function() clumsy() end},
    ["Right Foot Toes"] = {0x512D, false, 0, run = function() clumsy() end},

    -- Mid Body
    ["Pelvis"] = {0x2E28, false, 0, run = function() clumsy() end},
    ["Glutes"] = {0xE0FD, false, 0, run = function() clumsy() end},
    ["Lower Spine"] = {0x5C01, false, 0, run = function() clumsy() end},
    ["Lower Mid Spine"] = {0x60F0, false, 0, run = function() clumsy() end},
    ["Upper Mid Spine"] = {0x60F1, false, 0, run = function() clumsy() end},
    ["Upper Spine"] = {0x60F2, false, 0, run = function() clumsy() end},

    -- Upper Body
    ["Left Clavicle"] = {0xFCD9, false, 0, run = function() clumsy() end},
    ["Left Upper Arm"] = {0xB1C5, false, 0, run = function() clumsy() end},
    --["Left Upper Arm"] = {0xB1C5, false, 0, "treatment_cooldown", "weak_melee", "low_damage", "take_damage"},
    ["Left Forearm"] = {0xEEEB, false, 0, run = function() clumsy() end},
    ["Left Hand"] = {0x49D9, false, 0, run = function() clumsy() end},

    ["Right Clavicle"] = {0x29D2, false, 0, run = function() clumsy() end},
    ["Right Upper Arm"] = {0x9D4D, false, 0, run = function() clumsy() end},
    ["Right Forearm"] = {0x6E5C, false, 0, run = function() clumsy() end},
    ["Right Hand"] = {0xDEAD, false, 0, run = function() clumsy() end},

    -- Head portion
    ["Head"] = {0x796E, false, 0, run = function() clumsy() end},
    ["Neck"] = {0x9995, false, 0, run = function() clumsy() end},
}

local pulse = 70
local clumsythreadRunning = false
local pauseRagoll = false
local pauseThreadRunning = false
local lastBone = 0

function tvRP.getPlayerPulse()
  local health = GetEntityHealth(GetPlayerPed(-1))
	if health > 0 then
		pulse = (health / 4 + math.random(19, 28))
	end
	print(pulse)
  return pulse
end

function tvRP.getLastInjury()
  local string = ""
  for k,v in pairs(allHumanBones) do
    if v[2] then
      string = string..k.." x"..v[3].."<br>"
    end
  end
  if string == "" then
    string = "No injuries found"
  else
    string = "Injuries found in the following body parts: <br><br>"..string
  end

	return string
end

RegisterNetEvent("chat:setComaState")
AddEventHandler("chat:setComaState", function(flag)
  if not flag then
    --tvRP.clearBoneDamage()
  end
end)

function tvRP.clearBoneDamage()
  for k3,v3 in pairs(allHumanBones) do
    v3[2] = false
    v3[3] = 0
    clumsythreadRunning = false
    pauseRagoll = false
  end
  print("Damage cleared")
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local ped = GetPlayerPed(-1)
    local hit, bone = GetPedLastDamageBone(ped)
    ClearPedLastDamageBone(ped)
    if hit ~= nil and hit then
      for k1, v1 in pairs(allHumanBones) do
        if tonumber(v1[1]) == bone and bone ~= lastBone then
          lastBone = bone
          ClearPedLastDamageBone(ped)
          v1[2] = true
          v1[3] = v1[3] + 1
          v1.run()
        end
      end
    end
  end
end)

function clumsy()
  if not clumsythreadRunning then
    clumsythreadRunning = true
    Citizen.CreateThread(function()
      while clumsythreadRunning do
        Citizen.Wait(0)
        if not pauseRagoll then
          SetPedRagdollOnCollision(GetPlayerPed(-1), true)
          SetPedCanRagdollFromPlayerImpact(GetPlayerPed(-1), true)
        end
        if IsPedRagdoll(GetPlayerPed(-1)) and not pauseRagoll then
          pauseRagoll = true
          Citizen.CreateThread(function()
            local timeout = 500
            print("enter da lopp")
            while timeout > 0 do
              Citizen.Wait(1)
              timeout = timeout - 1
            end
            print("exit da loop")
            pauseRagoll = false
          end)
        end
      end
    end)
  end
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    --SetEntityHealth(GetPlayerPed(-1),200)
  end
end)

--[[
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    for k4,v4 in pairs(allHumanBones) do
      local boneCoord = GetPedBoneCoords(GetPlayerPed(-1), tonumber(v4[1]), 0, 0, 0)
      tvRP.drawText3Ds(k4, boneCoord.x, boneCoord.y, boneCoord.z)
    end
  end
end)
]]--
