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
            if menuConfig:enableMenu() and (not vRP.isInComa({})) then
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

-- TODO function to force close the menu
RegisterNetEvent("menu:forceCloseMenu")
AddEventHandler("menu:forceCloseMenu", function()
	showMenu = false
	SetNuiFocus(false, false)
	SendNUIMessage({
			type = 'destroy'
	})
end)

-- Callback function for closing menu
RegisterNUICallback('closemenu', function(data)
    -- Clear focus and destroy UI
    showMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'destroy'
    })

    -- Play sound
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
end)

-- Callback function for when a slice is clicked, execute command
RegisterNUICallback('sliceclicked', function(data)
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
	local closePed = GetClosestPlayer(4)
	vRPserver.giveId({closePed})
end)

RegisterNetEvent("menu:giveMoney")
AddEventHandler("menu:giveMoney", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.ch_give_money({closePed})
end)

RegisterNetEvent("menu:viewOwnID")
AddEventHandler("menu:viewOwnID", function()
	vRPserver.ch_viewOwnID({})
end)

RegisterNetEvent("menu:giveVehicleKeys")
AddEventHandler("menu:giveVehicleKeys", function()
	local closePed = GetClosestPlayer(4)
	local closeVeh = GetClosestVehicle(5)
	if closePed ~= nil and closeVeh ~= nil then
		local carName, plate = getVehicleData(closeVeh)
		local args = vRP.stringsplit({plate})
		if args ~= nil then
      plate = args[1]
      registration = vRP.getRegistrationNumber({})
      if registration == plate then
				vRPserver.ch_giveVehKeys({closePed, closeVeh, string.lower(carName), plate})
      end
    end
	end
end)

RegisterNetEvent("menu:togglelock")
AddEventHandler("menu:togglelock", function()
	vRP.newLockToggle({})
end)

RegisterNetEvent("menu:accessTrunk")
AddEventHandler("menu:accessTrunk", function()
	local closeVeh = GetClosestVehicle(5)
	if closeVeh ~= nil then
		local carName, plate = getVehicleData(closeVeh)
		local args = vRP.stringsplit({plate})
		if args ~= nil then
      plate = args[1]
      registration = vRP.getRegistrationNumber({})
      if registration == plate then
				vRPserver.accessTrunk({carName})
        vRP.recoverVehicleOwnership({"default",string.lower(carName),closeVeh})
      end
    end
	end
end)

RegisterNetEvent("menu:repairVehicle")
AddEventHandler("menu:repairVehicle", function()
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		local isNearMechanicOrRepairTruck = vRPcustom.IsNearMechanicOrRepairTruck({})
		local isNearMechanic = vRPcustom.IsNearMechanic({})
		if not vRP.getActionLock({}) then
			if vRPcustom.canRepairVehicle({}) then
				vRPserver.ch_repair({isNearMechanicOrRepairTruck, isNearMechanic})
			else
				vRP.notify({"Repair attempt failed. Make sure you are looking at the engine."})
			end
		end
	end
end)

RegisterNetEvent("menu:toggleRestraints")
AddEventHandler("menu:toggleRestraints", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.restrainPlayer({closePed})
end)

RegisterNetEvent("menu:escortTarget")
AddEventHandler("menu:escortTarget", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.escortPlayer({closePed})
end)

RegisterNetEvent("menu:copPutInCar")
AddEventHandler("menu:copPutInCar", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_putinveh({closePed})
end)

RegisterNetEvent("menu:pullOutVeh")
AddEventHandler("menu:pullOutVeh", function()
	vRPserver.choice_getoutveh({})
end)

RegisterNetEvent("menu:spikeStrip")
AddEventHandler("menu:spikeStrip", function()
	vRP.setSpikesOnGround({})
end)

RegisterNetEvent("menu:storeGetShotgun")
AddEventHandler("menu:storeGetShotgun", function()
	local closeVeh = GetClosestVehicle(5)
	if closeVeh ~= nil then
		local class = GetVehicleClass(closeVeh)
	  if class ~= nil and class == 18 then
	    vRP.storeCopWeapon({"WEAPON_PUMPSHOTGUN"})
	  end
	end
end)

