-- build the client-side interface
clientdef = {}
Tunnel.bindInterface("playerGarage",clientdef)

-- get the server-side access
serveraccess = Tunnel.getInterface("playerGarage","playerGarage")

local guiEnabled = false
local inCustomization = false
local isOwnedVehicleSpawned = false

local vehicles = {}
local vehicleList = json.encode(cfg.garage_types)

RegisterNUICallback('escape', function(data, cb)
    EnableGui(false)

    cb('ok')
end)

RegisterNUICallback('testmessage', function(data, cb)
    print(data.text)
    TriggerEvent('chatMessage', 'DEV', {255, 0, 0}, data.text)
    cb('ok')
end)

RegisterNUICallback('storeVehicle', function(data, cb)
    TriggerServerEvent('vrp:storeVehicle')
    EnableGui(false)
    cb('ok')
end)

RegisterNUICallback('buy_vehicle', function(veh, cb)
    TriggerServerEvent('vrp:purchaseVehicle', veh.garage, veh.vehicle)
    EnableGui(false)
    cb('ok')
end)

RegisterNetEvent("es_carshop:sendOwnedVehicles")
AddEventHandler('es_carshop:sendOwnedVehicles', function(v)
	SendNUIMessage({
        type = "vehicles",
        enable = v
    })
end)

RegisterNetEvent("es_carshop:sendOwnedVehicle")
AddEventHandler('es_carshop:sendOwnedVehicle', function(v)
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

RegisterNetEvent('es_carshop:closeWindow')
AddEventHandler('es_carshop:closeWindow', function()
	EnableGui(false)
end)

local spawnedVehicle = nil

DecorRegister("owner", 3)

RegisterNetEvent('es_carshop:createVehicle')
AddEventHandler('es_carshop:createVehicle', function(v, options)
	local carid = GetHashKey(v)
	local playerPed = GetPlayerPed(-1)
	if playerPed and playerPed ~= -1 and isOwnedVehicleSpawned == false then
		RequestModel(carid)
		while not HasModelLoaded(carid) do
				Citizen.Wait(0)
		end
		local playerCoords = GetEntityCoords(playerPed)

		DoScreenFadeOut(0)

		local veh = CreateVehicle(carid, playerCoords, 0.0, true, false)
		spawnedVehicle = NetworkGetNetworkIdFromEntity(veh);
		DecorSetInt(veh, "owner", GetPlayerServerId(PlayerId()))
		SetVehicleModKit(veh, 0)
		SetVehicleModColor_1(veh, 0, 0, 0)
		SetVehicleModColor_2(veh, 0, 0, 0)
		TaskWarpPedIntoVehicle(playerPed, veh, -1)
		SetVehicleCustomPrimaryColour(veh, tonumber(options.main_colour[1]), tonumber(options.main_colour[2]), tonumber(options.main_colour[3]))
		SetVehicleCustomSecondaryColour(veh, tonumber(options.secondary_colour[1]), tonumber(options.secondary_colour[2]), tonumber(options.secondary_colour[3]))
		SetVehicleNumberPlateText(veh, options.plate)
		SetVehicleMod(veh, 23, options.wheels, true)
		SetVehicleWindowTint(veh, options.windows)
		SetVehicleNumberPlateTextIndex(veh, options.platetype)
		SetVehicleMod(veh,  4,  options.exhausts,  true)
		SetVehicleMod(veh,  6,  options.grills,  true)
		SetVehicleMod(veh,  0,  options.spoiler,  true)
		SetVehicleDirtLevel(veh, 0)
		--TriggerServerEvent('es_carshop:newVehicleSpawned', NetworkGetNetworkIdFromEntity(veh))
		SetEntityInvincible(veh, true)
		SetVehicleEngineOn(veh, true, true)
		local blip = AddBlipForEntity(veh)
		SetBlipSprite(blip, 225)
		Citizen.Trace(spawnedVehicle .. "\n")

		isOwnedVehicleSpawned = true

		DoScreenFadeIn(2500)
	end
end)

local player_owned = {}
RegisterNetEvent('es_carshop:removeVehiclesDeleting')
AddEventHandler('es_carshop:removeVehiclesDeleting', function()
	if isOwnedVehicleSpawned then

		if DecorGetInt(GetVehiclePedIsIn(GetPlayerPed(-1), false), "owner") then

			if DecorGetInt(GetVehiclePedIsIn(GetPlayerPed(-1), false), "owner") == GetPlayerServerId(PlayerId()) then
				SetEntityAsMissionEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false))
				Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(GetVehiclePedIsIn(GetPlayerPed(-1))))

				--TriggerServerEvent('es_carshop:vehicleRemoved')
				TriggerEvent('chatMessage', 'SHOP', {255, 0, 0}, 'You removed your own vehicle!')
				isOwnedVehicleSpawned = false
			else
				TriggerEvent('chatMessage', 'SHOP', {255, 0, 0}, 'You require to be in your own vehicle to remove it.')
			end
		else
			TriggerEvent('chatMessage', 'SHOP', {255, 0, 0}, 'You require to be in your personal vehicle to remove it.')
		end
	else
		TriggerEvent('chatMessage', 'SHOP', {255, 0, 0}, 'You require to spawn a personal vehicle to remove it.')
	end
