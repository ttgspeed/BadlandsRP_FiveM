--Client.lua
local onJob = 0
local payout = 0
local player = PlayerId()
local jobDelayActive = false
local coolDownRemaining = 0

local jobs = {peds = {}, flag = {}, blip = {}, cars = {}, coords = {cx={}, cy={}, cz={}}}

function StartEMSJob(jobid)
	if jobid == 1 then -- taxi
		showLoadingPromtEMS("Loading EMS Dispatch", 2000, 3)
		jobs.coords.cx[1],jobs.coords.cy[1],jobs.coords.cz[1] = -393.6823425293,6132.3647460938,31.191421508789 -- paleto fd
		jobs.coords.cx[2],jobs.coords.cy[2],jobs.coords.cz[2] = -230.81303405762,6313.2768554688,31.290029525757 -- paleto clinic
		jobs.coords.cx[3],jobs.coords.cy[3],jobs.coords.cz[3] = 1843.5604248047,3665.0207519531,33.919143676758 -- sandy shores
		jobs.coords.cx[4],jobs.coords.cy[4],jobs.coords.cz[4] = 298.31918334961,-1443.9111328125,29.801239013672 -- central
		jobs.coords.cx[5],jobs.coords.cy[5],jobs.coords.cz[5] = 1155.0673828125,-1514.1384277344,34.692539215088 -- el buro
		jobs.coords.cx[6],jobs.coords.cy[6],jobs.coords.cz[6] = -675.81182861328,292.40075683594,81.843101501465 -- eclipse
		jobs.coords.cx[7],jobs.coords.cy[7],jobs.coords.cz[7] = -864.23992919922,-300.37069702148,39.536884307861 -- marathon/dorset
		jobs.coords.cx[8],jobs.coords.cy[8],jobs.coords.cz[8] = -454.69653320313,-340.34664916992,34.363433837891 -- mount zonah
		jobs.coords.cx[9],jobs.coords.cy[9],jobs.coords.cz[9] = 293.26489257813,-583.47509765625,43.193908691406 -- strawberry top
		jobs.coords.cx[10],jobs.coords.cy[10],jobs.coords.cz[10] = 364.4553527832,-591.39874267578,28.68648147583 -- stawberry bottom

		jobs.cars[1] = GetVehiclePedIsUsing(GetPlayerPed(-1))
		jobs.flag[1] = 0
		jobs.flag[2] = 59+GetRandomIntInRange(1, 61)
		Wait(2000)
		DrawMissionText("Drive around and wait for dispatches.", 10000)
		onJob = jobid
	end
end

function vRPjobs.toggleEMSmissions()
	if onJob == 0 then
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
			if inEmsVehicle() then
				if not jobDelayActive then
					StartEMSJob(1)
				else
					vRP.notify({"You are on a cooldown. You can signed into dispatch jobs in "..coolDownRemaining.." seconds."})
				end
			end
		end
	else
		DrawMissionText("Signed off LSFD dispatch calls.", 10000)
		StopJobEMS(1)
	end
end

function startJobDelayThread()
	if not jobDelayActive then
		jobDelayActive = true
		coolDownRemaining = 5*60
		Citizen.CreateThread(function()
			while jobDelayActive and coolDownRemaining > 0 do
				Citizen.Wait(1000)
				coolDownRemaining = coolDownRemaining - 1
			end
			jobDelayActive = false
			coolDownRemaining = 0
		end)
	end
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

function DrawMissionText(m_text, showtime)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function showLoadingPromtEMS(showText, showTime, showType)
	Citizen.CreateThread(function()
		Citizen.Wait(0)
		N_0xaba17d7ce615adbf("STRING") -- set type
		AddTextComponentString(showText) -- sets the text
		N_0xbd12f8228410d9b4(showType) -- show promt (types = 3)
		Citizen.Wait(showTime) -- show time
		N_0x10d373323e5b9c0d() -- remove promt
	end)
end

function StopJobEMS(jobid)
	if jobid == 1 then
		if DoesEntityExist(jobs.peds[1]) then
			local pedb = GetBlipFromEntity(jobs.peds[1])
			if pedb ~= nil and DoesBlipExist(pedb) then
				SetBlipSprite(pedb, 2)
				SetBlipDisplay(pedb, 3)
			end
			ClearPedTasksImmediately(jobs.peds[1])
			if DoesEntityExist(jobs.cars[1]) and IsVehicleDriveable(jobs.cars[1], 0) then
				if IsPedSittingInVehicle(jobs.peds[1], jobs.cars[1]) then
					TaskLeaveVehicle(jobs.peds[1], jobs.cars[1], 1)
				end
			end
			Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(jobs.peds[1]))
		end
		if jobs.blip[1] ~= nil and DoesBlipExist(jobs.blip[1]) then
			Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(jobs.blip[1]))
			jobs.blip[1] = nil
		end
		onJob = 0
		jobs.cars[1] = nil
		jobs.peds[1] = nil
		jobs.flag[1] = nil
		jobs.flag[2] = nil
		startJobDelayThread()
	end
