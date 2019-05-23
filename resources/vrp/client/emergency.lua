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
    ["SKEL_ROOT"] = {0x0, false},
    ["SKEL_Pelvis"] = {0x2E28, false},
    ["SKEL_L_Thigh"] = {0xE39F, false},
    ["SKEL_L_Calf"] = {0xF9BB, false},
    ["SKEL_L_Foot"] = {0x3779, false},
    ["SKEL_L_Toe0"] = {0x83C, false},
    ["EO_L_Foot"] = {0x84C5, false},
    ["EO_L_Toe"] = {0x68BD, false},
    ["IK_L_Foot"] = {0xFEDD, false},
    ["PH_L_Foot"] = {0xE175, false},
    ["MH_L_Knee"] = {0xB3FE, false},
    ["SKEL_R_Thigh"] = {0xCA72, false},
    ["SKEL_R_Calf"] = {0x9000, false},
    ["SKEL_R_Foot"] = {0xCC4D, false},
    ["SKEL_R_Toe0"] = {0x512D, false},
    ["EO_R_Foot"] = {0x1096, false},
    ["EO_R_Toe"] = {0x7163, false},
    ["IK_R_Foot"] = {0x8AAE, false},
    ["PH_R_Foot"] = {0x60E6, false},
    ["MH_R_Knee"] = {0x3FCF, false},
    ["RB_L_ThighRoll"] = {0x5C57, false},
    ["RB_R_ThighRoll"] = {0x192A, false},
    ["SKEL_Spine_Root"] = {0xE0FD, false},
    ["SKEL_Spine0"] = {0x5C01, false},
    ["SKEL_Spine1"] = {0x60F0, false},
    ["SKEL_Spine2"] = {0x60F1, false},
    ["SKEL_Spine3"] = {0x60F2, false},
    ["SKEL_L_Clavicle"] = {0xFCD9, false},
    ["SKEL_L_UpperArm"] = {0xB1C5, false},
    ["SKEL_L_Forearm"] = {0xEEEB, false},
    ["SKEL_L_Hand"] = {0x49D9, false},
    ["SKEL_L_Finger00"] = {0x67F2, false},
    ["SKEL_L_Finger01"] = {0xFF9, false},
    ["SKEL_L_Finger02"] = {0xFFA, false},
    ["SKEL_L_Finger10"] = {0x67F3, false},
    ["SKEL_L_Finger11"] = {0x1049, false},
    ["SKEL_L_Finger12"] = {0x104A, false},
    ["SKEL_L_Finger20"] = {0x67F4, false},
    ["SKEL_L_Finger21"] = {0x1059, false},
    ["SKEL_L_Finger22"] = {0x105A, false},
    ["SKEL_L_Finger30"] = {0x67F5, false},
    ["SKEL_L_Finger31"] = {0x1029, false},
    ["SKEL_L_Finger32"] = {0x102A, false},
    ["SKEL_L_Finger40"] = {0x67F6, false},
    ["SKEL_L_Finger41"] = {0x1039, false},
    ["SKEL_L_Finger42"] = {0x103A, false},
    ["PH_L_Hand"] = {0xEB95, false},
    ["IK_L_Hand"] = {0x8CBD, false},
    ["RB_L_ForeArmRoll"] = {0xEE4F, false},
    ["RB_L_ArmRoll"] = {0x1470, false},
    ["MH_L_Elbow"] = {0x58B7, false},
    ["SKEL_R_Clavicle"] = {0x29D2, false},
    ["SKEL_R_UpperArm"] = {0x9D4D, false},
    ["SKEL_R_Forearm"] = {0x6E5C, false},
    ["SKEL_R_Hand"] = {0xDEAD, false},
    ["SKEL_R_Finger00"] = {0xE5F2, false},
    ["SKEL_R_Finger01"] = {0xFA10, false},
    ["SKEL_R_Finger02"] = {0xFA11, false},
    ["SKEL_R_Finger10"] = {0xE5F3, false},
    ["SKEL_R_Finger11"] = {0xFA60, false},
    ["SKEL_R_Finger12"] = {0xFA61, false},
    ["SKEL_R_Finger20"] = {0xE5F4, false},
    ["SKEL_R_Finger21"] = {0xFA70, false},
    ["SKEL_R_Finger22"] = {0xFA71, false},
    ["SKEL_R_Finger30"] = {0xE5F5, false},
    ["SKEL_R_Finger31"] = {0xFA40, false},
    ["SKEL_R_Finger32"] = {0xFA41, false},
    ["SKEL_R_Finger40"] = {0xE5F6, false},
    ["SKEL_R_Finger41"] = {0xFA50, false},
    ["SKEL_R_Finger42"] = {0xFA51, false},
    ["PH_R_Hand"] = {0x6F06, false},
    ["IK_R_Hand"] = {0x188E, false},
    ["RB_R_ForeArmRoll"] = {0xAB22, false},
    ["RB_R_ArmRoll"] = {0x90FF, false},
    ["MH_R_Elbow"] = {0xBB0, false},
    ["SKEL_Neck_1"] = {0x9995, false},
    ["SKEL_Head"] = {0x796E, false},
    ["IK_Head"] = {0x322C, false},
    ["FACIAL_facialRoot"] = {0xFE2C, false},
    ["FB_L_Brow_Out_000"] = {0xE3DB, false},
    ["FB_L_Lid_Upper_000"] = {0xB2B6, false},
    ["FB_L_Eye_000"] = {0x62AC, false},
    ["FB_L_CheekBone_000"] = {0x542E, false},
    ["FB_L_Lip_Corner_000"] = {0x74AC, false},
    ["FB_R_Lid_Upper_000"] = {0xAA10, false},
    ["FB_R_Eye_000"] = {0x6B52, false},
    ["FB_R_CheekBone_000"] = {0x4B88, false},
    ["FB_R_Brow_Out_000"] = {0x54C, false},
    ["FB_R_Lip_Corner_000"] = {0x2BA6, false},
    ["FB_Brow_Centre_000"] = {0x9149, false},
    ["FB_UpperLipRoot_000"] = {0x4ED2, false},
    ["FB_UpperLip_000"] = {0xF18F, false},
    ["FB_L_Lip_Top_000"] = {0x4F37, false},
    ["FB_R_Lip_Top_000"] = {0x4537, false},
    ["FB_Jaw_000"] = {0xB4A0, false},
    ["FB_LowerLipRoot_000"] = {0x4324, false},
    ["FB_LowerLip_000"] = {0x508F, false},
    ["FB_L_Lip_Bot_000"] = {0xB93B, false},
    ["FB_R_Lip_Bot_000"] = {0xC33B, false},
    ["FB_Tongue_000"] = {0xB987, false},
    ["RB_Neck_1"] = {0x8B93, false},
    ["SPR_L_Breast"] = {0xFC8E, false},
    ["SPR_R_Breast"] = {0x885F, false},
    ["IK_Root"] = {0xDD1C, false},
    ["SKEL_Neck_2"] = {0x5FD4, false},
    ["SKEL_Pelvis1"] = {0xD003, false},
    ["SKEL_PelvisRoot"] = {0x45FC, false},
    ["SKEL_SADDLE"] = {0x9524, false},
    ["MH_L_CalfBack"] = {0x1013, false},
    ["MH_L_ThighBack"] = {0x600D, false},
    ["SM_L_Skirt"] = {0xC419, false},
    ["MH_R_CalfBack"] = {0xB013, false},
    ["MH_R_ThighBack"] = {0x51A3, false},
    ["SM_R_Skirt"] = {0x7712, false},
    ["SM_M_BackSkirtRoll"] = {0xDBB, false},
    ["SM_L_BackSkirtRoll"] = {0x40B2, false},
    ["SM_R_BackSkirtRoll"] = {0xC141, false},
    ["SM_M_FrontSkirtRoll"] = {0xCDBB, false},
    ["SM_L_FrontSkirtRoll"] = {0x9B69, false},
    ["SM_R_FrontSkirtRoll"] = {0x86F1, false},
    ["SM_CockNBalls_ROOT"] = {0xC67D, false},
    ["SM_CockNBalls"] = {0x9D34, false},
    ["MH_L_Finger00"] = {0x8C63, false},
    ["MH_L_FingerBulge00"] = {0x5FB8, false},
    ["MH_L_Finger10"] = {0x8C53, false},
    ["MH_L_FingerTop00"] = {0xA244, false},
    ["MH_L_HandSide"] = {0xC78A, false},
    ["MH_Watch"] = {0x2738, false},
    ["MH_L_Sleeve"] = {0x933C, false},
    ["MH_R_Finger00"] = {0x2C63, false},
    ["MH_R_FingerBulge00"] = {0x69B8, false},
    ["MH_R_Finger10"] = {0x2C53, false},
    ["MH_R_FingerTop00"] = {0xEF4B, false},
    ["MH_R_HandSide"] = {0x68FB, false},
    ["MH_R_Sleeve"] = {0x92DC, false},
    ["FACIAL_jaw"] = {0xB21, false},
    ["FACIAL_underChin"] = {0x8A95, false},
    ["FACIAL_L_underChin"] = {0x234E, false},
    ["FACIAL_chin"] = {0xB578, false},
    ["FACIAL_chinSkinBottom"] = {0x98BC, false},
    ["FACIAL_L_chinSkinBottom"] = {0x3E8F, false},
    ["FACIAL_R_chinSkinBottom"] = {0x9E8F, false},
    ["FACIAL_tongueA"] = {0x4A7C, false},
    ["FACIAL_tongueB"] = {0x4A7D, false},
    ["FACIAL_tongueC"] = {0x4A7E, false},
    ["FACIAL_tongueD"] = {0x4A7F, false},
    ["FACIAL_tongueE"] = {0x4A80, false},
    ["FACIAL_L_tongueE"] = {0x35F2, false},
    ["FACIAL_R_tongueE"] = {0x2FF2, false},
    ["FACIAL_L_tongueD"] = {0x35F1, false},
    ["FACIAL_R_tongueD"] = {0x2FF1, false},
    ["FACIAL_L_tongueC"] = {0x35F0, false},
    ["FACIAL_R_tongueC"] = {0x2FF0, false},
    ["FACIAL_L_tongueB"] = {0x35EF, false},
    ["FACIAL_R_tongueB"] = {0x2FEF, false},
    ["FACIAL_L_tongueA"] = {0x35EE, false},
    ["FACIAL_R_tongueA"] = {0x2FEE, false},
    ["FACIAL_chinSkinTop"] = {0x7226, false},
    ["FACIAL_L_chinSkinTop"] = {0x3EB3, false},
    ["FACIAL_chinSkinMid"] = {0x899A, false},
    ["FACIAL_L_chinSkinMid"] = {0x4427, false},
    ["FACIAL_L_chinSide"] = {0x4A5E, false},
    ["FACIAL_R_chinSkinMid"] = {0xF5AF, false},
    ["FACIAL_R_chinSkinTop"] = {0xF03B, false},
    ["FACIAL_R_chinSide"] = {0xAA5E, false},
    ["FACIAL_R_underChin"] = {0x2BF4, false},
    ["FACIAL_L_lipLowerSDK"] = {0xB9E1, false},
    ["FACIAL_L_lipLowerAnalog"] = {0x244A, false},
    ["FACIAL_L_lipLowerThicknessV"] = {0xC749, false},
    ["FACIAL_L_lipLowerThicknessH"] = {0xC67B, false},
    ["FACIAL_lipLowerSDK"] = {0x7285, false},
    ["FACIAL_lipLowerAnalog"] = {0xD97B, false},
    ["FACIAL_lipLowerThicknessV"] = {0xC5BB, false},
    ["FACIAL_lipLowerThicknessH"] = {0xC5ED, false},
    ["FACIAL_R_lipLowerSDK"] = {0xA034, false},
    ["FACIAL_R_lipLowerAnalog"] = {0xC2D9, false},
    ["FACIAL_R_lipLowerThicknessV"] = {0xC6E9, false},
    ["FACIAL_R_lipLowerThicknessH"] = {0xC6DB, false},
    ["FACIAL_nose"] = {0x20F1, false},
    ["FACIAL_L_nostril"] = {0x7322, false},
    ["FACIAL_L_nostrilThickness"] = {0xC15F, false},
    ["FACIAL_noseLower"] = {0xE05A, false},
    ["FACIAL_L_noseLowerThickness"] = {0x79D5, false},
    ["FACIAL_R_noseLowerThickness"] = {0x7975, false},
    ["FACIAL_noseTip"] = {0x6A60, false},
    ["FACIAL_R_nostril"] = {0x7922, false},
    ["FACIAL_R_nostrilThickness"] = {0x36FF, false},
    ["FACIAL_noseUpper"] = {0xA04F, false},
    ["FACIAL_L_noseUpper"] = {0x1FB8, false},
    ["FACIAL_noseBridge"] = {0x9BA3, false},
    ["FACIAL_L_nasolabialFurrow"] = {0x5ACA, false},
    ["FACIAL_L_nasolabialBulge"] = {0xCD78, false},
    ["FACIAL_L_cheekLower"] = {0x6907, false},
    ["FACIAL_L_cheekLowerBulge1"] = {0xE3FB, false},
    ["FACIAL_L_cheekLowerBulge2"] = {0xE3FC, false},
    ["FACIAL_L_cheekInner"] = {0xE7AB, false},
    ["FACIAL_L_cheekOuter"] = {0x8161, false},
    ["FACIAL_L_eyesackLower"] = {0x771B, false},
    ["FACIAL_L_eyeball"] = {0x1744, false},
    ["FACIAL_L_eyelidLower"] = {0x998C, false},
    ["FACIAL_L_eyelidLowerOuterSDK"] = {0xFE4C, false},
    ["FACIAL_L_eyelidLowerOuterAnalog"] = {0xB9AA, false},
    ["FACIAL_L_eyelashLowerOuter"] = {0xD7F6, false},
    ["FACIAL_L_eyelidLowerInnerSDK"] = {0xF151, false},
    ["FACIAL_L_eyelidLowerInnerAnalog"] = {0x8242, false},
    ["FACIAL_L_eyelashLowerInner"] = {0x4CCF, false},
    ["FACIAL_L_eyelidUpper"] = {0x97C1, false},
    ["FACIAL_L_eyelidUpperOuterSDK"] = {0xAF15, false},
    ["FACIAL_L_eyelidUpperOuterAnalog"] = {0x67FA, false},
    ["FACIAL_L_eyelashUpperOuter"] = {0x27B7, false},
    ["FACIAL_L_eyelidUpperInnerSDK"] = {0xD341, false},
    ["FACIAL_L_eyelidUpperInnerAnalog"] = {0xF092, false},
    ["FACIAL_L_eyelashUpperInner"] = {0x9B1F, false},
    ["FACIAL_L_eyesackUpperOuterBulge"] = {0xA559, false},
    ["FACIAL_L_eyesackUpperInnerBulge"] = {0x2F2A, false},
    ["FACIAL_L_eyesackUpperOuterFurrow"] = {0xC597, false},
    ["FACIAL_L_eyesackUpperInnerFurrow"] = {0x52A7, false},
    ["FACIAL_forehead"] = {0x9218, false},
    ["FACIAL_L_foreheadInner"] = {0x843, false},
    ["FACIAL_L_foreheadInnerBulge"] = {0x767C, false},
    ["FACIAL_L_foreheadOuter"] = {0x8DCB, false},
    ["FACIAL_skull"] = {0x4221, false},
    ["FACIAL_foreheadUpper"] = {0xF7D6, false},
    ["FACIAL_L_foreheadUpperInner"] = {0xCF13, false},
    ["FACIAL_L_foreheadUpperOuter"] = {0x509B, false},
    ["FACIAL_R_foreheadUpperInner"] = {0xCEF3, false},
    ["FACIAL_R_foreheadUpperOuter"] = {0x507B, false},
    ["FACIAL_L_temple"] = {0xAF79, false},
    ["FACIAL_L_ear"] = {0x19DD, false},
    ["FACIAL_L_earLower"] = {0x6031, false},
    ["FACIAL_L_masseter"] = {0x2810, false},
    ["FACIAL_L_jawRecess"] = {0x9C7A, false},
    ["FACIAL_L_cheekOuterSkin"] = {0x14A5, false},
    ["FACIAL_R_cheekLower"] = {0xF367, false},
    ["FACIAL_R_cheekLowerBulge1"] = {0x599B, false},
    ["FACIAL_R_cheekLowerBulge2"] = {0x599C, false},
    ["FACIAL_R_masseter"] = {0x810, false},
    ["FACIAL_R_jawRecess"] = {0x93D4, false},
    ["FACIAL_R_ear"] = {0x1137, false},
    ["FACIAL_R_earLower"] = {0x8031, false},
    ["FACIAL_R_eyesackLower"] = {0x777B, false},
    ["FACIAL_R_nasolabialBulge"] = {0xD61E, false},
    ["FACIAL_R_cheekOuter"] = {0xD32, false},
    ["FACIAL_R_cheekInner"] = {0x737C, false},
    ["FACIAL_R_noseUpper"] = {0x1CD6, false},
    ["FACIAL_R_foreheadInner"] = {0xE43, false},
    ["FACIAL_R_foreheadInnerBulge"] = {0x769C, false},
    ["FACIAL_R_foreheadOuter"] = {0x8FCB, false},
    ["FACIAL_R_cheekOuterSkin"] = {0xB334, false},
    ["FACIAL_R_eyesackUpperInnerFurrow"] = {0x9FAE, false},
    ["FACIAL_R_eyesackUpperOuterFurrow"] = {0x140F, false},
    ["FACIAL_R_eyesackUpperInnerBulge"] = {0xA359, false},
    ["FACIAL_R_eyesackUpperOuterBulge"] = {0x1AF9, false},
    ["FACIAL_R_nasolabialFurrow"] = {0x2CAA, false},
    ["FACIAL_R_temple"] = {0xAF19, false},
    ["FACIAL_R_eyeball"] = {0x1944, false},
    ["FACIAL_R_eyelidUpper"] = {0x7E14, false},
    ["FACIAL_R_eyelidUpperOuterSDK"] = {0xB115, false},
    ["FACIAL_R_eyelidUpperOuterAnalog"] = {0xF25A, false},
    ["FACIAL_R_eyelashUpperOuter"] = {0xE0A, false},
    ["FACIAL_R_eyelidUpperInnerSDK"] = {0xD541, false},
    ["FACIAL_R_eyelidUpperInnerAnalog"] = {0x7C63, false},
    ["FACIAL_R_eyelashUpperInner"] = {0x8172, false},
    ["FACIAL_R_eyelidLower"] = {0x7FDF, false},
    ["FACIAL_R_eyelidLowerOuterSDK"] = {0x1BD, false},
    ["FACIAL_R_eyelidLowerOuterAnalog"] = {0x457B, false},
    ["FACIAL_R_eyelashLowerOuter"] = {0xBE49, false},
    ["FACIAL_R_eyelidLowerInnerSDK"] = {0xF351, false},
    ["FACIAL_R_eyelidLowerInnerAnalog"] = {0xE13, false},
    ["FACIAL_R_eyelashLowerInner"] = {0x3322, false},
    ["FACIAL_L_lipUpperSDK"] = {0x8F30, false},
    ["FACIAL_L_lipUpperAnalog"] = {0xB1CF, false},
    ["FACIAL_L_lipUpperThicknessH"] = {0x37CE, false},
    ["FACIAL_L_lipUpperThicknessV"] = {0x38BC, false},
    ["FACIAL_lipUpperSDK"] = {0x1774, false},
    ["FACIAL_lipUpperAnalog"] = {0xE064, false},
    ["FACIAL_lipUpperThicknessH"] = {0x7993, false},
    ["FACIAL_lipUpperThicknessV"] = {0x7981, false},
    ["FACIAL_L_lipCornerSDK"] = {0xB1C, false},
    ["FACIAL_L_lipCornerAnalog"] = {0xE568, false},
    ["FACIAL_L_lipCornerThicknessUpper"] = {0x7BC, false},
    ["FACIAL_L_lipCornerThicknessLower"] = {0xDD42, false},
    ["FACIAL_R_lipUpperSDK"] = {0x7583, false},
    ["FACIAL_R_lipUpperAnalog"] = {0x51CF, false},
    ["FACIAL_R_lipUpperThicknessH"] = {0x382E, false},
    ["FACIAL_R_lipUpperThicknessV"] = {0x385C, false},
    ["FACIAL_R_lipCornerSDK"] = {0xB3C, false},
    ["FACIAL_R_lipCornerAnalog"] = {0xEE0E, false},
    ["FACIAL_R_lipCornerThicknessUpper"] = {0x54C3, false},
    ["FACIAL_R_lipCornerThicknessLower"] = {0x2BBA, false},
    ["MH_MulletRoot"] = {0x3E73, false},
    ["MH_MulletScaler"] = {0xA1C2, false},
    ["MH_Hair_Scale"] = {0xC664, false},
    ["MH_Hair_Crown"] = {0x1675, false},
    ["SM_Torch"] = {0x8D6, false},
    ["FX_Light"] = {0x8959, false},
    ["FX_Light_Scale"] = {0x5038, false},
    ["FX_Light_Switch"] = {0xE18E, false},
    ["BagRoot"] = {0xAD09, false},
    ["BagPivotROOT"] = {0xB836, false},
    ["BagPivot"] = {0x4D11, false},
    ["BagBody"] = {0xAB6D, false},
    ["BagBone_R"] = {0x937, false},
    ["BagBone_L"] = {0x991, false},
    ["SM_LifeSaver_Front"] = {0x9420, false},
    ["SM_R_Pouches_ROOT"] = {0x2962, false},
    ["SM_R_Pouches"] = {0x4141, false},
    ["SM_L_Pouches_ROOT"] = {0x2A02, false},
    ["SM_L_Pouches"] = {0x4B41, false},
    ["SM_Suit_Back_Flapper"] = {0xDA2D, false},
    ["SPR_CopRadio"] = {0x8245, false},
    ["SM_LifeSaver_Back"] = {0x2127, false},
    ["MH_BlushSlider"] = {0xA0CE, false},
    ["SKEL_Tail_01"] = {0x347, false},
    ["SKEL_Tail_02"] = {0x348, false},
    ["MH_L_Concertina_B"] = {0xC988, false},
    ["MH_L_Concertina_A"] = {0xC987, false},
    ["MH_R_Concertina_B"] = {0xC8E8, false},
    ["MH_R_Concertina_A"] = {0xC8E7, false},
    ["MH_L_ShoulderBladeRoot"] = {0x8711, false},
    ["MH_L_ShoulderBlade"] = {0x4EAF, false},
    ["MH_R_ShoulderBladeRoot"] = {0x3A0A, false},
    ["MH_R_ShoulderBlade"] = {0x54AF, false},
    ["FB_R_Ear_000"] = {0x6CDF, false},
    ["SPR_R_Ear"] = {0x63B6, false},
    ["FB_L_Ear_000"] = {0x6439, false},
    ["SPR_L_Ear"] = {0x5B10, false},
    ["FB_TongueA_000"] = {0x4206, false},
    ["FB_TongueB_000"] = {0x4207, false},
    ["FB_TongueC_000"] = {0x4208, false},
    ["SKEL_L_Toe1"] = {0x1D6B, false},
    ["SKEL_R_Toe1"] = {0xB23F, false},
    ["SKEL_Tail_03"] = {0x349, false},
    ["SKEL_Tail_04"] = {0x34A, false},
    ["SKEL_Tail_05"] = {0x34B, false},
    ["SPR_Gonads_ROOT"] = {0xBFDE, false},
    ["SPR_Gonads"] = {0x1C00, false},
    ["FB_L_Brow_Out_001"] = {0xE3DB, false},
    ["FB_L_Lid_Upper_001"] = {0xB2B6, false},
    ["FB_L_Eye_001"] = {0x62AC, false},
    ["Left FB_L_CheekBone_001"] = {0x542E, false},
    ["FB_L_Lip_Corner_001"] = {0x74AC, false},
    ["FB_R_Lid_Upper_001"] = {0xAA10, false},
    ["FB_R_Eye_001"] = {0x6B52, false},
    ["FB_R_CheekBone_001"] = {0x4B88, false},
    ["FB_R_Brow_Out_001"] = {0x54C, false},
    ["FB_R_Lip_Corner_001"] = {0x2BA6, false},
    ["FB_Brow_Centre_001"] = {0x9149, false},
    ["FB_UpperLipRoot_001"] = {0x4ED2, false},
    ["FB_UpperLip_001"] = {0xF18F, false},
    ["FB_L_Lip_Top_001"] = {0x4F37, false},
    ["FB_R_Lip_Top_001"] = {0x4537, false},
    ["FB_Jaw_001"] = {0xB4A0, false},
    ["FB_LowerLipRoot_001"] = {0x4324, false},
    ["FB_LowerLip_001"] = {0x508F, false},
    ["FB_L_Lip_Bot_001"] = {0xB93B, false},
    ["FB_R_Lip_Bot_001"] = {0xC33B, false},
    ["FB_Tongue_001"] = {0xB987, false}
}

