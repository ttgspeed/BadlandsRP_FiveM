-----------------
--- Variables ---
-----------------
local turfs = {
	['HAWICK'] = "Hawick",
	['DTVINE'] = "Downtown Vinewood",
	['ALTA'] = "Alta",
	['BURTON'] = "Burton",
	['EAST_V'] = "East Vinewood",
	['TEXTI'] = "Textile City"
}
local smoking_props = {
	"prop_cs_ciggy_01",
	"prop_sh_joint_01",
	"prop_cs_meth_pipe"
}

local Keys = {
  ["E"] = 38,
  ["Z"] = 20,
  ["F"] = 23,
	["H"] = 74
}

local playerPed = nil
local playerPos = nil
local selectedPed = nil
local sellingDrugs = false
local previouslySelectedPeds = {}
local currentTurf = nil


------------------------
--- Client Functions ---
------------------------


--------------------------
--- Internal Functions ---
--------------------------

--Main client thread(Civ)
Citizen.CreateThread(function()
  Citizen.Wait(100)
  while true do
    Citizen.Wait(0)

		--Get player info
		playerPed = GetPlayerPed(-1)
		playerPos = GetEntityCoords(playerPed)

		--We wait until you are in a drug zone
		while turfs[GetNameOfZone(table.unpack(GetEntityCoords(playerPed)))] == nil do
			Citizen.Wait(1000)
			playerPed = GetPlayerPed(-1)
			playerPos = GetEntityCoords(playerPed)
		end

    if IsControlJustReleased(1, Keys['H']) then
			sellingDrugs = true
			currentTurf = GetNameOfZone(table.unpack(GetEntityCoords(playerPed)))

			vRPserver.claimTurf({currentTurf},function(ok)
				if not ok then sellingDrugs = false end
			end)

			Citizen.Wait(1000)	--Wait for the callback to check if turf is available

			while sellingDrugs do

				checkIfPlayerIsStillInTurf()

				playerPos = GetEntityCoords(ped)
				selectPed()
	      SetEntityAsMissionEntity(selectedPed)
				previouslySelectedPeds[selectedPed] = true

				--DEBUG
				AddBlipForEntity(selectedPed)
				blip = AddBlipForEntity(ped)
				SetBlipSprite(blip, 1)
				SetBlipColour(blip, 3)
				SetBlipAlpha(blip, 255)
				Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true) -- Player Blip indicator
				----end DEBUG

				TaskFollowNavMeshToCoord(selectedPed, playerPos.x, playerPos.y, playerPos.z, 1.0, -1, 1.0, true, 0.0)

				local good = waitUntilPedIsNearPlayer()
	      if good then
	        ClearPedTasks(selectedPed)
					TaskTurnPedToFaceEntity(selectedPed, playerPed, -1)
					--TaskChatToPed(selectedPed, playerPed, 16, 0.0, 0.0, 0.0, 0.0, 0.0)
	        Citizen.Wait(5000)
	        sellDrug()
					Citizen.Wait(5000)
				end
			end
		end
  end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)
	while true do
		Citizen.Wait(1)

		if tvRP.isCop() then

			--Get player info
			playerPed = GetPlayerPed(-1)
			playerPos = GetEntityCoords(playerPed)

			local handle, ped = FindFirstPed()
			local success
			repeat
				success, ped = FindNextPed(handle)
				local pos = GetEntityCoords(ped)
				local distance = Vdist(pos.x, pos.y, pos.z, playerPos.x, playerPos.y, playerPos.z)
				if distance <= 15 and ped  ~= GetPlayerPed(-1) then
					local pedType = GetPedType(ped)
					local drug = DecorGetInt(ped, "Drugs")
					local restrained = DecorGetBool(ped,"Restrained")
					local fleeing = DecorGetBool(ped,"FleeingCop")
					local surrendering = DecorGetBool(ped,"Surrendering")

					if drug ~= 0 then
						if not restrained and not fleeing and not surrendering then

							--do event
							local event = math.random(1,100)
							if event < 20 then
								ClearPedTasks(ped)
								TaskSmartFleePed(ped, playerPed, 100.0, -1, false, false)
								DecorSetBool(ped,"FleeingCop",true)
							elseif event >=20 and event < 50 then
								TaskHandsUp(ped, -1, playerPed, -1, false)
								DecorSetBool(ped,"Surrendering",true)
							elseif event >=50 then
								print("huh")
							end
						end

						if drug == 1 then
							drug = "cocaine_pure"
						elseif drug == 2 then
							drug = "meth"
						elseif drug == 3 then
							drug = "weed"
						end
						--print(drug)

						playerPos = GetEntityCoords(playerPed)
						pos = GetEntityCoords(ped)
						local distance = Vdist(pos.x, pos.y, pos.z, playerPos.x, playerPos.y, playerPos.z)
						if distance < 2.5 then
							if not DecorGetBool(ped,"Restrained") then
								DisplayHelpText("Press ~g~E~s~ to restrain")
								if IsControlJustReleased(1, Keys['E']) then
									RequestAnimDict("mp_arresting")
									while (not HasAnimDictLoaded("mp_arresting")) do
										Citizen.Wait(0)
									end
									DecorSetBool(ped,"Restrained",true)
									SetEnableHandcuffs(ped, true)
									SetEnableBoundAnkles(ped, true)
									TaskPlayAnim(ped, "mp_arresting", "idle", 100.0, 200.0, -1 , 1, 0.2, 0, 0, 0)

									--Make sure the ped stays restrained
									Citizen.CreateThread(function()
										while DecorGetBool(ped,"Restrained") do
											Citizen.Wait(200)
											if not IsEntityPlayingAnim(ped,"mp_arresting","idle") then
												TaskPlayAnim(ped, "mp_arresting", "idle", 100.0, 200.0, -1 , 1, 0.2, 0, 0, 0)
											end
										end
									end)
								end
							else
								DisplayHelpText("Press ~g~E~s~ to unrestrain")
								if IsControlJustReleased(1, Keys['E']) then
									DecorSetBool(ped,"Restrained",false)
									clearPed(ped)
								end
							end
						end

						-- local copPed = CreatePed(6, 0xE9EC3678, playerPos.x, playerPos.y, playerPos.z)
						-- TaskArrestPed(copPed, closestPed)
					end

				end
			until not success
			EndFindPed(handle)
		end
	end
