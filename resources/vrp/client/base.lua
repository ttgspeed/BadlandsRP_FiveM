cfg = module("cfg/client")

tvRP = {}
local players = {} -- keep track of connected players (server id)
local first_spawn = true

-- bind client tunnel interface
Tunnel.bindInterface("vRP",tvRP)

-- get server interface
vRPserver = Tunnel.getInterface("vRP","vRP")

-- add client proxy interface (same as tunnel interface)
Proxy.addInterface("vRP",tvRP)
vRPphone = Proxy.getInterface("vrp_phone")
vRPcustom = Proxy.getInterface("CustomScripts")
vRPhospital = Proxy.getInterface("hospital")

-- functions

RegisterNetEvent('vRP:setHostName')
AddEventHandler('vRP:setHostName', function(hostname)
	SendNUIMessage({
		meta = 'setHostName',
		name = hostname
	})
end)

-- play a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
-- duration: in seconds, if -1, will play until stopScreenEffect is called
function tvRP.playScreenEffect(name, duration)
  if duration < 0 then -- loop
    StartScreenEffect(name, 0, true)
  else
    StartScreenEffect(name, 0, true)

    Citizen.CreateThread(function() -- force stop the screen effect after duration+1 seconds
      Citizen.Wait(math.floor((duration+1)*1000))
      StopScreenEffect(name)
    end)
  end
end

-- stop a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
function tvRP.stopScreenEffect(name)
  StopScreenEffect(name)
end

function tvRP.activated()
	TriggerServerEvent("Queue:playerActivated")
end

function tvRP.teleport(x,y,z)
	tvRP.setCheckDelayed(30)
	tvRP.unjail() -- force unjail before a teleportation
	SetEntityCoords(GetPlayerPed(-1), x+0.0001, y+0.0001, z+0.0001, 1,0,0,1)
	vRPserver.updatePos({x,y,z})
end

-- return x,y,z
function tvRP.getPosition()
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	return x,y,z
end

-- return x,y,z
function tvRP.getRotation()
	local x,y,z = table.unpack(GetGameplayCamRot(0))
	return x,y,z
end

-- return false if in exterior, true if inside a building
function tvRP.isInside()
	local x,y,z = tvRP.getPosition()
	return not (GetInteriorAtCoords(x,y,z) == 0)
end

function tvRP.getDistanceFrom(x,y,z)
	local curX,curY,curZ = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	return GetDistanceBetweenCoords(curX,curY,curZ,x,y,z,true)
end

-- return vx,vy,vz
function tvRP.getSpeed()
	local vx,vy,vz = table.unpack(GetEntityVelocity(GetPlayerPed(-1)))
	return math.sqrt(vx*vx+vy*vy+vz*vz)
end

function tvRP.getCamDirection()
	local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
	local pitch = GetGameplayCamRelativePitch()

	local x = -math.sin(heading*math.pi/180.0)
	local y = math.cos(heading*math.pi/180.0)
	local z = math.sin(pitch*math.pi/180.0)

	-- normalize
	local len = math.sqrt(x*x+y*y+z*z)
	if len ~= 0 then
		x = x/len
		y = y/len
		z = z/len
	end

	return x,y,z
end

local playersAndIds = {}

function tvRP.addPlayerAndId(player,user_id)
	playersAndIds[player] = user_id
end

function tvRP.removePlayerAndId(player)
	playersAndIds[player] = nil
end

function tvRP.getUserId(player)
	return playersAndIds[player]
end

function tvRP.addPlayer(player)
	players[player] = true
end

function tvRP.removePlayer(player)
	players[player] = nil
end

function tvRP.getNearestPlayers(radius)
	local r = {}

	local ped = GetPlayerPed(i)
	local pid = PlayerId()
	local px,py,pz = tvRP.getPosition()

	--[[
	for i=0,GetNumberOfPlayers()-1 do
		if i ~= pid then
			local oped = GetPlayerPed(i)

			local x,y,z = table.unpack(GetEntityCoords(oped,true))
			local distance = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
			if distance <= radius then
				r[GetPlayerServerId(i)] = distance
			end
		end
	end
	--]]

	for k,v in pairs(players) do
		local player = GetPlayerFromServerId(k)

		if v and player ~= pid and NetworkIsPlayerConnected(player) then
			local oped = GetPlayerPed(player)
			local x,y,z = table.unpack(GetEntityCoords(oped,true))
			local distance = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
			if distance <= radius then
				r[GetPlayerServerId(player)] = distance
			end
		end
	end

	return r
end

