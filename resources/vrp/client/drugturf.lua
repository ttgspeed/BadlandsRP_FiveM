-----------------
--- Variables ---
-----------------
local zones = {
	['LEGSQU'] = "Legion Square",
	['PBOX'] = "Pillbox Hill",
	['SKID'] = "Mission Row",
	['STRAW'] = "Strawberry",
	['TEXTI'] = "Textile City",
}
local smoking_props = {
	"prop_cs_ciggy_01",
	"prop_sh_joint_01",
	"prop_cs_meth_pipe"
}

local Keys = {
  ["E"] = 38,
  ["Z"] = 20,
  ["F"] = 23
}

local playerPed = nil
local playerPos = nil
local selectedPed = nil
local sellingDrugs = false
local previouslySelectedPeds = {}


------------------------
--- Client Functions ---
------------------------


--------------------------
--- Internal Functions ---
--------------------------

--Main client thread
Citizen.CreateThread(function()
  Citizen.Wait(100)
  while true do
    Citizen.Wait(0)

		--Get player info
		playerPed = GetPlayerPed(-1)
		playerPos = GetEntityCoords(ped)

    DisplayHelpText("Press ~g~E~s~ to start selling drugs")
    if IsControlJustReleased(1, Keys['E']) then

			sellingDrugs = true
			while sellingDrugs do

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

	      --local offsetCoords = GetOffsetFromEntityInWorldCoords(playerPos,0,1.0,0.0)
	      --TaskGoStraightToCoord(selectedPed, playerPos.x, playerPos.y,playerPos.z, 1.0, -1, 0.0, -0.1)
				--TaskFollowNavMeshToCoordAdvanced(selectedPed, playerPos.x, playerPos.y, playerPos.z, 1.0, 120, 0.0, 0, 0, 0, 0, 0.0)
				TaskFollowNavMeshToCoord(selectedPed, playerPos.x, playerPos.y, playerPos.z, 1.0, -1, 1.0, true, 0.0)
				--TaskGoToEntity(selectedPed, playerPed, 120,1.0,1.0)
				--TaskGoToCoordAnyMeans(selectedPed, playerPos.x, playerPos.y,playerPos.z, 1.0)
				--TaskFollowToOffsetOfEntity

				local good  = waitUntilPedIsNearPlayer()
	      if good then
	        ClearPedTasks(selectedPed)
	        --TaskLookAtCoord(selectedPed, playerPos.x, playerPos.y, playerPos.z, 100.0, 0, 0)
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
		pedPos = GetEntityCoords(selectedPed)
		distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y,playerPos.z, pedPos.x,pedPos.y,pedPos.z)
		if timeout > 120 then
			ClearPedTasks(selectedPed)
			SetPedAsNoLongerNeeded(selectedPed)
			TaskWanderInArea(selectedPed, playerPos.x, playerPos.y, playerPos.z, 100, 300, 1)
			good = false
			break
		end
		timeout = timeout + 0.1 --timeout because peds are stupid and get stuck sometimes
	end

	return good
end

function sellDrug()
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
			pedThread(selectedPed,drug)
		else
			ClearPedTasks(selectedPed)
			SetPedAsNoLongerNeeded(selectedPed)
			TaskWanderInArea(selectedPed, playerPos.x, playerPos.y, playerPos.z, 100, 300, 1)
		end
	end)
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

		ClearPedTasks(ped)
		SetPedAsNoLongerNeeded(ped)
		TaskWanderInArea(selectedPed, playerPos.x, playerPos.y, playerPos.z, 100, 300, 1)

	end)
end
