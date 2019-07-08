local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local jobDelayActive = false
local coolDownRemaining = 0

--locations
--arrays
local TruckingCompany = {
	{
		["x"] = 2761.5764160156,["y"] = 1402.6577148438, ["z"] = 24.544370193482,
		["tx"] = 2721.4096679688, ["ty"] = 1362.4340820312, ["tz"] = 24.52396774292
	},
	{
		["x"] = 1225.5522460938,["y"] = -3224.2302246094, ["z"] = 5.860875415802,
		["tx"] = 1166.2922363282, ["ty"] = -3218.0090332032, ["tz"] = 5.7997694015502
	},
	{
		["x"] = -1638.4842529296,["y"] = -813.10845947266, ["z"] = 10.20638206482,
		["tx"] = -1593.7147216797, ["ty"] = -833.57489013672, ["tz"] = 10.043174743652
	},
	{
		["x"] = 2315.8977050782,["y"] = 4919.3891601562, ["z"] = 41.435803741456,
		["tx"] = 2302.5932617188, ["ty"] = 4885.7802734375, ["tz"] = 41.808204650878
	},
	{
		["x"] = 29.184326171875,["y"] = 6537.7802734375, ["z"] = 31.551848983764,
		["tx"] = 61.818717956543, ["ty"] = 6511.4721679688, ["tz"] = 31.542123794556
	},
}

local delivery_locations = {
	[0] = {1212.4463, 2667.4351, 38.79, 0}, --x,y,z,money
	[1] = {2574.5144, 328.5554, 108.45, 0},
	[2] = {-2565.0894, 2345.8904, 33.06, 0},
	[3] = {1706.7966, 4943.9897, 42.16, 0},
	[4] = {196.5617, 6631.0967, 31.53, 0},
	[5] = {68.42, 96.07, 79.00, 0},
	[6] = {-757.31457519532,-2584.8825683594,13.861815452576, 0},
	[7] = {-1073.828491211,-2075.5458984375,13.29149723053, 0},
	[8] = {-744.06060791016,-1504.047241211,5.0002403259278,0},
	[9] = {-1234.658203125,-1426.6927490234,3.8430519104004, 0},
	[10] = {163.92289733886,-2945.095703125,6.000023841858, 0},
	[11] = {-108.38285827636,-2511.4079589844,5.0864944458008, 0},
	[12] = {798.51049804688,-2502.9658203125,21.801120758056, 0},
	[13] = {996.0689086914,-1857.5720214844,30.897911071778, 0},
	[14] = {1001.060974121,-1533.3104248046,29.798561096192, 0},
	[15] = {743.67205810546,-966.32482910156,24.804317474366, 0},
	[16] = {577.24517822266,127.57248687744,98.041442871094, 0},
	[17] = {84.809204101562,95.309829711914,78.652137756348, 0},
	[18] = {2889.412109375,4380.8540039062,50.322399139404, 0},
	[19] = {1736.6082763672,3289.6640625,41.144618988038, 0},
	[20] = {190.92193603516,2787.8605957032,45.622337341308, 0},
	[21] = {1264.182006836,1913.3024902344,78.512016296386, 0},
	[22] = {-85.531730651856,1878.937866211,197.30224609375, 0},
	[23] = {2702.9223632812,3453.326171875,55.710926055908, 0},
	[24] = {182.62503051758,6394.3588867188,31.381048202514, 0},
	[25] = {-355.50018310546,6067.2744140625,31.498622894288, 0},
	[26] = {-510.37362670898,5241.5415039062,80.304092407226, 0},
	[27] = {-1926.30078125,2061.2639160156,140.83590698242, 0},
	[28] = {-2351.8090820312,265.58404541016,165.10375976562, 0},
	[29] = {175.29559326172,1245.3864746094,223.47367858886, 0},
	[30] = {785.95245361328,1279.3848876954,360.29650878906, 0},
}

