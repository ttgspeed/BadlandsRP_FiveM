-------------------------------------------------------
-------------------------------------------------------
-----------------   Hunting Mod v1.0  -----------------
-----------------  Created by Manu97  -----------------
--------------  Last update: 20/12/2016  --------------
-------------------------------------------------------
-------------------------------------------------------
-----		||||||	||||||	  /\	 \\    //	   ----
-----		||		  ||	 //\\	  \\  //	   ----
-----		||	||	  ||	//  \\	   \\//		   ----
-----		||||||	  ||   //    \\  	\/		   ----
-------------------------------------------------------
-------------------------------------------------------


-----------------CONFIG DATA-----------------
---------------------------------------------

------------ huntingHouse coords ------------
local huntingHouse = {-1494.1384277344,4971.412109375,63.86808013916} 	--x,y,z
local x = huntingHouse[1]
local y = huntingHouse[2]
local z = huntingHouse[3]

------------ vendingHouse coords ------------
local vendingHouse = {-1491.3204345704,4979.7158203125,63.388717651368} 	--x,y,z

---------------- Menu colors ----------------
local r = 0		--red
local g = 128	--green
local b = 192	--blue
local f = 200	--shade

----------------- Menu key ------------------
local k = 69
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

----------------- Map blip ------------------
local mapBlip = 141


---------------------------------------------
---------------!!!-WARNING-!!!---------------
---------------------------------------------
----------!!!-DON'T EDIT BELOW-!!!-----------
---------------------------------------------

local huntDestination1 = {{0, 0, 0}}
local blip2 = nil
local blip3 = nil
local blip4 = nil
local count = 0
local remover = false
local missionX = 0
local missionY = 0
local missionZ = 0
local missionCoords = {}
local missionRunning = false
local entitySkin
local entityType
local entityQuantity
local entity = nil
local entityAlive = false
local entityBlip = nil
local entityHealth = 0

local GUI = {}
GUI.GUI = {}
GUI.title = {}
GUI.menu1 = {}
GUI.description = {}
GUI.TitleCount = 0
GUI.Menu1buttonCount = 0
GUI.desCount = 0
GUI.time = 0
GUI.selectionmenu1 = 0
GUI.loaded = false
GUI.hiddenMenu = true

-- Function local
function GUI.unload()
	-- for i, coords in pairs(huntingHouse) do
	-- 	RemoveBlip(blip)
	-- end
end

function GUI.init()
	GUI.time = GetGameTimer()
	GUI.loaded = true

	GUI.addTitle("Hunting",0.425, 0.19, 0.45, 0.07)
	GUI.addDescription("Help:",0.575, 0.375, 0.15, 0.30)

	GUI.addButtonMenu1("Hunt a boar: coming soon", GUI.Exit, 0.35, 0.25, 0.3, 0.05)
	GUI.addButtonMenu1("Hunt a deer: earn 800$", GUI.Mission2, 0.35, 0.30, 0.3, 0.05)
	GUI.addButtonMenu1("Hunt two boars: coming soon", GUI.Exit, 0.35, 0.35, 0.3, 0.05)
	GUI.addButtonMenu1("Hunt two deers: coming soon", GUI.Exit, 0.35, 0.40, 0.3, 0.05)
	GUI.addButtonMenu1("The Big Foot: coming soon", GUI.Exit, 0.35, 0.45, 0.3, 0.05)
	GUI.addButtonMenu1("Exit Menu", GUI.Exit, 0.35, 0.50, 0.3, 0.05)

end

function GUI.addTitle(name, xpos, ypos, xscale, yscale)
GUI.title[GUI.TitleCount +1] = {}
GUI.title[GUI.TitleCount +1]["name"] = name
GUI.title[GUI.TitleCount +1]["xpos"] = xpos
GUI.title[GUI.TitleCount +1]["ypos"] = ypos
GUI.title[GUI.TitleCount +1]["xscale"] = xscale
GUI.title[GUI.TitleCount +1]["yscale"] = yscale
end

function GUI.addButtonMenu1(name, func, xpos, ypos, xscale, yscale)
GUI.menu1[GUI.Menu1buttonCount +1] = {}
GUI.menu1[GUI.Menu1buttonCount +1]["name"] = name
GUI.menu1[GUI.Menu1buttonCount+1]["func"] = func
GUI.menu1[GUI.Menu1buttonCount+1]["xpos"] = xpos
GUI.menu1[GUI.Menu1buttonCount+1]["ypos"] = ypos
GUI.menu1[GUI.Menu1buttonCount+1]["xscale"] = xscale
GUI.menu1[GUI.Menu1buttonCount+1]["yscale"] = yscale
GUI.Menu1buttonCount = GUI.Menu1buttonCount+1
end

