local Keys = {["E"] = 38,["ENTER"] = 18}
local mission_running = false
local dropping = false
local mission_veh = nil
local speed = 0
local crates = 0
local missionCoordinates = {x=0,y=0}
local missionBlip = nil
local last_crate_accuracy = 0
local crate_accuracy_history = {}
local mission_crate_accuracy = 0
local mission_distance_traveled = 0.0

local warehouses = {
	[1] = {x=-2160.4963378906,y=3217.5615234375,z=32.810276031494},
	--[2] = {x=-1590.1925048828,y=-3040.2111816406,z=13.944696426392}, --debug LSIA warehouse, do not enable on prod
}

function tvRP.getAirdropStatus()
  return dropping
end

local function generateMissionCoordinates()
	local ped = GetPlayerPed(-1)
	local pedpos = GetEntityCoords(ped, nil)

	missionCoordinates.x = math.random(-1630,3053)+0.001
	missionCoordinates.y = math.random(-2590,6605)+0.001
	tvRP.setGPS(missionCoordinates.x,missionCoordinates.y)
	missionBlip = AddBlipForRadius(missionCoordinates.x,missionCoordinates.y,0.001,50.0)
	SetBlipSprite(missionBlip,9)
	SetBlipColour(missionBlip,3)
	SetBlipAlpha(missionBlip,80)

	mission_distance_traveled = mission_distance_traveled + math.floor(GetDistanceBetweenCoords(missionCoordinates.x,missionCoordinates.y,0.001,pedpos.x,pedpos.y,pedpos.z,false))
end

local function startAirDrops()
	mission_running = true
	crates = 5
	generateMissionCoordinates()
end

local function stopAirDrops()
	local payment = math.floor(((mission_distance_traveled+0.0)*0.4)*(mission_crate_accuracy/100))
	if(payment > 10000) then
		payment = 10000
	end
	TriggerServerEvent('a1dc3462-d40c-419c-bc67-97953231014b',payment)

	mission_running = false
	last_crate_accuracy = 0
	crate_accuracy_history = {}
	mission_crate_accuracy = 0
	mission_distance_traveled = 0.0
end

local function AddBlips()
	for i,pos in ipairs(warehouses) do
		local blip = AddBlipForCoord(pos.x,pos.y,pos.z)
		SetBlipSprite(blip, 359)
		SetBlipAsShortRange(blip,true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Airdrop Warehouse")
		EndTextCommandSetBlipName(blip)
	end
end

local function calculateMissionAccuracy()
	local total_accuracy = 0
	for i = 1, #crate_accuracy_history do
		total_accuracy = total_accuracy + crate_accuracy_history[i]
	end
	return math.floor(total_accuracy/#crate_accuracy_history)
end

Citizen.CreateThread(function()
	AddBlips()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local pedpos = GetEntityCoords(ped, nil)

		if mission_running and crates > 0 and not dropping and IsPedInAnyVehicle(ped) and pedpos.z > 1000.0 then
			DisplayHelpText("~w~Press ~g~E~w~ to airdrop")
			if (IsControlJustReleased(1, Keys['E']) and IsPedInAnyVehicle(ped)) then
				SetEntityVisible(ped, false, false)
				SetEntityInvincible(ped, true)
				tvRP.attachProp('prop_mil_crate_01',24818,0,0,0,0,0,0,true)
				dropping = true
				crates = crates - 1
				GiveWeaponToPed(ped, GetHashKey("gadget_parachute"), 1, false, false)
				SetPedParachuteTintIndex(PlayerPedId(), 6)
				mission_veh = GetVehiclePedIsIn(ped)
				speed = GetEntitySpeed(mission_veh, false)
				FreezeEntityPosition(mission_veh, true)
				Citizen.Wait(10)
				TaskLeaveVehicle(ped, mission_veh, 16)
			end
		end

		for i,pos in ipairs(warehouses) do
			if GetDistanceBetweenCoords(pos.x,pos.y,pos.z,GetEntityCoords(ped)) <= 50.001 then
				DrawMarker(23, pos.x,pos.y,pos.z-1+0.01, 0, 0, 0, 0, 0, 0, 10.0001, 10.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)
				local check_veh = GetVehiclePedIsIn(ped)
				if GetDistanceBetweenCoords(pos.x,pos.y,pos.z,GetEntityCoords(ped)) <= 10.001 and crates == 0 and (IsThisModelAHeli(GetEntityModel(check_veh)) or IsThisModelAPlane(GetEntityModel(check_veh))) then
					if mission_running then
						if crates == 0 then
							if IsControlJustPressed(1,201) then
								stopAirDrops()
							else
								DisplayHelpText("Press ~b~ENTER~w~ to collect payment for your ~b~Air Deliveries")
							end
						else
							DisplayHelpText("You are already assigned to an ~b~Air Delivery Mission")
						end
					else
						if IsControlJustPressed(1,201) then
							startAirDrops()
						else
							DisplayHelpText("Press ~b~ENTER~w~ to begin an ~b~Air Delivery Mission")
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local pos = GetEntityCoords(ped, nil)
		if(mission_running) then
			tvRP.missionText("Crates Remaining: "..tostring(crates).."~n~Total Accuracy: "..tostring(mission_crate_accuracy).."%~n~Last Accuracy: "..tostring(last_crate_accuracy).."%", 1)

			if(dropping) then
				DisableControlAction(0, 145, true)
				if(GetPedParachuteState(ped) == 0 and pos.z < 300.0) then
					ForcePedToOpenParachute(ped)
				elseif(GetPedParachuteState(ped) == 3) then
					dropping = false
					tvRP.deleteProp('prop_mil_crate_01')
					RemoveBlip(missionBlip)
					local distance = GetDistanceBetweenCoords(missionCoordinates.x, missionCoordinates.y, 0.0, GetEntityCoords(ped))
					if distance > 50.0 then
						distance = 50.0
					end
					last_crate_accuracy = math.floor(((50.0-distance)/50.0)*100.0)
					table.insert(crate_accuracy_history,last_crate_accuracy)
					mission_crate_accuracy = calculateMissionAccuracy()
					SetEntityVisible(ped, true, false)
					SetEntityInvincible(ped, false)
					SetPedIntoVehicle(ped,mission_veh,-1)
					FreezeEntityPosition(mission_veh, false)
					SetPlayerControl(PlayerId(),true)
					SetVehicleForwardSpeed(mission_veh, speed)

					--assign another mission if needed
					if(crates > 0) then
						generateMissionCoordinates()
					end
				end
			end
		end
	end
end)
