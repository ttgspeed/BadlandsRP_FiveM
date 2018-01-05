-- ###################################
--
--        C   O   N   F   I   G
--
-- ###################################

-- show/hide compoent
local HUD = {
	Speed 			= 'mph', -- kmh or mph
	DamageSystem 	= true,
	SpeedIndicator 	= false,
	ParkIndicator 	= false,
	Top 			= true, -- ALL TOP PANAL ( oil, dsc, plate, fluid, ac )
	Plate 			= true, -- only if Top is false and you want to keep Plate Number
	FuelIndicator	= true,
}

-- move all ui
local UI = {

	x =  0.000 ,	-- Base Screen Coords 	+ 	 x
	y = -0.001 ,	-- Base Screen Coords 	+ 	-y

}

-- ###################################
--
--             C   O   D   E
--
-- ###################################

local fuelAmmount = 0
local showUI = true

Citizen.CreateThread(function()
	while true do Citizen.Wait(1)

		if showUI then
			local MyPed = GetPlayerPed(-1)
			local timeMinutes = GetClockMinutes()
			if timeMinutes < 10 then
				timeMinutes = "0"..timeMinutes
			end
			local currentTime = GetClockHours()..":"..timeMinutes
			drawTxt(UI.x + 0.52, UI.y + 1.266, 1.0,1.0,0.45, "~w~" .. currentTime, 240, 200, 80, 255)

			if(IsPedInAnyVehicle(MyPed, false))then

				local MyPedVeh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
				local PlateVeh = GetVehicleNumberPlateText(MyPedVeh)
				local VehStopped = IsVehicleStopped(MyPedVeh)
				local VehEngineHP = GetVehicleEngineHealth(MyPedVeh)
				local VehBodyHP = GetVehicleBodyHealth(MyPedVeh)
				local VehBurnout = IsVehicleInBurnout(MyPedVeh)

				--drawTxt(UI.x + 0.563, 	UI.y + 1.2624, 1.0,1.0,0.55, "~w~" .. PlateVeh, 255, 255, 255, 255)
				--drawRct(UI.x + 0.0625, 	UI.y + 0.768, 0.045, 0.037, 0,0,0,150)

				--[[
				if VehBurnout then
					drawTxt(UI.x + 0.535, UI.y + 1.266, 1.0,1.0,0.44, "~r~DSC", 255, 255, 255, 200)
				else
					drawTxt(UI.x + 0.535, UI.y + 1.266, 1.0,1.0,0.44, "DSC", 255, 255, 255, 150)
				end
				]]--

				local dmg_bar_left = 0.159
				local dmg_bar_right = 0.1661
				local dmg_bar_top =  0.809
				local dmg_bar_bottom = 0.988
				local dmg_bar_height = dmg_bar_bottom - dmg_bar_top
				local dmg_bar_width = 0.005

				local speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 2.236936
				local veh = GetVehiclePedIsUsing(GetPlayerPed(-1))
				local timeMinutes = GetClockMinutes()
				if timeMinutes < 10 then
					timeMinutes = "0"..timeMinutes
				end
				local currentTime = GetClockHours()..":"..timeMinutes

				drawRct(dmg_bar_right, dmg_bar_top, dmg_bar_width,dmg_bar_height * (VehBodyHP/1000),0,0,0,100)  -- UI:body_base
				drawRct(dmg_bar_right, dmg_bar_bottom, dmg_bar_width,-(dmg_bar_height * ((1000 - VehBodyHP) / 1000)),255,0,0,100)  -- UI:body_damage

				if (VehEngineHP >= 750) and (VehEngineHP < 850) then
					drawRct(dmg_bar_left, dmg_bar_top, dmg_bar_width, dmg_bar_height * ((VehEngineHP - 750) / 250),0,0,0,100) -- UI:engine_base
					drawRct(dmg_bar_left, dmg_bar_bottom, dmg_bar_width,-(dmg_bar_height * ((1000 - VehEngineHP) / 250)),255,0,0,100) -- UI:engine_damage
					--drawTxt(UI.x + 0.563, 	UI.y + 1.2624, 1.0,1.0,0.55, "~y~" .. math.ceil(speed) .. " mph", 240, 200, 80, 255)
					--drawTxt(UI.x + 0.52, UI.y + 1.266, 1.0,1.0,0.45, "~y~" .. currentTime, 240, 200, 80, 255)
					--drawTxt(UI.x + 0.619, UI.y + 1.266, 1.0,1.0,0.45, "~y~" .. math.ceil(fuelAmmount).." Fuel", 240, 200, 80, 255)
				elseif VehEngineHP < 750 then
					drawRct(dmg_bar_left, dmg_bar_bottom, dmg_bar_width,-(dmg_bar_height),255,0,0,100) -- UI:engine_damage
					drawRct(UI.x + 0.159, UI.y + 0.809, 0.005, 0,0,0,0,100)  -- panel damage
					--drawTxt(UI.x + 0.563, 	UI.y + 1.2624, 1.0,1.0,0.55, "~r~" .. math.ceil(speed) .. " mph", 240, 200, 80, 255)
					--drawTxt(UI.x + 0.52, UI.y + 1.266, 1.0,1.0,0.45, "~r~" .. currentTime, 240, 200, 80, 255)
					--drawTxt(UI.x + 0.619, UI.y + 1.266, 1.0,1.0,0.45, "~r~" .. math.ceil(fuelAmmount).." Fuel", 240, 200, 80, 255)
				else
					drawRct(dmg_bar_left, dmg_bar_top, dmg_bar_width, dmg_bar_height * ((VehEngineHP - 750) / 250),0,0,0,100) -- UI:engine_base
					drawRct(dmg_bar_left, dmg_bar_bottom, dmg_bar_width,-(dmg_bar_height * ((1000 - VehEngineHP) / 250)),255,0,0,100) -- UI:engine_damage
					--drawTxt(UI.x + 0.563, 	UI.y + 1.2624, 1.0,1.0,0.55, "~w~" .. math.ceil(speed) .. " mph", 240, 200, 80, 255)
					--drawTxt(UI.x + 0.52, UI.y + 1.266, 1.0,1.0,0.45, "~w~" .. currentTime, 240, 200, 80, 255)
					--drawTxt(UI.x + 0.619, UI.y + 1.266, 1.0,1.0,0.45, "~w~" .. math.ceil(fuelAmmount).." Fuel", 240, 200, 80, 255)
				end
				drawTxt(UI.x + 0.563, 	UI.y + 1.2624, 1.0,1.0,0.55, "~w~" .. math.ceil(speed) .. " mph", 240, 200, 80, 255)


				if HUD.ParkIndicator then
					drawRct(UI.x + 0.159, UI.y + 0.768, 0.0122, 0.038, 0,0,0,150)
					if VehStopped then
						drawTxt(UI.x + 0.6605, UI.y + 1.262, 1.0,1.0,0.6, "~r~P", 255, 255, 255, 200)
					else
						drawTxt(UI.x + 0.6605, UI.y + 1.262, 1.0,1.0,0.6, "P", 255, 255, 255, 150)
					end
				end


				if DoesEntityExist(veh) and (IsThisModelAHeli(GetEntityModel(veh)) or IsThisModelAPlane(GetEntityModel(veh))) then
					local altitude = GetEntityHeightAboveGround(GetPlayerPed(-1))
					--drawRct(UI.x + 0.124, 	UI.y + 0.932, 0.032,0.03,0,0,0,150) -- Altitude panel
					if(altitude < 200)then
						drawTxt(UI.x + 0.619, UI.y + 1.266, 1.0,1.0,0.45, "~r~" .. math.ceil(altitude).." ~w~m", 240, 200, 80, 255)
					else
						drawTxt(UI.x + 0.619, UI.y + 1.266, 1.0,1.0,0.45, "~w~" .. math.ceil(altitude).." ~w~m", 240, 200, 80, 255)
					end
				end


				if HUD.FuelIndicator then
					drawRct(UI.x + 0.12, 	UI.y + 0.932, 0.036,0.03,0,0,0,150) -- Fuel panel
					drawTxt(UI.x + 0.621, 	UI.y + 1.427, 1.0,1.0,0.45 , "~w~" .. math.ceil(fuelAmmount), 255, 255, 255, 255)
					drawTxt(UI.x + 0.633, 	UI.y + 1.427, 1.0,1.0,0.45, "~w~ Fuel", 255, 255, 255, 255)
				end
			end
		end
	end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

RegisterNetEvent("carhud:updateFuel")
AddEventHandler("carhud:updateFuel", function(fuel)
	fuelAmmount = fuel
end)

RegisterNetEvent('camera:hideUI')
AddEventHandler('camera:hideUI', function(toggle)
  if toggle ~= nil then
    showUI = toggle
  end
end)
