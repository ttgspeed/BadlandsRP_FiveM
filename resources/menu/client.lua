vRPserver = Tunnel.getInterface("vRP","vRP")
vRP = Proxy.getInterface("vRP")
vRPcustom = Proxy.getInterface("CustomScripts")

------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------

local showMenu = false
local selfMenu = false
local toggleTrunk = 0
local toggleHood = 0
local toggleLocked = 0
local playing_emote = false

------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------

-- Show crosshair (circle) when player targets entities (vehicle, pedestrian…)
function Crosshair(enable)
  SendNUIMessage({
    crosshair = enable
  })
end

-- Toggle focus (Example of Vehcile's menu)
RegisterNUICallback('disablenuifocus', function(data)
  showMenu = data.nuifocus
  selfMenu = data.nuifocus
  SetNuiFocus(data.nuifocus, data.nuifocus)
end)

-- Toggle car trunk (Example of Vehcile's menu)
RegisterNUICallback('toggletrunk', function(data)
  print("I got here")
  if(toggleTrunk == 0)then
    SetVehicleDoorOpen(data.id, 5, false)
    toggleTrunk = 1
  else
    SetVehicleDoorShut(data.id, 5, false)
    toggleTrunk = 0
  end
end)

-- Toggle car hood (Example of Vehcile's menu)
RegisterNUICallback('togglehood', function(data)
  if(toggleHood == 0)then
    SetVehicleDoorOpen(data.id, 4, false)
    toggleHood = 1
  else
    SetVehicleDoorShut(data.id, 4, false)
    toggleHood = 0
  end
end)

---------- Start Civ self functions --------------------
RegisterNUICallback('togglelock', function(data)
  vRP.newLockToggle({})
end)

RegisterNUICallback('aptitudes', function(data)
  vRPserver.ch_aptitude({})
end)

RegisterNUICallback('viewOwnID', function(data)
  vRPserver.ch_viewOwnID({})
end)

RegisterNUICallback('openOwnInventory', function(data)
  vRPserver.openInventory({})
end)
---------- END Civ self functions --------------------

---------- Start LSFD self functions --------------------
RegisterNUICallback('toggleEmsDispatch', function(data)
  vRPserver.choice_ems_missions({})
end)

RegisterNUICallback('emsMobileTerminal', function(data)
  TriggerEvent('LoadCalls', false, "EMS/Fire", "dispatch")
end)
---------- END LSFD self functions --------------------

---------- Start LSPD self functions --------------------
RegisterNUICallback('toggleSpikeStrip', function(data)
  vRP.setSpikesOnGround({})
end)

RegisterNUICallback('viewWantedRecords', function(data)
  if vRP.isInProtectedVeh() then
    TriggerEvent('LoadCalls', false, "Police", "mdt")
  end
end)

RegisterNUICallback('pdMobileTerminal', function(data)
  TriggerEvent('LoadCalls', false, "Police", "dispatch")
end)

-- this is also a FD function
RegisterNUICallback('stopEscorting', function(data)
  local ped = GetPlayerPed(-1)
  local pos = GetEntityCoords(ped)
  local nearServId = vRP.getNearestPlayer({2})
  if nearServId ~= nil and not IsPedInAnyVehicle(ped, true) then
    local target = GetPlayerPed(GetPlayerFromServerId(nearServId))
    if target ~= 0 and IsEntityAPed(target) then
      if HasEntityClearLosToEntityInFront(ped,target) then
        vRPserver.stopEscortPlayer({nearServId})
      end
    end
  end
end)
---------- END LSPD self functions --------------------

---------- Start Civ target player functions --------------
RegisterNUICallback('giveId', function(data)
  vRPserver.giveId({data.id})
end)

RegisterNUICallback('giveMoney', function(data)
  vRPserver.ch_give_money({data.id})
end)

---------- End Civ target player functions --------------

---------- Start LSFD target player functions --------------
RegisterNUICallback('dragDeadPlayers', function(data)
  vRPserver.choice_escort({data.id})
end)

RegisterNUICallback('performCpr', function(data)
  vRPserver.choice_cpr({data.id})
end)

RegisterNUICallback('reviveTarget', function(data)
  vRPserver.choice_revive({data.id})
end)

RegisterNUICallback('fieldTreatment', function(data)
  vRPserver.choice_field_treatment({data.id})
end)

RegisterNUICallback('checkTargetPulse', function(data)
  vRPserver.choice_checkpulse({data.id})
end)

RegisterNUICallback('checkTargetInjuries', function(data)
  vRPserver.choice_checklastinjury({data.id})
end)

RegisterNUICallback('toggleBedState', function(data)
  vRPserver.choice_toggleBedState({data.id})
end)

RegisterNUICallback('putTargetInNearestVehMed', function(data)
  vRPserver.choice_putinvehMed({data.id})
end)
---------- End LSFD target player functions --------------

---------- Start LSPD target player functions --------------
RegisterNUICallback('restrainTarget', function(data)
  vRPserver.choice_handcuff({data.id})
end)

RegisterNUICallback('escortTarget', function(data)
  vRPserver.escortPlayer({data.id})
end)

RegisterNUICallback('putTargetInNearestVehPd', function(data)
  vRPserver.choice_putinveh({data.id})
end)

RegisterNUICallback('checkTargetIdPd', function(data)
  vRPserver.choice_checkidPd({data.id})
end)

RegisterNUICallback('checkTargetPd', function(data)
  vRPserver.choice_checkPd({data.id})
end)

RegisterNUICallback('seizeTargetWeapons', function(data)
  vRPserver.choice_seize_weapons({data.id})
end)

RegisterNUICallback('seizeTargetPedItems', function(data)
  vRPserver.choice_seize_items({data.id})
end)

RegisterNUICallback('seizeTargetPedItems', function(data)
  vRPserver.choice_seize_items({data.id})
end)

RegisterNUICallback('jailTarget', function(data)
  vRPserver.choice_jail({data.id})
end)

RegisterNUICallback('sendTargetPrison', function(data)
  vRPserver.choice_prison({data.id})
end)

RegisterNUICallback('fineTarget', function(data)
  vRPserver.choice_fine({data.id})
end)

RegisterNUICallback('revokeTargetKeys', function(data)
  vRPserver.choice_revoke_keys({data.id})
end)

RegisterNUICallback('revokeDriversLicense', function(data)
  vRPserver.choice_seize_driverlicense({data.id})
end)

RegisterNUICallback('revokeFirearmLicense', function(data)
  vRPserver.choice_seize_firearmlicense({data.id})
end)

RegisterNUICallback('gsrTarget', function(data)
  vRPserver.choice_gsr_test({data.id})
end)

RegisterNUICallback('toggleShackles', function(data)
  vRPserver.choice_handcuff_movement({data.id})
end)
---------- End LSPD target player functions --------------

---------- Start Civ vehicle functions --------------------
RegisterNUICallback('repairVehicle', function(data)
  vRPserver.ch_repair({})
end)

RegisterNUICallback('accessTrunk', function(data)
  carModel = GetEntityModel(data.id)
  carName = GetDisplayNameFromVehicleModel(carModel)
  vRPserver.accessTrunk({carName})
end)
---------- END Civ vehicle functions --------------------

---------- Start self internal vehicle functions ----------
RegisterNUICallback('rollWindows', function(data)
  vRP.rollWindows({})
end)

RegisterNUICallback('toggleEngine', function(data)
  vRPcustom.toggleEngine({})
end)

RegisterNUICallback('domeLight', function(data)
  if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
    if IsVehicleInteriorLightOn(data.id) then
      SetVehicleInteriorlight(data.id, false)
    else
      SetVehicleInteriorlight(data.id, true)
    end
  end
end)

RegisterNUICallback('toggleSeatbelt', function(data)
  vRP.toggleSeatbelt({})
end)
---------- END self internal vehicle functions --------------------

---------- Start external vehicle functions -----------------------
RegisterNUICallback('storeGetShotgun', function(data)
  local class = GetVehicleClass(data.id)
  if class ~= nil and class == 18 then
    vRP.storeCopWeapon({"WEAPON_PUMPSHOTGUN"})
  end
end)

RegisterNUICallback('storeGetSmg', function(data)
  local class = GetVehicleClass(data.id)
  if class ~= nil and class == 18 then
    vRP.storeCopWeapon({"WEAPON_SMG"})
  end
end)

RegisterNUICallback('repairCopItems', function(data)
  local class = GetVehicleClass(data.id)
  if class ~= nil and class == 18 then
    vRP.setFiringPinState({true})
  end
end)

RegisterNUICallback('searchTargetVehicle', function(data)
  local carName, plate = getVehicleData(data.id)
  if carName ~= nil and plate ~= nil then
    vRPserver.choice_check_vehicle({carName,plate})
  end
end)

RegisterNUICallback('searchTargetVin', function(data)
  local carName, plate = getVehicleData(data.id)
  if carName ~= nil and plate ~= nil then
    vRPserver.searchVehicleVin({carName,plate})
  end
end)

RegisterNUICallback('seizeVehicle', function(data)
  local carName, plate = getVehicleData(data.id)
  if carName ~= nil and plate ~= nil then
    vRPserver.choice_seize_vehicle({data.id,carName,plate})
  end
end)

RegisterNUICallback('seizeVehicleItems', function(data)
  local carName, plate = getVehicleData(data.id)
  if carName ~= nil and plate ~= nil then
    vRPserver.choice_seize_veh_items({data.id,carName,plate})
  end
end)

RegisterNUICallback('impoundVehicle', function(data)
  vRPserver.choice_impoundveh({})
end)

RegisterNUICallback('pullPlayerFromVeh', function(data)
  vRPserver.choice_getoutveh({})
end)
---------- END external vehicle functions -----------------------

function getVehicleData(vehicle)
  local carModel = GetEntityModel(vehicle)
  local carName = GetDisplayNameFromVehicleModel(carModel)
  local plate = GetVehicleNumberPlateText(vehicle)
  local args = vRP.stringsplit({plate})
  if args ~= nil then
    plate = args[1]
    return carName, plate
  end
  return nil, nil
end

-- Example of animation (Ped's menu)
RegisterNUICallback('cheer', function(data)
  playerPed = GetPlayerPed(-1);
		if(not IsPedInAnyVehicle(playerPed)) then
			if playerPed then
				if playing_emote == false then
					TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_CHEERING', 0, true);
					playing_emote = true
				end
			end
		end
end)

------------------------------------------------------------------
--                          Citizen
------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
    local Ped = GetPlayerPed(-1)

    -- Get informations about what user is targeting
    -- /!\ If not working, check that you have added "target" folder to resources and server.cfg
    local Entity, farCoordsX, farCoordsY, farCoordsZ = Target(6.0, Ped)
    local EntityType = GetEntityType(Entity)

    -- If EntityType is Vehicle
    if(EntityType == 2) then
      Crosshair(true)

      if IsControlJustReleased(1, 244) then -- E is pressed
        local faction = '.menu-car-civ-target'
        if vRP.isCop({}) then
          faction = '.menu-car-lspd-target'
        elseif vRP.isMedic({}) then
          faction = '.menu-car-lsfd-target'
        end

        showMenu = true
        SetNuiFocus(true, true)
        SendNUIMessage({
          menu = 'vehicle',
          class = faction,
          idEntity = Entity
        })
      end
    -- If EntityType = User
    elseif(EntityType == 1) then
      Crosshair(true)

      if IsControlJustReleased(1, 244) then -- E is pressed
        EntityID = GetPlayerByEntityID(Entity)
        if EntityID ~= nil and NetworkIsPlayerActive(EntityID) then
          Entity = GetPlayerServerId(EntityID)
        end
        local faction = '.menu-user-civ-target'
        if vRP.isCop({}) then
          faction = '.menu-user-lspd-target'
        elseif vRP.isMedic({}) then
          faction = '.menu-user-lsfd-target'
        end

        showMenu = true
        SetNuiFocus(true, true)
        SendNUIMessage({
          menu = 'user',
          class = faction,
          idEntity = Entity
        })
      end
    else
      if IsControlPressed(1, 21) and IsControlJustReleased(1, 244) then -- E is pressed
        showMenu = true
        selfMenu = true
        local menuType = "self"
        Entity = GetPlayerPed(-1)
        local faction = '.menu-self-civ'
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
          menuType = "vehSelf"
          Entity = GetVehiclePedIsIn(GetPlayerPed(-1), false)
          faction = '.menu-self-civ-veh'
          if vRP.isCop({}) then
            faction = '.menu-self-lspd-veh'
          elseif vRP.isMedic({}) then
            faction = '.menu-self-lsfd-veh'
          end
        else
          faction = '.menu-self-civ'
          if vRP.isCop({}) then
            faction = '.menu-self-lspd'
          elseif vRP.isMedic({}) then
            faction = '.menu-self-lsfd'
          end
        end
        SetNuiFocus(true, true)
        SendNUIMessage({
          menu = menuType,
          class = faction,
          idEntity = Entity
        })
      end
      if not selfMenu then
        SendNUIMessage({
          menu = false
        })
        if showMenu then
          SetNuiFocus(false, false)
        end
      end
      Crosshair(false)
    end


    -- Stop emotes if user press E
    -- TODO: Stop emotes if user move
    if playing_emote == true then
      if IsControlPressed(1, 244) then
        ClearPedTasks(Ped)
        playing_emote = false
      end
    end

    Citizen.Wait(1)
	end
end)

------------------------------------------------------------------
--                          Functions
------------------------------------------------------------------

-- Get entity in front of player
function GetEntInFrontOfPlayer(Distance, Ped)
  local Ent = nil
  local CoA = GetEntityCoords(Ped, 1)
  local CoB = GetOffsetFromEntityInWorldCoords(Ped, 0.0, Distance, 0.0)
  local RayHandle = StartShapeTestRay(CoA.x, CoA.y, CoA.z, CoB.x, CoB.y, CoB.z, -1, Ped, 0)
  local A,B,C,D,Ent = GetRaycastResult(RayHandle)
  return Ent
end

-- Camera's coords
function GetCoordsFromCam(distance)
  local rot = GetGameplayCamRot(2)
  local coord = GetGameplayCamCoord()

  local tZ = rot.z * 0.0174532924
  local tX = rot.x * 0.0174532924
  local num = math.abs(math.cos(tX))

  newCoordX = coord.x + (-math.sin(tZ)) * (num + distance)
  newCoordY = coord.y + (math.cos(tZ)) * (num + distance)
  local angleMulti = 8.0
  if IsPedInAnyVehicle(GetPlayerPed(-1), false) then -- TODO review this
    angleMulti = 16.0
  end
  newCoordZ = coord.z + (math.sin(tX) * angleMulti)
  return newCoordX, newCoordY, newCoordZ
end

-- Get entity's ID and coords from where player sis targeting
function Target(Distance, Ped)
  local Entity = nil
  local camCoords = GetGameplayCamCoord()
  local farCoordsX, farCoordsY, farCoordsZ = GetCoordsFromCam(Distance)
  local RayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, farCoordsX, farCoordsY, farCoordsZ, -1, Ped, 0)
  local A,B,C,D,Entity = GetRaycastResult(RayHandle)
  return Entity, farCoordsX, farCoordsY, farCoordsZ
end

function GetPlayerByEntityID(id)
  for _, i in ipairs(GetActivePlayers()) do
    if(GetPlayerPed(i) == id) then return i end
  end
	return nil
end