end)


function EnableGui(enable)
    SetNuiFocus(enable)
    guiEnabled = enable

    SendNUIMessage({
        type = "enableui",
        enable = enable
    })

    if(enable) then
      SendNUIMessage({
          type = "vehicleList",
          vehicles = vehicleList
      })

      serveraccess.getPlayerVehicles({""})
    end
end

RegisterNetEvent('es_carshop:recievePlayerVehicles')
AddEventHandler('es_carshop:recievePlayerVehicles', function(r)
  for k,v in pairs(r) do
    serveraccess.getVehicleGarage({v.vehicle}, function(x)
      SendNUIMessage({
          type = "vehicle",
          vehicle = v.vehicle,
          garage = x
      })
    end)
  end
end)

local carshops = {
	--{['x'] = 1696.66, ['y'] = 3607.99, ['z'] = 35.36, blip=true},
	{['x'] = -796.17, ['y'] = 300.94, ['z'] = 85.70, blip=true},
	{['x'] = -673.44, ['y'] = -2390.78, ['z'] = 13.89, blip=true},
	{['x'] = -15.20, ['y'] = -1082.81, ['z'] = 26.67, blip=true},
	{['x'] = -28.65, ['y'] = -1680.18, ['z'] = 29.45, blip=true},
	--{['x'] = 1181.78, ['y'] = 2655.33, ['z'] = 37.82, blip=true},
	{['x'] = -1212.95, ['y'] = -364.35, ['z'] = 37.28, blip=true},
	{['x'] = -1080.71	, ['y'] = -1252.78, ['z'] = 5.41, blip=true},
	{ ['x'] = 248.57885742188, ['y'] = -3062.1379394531, ['z'] = 5.7798938751221, blip=true },
	{ ['x'] = 348.42904663086, ['y'] = 350.54934692383, ['z'] = 105.10478210449, blip=true },
	{ ['x'] = -2173.6982421875, ['y'] = -411.58480834961, ['z'] = 13.279825210571, blip=true },
	{ ['x'] = 893.73767089844, ['y'] = -68.683937072754, ['z'] = 78.764297485352, blip=true },
	--{ ['x'] = -94.009635925293, ['y'] = 89.803314208984, ['z'] = 71.803337097168, blip=true },
	{ ['x'] = 2665.8696289063, ['y'] = 1671.4300537109, ['z'] = 24.487155914307, blip=true },
	{ ['x'] = 1983.103515625, ['y'] = 3773.9240722656, ['z'] = 32.180919647217, blip=true },
	--{ ['x'] = 124.32480621338, ['y'] = 6613.2944335938, ['z'] = 31.855966567993, blip=true },
	{ ['x'] = -242.36260986328, ['y'] = 6196.7661132813, ['z'] = 31.489208221436, blip=true },
	--{ ['x'] = 130.98764038086, ['y'] = 6369.3666992188, ['z'] = 31.297519683838, blip=true },
	{ ['x'] = 233.69268798828, ['y'] = -788.97814941406, ['z'] = 30.605836868286, blip=true },
	{ ['x'] = 1224.59680175781, ['y'] = 2719.73803710938, ['z'] = 38.0048179626465, blip=true },
	--{ ['x'] = -1115.3034667969, ['y'] = -2004.0853271484, ['z'] = 13.171050071716, blip=true },
	{ ['x'] = -349.576080322266, ['y'] = -92.3439254760742, ['z'] = 45.6639442443848, blip=true },
	-- police and emergency
	{ ['x'] = 454.4, ['y'] = -1017.6, ['z'] = 28.4, blip=false},
	{ ['x'] = 1871.0380859375, ['y'] = 3692.90258789063, ['z'] = 33.5941047668457,blip=false }, -- sandy shores
	{ ['x'] = -1119.01953125, ['y'] = -858.455627441406, ['z'] = 13.5303745269775,blip=false }, -- mission row
	{ ['x'] = 1699.84045410156, ['y'] = 3582.97412109375, ['z'] = 35.5014381408691,blip=false }, -- sandy shores
	--{ ['x'] = -492.08544921875, ['y'] = -336.749206542969, ['z'] = 34.3731842041016,blip=false } -- rockford hills
	{ ['x'] = 1160.1824951172, ['y'] = -1494.0286865234, ['z'] = 34.692573547363,blip=false } -- El Burrought Heights
}