RegisterNetEvent("menu:storeGetSmg")
AddEventHandler("menu:storeGetSmg", function()
	local closeVeh = GetClosestVehicle(5)
	if closeVeh ~= nil then
		local class = GetVehicleClass(closeVeh)
	  if class ~= nil and class == 18 then
	    vRP.storeCopWeapon({"WEAPON_SMG"})
	  end
	end
end)

RegisterNetEvent("menu:policeDispatch")
AddEventHandler("menu:policeDispatch", function()
	TriggerEvent('LoadCalls', false, "Police", "dispatch")
end)

RegisterNetEvent("menu:policeWanted")
AddEventHandler("menu:policeWanted", function()
	if vRP.isInProtectedVeh() then
    TriggerEvent('LoadCalls', false, "Police", "mdt")
  end
end)

RegisterNetEvent("menu:checkId")
AddEventHandler("menu:checkId", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_checkidPd({closePed})
end)

RegisterNetEvent("menu:searchTargetPlayer")
AddEventHandler("menu:searchTargetPlayer", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_checkPd({closePed})
end)

RegisterNetEvent("menu:doGsrTest")
AddEventHandler("menu:doGsrTest", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_gsr_test({closePed})
end)

RegisterNetEvent("menu:seizeWeapons")
AddEventHandler("menu:seizeWeapons", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_seize_weapons({closePed})
end)

RegisterNetEvent("menu:seizeItems")
AddEventHandler("menu:seizeItems", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_seize_items({closePed})
end)

RegisterNetEvent("menu:fineTarget")
AddEventHandler("menu:fineTarget", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_fine({closePed})
end)

RegisterNetEvent("menu:jailTarget")
AddEventHandler("menu:jailTarget", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_jail({closePed})
end)

RegisterNetEvent("menu:prisonTarget")
AddEventHandler("menu:prisonTarget", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_prison({closePed})
end)

RegisterNetEvent("menu:toggleShackles")
AddEventHandler("menu:toggleShackles", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_handcuff_movement({closePed})
end)

RegisterNetEvent("menu:revokeDriversLicense")
AddEventHandler("menu:revokeDriversLicense", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_seize_driverlicense({closePed})
end)

RegisterNetEvent("menu:revokeFirearmLicense")
AddEventHandler("menu:revokeFirearmLicense", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_seize_firearmlicense({closePed})
end)

RegisterNetEvent("menu:revokeKeys")
AddEventHandler("menu:revokeKeys", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_revoke_keys({closePed})
end)

RegisterNetEvent("menu:searchTargetVehicle")
AddEventHandler("menu:searchTargetVehicle", function()
	local closeVeh = GetClosestVehicle(5)
	if closeVeh ~= nil then
		local carName, plate = getVehicleData(closeVeh)
	  if carName ~= nil and plate ~= nil then
	    vRPserver.choice_check_vehicle({carName,plate})
	  end
	end
end)

RegisterNetEvent("menu:searchTargetVin")
AddEventHandler("menu:searchTargetVin", function()
	local closeVeh = GetClosestVehicle(5)
	if closeVeh ~= nil then
		local carName, plate = getVehicleData(closeVeh)
	  if carName ~= nil and plate ~= nil then
	    vRPserver.searchVehicleVin({carName,plate})
	  end
	end
end)

RegisterNetEvent("menu:seizeVehicleItems")
AddEventHandler("menu:seizeVehicleItems", function()
	local closeVeh = GetClosestVehicle(5)
	if closeVeh ~= nil then
		local carName, plate = getVehicleData(closeVeh)
	  if carName ~= nil and plate ~= nil then
	    vRPserver.choice_seize_veh_items({closeVeh,carName,plate})
	  end
	end
end)

RegisterNetEvent("menu:impoundVehicle")
AddEventHandler("menu:impoundVehicle", function()
	vRPserver.choice_impoundveh({})
end)

RegisterNetEvent("menu:seizeVehicle")
AddEventHandler("menu:seizeVehicle", function()
	local closeVeh = GetClosestVehicle(5)
	if closeVeh ~= nil then
		local carName, plate = getVehicleData(closeVeh)
	  if carName ~= nil and plate ~= nil then
	    vRPserver.choice_seize_vehicle({closeVeh,carName,plate})
	  end
	end
end)