function tvRP.getNearestPlayer(radius)
	local p = nil

	local players = tvRP.getNearestPlayers(radius)
	local min = radius+10.0
	for k,v in pairs(players) do
		if v < min then
			min = v
			p = k
		end
	end

	return p
end

function tvRP.getNearestSerrenderedPlayer(radius)
	Citizen.Trace("Client got here 1")
	local nearServId = tvRP.getNearestPlayer(radius)
	if nearServId ~= nil then
		Citizen.Trace("Client got here 2 "..nearServId)
		local target = GetPlayerPed(GetPlayerFromServerId(nearServId))
		if target ~= 0 and IsEntityAPed(target) and IsEntityPlayingAnim(target,"random@mugging3","handsup_standing_base",3) then
			if HasEntityClearLosToEntityInFront(GetPlayerPed(-1),target) then
				Citizen.Trace("Client got here 3")
				return nearServId
			end
		end
	end
	Citizen.Trace("Client got here 4")
	return nil
end

function tvRP.notify(msg, alert)
	alert = alert or false

	if(alert) then
		PlaySoundFrontend(-1, "On_Call_Player_Join", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 1)
	end

	TriggerEvent("pNotify:SendNotification", {text = msg , type = "success", layout = "centerLeft", queue = "global", theme = "gta", timeout = 5000})
end

RegisterNetEvent('vRP:emergencyChatMessage')
AddEventHandler('vRP:emergencyChatMessage', function(faction, author, color, message, rp_name, user_id)
	if (faction == "lsfd" and tvRP.isMedic()) or (faction == "lspd" and tvRP.isCop()) then
		TriggerServerEvent('_chat:messageEntered', author, color, message, rp_name, user_id)
	end
end)

-- Displays a subtitled mission text, like single player, bottom center of screen
-- text, text to display
-- time, time do display text
function tvRP.missionText(text, time)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(text)
	DrawSubtitleTimed(time, 1)
end

