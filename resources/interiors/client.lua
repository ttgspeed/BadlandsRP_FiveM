POS_actual = 1
PED_hasBeenTeleported = false

function teleport(pos)
    TriggerEvent('vrp:setCheckDelayed',30)
    Citizen.Wait(50)
    local ped = GetPlayerPed(-1)
    Citizen.CreateThread(function()
        PED_hasBeenTeleported = true

        DoScreenFadeOut(1000)
        while IsScreenFadingOut() do Citizen.Wait(0) end
        RequestCollisionAtCoord(pos.x, pos.y, pos.z)
        SetEntityCoords(ped, pos.x, pos.y, pos.z+0.5, 1, 0, 0, 1)
        SetEntityHeading(ped, pos.h)
        DoScreenFadeIn(1000)
        while IsScreenFadingIn() do Citizen.Wait(0)	end

        Citizen.Wait(500)
        PED_hasBeenTeleported = false
    end)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local ped = GetPlayerPed(-1)
        local playerPos = GetEntityCoords(ped, true)

        for i,pos in pairs(INTERIORS) do
            DrawMarker(23, pos.x, pos.y, pos.z-1, 0, 0, 0, 0, 0, 0, 0.7,0.7,0.5, 255,255,255, 200, 0, 0, 2, 0, 0, 0, 0)
            if (Vdist(playerPos.x, playerPos.y, playerPos.z, pos.x, pos.y, pos.z) < 0.5) and (not PED_hasBeenTeleported) then
                POS_actual = pos.id
                if not gui_interiors.opened then
                    gui_interiors_OpenMenu()
                end
            end
        end
    end
end)