RegisterNetEvent("menu:seizeVehicle")
AddEventHandler("menu:seizeVehicle", function()
	local closeVeh = GetClosestVehicle(5)
	if closeVeh ~= nil then
		local class = GetVehicleClass(closeVeh)
	  if class ~= nil and class == 18 then
	    vRP.setFiringPinState({true})
	  end
	end
end)

RegisterNetEvent("menu:reviveTarget")
AddEventHandler("menu:reviveTarget", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_revive({closePed})
end)

RegisterNetEvent("menu:emsEscort")
AddEventHandler("menu:emsEscort", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.escortPlayer({closePed})
end)

RegisterNetEvent("menu:performCpr")
AddEventHandler("menu:performCpr", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_cpr({closePed})
end)

RegisterNetEvent("menu:emsPutInVehicle")
AddEventHandler("menu:emsPutInVehicle", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_putinvehMed({closePed})
end)

RegisterNetEvent("menu:emsMobileTerminal")
AddEventHandler("menu:emsMobileTerminal", function()
	TriggerEvent('LoadCalls', false, "EMS/Fire", "dispatch")
end)

RegisterNetEvent("menu:toggleEmsDispatch")
AddEventHandler("menu:toggleEmsDispatch", function()
	vRPserver.choice_ems_missions({})
end)

RegisterNetEvent("menu:fieldTreatment")
AddEventHandler("menu:fieldTreatment", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_field_treatment({closePed})
end)

RegisterNetEvent("menu:toggleBedState")
AddEventHandler("menu:toggleBedState", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_toggleBedState({closePed})
end)

RegisterNetEvent("menu:checkTargetPulse")
AddEventHandler("menu:checkTargetPulse", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_checkpulse({closePed})
end)

RegisterNetEvent("menu:checkTargetInjuries")
AddEventHandler("menu:checkTargetInjuries", function()
	local closePed = GetClosestPlayer(4)
	vRPserver.choice_checklastinjury({closePed})
end)

RegisterNetEvent("menu:toggleTow")
AddEventHandler("menu:toggleTow", function()
	TriggerEvent("tow")
end)

RegisterNetEvent("menu:toggleEngine")
AddEventHandler("menu:toggleEngine", function()
	vRPcustom.toggleEngine({})
end)

RegisterNetEvent("menu:toggleDomeLight")
AddEventHandler("menu:toggleDomeLight", function()
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    if IsVehicleInteriorLightOn(veh) then
      SetVehicleInteriorlight(veh, false)
    else
      SetVehicleInteriorlight(veh, true)
    end
  end
end)

RegisterNetEvent("menu:toggleWindows")
AddEventHandler("menu:toggleWindows", function()
	vRP.rollWindows({})
end)

RegisterNetEvent("menu:toggleSeatBelt")
AddEventHandler("menu:toggleSeatBelt", function()
	vRP.toggleSeatbelt({})
end)

RegisterNetEvent("menu:toggleDoorFL")
AddEventHandler("menu:toggleDoorFL", function()
	toggleDoorState(0)
end)

RegisterNetEvent("menu:toggleDoorFR")
AddEventHandler("menu:toggleDoorFR", function()
	toggleDoorState(1)
end)

RegisterNetEvent("menu:toggleDoorBL")
AddEventHandler("menu:toggleDoorBL", function()
	toggleDoorState(2)
end)

RegisterNetEvent("menu:toggleDoorBR")
AddEventHandler("menu:toggleDoorBR", function()
	toggleDoorState(3)
end)

RegisterNetEvent("menu:toggleDoorHood")
AddEventHandler("menu:toggleDoorHood", function()
	toggleDoorState(4)
end)

RegisterNetEvent("menu:toggleDoorTrunk")
AddEventHandler("menu:toggleDoorTrunk", function()
	toggleDoorState(5)
end)

RegisterNetEvent("menu:toggleDoorBack")
AddEventHandler("menu:toggleDoorBack", function()
	toggleDoorState(6)
end)

RegisterNetEvent("menu:toggleDoorBack2")
AddEventHandler("menu:toggleDoorBack2", function()
	toggleDoorState(7)
end)

