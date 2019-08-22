local player = PlayerPedId()
local inside = false
local vehicle = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		player = PlayerPedId()
		local plyCoords = GetEntityCoords(player, false)

		if IsDisabledControlPressed(1, 74) and GetVehiclePedIsIn(player, false) == 0 then
			if not inside then
				vehicle = VehicleInFront()
			end
			if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
				local vehClass = GetVehicleClass(vehicle)
				if vehClass == 1 then
					SetVehicleDoorOpen(vehicle, 5, false, false)
					if not inside then
						AttachEntityToEntity(player, vehicle, -1, 0.0, -2.2, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
						RaiseConvertibleRoof(vehicle, false)
						if IsEntityAttached(player) then
							SetTextComponentFormat("STRING")
							AddTextComponentString('~INPUT_VEH_HEADLIGHT~ pop out')
							DisplayHelpTextFromStringLabel(0, 1, 1, -1)
							ClearPedTasksImmediately(player)
							Citizen.Wait(100)
							TaskPlayAnim(player, 'timetable@floyd@cryingonbed@base', 'base', 1.0, -1, -1, 1, 0, 0, 0, 0)
							if not (IsEntityPlayingAnim(player, 'timetable@floyd@cryingonbed@base', 'base', 3) == 1) then
								Streaming('timetable@floyd@cryingonbed@base', function()
									TaskPlayAnim(playerPed, 'timetable@floyd@cryingonbed@base', 'base', 1.0, -1, -1, 1, 0, 0, 0, 0)
								end)
							end

							inside = true
						else
							inside = false
						end
					elseif inside and IsDisabledControlPressed(1, 74) then
						DetachEntity(player, true, true)
						SetEntityVisible(player, true, true)
						ClearPedTasks(player)
						inside = false
						ClearAllHelpMessages()

					end
					Citizen.Wait(2000)
					SetVehicleDoorShut(vehicle, 5, false)
				end
			end
		end
		if inside then
			if DoesEntityExist(vehicle) then
				local visible = true
				DisableAllControlActions(0)
				DisableAllControlActions(1)
				DisableAllControlActions(2)
				EnableControlAction(0, 0, true) --- V - camera
				EnableControlAction(0, 249, true) --- N - push to talk
				EnableControlAction(2, 1, true) --- camera moving
				EnableControlAction(2, 2, true) --- camera moving
				EnableControlAction(0, 177, true) --- BACKSPACE
				EnableControlAction(0, 200, true) --- ESC
				if GetVehicleDoorAngleRatio(vehicle, 5) > 0  then
					SetEntityVisible(player, true, true)
				else
					SetEntityVisible(player, false, false)
				end
			elseif not DoesEntityExist(vehicle) then
				DetachEntity(player, true, true)
				SetEntityVisible(player, true, true)
				ClearPedTasks(player)
				inside = false
				ClearAllHelpMessages()
			end
		end
	end
end)

function Streaming(animDict, cb)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
	end
	if cb ~= nil then
		cb()
	end
end

function VehicleInFront()
	local pos = GetEntityCoords(player)
	local entityWorld = GetOffsetFromEntityInWorldCoords(player, 0.0, 6.0, 0.0)
	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, player, 0)
	local _, _, _, _, result = GetRaycastResult(rayHandle)
	return result
end