local health
local multi
local pulse = 70
local area = "Unknown"
local lastHit
local blood = 100
local bleeding = 0
local dead = false
local timer = 0

local cPulse = -1
local cBlood = -1
local cNameF = ""
local cNameL = ""
local cArea = ""
local cBleeding = "NONE"
local damaged_bones = {}

function tvRP.getPlayerPulse()
  local health = GetEntityHealth(GetPlayerPed(-1))
	if health > 0 then
		pulse = (health / 4 + math.random(19, 28))
	end
	print(pulse)
  return pulse
	--local hit, bone = GetPedLastDamageBone(GetPlayerPed(-1))
	--print(bone)
end

function tvRP.getLastInjury()
  local string = ""
  for k,v in pairs(allHumanBones) do
    if v[2] then
      string = string.." "..k
    end
  end
  if string == "" then
    string = "No injuries found"
  else
    string = "Injuries found in the fellowing body parts: "..string
  end

	return string
end

function tvRP.clearBoneDamage()
  for k3,v3 in pairs(allHumanBones) do
    v3[2] = false
  end
  print("Damage cleared")
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local ped = GetPlayerPed(-1)
    local hit, bone = GetPedLastDamageBone(ped)
    if hit ~= nil and hit then
      for k1, v1 in pairs(allHumanBones) do
        if tonumber(v1[1]) == bone then
          ClearPedLastDamageBone(ped)
          v1[2] = true
          print(k1)
          --table.insert(damaged_bones, bone)
        end
      end
    end
  end
end)