local freeBikeshops = {
	--{ ['x'] = -515.1123046875, ['y'] = -255.683700561523, ['z'] = 35.6126327514648,blip=true }, -- city hall
	{ ['x'] = -242.89831542969, ['y'] = -341.04299926758, ['z'] = 29.985424041748,blip=true }, -- rockford plaza subway
	{ ['x'] = 1855.33972167969, ['y'] = 2593.7685546875, ['z'] = 45.6720542907715,blip=true } -- prison
}

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
	for k,v in ipairs(carshops) do
		if v.blip then
			TriggerEvent('es_carshop:createBlip', 50, v.x, v.y, v.z)
		end
	end
	for k,v in ipairs(freeBikeshops) do
		if v.blip then
			TriggerEvent('es_carshop:createBlip', 376, v.x, v.y, v.z)
		end
	end
end)

RegisterNetEvent("es_carshop:createBlip")
AddEventHandler("es_carshop:createBlip", function(type, x, y, z)
	local blip = AddBlipForCoord(x, y, z)
	SetBlipSprite(blip, type)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	if(type == 50)then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Car Shop/Garage")
		EndTextCommandSetBlipName(blip)
	end
	if(type == 376)then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Free Bicycle Shop")
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

RegisterNetEvent('es_carshop:setColour')
AddEventHandler('es_carshop:setColour', function(r, g, b)
	SetVehicleCustomPrimaryColour(NetworkGetEntityFromNetworkId(spawnedVehicle),  r,  g,  b)
end)

RegisterNetEvent('es_carshop:setColourSecondary')
AddEventHandler('es_carshop:setColourSecondary', function(r, g, b)
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
vehicle_names = {
	[80636076] = 'dominator',
	[904750859] = 'mule',
	[-1627000575] = 'police2',
	[1032823388] = 'ninef',
	[-1461482751] = 'ninef2',
	[-1450650718] = 'prairie',
	[-1800170043] = 'gauntlet',
	[523724515] = 'voodoo2',
	[1126868326] = 'bfinjection',
	[-1207771834] = 'rebel',
	[-2030171296] = 'cognoscenti',
	[-685276541] = 'emperor',
	[-1289722222] = 'ingot',
	[1645267888] = 'rancherxl',
	[767087018] = 'alpha',
	[-1041692462] = 'banshee',
	[1039032026] = 'blista2',
	[-1045541610] = 'comet2',
	[-566387422] = 'elegy2',
	[-746882698] = 'schwarzer',
	[1531094468] = 'tornado2',
	[758895617] = 'ztype',
	[-1216765807] = 'adder',
	[1426219628] = 'fmj',
	[1878062887] = 'baller3',
}

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

			if(showFixMessage)then
				DisplayHelpText("You ~g~fixed~w~ your ~b~vehicle~w~!")
			end

			local pos = GetEntityCoords(GetPlayerPed(-1), true)

				for k,v in ipairs(carshops) do
					if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 100.0)then
						DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)

						if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 2.0 and showFixMessage == false)then
							if(not IsPedInAnyVehicle(GetPlayerPed(-1), false))then
								DisplayHelpText("Press ~INPUT_CONTEXT~ to access the ~b~garage~w~ to buy and spawn vehicles.")

								if(IsControlJustReleased(1, 51))then
									EnableGui(true)
								end
							else
								-- Disable vehicle repair at garages
								--[[
								if(IsVehicleDamaged(GetVehiclePedIsIn(GetPlayerPed(-1), false)) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1)), -1) == GetPlayerPed(-1))then
									DisplayHelpText("Press ~INPUT_CONTEXT~ to fix current vehicle.")
									if(IsControlJustReleased(1, 51))then
										showFixMessage = true
										SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1)))
									end
								else]]--
									DisplayHelpText("You cannot be in a vehicle while accessing the garage.")
								--end
							end
						end
					end
				end
				for k,v in ipairs(freeBikeshops) do
					if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 100.0)then
						DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)

						if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 2.0)then
							if(not IsPedInAnyVehicle(GetPlayerPed(-1), false))then
								if not freeBikeOnCooldown then
									DisplayHelpText("Press ~INPUT_CONTEXT~ to get a free bicycle.")

									if(IsControlJustReleased(1, 51))then
										local mhash = GetHashKey("cruiser")

									    local i = 0
									    while not HasModelLoaded(mhash) and i < 10000 do
									      RequestModel(mhash)
									      Citizen.Wait(10)
									      i = i+1
									    end
										local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
										local veh = CreateVehicle(mhash, x,y,z+0.5, 0.0, true, false)
										spawnedVehicle = NetworkGetNetworkIdFromEntity(veh);
										SetVehicleOnGroundProperly(veh)
										SetEntityInvincible(veh,false)
	        							SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(veh))
										SetPedIntoVehicle(GetPlayerPed(-1),veh,-1) -- put player inside
										freeBikeOnCooldown = true
										SetTimeout(freeBikeTimeCooldown * 60000, function()
											freeBikeOnCooldown = false
										end)
									end
								else
									DisplayHelpText("You can only get a free bike every "..freeBikeTimeCooldown.." minutes.")
								end
							else
								DisplayHelpText("You cannot be in a vehicle while accessing the garage.")
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