function GUI.addDescription(name, xpos, ypos, xscale, yscale)
GUI.description[GUI.desCount +1] = {}
GUI.description[GUI.desCount +1]["name"] = name
GUI.description[GUI.desCount +1]["xpos"] = xpos
GUI.description[GUI.desCount +1]["ypos"] = ypos
GUI.description[GUI.desCount +1]["xscale"] = xscale
GUI.description[GUI.desCount +1]["yscale"] = yscale
end

function GUI.Marker()
	count = entityQuantity
	blip2 = AddBlipForRadius(missionX,missionY,missionZ,350.0)
	SetBlipSprite(blip2,9)
	SetBlipColour(blip2,3)
	SetBlipAlpha(blip2,80)
end

-- Mission

function GUI.Mission1()
	missionX = 0
	missionY = 0
	missionZ = 0
	missionCoords[1] = missionX
	missionCoords[2] = missionY
	missionCoords[3] = missionZ
	missionRunning = true
	entityType = 28		--Player,1|Male,4|Female,5|Cop,6|Human,26|SWAT,27|Animal,28|Army,29
	entitySkin = {GetHashKey("")}	--Deer,a_c_deer|Boar,a_c_boar|Wolf,a_c_wolf
	entityQuantity = 1
	remover = true
	GUI.Marker()
end

function GUI.Mission2()
	missions = {-1653.9948730468,4604.001,46.22822189331}
	missionX = missions[1]
	missionY = missions[2]
	missionZ = missions[3]
	missionCoords[1] = missionX
	missionCoords[2] = missionY
	missionCoords[3] = missionZ
	missionRunning = true
	entityType = 28		--Player,1|Male,4|Female,5|Cop,6|Human,26|SWAT,27|Animal,28|Army,29
	entitySkin = GetHashKey("a_c_deer")
	entityQuantity = 1
	remover = true
	TriggerServerEvent('hunting:start',("Deer"))
	GUI.Marker()
end

function GUI.Mission3()
missionX = 0
missionY = 0
missionZ = 0
missionCoords[1] = missionX
missionCoords[2] = missionY
missionCoords[3] = missionZ
missionRunning = true
entityType = 28		--Player,1|Male,4|Female,5|Cop,6|Human,26|SWAT,27|Animal,28|Army,29
entitySkin = {GetHashKey("")}
entityQuantity = 1
remover = true
GUI.Marker()
end

function GUI.Mission4()
missionX = -1157
missionY = 4570
missionZ = 142.5
missionCoords[1] = missionX
missionCoords[2] = missionY
missionCoords[3] = missionZ
missionRunning = true
entityType = {28,28}		--Player,1|Male,4|Female,5|Cop,6|Human,26|SWAT,27|Animal,28|Army,29
entitySkin = {GetHashKey("a_c_deer"),GetHashKey("a_c_deer")}
entityQuantity = 2
remover = true
GUI.Marker()
end

function GUI.Mission5()
missionX = 0
missionY = 0
missionZ = 0
missionCoords[1] = missionX
missionCoords[2] = missionY
missionCoords[3] = missionZ
missionRunning = true
entityType = 28		--Player,1|Male,4|Female,5|Cop,6|Human,26|SWAT,27|Animal,28|Army,29
entitySkin = {GetHashKey("")}
entityQuantity = 1
remover = true
GUI.Marker()
end

function GUI.Exit()
GUI.hiddenMenu = true
end

pedindex = {} -- Define a global table to store them in.
blipindex = {}
function PopulatePedIndex()
    local handle, ped = FindFirstPed()
    local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
    repeat
        if not IsEntityDead(ped) then
                pedindex[ped] = {}
        end
        finished, ped = FindNextPed(handle) -- first param returns true while entities are found
    until not finished
    EndFindPed(handle)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		PopulatePedIndex()
		for k, v in pairs(pedindex) do
			if GetPedType(k) == 28 and GetEntityModel(k) ~= 1457690978 and GetEntityModel(k) == -664053099 then
				if not blipindex[k] then
					local blip = AddBlipForEntity(k)
					blipindex[k] = blip
				end
			end
		end
	end
end)

-- Master Function
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(huntingHouse[1],huntingHouse[2],huntingHouse[3])
	SetBlipSprite(blip,mapBlip)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Hunting")
	EndTextCommandSetBlipName(blip)

	while true do
		Citizen.Wait(0)
		local playerPed = GetPlayerPed(-1)
		local coords = GetEntityCoords( playerPed, nil )
		local entityCoords = {}

		if (GetDistanceBetweenCoords( coords.x, coords.y, coords.z, x, y, z, false ) < 5 and missionRunning == false and IsPedInAnyVehicle(playerPed, true)==false) then
			GUI.drawText()
			if(IsControlPressed(1, Keys["E"])) then
				GUI.hiddenMenu = false
			end
		else
			GUI.hiddenMenu = true
		end

		if (GetDistanceBetweenCoords( coords.x, coords.y, coords.z,missionX, missionY, missionZ, false ) < 300 and remover == true) then
		end

		if (missionRunning == true)then
			for entity, blip in pairs(blipindex) do
				entityHealth = GetEntityHealth(entity)
				entityCoords = GetEntityCoords(entity)
				if (entityHealth == 0) then
					SetBlipColour(blip,3)
				end
				if (GetDistanceBetweenCoords( coords.x, coords.y, coords.z,entityCoords.x, entityCoords.y, entityCoords.z, false ) < 3) then
					RemoveBlip(blip2)
					RemoveBlip(blip)
					DeleteEntity(entity)
					missionRunning = false
				end
			end
		end

		if(not GUI.hiddenMenu)then
			if( GUI.time == 0) then
				GUI.time = GetGameTimer()
			end
			if((GetGameTimer() - GUI.time)> 100) then
				GUI.updateSelectionMenu1()
			end
			GUI.renderMenu1GUI()
			if(not GUI.loaded ) then
				GUI.init()
			end
		end
	end
