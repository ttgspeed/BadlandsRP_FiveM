--===============================================
--= Drug Script- Onlyserenity				 	=
--===============================================

local selling = false
local secondsRemaining = 0
local rejected = false
local actionInProgress = false
local drugSold = nil
local drugSellingZone = nil
local drugHandicap = false
local drugHandicapThreadRunning = false
local defaultDrugHandicapTime = 10 * 60
local drugHandicapTimeRemaining = 0

Citizen.CreateThread(function()
	while true do
		if selling then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
		end

		Citizen.Wait(0)
	end
end)

local zones = {
	['LEGSQU'] = "Legion Square",
	['PBOX'] = "Pillbox Hill",
	['SKID'] = "Mission Row",
	['STRAW'] = "Strawberry",
	['TEXTI'] = "Textile City",
}

local currentped = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 74) and not actionInProgress then
			local player = GetPlayerPed(-1)
			local playerloc = GetEntityCoords(player, 0)
			if playerloc.y < 300.0 then
				local authorized_zone = zones[GetNameOfZone(playerloc.x, playerloc.y, playerloc.z)]
				local handle, ped = FindFirstPed()
				local success
				repeat
					success, ped = FindNextPed(handle)
					local pos = GetEntityCoords(ped)
						local distance = Vdist(pos.x, pos.y, pos.z, playerloc['x'], playerloc['y'], playerloc['z'])
						if canSell(ped) then
							if distance <= 2.5 and ped  ~= GetPlayerPed(-1) and ped ~= oldped then
								local pedType = GetPedType(ped)
								if pedType ~= 29 and pedType ~= 27 and pedType ~= 21 and pedType ~= 20 and pedType ~= 6 then
									actionInProgress = true
									oldped = ped
									DecorSetInt(ped, "OfferedDrugs", 2)
									currentped = ped
									vRPserver.hasAnyDrugs({}, function(ok,drug)
										if ok then
											if not authorized_zone then
												local currentZone = GetNameOfZone(playerloc.x, playerloc.y, playerloc.z)
												if drugSellingZone == nil then
													drugSellingZone = currentZone
													drugHandicap = false
													drugHandicapThreadRunning = false
												elseif drugSellingZone ~= currentZone then
													drugHandicap = true
													startDrugHandicapThread()
												else
													drugHandicap = false
													drugHandicapThreadRunning = false
												end
												actionInProgress = true
												SetEntityAsMissionEntity(currentped)
												ClearPedTasks(currentped)
												FreezeEntityPosition(ped,true)
												local random = math.random(1, 4)
												if random == 1 then
													rejected = true
												end
												drugSold = drug
												TaskStandStill(currentped, 9.0)
												pos1 = GetEntityCoords(currentped)
												currentlySelling()
											else
												tvRP.notify("The people here are not interested in drugs")
												actionInProgress = false
											end
										else
											tvRP.notify("You have no drugs to sell")
											actionInProgress = false
										end
									end)
								else
									DecorSetInt(ped, "OfferedDrugs", 2)
									tvRP.notify("The person rejected your offer")
									local plyPos = GetEntityCoords(GetPlayerPed(-1))
									vRPserver.sendServiceAlert({nil, "Police",plyPos.x,plyPos.y,plyPos.z,"Someone is offering me drugs."})
								end
							end
						end
				until not success
				EndFindPed(handle)
			end
		end
	end
end)

