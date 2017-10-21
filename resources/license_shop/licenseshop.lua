-- build the client-side interface
clientdef = {}
Tunnel.bindInterface("playerLicenses",clientdef)

-- get the server-side access
serveraccess = Tunnel.getInterface("playerLicenses","playerLicenses")

local guiEnabled = false
local inCustomization = false
local isOwnedVehicleSpawned = false

local vehicles = {}
local vehicleList = json.encode(cfg.garage_types)
local boatList = json.encode(cfg.boat_types)

RegisterNUICallback('escape', function(data, cb)
    EnableGui(false)
    cb('ok')
end)

RegisterNUICallback('testmessage', function(data, cb)
    print(data.text)
    TriggerEvent('chatMessage', 'DEV', {255, 0, 0}, data.text)
    cb('ok')
end)

RegisterNUICallback('buy_license', function(lic, cb)
    TriggerServerEvent('vrp:purchaseLicense', lic.license)
    EnableGui(false)
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

-- Util function stuff
function stringsplit(self, delimiter)
  local a = self:Split(delimiter)
  local t = {}

  for i = 0, #a - 1 do
     table.insert(t, a[i])
  end

  return t
end

RegisterNetEvent('license_shop:closeWindow')
AddEventHandler('license_shop:closeWindow', function()
	EnableGui(false)
end)

function EnableGui(enable, shopType)
    shopType = shopType or "car"
    vehicles = nil
    if shopType == "car" then
      vehicles = vehicleList
    elseif shopType == "boat" then
      vehicles = boatList
    else
      vehicles = vehicleList
    end

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

-- RegisterNetEvent('license_shop:recievePlayerVehicles')
-- AddEventHandler('license_shop:recievePlayerVehicles', function(r)
--   for k,v in pairs(r) do
--     serveraccess.getPlayerLicense({v.vehicle}, function(x)
--       SendNUIMessage({
--           type = "vehicle",
--           vehicle = v.vehicle,
--           garage = x
--       })
--     end)
--   end
-- end)

local carshops = {
	--{['x'] = 1696.66, ['y'] = 3607.99, ['z'] = 35.36, blip=true},
	{['x'] = -1154.2521972656, ['y'] = -2715.6701660156, ['z'] = 19.887300491334, blip=true}
}

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
	for k,v in ipairs(carshops) do
		if v.blip then
			TriggerEvent('license_shop:createBlip', 77, v.x, v.y, v.z)
		end
	end
end)

RegisterNetEvent("license_shop:createBlip")
AddEventHandler("license_shop:createBlip", function(type, x, y, z)
	local blip = AddBlipForCoord(x, y, z)
	SetBlipSprite(blip, type)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	if(type == 50)then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Department of Licensing")
		EndTextCommandSetBlipName(blip)
	end
end)

local menu = {
	["Primary Colour"] = function(e)
		print(e)
	end,
	["Secondary Colour"] = function(e)
		print(e)
	end
}

RegisterNetEvent('license_shop:setColour')
AddEventHandler('license_shop:setColour', function(r, g, b)
	SetVehicleCustomPrimaryColour(NetworkGetEntityFromNetworkId(spawnedVehicle),  r,  g,  b)
end)

RegisterNetEvent('license_shop:setColourSecondary')
AddEventHandler('license_shop:setColourSecondary', function(r, g, b)
	SetVehicleCustomSecondaryColour(NetworkGetEntityFromNetworkId(spawnedVehicle),  r,  g,  b)
end)

local function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline, center)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
	if(center)then
		Citizen.Trace("CENTER\n")
		SetTextCentre(false)
	end
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

local selected = 1
local keyboard = false
local tkeyboard = nil
local vehicleLocked = false

local selected = 1
local keyboard = false
local tkeyboard = nil

local showFixMessage = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if(showFixMessage)then
			Citizen.Wait(3000)
			showFixMessage = false
		end
	end
end)

local freeBikeOnCooldown = false
local freeBikeTimeCooldown = 5 -- in minutes

Citizen.CreateThread(function()
    while true do
			Citizen.Wait(1)

			for k,v in ipairs(vehicles) do
				SetVehicleTyresCanBurst(v, true)
			end

			local pos = GetEntityCoords(GetPlayerPed(-1), true)

				for k,v in ipairs(carshops) do
					if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 100.0)then
						DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)

						if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 2.0 and showFixMessage == false)then
							if(not IsPedInAnyVehicle(GetPlayerPed(-1), false))then
								DisplayHelpText("Press ~INPUT_CONTEXT~ to access the ~b~Department of Licensing~w~")

								if(IsControlJustReleased(1, 51))then
									EnableGui(true)
								end
							else
									DisplayHelpText("You cannot be in a vehicle while accessing the department")
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
