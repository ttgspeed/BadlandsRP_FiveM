local function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local active_tents = {}

function tvRP.addTent(id,pos)
    active_tents[id] = {
        ['pos'] = pos,
        ['active'] = true
    }
end

function tvRP.removeTent(id)
    local tent = active_tents[id]
    if tent ~= nil then
        local x,y,z = table.unpack(tent.pos)
        active_tents[id] = nil
        --delete the tent object if it exists
        local tent_obj = GetClosestObjectOfType(x,y,z,3.0,GetHashKey("prop_skid_tent_cloth"),false,false,false)
        SetEntityAsMissionEntity(tent_obj, true, true)
        DeleteObject(tent_obj)
    end
end

function tvRP.getForwardPosition()
    local ped = GetPlayerPed(-1)
    local pedCoord = GetEntityCoords(ped)
    local rot = GetEntityHeading(ped)
    local x, y, z = table.unpack(GetEntityCoords(ped, true))
    local fx,fy,fz = table.unpack(GetEntityForwardVector(ped))
    x = x+(fx*2.0)
    y = y+(fy*2.0)
    _,z = GetGroundZFor_3dCoord(x,y,z)

    return x,y,z
end

function tvRP.startTentRobbery(owner, location)
    local robbery_time_remaining = 600
    local robbery_done = false
    Citizen.CreateThread(function()
        while robbery_done == false do
            Citizen.Wait(1000)
            local ped = GetPlayerPed(-1)
            local x,y,z = table.unpack(GetEntityCoords(ped,true))
            local tx,ty,tz = table.unpack(location)

            if GetDistanceBetweenCoords(x,y,z,tx,ty,tz,true) > 3.0 or tvRP.isHandcuffed() or tvRP.isInComa() or IsPedInAnyVehicle(ped) then
                --fail
                vRPserver.resolveTentRobbery({owner,false})
                robbery_done = true
            end

            if robbery_time_remaining == 0 then
                --success
                vRPserver.resolveTentRobbery({owner,true})
                robbery_done = true
            else
                robbery_time_remaining = robbery_time_remaining - 1
            end
        end
    end)
    Citizen.CreateThread(function()
        while robbery_done == false do
            Citizen.Wait(0)
            tvRP.missionText("Breaking lock: ~r~" .. robbery_time_remaining .. "~w~ seconds remaining")
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local ped = GetPlayerPed(-1)
        local x,y,z = table.unpack(GetEntityCoords(ped,true))
        for k,v in pairs(active_tents) do
            if v ~= nil then
                local tx,ty,tz = table.unpack(v.pos)
                if GetDistanceBetweenCoords(x,y,z,tx,ty,tz,true) < 25.0 then
                    if DoesObjectOfTypeExistAtCoords(tx,ty,tz, 2.0, GetHashKey("prop_skid_tent_cloth"), true) then
                        if not v.active then
                            --delete
                        end
                    else
                        if v.active then
                            tent_model = GetHashKey("prop_skid_tent_cloth")

                            RequestModel(tent_model)
                            while not HasModelLoaded(tent_model) do
                                Citizen.Wait(1)
                            end

                            local object = CreateObject(tent_model, tx, ty, tz, false, true, false)
                            PlaceObjectOnGroundProperly(object)
                        end
                    end
                end
            end
        end
    end
end)