local job_trucks = {1518533038,569305213,-2137348917,177270108} --Acceptable trucks for this job... {"HAULER", "PACKER", "PHANTOM", "PHANTOM3"}
local job_trailers = {"TANKER", "TRAILERS", "TRAILERS2", "TRAILERLOGS"}

local MISSION = {}
MISSION.start = false
MISSION.tailer = false

MISSION.hashTruck = 0
MISSION.hashTrailer = 0

local currentMission = -1

local playerCoords
local playerPed

local GUI = {}
GUI.loaded          = false
GUI.showStartText   = false
GUI.showMenu        = false
GUI.selected        = {}
GUI.menu            = -1 --current menu

GUI.title           = {}
GUI.titleCount      = 0

GUI.desc            = {}
GUI.descCount       = 0

GUI.button          = {}
GUI.buttonCount     = 0

GUI.time            = 0

--text for mission
local text1 = false
local text2 = false

--blips
local BLIP = {}

BLIP.company = 0

BLIP.trailer = {}
BLIP.trailer.i = 0

BLIP.destination = {}
BLIP.destination.i = 0

--focus button color
local r = 0
local g= 128
local b = 192
local alpha = 200

function clear()
	MISSION.start = false
	SetBlipRoute(BLIP.destination[BLIP.destination.i], false)
	SetEntityAsNoLongerNeeded(BLIP.destination[BLIP.destination.i])

	if ( DoesEntityExist(MISSION.trailer) ) then
		SetEntityAsNoLongerNeeded(MISSION.trailer)
	end

	Citizen.InvokeNative(0xAD738C3085FE7E11, MISSION.trailer, true, true) -- set not as mission entity
	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(MISSION.trailer))

	MISSION.trailer = 0
	MISSION.hashTruck = 0
	MISSION.hashTrailer = 0
	currentMission = -1
end

local initload = false
Citizen.CreateThread(function()
		for k,v in ipairs(TruckingCompany) do
			local blip = AddBlipForCoord(v.x, v.y, v.z)
			SetBlipSprite(blip, 67)
			SetBlipScale(blip, 0.8)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Trucking Company")
			EndTextCommandSetBlipName(blip)
		end
	while true do
	   Wait(0)
	   playerPed = GetPlayerPed(-1)
	   playerCoords = GetEntityCoords(playerPed, 0)
		if (not initload) then
			init()
			initload = true
		end
		tick()
	end
end)

function init()
   -- GUI.loaded = true
end