end)

function selectPed()
	selectedPed = nil
	while selectedPed == playerPed or selectedPed == 0 or selectedPed == nil or previouslySelectedPeds[selectedPed] do
		playerPos = GetEntityCoords(playerPed)
		selectedPed = GetRandomPedAtCoord(playerPos.x, playerPos.y,playerPos.z, 100.0, 100.0, 20.0, 26)
		Citizen.Wait(100)
	end
end

function waitUntilPedIsNearPlayer()
	local pedPos = GetEntityCoords(selectedPed)
	local distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y,playerPos.z, pedPos.x,pedPos.y,pedPos.z)

	local timeout = 0
	local good = true

	--PED incoming
	while distance > 2 do
		Citizen.Wait(100)
		playerPos = GetEntityCoords(playerPed)
		pedPos = GetEntityCoords(selectedPed)
		distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y,playerPos.z, pedPos.x,pedPos.y,pedPos.z)
		checkIfPlayerIsStillInTurf()
		if timeout > 120 or not sellingDrugs then
			clearPed(selectedPed)
			good = false
			break
		end
		timeout = timeout + 0.1 --timeout because peds are stupid and get stuck sometimes
	end

	return good
end

function sellDrug()
	playerPos = GetEntityCoords(playerPed)
	local pedPos = GetEntityCoords(selectedPed)
	local distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y,playerPos.z, pedPos.x,pedPos.y,pedPos.z)
	if distance <= 2 then		-- check if you are still here

		local timeout = 0
		local good = true
		while not IsControlJustReleased(1, Keys['E']) do
			DisplayHelpText("Press ~g~E~s~ to sell drug")
			if timeout > 2 then
				good = false
				break
			end
			timeout = timeout + 0.001
			Citizen.Wait(1)
		end

		if good then
			vRPserver.sellNpcDrug({},function(sold,drug)
				if sold then
						RequestAnimDict("mp_common")
						while (not HasAnimDictLoaded("mp_common")) do
							Citizen.Wait(0)
						end
						RequestAnimDict("missfbi_s4mop")
						while (not HasAnimDictLoaded("missfbi_s4mop")) do
							Citizen.Wait(0)
						end

						tvRP.playAnim(true, {{"mp_common","givetake2_a",1}}, false)
						TaskPlayAnim(selectedPed,"mp_common","givetake2_a",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
						Citizen.Wait(2000)
						DecorSetInt(selectedPed, "OfferedDrugs", 2)

						if drug == "cocaine_pure" or "cocaine_poor" then
							DecorSetInt(selectedPed, "Drugs", 1)
						elseif drug == "meth" then
							DecorSetInt(selectedPed, "Drugs", 2)
						elseif drug == "weed2" or drug == "weed" then
							DecorSetInt(selectedPed, "Drugs", 3)
						end

						pedThread(selectedPed,drug)
				else
					clearPed(selectedPed)
				end
			end)
		else
			clearPed(selectedPed)
		end
	else
		clearPed(selectedPed)
	end
end

function pedThread(ped,drug)
	Citizen.CreateThread(function()
		Citizen.Wait(1000)
		ClearPedTasks(ped)
		SetPedAsNoLongerNeeded(ped)
		TaskWanderInArea(ped, playerPos.x, playerPos.y, playerPos.z, 100, 300, 1)
		SetEntityAsMissionEntity(ped)

		Citizen.Wait(math.random(60*1000,300*1000))

		ClearPedTasks(ped)
		if drug == "meth" then
			RequestAnimDict("timetable@ron@ig_4_smoking_meth")
			while (not HasAnimDictLoaded("timetable@ron@ig_4_smoking_meth")) do
				Citizen.Wait(0)
			end
			local obj = CreateObject(GetHashKey('prop_cs_meth_pipe'),  1729.73,  6403.90,  34.56,  true,  true,  true)
			AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, 28422), 0,0,0,0,0,0,  false, false, false, false, 2, true)
			TaskPlayAnim(ped, "timetable@ron@ig_4_smoking_meth", "chefiscookingup", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
			Citizen.Wait(10)
			while IsEntityPlayingAnim(ped,"timetable@ron@ig_4_smoking_meth","chefiscookingup",3) do Citizen.Wait(100) end
			TaskPlayAnim(ped, "timetable@ron@ig_4_smoking_meth", "onemorehit", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
			Citizen.Wait(10)
			while IsEntityPlayingAnim(ped,"timetable@ron@ig_4_smoking_meth","onemorehit",3) do Citizen.Wait(100) end
			TaskPlayAnim(ped, "timetable@ron@ig_4_smoking_meth", "base", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
			Citizen.Wait(10)
			while IsEntityPlayingAnim(ped,"timetable@ron@ig_4_smoking_meth","onemorehit",3) do Citizen.Wait(100) end
			DeleteEntity(obj)
		elseif drug == "weed" or drug == "weed2" then
			RequestAnimDict("amb@world_human_smoking@male@male_a@enter")
			while (not HasAnimDictLoaded("amb@world_human_smoking@male@male_a@enter")) do
				Citizen.Wait(0)
			end
			RequestAnimDict("timetable@gardener@smoking_joint")
			while (not HasAnimDictLoaded("timetable@gardener@smoking_joint")) do
				Citizen.Wait(0)
			end

			local obj = CreateObject(GetHashKey('prop_sh_joint_01'),  1729.73,  6403.90,  34.56,  true,  true,  true)
			AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, 28422), 0,0,0,0,0,0,  false, false, false, false, 2, true)
			TaskPlayAnim(ped, "amb@world_human_smoking@male@male_a@enter", "enter", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
			Citizen.Wait(10)
			while IsEntityPlayingAnim(ped,"amb@world_human_smoking@male@male_a@enter","enter",3) do Citizen.Wait(100) end

			TaskPlayAnim(ped, "amb@world_human_smoking@male@male_a@enter", "base", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
			Citizen.Wait(10)
			while IsEntityPlayingAnim(ped,"amb@world_human_smoking@male@male_a@enter","base",3) do Citizen.Wait(100) end

			TaskPlayAnim(ped, "timetable@gardener@smoking_joint", "idle_cough", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
			Citizen.Wait(10)
			while IsEntityPlayingAnim(ped,"timetable@gardener@smoking_joint","base",3) do Citizen.Wait(100) end

			TaskPlayAnim(ped, "amb@world_human_smoking@male@male_a@base", "idle_cough", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
			Citizen.Wait(10)
			while IsEntityPlayingAnim(ped,"imetable@gardener@smoking_joint","idle_cough",3) do Citizen.Wait(100) end

			TaskPlayAnim(ped, "timetable@gardener@smoking_joint", "idle_cough", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
			Citizen.Wait(10)
			while IsEntityPlayingAnim(ped,"timetable@gardener@smoking_joint","idle_cough",3) do Citizen.Wait(100) end

			TaskPlayAnim(ped, "amb@world_human_smoking@male@male_a@base", "base", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
			Citizen.Wait(10)
			while IsEntityPlayingAnim(ped,"amb@world_human_smoking@male@male_a@base","base",3) do Citizen.Wait(100) end

			TaskPlayAnim(ped, "amb@world_human_smoking@male@male_a@exit", "exit", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
			Citizen.Wait(10)
			while IsEntityPlayingAnim(ped,"amb@world_human_smoking@male@male_a@exit","exit",3) do Citizen.Wait(100) end

			TaskPlayAnim(ped, "timetable@gardener@smoking_joint", "idle_cough", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
			Citizen.Wait(10)
			while IsEntityPlayingAnim(ped,"timetable@gardener@smoking_joint","idle_cough",3) do Citizen.Wait(100) end

		elseif drug == "cocaine_pure" or drug ==  "cocaine_poor" then
			RequestAnimDict("missfbi3_party")
			while (not HasAnimDictLoaded("missfbi3_party")) do
				Citizen.Wait(0)
			end
			TaskPlayAnim(ped, "missfbi3_party", "snort_coke_b_male3", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
			Citizen.Wait(10)
			while IsEntityPlayingAnim(ped,"missfbi3_party","snort_coke_b_male3",3) do Citizen.Wait(100) end

			--Do something to make ped crazy/hyper maybe?
		end

		clearPed(ped)
	end)
end

function clearPed(ped)
	ClearPedTasks(ped)
	SetPedAsNoLongerNeeded(ped)
	TaskWanderInArea(ped, playerPos.x, playerPos.y, playerPos.z, 100, 300, 1)
end

function checkIfPlayerIsStillInTurf()
	if GetNameOfZone(table.unpack(GetEntityCoords(playerPed))) ~= currentTurf then
		vRPserver.exitTurf({currentTurf})
		sellingDrugs = false
		currentTurf = nil
	end
end
