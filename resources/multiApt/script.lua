function CreateTier1House(spawn)
    print("I got here11")
    local objects = {}
    local shell = CreateObject(`playerhouse_tier1`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)
    table.insert(objects, shell)

    local dt = CreateObject(`V_16_DT`, spawn.x-1.21854400, spawn.y-1.04389600, spawn.z + 1.39068600, false, false, false)
    table.insert(objects, dt)

    local curts = CreateObject(`playerhouse_tier1_curts`, spawn.x - 1.96423300, spawn.y - 0.95958710, spawn.z + 1.28092700, false, false, false)
    table.insert(objects, curts)
    local hall = CreateObject(`V_16_mid_hall_mesh_delta`, spawn.x + 3.69693000, spawn.y - 5.80020100, spawn.z + 1.00374200, false, false, false)
    table.insert(objects, hall)
    local bedDelta = CreateObject(`playerhouse_tier1_bed_delta`, spawn.x + 7.951874, spawn.y + 1.042465, spawn.z + 1.28402300, false, false, false)
    table.insert(objects, bedDelta)

    SetEntityCoords(PlayerPedId(), spawn.x + 3.69693000, spawn.y - 15.080020100, spawn.z + 1.5, 0, 0, 0, false)

    return objects
end

RegisterNetEvent('MultiApt:CreateTier1House') --Just added the event to activate the binoculars
AddEventHandler('MultiApt:CreateTier1House', function()
  print("I got here1")

  CreateTier1House(GetEntityCoords(GetPlayerPed(-1)))
end)

function CreateTier3House(spawn)
    print("I got here33")
    local objects = {}
    local shell = CreateObject(`playerhouse_tier3`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(shell, true)

    table.insert(objects, shell)

    SetEntityCoords(PlayerPedId(), spawn.x + 3.69693000, spawn.y - 15.080020100, spawn.z + 1.5, 0, 0, 0, false)

    return objects
end

RegisterNetEvent('MultiApt:CreateTier3House') --Just added the event to activate the binoculars
AddEventHandler('MultiApt:CreateTier3House', function()
  print("I got here3")
  CreateTier3House(GetEntityCoords(GetPlayerPed(-1)))
end)
