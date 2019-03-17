vRPfuel = {}
Tunnel.bindInterface("vRP_AdvancedFuel",vRPfuel)
vRPserver = Tunnel.getInterface("vRP","vRP_AdvancedFuel")
--MENUserver = Tunnel.getInterface("vrp_menu","vrp_menu")
Proxy.addInterface("vRP_AdvancedFuel",vRPfuel)
vRP = Proxy.getInterface("vRP")

essence = 0.142
local stade = 0
local lastModel = 0
local showUI = true
local vehiclesUsed = {}
local vechileForFuel = nil

local currentCans = 0

Citizen.CreateThread(function()
	TriggerServerEvent("essence:addPlayer")
	while true do
		Citizen.Wait(0)
		CheckVeh()
		renderBoxes()
		if(currentCans > 0) then
			local nul, number = GetCurrentPedWeapon(GetPlayerPed(-1))
			if(number == 883325847) then
				local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
				local veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, 4+0.0001, 0, 8192+4096+4+2+1)
				if not IsEntityAVehicle(veh) then veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, 4+0.0001, 0, 4+2+1) end -- cars

				if(veh ~= nil and GetVehicleNumberPlateText(veh) ~= nil) then
					--local nul, number = GetCurrentPedWeapon(GetPlayerPed(-1))

					--if(number == 883325847) then
						Info(settings[lang].refeel)
						if(IsControlJustPressed(1, 38)) then

							RequestAnimDict("weapon@w_sp_jerrycan")
							while not HasAnimDictLoaded("weapon@w_sp_jerrycan") do
								Citizen.Wait(100)
							end

							local toPercent = essence/0.142
							print(5000/toPercent)

							TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire", 8.0, -8, -1, 49, 0, 0, 0, 0)
							local done = false
							local amountToEssence = 0.142-essence
							while done == false do
								Wait(0)
								local _essence = essence
								if(amountToEssence-0.0005 > 0) then
									amountToEssence = amountToEssence-0.0005
									essence = _essence + 0.0005
									_essence = essence
									if(_essence > 0.142) then
										essence = 0.142
										TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(veh), GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
										done = true
									end
									SetVehicleUndriveable(veh, true)
									SetVehicleEngineOn(veh, false, false, false)
									local essenceToPercent = (essence/0.142)*65
									SetVehicleFuelLevel(veh,round(essenceToPercent))
									Wait(100)
								else
									essence = essence + amountToEssence
									local essenceToPercent = (essence/0.142)*65
									SetVehicleFuelLevel(veh,round(essenceToPercent))
									TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(veh), GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
									done = true
								end
							end
							TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire_outro", 8.0, -8, -1, 49, 0, 0, 0, 0)
							Wait(500)
							ClearPedTasks(GetPlayerPed(-1))
							currentCans = currentCans-1

							if(currentCans == 0) then
								RemoveWeaponFromPed(GetPlayerPed(-1),  0x34A67B97)
							end
							SetVehicleUndriveable(veh, false)
						end
					--end
				end
			end
		end
	end
end)


