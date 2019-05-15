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
    Citizen.Wait(10)
		local playerPed = GetPlayerPed(-1)
		local playerPos = GetEntityCoords(ped)
    DisplayHelpText("Press ~g~E~s~ to start selling drugs")
    if IsControlJustReleased(1, Keys['E']) then

			sellingDrugs = true
			while sellingDrugs do

				selectedPed = nil
	      while selectedPed == playerPed or selectedPed == 0 or selectedPed == nil or previouslySelectedPeds[selectedPed] do
					playerPos = GetEntityCoords(playerPed)
	        selectedPed = GetRandomPedAtCoord(playerPos.x, playerPos.y,playerPos.z, 100.0, 100.0, 20.0, 26)
					Citizen.Wait(100)
	      end
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


	      local pedPos = GetEntityCoords(selectedPed)
	      local distance = GetDistanceBetweenCoords(playerPos.x, playerPos.y,playerPos.z, pedPos.x,pedPos.y,pedPos.z)
	      local good = true
	      timeout = 0

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

	      if good then
	        ClearPedTasks(selectedPed)
	        TaskLookAtCoord(selectedPed, playerPos.x, playerPos.y, playerPos.z, 100.0, 0, 0)
					--TaskTurnPedToFaceEntity
	        Citizen.Wait(5000)
	        ClearPedTasks(selectedPed)

	        vRPserver.sellNpcDrug({},function(sold)
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
	          else
	          end
	        end)
					ClearPedTasks(selectedPed)
					SetPedAsNoLongerNeeded(selectedPed)
					TaskWanderInArea(selectedPed, playerPos.x, playerPos.y, playerPos.z, 100, 300, 1)
				end
			end
		end
  end
end)