--Draw Text / Menus
function tick()

	--debugging stange things
	if ( type(BLIP.trailer[BLIP.trailer.i]) == "boolean" ) then
		--Citizen.Trace("-FAIL!-")
	elseif( BLIP.trailer[BLIP.trailer.i] == nil ) then
		--Citizen.Trace("-nil-")
	else
	   BLIP.trailer[BLIP.trailer.i] = BLIP.trailer[BLIP.trailer.i]
	   BLIP.destination[BLIP.destination.i] = BLIP.destination[BLIP.destination.i]
	end


	--Show menu, when player is near
	if( MISSION.start == false) then
			local pos = GetEntityCoords(GetPlayerPed(-1), true)
			for k,v in ipairs(TruckingCompany) do
				if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 100.0)then
					DrawMarker(23, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)

					if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 5.0)then
						if(GUI.showStartText == false) then
							GUI.drawStartText()
						end
						--key controlling
						if(IsControlJustReleased(1, Keys["E"]) and GUI.showMenu == false) then
							--clear()
							if not jobDelayActive then
								local ped = GetPlayerPed(-1)
								local in_truck = false
								if IsPedSittingInAnyVehicle(ped) then
									local veh = GetVehiclePedIsUsing(ped)
									if DoesEntityExist(veh) then
										if IsEntityAMissionEntity(veh) then
											for _,v in pairs(job_trucks) do
												if v == GetEntityModel(veh) then
													in_truck = true
												end
											end
										else
											DrawMissionText("This vehicle has no registered owner and cannot be used.", 500)
										end
									end
								end
								if in_truck then
									GUI.optionMisson()
									GUI.mission()
									MISSION.spawnTrailer(v.tx, v.ty, v.tz)
									-- GUI.showMenu = true
									-- GUI.menu = 0
								end
							else
								vRP.notify({"The boss is not happy with your last job and will not give you another contract for "..coolDownRemaining.." seconds."})
							end
						end
						if(IsControlPressed(1, Keys["N-"]) and GUI.showMenu == true) then
							GUI.showMenu = false
						end
					else
						GUI.showStartText = false
					end
				end
			end
		--menu
		if( GUI.loaded == false ) then
			GUI.init()
		end

		if( GUI.showMenu == true and GUI.menu ~= -1) then
			if( GUI.time == 0) then
				GUI.time = GetGameTimer()
			end
			if( (GetGameTimer() - GUI.time) > 10) then
				GUI.updateSelectionMenu(GUI.menu)
				GUI.time = 0
			end
			GUI.renderMenu(GUI.menu)
		end --if GUI.loaded == false
	elseif( MISSION.start == true ) then

		MISSION.markerUpdate(IsEntityAttached(MISSION.trailer))
		if( IsEntityAttached(MISSION.trailer) and text1 == false) then
			DrawMissionText("Drive to the marked ~g~destination~w~.", 10000)
			text1 = true
		elseif( not IsEntityAttached(MISSION.trailer) and text2 == false ) then
			DrawMissionText("Attach the ~o~trailer~w~.", 15000)
			text2 = true
		end
		local trailerCoords = GetEntityCoords(MISSION.trailer, 0)
		if ( GetDistanceBetweenCoords(currentMission[1], currentMission[2], currentMission[3], trailerCoords ) < 25 and  not IsEntityAttached(MISSION.trailer)) then
			MISSION.removeMarker()
			local veh = GetVehiclePedIsUsing(GetPlayerPed(-1))
			if IsEntityAMissionEntity(veh) then
				vRPjs.truckerJobSuccess({currentMission[4]})
			else
				DrawMissionText("This vehicle has no registered owner. Payment has been witheld.", 500)
			end
			clear()
		elseif ( GetDistanceBetweenCoords(currentMission[1], currentMission[2], currentMission[3], trailerCoords ) < 100 and IsEntityAttached(MISSION.trailer) ) then
			DrawMarker(23, currentMission[1], currentMission[2], currentMission[3] - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)
			if ( GetDistanceBetweenCoords(currentMission[1], currentMission[2], currentMission[3], trailerCoords ) < 25 and IsEntityAttached(MISSION.trailer) ) then
				DrawMissionText("You have arrived. Detach your ~o~trailer~w~ with ~r~H~w~", 15000)
			end
		end

		if ( IsEntityDead(MISSION.trailer)) and MISSION.start then
			startTruckJobDelayThread()
			MISSION.removeMarker()
			clear()
		end
	end --if MISSION.start == false
end

function startTruckJobDelayThread()
	if not jobDelayActive then
		jobDelayActive = true
		coolDownRemaining = 10*60
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



