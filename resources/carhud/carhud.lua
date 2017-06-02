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
    DrawText(x - width/2, (y - 0.01)- height/2 + 0.005)
end

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, (y - 0.01) + height/2, width, height, r, g, b, a)
end

Citizen.CreateThread(function()
	while true do
	
		Citizen.Wait(1)
		local get_ped = GetPlayerPed(-1) -- current ped
		local get_ped_veh = GetVehiclePedIsIn(GetPlayerPed(-1),false) -- Current Vehicle ped is in
		local plate_veh = GetVehicleNumberPlateText(get_ped_veh) -- Vehicle Plate
		local veh_stop = IsVehicleStopped(get_ped_veh) -- Parked or not
		local veh_engine_health = GetVehicleEngineHealth(get_ped_veh) -- Vehicle Engine Damage 
		local veh_body_health = GetVehicleBodyHealth(get_ped_veh)
		local veh_burnout = IsVehicleInBurnout(get_ped_veh) -- Vehicle Burnout


		if(IsPedInAnyVehicle(GetPlayerPed(-1), false))then			
			
			----Area above map ----
			drawRct(0.028, 0.777, 0.029, 0.02, 0,0,0,150)          -- UI: DSC Background
			drawRct(0.1131, 0.777, 0.029, 0.02, 0,0,0,150)         -- UI: Fluid Background
			drawRct(0.143, 0.777, 0.013, 0.028, 0,0,0,150)       -- UI: AC Background
			drawRct(0.014, 0.777, 0.013, 0.028, 0,0,0,150)         -- UI: Oil
			drawRct(0.0625, 0.768, 0.045, 0.037, 0,0,0,150)        -- UI: Plate Background
			drawRct(0.014, 0.768, 0.043, 0.007, 0,0,0,150)         -- UI: Top left style
			drawRct(0.1131, 0.768, 0.043, 0.007, 0,0,0,150)        -- UI: Top Right style
			drawRct(0.1125, 0.798, 0.0296, 0.007, 0,0,0,150)        -- UI: Bottom right style
			drawRct(0.0279, 0.798, 0.0293, 0.007, 0,0,0,150)       -- UI: Bottom left style
			drawRct(0.0575, 0.768, 0.004, 0.037, 0,0,0,150)        -- UI: Left mid style	
			drawRct(0.1085, 0.768, 0.004, 0.037, 0,0,0,150)        -- UI: Right mid style
			drawTxt(0.567, 1.269, 1.0,1.0,0.45, "~w~" .. plate_veh, 255, 255, 255, 255) -- TXT: Plate	
			drawRct(0.159, 0.768, 0.0122, 0.038, 0,0,0,150)        -- UI: P Background
			
			if veh_burnout then
				drawTxt(0.535, 1.266, 1.0,1.0,0.44, "~r~DSC", 255, 255, 255, 200) -- TXT: DSC {veh_burnout}
			else
				drawTxt(0.535, 1.266, 1.0,1.0,0.44, "DSC", 255, 255, 255, 150)
			end		
				
			local dmg_bar_left = 0.159
			local dmg_bar_right = 0.1661
			local dmg_bar_top =  0.809
			local dmg_bar_bottom = 0.988
			local dmg_bar_height = dmg_bar_bottom - dmg_bar_top
			local dmg_bar_width = 0.005
			
			drawRct(dmg_bar_right, dmg_bar_top, dmg_bar_width,dmg_bar_height * (veh_body_health/1000),0,0,0,100)  -- UI:body_base
			drawRct(dmg_bar_right, dmg_bar_bottom, dmg_bar_width,-(dmg_bar_height * ((1000 - veh_body_health) / 1000)),255,0,0,100)  -- UI:body_damage
			
			if (veh_engine_health >= 750) and (veh_engine_health < 850) then
				drawRct(dmg_bar_left, dmg_bar_top, dmg_bar_width, dmg_bar_height * ((veh_engine_health - 750) / 250),0,0,0,100) -- UI:engine_base
				drawRct(dmg_bar_left, dmg_bar_bottom, dmg_bar_width,-(dmg_bar_height * ((1000 - veh_engine_health) / 250)),255,0,0,100) -- UI:engine_damage 
				drawTxt(0.619, 1.266, 1.0,1.0,0.45, "~y~Fluid", 255, 255, 255, 200) -- TXT: Fluid
				drawTxt(0.514, 1.269, 1.0,1.0,0.45, "~w~~y~Oil", 255, 255, 255, 200) -- TXT: Oil
				drawTxt(0.645, 1.269, 1.0,1.0,0.45, "~y~AC", 255, 255, 255, 200)
			elseif veh_engine_health < 750 then 
				drawRct(dmg_bar_left, dmg_bar_bottom, dmg_bar_width,-(dmg_bar_height),255,0,0,100) -- UI:engine_damage 
				drawTxt(0.645, 1.270, 1.0,1.0,0.45, "~r~AC", 255, 255, 255, 200)
				drawTxt(0.619, 1.266, 1.0,1.0,0.45, "~r~Fluid", 255, 255, 255, 200) -- TXT: Fluid
				drawTxt(0.514, 1.269, 1.0,1.0,0.45, "~w~~r~Oil", 255, 255, 255, 200) -- TXT: Oil
				drawTxt(0.645, 1.269, 1.0,1.0,0.45, "~r~AC", 255, 255, 255, 200)
			else
				drawRct(dmg_bar_left, dmg_bar_top, dmg_bar_width, dmg_bar_height * ((veh_engine_health - 750) / 250),0,0,0,100) -- UI:engine_base
				drawRct(dmg_bar_left, dmg_bar_bottom, dmg_bar_width,-(dmg_bar_height * ((1000 - veh_engine_health) / 250)),255,0,0,100) -- UI:engine_damage 
				drawTxt(0.619, 1.266, 1.0,1.0,0.45, "Fluid", 255, 255, 255, 150) -- TXT: Fluid
				drawTxt(0.514, 1.269, 1.0,1.0,0.45, "Oil", 255, 255, 255, 150) -- TXT: Oil
				drawTxt(0.645, 1.269, 1.0,1.0,0.45, "~w~AC", 255, 255, 255, 150)
			end	
			
			if veh_stop then
				drawTxt(0.6605, 1.262, 1.0,1.0,0.6, "~r~P", 255, 255, 255, 200)
			else
				drawTxt(0.6605, 1.262, 1.0,1.0,0.6, "P", 255, 255, 255, 150)
			end
		end		
	end
end)