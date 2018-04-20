
local noclip = false
local noclip_speed = 1.0
local admin = false
local godmode = false

function tvRP.toggleNoclip()
  noclip = not noclip
  local ped = GetPlayerPed(-1)
  if noclip then -- set
    SetEntityInvincible(ped, true)
    SetEntityVisible(ped, false, false)
    SetEntityCollision(ped,false,false)
  else -- unset
    if not godmode then
      SetEntityInvincible(ped, false)
    end
    SetEntityVisible(ped, true, false)
    SetEntityCollision(ped,true,true)
  end
end

function tvRP.toggleGodMode(flag)
  local ped = GetPlayerPed(-1)
  godmode = flag
  if flag then -- set
    SetEntityInvincible(ped, true)
    godModeThread()
  else -- unset
    SetEntityInvincible(ped, false)
  end
end

function tvRP.getGodModeState()
  return godmode
end

function godModeThread()
  if tvRP.isAdmin() then
    Citizen.CreateThread(function()
      while godmode do
        Citizen.Wait(500)
        SetEntityHealth(GetPlayerPed(-1),200)
      end
    end)
  end
end

function tvRP.isNoclip()
  return noclip
end

function tvRP.setAdmin(flag)
  admin = flag
end

function tvRP.isAdmin()
  return admin
end

-- Teleport to waypoint is from mellotrainer
function tvRP.teleportWaypoint()
  local targetPed = GetPlayerPed(-1)
  if(IsPedInAnyVehicle(targetPed))then
    targetPed = GetVehiclePedIsUsing(targetPed)
  end

  if(not IsWaypointActive())then
    return
  end

  local waypointBlip = GetFirstBlipInfoId(8) -- 8 = Waypoint ID
  local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector()))

  -- Ensure Entity teleports above the ground
  local ground
  local groundFound = false
  local groundCheckHeights = {0.0, 50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0}


  for i,height in ipairs(groundCheckHeights) do
    RequestCollisionAtCoord(x, y, height)
    Wait(0)
    SetEntityCoordsNoOffset(targetPed, x,y,height, 0, 0, 1)
    ground,z = GetGroundZFor_3dCoord(x,y,height)
    if(ground) then
      z = z + 3
      groundFound = true
      break;
    end
  end

  if(not groundFound)then
    z = 1000
    GiveDelayedWeaponToPed(PlayerPedId(), 0xFBAB5776, 1, 0) -- Parachute
  end

  SetEntityCoordsNoOffset(targetPed, x,y,z, 0, 0, 1)
end

-- noclip/invisibility
Citizen.CreateThread(function()
  local speed = noclip_speed
  while true do
    Citizen.Wait(0)
    if noclip then
      local ped = GetPlayerPed(-1)
      local x,y,z = tvRP.getPosition()
      local dx,dy,dz = tvRP.getCamDirection()

      if IsControlPressed(0,21) then
        speed = noclip_speed * 2.0
      end
      if IsControlReleased(0,21) then
        speed = noclip_speed
      end

      -- reset velocity
      SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)

      -- forward
      if IsControlPressed(0,32) then -- MOVE UP
        x = x+speed*dx
        y = y+speed*dy
        z = z+speed*dz
      end

      -- backward
      if IsControlPressed(0,269) then -- MOVE DOWN
        x = x-speed*dx
        y = y-speed*dy
        z = z-speed*dz
      end

      SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
    end
  end
end)

function tvRP.adminSpawnVehicle(name)
  if name ~= nil and name ~= "" then
    local myPed = GetPlayerPed(-1)
    local player = PlayerId()
    local mhash = GetHashKey(name)

    local i = 0
    while not HasModelLoaded(mhash) and i < 10000 do
      RequestModel(mhash)
      Citizen.Wait(10)
      i = i+1
    end

    if HasModelLoaded(mhash) then
      local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
      local spawned_car = CreateVehicle(mhash, coords, GetEntityHeading(myPed), true, false)
      Citizen.Trace("Admin spawn")
      SetVehicleOnGroundProperly(spawned_car)
      Citizen.Wait(10)
      SetVehicleEngineOn(spawned_car, true, true)
      SetVehicleDoorsLocked(spawned_car,0)
      SetVehicleDoorsLockedForAllPlayers(spawned_car, false)
      SetVehicleDoorsLockedForPlayer(spawned_car, PlayerId(), false)
      SetModelAsNoLongerNeeded(mhash)
      Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(spawned_car))
    end
  end
end