Citizen.CreateThread(function()

	local menu = false
	local bool = false
	local int = 0
	local position = 1
	local array = {"TEST", "TEST2", "TEST3", "TEST4"}

	while true do
		Citizen.Wait(0)
		--if IsPedInAnyVehicle(GetPlayerPed(-1), -1) then
			local isNearFuelStation, stationNumber, distanceF = isNearStation()
			local isNearFuelPStation, stationPlaneNumber = isNearPlaneStation()
			local isNearFuelHStation, stationHeliNumber = isNearHeliStation()
			local isNearFuelBStation, stationBoatNumber = isNearBoatStation()


			------------------------------- VEHICLE FUEL PART -------------------------------

			if(isNearFuelStation) then-- and IsPedInAnyVehicle(GetPlayerPed(-1), -1) and not IsPedInAnyHeli(GetPlayerPed(-1)) and not isBlackListedModel() and not isElectricModel() and GetPedVehicleSeat(GetPlayerPed(-1)) == -1) then
				--Info(settings[lang].openMenu)
				local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
				local veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, 4+0.0001, 0, 8192+4096+4+2+1)  -- boats, helicos
		    if not IsEntityAVehicle(veh) then veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, 4+0.0001, 0, 4+2+1) end -- cars
		    if veh ~= nil and IsEntityAVehicle(veh) then
					vechileForFuel = veh
					local engineRunning = GetIsVehicleEngineRunning(vechileForFuel)
					if distanceF < 3 then
						if engineRunning then
							DrawText3Ds(vechileForFuel, settings[lang].turnEngineOff)
						else
							DrawText3Ds(vechileForFuel, settings[lang].openMenu)
						end
					end
					if(IsControlJustPressed(1, 38))  then
						if not engineRunning then
							menu = not menu
							int = 0
							--[[Menu.hidden = not Menu.hidden

							Menu.Title = "Station essence"
							ClearMenu()
							Menu.addButton("Eteindre le moteur", "stopMotor")]]--
						else
							TriggerEvent('showErrorNotif',"Turn off your engine (G by default)")
						end
					end

					if(menu) then
						TriggerEvent("GUI:Title", settings[lang].buyFuel)

						local maxEscense = 60-(essence/0.142)*60

						TriggerEvent("GUI:Int", settings[lang].liters.." : ", int, 0, maxEscense, function(cb)
							int = cb
						end)

						TriggerEvent("GUI:Option", settings[lang].confirm, function(cb)
							if(cb) then
								menu = not menu

								TriggerServerEvent("essence:buy", int, stationNumber,false)
							else

							end
						end)

						TriggerEvent("GUI:Update")
					end
					--else
					--	if(isNearFuelStation and IsPedInAnyVehicle(GetPlayerPed(-1), -1) and not IsPedInAnyHeli(GetPlayerPed(-1)) and not isBlackListedModel() and isElectricModel()) then
					--		Info(settings[lang].electricError)
					--	end
				else
					if not IsPedInAnyVehicle(GetPlayerPed(-1), -1) then
						Info(settings[lang].getJerryCan)

						if(IsControlJustPressed(1, 38)) then
							TriggerServerEvent("essence:buyCan")
						end
					end
				end
			end


			------------------------------- ELECTRIC VEHICLE PART -------------------------------

			if(isNearElectricStation() and IsPedInAnyVehicle(GetPlayerPed(-1), -1) and not IsPedInAnyHeli(GetPlayerPed(-1)) and not isBlackListedModel() and isElectricModel() and GetPedVehicleSeat(GetPlayerPed(-1)) == -1) then
				Info(settings[lang].openMenu)

				if(IsControlJustPressed(1, 38)) and not GetIsVehicleEngineRunning(GetVehiclePedIsIn(GetPlayerPed(-1), true))  then
					menu = not menu
					int = 0
					--[[Menu.hidden = not Menu.hidden

					Menu.Title = "Station essence"
					ClearMenu()
					Menu.addButton("Eteindre le moteur", "stopMotor")]]--
				end

				if(menu) then
					TriggerEvent("GUI:Title", settings[lang].buyFuel)

					local maxEssence = 60-(essence/0.142)*60

					TriggerEvent("GUI:Int", settings[lang].percent.." : ", int, 0, maxEssence, function(cb)
						int = cb
					end)

					TriggerEvent("GUI:Option", settings[lang].confirm, function(cb)
						if(cb) then
							menu = not menu

							TriggerServerEvent("essence:buy", int, electricityPrice,true)
						else

						end
					end)

					TriggerEvent("GUI:Update")
				end
			else
				if(isNearElectricStation()  and IsPedInAnyVehicle(GetPlayerPed(-1), -1) and not IsPedInAnyHeli(GetPlayerPed(-1)) and not isBlackListedModel() and not isElectricModel()) then
					Info(settings[lang].fuelError)
				end
			end

			------------------------------- BOAT PART -------------------------------

			if(isNearFuelBStation and IsPedInAnyVehicle(GetPlayerPed(-1), -1) and not IsPedInAnyHeli(GetPlayerPed(-1)) and not isBlackListedModel() and GetPedVehicleSeat(GetPlayerPed(-1)) == -1) then
				Info(settings[lang].openMenu)

				if(IsControlJustPressed(1, 38)) and not GetIsVehicleEngineRunning(GetVehiclePedIsIn(GetPlayerPed(-1), true))  then
					menu = not menu
					int = 0
					--[[Menu.hidden = not Menu.hidden

					Menu.Title = "Station essence"
					ClearMenu()
					Menu.addButton("Eteindre le moteur", "stopMotor")]]--
				end

				if(menu) then
					TriggerEvent("GUI:Title", settings[lang].buyFuel)

					local maxEssence = 60-(essence/0.142)*60
					TriggerEvent("GUI:Int", settings[lang].percent.." : ", int, 0, maxEssence, function(cb)
						int = cb
					end)

					TriggerEvent("GUI:Option", settings[lang].confirm, function(cb)
						if(cb) then
							menu = not menu

							TriggerServerEvent("essence:buy", int, stationBoatNumber,false)
						else

						end
					end)

					TriggerEvent("GUI:Update")
				end
			else
				if(isNearFuelBStation  and IsPedInAnyVehicle(GetPlayerPed(-1), -1) and not IsPedInAnyHeli(GetPlayerPed(-1)) and not isBlackListedModel() and isElectricModel()) then
					Info(settings[lang].fuelErrorBoat)
				end
			end

			------------------------------- PLANE PART -------------------------------

			if(isNearFuelPStation and IsPedInAnyVehicle(GetPlayerPed(-1), -1) and not isBlackListedModel() and isPlaneModel() and GetPedVehicleSeat(GetPlayerPed(-1)) == -1) then
				Info(settings[lang].openMenu)

				if(IsControlJustPressed(1, 38)) and not GetIsVehicleEngineRunning(GetVehiclePedIsIn(GetPlayerPed(-1), true))  then
					menu = not menu
					int = 0
					--[[Menu.hidden = not Menu.hidden

					Menu.Title = "Station essence"
					ClearMenu()
					Menu.addButton("Eteindre le moteur", "stopMotor")]]--
				end

				if(menu) then
					TriggerEvent("GUI:Title", settings[lang].buyFuel)

					local maxEssence = 60-(essence/0.142)*60

					TriggerEvent("GUI:Int", settings[lang].percent.." : ", int, 0, maxEssence, function(cb)
						int = cb
					end)

					TriggerEvent("GUI:Option", settings[lang].confirm, function(cb)
						if(cb) then
							menu = not menu

							TriggerServerEvent("essence:buy", int, stationPlaneNumber,false)
						else

						end
					end)

					TriggerEvent("GUI:Update")
				end
			else
				if(isNearFuelPStation  and IsPedInAnyVehicle(GetPlayerPed(-1), -1) and not isBlackListedModel() and not isPlaneModel()) then
					Info(settings[lang].fuelErrorAir)
				end
			end

			------------------------------- HELI PART -------------------------------

			if(isNearFuelHStation and IsPedInAnyVehicle(GetPlayerPed(-1), -1) and not isBlackListedModel() and isHeliModel() and GetPedVehicleSeat(GetPlayerPed(-1)) == -1) then
				Info(settings[lang].openMenu)

				if(IsControlJustPressed(1, 38)) and not GetIsVehicleEngineRunning(GetVehiclePedIsIn(GetPlayerPed(-1), true))  then
					menu = not menu
					int = 0
					--[[Menu.hidden = not Menu.hidden

					Menu.Title = "Station essence"
					ClearMenu()
					Menu.addButton("Eteindre le moteur", "stopMotor")]]--
				end

				if(menu) then
					TriggerEvent("GUI:Title", settings[lang].buyFuel)

					local maxEssence = 60-(essence/0.142)*60

					TriggerEvent("GUI:Int", settings[lang].percent.." : ", int, 0, maxEssence, function(cb)
						int = cb
					end)

					TriggerEvent("GUI:Option", settings[lang].confirm, function(cb)
						if(cb) then
							menu = not menu

							TriggerServerEvent("essence:buy", int, stationHeliNumber,false)
						else

						end
					end)

					TriggerEvent("GUI:Update")
				end
			else
				if(isNearFuelHStation  and IsPedInAnyVehicle(GetPlayerPed(-1), -1) and not isBlackListedModel() and not isHeliModel()) then
					Info(settings[lang].fuelErrorHeli)
				end
			end
		--[[
		else
			local isNearFuelStation, stationNumber = isNearStation()
			if isNearFuelStation then
				Info(settings[lang].getJerryCan)

				if(IsControlJustPressed(1, 38)) then
					TriggerServerEvent("essence:buyCan")
				end
			end
		end
		]]--
	end