function tvRP.showHelpNotification(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end


-- SCREEN

-- play a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
-- duration: in seconds, if -1, will play until stopScreenEffect is called
function tvRP.playScreenEffect(name, duration)
	if duration < 0 then -- loop
		StartScreenEffect(name, 0, true)
	else
		StartScreenEffect(name, 0, true)

		Citizen.CreateThread(function() -- force stop the screen effect after duration+1 seconds
			Citizen.Wait(math.floor((duration+1)*1000))
			StopScreenEffect(name)
		end)
	end
end

-- stop a screen effect
-- name, see https://wiki.fivem.net/wiki/Screen_Effects
function tvRP.stopScreenEffect(name)
	StopScreenEffect(name)
end

-- ANIM

-- animations dict and names: http://docs.ragepluginhook.net/html/62951c37-a440-478c-b389-c471230ddfc5.htm

local anims = {}
local anim_ids = Tools.newIDGenerator()

-- play animation (new version)
-- upper: true, only upper body, false, full animation
-- seq: list of animations as {dict,anim_name,loops} (loops is the number of loops, default 1) or a task def (properties: task, play_exit)
-- looping: if true, will infinitely loop the first element of the sequence until stopAnim is called
function tvRP.playAnim(upper, seq, looping)
	if seq.task ~= nil and not tvRP.isPedInCar() then -- is a task (cf https://github.com/ImagicTheCat/vRP/pull/118)
		tvRP.stopAnim(true)

		local ped = GetPlayerPed(-1)
		if seq.task == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then -- special case, sit in a chair
			local x,y,z = tvRP.getPosition()
			TaskStartScenarioAtPosition(ped, seq.task, x, y, z-1, GetEntityHeading(ped), 0, 0, false)
		else
			TaskStartScenarioInPlace(ped, seq.task, 0, not seq.play_exit)
		end
	else -- a regular animation sequence
		tvRP.stopAnim(upper)

		local flags = 0
		if upper then
			flags = flags+48
		else
			if tvRP.isPedInCar() then
				tvRP.stopAnim(upper)
				return
			end
		end
		if looping then flags = flags+1 end

		Citizen.CreateThread(function()
			-- prepare unique id to stop sequence when needed
			local id = anim_ids:gen()
			anims[id] = true

			for k,v in pairs(seq) do
				local dict = v[1]
				local name = v[2]
				local loops = v[3] or 1

				for i=1,loops do
					if anims[id] then -- check animation working
						local first = (k == 1 and i == 1)
						local last = (k == #seq and i == loops)

						if dict == "missheistdockssetup1clipboard@base" and name == "base" then
							tvRP.takeNotes()
						else
							-- request anim dict
							RequestAnimDict(dict)
							local i = 0
							while not HasAnimDictLoaded(dict) and i < 1000 do -- max time, 10 seconds
								Citizen.Wait(10)
								RequestAnimDict(dict)
								i = i+1
							end

							-- play anim
							if HasAnimDictLoaded(dict) and anims[id] then
								local inspeed = 8.0001
								local outspeed = -8.0001
								if not first then inspeed = 2.0001 end
								if not last then outspeed = 2.0001 end

								TaskPlayAnim(GetPlayerPed(-1),dict,name,inspeed,outspeed,-1,flags,0,0,0,0)
							end

							Citizen.Wait(0)
							while IsEntityPlayingAnim(GetPlayerPed(-1),dict,name,3) and anims[id] do
								Citizen.Wait(0)
								SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263, true)
								DisableControlAction(0, 24, true) -- Attack
								DisableControlAction(0, 25, true) -- Aim
								DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
								DisableControlAction(0, 142, true) -- MeleeAttackAlternate
								DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
								DisableControlAction(0,263,true) -- disable melee
								DisableControlAction(0,264,true) -- disable melee
								DisableControlAction(0,140,true) -- disable melee
								DisableControlAction(0,141,true) -- disable melee
								DisableControlAction(0,143,true) -- disable melee
							end
						end
					end
				end
			end

			-- free id
			anim_ids:free(id)
			anims[id] = nil
		end)
	end
end

-- stop animation (new version)
-- upper: true, stop the upper animation, false, stop full animations
function tvRP.stopAnim(upper)
	anims = {} -- stop all sequences
	if upper then
		ClearPedSecondaryTask(GetPlayerPed(-1))
	else
		ClearPedTasks(GetPlayerPed(-1))
	end
end

local currentProps = {}
function tvRP.attachProp(prop,bone_ID,x,y,z,RotX,RotY,RotZ)
	local ped = GetPlayerPed(-1)
	bone_ID = GetPedBoneIndex(ped, bone_ID)
	local obj = CreateObject(GetHashKey(prop),  1729.73,  6403.90,  34.56,  true,  true,  true)
	AttachEntityToEntity(obj, ped, bone_ID, x,y,z, RotX,RotY,RotZ,  false, false, false, false, 2, true)
	currentProps[prop] = obj
end

function tvRP.deleteProp(prop)
	DeleteEntity(currentProps[prop])
	currentProps[prop] = nil
end

function tvRP.getCurrentProps()
	return currentProps
end

function tvRP.isInWater()
	return IsEntityInWater(GetPlayerPed(-1))
end

function tvRP.isInWaterOrBoat()
	if IsEntityInWater(GetPlayerPed(-1)) then
		return true
	end

	local player = GetPlayerPed(-1)
	local pos = GetEntityCoords(player)
	local pos2 = {
		["x"] = pos.x,
		["y"] = pos.y,
		["z"] = pos.z-2
	}
	local veh_below = tvRP.GetVehicleInDirection(pos, pos2)
	local targetModelHash = GetEntityModel(veh_below)

  return IsThisModelABoat(targetModelHash)
end

--[[
function tvRP.isLookingAtWater()
	local ped = GetPlayerPed(-1)
	local pos = GetEntityCoords(ped)
	local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, -0.5)
	local obj = CreatePed(28,GetHashKey("A_C_Fish"),entityWorld.x,entityWorld.y,entityWorld.z,0,true,true)
	--SetEntityLocallyInvisible(obj)
	local inWater = IsEntityInWater(obj)
	SetTimeout(5000,function()
		DeleteEntity(obj)
	end)
	return inWater
end
]]--

-- RAGDOLL
local ragdoll = false
local ragdollThreadActive = false

-- set player ragdoll flag (true or false)
function tvRP.setRagdoll(flag)
	ragdoll = flag
	if ragdoll then
		startRagdollThread()
	end
end

-- ragdoll thread function
function startRagdollThread()
	if not ragdollThreadActive then
		ragdollThreadActive = true
		Citizen.CreateThread(function()
			while ragdoll do
				Citizen.Wait(10)
				SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
			end
			ragdollThreadActive = false
		end)
	end
end

-- SOUND
-- some lists:
-- pastebin.com/A8Ny8AHZ
-- https://wiki.gtanet.work/index.php?title=FrontEndSoundlist

-- play sound at a specific position
function tvRP.playSpatializedSound(dict,name,x,y,z,range)
	PlaySoundFromCoord(-1,name,x+0.0001,y+0.0001,z+0.0001,dict,0,range+0.0001,0)
end

-- play sound
function tvRP.playSound(dict,name)
	PlaySound(-1,name,dict,0,0,1)
end

local action_lock = false

function tvRP.setActionLock(flag)
	action_lock = flag
end

function tvRP.getActionLock()
	return action_lock
end

local transformer_lock = false

function tvRP.setTransformerLock(flag)
	transformer_lock = flag
end

function tvRP.getTransformerLock()
	return transformer_lock
end

--[[
-- not working
function tvRP.setMovement(dict)
	if dict then
		SetPedMovementClipset(GetPlayerPed(-1),dict,true)
	else
		ResetPedMovementClipset(GetPlayerPed(-1),true)
	end
end
--]]

function tvRP.setJobLabel(groupName)
	--TriggerEvent("banking:updateJob", groupName)
end

function tvRP.stringsplit(inputstr, sep)
	if inputstr ~= nil then
		if sep == nil then
						sep = "%s"
		end
		local t={}
		for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
						table.insert(t,str)
		end
		return t
	else
		return nil
	end
end


-- events

function tvRP.configurePlayer(char)
	print("trigger ConfigureUserTable")
	print(char)
	vRPserver.ConfigureUserTable({char},function(success)
		if success then
			print("trigger vRPcli:playerSpawned")
			TriggerServerEvent("vRPcli:playerSpawned")
		end
	end)
end

AddEventHandler("playerSpawned",function()
	if first_spawn then
		print("trigger vRPcli:preSpawn")
		TriggerEvent('setInitialVoice')
		TriggerServerEvent("vRPcli:preSpawn")
		first_spawn = false
	end
end)

AddEventHandler("onPlayerDied",function(player,reason)
	TriggerServerEvent("vRPcli:playerDied")
end)

AddEventHandler("onPlayerKilled",function(player,killer,reason)
	TriggerServerEvent("vRPcli:playerDied")
end)

-- voice proximity computation
--[[
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local ped = GetPlayerPed(-1)
		local proximity = cfg.voice_proximity

		if IsPedSittingInAnyVehicle(ped) then
			local veh = GetVehiclePedIsIn(ped,false)
			local hash = GetEntityModel(veh)
			-- make open vehicles (bike,etc) use the default proximity
			if IsThisModelACar(hash) or IsThisModelAHeli(hash) or IsThisModelAPlane(hash) then
				proximity = cfg.voice_proximity_vehicle
			end
		elseif tvRP.isInside() then
			proximity = cfg.voice_proximity_inside
		end

		NetworkSetTalkerProximity(proximity+0.0001)
	end
end)
]]-- Not in use, pulled to keep up with repo

