
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

function tvRP.teleportWaypoint()
  local playerPed = GetPlayerPed(-1)
  local WaypointHandle = GetFirstBlipInfoId(8)
  if DoesBlipExist(WaypointHandle) then
    local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
    tvRP.teleport(coord.x,coord.y,coord.z)
  else
    tvRP.notify("No waypoint set.")
  end
end

-- noclip/invisibility
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if noclip then
      local ped = GetPlayerPed(-1)
      local x,y,z = tvRP.getPosition()
      local dx,dy,dz = tvRP.getCamDirection()
      local speed = noclip_speed

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