end)

local motorcycles = {
	"faggio2",
	"pcj",
	"ruffian",
	"sanchez",
	"daemon",
	"enduro",
	"AKUMA",
	"bagger",
	"vader",
	"carbonrs",
	"nemesis",
	"hexer",
	"sovereign",
	"bati",
	"bf400",
	"vindicator",
	"bati2",
	"cliffhanger",
	"innovation",
	"lectro",
	"thrust",
	"gargoyle",
	"hakuchou",
	"avarus",
	"chimera",
	"daemon2",
	"defiler",
	"diablous",
	"diablous2",
	"esskey",
	"faggion",
	"fcr",
	"fcr2",
	"hakuchou2",
	"manchez",
	"nightblade",
	"ratbike",
	"sanctus",
	"shotaro",
	"vortex",
	"wolfsbane",
	"zombiea",
	"zombieb",
	"double",
}

local supercars = {
	"pfister811",
	"adder",
	"banshee2",
	"bullet",
	"cheetah",
	"entityxf",
	"sheava",
	"fmj",
	"gp1",
	"infernus",
	"italigtb",
	"italigtb2",
	"nero",
	"nero2",
	"osiris",
	"penetrator",
	"le7b",
	"reaper",
	"sultanrs",
	"t20",
	"tempesta",
	"turismor",
	"tyrus",
	"vacca",
	"vagner",
	"voltic",
	"prototipo",
	"xa21",
	"zentorno",
}

