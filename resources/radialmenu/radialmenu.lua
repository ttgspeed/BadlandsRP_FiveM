vRPserver = Tunnel.getInterface("vRP","vRP")
vRP = Proxy.getInterface("vRP")
vRPcustom = Proxy.getInterface("CustomScripts")

-- Menu state
local showMenu = false

-- Keybind Lookup table
local keybindControls = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

-- Main thread
Citizen.CreateThread(function()
    -- Update every frame
    while true do
        Citizen.Wait(0)

        -- Loop through all menus in config
        for _, menuConfig in pairs(menuConfigs) do
            -- Check if menu should be enabled
            if menuConfig:enableMenu() then
                -- When keybind is pressed toggle UI
                local keybindControl = keybindControls[menuConfig.data.keybind]
                if IsControlPressed(0, keybindControl) then
                    -- Init UI
                    showMenu = true
                    SendNUIMessage({
                        type = 'init',
                        data = menuConfig.data,
                        resourceName = GetCurrentResourceName()
                    })

                    -- Set cursor position and set focus
                    SetCursorLocation(0.5, 0.5)
                    SetNuiFocus(true, true)

                    -- Play sound
                    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)

                    -- Prevent menu from showing again until key is released
                    while showMenu == true do Citizen.Wait(100) end
                    Citizen.Wait(100)
                    while IsControlPressed(0, keybindControl) do Citizen.Wait(100) end
                end
            end
        end
    end
end)

--------------------------------------------------------------------
function GetEntInFrontOfPlayer(Distance, Ped)
  local Ent = nil
  local CoA = GetEntityCoords(Ped, 1)
  local CoB = GetOffsetFromEntityInWorldCoords(Ped, 0.0, Distance, 0.0)
  local RayHandle = StartShapeTestRay(CoA.x, CoA.y, CoA.z, CoB.x, CoB.y, CoB.z, -1, Ped, 0)
  local A,B,C,D,Ent = GetRaycastResult(RayHandle)
  return Ent
end

function Target()
  local Entity = nil
	local player = GetPlayerPed(-1)
  local camCoords = GetGameplayCamCoord()
	local entityWorld = GetOffsetFromEntityInWorldCoords(player, 0.0, 4+0.00001, 0.0)
  local RayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, entityWorld.x, entityWorld.y, entityWorld.z, -1, player, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(RayHandle)
  return entityHit, hit, endCoords.x, endCoords.y, endCoords.z
end

function GetPlayerByEntityID(id)
  for _, i in ipairs(GetActivePlayers()) do
    if(GetPlayerPed(i) == id) then return i end
  end
	return nil
end

function GetTargetEntity()
	local Ped = GetPlayerPed(-1)
	local Entity, farCoordsX, farCoordsY, farCoordsZ = Target(6.0, Ped)
	local EntityType = GetEntityType(Entity)

	-- Entity type is an object
	if (EntityType == 3) then
		return EntityType, Entity
	-- If EntityType is Vehicle
	elseif(EntityType == 2) then

	-- If EntityType = User
	elseif(EntityType == 1) then

	else

	end
end
--------------------------------------------------------------------

-- Callback function for closing menu
RegisterNUICallback('closemenu', function(data, cb)
    -- Clear focus and destroy UI
    showMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'destroy'
    })

    -- Play sound
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)

    -- Send ACK to callback function
    cb('ok')
end)

-- Callback function for when a slice is clicked, execute command
RegisterNUICallback('sliceclicked', function(data, cb)
    -- Clear focus and destroy UI
    showMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'destroy'
    })

    -- Play sound
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)

    -- Run command
		if data.command ~= "none" then
    	ExecuteCommand(data.command)
		elseif data.trigger ~= "none" then
			TriggerEvent("menu:"..data.trigger)
		end

    -- Send ACK to callback function
    cb('ok')
end)

RegisterNetEvent("menu:openInventory")
AddEventHandler("menu:openInventory", function()
	vRPserver.openInventory({})
end)

RegisterNetEvent("menu:viewAptitudes")
AddEventHandler("menu:viewAptitudes", function()
	vRPserver.ch_aptitude({})
end)

RegisterNetEvent("menu:giveId")
AddEventHandler("menu:giveId", function()
	--TODO
	vRPserver.giveId({data.id})
end)

RegisterNetEvent("menu:giveMoney")
AddEventHandler("menu:giveMoney", function()
	--TODO
	vRPserver.ch_give_money({data.id})
end)

RegisterNetEvent("menu:viewOwnID")
AddEventHandler("menu:viewOwnID", function()
	vRPserver.ch_viewOwnID({})
end)

RegisterNetEvent("menu:giveVehicleKeys")
AddEventHandler("menu:giveVehicleKeys", function()
	vRPserver.ch_giveVehKeys({})
end)

RegisterNetEvent("menu:togglelock")
AddEventHandler("menu:togglelock", function()
	vRP.newLockToggle({})
end)

RegisterNetEvent("menu:accessTrunk")
AddEventHandler("menu:accessTrunk", function()
	--TODO
	carModel = GetEntityModel(data.id)
  carName = GetDisplayNameFromVehicleModel(carModel)
  vRPserver.accessTrunk({carName})
end)

RegisterNetEvent("menu:toggleRestraints")
AddEventHandler("menu:toggleRestraints", function()
	--TODO
	vRPserver.restrainPlayer({data.id})
end)
RegisterNetEvent("menu:escortTarget")
AddEventHandler("menu:escortTarget", function()
	--TODO
	vRPserver.escortPlayer({data.id})
end)
RegisterNetEvent("menu:copPutInCar")
AddEventHandler("menu:copPutInCar", function()
	--TODO
	vRPserver.choice_putinveh({data.id})
end)
RegisterNetEvent("menu:pullOutVeh")
AddEventHandler("menu:pullOutVeh", function()
	vRPserver.choice_getoutveh({})
end)
RegisterNetEvent("menu:spikeStrip")
AddEventHandler("menu:spikeStrip", function()
	vRP.setSpikesOnGround({})
end)

-------- COMMANDS ---------
RegisterCommand("walletSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["walletSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand("emoteSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["emoteSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand("externalVehSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["externalVehSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand("policeSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["policeSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand("externalCopVehSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["externalCopVehSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand("weaponStoreSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["weaponStoreSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand("mdtSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["mdtSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand("playerActionSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["playerActionSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand("vehicleActionSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["vehicleActionSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand("policeLicenseSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["policeLicenseSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand("medSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["medSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand("medTreatmentSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["medTreatmentSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand("walletPoliceSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["walletPoliceSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand("walletMedSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["walletMedSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand("externalMedVehSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["externalMedVehSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)
