function tvRP.startRobbery(time, location, cb, cbargs)
    local robbery_time_remaining = time
    local robbery_done = false
    Citizen.CreateThread(function()
        while robbery_done == false do
            Citizen.Wait(1000)
            local ped = GetPlayerPed(-1)
            local x,y,z = table.unpack(GetEntityCoords(ped,true))
            local tx,ty,tz = table.unpack(location)

            local distance = 10.0
            if cb == "tent" then
                distance = 3.0
            end

            if GetDistanceBetweenCoords(x,y,z,tx,ty,tz,true) > distance or tvRP.isHandcuffed() or tvRP.isInComa() or IsPedInAnyVehicle(ped) then
                --fail
                vRPserver.resolveRobbery({false,cb,cbargs})
                robbery_done = true
            end

            if cb ~= "store_raid" then
                vRPserver.getInventoryItemAmount({"safe_kit"}, function(count)
                    if count < 1 then
                        vRPserver.resolveRobbery({false,cb,cbargs})
                        robbery_done = true
                    end
                end)
            end

            if robbery_time_remaining == 0 then
                --success
                vRPserver.resolveRobbery({true,cb,cbargs})
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