end)

-- GUI Function

function GUI.drawText()
	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, 0.35)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0,220)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString("Press E to show hunting menu")
	DrawText(0.022, 0.020)
	DrawRect(0.127,0.035,0.22,0.05,0,0,0,170)
end

function GUI.updateSelectionMenu1()
if IsControlJustPressed(1, Keys["DOWN"]) then
	if(GUI.selectionmenu1 < GUI.Menu1buttonCount -1  )then
		GUI.selectionmenu1 = GUI.selectionmenu1 +1
		GUI.time = 0
	end
elseif (IsControlPressed(1, Keys["TOP"]))then
	if(GUI.selectionmenu1 > 0)then
		GUI.selectionmenu1 = GUI.selectionmenu1 -1
		GUI.time = 0
	end
elseif (IsControlPressed(1, Keys["ENTER"])) then
	if(type(GUI.menu1[GUI.selectionmenu1 +1]["func"]) == "function") then
		GUI.menu1[GUI.selectionmenu1 +1]["func"](GUI.menu1[GUI.selectionmenu1 +1]["args"])
	end
	GUI.time = 0
end
local iterator = 0
for id, settings in ipairs(GUI.menu1) do
	GUI.menu1[id]["active"] = false
	if(iterator == GUI.selectionmenu1 ) then
		GUI.menu1[iterator +1]["active"] = true
	end
	iterator = iterator +1
end
end

function GUI.renderMenu1GUI()
	GUI.renderTitle()
	GUI.renderButtonsMenu1()
	GUI.renderDescription()
end

function GUI.renderBox(xpos,ypos,xscale,yscale,color1,color2,color3,color4)
	DrawRect(xpos,ypos,xscale,yscale, color1,color2,color3,color4)
end

function GUI.renderTitle()
for id, settings in pairs(GUI.title) do
	local screen_w = 0
	local screen_h = 0
	screen_w, screen_h =  GetScreenResolution(0, 0)
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
	AddTextComponentString(settings["name"])
	GUI.renderBox(settings["xpos"],settings["ypos"],settings["xscale"],settings["yscale"],boxColor[1],boxColor[2],boxColor[3],boxColor[4])
end
end

function GUI.renderButtonsMenu1()

for id, settings in pairs(GUI.menu1) do
	local screen_w = 0
	local screen_h = 0
	screen_w, screen_h =  GetScreenResolution(0, 0)
	boxColor = {0,0,0,100}
	if(settings["active"]) then
		boxColor = {r,g,b,f}
	end
	SetTextFont(0)
	SetTextScale(0.0, 0.35)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(true)
	SetTextDropshadow(0, 0, 0, 0, 0)
	SetTextEdge(0, 0, 0, 0, 0)
	SetTextEntry("STRING")
	AddTextComponentString(settings["name"])
	DrawText((settings["xpos"] + 0.001), (settings["ypos"] - 0.015))
	AddTextComponentString(settings["name"])
	GUI.renderBox(settings["xpos"] ,settings["ypos"], settings["xscale"], settings["yscale"],boxColor[1],boxColor[2],boxColor[3],boxColor[4])
 end
end

function GUI.renderDescription()
	for id, settings in pairs(GUI.description) do
		local screen_w = 0
		local screen_h = 0
		screen_w, screen_h =  GetScreenResolution(0, 0)
		boxColor = {0,0,0,240}
		SetTextFont(0)
		SetTextScale(0.0, 0.37)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
		SetTextEntry("STRING")
		AddTextComponentString(settings["name"] .. "\n" .."\n" .."Num8 to UP" .. "\n" .. "Num2 to DOWN" .. "\n" .. "Num5 to Select".. "\n" )
		DrawText((settings["xpos"] - 0.06), (settings["ypos"] - 0.13))
		AddTextComponentString(settings["name"])
		GUI.renderBox(settings["xpos"],settings["ypos"],settings["xscale"],settings["yscale"],boxColor[1],boxColor[2],boxColor[3],boxColor[4])
	end
end

return GUI
