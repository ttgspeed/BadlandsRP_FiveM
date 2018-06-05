-- Source https://github.com/nynjardin/outlawalert
-- Modified by serpico for vRP

--Config
local timer = 1 --in minutes - Set the time during the player is outlaw
local showOutlaw = true --Set if show outlaw act on map
local gunshotAlert = true --Set if show alert when player use gun
local carJackingAlert = false --Set if show when player do carjacking
local meleeAlert = true --Set if show when player fight in melee
local blipGunTime = 30 --in second
local blipMeleeTime = 30 --in second
local blipJackingTime = 10 -- in second
local wanted_time = 15 -- in seconds how long between any wanted alert
--End config

local timing = timer * 60000 --Don't touche it
local wanted_time_left = 0

RegisterNetEvent('463aae12-c6d6-46ec-8a40-3874ba702fd2')
AddEventHandler('463aae12-c6d6-46ec-8a40-3874ba702fd2', function(alert)
    tvRP.notify(alert)
end)

RegisterNetEvent('cf5403c9-0b68-4fcc-9b31-f84d994d94ca')
AddEventHandler('cf5403c9-0b68-4fcc-9b31-f84d994d94ca', function(tx, ty, tz)
    if carJackingAlert then
        local transT = 250
        local thiefBlip = AddBlipForCoord(tx, ty, tz)
        SetBlipSprite(thiefBlip,  304)
        SetBlipColour(thiefBlip,  38)
        SetBlipAlpha(thiefBlip,  transT)
        SetBlipAsShortRange(thiefBlip,  1)
        while transT ~= 0 do
            Wait(blipJackingTime * 4)
            transT = transT - 1
            SetBlipAlpha(thiefBlip,  transT)
            if transT == 0 then
                SetBlipSprite(thiefBlip,  2)
                return end
        end
    end
end)

RegisterNetEvent('203e11f6-f7d5-4b35-80ef-750f21ab00a1')
AddEventHandler('203e11f6-f7d5-4b35-80ef-750f21ab00a1', function(gx, gy, gz)
    if gunshotAlert then
        local transG = 250
        local gunshotBlip = AddBlipForCoord(gx, gy, gz)
        SetBlipSprite(gunshotBlip,  304)
        SetBlipColour(gunshotBlip,  38)
        SetBlipAlpha(gunshotBlip,  transG)
        SetBlipAsShortRange(gunshotBlip,  1)
        while transG ~= 0 do
            Wait(blipGunTime * 4)
            transG = transG - 1
            SetBlipAlpha(gunshotBlip,  transG)
            if transG == 0 then
                SetBlipSprite(gunshotBlip,  2)
                return end
        end
    end
end)

RegisterNetEvent('fdfb1ea7-c5fa-40a8-abc5-bf74330db559')
AddEventHandler('fdfb1ea7-c5fa-40a8-abc5-bf74330db559', function(mx, my, mz)
    if meleeAlert then
        local transM = 250
        local meleeBlip = AddBlipForCoord(mx, my, mz)
        SetBlipSprite(meleeBlip,  304)
        SetBlipColour(meleeBlip,  38)
        SetBlipAlpha(meleeBlip,  transG)
        SetBlipAsShortRange(meleeBlip,  1)
        while transM ~= 0 do
            Wait(blipMeleeTime * 4)
            transM = transM - 1
            SetBlipAlpha(meleeBlip,  transM)
            if transM == 0 then
                SetBlipSprite(meleeBlip,  2)
                return end
        end
    end
end)

--Star color
--[[1- White
2- Black
3- Grey
4- Clear grey
5-
6-
7- Clear orange
8-
9-
10-
11-
12- Clear blue]]

Citizen.CreateThread(function() -- coma decrease thread
  while true do
    Citizen.Wait(1000)
    if wanted_time_left > 0 then
      wanted_time_left = wanted_time_left-1
    end
  end
end)

-- Car Jacking Detection
Citizen.CreateThread( function()
    while true  and carJackingAlert do
        Wait(0)
        if not tvRP.isCop() and not tvRP.isMedic() and prison == nil and jail == nil and wanted_time_left < 1 then
            local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
            local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
            local street1 = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)
            if IsPedTryingToEnterALockedVehicle(GetPlayerPed(-1)) or IsPedJacking(GetPlayerPed(-1)) then
                local male = IsPedMale(GetPlayerPed(-1))
                if male then
                    sex = "man"
                elseif not male then
                    sex = "woman"
                end
                TriggerServerEvent('30519e85-698f-485b-a5a7-f9d6b32261a3', plyPos.x, plyPos.y, plyPos.z)
                local veh = GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))
                local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                local vehName2 = GetLabelText(vehName)
                if s2 == 0 then
                    TriggerServerEvent('3e2bbe37-685c-427b-b73e-7013d6527002', street1, vehName2, sex)
                elseif s2 ~= 0 then
                    TriggerServerEvent('9e0e633a-e1c4-451a-9014-7b8cfcf43408', street1, street2, vehName2, sex)
                end
                wanted_time_left = wanted_time
            end
        end
    end
end)

-- Fight detection
Citizen.CreateThread( function()
    while true do
        Wait(0)
        if not tvRP.isCop() and not tvRP.isMedic() and prison == nil and jail == nil and wanted_time_left < 1 then
            local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
            local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
            local street1 = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)
            if IsPedInMeleeCombat(GetPlayerPed(-1)) then
                local male = IsPedMale(GetPlayerPed(-1))
                if male then
                    sex = "man"
                elseif not male then
                    sex = "woman"
                end
                TriggerServerEvent('c7798036-420e-447c-b709-0d7a8abfa4ba', plyPos.x, plyPos.y, plyPos.z)
                if s2 == 0 then
                    TriggerServerEvent('881136c1-bb7b-4f9d-b15b-15df907e5121', street1, sex)
                elseif s2 ~= 0 then
                    TriggerServerEvent('1a35c113-4c55-4e48-8b03-e39e01d61817', street1, street2, sex)
                end
                wanted_time_left = wanted_time
            end
        end
    end
end)

-- Gunshot detection
Citizen.CreateThread( function()
    while true do
        Wait(0)
        if not tvRP.isCop() and not tvRP.isMedic() and prison == nil and jail == nil and wanted_time_left < 1 then
            local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
            local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
            local street1 = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)
            local currentWeapon = GetSelectedPedWeapon(PlayerPedId())
            if IsPedShooting(GetPlayerPed(-1)) and currentWeapon ~= GetHashKey('WEAPON_SNIPERRIFLE') then
                local male = IsPedMale(GetPlayerPed(-1))
                if male then
                    sex = "man"
                elseif not male then
                    sex = "woman"
                end
                tvRP.setGunFired()
                TriggerServerEvent('54a935cc-33d2-4dfd-9809-df47127c67f9', plyPos.x, plyPos.y, plyPos.z)
                if s2 == 0 then
                    TriggerServerEvent('48b9cf90-f67e-4fb8-92be-438c76105519', street1, sex)
                elseif s2 ~= 0 then
                    TriggerServerEvent('f32d543d-5285-4b51-ad88-cb943d7b1710', street1, street2, sex)
                end
                wanted_time_left = wanted_time
            end
        end
    end
end)
