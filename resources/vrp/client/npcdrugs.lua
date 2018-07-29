--===============================================
--= Drug Script- Onlyserenity				 	=
--===============================================

local selling = false
local secondsRemaining = 0
local rejected = false
local actionInProgress = false
local drugSold = nil

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
				local current_zone = zones[GetNameOfZone(playerloc.x, playerloc.y, playerloc.z)]
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
											if not current_zone then
												actionInProgress = true
												SetEntityAsMissionEntity(currentped)
												ClearPedTasks(currentped)
												FreezeEntityPosition(ped,true)
												local random = math.random(1, 4)
												if random == 1 then
													tvRP.notify("The person rejected your offer")
													selling = false
													actionInProgress = false
													SetEntityAsMissionEntity(currentped)
													ClearPedTasks(currentped)
													FreezeEntityPosition(currentped,false)
													SetPedAsNoLongerNeeded(currentped)
													local randomReport = math.random(1, 3)
													if randomReport == 3 then
														local plyPos = GetEntityCoords(GetPlayerPed(-1))
														vRPserver.sendServiceAlert({nil, "Police",plyPos.x,plyPos.y,plyPos.z,"Someone is offering me drugs."})
													end
												else
													drugSold = drug
													TaskStandStill(currentped, 9.0)
													pos1 = GetEntityCoords(currentped)
													currentlySelling()
												end
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
				--true,{{"missfbi_s4mop","plant_bomb_b",1}},false
				TaskPlayAnim(pid,"missfbi_s4mop","plant_bomb_b",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
				TaskPlayAnim(oldped,"mp_common","givetake2_a",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
				Citizen.Wait(1000)
				StopAnimTask(pid, "missfbi_s4mop","plant_bomb_b", 1.0)
				StopAnimTask(oldped, "mp_common","givetake2_a", 1.0)
				Citizen.Wait(2000)
				ClearPedTasks(oldped)
				FreezeEntityPosition(oldped,false)
				SetPedAsNoLongerNeeded(oldped)
			end
		end
		if rejected then
			drawTxt(0.90, 1.40, 1.0,1.0,0.4, "Person ~r~rejected ~w~your offer ~r~", 255, 255, 255, 255)
		end
	end
end)

function sellDrug(flag)
	if flag then
		vRPserver.giveReward({drugSold})
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