---------------------------------------
---------------------------------------
---------------------------------------
----------------MISSON-----------------
---------------------------------------
---------------------------------------
---------------------------------------
function GUI.optionMisson()
	--select trailer
	local randomTrailer = GetRandomIntInRange(1, #job_trailers)
	MISSION.hashTrailer = GetHashKey(job_trailers[randomTrailer])
	RequestModel(MISSION.hashTrailer)

	while not HasModelLoaded(MISSION.hashTrailer) do
		Wait(1)
	end
end

function GUI.mission()
	local pos = GetEntityCoords(GetPlayerPed(-1), true)
	local randomMission = GetRandomIntInRange(0, #delivery_locations-1)
	BLIP.trailer.i = BLIP.trailer.i + 1
	BLIP.destination.i = BLIP.destination.i + 1
	currentMission = delivery_locations[randomMission]
	currentMission[4] = math.ceil(Vdist(pos.x, pos.y, pos.z, currentMission[1], currentMission[2], currentMission[3])*0.75)
	print(currentMission[4])
	GUI.showMenu = false
	--mission start
	MISSION.start = true
end

function MISSION.spawnTrailer(tx, ty, tz)
	MISSION.trailer = CreateVehicle(MISSION.hashTrailer, tx, ty, tz, 0.0, true, false)
	SetVehicleOnGroundProperly(MISSION.trailer)

	--setMarker on trailer
	MISSION.trailerMarker()
end

local oneTime = false

function MISSION.trailerMarker()
	--BLIP.trailer.i = BLIP.trailer.i + 1 this happens in GUI.mission()
	BLIP.trailer[BLIP.trailer.i] = AddBlipForEntity(MISSION.trailer)
	SetBlipSprite(BLIP.trailer[BLIP.trailer.i], 1)
	SetBlipColour(BLIP.trailer[BLIP.trailer.i], 17)
	SetBlipRoute(BLIP.trailer[BLIP.trailer.i], false)
	Wait(50)
end

function MISSION.markerUpdate(trailerAttached)
	if( not BLIP.destination[BLIP.destination.i] and trailerAttached) then
	   -- BLIP.destination.i = BLIP.destination.i + 1 this happens in GUI.mission()
		BLIP.destination[BLIP.destination.i]  = AddBlipForCoord(currentMission[1], currentMission[2], currentMission[3])
		SetBlipSprite(BLIP.destination[BLIP.destination.i], 1)
		SetBlipColour(BLIP.destination[BLIP.destination.i], 2)
		SetBlipRoute(BLIP.destination[BLIP.destination.i], true)
	end
	if( trailerAttached ) then
		SetBlipSprite(BLIP.trailer[BLIP.trailer.i], 2) --invisible
	elseif ( not trailerAttached and BLIP.trailer[BLIP.trailer.i]) then
		SetBlipSprite(BLIP.trailer[BLIP.trailer.i], 1) --visible
		SetBlipColour(BLIP.trailer[BLIP.trailer.i], 17)
	end
	Wait(50)
end

function MISSION.removeMarker()
	SetBlipSprite(BLIP.destination[BLIP.destination.i], 2)--invisible
	SetBlipSprite(BLIP.trailer[BLIP.trailer.i], 2) --invisible
end

---------------------------------------
---------------------------------------
---------------------------------------
-----------------MENU------------------
---------------------------------------
---------------------------------------
---------------------------------------
function GUI.drawStartText()
	local ped = GetPlayerPed(-1)
	local in_truck = false
	if IsPedSittingInAnyVehicle(ped) then
		local veh = GetVehiclePedIsUsing(ped)
		if DoesEntityExist(veh) then
			for _,v in pairs(job_trucks) do
				if v == GetEntityModel(veh) then
					in_truck = true
				end
			end
		end
	end
	if in_truck then
		DrawMissionText("Press ~r~E~w~ to begin a trucking job", 500)
	else
		DrawMissionText("You must be driving a ~r~truck~w~ to start this job", 500)
	end
  --GUI.showStartText = true
end

function GUI.renderMenu(menu)
	GUI.renderTitle()
	GUI.renderDesc()
	GUI.renderButtons(menu)
end

function GUI.init()
	GUI.loaded = true
	GUI.addTitle("You're a trucker now.", 0.425, 0.19, 0.45, 0.07 )
	GUI.addDesc("Choose a trailer.", 0.575, 0.375, 0.15, 0.30 )

	--menu, title, function, position
	GUI.addButton(0, "RON Tanker trailer", GUI.optionMisson, 0.35, 0.25, 0.3, 0.05 )
	GUI.addButton(0, "Container trailer", GUI.optionMisson, 0.35, 0.30, 0.3, 0.05 )
	GUI.addButton(0, "Articulated trailer", GUI.optionMisson, 0.35, 0.35, 0.3, 0.05 )
	GUI.addButton(0, "Log trailer", GUI.optionMisson, 0.35, 0.40, 0.3, 0.05 )
	GUI.addButton(0, " ", GUI.null, 0.35, 0.45, 0.3, 0.05)
	GUI.addButton(0, "Exit Menu", GUI.exit, 0.35, 0.50, 0.3, 0.05 )

	GUI.buttonCount = 0

	GUI.addButton(1, "Mission 1 [ 5.000$ ]", GUI.mission, 0.35, 0.25, 0.3, 0.05)
	GUI.addButton(1, "Mission 2 [ 10.000$ ]", GUI.mission, 0.35, 0.30, 0.3, 0.05)
	GUI.addButton(1, "Mission 3 [ 15.000$ ]", GUI.mission, 0.35, 0.35, 0.3, 0.05)
	GUI.addButton(1, "Mission 4 [ 20.000$ ]", GUI.mission, 0.35, 0.40, 0.3, 0.05)
	GUI.addButton(1, "Mission 5 [ 30.000$ ]", GUI.mission, 0.35, 0.45, 0.3, 0.05)
	GUI.addButton(1, "For Testing! [ 1.337$ ]", GUI.mission, 0.35, 0.50, 0.3, 0.05)
	GUI.addButton(1, "Exit Menu", GUI.exit, 0.35, 0.55, 0.3, 0.05)
end

--Render stuff
function GUI.renderTitle()
	for id, settings in pairs(GUI.title) do
		local screen_w = 0
		local screen_h = 0
		screen_w, screen_h = GetScreenResolution(0,0)
		boxColor = {0,0,0,255}
		SetTextFont(0)
		SetTextScale(0.0, 0.40)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(true)
		SetTextDropshadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
		SetTextEntry("STRING")
		AddTextComponentString(settings["name"])
		DrawText((settings["xpos"] + 0.001), (settings["ypos"] - 0.015))
		--AddTextComponentString(settings["name"])
		GUI.renderBox(
			settings["xpos"], settings["ypos"], settings["xscale"], settings["yscale"],
			boxColor[1], boxColor[2], boxColor[3], boxColor[4]
		)
	end
end

function GUI.renderDesc()
		for id, settings in pairs(GUI.desc) do
		local screen_w = 0
		local screen_h = 0
		screen_w, screen_h =  GetScreenResolution(0, 0)
		boxColor = {0,0,0,240}
		SetTextFont(0)
		SetTextScale(0.0, 0.37)
		SetTextColour(255, 255, 255, 255)
		SetTextDropShadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
		SetTextEntry("STRING")
		AddTextComponentString(settings["name"] .. "\n" .."\n" .."Navigate with" .. "\n" .. "arrows." .. "\n" .. "ENTER to Select".. "\n" .."Hold H to Detach" .. "\n" .. "Trailer")
		DrawText((settings["xpos"] - 0.06), (settings["ypos"] - 0.13))
		AddTextComponentString(settings["name"])
		GUI.renderBox(
			settings["xpos"], settings["ypos"], settings["xscale"], settings["yscale"],
			boxColor[1], boxColor[2], boxColor[3], boxColor[4]
		)
		end
end

function GUI.renderButtons(menu)
	for id, settings in pairs(GUI.button[menu]) do
		local screen_w = 0
		local screen_h = 0
		screen_w, screen_h =  GetScreenResolution(0, 0)
		boxColor = {0,0,0,100}
		if(settings["active"]) then
			boxColor = {r,g,b,alpha}
		end
		SetTextFont(0)
		SetTextScale(0.0, 0.35)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(true)
		SetTextDropShadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
		SetTextEntry("STRING")
		AddTextComponentString(settings["name"])
		DrawText((settings["xpos"] + 0.001), (settings["ypos"] - 0.015))
		--AddTextComponentString(settings["name"])
		GUI.renderBox(
			settings["xpos"], settings["ypos"], settings["xscale"],
			settings["yscale"], boxColor[1], boxColor[2], boxColor[3], boxColor[4]
		)
	 end
end

function GUI.renderBox(xpos, ypos, xscale, yscale, color1, color2, color3, color4)
	DrawRect(xpos, ypos, xscale, yscale, color1, color2, color3, color4)
end

--adding stuff
function GUI.addTitle(name, xpos, ypos, xscale, yscale)
	GUI.title[GUI.titleCount] = {}
	GUI.title[GUI.titleCount]["name"] = name
	GUI.title[GUI.titleCount]["xpos"] = xpos
	GUI.title[GUI.titleCount]["ypos"] = ypos
	GUI.title[GUI.titleCount]["xscale"] = xscale
	GUI.title[GUI.titleCount]["yscale"] = yscale
end

function GUI.addDesc(name, xpos, ypos, xscale, yscale)
	GUI.desc[GUI.descCount] = {}
	GUI.desc[GUI.descCount]["name"] = name
	GUI.desc[GUI.descCount]["xpos"] = xpos
	GUI.desc[GUI.descCount]["ypos"] = ypos
	GUI.desc[GUI.descCount]["xscale"] = xscale
	GUI.desc[GUI.descCount]["yscale"] = yscale
end

function GUI.addButton(menu, name, func, xpos, ypos, xscale, yscale)
	if(not GUI.button[menu]) then
		GUI.button[menu] = {}
		GUI.selected[menu] = 0
	end
	GUI.button[menu][GUI.buttonCount] = {}
	GUI.button[menu][GUI.buttonCount]["name"] = name
	GUI.button[menu][GUI.buttonCount]["func"] = func
	GUI.button[menu][GUI.buttonCount]["xpos"] = xpos
	GUI.button[menu][GUI.buttonCount]["ypos"] = ypos
	GUI.button[menu][GUI.buttonCount]["xscale"] = xscale
	GUI.button[menu][GUI.buttonCount]["yscale"] = yscale
	GUI.button[menu][GUI.buttonCount]["active"] = 0
	GUI.buttonCount = GUI.buttonCount + 1
end

function GUI.null()
end

function GUI.exit()
	GUI.showMenu = false
	print("Exit menu")
end

--update stuff
function GUI.updateSelectionMenu(menu)
	if( IsControlPressed(0, Keys["DOWN"]) ) then
		if( GUI.selected[menu] < #GUI.button[menu] ) then
			GUI.selected[menu] = GUI.selected[menu] + 1
		end
	elseif( IsControlPressed(0, Keys["TOP"]) ) then
		if( GUI.selected[menu] > 0 ) then
			GUI.selected[menu] = GUI.selected[menu] - 1
		end
	elseif( IsControlPressed(0, Keys["ENTER"]) ) then
		if( type(GUI.button[menu][GUI.selected[menu]]["func"]) == "function" ) then
			--remember variable GUI.selected[menu]

			--call mission functions
			GUI.button[menu][GUI.selected[menu]]["func"](GUI.selected[menu])

			GUI.menu = 1
			GUI.selected[menu] = 0
			if( not GUI.menu ) then
				GUI.menu = -1
			end
			Wait(100)

			--GUI.button[menu][GUI.selected[menu]]["func"](GUI.selected[menu])
		else
			Citizen.Trace("\n Failes to call function! - Selected Menu: "..GUI.selected[menu].." \n")
		end
		GUI.time = 0
	end
	local i = 0
	for id, settings in ipairs(GUI.button[menu]) do
		GUI.button[menu][i]["active"] = false
		if( i == GUI.selected[menu] ) then
			GUI.button[menu][i]["active"] = true
		end
		i = i + 1
	end
end