function isMotorcycle(model)
  for _, motorcylce in pairs(motorcycles) do
    if model == GetHashKey(motorcylce) then
      return true
    end
  end
  return false
end

function isSupercar(model)
  for _, supercar in pairs(supercars) do
    if model == GetHashKey(supercar) then
      return true
    end
  end
  return false
end

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1000)

		--local isEngineOn = Citizen.InvokeNative(0xAE31E7DF9B5B132E, GetVehiclePedIsIn(GetPlayerPed(-1))) -- Thanks to Asser
		if(IsPedInAnyVehicle(GetPlayerPed(-1), -1) and GetIsVehicleEngineRunning(GetVehiclePedIsIn(GetPlayerPed(-1))) and GetPedVehicleSeat(GetPlayerPed(-1)) == -1 and not isBlackListedModel()) then
			local mph = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 2.236936
			local vitesse = math.ceil(mph)
			local hasTurbo = GetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1)),18)
			local carModel = GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1)))
			local isMotorBike = isMotorcycle(carModel)
			local isSuperCar = isSupercar(carModel)

			if isMotorBike or isSuperCar then
				if(vitesse > 0 and vitesse <20) then
					stade = 0.00002
				elseif(vitesse >= 20 and vitesse <50) then
					stade = 0.00004
				elseif(vitesse >= 50 and vitesse < 70) then
					stade = 0.00008
				elseif(vitesse >= 70 and vitesse <90) then
					stade = 0.00016
				elseif(vitesse >=90 and vitesse < 130) then
					stade = 0.00026
				elseif(vitesse >= 130 and vitesse < 150) then
					stade = 0.00038
				elseif(vitesse >= 150 and vitesse < 160) then
					stade = 0.00052
				elseif(vitesse >= 160 and vitesse < 170) then
					stade = 0.001
				elseif(vitesse >= 170) then
					stade = 0.005
				elseif(vitesse == 0 and IsVehicleEngineOn(veh)) then
					stade = 0.0000004
				end
			else
				if(vitesse > 0 and vitesse <20) then
					stade = 0.00001
				elseif(vitesse >= 20 and vitesse <50) then
					stade = 0.00002
				elseif(vitesse >= 50 and vitesse < 70) then
					stade = 0.00003
				elseif(vitesse >= 70 and vitesse <90) then
					stade = 0.00004
				elseif(vitesse >=90 and vitesse < 130) then
					stade = 0.00006
				elseif(vitesse >= 130 and vitesse < 150) then
					stade = 0.00008
				elseif(vitesse >= 150 and vitesse < 180) then
					stade = 0.00014
				elseif(vitesse >= 180) then
					stade = 0.00020
				elseif(vitesse == 0 and IsVehicleEngineOn(veh)) then
					stade = 0.0000001
				end
			end

			if hasTurbo ~= -1 then
				stade = stade * 1.5
			end

			if(essence - stade > 0) then
				essence = essence - stade
				local essenceToPercent = (essence/0.142)*65
				SetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1)),round(essenceToPercent))
			else
				essence = 0
				SetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1)),0)
				SetVehicleUndriveable(GetVehiclePedIsUsing(GetPlayerPed(-1)), true)
			end
			local percent = (essence/0.142)*100
			--TriggerEvent("carhud:updateFuel", round(percent,1))
		end
	end

