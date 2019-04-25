local active_host = false

RegisterNetEvent('vRP:initiateRace')
AddEventHandler('vRP:initiateRace', function(betAmount, randomTrack)
  if betAmount == nil or betAmount < 0 then
    betAmount = 0
  end
  if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    if veh ~= nil and (GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)) then
      if not active_host then
        active_host = true
        local point_found = false
        local x = 0.0
        local y = 0.0
        local z = 0.0
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local raceCoord = nil
        local masterTimeout = 1000

        if randomTrack == 1 then
          x, y, z = getRandomCoord()
          local masterTimeout = 1000
          while not point_found and masterTimeout > 0 do
            Citizen.Wait(1)
            _bool, raceCoord = GetClosestVehicleNode(x, y, z, 0, 100.0, 2.5)
            if _bool then
              if raceCoord ~= nil then
                point_found = true
              end
            else
              x, y, z = getRandomCoord()
            end
            masterTimeout = masterTimeout - 1
          end
        else
          if IsWaypointActive() then
            waypointBlip = GetFirstBlipInfoId(8) -- 8 = Waypoint ID
            raceCoord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector())
          else
            tvRP.notify("You did not provide a race end point and decline random race generation.")
          end
        end

        if raceCoord ~= nil then
          vRPserver.promptNearbyRace({pos.x, pos.y, pos.z, raceCoord.x, raceCoord.y, raceCoord.z, betAmount})
        end
        active_host = false
      end
    else
      tvRP.notify("You must be in the drivers seat")
    end
  else
    tvRP.notify("You are not in a vehicle")
  end
end)

local inRace = false
local preRace = false

RegisterNetEvent('vRP:quitRace')
AddEventHandler('vRP:quitRace', function()
  inRace = false
end)

function tvRP.signalStart()
  preRace = false
end

function tvRP.startRace(raceID,rCoordx,rCoordy,rCoordz)
  if not inRace then
    SetNewWaypoint(rCoordx,rCoordy)
    inRace = true
    preRace = true
    local falseStart = false
    local startposX,startposY,startposZ = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
    while preRace do
      Citizen.Wait(0)
      curX,curY,curZ = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
      tvRP.drawText3Ds("Don't move or risk disqualification", curX,curY,curZ)
      if GetDistanceBetweenCoords(curX,curY,curZ,startposX,startposY,startposZ,true) > 2.0001 then
        preRace = false
        inRace = false
        falseStart = true
      end
    end
    if not falseStart then
      SetNewWaypoint(rCoordx,rCoordy)
      tvRP.notify("GO GO GO!!!")
      Citizen.CreateThread(function()
      	while inRace do
      		Citizen.Wait(0)
          if IsEntityAtCoord(GetPlayerPed(-1), rCoordx, rCoordy, rCoordz, 7.001, 7.001, 80.001, 0, 1, 0) then
            vRPserver.raceComplete({raceID})
            inRace = false
          end
          if not IsWaypointActive() and inRace then
            SetNewWaypoint(rCoordx,rCoordy)
          end
          tvRP.drawText3Ds("Race Finish", rCoordx, rCoordy, rCoordz)
        end
      end)
    else
      tvRP.notify("Disqualified. Early start.")
    end
  end
end

function getRandomCoord()
  local x = math.random(-3512, 4150)+0.0001
  local y = math.random(-3480, 7284)+0.0001
  local z = 40.00001
  return x, y, z
end
