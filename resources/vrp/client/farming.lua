--[[
  -- Filename: farming.lua
  -- Author: Serpico
  -- Description: Serves as a method to allow planting/growing of a weed plant.
  --              Random conditions and actions must be performed. 100% yeilds best
  --              weed. 1 error, lesser weed. 2 errors, you get your seed back. 3+
  --              lose your plant.
]]--

local growing = false
local startGrowPos = nil
local plantPos = nil
local growTimeout = 0
local action_performed = 0
local successfulSteps = 0
local started = false

function tvRP.isFarming()
  return started
end

function tvRP.startWeedGrowth()
  if not started then
    started = true
    successfulSteps = 0
    local ped = GetPlayerPed(-1)
    local pedCoord = GetEntityCoords(ped)
    local rot = GetEntityHeading(ped)
    startGrowPos = GetEntityCoords(ped, true)
    local x, y, z = table.unpack(startGrowPos)
    local fx,fy,fz = table.unpack(GetEntityForwardVector(ped))
    x = x+(fx*2.0)
    y = y+(fy*2.0)
    plantPos = {plantX = x, plantY = y, plantZ = z}

    plantHash = GetHashKey("prop_weed_01")

    RequestModel(plantHash)
    while not HasModelLoaded(plantHash) do
      Citizen.Wait(1)
    end
    reduction = 2.5
    failure = 0
    object = CreateObject(plantHash, x, y, z-reduction, true, true, false)
    while reduction > 1.1 and failure < 3 do
      if stepGrowth() then
        successfulSteps = successfulSteps + 1
        reduction = reduction - 0.2
        Citizen.Trace("Success "..reduction)
        DeleteObject(object)
        object = CreateObject(plantHash, x, y, z-reduction, true, true, false)
      else
        Citizen.Trace("Failure "..failure)
        failure = failure + 1
      end
    end
    DeleteObject(object)
    if successfulSteps > 6 then
      amount = math.random(10,12)
      vRPserver.giveFarmingReward({"marijuana2",amount})
    elseif successfulSteps > 5 then
      amount = math.random(9,11)
      vRPserver.giveFarmingReward({"marijuana",amount})
    elseif successfulSteps > 3 then
      amount = 1
      vRPserver.giveFarmingReward({"cannabis_seed",amount})
    else
      msg = "Stop smoking the product, how else could you fuck up this bad!"
      tvRP.notify(msg)
    end
    started = false
  end
end

function stepGrowth()
  growing = true
  growTimeout = 10
  action_performed = 0
  local random = math.random(1, 4)
  if random == 1 then
    condition = "The leaves are looking dry"
  elseif random == 2 then
    condition = "The soil is looking old"
  elseif random == 3 then
    condition = "Plant is looking overgrown"
  elseif random == 4 then
    condition = "Things are looking good"
  end

  while growing do
    Citizen.Wait(0)
    DisableControlAction(0, 157, true)
    DisableControlAction(0, 158, true)
    DisableControlAction(0, 160, true)

    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
    local distance = GetDistanceBetweenCoords(x,y,z,plantPos.plantX,plantPos.plantY,plantPos.plantZ,true)
    if distance <= 2 then
      tvRP.showHelpNotification(condition.."~n~"..growTimeout.."s to complete action")
      tvRP.missionText("Press ~r~1~w~ to water plant.~n~Press ~r~2~w~ to turn soil~n~Press ~r~3~w~ prune leaves~n~", 1)
      if IsDisabledControlJustPressed(0, 157) then
        RequestAnimDict("weapon@w_sp_jerrycan")
        while not HasAnimDictLoaded("weapon@w_sp_jerrycan") do
          Citizen.Wait(100)
        end
        TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire", 8.0, -8, -1, 49, 0, 0, 0, 0)
        Citizen.Wait(5000)
        ClearPedTasks(GetPlayerPed(-1))
        growing = false
        growTimeout = 0
        action_performed = 1
      end
      if IsDisabledControlJustPressed(0, 158) then
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_GARDENER_PLANT", 0, 1)
        Citizen.Wait(5000)
        ClearPedTasks(GetPlayerPed(-1))
        growing = false
        growTimeout = 0
        action_performed = 2
      end
      if IsDisabledControlJustPressed(0, 160) then
        TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_PARKING_METER", 0, 1)
        Citizen.Wait(5000)
        ClearPedTasks(GetPlayerPed(-1))
        growing = false
        growTimeout = 0
        action_performed = 3
      end
      if growTimeout < 1 then
        growing = false
        if action_performed == 0 then
          action_performed = 4
        end
      end
    else
      if growTimeout < 1 then
        growing = false
        if action_performed == 0 then
          action_performed = -1
        end
      end
      tvRP.showHelpNotification("Too far")
    end
  end
  if action_performed == random then
    tvRP.notify("Correct Action Performed")
    return true
  elseif action_performed == -1 then
    tvRP.notify("You were too far from the plant and missed a step")
    return false
  else
    tvRP.notify("Incorrect Action Performed")
    return false
  end
end

Citizen.CreateThread(function() -- coma decrease thread
  while true do
    Citizen.Wait(1000)
    if growTimeout > 0 then
      growTimeout = growTimeout-1
    end
  end
end)