end)

function vRPfuel.getFuelLevel()
	local percent = (essence/0.142)*100
	return round(percent,1)
end

-- 0.0001 pour 0 à 20, 0.142 = 100%
-- Donc 0.0001 km en moins toutes les 10 secondes

local lastPlate = 0
local refresh = true
function CheckVeh()
	if(IsPedInAnyVehicle(GetPlayerPed(-1)) and not isBlackListedModel()) then

		--if((lastPlate == GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) and lastModel ~= GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) or (lastPlate ~= GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) and lastModel == GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) or (lastPlate ~= GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) and lastModel ~= GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) then
		if(refresh) then
			TriggerServerEvent("vehicule:getFuel", GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))), GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1)))))
			lastModel = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))
			lastPlate = GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1)))
			refresh = false
		end

	else
		if(not refresh) then
			TriggerServerEvent("essence:setToAllPlayerEscense", essence, lastPlate, lastModel)
			refresh = true
		end
	end



	if(essence == 0 and GetVehiclePedIsUsing(GetPlayerPed(-1)) ~= nil) then
		SetVehicleEngineOn(GetVehiclePedIsUsing(GetPlayerPed(-1)), false, false, false)
	end
end



function renderBoxes()
	if(IsPedInAnyVehicle(GetPlayerPed(-1), -1) and GetPedVehicleSeat(GetPlayerPed(-1)) == -1 ) then
		if showUI then
			local percent = (essence/0.142)*100
			--Citizen.Trace(percent)
			drawRct(0.12, 	0.932, 0.036,0.03,0,0,0,150) -- Fuel panel
			drawTxt(0.621, 	1.427, 1.0,1.0,0.45 , "~w~" .. math.ceil(percent), 255, 255, 255, 255)
			drawTxt(0.633, 	1.427, 1.0,1.0,0.45, "~w~ Fuel", 255, 255, 255, 255)

		end
		if(hud_form == 1) then
			if(showBar) then
				DrawRect(hud_x, hud_y, 0.0149999999999998, 0.15, 255, 255, 255, 200)
				DrawRect(hud_x, hud_y, 0.0119999999999998, 0.142, 80, 80, 80, 255)
				DrawRect(hud_x, hud_y, 0.0119999999999998, essence, 225, 146, 45, 255)
			end

			if(showText) then
				local percent = (essence/0.142)*100

				--DrawAdvancedText(text_x, text_y, 0.005, 0.0028, 0.4,round(percent,1).."%", 255, 255, 255, 255, 0, 1)
				--TriggerEvent("carhud:updateFuel", round(percent,1))
			end
		else
			if(showBar) then
				DrawRect(hud_x, hud_y, 0.15, 0.0149999999999998, 255, 255, 255, 200)
				DrawRect(hud_x, hud_y, 0.142, 0.0119999999999998, 80, 80, 80, 255)
				DrawRect(hud_x, hud_y, essence, 0.0119999999999998, 225, 146, 45, 255)
			end

			if(showText) then
				local percent = (essence/0.142)*100

				--DrawAdvancedText(text_x, text_y, 0.005, 0.0028, 0.4,round(percent,1).."%", 255, 255, 255, 255, 0, 1)
				--TriggerEvent("carhud:updateFuel", round(percent,1))
			end
		end
	end
end

function isNearStation()
	local ped = GetPlayerPed(-1)
	--local plyCoords = GetEntityCoords(GetPlayerPed(-1), 0)

	for _,items in pairs(station) do
		if IsEntityAtCoord(ped, items.x, items.y, items.z, 2.001, 2.001, 2.001, 0, 1, 0) then
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), 0)
			local dist = GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
		--if(GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true) < 2) then
			return true, items.s, dist
		end
	end

	return false
end


function isNearPlaneStation()
	local ped = GetPlayerPed(-1)
	--local plyCoords = GetEntityCoords(GetPlayerPed(-1), 0)

	for _,items in pairs(avion_stations) do
		if IsEntityAtCoord(ped, items.x, items.y, items.z, 10.001, 10.001, 10.001, 0, 1, 0) then
		--if(GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true) < 10) then
			return true, items.s
		end
	end

	return false
