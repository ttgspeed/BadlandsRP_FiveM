Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            if (IsDisabledControlPressed(1, 32) and IsDisabledControlJustPressed(1, 38)) then
                --if IsControlPressed(1, 303) or IsControlPressed(1, 38) and GetLastInputMethod( 0 ) then
                if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                    local player = tvRP.getNearestPlayer(1.5)
                    if player ~= nil then
                        vRPserver.tackle({player})
                        --TriggerServerEvent("Tackle", GetPlayerServerId(player))
                    end
                    SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
                end
            end
        end
    end
)

function tvRP.tackleragdoll()
    SetPedToRagdoll(GetPlayerPed(-1), 5000, 5000, 0, 0, 0, 0)
end