function canSell(aiPed)
	if IsPedInAnyVehicle(GetPlayerPed(-1)) == false then
		if DoesEntityExist(aiPed)then
			if IsPedDeadOrDying(aiPed) == false then
				if IsPedInAnyVehicle(aiPed) == false then
					local pedType = GetPedType(aiPed)
					if pedType ~= 28 and IsPedAPlayer(aiPed) == false then
						if DecorGetInt(aiPed, "OfferedDrugs") ~= 2 then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if selling then
			local player = GetPlayerPed(-1)
			local playerloc = GetEntityCoords(player, 0)
			drawTxt(0.90, 1.40, 1.0,1.0,0.4, "Negotiating: ~b~" .. secondsRemaining .. "~w~ seconds remaining", 255, 255, 255, 255)
			local distance = Vdist(pos1.x, pos1.y, pos1.z, playerloc['x'], playerloc['y'], playerloc['z'])

			if distance > 6 then
				tvRP.notify("Sale Canceled: You're far away now.")
				selling = false
				actionInProgress = false
				SetEntityAsMissionEntity(oldped)
				ClearPedTasks(oldped)
				FreezeEntityPosition(oldped,false)
				SetPedAsNoLongerNeeded(oldped)
			end
			if secondsRemaining == 0 then
				if not rejected then
					local drugItem = drugSold
					sellDrug(true)
					local pid = PlayerPedId()
					SetEntityAsMissionEntity(oldped)
					RequestAnimDict("mp_common")
					while (not HasAnimDictLoaded("mp_common")) do
						Citizen.Wait(0)
					end
					RequestAnimDict("missfbi_s4mop")
					while (not HasAnimDictLoaded("missfbi_s4mop")) do
						Citizen.Wait(0)
					end
					if drugItem == "weed" or drugItem == "weed2" then
						drugItem = "prop_weed_bottle"
					elseif drugItem == "meth" or drugItem == "cocaine_pure" or drugItem == "cocaine_poor" then
						drugItem = 'prop_meth_bag_01'
					else
						drugItem = 'ng_proc_drug01a002'
					end

					local drugObj = CreateObject(GetHashKey(drugItem), tvRP.getPosition(), true, false, false);
					SetEntityAsMissionEntity(drugObj, true, true)
					local playerBoneIndex = GetPedBoneIndex(GetPlayerPed(-1), 57005)
					AttachEntityToEntity(drugObj, GetPlayerPed(-1), playerBoneIndex, 0.1, 0.0, -0.05, 0.0, 90.0, 90.0, false, false, false, false, 2, true)


					--true,{{"missfbi_s4mop","plant_bomb_b",1}},false
					TaskPlayAnim(pid,"missfbi_s4mop","plant_bomb_b",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
					TaskPlayAnim(oldped,"mp_common","givetake2_a",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
					Citizen.Wait(1000)

					DeleteObject(drugObj)
					local cashObj = CreateObject(GetHashKey("prop_anim_cash_pile_01"), tvRP.getPosition(), true, false, false)
					SetEntityAsMissionEntity(cashObj, true, true)
					AttachEntityToEntity(cashObj, GetPlayerPed(-1), playerBoneIndex, 0.1, 0.0, -0.05, 0.0, 90.0, 90.0, false, false, false, false, 2, true)

					StopAnimTask(pid, "missfbi_s4mop","plant_bomb_b", 1.0)
					StopAnimTask(oldped, "mp_common","givetake2_a", 1.0)
					Citizen.Wait(2000)
					DeleteObject(cashObj)
					local random = math.random(1, 20)
					if random == 3 or random == 11 or random == 16 then
						local plyPos = GetEntityCoords(GetPlayerPed(-1))
						vRPserver.sendServiceAlert({nil, "Police",plyPos.x,plyPos.y,plyPos.z,"Someone is offering me drugs."})
					end
				else
					tvRP.notify("The person rejected your offer")
					selling = false
					actionInProgress = false
					rejected = false
					SetEntityAsMissionEntity(oldped)
					local randomReport = math.random(1, 3)
					if randomReport == 3 then
						local plyPos = GetEntityCoords(GetPlayerPed(-1))
						vRPserver.sendServiceAlert({nil, "Police",plyPos.x,plyPos.y,plyPos.z,"Someone is offering me drugs."})
					end
				end
				ClearPedTasks(oldped)
				FreezeEntityPosition(oldped,false)
				SetPedAsNoLongerNeeded(oldped)
			end
		end
	end
end)

function sellDrug(flag)
	if flag then
		vRPserver.giveReward({drugSold,drugHandicap})
		drugSold = nil
		selling = false
		actionInProgress = false
	end
end

function currentlySelling()
	selling = true
	secondsRemaining = 5
end

function tvRP.cancelDrug(drug)
	drugSold = drug
end

function tvRP.doneDrug()
	selling = false
	actionInProgress = false
	secondsRemaining = 0
end

function startDrugHandicapThread()
	if not drugHandicapThreadRunning then
		drugHandicapThreadRunning = true
		drugHandicapTimeRemaining = defaultDrugHandicapTime
		Citizen.CreateThread(function()
			while drugHandicapThreadRunning and drugHandicapTimeRemaining > 0 do
				Citizen.Wait(1000)
				drugHandicapTimeRemaining = drugHandicapTimeRemaining - 1
			end
			drugHandicap = false
			drugSellingZone = nil
			drugHandicapThreadRunning = false
		end)
	end
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawSpecialText(m_text)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end


function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
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