-- Disable NPC emergency/police dispatch
Citizen.CreateThread(function()
	for i = 1, 11 do
		Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
	end
end)

-----------------
-- AFK Kicking
-----------------
function drawTxt2(x,y ,width,height,scale, text, r,g,b,a)
  SetTextFont(6)
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

local afk_lx = nil
local afk_ly = nil
local afk_lz = nil
local afk_ticks = 0
local afk_timeout = 900 --AFK kick time in seconds (15 minutes)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if not tvRP.isInComa() and not tvRP.isHandcuffed() and not tvRP.isJailed() and not tvRP.isInPrison() then
			local x,y,z = tvRP.getPosition()
			if x ~= nil and afk_lx ~= nil and y ~= nil and afk_ly ~= nil then
				if math.floor(x) == math.floor(afk_lx) and math.floor(y) == math.floor(afk_ly) then
					afk_ticks = afk_ticks + 1
					if afk_ticks == afk_timeout then
						TriggerServerEvent("vRP:dropSelf","Inactive beyond limit")
					end
				else
					afk_ticks = 0
				end
			end
		end
		afk_lx,afk_ly,afk_lz = tvRP.getPosition()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		-----------------
		-- AFK Warning
		-----------------
		if afk_ticks > afk_timeout-180 then
			drawTxt2(0.9, 1.39, 1.0,1.0,0.4, "You will be kicked due to inactivity in ~r~"..(afk_timeout-afk_ticks).." seconds.", 255, 255, 255, 255)
		end

		-----------------
		-- Prevent use of Y cancel action when action locked or restrained
		-----------------
		if IsControlJustReleased(1, 246) then
			if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
				if not tvRP.isHandcuffed() and not action_lock then
					if transformer_lock then
						vRPserver.leaveArea({tvRP.getCurrentTransformer()})
					end
					tvRP.stopAnim(true)
					tvRP.stopAnim(false)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300000)
		vRPserver.updatePlayTime({tvRP.isMedic(),tvRP.isCop()})
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(150000)
	while true do
		Citizen.Wait(30000)
		collectgarbage()
	end
end)
