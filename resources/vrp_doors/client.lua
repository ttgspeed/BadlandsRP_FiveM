--[[-----------------
 	Doors Control By XanderWP from Ukraine with <3
 ------------------------]]--
vRP = Proxy.getInterface("vRP")

local doors = {}
local LockHotkey = {0,303}

RegisterNetEvent('vrpdoorsystem:load')
AddEventHandler('vrpdoorsystem:load', function(list)
  doors = list
end)

RegisterNetEvent('vrpdoorsystem:statusSend')
AddEventHandler('vrpdoorsystem:statusSend', function(i, status)
  doors[i].locked = status
  if status then
    displayDoorState(i, "Locked")
  else
    displayDoorState(i, "Unlocked")
  end
end)

local activeDisplay = false

function displayDoorState(id, text)
  local x = doors[id].x
  local y = doors[id].y
  local z = doors[id].z
  local text = text
  if IsEntityAtCoord(GetPlayerPed(-1), x, y, z, 3.0001, 3.0001, 3.0001, 0, 1, 0) then
    Citizen.CreateThread(function()
      local displayTime = 250
      while displayTime > 0 do
        Citizen.Wait(1)
        displayTime = displayTime - 1
        DrawText3Ds(text, x, y, z)
      end
    end)
  end
end

function searchIdDoor()
  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
  for k,v in pairs(doors) do
    if GetDistanceBetweenCoords(x,y,z,v.x,v.y,v.z,true) <= 1.5 then
      return k
    end
  end
  return 0
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if IsControlJustPressed(table.unpack(LockHotkey)) then
      if vRP.isCop({}) then
        local id = searchIdDoor()
        if id ~= 0 then
          TriggerServerEvent("vrpdoorsystem:open", id)
          Citizen.Wait(5000) -- Prevent spam that will cause server lag
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(100)
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    for k,v in pairs(doors) do
      if GetDistanceBetweenCoords(x,y,z,v.x,v.y,v.z,true) <= 10 then
        local door = GetClosestObjectOfType(v.x,v.y,v.z, 1.0, v.hash, false, false, false)
        if door ~= 0 then
          SetEntityCanBeDamaged(door, false)
          if v.locked == false then
            NetworkRequestControlOfEntity(door)
            FreezeEntityPosition(door, false)
          else
            local locked, heading = GetStateOfClosestDoorOfType(v.hash, v.x,v.y,v.z, locked, heading)
            if heading > -0.02 and heading < 0.02 then
              NetworkRequestControlOfEntity(door)
              FreezeEntityPosition(door, true)
            end
          end
        end
      end
    end
  end
end)

function DrawText3Ds(text, x, y, z)
	local scale = 0.4
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)

	AddTextComponentString(text)
	DrawText(_x, _y)

	local factor = (string.len(text)) / 370

	DrawRect(_x, _y + 0.0150, 0.030 + factor, 0.025, 41, 11, 41, 100)
end