end


function isNearHeliStation()
	local ped = GetPlayerPed(-1)
	--local plyCoords = GetEntityCoords(GetPlayerPed(-1), 0)

	for _,items in pairs(heli_stations) do
		if IsEntityAtCoord(ped, items.x, items.y, items.z, 10.001, 10.001, 10.001, 0, 1, 0) then
		--if(GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true) < 10) then
			return true, items.s
		end
	end

	return false
end


function isNearBoatStation()
	local ped = GetPlayerPed(-1)
	--local plyCoords = GetEntityCoords(GetPlayerPed(-1), 0)

	for _,items in pairs(boat_stations) do
		if IsEntityAtCoord(ped, items.x, items.y, items.z, 10.001, 10.001, 10.001, 0, 1, 0) then
		--if(GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true) < 10) then
			return true, items.s
		end
	end

	return false
end


function isNearElectricStation()
	local ped = GetPlayerPed(-1)
	--local plyCoords = GetEntityCoords(GetPlayerPed(-1), 0)

	for _,items in pairs(electric_stations) do
		if IsEntityAtCoord(ped, items.x, items.y, items.z, 2.001, 2.001, 2.001, 0, 1, 0) then
		--if(GetDistanceBetweenCoords(items.x, items.y, items.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true) < 2) then
			return true
		end
	end

	return false
end

--100% = 100L = 100$
-- 1% = 1L = 1


function Info(text, loop)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, loop, 1, 0)
end



function round(num, dec)
  local mult = 10^(dec or 0)
  return math.floor(num * mult + 0.5) / mult
end


function isBlackListedModel()
	local model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1))))
	local isBL = false
	for _,k in pairs(blacklistedModels) do
		if(k==model) then
			isBL = true
			break;
		end
	end

	return isBL
end

function isElectricModel()
	local model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1))))
	local isEL = false
	for _,k in pairs(electric_model) do
		if(k==model) then
			isEL = true
			break;
		end
	end

	return isEL
end


function isHeliModel()
	local model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1))))
	local isHe = false
	for _,k in pairs(heli_model) do
		if(k==model) then
			isHe = true
			break;
		end
	end

	return isHe
end


function isPlaneModel()
	local model = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1))))
	local isPl = false
	for _,k in pairs(plane_model) do
		if(k==model) then
			isPl = true
			break;
		end
	end

	return isPl
end


function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	  N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end


function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end



function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
        if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
    end
    return -2
end



function IsVehInArray()
	for i,k in pairs(vehiclesUsed) do
		if(k.plate == GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) and k.model == GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) then
			return true
		end
	end

	return false
end


function searchByModelAndPlate(plate, model)
	for i,k in pairs(vehiclesUsed) do
		if(k.plate == plate and k.model == model) then
			return true, i
		end
	end

	return false, nil
end


function getVehIndex()
	local index = -1

	for i,k in pairs(vehiclesUsed) do
		if(k.plate == GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) and k.model == GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) then
			index = i
		end
	end

	return index
end


AddEventHandler("playerSpawned", function()
	TriggerServerEvent("essence:playerSpawned")
	TriggerServerEvent("essence:addPlayer")
end)


RegisterNetEvent("showNotif")
AddEventHandler("showNotif", function(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end)

RegisterNetEvent("advancedFuel:setEssence")
AddEventHandler("advancedFuel:setEssence", function(percent, plate, model)
	local toEssence = (percent/100)*0.142

	if(GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))) == plate and model == GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))) then
		essence = toEssence
		local essenceToPercent = (essence/0.142)*65
		SetVehicleFuelLevel(GetVehiclePedIsIn(GetPlayerPed(-1)),round(essenceToPercent))
	end

	TriggerServerEvent("advancedFuel:setEssence_s",percent,plate,model)
end)


RegisterNetEvent('essence:sendEssence')
AddEventHandler('essence:sendEssence', function(array)
	for i,k in pairs(array) do
		vehiclesUsed[i] = {plate=k.plate,model=k.model,es=k.es}
	end
end)


RegisterNetEvent('essence:syncWithAllPlayers')
AddEventHandler('essence:syncWithAllPlayers', function(fuel, vplate, vmodel)

	if(IsPedInAnyVehicle(GetPlayerPed(-1))) then
		currentPedVModel = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1))))
		currentPedVPlate = GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1)))

		if(currentPedVModel == vmodel and currentPedVPlate == vmodel) then
			essence = fuel
		end
	end

