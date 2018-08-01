local medic = false
local emergencyLevel = 0

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
    SetPedRelationshipGroupHash(GetPlayerPed(-1), GetHashKey("blrp_ems")) --add player to non-agro group
    TriggerEvent('chat:addSuggestion', '/carmod', 'Toggle vehicle extras.',{{name = "extra", help = "Number 1-14"},{name = "toggle", help = "0 = on, 1 = off"}})
  else
    -- Remove medic weapons when going off duty
    RemoveWeaponFromPed(GetPlayerPed(-1),0x497FACC3) -- WEAPON_FLARE
    RemoveWeaponFromPed(GetPlayerPed(-1),0xCB13D282) -- WEAPON_FIREEXTINGUISHER (pickup)
    RemoveWeaponFromPed(GetPlayerPed(-1),0x060EC506) -- WEAPON_FIREEXTINGUISHER
    vRPserver.removePlayerToActiveEMS({})
    SetPedRelationshipGroupHash(GetPlayerPed(-1), GetHashKey("PLAYER")) --set player back to default group
    TriggerEvent('chat:removeSuggestion', '/carmod')
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
