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
	while true do
		Citizen.Wait(1)

		if showUI then
			local MyPed = GetPlayerPed(-1)

			if(IsPedInAnyVehicle(MyPed, -1))then

				local MyPedVeh = GetVehiclePedIsIn(MyPed,false)
				local VehStopped = IsVehicleStopped(MyPedVeh)
				local VehEngineHP = GetVehicleEngineHealth(MyPedVeh)
				local VehBodyHP = GetVehicleBodyHealth(MyPedVeh)

				local dmg_bar_left = 0.159
				local dmg_bar_right = 0.1661
				local dmg_bar_top =  0.809
				local dmg_bar_bottom = 0.988
				local dmg_bar_height = dmg_bar_bottom - dmg_bar_top
				local dmg_bar_width = 0.005

				local speed = GetEntitySpeed(MyPedVeh) * 2.236936

				drawRct(dmg_bar_right, dmg_bar_top, dmg_bar_width,dmg_bar_height * (VehBodyHP/1000),0,0,0,100)  -- UI:body_base
				drawRct(dmg_bar_right, dmg_bar_bottom, dmg_bar_width,-(dmg_bar_height * ((1000 - VehBodyHP) / 1000)),255,0,0,100)  -- UI:body_damage

				if (VehEngineHP >= 750) and (VehEngineHP < 850) then
					drawRct(dmg_bar_left, dmg_bar_top, dmg_bar_width, dmg_bar_height * ((VehEngineHP - 750) / 250),0,0,0,100) -- UI:engine_base
					drawRct(dmg_bar_left, dmg_bar_bottom, dmg_bar_width,-(dmg_bar_height * ((1000 - VehEngineHP) / 250)),255,0,0,100) -- UI:engine_damage
				elseif VehEngineHP < 750 then
					drawRct(dmg_bar_left, dmg_bar_bottom, dmg_bar_width,-(dmg_bar_height),255,0,0,100) -- UI:engine_damage
					drawRct(UI.x + 0.159, UI.y + 0.809, 0.005, 0,0,0,0,100)  -- panel damage
				else
					drawRct(dmg_bar_left, dmg_bar_top, dmg_bar_width, dmg_bar_height * ((VehEngineHP - 750) / 250),0,0,0,100) -- UI:engine_base
					drawRct(dmg_bar_left, dmg_bar_bottom, dmg_bar_width,-(dmg_bar_height * ((1000 - VehEngineHP) / 250)),255,0,0,100) -- UI:engine_damage
				end
				drawTxt(UI.x + 0.563, 	UI.y + 1.2624, 1.0,1.0,0.55, "~w~" .. math.ceil(speed) .. " mph", 240, 200, 80, 255)

				if IsPedInAnyHeli(MyPed) or IsPedInAnyPlane(MyPed) then
					local altitude = GetEntityHeightAboveGround(MyPed)
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