end

local ems_vehicles = {
  "ambulance",
  "firetruk",
  "firesuv",
  "asstchief",
  "chiefpara",
	"raptor2",
}

function inEmsVehicle()
	for k,v in pairs(ems_vehicles) do
		if IsVehicleModel(GetVehiclePedIsUsing(GetPlayerPed(-1)), GetHashKey(v)) then
			return true
		end
	end
	return false
end

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if onJob == 1 then
			if DoesEntityExist(jobs.cars[1]) and IsVehicleDriveable(jobs.cars[1], 0) then
				if IsPedSittingInVehicle(GetPlayerPed(-1), jobs.cars[1]) then
					if DoesEntityExist(jobs.peds[1]) then
						if IsPedFatallyInjured(jobs.peds[1]) then
							Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(jobs.peds[1]))
							local pedb = GetBlipFromEntity(jobs.peds[1])
							if pedb ~= nil and DoesBlipExist(pedb) then
								SetBlipSprite(pedb, 2)
								SetBlipDisplay(pedb, 3)
							end
							jobs.peds[1] = nil
							jobs.flag[1] = 0
							jobs.flag[2] = 59+GetRandomIntInRange(1, 61)
							if jobs.blip[1] ~= nil and DoesBlipExist(jobs.blip[1]) then
								Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(jobs.blip[1]))
								jobs.blip[1] = nil
							end
							DrawMissionText("The patient is dead. It's too late for them.", 5000)
						else
							if jobs.flag[1] == 1 and jobs.flag[2] > 0 then
								Wait(1000)
								jobs.flag[2] = jobs.flag[2]-1
								if jobs.flag[2] == 0 then
									local pedb = GetBlipFromEntity(jobs.peds[1])
									if pedb ~= nil and DoesBlipExist(pedb) then
										SetBlipSprite(pedb, 2)
										SetBlipDisplay(pedb, 3)
									end
									ClearPedTasksImmediately(jobs.peds[1])
									Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(jobs.peds[1]))
									jobs.peds[1] = nil
									DrawMissionText("The patient got tired of waiting and called a taxi. Wait for the next dispatch.", 5000)
									jobs.flag[1] = 0
									jobs.flag[2] = 59+GetRandomIntInRange(1, 61)
								else
									if IsPedSittingInVehicle(GetPlayerPed(-1), jobs.cars[1]) then
										if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(jobs.peds[1]), true) < 8.0001 then
											local offs = GetOffsetFromEntityInWorldCoords(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.5, 0.0, 0.0)
											local offs2 = GetOffsetFromEntityInWorldCoords(GetVehiclePedIsUsing(GetPlayerPed(-1)), -1.5, 0.0, 0.0)
											local taskType = 1
											if IsVehicleModel(GetVehiclePedIsUsing(GetPlayerPed(-1)), GetHashKey("ambulance")) then
												taskType = 16
											end
											if GetDistanceBetweenCoords(offs['x'], offs['y'], offs['z'], GetEntityCoords(jobs.peds[1]), true) < GetDistanceBetweenCoords(offs2['x'], offs2['y'], offs2['z'], GetEntityCoords(jobs.peds[1]), true) then
												TaskEnterVehicle(jobs.peds[1], jobs.cars[1], -1, 2, 2.0001, taskType)
											else
												TaskEnterVehicle(jobs.peds[1], jobs.cars[1], -1, 1, 2.0001, taskType)
											end
											jobs.flag[1] = 2
											jobs.flag[2] = 30
										end
									end
								end
							end
							if jobs.flag[1] == 2 and jobs.flag[2] > 0 then
								Wait(1000)
								jobs.flag[2] = jobs.flag[2]-1
								if jobs.flag[2] == 0 then
									local pedb = GetBlipFromEntity(jobs.peds[1])
									if pedb ~= nil and DoesBlipExist(pedb) then
										SetBlipSprite(pedb, 2)
										SetBlipDisplay(pedb, 3)
									end
									ClearPedTasksImmediately(jobs.peds[1])
									Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(jobs.peds[1]))
									jobs.peds[1] = nil
									DrawMissionText("The patient is not going with you. Wait for the next dispatch.", 5000)
									jobs.flag[1] = 0
									jobs.flag[2] = 59+GetRandomIntInRange(1, 61)
								else
									if IsPedSittingInVehicle(jobs.peds[1], jobs.cars[1]) then
										local pedb = GetBlipFromEntity(jobs.peds[1])
										if pedb ~= nil and DoesBlipExist(pedb) then
											SetBlipSprite(pedb, 2)
											SetBlipDisplay(pedb, 3)
										end
										jobs.flag[1] = 3
										jobs.flag[2] = GetRandomIntInRange(1, 10)
										local street = table.pack(GetStreetNameAtCoord(jobs.coords.cx[jobs.flag[2]],jobs.coords.cy[jobs.flag[2]],jobs.coords.cz[jobs.flag[2]]))
										if street[2] ~= 0 and street[2] ~= nil then
											local streetname = string.format("~w~Take me to~y~ %s~w~, nearby~y~ %s", GetStreetNameFromHashKey(street[1]),GetStreetNameFromHashKey(street[2]))
											DrawMissionText(streetname, 5000)
										else
											local streetname = string.format("~w~Take me to the~y~ %s", GetStreetNameFromHashKey(street[1]))
											DrawMissionText(streetname, 5000)
										end
										jobs.blip[1] = AddBlipForCoord(jobs.coords.cx[jobs.flag[2]],jobs.coords.cy[jobs.flag[2]],jobs.coords.cy[jobs.flag[2]])
										AddTextComponentString(GetStreetNameFromHashKey(street[1]))
										N_0x80ead8e2e1d5d52e(jobs.blip[1])
										SetBlipRoute(jobs.blip[1], 1)
										local pos = GetEntityCoords(GetPlayerPed(-1), true)
										payout = math.ceil(Vdist(pos.x, pos.y, pos.z, jobs.coords.cx[jobs.flag[2]], jobs.coords.cy[jobs.flag[2]], jobs.coords.cy[jobs.flag[2]])*0.05)
									end
								end
							end
							if jobs.flag[1] == 3 then
								if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), jobs.coords.cx[jobs.flag[2]],jobs.coords.cy[jobs.flag[2]],jobs.coords.cz[jobs.flag[2]], true) > 4.0001 then
									DrawMarker(1, jobs.coords.cx[jobs.flag[2]],jobs.coords.cy[jobs.flag[2]],jobs.coords.cz[jobs.flag[2]]-1.0001, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 2.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
								else
									if GetEntitySpeed(GetPlayerPed(-1)) < 1 then
										if jobs.blip[1] ~= nil and DoesBlipExist(jobs.blip[1]) then
											Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(jobs.blip[1]))
											jobs.blip[1] = nil
										end
										ClearPedTasksImmediately(jobs.peds[1])
										TaskLeaveVehicle(jobs.peds[1], jobs.cars[1], 1)
										Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(jobs.peds[1]))
										jobs.peds[1] = nil
										Wait(6000)

				  					DrawMissionText("~g~You have delivered the patient!", 5000)
										-- pay money on something
										vRPjs.emsJobSuccess({payout})
										payout = 0
										Wait(8000)
										DrawMissionText("Drive around and wait for the next dispatch.", 10000)
										jobs.flag[1] = 0
										jobs.flag[2] = 59+GetRandomIntInRange(1, 61)
									end
								end
							end
						end
					else
						if jobs.flag[1] > 0 then
							jobs.flag[1] = 0
							jobs.flag[2] = 59+GetRandomIntInRange(1, 61)
							DrawMissionText("Drive around and wait for the next dispatch.", 10000)
							if jobs.blip[1] ~= nil and DoesBlipExist(jobs.blip[1]) then
								Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(jobs.blip[1]))
								jobs.blip[1] = nil
							end
						end
						if jobs.flag[1] == 0 and jobs.flag[2] > 0 then
							Wait(1000)
							if jobs.flag[2] ~= nil then
								jobs.flag[2] = jobs.flag[2]-1
							end
							if jobs.flag[2] == 0 then
								local pos = GetEntityCoords(GetPlayerPed(-1))
								local rped = GetRandomPedAtCoord(pos['x'], pos['y'], pos['z'], 35.001, 35.001, 35.001, 6, _r)
								local rpedType = GetPedType(rped)
								if rpedType ~= 29 and rpedType ~= 28 and rpedType ~= 27 and rpedType ~= 21 and rpedType ~= 20 and rpedType ~= 6 then
									if DoesEntityExist(rped) then
										jobs.peds[1] = rped
										jobs.flag[1] = 1
										jobs.flag[2] = 19+GetRandomIntInRange(1, 21)
										ClearPedTasksImmediately(jobs.peds[1])
										SetBlockingOfNonTemporaryEvents(jobs.peds[1], 1)
										TaskStandStill(jobs.peds[1], 1000*jobs.flag[2])
										DrawMissionText("The patient is waiting for you. Drive nearby", 5000)
										local lblip = AddBlipForEntity(jobs.peds[1])
										SetBlipAsFriendly(lblip, 1)
										SetBlipColour(lblip, 2)
										SetBlipCategory(lblip, 3)
									else
										jobs.flag[1] = 0
										jobs.flag[2] = 59+GetRandomIntInRange(1, 61)
										DrawMissionText("Drive around and wait for the next dispatch.", 10000)
									end
								end
							end
						end
					end
				else
					if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(jobs.cars[1]), true) > 30.0001 then
						StopJobEMS(1)
					else
						DrawMissionText("Get back in your vehicle to continue.~n~Or go away from the vehicle to stop the dispatch task.~n~ ", 1)
					end
				end
			else
				StopJobEMS(1)
				DrawMissionText("The vehicle is destroyed.", 5000)
			end
		end
	end
end)