function toggleDoorState(doorNum)
	local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	if veh ~= nil and doorNum ~= nil and GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
		if GetVehicleDoorAngleRatio(veh, doorNum) > 0  then
			SetVehicleDoorShut(veh,doorNum)
		else
			SetVehicleDoorOpen(veh,doorNum,0,false)
		end
	end
end
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

RegisterCommand("externalTowVehSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["externalTowVehSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand("vehDoorSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["vehDoorSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

RegisterCommand("vehMdtPoliceSubMenu", function(source, args, rawCommand)
    Citizen.Wait(0)
    showMenu = true
    SendNUIMessage({
        type = 'init',
        data = subMenuConfigs["vehMdtPoliceSubMenu"].data,
        resourceName = GetCurrentResourceName()
    })
    SetNuiFocus(true, true)
end, false)

------------------Helper Functions---------------------------
function GetClosestPed(radius)
    local closestPed = 0

    for ped in EnumeratePeds() do
        local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped), true)
        if distanceCheck <= radius+.000001 and ped ~= GetPlayerPed(-1) then
            closestPed = ped
            break
        end
    end

    return closestPed
end

function GetClosestPlayer(radius)
  local closestPed = 0

  for ped in EnumeratePeds() do
    local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped), true)
    if distanceCheck <= radius+.000001 and ped ~= GetPlayerPed(-1) then
      local closePedID = GetPlayerByEntityID(ped)
      if closePedID ~= nil and NetworkIsPlayerActive(closePedID) then
        closestPed = GetPlayerServerId(closePedID)
        break
      end
    end
  end
  return closestPed
end

function GetClosestPlayers(radius)
  local closestPeds = {}

  for ped in EnumeratePeds() do
    local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped), true)
    if distanceCheck <= radius+.000001 and ped ~= GetPlayerPed(-1) then
      local closePedID = GetPlayerByEntityID(ped)
      if closePedID ~= nil and NetworkIsPlayerActive(closePedID) then
        local closestPed = GetPlayerServerId(closePedID)
        table.insert(closestPeds, closestPed)
      end
    end
  end
  return closestPeds
end

function GetClosestVehicle(radius)
    local closestVeh = 0

    for veh in EnumerateVehicles() do
        local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(veh), true)
        if distanceCheck <= radius+.000001 then
            closestVeh = veh
            break
        end
    end

    return closestVeh
end

function TargetVehicleInProximity(radius,vplate,vname)
  local closestVeh = 0

  for veh in EnumerateVehicles() do
    local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(veh), true)
    if distanceCheck <= radius+.000001 then
      local carModel = GetEntityModel(veh)
      local carName = GetDisplayNameFromVehicleModel(carModel)
      local plate = GetVehicleNumberPlateText(veh)
      local args = vRP.stringsplit({plate})
      closestVeh = veh
      if args ~= nil then
        plate = args[1]
        if vplate == plate and string.lower(vname) == string.lower(carName) then
          return true
        end
      end
    end
    end
  return false
end

function GetClosestParkedVehicles(radius, maxQty)
	local closestVehicles = {}
	local count = 0
	for veh in EnumerateVehicles() do
		local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(veh), true)
		local popType = GetEntityPopulationType(veh)
		if distanceCheck <= radius+.000001 and popType == 2 then
			count = count + 1
			table.insert(closestVehicles, veh)
		end
		if count == maxQty then
			break
		end
	end
	return closestVehicles
end

local entityEnumerator = {
  __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
      disposeFunc(iter)
      return
    end

    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)

    local next = true
    repeat
      coroutine.yield(id)
      next, id = moveFunc(iter)
    until not next

    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

function EnumerateObjects()
  return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
  return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
  return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function GetPlayerByEntityID(id)
  for _, i in ipairs(GetActivePlayers()) do
    if(GetPlayerPed(i) == id) then return i end
  end
	return nil
end

function getVehicleData(vehicle)
  local carModel = GetEntityModel(vehicle)
  local carName = GetDisplayNameFromVehicleModel(carModel)
  local plate = GetVehicleNumberPlateText(vehicle)
  local args = vRP.stringsplit({plate})
  if args ~= nil then
    plate = args[1]
    return carName, plate
  end
  return nil, nil
end
