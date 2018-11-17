local guiEnabled = false

local vehicles = {}
local current_station = nil

local clubs = {
	['RADIO_03_HIPHOP_NEW'] = {
		['pos'] = {-1387.4630126954,-617.9398803711,30.819576263428}
	}
}

local dj_booths = {
	{['x'] = -1381.9998779296, ['y'] = -614.708984375, ['z'] = 31.597900009156, station="RADIO_03_HIPHOP_NEW"},
	{['x'] = -245.63412475586, ['y'] = 6238.7451171875, ['z'] = 31.499290237427, station=""}
}

RegisterNUICallback('escape', function(data, cb)
    EnableGui(false)
    cb('ok')
end)

RegisterNUICallback('testmessage', function(data, cb)
    print(data.text)
    TriggerEvent('chatMessage', 'DEV', {255, 0, 0}, data.text)
    cb('ok')
end)

RegisterNUICallback('update_radio', function(data, cb)
    print(data.station)
    cb('ok')
end)

RegisterNetEvent("license_shop:sendOwnedVehicles")
AddEventHandler('license_shop:sendOwnedVehicles', function(v)
	SendNUIMessage({
        type = "vehicles",
        enable = v
    })
end)

RegisterNetEvent("license_shop:sendOwnedVehicle")
AddEventHandler('license_shop:sendOwnedVehicle', function(v)
	SendNUIMessage({
        type = "vehicle",
        enable = v
    })
end)

RegisterNetEvent('license_shop:closeWindow')
AddEventHandler('license_shop:closeWindow', function()
	EnableGui(false)
end)

function EnableGui(enable, shopType)
    shopType = shopType or "car"
    vehicles = {}

    SetNuiFocus(enable)
    guiEnabled = enable

    SendNUIMessage({
        type = "enableui",
        enable = enable
    })
    if(enable) then
      SendNUIMessage({
          type = "vehicleList",
          vehicles = vehicles
      })
    end
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local selected = 1
local keyboard = false
local tkeyboard = nil
local vehicleLocked = false

local selected = 1
local keyboard = false
local tkeyboard = nil

local showFixMessage = false

local function start_music()
	print("start "..current_station)
	StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE")
	SendNuiMessage({
		"type": "play",
		"radio": current_station
	})
end

local function stop_music()
	print("stop "..current_station)
	StopAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE")
	SendNuiMessage({
		"type": "stop"
	})
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if(showFixMessage)then
			Citizen.Wait(3000)
			showFixMessage = false
		end
	end
end)

Citizen.CreateThread(function()
    while true do
			Citizen.Wait(1)
			local pos = GetEntityCoords(GetPlayerPed(-1), true)

			if current_station ~= nil then
				local current_club = clubs[current_station]
				if(Vdist(pos.x, pos.y, pos.z, current_club.pos[1], current_club.pos[2], current_club.pos[3]) > 50.0) then
					stop_music()
					current_station = nil
				end
			else
				for station,club in pairs(clubs) do
					if(Vdist(pos.x, pos.y, pos.z, club.pos[1], club.pos[2], club.pos[3]) < 50.0) then
						current_station = station
						start_music()
					end
				end
			end

			for k,v in ipairs(dj_booths) do
				if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 10.0)then
					DrawMarker(23, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.5001, 255, 165, 0,165, 0, 0, 0,0)

					if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 1.0 and showFixMessage == false)then
						if(not IsPedInAnyVehicle(GetPlayerPed(-1), false))then
							DisplayHelpText("Press ~INPUT_CONTEXT~ to access the ~b~DJ booth~w~")

							if(IsControlJustReleased(1, 51))then
								EnableGui(true)
							end
						end
					end
				end
			end

      if guiEnabled then
				DisableControlAction(1, 18, true)
				DisableControlAction(1, 24, true)
				DisableControlAction(1, 69, true)
				DisableControlAction(1, 92, true)
				DisableControlAction(1, 106, true)
				DisableControlAction(1, 122, true)
				DisableControlAction(1, 135, true)
				DisableControlAction(1, 142, true)
				DisableControlAction(1, 144, true)
				DisableControlAction(1, 176, true)
				DisableControlAction(1, 223, true)
				DisableControlAction(1, 229, true)
				DisableControlAction(1, 237, true)
				DisableControlAction(1, 257, true)
				DisableControlAction(1, 329, true)

				DisableControlAction(1, 14, true)
				DisableControlAction(1, 16, true)
				DisableControlAction(1, 41, true)
				DisableControlAction(1, 43, true)
				DisableControlAction(1, 81, true)
				DisableControlAction(1, 97, true)
				DisableControlAction(1, 180, true)
				DisableControlAction(1, 198, true)
				DisableControlAction(1, 39, true)
				DisableControlAction(1, 50, true)

				DisableControlAction(1, 22, true)
				DisableControlAction(1, 55, true)
				DisableControlAction(1, 76, true)
				DisableControlAction(1, 102, true)
				DisableControlAction(1, 114, true)
				DisableControlAction(1, 143, true)
				DisableControlAction(1, 179, true)
				DisableControlAction(1, 193, true)
				DisableControlAction(1, 203, true)
				DisableControlAction(1, 216, true)
				DisableControlAction(1, 255, true)
				DisableControlAction(1, 298, true)
				DisableControlAction(1, 321, true)
				DisableControlAction(1, 328, true)
				DisableControlAction(1, 331, true)

        if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
            SendNUIMessage({
                type = "click"
            })
        end
      end
    end
end)

EnableGui(false)
