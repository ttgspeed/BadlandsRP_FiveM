vRPserver = Tunnel.getInterface("vRP","vRP")
vRP = Proxy.getInterface("vRP")

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

-- Toggle car lock (Example of Vehcile's menu)
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

RegisterNUICallback('repairVehicle', function(data)
  vRPserver.ch_repair({})
end)

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
      if showMenu == false then
        SetNuiFocus(false, false)
      end
      Crosshair(true)

      if IsControlJustReleased(1, 38) then -- E is pressed
        showMenu = true
        SetNuiFocus(true, true)
        SendNUIMessage({
          menu = 'vehicle',
          idEntity = Entity
        })
      end
    -- If EntityType = User
    elseif(EntityType == 1) then
      if showMenu == false then
        SetNuiFocus(false, false)
      end
      Crosshair(true)

      if IsControlJustReleased(1, 38) then -- E is pressed
        showMenu = true
        SetNuiFocus(true, true)
        SendNUIMessage({
          menu = 'user',
          idEntity = Entity
        })
      end
    else
      if IsControlPressed(1, 21) and IsControlJustReleased(1, 38) then -- E is pressed
        showMenu = true
        selfMenu = true
        SetNuiFocus(true, true)
        SendNUIMessage({
          menu = 'self',
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
      if IsControlPressed(1, 38) then
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