end)


RegisterNetEvent("essence:setEssence")
AddEventHandler("essence:setEssence", function(ess,vplate,vmodel)
	if(ess ~= nil and vplate ~= nil and vmodel ~=nil) then
		local bool,index = searchByModelAndPlate(vplate,vmodel)

		if(bool and index ~=nil) then
			vehiclesUsed[index].es = ess
		else
			table.insert(vehiclesUsed, {plate = vplate, model = vmodel, es = ess})
		end
	end
end)

local refuelInProgress = false

RegisterNetEvent("essence:hasBuying")
AddEventHandler("essence:hasBuying", function(amount)
	if not refuelInProgress then
		showDoneNotif(settings[lang].YouHaveBought..amount..settings[lang].fuel)
		RequestAnimDict("weapon@w_sp_jerrycan")
		while not HasAnimDictLoaded("weapon@w_sp_jerrycan") do
			Citizen.Wait(100)
		end

		TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire", 8.0, -8, -1, 49, 0, 0, 0, 0)
		local amountToEssence = (amount/60)*0.142

		local done = false
		refuelInProgress = true
		while done == false do
			Wait(0)
			local _essence = essence

			local vehClass = GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1),false))
			if not GetIsVehicleEngineRunning(vechileForFuel) and (not IsPedInAnyVehicle(GetPlayerPed(-1), -1) or (vehClass == 14 or vehClass == 15 or vehClass == 16)) then
				if(amountToEssence-0.0005 > 0) then
					amountToEssence = amountToEssence-0.0005
					essence = _essence + 0.0005
					_essence = essence
					if(_essence > 0.142) then
						essence = 0.142
						done = true
						refuelInProgress = false
					end
					SetVehicleUndriveable(vechileForFuel, true)
					local essenceToPercent = (essence/0.142)*65
					SetVehicleFuelLevel(vechileForFuel,round(essenceToPercent))
					Wait(100)
				else
					essence = essence + amountToEssence
					local essenceToPercent = (essence/0.142)*65
					SetVehicleFuelLevel(vechileForFuel,round(essenceToPercent))
					done = true
					refuelInProgress = false
				end
			else
				done = true
				refuelInProgress = false
			end
		end
		TaskPlayAnim(GetPlayerPed(-1),"weapon@w_sp_jerrycan","fire_outro", 8.0, -8, -1, 49, 0, 0, 0, 0)
		Wait(500)
		ClearPedTasks(GetPlayerPed(-1))
		TriggerServerEvent("essence:setToAllPlayerEscense", essence, GetVehicleNumberPlateText(vechileForFuel), GetDisplayNameFromVehicleModel(GetEntityModel(vechileForFuel)))


		SetVehicleUndriveable(vechileForFuel, false)
	else
		vRP.notify({"You are already refuelling the vehicle"})
	end
end)



RegisterNetEvent("essence:buyCan")
AddEventHandler("essence:buyCan", function()
	showDoneNotif("You bought a fuel can")
	GiveWeaponToPed(GetPlayerPed(-1), 0x34A67B97, currentCans+1,  0, true)
	currentCans = currentCans +1
end)


RegisterNetEvent("vehicule:sendFuel")
AddEventHandler("vehicule:sendFuel", function(bool, ess)

	if(bool == 1) then
		essence = ess
	else
		essence = (math.random(20,100)/100)*0.142
		vehicle = vechileForFuel
		TriggerServerEvent("essence:setToAllPlayerEscense", essence, GetVehicleNumberPlateText(vechileForFuel), GetDisplayNameFromVehicleModel(GetEntityModel(vechileForFuel)))
	end

end)

RegisterNetEvent('camera:hideUI')
AddEventHandler('camera:hideUI', function(toggle)
  if toggle ~= nil then
    showUI = toggle
  end
end)

function DrawText3Ds(object, text)
	local scale = 0.4

	local x,y,z = table.unpack(GetEntityCoords(object))
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)

	AddTextComponentString(text)
	DrawText(_x, _y)

	local factor = (string.len(text)) / 370

	DrawRect(_x, _y + 0.0150, 0.030 + factor, 0.025, 41, 11, 41, 100)
end
